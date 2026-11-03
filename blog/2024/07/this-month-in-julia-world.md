@def title = "This Month in Julia World (June 2024)"
@def authors = "Stefan Krastanov"
@def published = "6 July 2024"
@def rss_pubdate = Date(2024, 7, 6)
@def rss = """Community Newsletter for June 2024"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Core repos

* There are considerations of how to remove some of Julia’s warts without a breaking Julia 2.0 release: a “[strict mode](https://github.com/JuliaLang/julia/issues/54903)” and [versioning of export statements](https://github.com/JuliaLang/julia/issues/54905) seem like a pretty big step in that direction.

* The [compiler now has a much neater “engine”](https://github.com/JuliaLang/julia/pull/54816) to track (potentially multithreaded) inference and code generation.

* Much [neater autocompletion](https://github.com/JuliaLang/julia/pull/54800) of emojis on the REPL.

* This is a bit of a prolonged edge case frustration at this point, but progress is made again on fixing the [`Tuple{Union{}}`](https://github.com/JuliaLang/julia/pull/54792) breaking change edge case from 1.10. Discussed previously in the March issue of this newsletter.

* Progress on the “wordage for bindings, not just function methods” discussed in the last month’s issue. Refactoring and cleanup being done for [lowering of consts](https://github.com/JuliaLang/julia/pull/54773). Some related performance improvements to the [use of global variables](https://github.com/JuliaLang/julia/pull/54733).

* Julia now has a more reliable mechanism to [communicate breaks](https://github.com/JuliaLang/julia/pull/53849) to internal unexported nonpublic functionality, hopefully leading to more stable packages that (ab)use unstable implementation details (e.g. JET, Revise, Cthulhu).

* [Improvements to the printing](https://github.com/JuliaLang/julia/pull/54714) of stack overflow traces related to recursion. Some related [PRs](https://github.com/JuliaLang/julia/pull/54712).

* `@atomic` might soon [permit indexing](https://github.com/JuliaLang/julia/pull/54707).

* Improvements to [tuple sorting](https://github.com/JuliaLang/julia/pull/54494).

* Interesting experimentation with new recursive implementations for fold, map, setindex functionality for tuples, related to better loop unrolling capabilities in the compiler and to better type stability. [[1](https://github.com/JuliaLang/julia/pull/54478)] [[2](https://github.com/JuliaLang/julia/pull/54479)] [[3](https://github.com/JuliaLang/julia/pull/54480)] [[4](https://github.com/JuliaLang/julia/pull/54490)]

* An interesting discussion on the interaction between `convert` and `==` and other equality checks on [slack](https://julialang.slack.com/archives/C67TK21LJ/p1717777602292389) and a related [github discussion](https://github.com/JuliaLang/julia/issues/40717) on the type-safety of equality checks.

* JET now has [an official badge](https://github.com/aviatesk/JET.jl/pull/635) you can put in your readmes (together with your Aqua badge). [![Tested with JET.jl badge](https://img.shields.io/badge/%F0%9F%9B%A9%EF%B8%8F_tested_with-JET.jl-233f9a)](https://github.com/aviatesk/JET.jl)

* On master you can start julia with `--trace-compile=stderr --trace-compile-timing` to figure out [how long compilation/precompilation takes](https://github.com/JuliaLang/julia/pull/54662) for each methods.

* A big step forward for the project to plug [external garbage collectors](https://github.com/JuliaLang/julia/pull/54238) into julia. Still, just refactoring for now.

* The standard UUID library now has a [UUID 7](https://github.com/JuliaLang/julia/pull/54834) implementation.

* More detailed documentation of the [new memory backends](https://github.com/JuliaLang/julia/pull/54642) on which vectors are implemented.

* An interesting example of [using `@constprop` annotation](https://github.com/JuliaLang/julia/pull/54635) to improve the type stability of a function.

## Dustbin of history

* Unicode subscripts and superscripts are wonderful when writing more legible code, but frustratingly a few random latin letters are not available… Some time ago the Julia community started preparing a [proposal to the unicode consortium](https://github.com/stevengj/subsuper-proposal) to remedy that situation, but it has lately lost steam (any volunteers?).

## In search of contributors

* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.

* ChainRules, a foundational package to the Julia autodiff effort is looking for a [new primary maintainer](https://discourse.julialang.org/t/chainrules-project-looking-for-a-new-primary-maintainer/115636).

## Ecosystem

* [GTPSA](https://discourse.julialang.org/t/gtpsa-jl-a-julia-interface-to-the-new-gtpsa-library-for-fast-high-order-automatic-differentiation/115370) is a new library for Taylor-style autodiff, with a new Julia interface.

* Julia was used to [prototype the new audio codec](https://discourse.julialang.org/t/julia-used-to-prototype-whatsapp-audio/115626) in WhatsApp.

* Significant improvements to linear algebra on multinode computing clusters with Dagger.jl, [discussed on slack](https://julialang.slack.com/archives/C677F4ABD/p1719340733844509).

* AlgebraOfGraphics.jl plotting library is getting a healthy refresh, [discussed on slack](https://julialang.slack.com/archives/C8RQUU2KH/p1719416651396969).

* A [slack discussion](https://julialang.slack.com/archives/C6G240ENA/p1719468441542609) of improvements in DifferentiationInterface.jl – this package is becoming a valuable cornerstone for the autodiff efforts in Julia.

* Some recent publicity about Julia in HPC, [discussed on slack](https://julialang.slack.com/archives/CBFP2PTTR/p1719144962104219).

## Other ecosystems

* NumPy 2.0 breaking release is out. Discussed on [hacker news](https://news.ycombinator.com/item?id=40699470).

## Blogs and talks

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack. [Minutes are kept](https://hackmd.io/@LilithHafner/HJaw__uMp).

* Julia [tshirts](https://cormullion.github.io/pages/2024-06-03-rejects/) made with Luxor.jl

## Sundry

* A “[Julia for HPC](https://discourse.julialang.org/t/ann-training-course-julia-for-hpc-in-stuttgart-germany-on-sept-10-13-2024/115311)” training course will run in Germany in September.

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
