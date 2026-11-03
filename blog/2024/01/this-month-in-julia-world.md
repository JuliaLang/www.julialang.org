@def title = "This Month in Julia World (December 2023)"
@def authors = "Stefan Krastanov"
@def published = "24 December 2023"
@def rss_pubdate = Date(2023, 12, 24)
@def rss = """Community Newsletter for December 2023"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

A bit early this month. Enjoy the holidays.

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* Indexing into unicode strings is complicated. Do you want O(1) indexing capabilities or only fast iteration? Do you want to get the byte in the utf8 representation or a unicode codepoint or a self-contained human-readable glyph? Here is [a discourse discussion on possible improvements](https://discourse.julialang.org/t/stringindex-idea-julia-2-0/107185/11) to the indexing API for julia strings.

* Each function in Julia is the single instance of a singleton type assigned to it. This permits dispatching in higher-order functions and high-performance functional programming (as methods can dispatch and specialize on `typeof(func)`). [The occasional need to construct an instance of these singleton types](https://discourse.julialang.org/t/instantiating-function-from-type/107532) is discussed on discourse (with links to previous discussions). Relatedly, there is a desire to [add an `instancemethods` function](https://github.com/JuliaLang/julia/pull/52304) that gives all methods defined for a function when only the function singleton type is available (skipping the need to instantiate the function).

* A [discussion on the #internals channel](https://julialang.slack.com/archives/C688QKS7Q/p1702270601458879) on slack on customizing the compilation of methods by creating your own AbstractInterpreter. (Julia’s compiler & type-inference infrastructure has been evolving to be much friendlier to external modification, e.g. to support Difractor & Enzyme for autodiff or GPUCompiler & StaticCompiler for generating machine code for “weird” targets).

## Core repos

* Compilers frequently need hash tables of simple structs (e.g. containing a couple of integers or pointers). There is a [neat super-fast super-simple hashing algorithm](https://nnethercote.github.io/2021/12/08/a-brutally-effective-hash-function-in-rust.html) used in Firefox that then found its way to the Rust compiler, that is now being considered in Julia (see [here](https://github.com/JuliaLang/julia/pull/52496) and [here](https://github.com/JuliaLang/julia/issues/52440)).

* A new [`hasdocs` function](https://github.com/JuliaLang/julia/pull/52139) that checks whether a symbol has a docstring.

* Potentially a very exciting development in the compiler that might [make it possible to optimize away some array allocations](https://github.com/JuliaLang/julia/pull/52382) (early-stage and incomplete yet, not yet providing speedup). New Julia programmers quickly learn that avoiding heap allocations is one of the best ways to make your code faster. However, arrays in Julia are always heap allocated because the compiler currently does not know how to stack allocate objects whose size is dynamic and not encoded in its type. See this [JuliaCon Einhoven talk on custom allocators](https://www.youtube.com/watch?v=n1nG0_Nwzhs) in Julia for why stack allocations are fast (and usually not even counted in benchmarks) and why heap allocations are slow. This blog post discusses [good ways to benchmark](https://spmd.org/posts/multithreadedallocations/) these capabilities.

* Better capabilities to study and profile the performance of the garbage collector in Julia [here](https://github.com/JuliaLang/julia/pull/52390) and [here](https://github.com/JuliaLang/julia/pull/52567).

* There has been a longstanding complaint that Julia is using `nothing` in a way that can be confusing - e.g. a search into a collection might return `nothing` to represent that the searched-for element does not exist or it might return `nothing` to represent that the searched-for element is actually `nothing` itself. This is related to the complaint that Base does not use an `Optional` type in its API. Anyway, the standard workaround is to use [`Some`](https://docs.julialang.org/en/v1/base/base/#Base.Some) and some of the helper methods are [getting some improvements to type-stability now](https://github.com/JuliaLang/julia/pull/52381).

* Using `] add …` to add a package to a Project.toml now automatically also [provides a `compat` entry](https://github.com/JuliaLang/Pkg.jl/pull/3732) as well.

* Compiling into [WebAssembly from Julia is getting better and better](https://github.com/tshort/WebAssemblyCompiler.jl). Still experimental though.

## Dustbin of history

* Fidgeting with the `max_methods` constant (globally or per module) can let you trade type inference precision for type inference performance (and vice versa). It was [globally lowered long time ago](https://github.com/JuliaLang/julia/pull/36208). A fun [experiment of setting it extremely low](https://github.com/JuliaLang/julia/pull/48320) was done at the start of the year. Playing with it was one of the [core early ideas for optimizing inference performance](https://github.com/JuliaLang/julia/issues/33326). Further related ideas about changing the way inference is done can be seen [here](https://github.com/JuliaLang/julia/issues/34742). Two years ago it became possible to [modify `max_methods` per module](https://github.com/JuliaLang/julia/pull/43370) so that package authors can fine-tune the inference time-precision tradeoff for their packages.

* A pretty [wild old discussion](https://github.com/JuliaLang/julia/issues/24614) on the possibility to change the (rather special) rules for Tuple subtyping comparisons.

* Wouldn’t it be nice to be able to write [`func^n` to create an iterated function](https://github.com/JuliaLang/julia/pull/39042)…

* There is some revived interest in [profile-guided optimization and link-time optimization for Julia](https://github.com/JuliaLang/julia/pull/45641).

## Ecosystem

* A truly wonderful way to add animations of your terminal to Documenter.jl pages with [Asciicast.jl](https://discourse.julialang.org/t/ann-asciicast-jl/107529)

* A new string templating engine - [Oteraengine.jl](https://discourse.julialang.org/t/ann-oteraengine-jl-template-engine-for-julia/107248). Consider Moustache.jl as another alternative.

* For working with repeated decimal notation for fractions, now we have [RepeatedDecimalNotations.jl](https://discourse.julialang.org/t/ann-repeatingdecimalnotations-jl/108011).

* A wonderful [github CI action to run your tests against **oldest** possible compatible packages](https://github.com/cjdoris/julia-downgrade-compat-action). Provides for a great way to check for outdated lower bounds on your `[compat]` entries. Used by SciML and other parts of the ecosystem already.

## Blogs and talks

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack.

* The recordings from the [JuliaCon Eindhoven talks are online](https://www.youtube.com/playlist?list=PLP8iPy9hna6Tp3QV4akXAd23_O5Vjm_e2).

* Jeff’s talk at JuliaCon Eindhoven was very informative about the progress in [ahead-of-time compilation of small binaries](https://www.youtube.com/watch?v=kNslvU3WD4M&list=PLP8iPy9hna6Tp3QV4akXAd23_O5Vjm_e2&index=1) in Julia.

* Chris’s talk at JuliaCon Eindhove on [NonlinearSolve.jl is a great update on SciML’s unification](https://www.youtube.com/watch?v=O-2F8fBuRRg&list=PLP8iPy9hna6Tp3QV4akXAd23_O5Vjm_e2&index=17) of an API (and a set of best-in-class GPU-capable algorithms) for differential equations, linear solvers, nonlinear solvers, integrators, and optimizers.

* A neat blogpost on solving the [“N Queens” problem purely in Julia’s type domain](https://github.com/Seelengrab/TypingTheJuliaInterview.jl) (no runtime code).

## Sundry

* Start planning about submitting abstracts to JuliaCon 2024 (this time in Europe)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
