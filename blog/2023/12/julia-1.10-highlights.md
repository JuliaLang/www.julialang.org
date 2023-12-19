+++
mintoclevel = 2
maxtoclevel = 3
title = "Julia 1.10 Highlights"
authors = "The Julia contributors"
published = "22 December 2023"
rss_pubdate = Date(2023, 12, 22)
rss = """Highlights of the Julia 1.10 release."""
+++


After X betas and X release candidates, Julia version 1.10 has finally(!) been released. We would like to thank all the contributors to this release and all the testers that helped with finding regressions and issues in the pre-releases. Without you, this release would not have been possible.

The full list of changes can be found in the [NEWS file](https://github.com/JuliaLang/julia/blob/release-1.10/NEWS.md), but here we'll give a more in-depth overview of some of the release highlights.

\toc

# New parser written in Julia

*Claire Foster*

In Julia 1.10 we have replaced Julia's default parser (written in Scheme) with one written in Julia...

# Package load time improvements

*Jameson Nash et al.*

In 1.9 the TTFX was heavily improved by allowing package authors to enable saving of native code during precompilation.

In 1.10, as a follow up, significant work was put into the performance of the loading of packages

A lot of this work was driven by profiling and improving the load time of [OmniPackage.jl](https://github.com/JuliaComputing/OmniPackage.jl) which is an artificial "mega package" which only purpose is to depend on and load a lot of dependencies.

- Improvement to the type system... (Jameson)
- Reduction of invalidations causing recompilation
- Moving packages away from Requires.jl to package extensions
- `mul!` dispatch improvements (Daniel K)

Omnipackage load times:

Julia 1.9: 48.041773 seconds (102.17 M allocations: 6.522 GiB, 5.82% gc time, 1.21% compilation time: 86% of which was recompilation)
Julia 1.10: 19.125309 seconds (30.38 M allocations: 2.011 GiB, 11.54% gc time, 10.38% compilation time: 61% of which was recompilation)

# Stacktrace rendering improvements

*Jeff Bezanson, Tim Holy*

- `Type{...}` in stacktraces
- Successive frames at identical location collapsed
- https://github.com/JuliaLang/julia/pull/49102


# Parallel GC

*Diogo Netto*

Up to 1.9, Julia's garbage collector was stop-the-world (meaning that all compute threads had to be stopped while a collection cycle was running) and serial (meaning a single thread performed a collection while the compute threads were halted). As one may imagine, garbage collection can quickly become a bottleneck in multithreaded code, particularly in code where multiple threads allocate.

In 1.10, we gave the first steps towards improving scalability of the garbage collector in multithreaded code. More specifically, our work consisted of parallelizing the mark-phase of Julia's GC and enabling part of sweeping to be run concurrently with compute threads.

# Tracy and Intel VTune ITTAPI profiling integration

*Cody Tapscott, Valentin Churavy, Prem Chintalapudi*

<Screenshot Tracy> </Screenshot>

<Screenshot VTune></Screenshot>

# Symbol versioning by default

*Cody Tapscott*

You get a libjulia and you get a libjulia and you get a libjulia...

# Upgrade to LLVM 15

*Valentin Churavy, Gabriel Baraldi, Prem Chintalapudi*

We continue to track upstream LLVM and this release updates Julia to LLVM 15. This brings with it updated profiles for new processors and general modernizations.

Particular noteworthy were the move to the new pass-manager promising performance improvements for the native codegen pipeline, as well as
improved support for Float16 on x86.

## Linux-aarch64 Stability Improvements

*Mose Giordano*

With the upgrade to LLVM 15 we were able to [use JITLink on aarch64 CPUs on Linux](https://github.com/JuliaLang/julia/pull/49745).  [This linker](https://llvm.org/docs/JITLink.html), which had been first introduced in [Julia v1.8 only for Apple Silicon](https://julialang.org/blog/2022/08/julia-1.8-highlights/#improved_support_for_apple_silicon) (aarch64 CPUs on macOS), resolves many frequent segmentation fault errors that affected Julia on this platform.  However, due to a [bug in LLVM memory manager](https://github.com/llvm/llvm-project/issues/63236), non-trivial workloads may generate too many memory mappings (`mmap`) that can exceed the limit of allowed mappings.  If you run into this problem, read the documentation on how to [change the `mmap` limit](https://docs.julialang.org/en/v1.10.0/devdocs/build/arm/#AArch64-(ARMv8)).

# Parallel native code generation for system images and package images

*Prem Chintalapudi*

Ahead of time compileration (AOT) was speed up by exposing parallelism during [the image generation phase](https://github.com/JuliaLang/julia/pull/47797). Instead of compiling a large monolithic compilation unit, the work is now split into multiple smaller chunks.

The amount of parallelism used can be controlled by the environment variable `JULIA_IMAGE_THREADS`.

# Avoiding races during parallel Precompilation

*Ian Butterworth*

In previous versions of Julia multiple processes running with the same depot will all race to precompile packages into cache files, resulting in extra work being done and the potential for corruption of these cache files.

1.10 introduces a "pidfile" (process id file) locking mechanism that orchestrates it such that only one Julia process will work to precompile a given cache file, where a cache file is specific to the Julia setup that is being targeted during precompilation.

This arrangement benefits both local users, whom may be running multiple processes at once, and high performance computing users who may be running hundreds of workers with the same shared depot.

# Parallel precompile on using

*Ian Butterworth*

While `Pkg` automatically precompiles dependencies in parallel after installation, precompilation  that happens at `using/import` time has previously been serial, precompiling one dependency at a time.

When developing a package users can end up hitting precompilation during load time, and if code changes in developed packages are deep in the dependency tree of the package being loaded the serial precompile process can be particularly slow.

1.10 introduces parallel precompilation during loading time to catch these cases and precompile faster.

# Acknowledgement

The preparation of this release was partially funded by NASA under award 80NSSC22K1740. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Aeronautics and Space Administration.
