@def title = "Julia 1.5 Highlights"
@def authors = "Jeff Bezanson & Stefan Karpinski"
@def published = "3 August 2020"
@def rss_pubdate = Date(2020, 8, 3)
@def rss_description = """Julia version 1.5 has been released, featuring many performance improvements and new capabilities."""


[Julia version 1.5 has been released](https://discourse.julialang.org/t/julia-v1-5-0-has-been-released/44169).
Releases are timed and hence not planned around
specific features, but this time we seem to have gotten lucky: quite a few major
developments came together to make 1.5 particularly exciting.
Let's walk through some highlights.

\toc

## Struct layout and allocation optimizations

This release brings a major, long-desired optimization that can significantly reduce heap
allocations in some workloads. To understand it, it helps to know a bit about Julia’s object model.
Julia has both mutable and immutable kinds of objects. New record (composite) types declared with
`struct` are immutable, whereas if you want a mutable record, you have to use `mutable struct` to
declare the new type. The language automatically picks memory layouts and calling conventions for
each type, generally trying to be compatible with C/C++. In general, a mutable object must exist in
a single location on the heap, so mutable objects will be stored and passed by reference (unless the
compiler can prove that it won’t matter). Immutable objects, on the other hand, give the compiler
much greater flexibility. For example, an immutable struct containing two values could be passed to
a function by reference just like a mutable struct with the same fields, but it can also be passed
just by passing those two values in registers—because there’s no memory location that needs to be
kept in sync with the values since regardless of where they came from, they cannot be modified.

Prior to this release, layout optimizations for immutable objects had a significant limitation: if an
immutable object pointed to a heap-allocated, mutable object, it would itself need to be heap-allocated.
That was an artifact of how the garbage collector and code generator worked: it was simpler for there
to be a one-to-one correspondence between object fields and GC roots. For 1.5, Jameson Nash did a
[redesign](https://github.com/JuliaLang/julia/pull/33886) to fix this, allowing the compiler to track
multiple roots inside object fields.

As a result of this work, arbitrary immutable objects—regardless of whether they have fields that
reference mutable objects or not—can now be stack allocated, passed and returned by value, and stored
inline in arrays and other objects. In short, immutable structs that refer to mutable values are now
just as efficient as immutable structs that only refer to other immutable objects.
(There are some size-based limits to which structs can be stack allocated, but they are unlikely
to be exceeded in practice.)

This is a big deal because many important abstractions can only be implemented by wrapping mutable
objects in structs. The classic example in Julia is array "views" (the `SubArray` type), which wrap
mutable arrays together with some metadata about how to translate indices into the view into indices
into the original array. The purpose of a view is to be able to pass part of an array to a function
without copying it. However, if the view object itself needs to be heap allocated, we find ourselves
in the unfortunate situation where using views to eliminate allocation itself causes allocation: in
previous Julia versions, you had to choose between copying array slices or using views but having to
allocate view objects. Even though view objects are small and relatively cheap to allocate, any
amount of allocation can inhibit optimizations and trigger garbage collection, both of which can be
painful in performance-critical code. Eliminating this allocation has been sufficiently important for
some users that the [UnsafeArrays](https://github.com/JuliaArrays/UnsafeArrays.jl) package exists
solely to allow creating views without allocating.

In 1.5 this difficult choice goes away: using views no longer forces allocation. This means that
`UnsafeArrays` is no longer necessary in the vast majority of cases. Needless to say, removing the
need for elaborate performance workarounds is always one of the highest aspirations of a compiler
developer. To see this in action, here is a simple function for summing n x n neighborhoods of a
matrix:

```
function sum_neighborhoods(A, n::Int)
    return [ sum(@view A[i:i+n-1, j:j+n-1]) for i = 1:n:size(A,1), j = 1:n:size(A,2) ]
end
```

Note this uses the `@view` macro to create an in-place view of each n x n region. We can use the
BenchmarkTools package to check its resource usage. Here are the results in Julia v1.4:

```
julia> using BenchmarkTools

julia> x = rand(1000, 1000);

julia> @benchmark sum_neighborhoods($x, 2)
BenchmarkTools.Trial:
  memory estimate:  17.17 MiB
  allocs estimate:  250004
  --------------
  minimum time:     4.510 ms (0.00% GC)
  median time:      5.320 ms (0.00% GC)
  mean time:        5.411 ms (5.25% GC)
  maximum time:     11.100 ms (11.41% GC)
  --------------
  samples:          923
  evals/sample:     1
```

Here are the results in v1.5:

```
julia> @benchmark sum_neighborhoods($x, 2)
BenchmarkTools.Trial:
  memory estimate:  1.91 MiB
  allocs estimate:  2
  --------------
  minimum time:     3.479 ms (0.00% GC)
  median time:      4.007 ms (0.00% GC)
  mean time:        4.297 ms (2.03% GC)
  maximum time:     8.191 ms (29.20% GC)
  --------------
  samples:          1164
  evals/sample:     1
```

The speedup is actually not that large, which is a testament to the fact that Julia's allocator is
very efficient, but note the difference in allocations: 250004 on 1.4 versus 2 on 1.5. The
difference is all those view objects which don't need to heap allocated anymore.

We would like to thank [RelationalAI](https://relational.ai/) for sponsoring this work.

## Multithreading API stabilization & improvements

Improving support for parallelism is a major focus of ongoing work. Threading was introduced as an
experimental feature way back in v0.5, and since then nearly every release has increased thread safety
and added new features. In particular, 1.3 was a major milestone release for threading because it
[introduced](https://julialang.org/blog/2019/07/multithreading/) the `@spawn` construct (along with
all the supporting infrastructure) for composable multithreading, a la Go’s "goroutines", but with a
focus on high-performance computing.

Many Julia programmers are using threads at this point, and major performance wins like multithreaded
[CSV parsing](https://github.com/JuliaData/CSV.jl) have emerged. As a result we felt the "experimental"
label was no longer really appropriate, and in this release we are marking most of the thread API as
stable. We explicitly documented the remaining limitations and the parts of the API that may still
change. Here is a brief overview of thread-related work that has gone into this release:

- Improved thread-safety of some top level expressions: type definitions, global assignments, modules
- Made `@sync` thread-safe
- Made the SuiteSparse bindings thread-safe
- Improvements to task switch performance
- New `@threads :static` syntax to request the current default threaded loop schedule, allowing us to change the default schedule in the future
- The `-t` command line option for specifying the number of threads to use
- A `lock=false` option to `open` for faster single-thread access to files

We're very much looking forward to more performance wins in the ecosystem as developers start taking advantage of the stability of the threading API.

## Per-module optimization levels

Being a greedy language, we often try to have things both ways. That isn't always easy, and the
trade-off between compilation time and run-time performance has been a particular source of
frustration. To provide a good initial user experience, the default optimization level we use is
`-O2`, which is roughly similar to the `-O2` option in `gcc` or `clang`. That's great for compute
kernels and benchmarks, but not all code is performance-critical, and Julia users are loading more
and larger packages for plotting and other "non-inner-loop" support tasks all the time. To help
reduce compilation delays for such packages, it is now possible to provide an optimization level
hint in each module. For example, Plots.jl specifies `@optlevel 1`, indicating that it wants to use
the `-O1` optimization level, rather than the default `-O2`.
This cuts the time-to-first-plot by about a third.

## Other latency improvements

In addition to `@optlevel`, we have been chipping away at other compiler performance issues — sometimes
big improvements come just one or two percent at a time. Browsing through
[the "latency" label](https://github.com/JuliaLang/julia/pulls?q=is%3Apr+label%3Alatency) on github
gives some idea of what is involved. The net effect of this work is that, moving from version 1.4
to 1.5, the time to load the Plots.jl package (`using Plots`) goes from 9.8 seconds to 6.1 seconds
(38% faster), and the time to generate the first plot goes from 11.7 seconds to 7.8 seconds (33% faster).
Your mileage may vary of course — performance is always highly dependent on the system hardware and
configuration.
But in general, this release improves compiler latency by a considerable margin over 1.4, which was already snappier than earlier releases.

## Implicit keyword argument values

When passing a keyword argument, or constructing a named tuple, it's quite common for the value to
be held in a variable with the same name as the argument or field name. For example, if you are
printing colored text and have the color to use in a variable called `color`, you need to write
`printstyled("text", color=color)`. Typing the same words twice all the time can get tedious,
especially when delegating several keyword arguments to another function. This release adds a
convenient shorthand that has already become popular in several other languages (such as
TypeScript):

- `printstyled("text"; color)` is an abbreviation for
- `printstyled("text"; color = color)`.

Note the semicolon before the `color` argument: this is necessary for Julia to distinguish this
shorthand syntax from passing `color` as a second positional argument. A similar shorthand works for
named tuples:

- `(; name, value, type)` is shorthand for
- `(name = name, value = value, type = type)`.

These shorthands also work when the value being passed is a field in a structure with the same name as the keyword argument (or anything else that uses `object.field` syntax):

- `printstyled("text"; opts.color)` is shorthand for
- `printstyled("text"; color = opts.color)`.

Although this change doesn't allow programmers to _do_ anything they couldn't do before, it makes
writing code that works with keyword arguments and named tuples a lot more pleasant, concise and
readable.

## The return of "soft scope" in the REPL

Variable scope is a surprisingly rich source of design conundrums in programming languages.
For the most part, dividing a program into many nested scopes is a great thing: it aids in local
reasoning about what code means, it enables optimizations, and it prevents changes in one section
of code from accidentally breaking distant, unrelated code. All good features for "programming in the
large". But for quick, experimental programming it is tedious to worry about the lifetime of every
variable, and in particular, the safe default of making things local rather than global can sometimes
be confusing and inconvenient when working interactively.

In 0.x versions of Julia, we did some clever "guessing" about when users wanted a variable to be local
or global. The basic rule was that inside of a loop but outside of any function body—in a so-called
"soft scope"—when the user assigned to a variable, if there was already a global by that name, it was
assigned, but if there wasn't a global by that name, then the assignment would create a new variable
local to the loop. This was a really effective heuristic and approximates what happens inside of function
bodies as closely as possible in global scope. However, there were some issues: some people found it
confusing and inconsistent, and it made it impossible to statically determine the meaning of code since
whether a global by a given name exists or not cannot be statically determined in a dynamic language like
Julia. So for the 1.0 release of Julia, we simplified the rules: no more guessing what the user meant: if
you assign to a variable in a local scope (function or loop) and there's no local by that name, then that
assignment creates a new local variable. Period. End of story, dead simple rule.

Despite the "on paper" simplicity of the 1.0 scope rule, many people found it unintuitive and annoying.
Consider the following example:

```
s = 0
for i = 1:10
    s = s + i
end
println(s)
```

One would naively guess that this prints the number `55`, and prior to Julia 1.0 that's exactly what
it did. But in 1.0, we consistently made `for` loops introduce new local scopes, which means that this
code would throw an undefined variable error because `s` is deemed to be local to the loop: since there
is no pre-existing local `s` (only a global `s`) and `s` is assigned in the loop, it is local and the
first iteration of the loop tries to access an undefined local `s`.

In a long top-level script where you may not realize you are overwriting a global variable used in a
different part of the file, this default assumption of localness can be better (indeed, many bugs were
uncovered when we changed the behavior for 1.0), but for interactive use, this is decidedly unfriendly.
It is also a pain when using the REPL to debug: code that works in a function body doesn't work the
same way in the REPL without extra `global` annotations.

This was enough of an issue—especially for new users—that the developers of
[IJulia](https://github.com/JuliaLang/IJulia.jl) took matters into their own hands and added code to
rewrite inputs in a way that restores the old pre-1.0 scope behavior. Having the commonly-used Jupyter
front-end behave differently than the default REPL is not a good situation, so we had to do something.

After a lengthy discussion and several designs considered and prototyped, we settled on the following
solution in v1.5:

- Make the REPL behave like IJulia, and Julia versions 0.6 or earlier.
- Keep the 1.0 behavior in files, to avoid breaking anybody's code.
- Print a warning if code in a file would behave differently than in the REPL, requesting an explicit
  `local` or `global` declaration to disambiguate the variable in the loop.

We feel this is the best that can be done without making breaking changes. Arguably, it's the best
that can be done even allowing breaking changes, without radically changing the way scopes or variable
declarations work. It has several desirable properties:

- Code works as expected by new users in the REPL and in notebooks.
- You can cut and paste code between function bodies and the REPL for debugging.
- In files, where accidentally clobbering a global by assigning to it inside of a local scope is a real
  problem, you get a clear warning, prompting you to clarify whether the clobbering is intentional.

This change fixes a common stumbling block for new Julia users and an annoyance for regular users who
like to use the REPL for debugging, while not sacrificing the suitability of the language for reliable
programming at scale.

## New `@ccall` macro

Julia has long had a capable and widely-used interface for calling C functions. While the functionality
is fine, some greedy programmers (our favorite kind) pointed out that the syntax is less than
beautiful: a C call does not look much like an ordinary function call. For example, a call to `strlen`
looks like this:

```
ccall(:strlen, Csize_t, (Cstring,), "hello")
```

For 1.5, Aaron Christianson [implemented](https://github.com/JuliaLang/julia/pull/32748) a macro providing
nicer syntax:

```
@ccall strlen("hello"::Cstring)::Csize_t
```

Ah — now it looks like a call to `strlen`, with types specified using natural Julian syntax.

## Faster random numbers

Julia excels at simulations, so random numbers are important to a lot of users of the language. For
this release [Rafael Fourquet](https://github.com/rfourquet), one of the primary architects of the
`Random` standard library and a prolific contributor in general, implemented some impressive
algorithmic improvements for some popular cases. The first is a major improvement when generating
normally-distributed double-precision floats.
Calling `randn(1000)` is nearly twice as fast in Julia 1.5 compared with Julia 1.4.
Generating random booleans also got **much** faster: `rand(Bool, 1000)` is nearly 6x faster.
Finally, sampling from discrete collections has also gotten faster: `rand(1:100, 1000)` got 25% faster.

## Automated rr-based bug reports

There is a new command-line option `--bug-report=rr` which makes it trivially easy to record
and upload [rr](https://rr-project.org/) traces to aid in fixing bugs.
This feature is described in detail in [a separate blog post](https://julialang.org/blog/2020/05/rr).

## Pkg Protocol now the default

Julia ships with a built-in package manager called `Pkg`. In the past, `Pkg` has downloaded packages
directly from GitHub, GitLab, BitBucket, or wherever else they happen to be hosted. While this was a
great way to bootstrap a package ecosystem, it has a number of disadvantages:

- *Vanishing resources:* if the repo for a package goes away because the maintainer deletes it, makes it
  private, or its hosting service goes down, then nobody can install that package anymore. We want to
  insulate Julia users from getting
  "[left-padded](https://en.wikipedia.org/wiki/Npm_(software)#Notable_breakages)".

- *Lack of insight:* the Julia project has no idea what packages are installed a lot or a little. GitHub
  et al. have this information but doesn't share it with us. It would be really beneficial to the
  community to know what packages get used the most.

- *Coupling with Git/GitHub:* if you're installing packages from git hosting services, that ties the
  package manager to that hosting service's API and/or the git protocol. There's nothing
  inherently requiring Julia packages to be developed with git or served by git hosting services.

- *Firewall problems:* A lot of organizations with firewalls block git and/or ssh. It's not uncommon
  to block access to code hosting services since IT may need control over what software people use.
  Having a single server as the sole point-of-contact for installing Julia packages and using a standard
  protocol like HTTPS would alleviate firewall problems considerably. Even better if it was trivial
  to set up a caching proxy server inside the firewall.

- *Performance:* while downloading packages from GitHub may work great in North America, it's not so fast
  in the rest of the world. We've heard of Pkg operations taking tens of minutes for users in China and
  Australia. We want Julia users _everywhere_ to have a great experience installing packages.

A new way of getting packages was introduced in Julia 1.4, known as "[the Pkg
protocol](https://github.com/JuliaLang/Pkg.jl/issues/1377)", which solves all of these issues.
Instead of downloading packages from wherever they happen to be hosted, the Pkg client connects to a
"Pkg server" using a simple HTTPS protocol to download new versions of package registries, package
tarballs and artifacts—everything that's needed to install and use packages. This protocol was
introduced in 1.4 but not used by default: we wanted to have time to test it out, make sure it was
working well, and build out the required server infrastructure. In 1.5, we've flipped the switch,
making the Pkg protocol the default way that Julia gets packages. Now by default everything is
downloaded from <https://pkg.julialang.org> (it's not a website, as the very basic landing page tells
you), which is served by a dozen pkg servers around the world, ensuring that everyone everywhere has
a great experience installing and updating Julia packages.

## Conclusion

Please enjoy the release, and as always [let us know](https://github.com/JuliaLang/julia/issues)
if you encounter any problems or have any suggestions.
We hope to be back in about four months to report on even more progress in version 1.6!
