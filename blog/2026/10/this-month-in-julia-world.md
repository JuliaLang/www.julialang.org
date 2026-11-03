@def title = "This Month in Julia World (September 2026)"
@def authors = "Jakob Nybo Andersen"
@def published = "2 October 2026"
@def rss_pubdate = Date(2026, 10, 2)
@def rss = """Community Newsletter for September 2026"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

Disclaimer: An LLM was used for copy-editing this post. While I have reviewed its edits, it is possible the LLM has made mistakes. Please be aware of the [Julia Discourse policy on Generative AI content](https://discourse.julialang.org/t/updates-to-the-site-guidelines-especially-regarding-gen-ai/134315).

\toc

## General
Current status (as of 2026-09-30): The latest Julia release is 1.13.1, and the LTS release is 1.10.12. The master branch is at 1.14.0-DEV.3418. The 1.14 feature freeze is scheduled for 2026-10-12.

This month saw a large amount of activity on GitHub: 435 PRs were opened to JuliaLang/julia, compared to 282 in the already busy month of August, an increase of more than 50%. Most PRs this month were small: bug fixes, performance improvements or minor internal changes. This contrasts with last month, which saw several big, experimental PRs.

## Core repos
* Julia's SIMD support is currently spotty. We can call LLVM directly through the (private) `Core.Intrinsics.llvmcall`, which SIMD.jl abstracts over, and of course there is LLVM's autovectorization. However, some basic SIMD abstractions may be coming to Base, thanks to [ongoing work by Oscar Smith](https://github.com/JuliaLang/julia/pull/63347). This could provide a better foundation for SIMD that does not require reaching into Julia internals, and could fill an important gap between autovectorization and (the still unsupported) platform-specific SIMD. Julia's SIMD support is still nascent, so there will no doubt be more work on this in the future.

* A [new PR by Max Horn](https://github.com/JuliaLang/julia/pull/63095) would allow defining a primitive type parameterized by its number of bits. In a similar vein, Max Horn continues to fix issues with odd-width primitives [[1](https://github.com/JuliaLang/julia/pull/63093), [2](https://github.com/JuliaLang/julia/pull/62492), [3](https://github.com/JuliaLang/julia/pull/63408)]. These efforts will eventually allow us to define types such as `primitive type BitUnsigned{N} <: Unsigned N end`, which would be bona fide N-bit integers.

* Amazingly, even very basic operations such as `min`, `>=` and `<` were not optimally implemented in Base for mixed bit-integer types. New PRs [[1](https://github.com/JuliaLang/julia/pull/63309), [2](https://github.com/JuliaLang/julia/pull/63287)] by Patrick Haecker and matthias314 rectify this. I find it stunning that there are still optimization opportunities in something as basic as `<(::Int16, ::UInt8)`.

* A `Vector` [can now be resized by adding uninitialized elements at the front](https://github.com/JuliaLang/julia/pull/57313) by calling `resize!(v, n; first=true)`. This obviously missing feature was implemented by Adriano Meligrana.

* Jacob Quinn has [added a new `Timestamp{P}` type](https://github.com/JuliaLang/julia/pull/62994) in Dates, backed by an `Int64`, where `P` controls the resolution. The motivating case is `Timestamp{Nanosecond}`, which provides nanosecond resolution but can only represent dates from the years 1677 to 2262. This contrasts with `DateTime`, which only has millisecond resolution but spans more than 400 million years. There is also [a discussion of this proposal on Slack](https://julialang.slack.com/archives/C67910KEH/p1790223276081619).

* Julia's unions are currently stored as [tagged unions](https://en.wikipedia.org/wiki/Tagged_union) (for bitstypes), as pointers to boxed objects (for non-bitstypes), or [with the tags stored in a separate array](https://docs.julialang.org/en/v1/devdocs/isbitsunionarrays/) in a [struct-of-arrays](https://en.wikipedia.org/wiki/AoS_and_SoA)-like optimization (for arrays of bitstypes). Notably lacking is [niche optimization](https://niche.rs/about), where the tag and value are bit-packed together when the value has unused bits. [A new PR by Max Horn](https://github.com/JuliaLang/julia/pull/62918) implements niche optimization for a very specific set of unions: unions of reference types and bitstypes with fewer than five primitive members. For example, on a 64-bit machine, `Union{String, UInt32}` would store the `UInt32` inline, saving a heap allocation.

* It has long been possible to use control flow such as `return` and `@goto` in a `finally` block to skip an exception, even though that should absolutely not be the case. Using `@goto` to do this is now disallowed [[1](https://github.com/JuliaLang/julia/pull/60979), [2](https://github.com/JuliaLang/julia/pull/63009)]. Using `return` to skip `finally` [is still an open issue](https://github.com/JuliaLang/julia/issues/57875), but the new syntax evolution in Julia 1.14 may allow it to be disallowed in the future.

* Terminals support escape sequences that mark the start and end of prompts, which let them distinguish prompts from command output. [The Julia REPL now emits them](https://github.com/JuliaLang/julia/pull/63112). Terminals that don't understand these sequences simply ignore them, but some terminals offer commands like "jump to prompt" and "copy last prompt", which now work with the Julia REPL.

* A [new PR by Tim Besard](https://github.com/JuliaLang/julia/pull/62724) makes code coverage much faster: almost twice as fast when measuring coverage of Julia itself. Coverage counters are now relocatable, so code compiled with coverage enabled can be precompiled. In addition, the counters' volatile loads and stores have been replaced with atomics operating on a separate, unaliased memory region, which allows _significantly_ more compiler optimization. Finally, the default has changed from "how many times was this line hit?" to "was this line hit at least once?", which is cheaper to compute.

* Sam Schweigel may win the "most bang for a one-line change" prize with [a recent PR](https://github.com/JuliaLang/julia/pull/63073), which changes the code caching rules during compiler bootstrapping and thereby makes bootstrapping twice as fast. During bootstrapping, the full compiler is not yet available to the runtime, so the mechanism by which Julia specializes code and requests JIT compilation is different. [A recent refactor](https://github.com/JuliaLang/julia/pull/61997) changed how specialization works and accidentally [made the existing bootstrapping heuristics slow](https://github.com/JuliaLang/julia/issues/62198); that is what Sam's PR fixes.

* Andy Dienes has improved codegen for copies [[1](https://github.com/JuliaLang/julia/pull/62905), [2](https://github.com/JuliaLang/julia/pull/63015)]. Copying bitstypes may emit LLVM `memcpy` calls, which can't track alias information separately for the load and store sides. By modelling copies of small data as a few integer loads and stores with distinct alias information, the aliasing is more precise and LLVM can optimize the code more aggressively. This fixes [a regression](https://github.com/JuliaLang/julia/issues/60409), but is probably also simply a better way to generate code for small copies.

* Many compilers keep track of the effects of code. It sure would be nice if the extensive effect inference of [Julia's effect system](https://docs.julialang.org/en/v1/base/base/#Base.@assume_effects) could be used by Julia's backend compiler, LLVM. [A new work-in-progress PR by Valentin Churavy](https://github.com/JuliaLang/julia/pull/63464) takes a step in that direction by translating a subset of Julia's effects into LLVM attributes on statically resolved, non-inlined function calls. As a result, LLVM knows more about which optimizations are legal, and so optimizes more. This PR is the second attempt, after [the previous one by Ian Butterworth](https://github.com/JuliaLang/julia/pull/61394) was reverted because it did not properly account for the extra side effects caused by Julia's garbage collector.

* Julia prefers to display types by their aliases, e.g. `Vector{Int}` instead of the full name `Array{Int, 1}`. But what if several aliases match the same type? Previously, the heuristic would give up and print the full type. That was unfortunate, because types with several aliases are typically nasty, deeply nested ones. Thanks to Benoît Legat, [Julia now prints the narrowest applicable alias](https://github.com/JuliaLang/julia/pull/63372). If several aliases apply and none is strictly narrower than the others, it still falls back to showing the full type. This should help tame some of the enormous stack traces produced by packages that nest types deeply.

* When compiling ahead of time (package images, system images or JuliaC), Julia reduces LLVM's memory pressure by splitting the LLVM module into smaller shards. There used to be one shard per thread, but thanks to [a new PR by Sam Schweigel](https://github.com/JuliaLang/julia/pull/63363), modules are now split based on estimated IR size. This usually means noticeably less memory usage: 23% less when building a system image. In [a related work-in-progress PR](https://github.com/JuliaLang/julia/pull/63166), Sam trimmed almost 4% off the heap image size simply by shrinking the `Memory` backing `Vector`s so that it has no excess capacity.

* Ian Butterworth is doing a lot of work on making package loading faster [[1](https://github.com/JuliaLang/julia/pull/63327), [2](https://github.com/JuliaLang/julia/pull/63303), [3](https://github.com/JuliaLang/julia/pull/63232), [4](https://github.com/JuliaLang/julia/pull/63035)], with several of the ideas taken from [one of Keno Fischer's work-in-progress PRs](https://github.com/JuliaLang/julia/pull/62254).

* The output of `pkg> why` [is getting a makeover](https://github.com/JuliaLang/Pkg.jl/pull/4839) thanks to Kristoffer Carlsson.

* Ian Butterworth [proposes a "lazy" package API](https://github.com/JuliaLang/Pkg.jl/pull/4834), which would, for example, let you add or upgrade packages without installing or compiling them immediately. This would make package operations much faster if you, e.g., only want to check the latest version or generate a Manifest.toml.

* Pkg reads the registry directly from the compressed registry tarball, an optimization that greatly improved Pkg's speed when [it landed years ago](/blog/2021/11/julia-1.7-highlights/#improved_performance_for_handling_registries_on_windows_and_distributed_file_systems). Kristoffer Carlsson [aims to optimize this further](https://github.com/JuliaLang/Pkg.jl/pull/4797) with a memory-mapped binary cache file that is fast to query. Pkg is already fast, so this "only" saves tens of milliseconds, but in my opinion, it's the compounding effect of optimizations like these that makes the difference between a reasonably fast package manager and a delightfully smooth experience.

## Other repos
* Jacob Quinn [has released CSV.jl 1.0](https://discourse.julialang.org/t/ann-csv-jl-1-0-release/139485). Version 1.0 comes with many new features and improvements, including partially SIMD-accelerated parsing, `--trim` compatibility and a new `CSV.lazy` reader. In the announcement's benchmarks, CSV.jl 1.0 shows large speedups and trades blows with Polars and PyArrow.

* This month, Jacob Quinn also [announced Postgres.jl v2.0](https://discourse.julialang.org/t/ann-postgres-jl-a-julia-native-postgresql-client/139504), a native Julia PostgreSQL client. Over the last year or so, Jacob's open source work has accelerated to an impressive degree, with great contributions to the ecosystem's foundational data infrastructure, including [Reseau.jl](https://github.com/JuliaServices/Reseau.jl), [JSON.jl v1](https://github.com/JuliaIO/JSON.jl/releases/tag/v1.0.0), [Servo.jl](https://github.com/JuliaServices/Servo.jl), [OAuth.jl](https://github.com/JuliaServices/OAuth.jl), [HTTP.jl v2](https://github.com/JuliaWeb/HTTP.jl/releases/tag/v2.0.0) and probably several more packages that haven't reached my radar.

* Mark Kittisopikul has [announced StaticStrings.jl v0.3](https://discourse.julialang.org/t/staticstrings-jl-v0-3-move-to-juliastrings/139648), a package providing an `AbstractString` that wraps an `NTuple{N, UInt8}`. The Discourse thread includes some discussion of how it differs from, and overlaps with, similar packages such as InlineStrings.jl, and StringViews.jl combined with StaticArrays.jl.

* [gRPCServer.jl](https://github.com/JuliaIO/gRPCServer.jl) provides a native Julia gRPC server, filling a gap in the ecosystem: gRPC client support existed, but server-side support was largely missing. It supports unary, streaming and bidirectional RPCs, with type-safe dispatch and an extensible interceptor system for things like authentication, logging and metrics.

## Other community news
* BioJulia will hold its [first community call](https://discourse.julialang.org/t/first-ever-biojulia-community-call-poll/139645/2) on Tuesday, October 6th. The call will cover the current state of the BioJulia ecosystem and its packages, near-future work and, time permitting, what participants are working on individually.

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
