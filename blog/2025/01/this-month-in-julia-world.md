@def title = "This Month in Julia World"
@def authors = "Stefan Krastanov"
@def published = "1 January 2025"
@def rss_pubdate = Date(2025, 1, 1)
@def rss = """Community Newsletter for December 2024"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what I found interesting this month, with contributions from the community.

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* Julia’s compiler has long had the ability to detect if memory allocations escape local scopes, and optimize them away in some cases when it can be proven they don’t escape. However, this existing ‘escape analysis’ in Julia has been limited and hasn’t actually enabled much optimisation. A new [overhaul of escape analysis](https://github.com/JuliaLang/julia/pull/56849) aims to be more accurate and open the door for implementing further memory optimisations in the future.
* Support for the independent external experimental Garbage Collector framework MMTk [is almost a reality](https://github.com/JuliaLang/julia/pull/56288).
* Another discussion on [current and future ways to work with interfaces and traits in Julia](https://discourse.julialang.org/t/interfaces-traits-in-julia-2-0-and-multiple-inheritance/124011). While these discussions are always informative, be careful as they also can be a bit bikesheddy.
* A small helpful discussion on [when does `@inbounds` increase performance](https://discourse.julialang.org/t/when-does-inbounds-increase-performance/123827)?

In search of contributors and new maintainers (specify novice/moderate/expert and internals/domain background necessary):

* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science.
* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.
* ChainRules, a foundational package to the Julia autodiff effort is looking for a [new primary maintainer](https://discourse.julialang.org/t/chainrules-project-looking-for-a-new-primary-maintainer/115636).

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* The general package registry now [requires release notes on breaking releases](https://discourse.julialang.org/t/new-automerge-requirement-release-notes-required-for-breaking-package-releases/123955).
* Cute little [GUI](https://discourse.julialang.org/t/pre-ann-startyourpk-gui-for-pkgtemplates/124197) for creating Julia packages (on top of PkgTemplates.jl)
* [DispatchDoctor.jl](https://github.com/MilesCranmer/DispatchDoctor.jl) is a neat way to ensure your code is type stable.
* The benchmarking toolkit Chairmarks.jl now supports [benchmarking two functions in an interleaved fashion](https://discourse.julialang.org/t/chairmarks-supports-comparative-benchmarking/124166), avoiding potential sources of noise and bias.
* Julia is proving to be [really interesting for signal processing](https://discourse.julialang.org/t/julia-and-the-gps-payload-onboard-waratah-seed-1-satellite/123795) and real time control of space satellites.

Julia Autodiff ecosystem:

* [DynamicDiff.jl](https://discourse.julialang.org/t/ann-dynamicdiff-jl-fast-symbolic-differentiation-for-runtime-generated-expressions/123907), integrated with the larger SymbolicRegression.jl ecosystem, provides for blazingly fast differentiation of dynamically generated expressions without compilation overhead.
* [DifferentiationInterface.jl has great documentation](https://juliadiff.org/DifferentiationInterface.jl/DifferentiationInterface/dev/faq/differentiability/) with a useful overview of the ecosystem.

Notes from other ecosystems:

* [EmacsConf talk](https://emacsconf.org/2024/talks/julia/): “Exploring shared philosophies in Julia and Emacs” ([YouTube](https://www.youtube.com/watch?v=RTVXaDR697k))
* NumPy uses [avx-512 SIMD instructions when available for sorting](https://discourse.julialang.org/t/numpy-sort-vs-julia-sort/123421/7?u=krastanov), leading to much higher performance

See also: [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [minutes of triage meetings](https://hackmd.io/@LilithHafner/HJaw__uMp)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
