@def title = "This Month in Julia World (August 2026)"
@def authors = "Jakob Nybo Andersen"
@def published = "2 September 2026"
@def rss_pubdate = Date(2026, 9, 2)
@def rss = """Community Newsletter for August 2026"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

Disclaimer: An LLM was used for copy-editing this post. While I have reviewed its edits, it is possible the LLM has made mistakes. Please be aware of the [Julia Discourse policy on Generative AI content](https://discourse.julialang.org/t/updates-to-the-site-guidelines-especially-regarding-gen-ai/134315).

\toc

## General

* Current status of Julia releases (as of 2026-09-01): The Julia release is 1.12.7, the Julia LTS release is 1.10.12, and Julia 1.13.0-rc3 is available for testing. The master branch is at 1.14.0-DEV.3081.

* JuliaCon Global 2026 took place this month in Mainz, Germany. This year's JuliaCon was hot, both figuratively, as there was lots of exciting Julia activity and many new developments in industry and in the language itself, and literally, as it was 35 degrees out with little air conditioning.
  Videos from the auditoriums are up [on the Julia Language YouTube channel](https://www.youtube.com/@TheJuliaLanguage), but the individual talks have not yet been cut into videos.
  There is a huge number of interesting talks to watch, but if I am to recommend a single talk, it would be [this year's State of Julia](https://youtu.be/X6LZ7GeNzlw?t=32193).

* Until recently, the release of Julia 1.13 was stuck on rc1 for many months. The reasons for this are a series of unfortunate events described in [this year's State of Julia](https://youtu.be/X6LZ7GeNzlw?t=32268):

  - First, security researcher Tsi-Lin Ng and others managed to backdoor the infrastructure behind the package managers for Python, Go, Flutter, and … Julia.
    He gave a presentation on the exploit at Black Hat 2026, the [slides for which are publicly available](https://i.blackhat.com/BH-USA-26/Presentations/US-26-SplitlineNg-BornCorrupted-Thursday.pdf).
    Rebuilding the Julia infrastructure to fix the issue took extra time since some software could not be updated as its dependencies were no longer supported, so lots of yaks had to be shaved.

  - Then, the machine that ran PkgEval unexpectedly stopped working, and without PkgEval, Julia version 1.13 could contain accidental breaking changes. So, the PkgEval runner had to be rewritten.

  - Finally, before releasing the AI model [Claude Mythos](https://www.anthropic.com/claude/mythos), Anthropic launched [Project Glasswing](https://www.anthropic.com/glasswing), which provided free security audits to various pieces of software infrastructure in anticipation of upcoming AI models being able to automate security-vulnerability discovery upon release. Anthropic found 155 possible security vulnerabilities in Julia's infrastructure, which eventually [led to 16 confirmed disclosures](https://github.com/JuliaLang/SecurityAdvisories.jl/pull/544). Knowing that models that could automatically find these vulnerabilities would soon hit the market, these issues needed to be fixed immediately.

All these issues have now been resolved, and the Julia developers can make new releases again.

## Core repos

* It's always been awkward that Julia's documentation had a package for [the latest stable version](https://docs.julialang.org/en/v1/) and [for nightly](https://docs.julialang.org/en/v1.14-dev/), but not for alpha, beta, or release candidates. Thanks to [a PR by Lars Göttgens](https://github.com/JuliaLang/julia/pull/62611), we finally have [such a page](https://docs.julialang.org/en/v1.13.0-rc3/).

* [A PR](https://github.com/JuliaLang/julia/pull/62566) shows an interesting example of how a series of supposedly zero- or low-cost abstractions conspired to give SHA-256 hashing of `String`s an accidentally quadratic time complexity: Strings were hashed one chunk at a time, with each chunk copied into a buffer. The generic implementation of copying needed to check for aliasing between the source and destination to avoid data corruption; this was done with `Base.dataids`, which fell back to `objectid`, which hashed the entire string. The underlying issue here may be Julia's argument aliasing policy, which is still somewhat ad hoc and therefore the code paths involved with unaliasing can't be reasoned about systematically.

* In [yet another of Keno's amazing AI-generated prototypes](https://github.com/JuliaLang/julia/pull/62715), Keno tests out semantics for computed field types. Computed field types are useful when some type parameters are not free but derived from other type parameters. Consider StaticArray's `SMatrix{N, M, T, L}`—its size is `N * M`, and it's backed by an `NTuple{L, T}`. `L` is always `N * M`, so it is redundant, but it cannot be removed because there is no way to specify the tuple's type as `NTuple{N * M, T}`. The extra parameter not only hurts legibility, it also causes headaches for package developers because invalid types such as `SMatrix{1, 1, Int, 5}` (where `L != N * M`) can be constructed even if instantiation is disallowed. With Keno's prototype, it would be possible to specify the tuple as exactly `NTuple{N * M, T}`, and the `L` parameter could be dropped. This feature has been requested for years and years.

* The above feature quickly turns into a can of worms: What if a user defines a `foo() = 2`, uses `foo` to compute a field type, and then redefines `foo`? What if users compute fields from mutable global state, or from a `@ccall`, or use side-effectful code to compute type parameters? In [another of Keno's ambitious prototypes](https://github.com/JuliaLang/julia/pull/62840), Keno implemented RCJulia, a subset of Julia that can be shown, by construction, to be side-effect-free and terminating. This subset is *extremely* restrictive and doesn't allow things like loops or some forms of recursion. So, it is intended as a Julian version of [C++'s `constexpr`](https://en.cppreference.com/cpp/language/constexpr), precisely for expressions like computed field types, when you only want deterministic, cacheable, and terminating code.

* The [world age mechanism](https://docs.julialang.org/en/v1/manual/worldage/#The-World-Age-mechanism) is a crucial part of Julia's compiler internals and is the mechanism by which Julia is able [to invalidate code](/blog/2020/08/invalidations/#method_invalidation_what_is_it_and_when_does_it_happen). By design, it is an increasing integer, modeling the monotonically increasing lifetime of available compiled code within a single Julia process. However, with system and package images, code is not compiled in a single process but across many histories. In [another one of Keno's PRs](https://github.com/JuliaLang/julia/pull/62834), he prototypes turning the world age into a directed acyclic graph such that the world age of cached Julia processes can still be referred to. This is useful for unambiguously referring to code that existed in previous processes, e.g. which was used to compute derived field types. However, the change is really a deeper precision of the world age semantics, and so it sounds like it should be useful for all kinds of things in the future, though it's above my paygrade to speculate on what, exactly.

* When you write `f(::Type{<:MyType})`, the method also applies to `f(Union{})`, as `Union{}` (a.k.a. `Bottom`) is a subtype of all types. This is semantically correct but practically very annoying—suppose you define `element_type(::Type{<:AbstractSet{T}}) = T`; now, the method also covers `element_type(Union{})` even though it makes no sense, and `T` is undefined (an unbound type var). In cases such as this—in most cases, in fact—you don't want such methods to apply to `Bottom`. You want a way to specify "all subtypes of `MyType` *except* for `Bottom`." However, Julia doesn't have that functionality, despite it being on many a wishlist for years. Thanks to [a PR by Keno](https://github.com/JuliaLang/julia/pull/62265), this may change with the introduction of `Core.Epsilon`: A marker which, when specified as the lower bound of a `TypeVar`, includes every subtype except `Bottom`. If this gets merged, we could now write `element_type(::Type{S}) where {Core.Epsilon <: S <: AbstractSet{T}} = T`. The compiler team is also discussing making `X{<:T}` desugar to `X{Y} where {Core.Epsilon <: Y <: T}`, which would solve this problem automatically in existing codebases, but whether that will happen depends on how breaking it is in practice.

* In a similar set of events, `element_type(::Type{<:AbstractSet{T}}) = T` [now correctly reports `T` as possibly unbound](https://github.com/JuliaLang/julia/pull/62405) (due to the aforementioned case `element_type(::Type{Union{}})`). This causes `Test.detect_unbound_args` to fire much more frequently, which is leading to package test failures on nightly. In [a mitigating PR by Kristoffer Carlsson](https://github.com/JuliaLang/julia/pull/62913), `Test.detect_unbound_args` now defaults to ignoring the case when the unbound arg is caused by `Bottom`, with the option of re-enabling it.

* [ScopedValues](https://docs.julialang.org/en/v1/base/scopedvalues/) were [added in Julia 1.11](https://github.com/JuliaLang/julia/pull/50958). While [they're useful](https://discourse.julialang.org/t/task-local-storage-and-scoped-values-what-they-are-used-for/132045?u=jakobnissen), they have struggled with poor performance for several years: Until recently, they used to [allocate when accessed](https://github.com/JuliaLang/julia/issues/53584)—fixing that required [beefing up Julia's Union return type ABI](https://github.com/JuliaLang/julia/pull/55045). [A new PR by Andy Dienes](https://github.com/JuliaLang/julia/pull/62762) allows constant `ScopedValue` writes to be constant-folded into the `with` body. [A related PR by Jacob Quinn](https://github.com/JuliaLang/julia/pull/62730) makes `ScopedValue` updates type-stable by applying long-overdue and completely standard type-stabilizing practices to the `ScopedValues` implementation. As far as I'm aware, these PRs fix all outstanding issues with `ScopedValue` performance.

* Heap images used to live in the `.so` (or `.dll`) files produced by precompilation. Thanks to [work by Sam Schweigel](https://github.com/JuliaLang/julia/pull/61649), they now live in the `.ji` files. This inconspicuous change reduces peak memory usage during compilation, may improve relocatability of precompiled code, and makes the created shared-object files much smaller. The latter is especially a relief for people making huge `PackageCompiler` binaries, which would otherwise run into the 4-GB file-size limit.

* The long journey of [MMTk integration](https://www.mmtk.io/) into Julia continues. A new [work-in-progress PR by Yin Li](https://github.com/JuliaLang/julia/pull/62875) enables the LXR garbage collector (GC) in Julia. This is an advanced low-latency GC. At this point, Julia can be built with some of MMTk's GCs by opting in; these currently provide lower latency but also lower throughput than Julia's existing GC. This may be useful for specialized applications that require lower GC latency. Optimization continues, and perhaps not too far into the future, one of MMTk's GCs will surpass Julia's own GC on balance, and Julia will default to an MMTk GC.

* Tuple operations like `Base.front`, `Base.tail`, and splatting are classic compiler-performance traps for new users. Improvements to the heuristics for some cases are in the pipeline: [Hossein Ostolagh made `tail` iterative instead of recursive](https://github.com/JuliaLang/julia/pull/62786) for massive speedups. [A similar work-in-progress PR by Kristoffer](https://github.com/JuliaLang/julia/pull/62746) switches long splats from unrolling them into a huge amount of LLVM code to a normal iterative approach, avoiding the codegen explosion.

* `Threads.@threads :static` cannot currently be used concurrently or in a nested context. [An unmerged PR by Ian Butterworth](https://github.com/JuliaLang/julia/pull/62751) allows concurrent use by having each task consult a lock.

* Some downstream code generators like Enzyme or GPUCompiler need to query the ABI of Julia functions. Currently, they attempt to derive the ABI themselves, but [a new PR by Gabriel Baraldi](https://github.com/JuliaLang/julia/pull/62610) allows querying this from the compiler directly.

* Julia allows reinterpreting between bitstypes, but not when padding differs. Nathan Zimmerberg has [added a fix](https://github.com/JuliaLang/julia/pull/62771) to [a bug](https://github.com/JuliaLang/julia/issues/62815) in this padding check. Relatedly, he has covered [issues with `elsize` and alignment of the new odd-sized primitive types](https://github.com/JuliaLang/julia/issues/62398). It appears to still be a little up in the air exactly [how odd-sized primitives should be sized](https://github.com/JuliaLang/julia/issues/61361), with [a potential implementation in the works](https://github.com/JuliaLang/julia/pull/62852) by Max Horn.

* The Trixi.jl devs logged [a Julia 1.11 performance regression](https://github.com/JuliaLang/julia/issues/62798), which appears to be caused by the Julia 1.11 Memory PR degrading the compiler's aliasing information. Jameson [merged a PR which restored the aliasing information](https://github.com/JuliaLang/julia/pull/62802), which surprisingly [made the regression worse](https://github.com/JuliaLang/julia/pull/62802#issuecomment-5404644758). The problem now is that LLVM seems to produce *worse code* given *better information* from the Julia front end. This is an interesting dilemma: Should Julia intentionally provide worse information to LLVM to work around LLVM making poor use of that information? Possibly yes; Jameson has [opened another PR](https://github.com/JuliaLang/julia/pull/62904) which does exactly that, which empirically leads to better codegen. It seems a little crazy, but practicality beats purity.

## Latency

It seems Fable, Opus, and Sol are enabling people outside the compiler team to do substantial work to improve Julia's latency:

* James Wrigley has put up [a still-open PR that refines backedges](https://github.com/JuliaLang/julia/pull/62658). Previously, if `f` called `g`, there would be a backedge from `g` to `f`. Theoretically, new definitions of `g` could refine the inference of `f`, but that happened rarely, and recompilation usually occurred when new code required `f` to relax its precision. In the PR, the compiler won't put a backedge if `f` already has no useful information about `g` and therefore can't relax its information further. Amazingly, this eliminates a huge amount of invalidation and so ought to have a noticeable positive effect on latency if it gets merged.

* Even in the deepest, darkest corners of the compiler, the teachings from Introduction to Algorithms and Data Structures still apply. When [looking into a compiler regression](https://github.com/JuliaLang/julia/issues/62723), Ian Butterworth noticed that inserting missing-method backedges (the kind that causes world-splitting invalidations) takes a substantial amount of time because it had to check whether a `(signature, caller)` pair was present in an array by looping over that array. By [switching part of this lookup to use a dict](https://github.com/JuliaLang/julia/pull/62733), invalidation bookkeeping is sped up significantly.

* Sam Schweigel (and [independently, Ian Butterworth](https://github.com/JuliaLang/julia/pull/62934)) noticed that compiled code in package images was needlessly re-inferred. Sam [submitted a fix in a PR](https://github.com/JuliaLang/julia/pull/61479), which improved precompilation speed by roughly 10% and also reduced the size of package images.

* Kristoffer Carlsson has been on a roll improving load times. In [a recent PR of his](https://github.com/JuliaLang/julia/pull/62578), he cut down on redundant work during loading by caching `compilecache_freshest_path` and cutting down on needless hashing. This knocked about half a second off the load time in a large environment. In another PR, he has been [working on caching the validation of cache files between workers during precompilation](https://github.com/JuliaLang/julia/pull/62586). Benchmarking suggests it may cut `stat` calls by 75% when combined with [another of his loading-related PRs](https://github.com/JuliaLang/julia/pull/62404), which we mentioned last month.

At this point, precompilation and script execution [now have lower latency on master](https://github.com/JuliaLang/julia/pull/61479#issuecomment-5482502155) than v1.10. However, package loading remains slower.

## Other repos

* [Revise 3.17 is out](https://github.com/timholy/Revise.jl/releases). Its main feature [is automatic revision of structs by default](https://discourse.julialang.org/t/revise-3-16-fast-type-revision-frozen-worlds-and-complete-language-support/138211/7?u=jakobnissen). With this release, the long-desired feature of automatic struct redefinition has finally arrived.

* The new-ish [JuliaLibWrapping.jl package](https://github.com/JuliaInterop/JuliaLibWrapping.jl) allows the creation of C header files for static Julia libraries compiled with JuliaC. It also automates the creation of Python packages calling into this C-compatible Julia library! This package was registered back in June but somehow flew under my radar.

## Other community news

* Andy Dienes (and Claude) made [a cool website](https://claude.ai/code/artifact/cc2fa16e-e491-4717-afc8-4b7d41c4fb79) that gathers statistics from the JuliaLang/julia repo. Besides actually useful information, it also includes a list of achievements. For example, Cody Tapscott leads in issue opening, with 65 issues opened over the past 13 months.

* There has been [a very long and lively discussion on Slack](https://julialang.slack.com/archives/C6FGJ8REC/p1786795139624069) about the use of AI for developing Julia and the Julia ecosystem, and its impact on the community. This Slack thread spun off [a similar Discourse thread](https://discourse.julialang.org/t/getting-the-best-out-of-ai-without-endangering-the-community/138834/1).

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
