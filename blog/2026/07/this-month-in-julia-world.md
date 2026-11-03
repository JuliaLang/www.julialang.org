@def title = "This Month in Julia World (May and June 2026)"
@def authors = "Jakob Nybo Andersen"
@def published = "30 July 2026"
@def rss_pubdate = Date(2026, 7, 30)
@def rss = """Community Newsletter for May and June 2026"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

**Temporary change in editorship**
_Stefan Krastanov usually edits and publishes these posts, but he has been busy the last few months and unable to do so. Until Stefan is back, at least for the next few months, the newsletter will be edited by me instead. Under my editorship, the newsletter will focus on developments in core repositories like JuliaLang/julia and Pkg.jl, and less on the broader ecosystem. This is not an editorial line, but of necessity, simply because I am out of the loop of ecosystem news.
Contributors are very welcome to add news about the broader ecosystem to [the shared document](https://hackmd.io/@stefan/Hk9CHPzMbe/edit)._

_The following post concerns changes from May and June. The July newsletter will come out in a few days._

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

Current status (as it was July 1st): Julia release is 1.12.6, Julia LTS is 1.10.11. The 1.13.0-rc1 is available for testing. The dev branch is at 1.14-dev.

\toc

## Core repos

- Ian Butterworth and Gabriel Baraldi have been hard at work improving precompile times (Ian's PRs: [[1](https://github.com/JuliaLang/julia/pull/61920), [2](https://github.com/JuliaLang/julia/pull/62031), [3](https://github.com/JuliaLang/julia/pull/61958), [4](https://github.com/JuliaLang/julia/pull/61957), [5](https://github.com/JuliaLang/julia/pull/62238)], Gabriel's PRs: [[1](https://github.com/JuliaLang/julia/pull/61982), [2](https://github.com/JuliaLang/julia/pull/61967), [3](https://github.com/JuliaLang/julia/pull/61965), [4](https://github.com/JuliaLang/julia/pull/61963), [5](https://github.com/JuliaLang/julia/pull/61943), [6](https://github.com/JuliaLang/julia/pull/61930)]). Julia's (pre)compile times have continuously regressed since v1.10 about three years ago, and, before these PRs, compiler performance hit a new low point on Julia's master branch. At JuliaCon 2026, Gabriel will present a talk on optimizing Julia's compiler, and whether the regressions over the last few years can be undone.

- Keno is implementing many improvements and internal refactors to the type system, particularly with the aim to give type variables, the diagonal rule, and type-of-types more solidly well-defined semantics [[1](https://github.com/JuliaLang/julia/pull/61876), [2](https://github.com/JuliaLang/julia/pull/61861), [3](https://github.com/JuliaLang/julia/pull/61915), [4](https://github.com/JuliaLang/julia/pull/61942), [5](https://github.com/JuliaLang/julia/pull/61940), [6](https://github.com/JuliaLang/julia/pull/61645), [7](https://github.com/JuliaLang/julia/pull/61791), [8](https://github.com/JuliaLang/julia/pull/62228), and many others].

- Gabriel Baraldi has been working to optimize dynamic dispatch by improving [hashing](https://github.com/JuliaLang/julia/pull/62211) and [caching](https://github.com/JuliaLang/julia/pull/62213) during dynamic dispatch with typed-valued arguments. He has also optimized dynamic dispatch [for builtins and intrinsics](https://github.com/JuliaLang/julia/pull/62210). Together, these changes should improve runtime speed of type unstable code, including the interpreter, and the compiler during concrete evaluation, so hopefully these changes will also speed up the compiler.

- `DirEntry` [is now exported from Base](https://github.com/JuliaLang/julia/pull/55358). This type represents an entry in the filesystem, and contains the file type (directory or file) of the entry along with its path. By representing files as `DirEntry` instead of paths, users can statically distinguish abstract paths from resolved files, and, depending on the platform, may also get cached `isdir` and `isfile` calls that do not need syscalls. In the same PR, new methods were added to `readdir` which returns a `Vector{DirEntry}`.

- In [a followup to the DirEntry PR](https://github.com/JuliaLang/julia/pull/62164), Ian Butterworth introduces `scandir`, a lazy version of `readdir`. Its laziness means the filesystem can avoid some work when searching for a specific file instead of querying the filesystem for all files present in a directory.

- Oscar Smith has done work [[1](https://github.com/JuliaLang/julia/pull/62063), [2](https://github.com/JuliaLang/julia/pull/61215)] on supporting a concurrent Immix garbage collector (GC) in Julia. Concurrency in Julia's GC has been a work in progress for many years and some stages of the GC already run in parallel. More parallelism could improve GC pauses in multithreaded scenarios, where the current GC struggles with multiple threads each producing garbage in parallel.

- MethodErrors are improving quite a bit: Andy Dienes [has added hints](https://github.com/JuliaLang/julia/pull/61648) for when a MethodError occurs when a wrong type is passed in with the same name as the expected type, as may happen if two different modules define types of the same name. In [another of his PRs](https://github.com/JuliaLang/julia/pull/61651), highlighting of mismatching types has become more precise, such that when only a type parameter is wrong, only the type parameter is highlighted. This makes it easier to comprehend exactly which part of a deeply nested input type is unexpected.

- In a similar vein, Em Chu has [started work on byte-precise DebugInfo](https://github.com/JuliaLang/julia/pull/61991). She has made use of that feature in [a draft PR](https://github.com/JuliaLang/julia/pull/62024), which implements byte-precise stacktraces. That PR contains an example, where each frame of the trace contains an excerpt of the erroring source code, with the erroring expression marked by a red underline, making the stack trace much nicer and more readable. This is part of the payoff of the multi-year work on JuliaSyntax and JuliaLowering which is still ongoing and has been mentioned in many editions of this newsletter.

- Ian Butterworth has investigated why multithreading with many tasks is slow on Windows, and fixed it [in a recent PR](https://github.com/JuliaLang/julia/pull/61826). Before, scheduling a new task woke up every thread. Now, only a single sleeping thread is awoken on schedule. For workloads with many threads that spawned lots of tasks, this results in a large speed gain on Unix, and massive ~100x speed-ups on Windows.

- Andy Dienes has made a series of PRs to improve the performance of the Serialization module [[1](https://github.com/JuliaLang/julia/pull/61730), [2](https://github.com/JuliaLang/julia/pull/61766), [3](https://github.com/JuliaLang/julia/pull/61753), [4](https://github.com/JuliaLang/julia/pull/61725), [5](https://github.com/JuliaLang/julia/pull/61724)].

- Julia [now has a `Core.memoryrefunset!` intrinsic](https://github.com/JuliaLang/julia/pull/61759), which unsets the value at an index from a `Memory`. This resets the value at that index in a `Memory` to undefined data (i.e., `#undef` for pointer-ful types, and arbitrary data for bitstypes). This functionality, which previously was done by the private `Base._unsetindex!` function, is necessary to free (and garbage collect) pointer-ful types stored in arrays. This function and its semantics are not yet public, but there is [an open PR addressing that issue](https://github.com/JuliaLang/julia/pull/62181).

- [A new work-in-progress PR](https://github.com/JuliaLang/julia/pull/62157) by Keno Fischer would allow the entire Julia frontend (JuliaSyntax and JuliaLowering) to be replaced. In related changes, Keno [is working on](https://github.com/JuliaLang/julia/pull/62068) splitting off the frontend into a separate `libjulia-frontend` and to [compile this separately](https://github.com/JuliaLang/julia/pull/62073) from the rest of Julia. These changes will allow packages whose files are not parseable with the current Julia parser. For example, it would allow a package to use Julia v1.15 syntax while still supporting Julia v1.14, by running the v1.15 parser. It could also allow re-building the backend and frontend of Julia independently, which will speed up development.

- Shuhei Kadowaki is attempting to [refine inference based on the caller signature constraints](https://github.com/JuliaLang/julia/pull/62071). For example, when calling `f(a::T, b::T) where T`, the function should know `a` and `b` must be of the same type.

- Gabriel Baraldi and Ian Butterworth is doing [some speculative work](https://github.com/JuliaLang/julia/pull/61888) on tiered compilation. The idea is that Julia starts up with lower optimization levels and thus lower latency. Concurrently with execution, less-optimised versions of functions would be hot-swapped with more-optimised versions. Tiered compilation theoretically allows both low latency and high performance, and has been discussed for years as a potential latency mitigation. Historical initiatives has been blocked by the problem that execution could be stuck in a unoptimized, long-running loop, which would tank performance. It is not clear how the new PR would address that problem and so tiered compilation remains theoretical for now.

- There is [a new website](https://perf.julialang.org/) for tracking various performance related metrics across julia development and the ecosystem.

## In search of contributors

- [Agents.jl](https://juliadynamics.github.io/Agents.jl/stable/) is a mature and well-established library for agent-based modelling. It is currently [searching for maintainers](https://discourse.julialang.org/t/agents-jl-v6-releases-announcement-post/111678/13?u=datseris).

- [XGBoost.jl](https://github.com/dmlc/XGBoost.jl) is the Julia wrapper for the `libxgboost` gradient boosted trees machine learning library. It is currently in search of maintainers.

## Numerical math and science

- [RecurrenceMicrostatesAnalysis.jl](https://juliadynamics.github.io/DynamicalSystemsDocs.jl/recurrencemicrostatesanalysis/stable/) is a new package for nonlinear timeseries analysis that has joined [DynamicalSystems.jl](https://juliadynamics.github.io/DynamicalSystemsDocs.jl/dynamicalsystems/dev/). It implements several cutting edge approaches to identify recurrences in (uni/multi)-variate timeseries, which can then be used for a variety of things like distinguishing noise from chaos or identifying transitions in timeseries. It also coordinates and interfaces with ComplexityMeasures.jl [API for probabilities and entropies](https://juliadynamics.github.io/DynamicalSystemsDocs.jl/complexitymeasures/stable/probabilities/).

See also: [JuliaHub corporate blog](https://juliahub.com/blog), [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](/community/#events), [Turing.jl newsletter](https://github.com/TuringLang/Turing.jl/issues/2498)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
