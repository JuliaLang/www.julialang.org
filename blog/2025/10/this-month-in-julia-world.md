@def title = "This Month in Julia World (September 2025)"
@def authors = "Stefan Krastanov"
@def published = "1 October 2025"
@def rss_pubdate = Date(2025, 10, 1)
@def rss = """Community Newsletter for September 2025"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what a clique of us found interesting this month, with contributions from the community.

For recent news on Julia and interesting conversations with community members, check out the [JuliaDispatch](https://juliadispatch.fm/) podcast (on many platforms, including [youtube](https://www.youtube.com/@JuliaDispatch/) and [spotify](https://open.spotify.com/show/6Y1zWtFhjqPLsFQWRvZmws)). Highlights from the newsletter get discussed (with more context) during some episodes.

Julia 1.12 is released. Many of the improvements in it have been discussed in the past on this newsletter. [Check out the blogpost for a good summary](https://julialang.org/blog/2025/10/julia-1.12-highlights/). 

[Properly cut JuliaCon 2025 videos are being released on youtube.](https://discourse.julialang.org/t/juliacon-global-2025-videos-will-start-releasing-today/132454)

[JuliaCon 2026 will happen from August 10th to August 15th 2026 in Germany](https://discourse.julialang.org/t/juliacon-2026-save-the-date/132172).

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* [JuliaLowering.jl](http://github.com/c42f/JuliaLowering.jl/pull/93) has been seeing a flurry of activity in the last couple of months. Julia has a syntactic pass that parses text into an abstract syntax tree and a lowering pass that takes care of macros and desugaring. Historically this was done in lisp, leading to difficulty with introspection and tooling like Revise.jl, also making macros harder to debug. JuliaSyntax.jl reimplemented the parser in pure Julia and JuliaLowering.jl is the final piece of the puzzle, implementing all of the “lowering” in Julia itself. The link above is to one of many improvements from the last few weeks, this one in particular focusing on simplifying and more neatly organizing the lowering logic.
* Julia is on track to have the fanciest REPL history search in the land with [recent proposed changes](https://github.com/JuliaLang/julia/pull/59819).
* TypedCallable, is a [proposal](https://github.com/JuliaLang/julia/issues/59774) for better supporting optimized calls to runtime-known functions with compile-time known arguments. The underlying goal is to better support closures, especially with ahead-of-time compilation to binaries.
* Julia supports [Unicode 17 now](https://github.com/JuliaLang/julia/pull/59534). Julia programmers have long lamented that Unicode does not support proper latin alphabet superscripts for all letters. [Small superscript q is supported now though](http://github.com/JuliaLang/julia/pull/59544). See [this wiki page](https://en.wikipedia.org/wiki/Unicode_subscripts_and_superscripts#Latin,_Greek,_Cyrillic,_and_IPA_tables) for a full list of unicode sub/super script characters.
* `Base.Cartesian` is now a [public part of the Julia API](https://github.com/JuliaLang/julia/pull/59459).
* PSA: Given that there is no type filtering capabilities in julia’s `try`, [it is important to not forget to use `rethrow()`](https://github.com/JuliaLang/julia/pull/59729/files).
* The `:greedy` scheduler now [better prioritizes having work for all threads](https://github.com/JuliaLang/julia/pull/59515).
* Do not use `Base.get_extension` in library code, as it can wreak havoc on precompilation. Appropriate [solution discussed in this PR](https://github.com/JuliaLang/julia/pull/59593).
* Cleaning up some (unsafe) [constructor functions](https://github.com/JuliaLang/julia/pull/59663) for strings and substrings.

In search of contributors and new maintainers (specify novice/moderate/expert and internals/domain background necessary):

* The [Graphs.jl](http://graphs.jl) repo features a few bounties on [integrating external graph theory libraries](https://github.com/JuliaGraphs/Graphs.jl/issues?q=is%3Aissue%20state%3Aopen%20label%3Abounty) better with the rest of the Graphs ecosystem.
* [JuliaPackageComparisons](https://discourse.julialang.org/t/juliapackagecomparisons-is-looking-for-a-new-maintainer/130667) is a wiki-like resource comparing different julia tools. It is in search of a new maintainer.
* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science.
* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* [Many improvements to the PythonCall ecosystem](https://discourse.julialang.org/t/pythoncall-ecosystem-updates/132500) for integration (in both directions) between Julia and Python.
* JSON.jl had a breaking release with many improvements. It comes with [a fantastic migration guide](https://juliaio.github.io/JSON.jl/stable/migrate/#Migration-guides).
* [Bonito.jl](https://discourse.julialang.org/t/ann-bonito-jl/132946) has existed for a while as a wonderful way to have reactive web pages written in Julia, but now there is a proper announcement after steady small improvements for many years.
* [SymBoltz.jl](https://discourse.julialang.org/t/ann-symboltz-jl-a-symbolic-numeric-approximation-free-and-differentiable-linear-einstein-boltzmann-solver-for-cosmology/132819) – a very impressive showcase of the capabilities of ModelingToolkit.jl, a symbolic-numeric, approximation-free and differentiable linear Einstein-Boltzmann solver for cosmology
* [AccessibleModels.jl](https://discourse.julialang.org/t/accessiblemodels-jl-automatic-ui-and-model-fitting-for-arbitrary-objects/132363): Automatic UI and Model Fitting for Arbitrary Objects
* [MoleculeHub](https://discourse.julialang.org/t/ann-moleculehub-a-set-of-cheminformatics-tools-in-julia/132415): A set of cheminformatics tools in Julia
* [Durbyn.jl](https://discourse.julialang.org/t/ann-durbyn-jl-time-series-forecasting-in-julia/132544): Time Series Forecasting in Julia
* [PlutoBook.jl](https://discourse.julialang.org/t/ann-new-package-plutobook-jl/132641) wraps around the C++ library PlutoBook for lightweight converter between html and pdf. (no relationship to [Pluto.jl](http://pluto.jl))
* [NoSleep.jl](https://discourse.julialang.org/t/nosleep-jl-keep-julia-awake-for-long-calculations/132911): Keep Julia awake for long calculations
* [WebAuthn.jl](https://discourse.julialang.org/t/ann-webauthn-jl/132672): WebAuthn enables passwordless, phishing-resistant login using public-key cryptography.

See also: [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [Turing.jl newsletter](https://github.com/TuringLang/Turing.jl/issues/2498)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
