@def title = "This Month in Julia World"
@def authors = "Stefan Krastanov"
@def published = "1 April 2025"
@def rss_pubdate = Date(2025, 4, 1)
@def rss = """Community Newsletter for March 2025"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what I found interesting this month, with contributions from the community.

Call for proposals now open for [JuliaCon Local Paris](https://pretalx.com/juliacon-local-paris-2025/).

[Tickets are now available](https://discourse.julialang.org/t/juliacon-2025-tickets-are-now-available/127765) for JuliaCon Global 2025 in Pittsburgh.

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* Julia 1.12-beta1 is out, check out the [release notes](https://github.com/JuliaLang/julia/blob/v1.12.0-beta1/NEWS.md).
* In a recent push to reduce invalidations in Base, Neven Sajko has made a [flurry of small improvements to inference](https://github.com/JuliaLang/julia/issues?q=is%3Apr+label%3Ainvalidations+). This should improve TTFX in Julia 1.13.
* The Julia REPL has autocompletion, which is surprisingly complex and has been the source of many bugs. A [complete overhaul](https://github.com/JuliaLang/julia/pull/57767) based on the new JuliaSyntax parser is on its way, fixing many outstanding bugs.
* LinearAlgebra is part of the Julia system image, contributing to memory consumption and startup time, even when the package is not used. To address this, there has been [recent work towards making LinearAlgebra lazily loaded](https://github.com/JuliaLang/julia/pull/57719).
* `try` without a `catch` block but with a `return/break/continue` in a `finally` block is really weird (broken?) in multiple languages. At least it is now properly [tracked as an issue](https://github.com/JuliaLang/julia/issues/57875). ([slack discussion](https://julialang.slack.com/archives/C67TK21LJ/p1742820570901569))
* `@test` is particularly neat in how it forwards kwargs to the function call being tested. This might get [added to `@assert` as well](https://github.com/JuliaLang/julia/issues/57503).
* The “performance tips” doc page has been growing in the 1.13 branch. E.g. see new notes on TTFX and on [profiling slow precompilation](https://docs.julialang.org/en/v1.13-dev/manual/performance-tips/#Reducing-precompilation-time).
* How can you make [variable length tuples without allocations](https://discourse.julialang.org/t/variable-length-tuples-without-allocation/127113).
* Code-coverage might get [quite a bit faster thanks to this PR](https://github.com/JuliaLang/julia/pull/57988).
* Tools like `@code_typed f(some_argument)` are great, but it would even nicer if we can just write the type without having to have an actual instance like in `@code_typed f(::SomeType)`. [Potentially soon to be available](https://github.com/JuliaLang/julia/pull/57909).
* Julia’s tests now include [automated checks that new contributions do not cause invalidations](https://github.com/JuliaLang/julia/pull/57884), of great use in preventing regressions.
* A lot of changes happened to the internals for the upcoming 1.12, breaking PrecompileTools in the process, [but that is now fixed](https://github.com/JuliaLang/julia/pull/57828).
* The names of `ccallables` created by Julia can now be [more easily customized](https://github.com/JuliaLang/julia/pull/57763).
* Julia’s initialization when started embedded on a thread of another process is [getting simpler](https://github.com/JuliaLang/julia/pull/57498).
* Considering a [variety of different techniques](https://github.com/JuliaLang/julia/pull/57649) for more efficient waking up of Julia threads when new tasks become available.
* Work on improvements to type inference thanks to [interprocedural propagation of slot refinements](https://github.com/JuliaLang/julia/pull/57651).
* There have been some significant TTFX/precompilation/invalidation [issues with the recently added StyleStrings](https://github.com/JuliaLang/julia/issues/57998) – otherwise a very impressive tool, enabling much richer text output in julia. A very informative discussion on the difficulties with structuring standard libraries and avoiding piracies and invalidations.

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* [Julia is now officially supported in Google Colab!!!](https://discourse.julialang.org/t/julia-in-colab/126600) This includes running [Lux & Reactant on TPUs](https://discourse.julialang.org/t/lux-reactant-on-colab-tpus/126926).
* Documenter 1.9 now [properly filters by the `public` keyword](https://discourse.julialang.org/t/ann-documenter-1-9-public-keyword-support/127021), potentially breaking in some edge cases.
* AlgebraOfGraphics.jl has had a lot of recent improvements, including the [release of v0.10](https://discourse.julialang.org/t/ann-algebraofgraphics-v0-10-and-v0-9-v0-8/127511) as well as a new comprehensive [introductory tutorial series](https://aog.makie.org/v0.10.2/tutorials/intro-i).
* BeforeIT.jl - [High-Performance Agent-Based Macroeconomics in Julia](https://discourse.julialang.org/t/beforeit-jl-high-performance-agent-based-macroeconomics-in-julia/126984)
* SmithChart.jl - [Visualize Smith charts with Makie.jl](https://discourse.julialang.org/t/ann-smithchart-jl-visualize-smith-charts-with-makie-jl/127391)
* DeviceLayout.jl - [CAD for quantum integrated circuits](https://discourse.julialang.org/t/ann-devicelayout-jl-cad-for-quantum-integrated-circuits-and-more/126502)

Julia Autodiff ecosystem:

* DifferentialInterface.jl had a breaking release related to significant improvements in allocation-free sophisticated gradient computations. ([slack discussion](https://julialang.slack.com/archives/C6G240ENA/p1742029987644709))
* A slightly-breaking ForwardDiff v1 is now released ([slack discussion](https://julialang.slack.com/archives/C6G240ENA/p1743003851115789)) thanks to finishing a [PR on properly dealing with zero-measure edge cases](https://github.com/JuliaDiff/ForwardDiff.jl/pull/481) (see [related issue](https://github.com/JuliaDiff/ForwardDiff.jl/issues/480))

Mathematica Optimization ecosystem:

* Optim.jl has had some very significant [updates and improvements](https://discourse.julialang.org/t/ann-optim-jl-updates/109340/18), including now support for DifferentiationInterface.jl.

Notes from other ecosystems:

* [Low-level matrix optimization on AMD GPUs](https://seb-v.github.io/optimization/update/2025/01/20/Fast-GPU-Matrix-multiplication.html)
* [Benchmark of autodiff tools](https://github.com/gradbench/gradbench) in various languages

* “[Programming Massively Parallel Processors](https://www.sciencedirect.com/book/9780323912310/programming-massively-parallel-processors)” - a neat book on structuring algorithms for devices like GPUs from first principles

Events:

* The QNumerics summer school on numerical methods in quantum information science is [open for registration](https://qnumerics.org/).
* [Rust x Julia Eindhoven](https://www.meetup.com/nl-NL/rust-nederland/events/306434865/) Meetup (requires a Meetup account)

See also: [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [minutes of triage meetings](https://hackmd.io/@LilithHafner/HJaw__uMp)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
