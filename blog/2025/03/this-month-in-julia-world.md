@def title = "This Month in Julia World"
@def authors = "Stefan Krastanov"
@def published = "1 March 2025"
@def rss_pubdate = Date(2025, 3, 1)
@def rss = """Community Newsletter for February 2025"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what I found interesting this month, with contributions from the community.

> Save the date for JuliaCon Local Paris 2025 (October 2nd-3rd)!
>
> More information at **<https://juliacon.org/local/paris2025/>**

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* Revise is almost ready to work on structs, not just functions… This went from “never going to happen” to “standard feature” in the blink of an eye. See [slack discussion](https://julialang.slack.com/archives/C03D578FCDD/p1738836742511929) and the [last PR in the series](https://github.com/JuliaLang/julia/pull/57253).
* JETLS.jl: New [language server for Julia](https://julialang.slack.com/archives/C6FGJ8REC/p1739952975346129) with advanced static analysis in a nascent stage of development and potentially Google Summer of Code positions open for it.
* [“C codegen considered unnecessary”](https://arxiv.org/abs/2502.01128) is a neat example by folks at JuliaHub of the new compile-to-binary capabilities introduced in Julia
* The `@threads` macro can cause normal looking Julia code to have somewhat confusing behavior in an edge case. Namely, redefining variables inside of the newly defined closure and the way that boxing of variables works in Julia break the mental model of “a variable in Julia is just a label to a piece of actual data and assigning a variable does not modify the data, rather it just changes the what is being labeled”. A pretty esoteric source of bugs, with a [possible fix/warning proposed in a recent PR](https://github.com/JuliaLang/julia/pull/57185).
* Pkg now prints if the [precompiled and loaded versions of a library are mismatched](https://julialang.slack.com/archives/C03D578FCDD/p1735656334706059) (frequent source of repeated precompilation when updating packages in a long-lived session). [PR1](https://github.com/JuliaLang/julia/pull/56901) and [PR2](https://github.com/JuliaLang/julia/pull/56926)
* Compiler.jl, the julia compiler now factored out as a stdlib that you can experiment with, is getting its [best practices document](https://github.com/JuliaLang/julia/pull/57520).
* More [caching capabilities for Julia code](https://github.com/JuliaLang/julia/pull/57193) running through customized compilers / AbstractInterpreters, remind me of the much bigger project of setting up a reliable [API for integrating external compilers](https://github.com/JuliaLang/julia/pull/52964).
* Deep [rework and cleanup for `IOBuffer`](https://github.com/JuliaLang/julia/pull/57570) is coming up.
* In case you did not know, besides the subtyping comparator `<:` we have a supertyping comparator `:>` that can be used in type parameterizations. It now also has a little bit more [syntactic sugar support](https://github.com/JuliaLang/julia/pull/57554).
* Suggested best practices for [documenting return value types](https://github.com/JuliaLang/julia/pull/57583).
* BinaryBuilder.jl [is stuck to julia 1.7](https://github.com/JuliaPackaging/JLLPrefixes.jl/issues/6). Work has started on removing these constraints, thanks to [stability guarantees in Pkg internals](https://github.com/JuliaLang/Pkg.jl/pull/4156) enabled by [recent work](https://github.com/JuliaLang/Pkg.jl/pull/4151).
* Internal support for LLVM 19 in the julia compiler is [done](https://github.com/JuliaLang/julia/pull/56130) and [progress is being made for LLVM 20](https://github.com/JuliaLang/julia/pull/57352).
* Support for using various external garbage collection algorithms (thanks to immix) is [growing here](https://github.com/JuliaLang/julia/pull/57327) and [here](https://github.com/JuliaLang/julia/pull/57294).

In search of contributors and new maintainers (specify novice/moderate/expert and internals/domain background necessary):

* The Center for Quantum Networks is [hirring GUI developers](https://discourse.julialang.org/t/gui-developer-for-simulation-tools-at-the-nsf-center-for-quantum-networks/126782) for work on open source network design and simulation frontend, hopefully with positive outcomes to the graphs.jl ecosystem as well.
* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science.
* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* [Google Colab now supports Julia natively](https://discourse.julialang.org/t/julia-in-colab/126600)
* [ComposableAsyncStatus.jl](https://code.tecosaur.net/tec/ComposableAsyncStatus.jl#headline-1) is amazing for [progress reporting from multiple potentially parallel tasks](https://julialang.slack.com/archives/C67910KEH/p1739280864875829).
* [RxInfer.jl just got to v1](https://discourse.julialang.org/t/release-rxinfer-4-0-0-and-updated-documentation/126145), an amazing package for Bayesian inference.
* AcademicIdentifiers.jl – a convenient library to work with [DOI/ORCiD/Arxiv and more](https://code.tecosaur.net/tec/AcademicIdentifiers.jl)
* An in-depth discussion of the details behind [abstol and reltol in ODE solvers](https://discourse.julialang.org/t/setting-abstol-and-reltol-when-solving-the-schrodinger-equation-with-ordinarydiffeq/125534).
* [CImGui v5.0.0](https://github.com/JuliaImGui/CImGui.jl) and [ImPlot v0.6.0](https://github.com/JuliaImGui/ImPlot.jl) are out with many improvements: new [documentation](https://juliaimgui.github.io/ImGuiDocs.jl/cimgui/stable/), updating for latest library versions, using official GLFW/OpenGL backends, cleaning boilerplate code, and even experimental Makie plots integration (see [relevant discussion](https://github.com/JuliaImGui/CImGui.jl/discussions/52#discussioncomment-12066825)). And finally, [ImGuiTestEngine.jl](https://github.com/JuliaImGui/ImGuiTestEngine.jl) is a new testing and automation library. Now it is even easier to develop content creation tools, visualization / debug tools, using lots of widgets and plots with dynamic and interactive behaviour.
* Makie.jl used for some amazing plots in a [recent neutrino physics discovery](https://makie.org/website/blogposts/showcases/).
* A proposal for better support for [file path handling and abstraction](https://discourse.julialang.org/t/designing-a-paths-julep/124335) in Julia.
* The ITensor team is developing new packages for quantum operators and tensor algebra:[ QuantumOperatorAlgebra.jl](https://github.com/ITensor/QuantumOperatorAlgebra.jl),[ QuantumOperatorDefinitions.jl](https://github.com/ITensor/QuantumOperatorDefinitions.jl), and[ TensorAlgebra.jl](https://github.com/ITensor/TensorAlgebra.jl).
* [TerminalSystemMonitor.jl](https://discourse.julialang.org/t/ann-terminalsystemmonitor-jl-displays-usage-of-cpu-ram-and-optionally-gpu/125678) is a neat system resources monitor implemented in Julia.

Abstract Math ecosystem:

* [Matroids.jl](https://github.com/scheinerman/Matroids.jl) is a Julia library for working with matroids using rank functions, supporting fundamental operations and integration with the Julia Graphs ecosystem.
* [TensorAlgebra.jl](https://github.com/ITensor/TensorAlgebra.jl) implements tensor contraction and algebra utilities, including dimension splitting, factorization, and permutation handling.

Julia Autodiff ecosystem:

* [DiffMatic.jl](https://github.com/asterycs/DiffMatic.jl) Symbolic differentiation of vector/matrix/tensor expressions in Julia

Notes from other ecosystems:

* [The two factions of C++](https://herecomesthemoon.net/2024/11/two-factions-of-cpp/)
* [Why I'm writing a Scheme implementation in 2025: Async Rust](https://news.ycombinator.com/item?id=43083017)
* The [UltraScale Playbook](https://bsky.app/profile/thomwolf.bsky.social/post/3likeqqv3dk2y) (tutorials on parallel computing)

Soapboxes (blogs/talks):

* [Julia for R users](https://discourse.julialang.org/t/some-nice-advantages-of-learning-julia-for-the-r-programmers-a-small-article/125628?u=vituri)

See also: [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [minutes of triage meetings](https://hackmd.io/@LilithHafner/HJaw__uMp)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
