@def title = "This Month in Julia World (April 2024)"
@def authors = "Stefan Krastanov"
@def published = "30 April 2024"
@def rss_pubdate = Date(2024, 4, 30)
@def rss = """Community Newsletter for April 2024"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

To my surprise, this newsletter is now running for a whole year...

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* A new Documenter.jl frontend provides for nice “modern looking” documentation pages. Some folks are [experimenting with converting the default Julia docs to this new frontend](https://github.com/JuliaLang/julia/pull/53988). Also discussed on [slack](https://julialang.slack.com/archives/C67910KEH/p1712494270086029).

* Frame’s [frustration with generic `error()` exceptions](https://julialang.slack.com/archives/C67910KEH/p1712566017244079) without valuable metadata led to discussion of Timothy’s draft [proposal for better error reporting in Julia](https://public.tecosaur.net/JuliaErrors.html).

* A slack discussion on [duck typing and interfaces in Julia vs Rust](https://julialang.slack.com/archives/C67TK21LJ/p1712654824391249).

* Discussion on the paradigm [differences between Julia and Rust which lead to Julia being comparatively slower to compile](https://discourse.julialang.org/t/why-is-rust-compilation-faster-than-julia-pre-compilation/113257) (chiefly stemming from Julia’s “open world” extensibility).

* Why is it difficult to provide certain other Rust-like ergonomics, e.g. [amazing interactive type-stability reports as you type your code in your IDE](https://discourse.julialang.org/t/towards-rust-level-feedback-on-type-stability/113497)?

* Maybe you should not do this, but here is a brief discussion on [how far can you push Julia’s goto](https://julialang.zulipchat.com/#narrow/stream/225542-helpdesk/topic/Programmatic.20goto.20for.20backtracking/near/434498885) for manipulating your own (potentially faster) call stack.

* Improvements to the [matrix multiplication dispatch tree](https://github.com/JuliaLang/julia/pull/52439), potentially significantly improving type stability and performance.

* [About.jl](https://github.com/tecosaur/About.jl) is [getting fancier and fancier](https://julialang.zulipchat.com/#narrow/stream/137791-general/topic/About.2Ejl/near/432048760). It now gives a pretty [nice overview of `infer_effects`](https://julialang.zulipchat.com/#narrow/stream/137791-general/topic/About.2Ejl/near/435878576) for any function (i.e. it reports what the compiler has proved/assumed about a function).

* [`deepcopy(nothing)` vs `copy(nothing)`](https://discourse.julialang.org/t/why-can-i-deepcopy-nothing-but-not-copy-nothing/112429) is a convenient reason to revisit some of the semantics of the `copy` interface.

* OpenBLAS now has an interface to cooperate with threads provided by an external runtime. Maybe soon enough we will have [freely nestable multithreading **aware** of OpenBLAS threads](https://julialang.slack.com/archives/C674ELDNX/p1713906763590949).

* Significant performance improvements might be possible if we start special-casing the [construction and storage of small strings](https://julialang.slack.com/archives/C688QKS7Q/p1713867916171509).

* Folks are looking into more ways to [visualize reports from the full-ecosystem continuous integration runner (nanosoldier)](https://julialang.slack.com/archives/C688QKS7Q/p1713933549841489)

* A few stories on what “Undefined Behavior” is for the Julia compiler, on [slack](https://julialang.slack.com/archives/C67910KEH/p1713349665663749) and [github](https://github.com/JuliaLang/julia/pull/54099)

## Core repos

* Upgrading Julia’s [LLVM backend to v17 is almost finished](https://github.com/JuliaLang/julia/pull/53070).

* Get ready for another bikeshedding session as we are discussing the potential for creating anonymous “get property” functions (e.g. `.foo` as shorthand for `x -> x.foo`). Check out the [PR](https://github.com/JuliaLang/julia/pull/53946).

* The “Performance Tips” section of the documentation has finally been structured to reflect the main categories of advice, see the [new docs](https://docs.julialang.org/en/v1.12-dev/manual/performance-tips/) and the [PR](https://github.com/JuliaLang/julia/pull/54211)

## In search of contributors

* Issue bounties are still up for grabs at the [Plots.jl repository](https://github.com/JuliaPlots/Plots.jl/issues/4786)

## Ecosystem

* [Version 1.0 of ADTypes.jl](https://github.com/SciML/ADTypes.jl/pull/40) (the autodiff package chooser) has been released, with support for all existing autodifferentiation packages and a more coherent handling of sparsity. Updating dependents is an [ongoing process](https://github.com/SciML/ADTypes.jl/issues/44).

* Lux.jl now supports [much better nested autodifferentiation](https://discourse.julialang.org/t/nested-ad-with-lux-etc/113573).

* Folks sharing tips and tricks on their preferred approach to [data science in Julia](https://discourse.julialang.org/t/whats-the-current-spring-2024-canonical-approach-to-data-science-in-julia/112427).

* Tidier, the tidy-verse-style Julia data science ecosystem [has new docs](https://tidierorg.github.io/Tidier.jl/dev/).

* Native Julia engine for quarto using [QuartoNotebookRunner.jl](https://discourse.julialang.org/t/ann-native-julia-engine-for-quarto-using-quartonotebookrunner-jl/112753)

* A new advanced extremely fast random sampler that is soon to be incorporated in most of Julia foundational statistics packages: [AliasTables.jl](https://discourse.julialang.org/t/aliastables-jl/112884)

* [Rambus.jl](https://discourse.julialang.org/t/ann-rembus-jl/112372) is a new serialization / message passing toolkit for Julia and other languages.

* [BayesianTomography.jl](https://discourse.julialang.org/t/ann-bayesiantomography-jl-a-julia-package-for-bayesian-quantum-state-tomography/112764) was recently released for quantum state tomography.

* [Space Invaders REPL](https://github.com/JuliaWTF/WatchJuliaBurn.jl/pull/44).

* A lovely list of [well documented packages](https://julialang.slack.com/archives/C6FGJ8REC/p1713881924909949) that you can use as an inspiration for your documentation writing.

* An essay and paper of [Julia’s potential for being best-in-class statistical software framework](https://discourse.julialang.org/t/julia-as-a-universal-platform-for-statistical-software-development/113017).

* Prometheus is an open source software for tracking the performance of servers and systems. We have a convenient [Julia interface for Prometheus](https://discourse.julialang.org/t/prometheus-jl-release-announcement/113005) now.

* [Changelog.jl](https://discourse.julialang.org/t/changelog-jl-release-announcement/112996) can help with managing and prettifying a Changelog file (potentially as part of a Documenter.jl deployment).

* Discussion on the [difficulties of creating a convenient interfacing package for binding Rust in Julia](https://discourse.julialang.org/t/rustcall-jl/113259/).

* Interesting “[experience report](https://discourse.julialang.org/t/experience-report-after-finishing-a-reasonably-substantial-julia-project-in-2024/113148)” from a developer that recently finished a big self-contained software project in Julia. Might be of value for people brainstorming dev tool improvements.

* Gripes and suggestions on using [Arrow, Parquet, and HDF5](https://discourse.julialang.org/t/challenges-with-arrow-and-parquet-in-a-reasonably-substantial-julia-project/113209) as data storage formats from Julia.

## Other ecosystems

* Chapel is an interesting language to keep an eye on if you are into high-performance numerical computing. [Their yearly conference is happening soon](https://chapel-lang.org/ChapelCon24.html).

* Rust is floating the idea of [experimenting with “calling conventions”](https://mcyoung.xyz/2024/04/17/calling-convention/), i.e. how at machine-code level function arguments are mapped to CPU registers. Discussed on our [slack](https://julialang.slack.com/archives/C688QKS7Q/p1713447344540189) and on [hacker news](https://news.ycombinator.com/item?id=40081314).

## Blogs and talks

* A great thorough primer on [Automatic Differentiation in Julia](https://gdalle.github.io/AutodiffTutorial/).

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack.

## Sundry

* [Summer school on numerical methods in quantum information science](https://qnumerics.org), mostly presented in Julia. Happening in August, near Boston.

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
