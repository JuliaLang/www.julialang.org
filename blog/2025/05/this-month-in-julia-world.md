@def title = "This Month in Julia World"
@def authors = "Stefan Krastanov"
@def published = "1 May 2025"
@def rss_pubdate = Date(2025, 5, 1)
@def rss = """Community Newsletter for April 2025"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what a clique of us found interesting this month, with contributions from the community.

For recent news on Julia and interesting conversations with community members, check out the [JuliaDispatch](https://juliadispatch.fm/) podcast (on many platforms, including [youtube](https://www.youtube.com/@JuliaDispatch/) and [spotify](https://open.spotify.com/show/6Y1zWtFhjqPLsFQWRvZmws)). Highlights from the newsletter get discussed (with more context) during some episodes.

JuliaCon Local Paris 2025:

* The call for proposals is still open until May 15th! [Submit your talk, tutorial or poster while you can](https://juliacon.org/local/paris2025/cfp/).
* Tickets are now available! [Get yours here](https://juliacon.org/local/paris2025/tickets/)!

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* Julia 1.11.5 and 1.12-beta2 have been released.

* The API for the compiler’s lowering has been reworked [[1](https://github.com/JuliaLang/julia/pull/58147), [2](https://github.com/JuliaLang/julia/pull/58207)], paving the way for experimental use of [JuliaLowering.jl](https://github.com/c42f/JuliaLowering.jl) as the default lowering implementation. JuliaLowering is intended to improve code provenance in Julia, which will have a big impact on future developer tooling. See the [JuliaCon 2024 video](https://www.youtube.com/watch?v=I6-zV0SPpFA). A recent [discussion on discourse](https://discourse.julialang.org/t/understanding-bindings-in-julialowering-jl/126941) also delves deeper in the inner workings of JuliaLowering. JuliaLowering is also an important part of the experimental [JET-based language server](https://github.com/c42f/JuliaLowering.jl/pull/10), which would provide much better dev feedback in IDEs.
* The [StyledStrings standard library committed piracy](https://github.com/JuliaLang/StyledStrings.jl/issues/61) against Base and was type unstable. This led to invalidations and contributed to the higher latency of Julia 1.11 and 1.12 compared to 1.10. The latency impact has now been [deemed untenable](https://github.com/JuliaLang/julia/issues/57998), so work is ongoing to fix the piracy and invalidations [[1](https://github.com/JuliaLang/julia/pull/58112), [2](https://github.com/JuliaLang/julia/pull/56194), [3](https://github.com/JuliaLang/julia/pull/58134)]
* The discussion on optional modules has bubbled up again [[1](https://github.com/JuliaLang/julia/pull/58051), [2](https://github.com/JuliaLang/julia/issues/55516)]. This is related to the older discussion of [precompile-only packages](https://github.com/JuliaLang/julia/issues/48163) as well as package extensions, all mechanisms to reduce the number of dependencies, and thereby improve precompile times and latency.
* There have been many posts about the increasing load latency since the release of Julia 1.10 [[1](https://discourse.julialang.org/t/startup-time-of-1000-packages-53-slower-in-julia-1-12-vs-1-10/128343/), [2](https://discourse.julialang.org/t/slower-times-to-ttfx-for-gmt-in-1-11-and-even-more-in-nightly/126350), [3](https://github.com/JuliaLang/julia/issues/58201), [4](https://github.com/JuliaLang/julia/issues/57436), [5](https://github.com/JuliaLang/julia/issues/57970), [6](https://github.com/JuliaLang/julia/issues/58163)]. This issue is well known to the compiler team who are looking into it. One particularly nice outcome of this is the creation of a repository of “representative examples of a package’s use” for benchmarking Julia’s performance on load, compilation, and more. There is even a [simple webpage for direct submission of such code snippets](https://discourse.julialang.org/t/startup-time-of-1000-packages-53-slower-in-julia-1-12-vs-1-10/128343/51?u=krastanov).
* Detailed new documentation on the [“world age” mechanism in julia](https://github.com/JuliaLang/julia/pull/58253/files).
* Further progress on [support for LLVM v20](https://github.com/JuliaLang/julia/pull/58142) is near.
* Unexpectedly, a few ‘optimised’ methods in Base have been found to be slower than the naive implementations, providing rare opportunities to optimise code simply by deleting stuff [[1](https://github.com/JuliaLang/julia/pull/50509), [2](https://github.com/JuliaLang/julia/pull/58280), [3](https://github.com/JuliaLang/julia/pull/58267)].
* A talk for non-julian audiences on the [recent progress on static compilation](https://www.youtube.com/watch?v=LluyXFj9YDI) at PyData Global by Jeff.
* [Why are static arrays immutable?](https://discourse.julialang.org/t/why-are-statically-sized-arrays-immutable/128331) - a short discourse post in which Oscar and Mason give very informative short answers about stack and heap allocations in julia and other languages.

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* [TestPicker.jl](https://discourse.julialang.org/t/ann-testpicker-interactive-tool-for-testing-based-on-fzf-and-bat/128273/3) - a neat dev tool for interactively running a subset of tests matching a fuzzy search.
* [BorrowChecker.jl](https://discourse.julialang.org/t/ann-borrowchecker-jl-a-borrow-checker-for-julia/127897) - a runtime borrow checker (similar to Rusts compile borrow checker) that can be disabled in release code, but kept enabled during development and testing to detect bugs and structural issues in your library code.
* The Pluto notebook is getting AI coding assistance features. They are taking a very cautious approach of putting in only limited-scope features of high value right now, e.g. [automatically fixing syntax errors](https://github.com/fonsp/Pluto.jl/pull/3201).
* [AskAI.jl](https://discourse.julialang.org/t/ann-askai-your-direct-ai-support-in-repl/128042) for interactive queries to LLMs and executing code returned by them.
* [RxInferServer and a Python SDK](https://discourse.julialang.org/t/ann-rxinferserver-python-sdk-fast-inference-from-python-and-more/127969): remote execution of probabilistic modules and support for consumers from other languages.
* [ZeroDimensionalArrays.jl](https://discourse.julialang.org/t/ann-zerodimensionalarrays-jl-zero-dimensional-arrays-references-boxes/128002) - tiny package, implementing several similar types, each being a zero-dimensional array, as a semantically neater alternative to the many meanings `Base.Ref` has.
* [PawsomeTracker.jl](https://discourse.julialang.org/t/ann-pawsometracker-jl/127929) for target tracking in videos.
* [StructuralVibration.jl](https://discourse.julialang.org/t/ann-structuralvibration-jl/127978) released recently for work on modeling various problems in mechanics.
* [ClickeTrees.jl](https://discourse.julialang.org/t/ann-announcing-cliquetrees-jl-tree-decompositions-in-julia/128808) - tree decomposition tools
* [SmallCollections.jl](https://discourse.julialang.org/t/ann-smallcollections-jl-fast-small-vectors-sets-and-dictionaries/128787) - fast small vectors, sets and dictionaries

Abstract Math ecosystem:

* [LieGroups.jl](https://discourse.julialang.org/t/ann-liegroups-jl/128294) - an interface to work with and define Lie groups as well as a library of Lie groups

Numerical Math ecosystem:

* [ConvolutionInterpolations.jl](https://discourse.julialang.org/t/ann-convolutioninterpolations-jl-smooth-multi-dimensional-high-order-of-accuracy-interpolation/128003): Smooth multi-dimensional high order of accuracy interpolation.
* [Breakers.jl](https://discourse.julialang.org/t/ann-breakers-jl/127874) for binning continuous data, a pure Julia partial implementation of the R classInt library, that handles fisher, kmeans, quantile and equal breaks of a vector (potentially containing missing values).
* [NumericalDistributions.jl](https://discourse.julialang.org/t/ann-numericaldistributions-jl-user-defined-distributions/128025): a Distributions.jl-compatible tool for defining custom probability distributions from arbitrary numerical functions.
* [Numerical Linear Algebra class in Julia at TUM](https://discourse.julialang.org/t/numerical-linear-algebra-class-in-julia-tum/128661)

Notes from other ecosystems:

* [PhysLean](https://github.com/HEPLean/PhysLean): Digitizing physics in Lean 4 – formalizing calculations, theorems, and proofs!
* [CubeCL](https://news.ycombinator.com/item?id=43777731): the Rust version of KernelAbstractions

Events:

* The QNumerics summer school on numerical methods in quantum information science is [open for registration](https://qnumerics.org/).

See also: [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [minutes of triage meetings](https://hackmd.io/@LilithHafner/HJaw__uMp)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
