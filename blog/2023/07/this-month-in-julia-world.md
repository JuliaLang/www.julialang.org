@def title = "This Month in Julia World (June 2023)"
@def authors = "Stefan Krastanov"
@def published = "27 June 2023"
@def rss_pubdate = Date(2023, 6, 27)
@def rss = """Community Newsletter for June 2023"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* Wonderful learning materials on how to become a Julia compiler hacker (especially the first comment by ToucheSir). [discourse](https://discourse.julialang.org/t/compiler-tools-and-workflow-for-compiler-optimization/100016)

* Some musings on support for Interfaces in Julia by Keno, Valentin (of AVR fame), Rafael, and Mark. [slack/general](https://julialang.slack.com/archives/C67910KEH/p1685526477993929)

* Escape analysis and its potential future use in minimizing allocations briefly discussed. [slack/general](https://julialang.slack.com/archives/C67910KEH/p1687852217103719)

* Discussion on current options for a trait system in Julia and potential future work (under an ASML job posting on the topic). [slack/jobs](https://julialang.slack.com/archives/C8P49NJHG/p1686142264144369)

* Keno discusses the many problems with the `--check-bounds` flag in julia and first steps in dealing with these issues. [github](https://github.com/JuliaLang/julia/pull/50239)

* A long discussion on how to properly define “public” API in a more standardized way. Valentin Sukera wrote a very detailed proposal that generated many downstream ideas. There is no consensus yet, but many fruitful nearterm steps that volunteers can undertake were brought up. [github](https://github.com/JuliaLang/julia/issues/49973) (and a related discussion on [discourse](https://discourse.julialang.org/t/a-kind-of-two-language-problem-in-julia-ecosystem/100445) and related ideas in this [PR](https://github.com/JuliaLang/julia/pull/50105))

* A discussion on the potential for a stable public API for the effects system in the compiler. [slack](https://julialang.slack.com/archives/C67910KEH/p1686593181570309?thread_ts=1686591563.885149&cid=C67910KEH) (and a related discussion on [github](https://github.com/JuliaLang/julia/issues/49273))

* More discussion of SumTypes.jl (and Unityper.jl, and Expronicon.jl) as tools for avoiding boxing and dynamic dispatch when having large unions or arrays of disparate types. (see also: abstract data types, union splitting) [zulip](https://julialang.zulipchat.com/#narrow/stream/137791-general/topic/SumTypes.2Ejl.20updates/near/345285237)

## Core repos

* [merged] Claire’s [absolutely heroic work](https://github.com/JuliaLang/julia/pull/46372#issuecomment-1580312174) on merging the new parser ~~~<del>continues</del>~~~ is finished (for a certain definition of the word “finished”)!

* [draft] For a while now Julia multithreading tasks can switch between different threads (providing for dynamic scheduling), but this also has led to [folks having races in their code due to naive thread-local storage setups that are not safe anymore](https://github.com/JuliaLang/julia/pull/48542#issuecomment-1569101718). There is some work on documenting this and providing a best practices guide ([blog draft](https://github.com/JuliaLang/www.julialang.org/pull/1904)), as well as [new neater API](https://github.com/JuliaLang/julia/pull/50052).

* [dispersed] A lot of small incremental improvements to the garbage collector by doggedly persistent folks. [1](https://github.com/JuliaLang/julia/pull/48600), [2](https://github.com/JuliaLang/julia/pull/48969), [3](https://github.com/JuliaLang/julia/pull/49644), [4](https://github.com/JuliaLang/julia/pull/50137), [5](https://github.com/JuliaLang/julia/pull/50144)

* [docs] [Documenting](https://github.com/JuliaLang/julia/pull/50168) the Julia JIT (for the first time?).

## Dustbin of history

* Before the recent amazing improvements to TTFX (precompilation caching thanks to pkgimages in Julia 1.9), a lot of work went into potential faster/incremental compilation of sysimages. See [Keno’s](https://github.com/JuliaLang/julia/pull/40414) and [Petr’s](https://github.com/JuliaLang/julia/pull/46045) and [Jameson’s](https://github.com/JuliaLang/julia/pull/38119) work. That work had to be abandoned because of the clashing pkgimage changes, but it might [one day be revived](https://github.com/JuliaLang/julia/pull/49953). Context: Pkgimages make loading time (i.e. `using SomePackage`) a bit slower, but make time-to-first-X (a.k.a. TTFX, i.e. the first call to `SomePackage.somefunction()`) instant. Sysimages make both instant, but are very slow to compile and they set your environment in stone (need recompilation on each Pkg add/update).

* For a while there has been a desire to have more detailed [“provenance tracking”](https://github.com/JuliaLang/julia/issues/31162) for low level generated code, i.e. knowing what source code it comes from. With the improvements brought by JuliaSyntax, maybe this can be tackled soon.

## Ecosystem

* A great set of [auto differentiation lecture notes](https://adrhill.github.io/julia-ml-course/L6_Automatic_Differentiation/) including both theory and Julia ecosystem examples. [slack](https://julialang.slack.com/archives/C6G240ENA/p1685627057690829)

* A new, very fast and polished Hidden Markov Chain package. [discourse](https://discourse.julialang.org/t/ann-hiddenmarkovmodels-jl-when-did-hmms-get-so-fast/100191)

* An alternative to Unitful.jl which is much easier to keep type-stable (units are not encoded in the type). [discourse](https://discourse.julialang.org/t/ann-dynamicquantities-jl-type-stable-physical-quantities/99963)

* [OpenCV.jl](https://github.com/JuliaImages/OpenCV.jl) is now maintained by JuliaImages. [slack/image-processing](https://julialang.slack.com/archives/CB1R90P8R/p1685468068195209)

* JuliaFolds is maintained again (as JuliaFolds2) and in need of more helpers. [zulip](https://julialang.zulipchat.com/#narrow/stream/137791-general/topic/Request.20for.20help.20with.20JuliaFolds2/near/357978488)

* SimJulia is maintained again (under the JuliaDynamics org), renamed to [ConcurrentSim](https://github.com/JuliaDynamics/ConcurrentSim.jl). [ResumableFunctions](https://github.com/JuliaDynamics/ResumableFunctions.jl) is also maintained once again (under the same org).

* Jacob Zelko has kicked off monthly JuliaHealth community organization meetings

## Blogs and talks

* [JuliaCon 2023](https://juliacon.org/2023/) is approaching (in July, in person and online). The [JuMP-Dev](https://jump.dev/meetings/jumpdev2023/) conference and the SciML conference happen concurrently with it.

* Chris’s SciML / Digiwell seminar talk “[The Continuing Advancements of Scientific Machine Learning (SciML)](https://www.youtube.com/watch?v=yHiyJQdWBY8)”

* Wonderful little video intro/tutorial by Jacobus on latency in Julia (great for newcomers). [discourse](https://discourse.julialang.org/t/video-how-to-reduce-julias-latency/100298) or [youtube](https://www.youtube.com/watch?v=_3vJSBk0Bls)

* A blog post on “Modern Julia workflows” is being considered, prompted partially by the video above, currently in a very early [draft stage](https://github.com/JuliaLang/www.julialang.org/issues/1908).

## Sundry

* JuliaHub is hiring an [EDA core system & compiler engineer](https://jobs.juliacomputing.com/jobs/Iyii70VtHMgj/eda-core-system-compiler-engineer-remote) and a [Senior Cloud Engineer](https://jobs.juliacomputing.com/jobs/k_NT-998DQPl/senior-cloud-engineer-remote).

* ASML is hiring an intern to work on [trait systems for Julia](https://julialang.slack.com/archives/C8P49NJHG/p1686142264144369).

* A [Pluto Notebook Competition](https://help.juliahub.com/juliahub/stable/pluto2023/) is running the next few weeks, for the best, most engaging example of a Pluto notebook project.

* Put changelogs in your package’s documentation! [slack thread](https://julialang.slack.com/archives/C6FGJ8REC/p1687399466834029)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
