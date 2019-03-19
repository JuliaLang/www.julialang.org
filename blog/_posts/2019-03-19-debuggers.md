---
layout: post
title: "A Julia interpreter and debugger"
author: <a href="https://github.com/timholy">Tim Holy</a>
author: <a href="https://github.com/KristofferC">Kristoffer Carlsson</a>
author: <a href="https://github.com/pfitzseb">Sebastian Pfiztner</a>
author: <a href="https://github.com/Keno">Keno Fischer</a>
---

The authors are pleased to announce the immediate availability of a
debugger for the Julia programming language. The core infrastructure
is in [JuliaInterpreter][JI].  Currently there are also three separate
front-ends: a full-featured IDE in [Juno][], a REPL (console) GUI-like
mode in [Rebugger][RB], and "step/next/continue" console interface in
[Debugger][DB]. The new debugging infrastructure allows you to move
stepwise through code, but you can also set breakpoints and trap
errors. Moreover, the new debugging capabilities have been written to
integrate seamlessly with [Revise][RV], so that you can continuously
analyze and modify code in a single session.  Indeed, Revise has been
rewritten with JuliaInterpreter at its foundation, and this has given
both Revise and Rebugger powerful new capabilities. To better support
a multitude of consumers, Revise has been split into two packages, and
now offers a convenient "query" API in the [CodeTracking][CT] package
to allow other packages to ask questions about the code in your
running Julia session.

# A brief user-level introduction to the front end debuggers

To orient potential users to the debugger front-ends, here we include
a couple of screen shots that highlight the new capabilities.

## Juno


## Rebugger and Debugger

If you have a different favorite editor than Atom---or sometimes work
in remote sessions through a console interface---you can alternatively
perform debugging via the REPL.  There are two REPL interfaces:
Debugger offers a "step, next, continue" interface similar to
debuggers like `gdb`, whereas Rebugger aims to provide a console interface
that is remiscent of an IDE. Debugger has some capabilities that none
of the other interfaces offer (e.g., very fine-grained control over
stepping, the ability to execute the generator of generated functions,
etc.), so it should be your go-to choice for particularly difficult cases.

<screenshots>

Rebugger also features an "edit" interface. For more information, see
[Rebugger's documentation](https://timholy.github.io/Rebugger.jl/dev/).

# An overview of the packages

With several packages making their initial debut, and some old ones
getting new capabilities, we felt it would be appropriate to provide
an overview of the underpinnings of the new ecosystem.

## JuliaInterpreter

[JuliaInterpreter][JI] is the lynchpin of the entire stack; it
contains the logic needed to evaluate and inspect running Julia code.
An
[interpreter](https://en.wikipedia.org/wiki/Interpreter_(computing))
lends itself naturally to stepwise code evaluation and the
implementation of breakpoints.

JuliaInterpreter descended from an original package
[ASTInterpreter2](https://github.com/JuliaDebug/ASTInterpreter2.jl)
written by Keno Fischer. In its original form (prior to Jan 2019),
ASTInterpreter2 was a fairly small but sophisticated package, capable
of handling many advanced aspects of Julia's internal representation
of code.  It was in need of updating to the many changes in Julia 1.0,
although most of that work had already been done by Neethu Joy in late
2018.  When we began our own efforts, we finished the updates and
decided to extend it in many ways:

- JuliaInterpreter became recursive-by-default, interpreting calls all
  the way down to the `ccall`s, intrinsic functions, and builtin
  functions that define Julia's lowest levels.  By running virtually all code
  through the interpreter, it became more straightforward to implement
  breakpoints and trap errors.

- JuliaInterpreter received numerous performance enhancements, and now
  can run stepwise through code at roughly 50× its original speed.
  These optimizations reduce---but come nowhere close to
  eliminating---the most serious disadvantage of running all code in the
  interpreter: slow performance. It is hoped that the performance gap
  between compiled and interpreted code, which is now as high as 1000×
  in some cases, will narrow in the coming months.  However, the
  interpreter will always be slower than compiled code.

  It's also worth noting that there are cases where the interpreter
  feels faster, at least on initial execution. Julia's JIT compiler
  produces excellent results, but all that code-analysis takes time;
  there is interest in exploring whether running more code in the
  interpreter could reduce latencies, a.k.a. the "time to first plot"
  problem. JuliaInterpreter is a potential tool for exploring that
  tradeoff, and it appears that [not much additional work would be
  needed](https://github.com/JuliaDebug/JuliaInterpreter.jl/issues/44).

- JuliaInterpreter gained the ability to interpret "top-level code",
  for example the code used to define packages and create test
  suites. This was a major change, partly because top-level code uses
  an expanded vocabulary, but mostly because top-level code can define
  new modules, structures, and methods, which in turn introduces the
  need to manage "world age," the counter that determines the
  visibility of methods to callers. (If this fails, you see errors
  like "method is too new to be called...").

  Supporting top-level code allowed JuliaInterpreter to achieve two
  goals: the ability to serve as the foundation of new code-parsing
  abilities for Revise, and the ability to run test suites originally
  designed for compiled Julia code.  Once we had top-level execution
  partially working, we
  [decided](https://github.com/JuliaDebug/JuliaInterpreter.jl/issues/13)
  to evaluate JuliaInterpreter against the most extensive single test
  suite available, that of Julia itself.  This revealed dozens of bugs
  in areas like the calling of C libraries (`ccall`, `@cfunction`, and
  `cglobal`), `llvmcall`, keyword-argument functions, generated
  functions, anonymous functions, `struct` definitions, global
  variables, the handling of try/catch, locks and threads, and the
  treatment of `@eval`ed code.  Some of these problems were isolated
  for us from the test suite failures by two additional contributors,
  Gunnar Farnebäck and Don MacMillen.

  As of this writing, most of the cleanly-isolated problems have been
  fixed.  While we are still far from perfect, the pursuit of such a
  demanding goal has contributed extensively to the robustness of
  these young packages.

- JuliaInterpreter gained support for breakpoints. While not strictly
  a feature of interpreters, they are necessary to build a capable
  debugger and can be viewed as an additional form of control-flow
  within the interpreter itself. These breakpoints can be set manually
  with functions `breakpoint` and a macro `@breakpoint`, manipulated in Juno,
  Rebugger, or Debugger, or added directly to code with the `@bp` macro.
  Existing breakpoints can be `disable`d,
  `enable`d, or `remove`d.  We support setting of breakpoints at
  specific source lines or on entry to a specific method, conditional
  and unconditional breakpoints, and can automatically trap errors as
  if they were manually-set breakpoints.

To explore the interpreter in its own right, you can start like this:

```
using JuliaInterpreter
A = rand(1:10, 5)
@interpret sum(A)
```

If all is working well, you should see the same answer you get from
running `sum(A)` without `@interpret`.

## LoweredCodeUtils

[LoweredCodeUtils][LCU] is the most specialized and opaque of the new
packages.  Its purpose is to build links between multiple
cooperating methods.  For example, the seemingly-simple definition

```
mymethod(x, y=0; z="Hello", msg="world") = 1
```

actually creates 5 methods: one "body method" (here, simply returning
`1`), two "positional-argument" methods (ones that do not accept any
keyword arguments), and two "keyword function" methods (ones that get
called when you supply at least one keyword argument, then fill
in defaults and standardize order).  Because all five of these arise
from the same user-supplied expression, they need to be implicitly
linked in order to provide a satisfying user experience.  In
particular, changes to source files cause the line numbers of compiled
methods to become outdated; if we didn't correct that, Juno might open
a file to the outdated line number when stepping through
code. LoweredCodeUtils does the source-level analysis to discover
these associations and handle differences that arise when parsing the
same file multiple times.

If you ever wanted to be able to parse Julia code and extract the
signatures of the methods it defines (without redefining the methods),
LoweredCodeUtils is the package for you.

## CodeTracking

[CodeTracking][CT] was designed to act as a simple, lightweight "query
API" for retreiving data from [Revise][RV]. Essentially,
LoweredCodeUtils performs analysis, Revise manages changes that occur
over time, and CodeTracking informs the rest of the world.  For
CodeTracking to do anything interesting, you need to be running
Revise; to allow CodeTracking to be a lightweight dependency, it
relies on Revise to populate its own internal variables.

See CodeTracking's README for more information.

## Revise and Rebugger

Thanks to a rewrite based on JuliaInterpreter, Revise and Rebugger are
better (in some cases, much better) at their core tasks. In
particular, if you used an earlier version of Rebugger, you may have
noticed that it was defeated by many language constructs (e.g.,
functions containing keyword arguments, `@eval`-generated methods,
etc).  Most of the underlying causes were resolved by
LoweredCodeUtils, which is in turn used by Revise, which then feeds
the necessary data to CodeTracking for consumption by Rebugger.  As
one measure of the difference, of the more than 10,000 methods in
Base, Revise 1.1.0 fails to capture 1,425 method signatures (a failure
rate of 13%). In contrast, Revise 2.0.0 misses only 10 (<0.1%).

Consequently, in addition to the new "interpret" interface, the new
Rebugger is much better at its original "edit" interface, too.

Revise (and consequently Rebugger) has also gained some other new
abilities, like handling methods defined at the REPL.  In the longer
term, its foundation on LoweredCodeUtils may support more extensive
analysis allowing Revise to update [dependent
blocks](https://github.com/timholy/Revise.jl/issues/249).

# Summary

This has been only a high-level overview. Some of the individual packages
have extensive documentation, and interested readers are encouraged to
work through it. For anyone looking to develop a deeper understanding
of the internals of Julia's code, the new packages provide a powerful set of
tools for introspection and analysis. And of course, we hope that the
new debugging capabilities further accelerate Julia's rapid development,
and make it that much more fun of a language to use.

-----------------------

[CT]: https://github.com/timholy/CodeTracking.jl         "CodeTracking"
[DB]: https://github.com/JuliaDebug/Debugger.jl          "Debugger"
[JI]: https://github.com/JuliaDebug/JuliaInterpreter.jl  "JuliaInterpreter"
[Juno]: http://junolab.org/                              "Juno"
[LCU]: https://github.com/JuliaDebug/LoweredCodeUtils.jl "LoweredCodeUtils"
[RB]: https://github.com/timholy/Rebugger.jl             "Rebugger"
[RV]: https://github.com/timholy/Revise.jl               "Revise"
