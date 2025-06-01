@def title = "This Month in Julia World"
@def authors = "Stefan Krastanov"
@def published = "1 June 2025"
@def rss_pubdate = Date(2025, 6, 1)
@def rss = """Community Newsletter for May 2025"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what a clique of us found interesting this month, with contributions from the community.

For recent news on Julia and interesting conversations with community members, check out the [JuliaDispatch](https://juliadispatch.fm/) podcast (on many platforms, including [youtube](https://www.youtube.com/@JuliaDispatch/) and [spotify](https://open.spotify.com/show/6Y1zWtFhjqPLsFQWRvZmws)). Highlights from the newsletter get discussed (with more context) during some episodes.

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* Julia 1.12-beta3 [has been released](https://discourse.julialang.org/t/julia-v1-12-0-beta3-is-now-available/128941).
* Julia [may get an await mechanism](https://github.com/JuliaLang/julia/pull/58532) similar to C++’s coroutines. These are low-level resumable functions, which are generally useful to implement asynchronous software, and may e.g. be used by Julia’s existing Task infrastructure, or Python yield-style generators. This would be a much better alternative than the fairly hackish [ResumableFunctions.jl](https://github.com/JuliaDynamics/ResumableFunctions.jl/) library.
* Work has started on much more [fine-grained caching of compiled code](https://github.com/JuliaLang/julia/pull/58592) (i.e. work like this can enable recompiling only parts of a module after an edit).
* The manual now has a more [detailed section on world age and binding partitioning](https://github.com/JuliaLang/julia/pull/58253/files).
* The Julia task scheduler is fairly good, but [work stealing](https://en.wikipedia.org/wiki/Work_stealing) could make it even better. A [new work-in-progress PR](https://github.com/JuliaLang/julia/pull/58500) implements it. This is the fourth attempt at implementing work stealing [[1](https://github.com/JuliaLang/julia/pull/55542), [2](https://github.com/JuliaLang/julia/pull/50221), [3](https://github.com/JuliaLang/julia/pull/43366)], so let’s hope it lands this time.

* The hash algorithm is [changing](https://github.com/JuliaLang/julia/pull/57509)! In many cases the performance should improve substantially, particularly on Strings and [AbstractArrays](https://github.com/JuliaLang/julia/pull/57509)
* Atomic operations on mutable structs with fields marked @atomic [now generate efficient code](https://github.com/JuliaLang/julia/pull/57010), and the old Threads.Atomic type is therefore no longer special.
* The implementation of ‘reduce-like’ functions such as reduce, foldl, and sum has long [had several issues](https://github.com/JuliaLang/julia/issues?q=is%3Aissue%20label%3Afold) with performance and consistency. [A new WIP PR](https://github.com/JuliaLang/julia/pull/58418) completely reworks them, closing 17 issues at once.
* A push to lazily load more JLL libraries in the standard libraries [[1](https://github.com/JuliaLang/julia/pull/58405), [2](https://github.com/JuliaLang/julia/pull/58444/files)] and [elsewhere](https://github.com/JuliaSparse/SparseArrays.jl/pull/626), and [precompile JLL related code](https://github.com/JuliaLang/julia/pull/58436) improves latency a fair bit.
* [Work on various versions of `cat` with static size information](https://github.com/JuliaLang/julia/pull/58422) (number of rows or columns being concatenated) for potentially faster initialization of array literals.
* A proposal for library authors to be able to control [how type parameters are printed in stack traces](https://github.com/JuliaLang/julia/pull/58389).
* Should `collect` be able to return other AbstractArray types than Array? This question has [come up again](https://github.com/JuliaLang/julia/pull/58513), and has previously been discussed several times before [[1](https://github.com/JuliaLang/julia/issues/36448), [2](https://github.com/JuliaLang/julia/issues/50051), [3](https://github.com/JuliaLang/julia/issues/47777)].
* In a [discourse discussion](https://discourse.julialang.org/t/question-about-the-future-of-juliac/129228/4?u=krastanov) on julia and juliac, Matt gives a nice summary of some of the ways to execute/compile julia code.
* A somewhat overdue [warning to the docstring of `deepcopy`](https://github.com/JuliaLang/julia/pull/58416/files) - please avoid using it, `copy` is probably what you need.

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* [AirspeedVelocity.jl](https://discourse.julialang.org/t/easy-github-benchmarking-with-new-airspeedvelocity-jl/129327) is a CI-focused package-benchmarking utility that now comes with a Github action that can run and post benchmarks in your pull requests.
* [Trash.jl](https://discourse.julialang.org/t/ann-trash-jl/129104) - the most feature-complete cross-platform file-trashing library in existence.
* [SmallCollections.jl](https://discourse.julialang.org/t/ann-smallcollections-jl-fast-small-vectors-sets-and-dictionaries/128787) - static implementation for small vectors, sets, and dicts, without allocations, and satisfying `isbitstype`.
* [pluto.land](https://discourse.julialang.org/t/ann-pluto-land-new-simple-website-to-share-pluto-html-notebooks/129138) is web service for hosting static HTML exports of Pluto notebooks by the Pluto team.
* [SankeyMakie.jl](https://discourse.julialang.org/t/ann-sankeymakie-jl/129209) for Sankey-style flow diagrams in Makie.
* [ExchangeRates.jl](https://discourse.julialang.org/t/ann-exchangerates-jl/129317) for simple conversion between currencies.
* [JSON.jl](https://github.com/JuliaIO/JSON.jl/pull/374) will have a breaking release fixing many outstanding issues with it and JSON3.
* [TensorMixedStates.jl](https://github.com/jerhoud/TensorMixedStates.jl) is a new package for simulating open quantum system based on ITensor
* The main Julia repository now contains an [AGENTS.md](https://github.com/JuliaLang/julia/pull/58561/files) file to guide AI agents on how to develop Julia. It is also an interesting way to distill dev tips.

Numerical Math ecosystem:

* [RationalFunctionApproximation.jl](https://discourse.julialang.org/t/ann-rationalfunctionapproximation-jl-v0-2/129078) is a tool for automatic approximation of functions by ratios of polynomials, now out at v0.2

Autodiff ecosystem:

* A recent publication on [sparse matrix autodiff and coloring](https://arxiv.org/pdf/2505.07308).

See also: [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [minutes of triage meetings](https://hackmd.io/@LilithHafner/HJaw__uMp)

Please feel free to post below with your own interesting finds, or in-depth explanations, or questions about these developments.

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
