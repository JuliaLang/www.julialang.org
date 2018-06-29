---
layout: default
title:  General Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

## Calling Julia from Python

Julia could be a great replacement for C in Python projects, where it can be used to speed up bottlenecks without sacrificing ease of use. However, while the basic functionality for communicating with Julia exists in [PyCall.jl](https://github.com/JuliaPy/PyCall.jl) and [pyjulia](https://github.com/jakebolewski/pyjulia), it needs to be separated out and maintained as a real Python package.

**Expected Results**: An easy-to-use Python package which allows Julia functions to be imported and called, with transparent conversion of data.

**Recommended skills**: Familiarity with both Python and Julia, especially C interop.

**Mentors**: [Steven Johnson](https://github.com/stevengj)

## Calling Julia shared libraries from Python

Similar to the above, but involving [PackageCompiler](https://github.com/JuliaLang/PackageCompiler.jl) to remove JIT overhead.
The successful candidate will start off from the [prototype](https://github.com/JuliaLang/PackageCompiler.jl/pull/26)
and will make sure that linking a shared Julia library to Python works on all platforms.
If there is still time after this, the project can be extended to make the interaction
between Python and Julia work smoothly.
We will need to make sure that all functions can be called with rich
python datatypes, and that conversions to common Julia datatypes happens automatically.
If the conversion can't happen automatically, we need to make sure that there are easy ways
to convert a Python object to the correct Julia object.

**Recommended skills**: This project will require strong knowledge about compiling and linking binaries.
**Expected Results**: An easy way to call into static julia libraries without JIT overhead and with automatic type conversions.

**Mentors**: [Simon Danisch](https://github.com/SimonDanisch/)

## Middlewares for common web application chores in Mux.jl

Implementation of mid-level features - specifically routing, load-balancing, cookie/session handling, and authentication - in [Mux.jl](https://github.com/JuliaWeb/Mux.jl).  The implementation should be extensible enough to allow easy interfacing with different kinds of caching, databases or authentication backends. (See [Clojure/Ring](https://github.com/ring-clojure/ring/wiki/Why-Use-Ring%3F) for inspiration).

**Expected Results**: Improvements to the Mux.jl package.

**Required Skills**: Experience with web development.

**Recommended Skills**: Knowledge of various web frameworks, especially the design decisions and tradeoffs behind them.

**Mentors**: [Mike Innes](https://github.com/MikeInnes)

## WebAssembly

[WebAssembly](http://webassembly.org/) is a new standard for running compiled code in a web browser. If Julia can generate WebAssembly, it opens up many opportunities to embed Julia "apps" in web interfaces. Julia is well positioned here because Julia can already compile efficient LLVM bitcode. LLVM bitcode can be translated into WebAssembly by [Emscripten](http://emscripten.org/) or with a direct LLVM [backend](https://github.com/llvm-mirror/llvm/tree/master/lib/Target/WebAssembly).

The two most promising approaches to generate WebAssembly are outlined as follows.

1. **Extended CUDAnative approach** –  The experimental [ExportWebAssembly package](https://github.com/tshort/ExportWebAssembly.jl/) uses code from the [CUDAnative package](https://github.com/JuliaGPU/CUDAnative.jl) to produce LLVM bitcode on the fly. It works great for simple code (type stable code with no use of libjulia or other C functions). Math code that uses immutable structs and/or StaticArrays works well with this approach. The main downside is that it is so limited–-no arrays, no strings, no IO, etc. The main work with this approach is to substitute out libjulia-type functions with equivalents that work in JavaScript/WebAssembly. For example, [this](https://github.com/tshort/ExportWebAssembly.jl/blob/master/examples/crude-array.jl) crude example shows a custom array type that could work with WebAssembly. The main steps in this approach are: (1) write a package to create WebAssembly-friendly versions of basic Julia types and operations (Dicts, Strings, Arrays, and printing) and (2) use the [Cassette package](https://github.com/jrevels/Cassette.jl) or another approach to replace standard Julia dispatches involving these basic types with the WebAssembly-friendly versions.

2. **[CodeGen.jl](https://github.com/tshort/CodeGen.jl) approach** – This package uses the [LLVM package](https://github.com/maleadt/LLVM.jl) to directly generate bitcode based on code_typed Julia code. There is a branch of [ExportWebAssembly](https://github.com/tshort/ExportWebAssembly.jl/tree/codegen-jl) that uses this. This can use libjulia functions (also compiled to LLVM bitcode), so a wider range of Julia code may work. Some decently complex code runs, including some simple array creation and manipulation. But, there are still many gaps that need to be filled in here to be able to run Julia code in general. The main work with this approach is in upgrading the CodeGen package to support more Julia code. This method offers the most control over code generation and may allow the widest Julia code coverage (including code that links to C and Fortran libraries).

**Expected Results**: An upgraded version of the ExportWebAssembly package that supports a wider range of Julia code.

**Recommended skills**: Familiarity with (or willingness to learn) LLVM IR helps when interpreting Julia output before it is converted to WebAssembly; for the CodeGen approach, familiarity with C++ helps to interpret the C++ code in Julia that does code generation

**Mentors**: [Tom Short](https://github.com/tshort)


## Improve IR transformation API + 0.7 support for Sugar

Improve the new [MacroTools](https://github.com/MikeInnes/MacroTools.jl/) based IR rewriting capabilities in [Sugar.jl](https://github.com/SimonDanisch/Sugar.jl).

There are 2 ways to match IR and rewrite the matching expressions in Sugar right now:

1) match with function, e.g. rewrite all expressions for which is_goto(::Expr)::Bool returns true.

2) MacroTools based form, which uses [Julia expressions](https://github.com/SimonDanisch/Sugar.jl/blob/sd/07/src/patterns.jl#L175) to define what to match

Those capabilities are already fairly evolved on the branch [sd/07](https://github.com/SimonDanisch/Sugar.jl/tree/sd/07),
but they need thorough tests.
After making sure they work reliably, the project will be about refactoring Sugar
to use the new infrastructure to offer generic passes over the Julia IR, to e.g.
remove goto labels and replace them by the correct control flow statements,
passes for boundcheck elimination, or simple passes to replace a set of functions.

**Expected Results**: Release a new version of Sugar including 0.7 compatibility and the new API

**Recommended skills**: Knowledge of Julia's AST, IR and MacroTools would be great

**Mentors**: [Simon Danisch](https://github.com/SimonDanisch/)

## Minecraft Examples for Julia on the Raspberry Pi

Minecraft is, by some measures, the most popular video game ever. On the Raspberry Pi, the Minecraft
world can be programatically controlled. This provides an incredible platform to teach children to code -- 
an unique combination of the physical and the virtual. 

This project will aim to create content in the form of example programs that showcase using Julia on the Pi 
to control Minecraft. Some inspiration might be derived from a [similar book in R](https://github.com/ropenscilabs/miner_book). 
This code will use the [PiCraft.jl](https://github.com/JuliaBerry/PiCraft.jl) Julia package which provides the infrastructure to 
connect to Minecraft on the Pi. 

**Expected Results**: A set of example programs with documentation

**Recommended skills**: Basic Julia programming skills, some familiarity with R *or* Python. Access to a Rasberry Pi will be helpful. 

**Mentors**: [Avik Sengupta](https://github.com/aviks/)

## Liquid Templating Library

[Liquid](http://shopify.github.io/liquid/) is a popular templating library, used primarily from Ruby. A pure Julia implementation
of Liquid would be useful for web application authors in Julia. 

**Expected Results**: A pure Julia package that can compile a liquid template to Julia code. 

**Recommended skills**: Basic Julia programming skills. Familiarity with parsing techniques.  

**Mentors**: [Avik Sengupta](https://github.com/aviks/)

## Enhanced clipboard

Julia's functions for getting and setting the clipboard are currently limited to text; it would be useful to extend them to allow the transfer of other data (for example, spreadsheet data or images).

**Expected Results**: Extensible `clipboard()` and `clipboard(x)` functions to get and set the richest possible representation of the system clipboard data, as well as methods for specific types.

**Recommended skills**: Interfacing with C from Julia, clipboard APIs for different platforms. Familiarity with FileIO.jl.

**Mentors**: [Stefan Karpinski](https://github.com/StefanKarpinski)

## QML.jl Improvements

The [QML.jl](https://github.com/barche/QML.jl) package provides Julia bindings for [Qt QML](http://doc.qt.io/qt-5/qtqml-index.html) on Windows, OS X and Linux. In the current state, basic functionality is available, but there is room for improvement regarding integration with [GLVisualize](https://github.com/JuliaGL/GLVisualize.jl) and plotting packages such as [GR](https://github.com/jheinen/GR.jl) (see also [issue 23](https://github.com/barche/QML.jl/issues/23)) or [Plots](https://github.com/JuliaPlots/Plots.jl). Another area of work is supporting more elaborate data models.

**Expected Results**: Improvements to the QML.jl package along one of these lines.

**Recommended Skills**: Familiarity with both Julia and the QT framework.

**Mentors**: [Bart Janssens](https://github.com/barche)

## Data Structure Algorithm Improvements

While many common data structures are encouraged to be implemented in packages, to encourage more experimentation, some are so basic they need to be in Base. There are a number of projects that could be done to improve the quality, performance, or usability of these builtin structures. Some ideas include:

- Changing Base.Dict to an ordered dict representation (http://juliacollections.github.io/DataStructures.jl/latest/ordered_containers.html, https://github.com/JuliaLang/julia/pull/10116)
- Experiment with using alternative Dict hash structures (such as Robin Hood Hashing, used by [Rust](https://doc.rust-lang.org/beta/std/collections/struct.HashMap.html))
- Implementation and tests for assorted asynchronous, threaded storage primitives and data channels

**Recommended Skills**: Ability to write type-stable Julia code. Ability to find performance issues. Knowledge about data structures and related algorithms.

**Mentors:** [Jameson Nash](https://github.com/vtjnash)
