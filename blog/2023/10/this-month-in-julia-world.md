@def title = "This Month in Julia World (September 2023)"
@def authors = "Stefan Krastanov"
@def published = "29 September 2023"
@def rss_pubdate = Date(2023, 9, 29)
@def rss = """Community Newsletter for September 2023"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* [Prem Chintalapudi’s Master Thesis](https://dspace.mit.edu/bitstream/handle/1721.1/151537/chintalapudi-premc-meng-eecs-2023-thesis.pdf?sequence=1&isAllowed=y) on “Reducing Compilation Latency in the Julia Programming Language” – Prem has been doing a ton of work on documenting and speeding up the compiler (discussed in previous issues of this newsletter). Check section 5.4 for things that are yet to be done (and where you can potentially help).

* There has been a lot of work on making the Julia compiler more pleasant to use from “user space” for people that want to customize compilation. Escape analysis in particular was recently discussed on [the internals slack](https://julialang.slack.com/archives/C688QKS7Q/p1695223038098329) and is now much [better documented for 1.11](https://docs.julialang.org/en/v1.11-dev/devdocs/EscapeAnalysis/#EA-Alias-Analysis).

* A recent discussion on [what is so special about Julia that static compilation is not yet a solved problem](https://discourse.julialang.org/t/why-is-static-compilation-difficult/103796). This type of thread reappears every few months, but there is always something new to discuss as more progress is being made. This particular discussion focuses on runtime features that are difficult to provide in a self-contained static compiled binary (such a binary is supposed to be able to ship without its own copy of an entire julia installation).

* Mojo, a new tool aiming to be Python but compiled and fast (similar to cython, numba, jax and others, but more ambitious and more universal) had its first public release. There were a couple of [interesting comparison threads with Julia in the context of recursion](https://discourse.julialang.org/t/performance-comparison-julia-is-a-slower-than-mojo-am-i-doing-something-wrong/103870) and [another one focused on SIMD-ification](https://discourse.julialang.org/t/julia-mojo-mandelbrot-benchmark/103638/). The rough consensus seems to be that “very optimized not-readable code” performs blazingly fast both in Mojo and in Julia (some users had Mojo a bit faster, some had Julia a bit faster, depending on their hardware). That type of code also does not look anything like actual Python in either case. My personal conclusion was that super-optimized code is equally difficult to write in Mojo and in Julia, but there were a couple of examples of simple Julia code that performs almost as fast as the super-optimized unreadable versions (simd-ifying complex numbers being a good demo). On the other hand, in Julia you really should write iterative code, not recursive code, while Mojo does not necessarily require that style. Of course, all of this is about microbenchmarks – how easy it is to build a big project is a different question. Lastly, do check out Chris Elrod’s compile-time trick, making the Julia solution for the recursive microbenchmark take practically constant time (a few nanoseconds) – not really a fair comparison, but a fun trick nonetheless.

* On autodiff: a [very long slack thread](https://julialang.slack.com/archives/C6G240ENA/p1695375125319359) that started with a discussion on creating a universal set of unit tests and regression tests for all julia autodiff tools, that then turned into discussion of how much of SciML has “secretly” transitioned to use Enzyme behind the scenes already, that then turned into a discussion of where Enzyme is heading in the near term and how Enzyme is being designed to be robust.

* Another thread on recent [exciting improvements to the Enzyme autodiff tool](https://julialang.slack.com/archives/C6G240ENA/p1695637644435929).

* And a [really fun example of how Enzyme works for an incredibly surprising mutating calculation](https://julialang.slack.com/archives/C01J3R4FHB3/p1695651880781629).

* The Julia compiler recompiles functions/methods as necessary whenever new method definitions are imported. It uses “world ages” as a way to track whether a recompilation is necessary. In that context, yet another piece of dark magic from Frames: [a tool that lets you access older versions of functions, from before they were recompiled](https://discourse.julialang.org/t/timetraveler-jl-a-package-for-running-julia-code-back-in-time/103478). It is a bit like the opposite of Revise: it lets you check what a function was doing before you modified it.

* For when you know you **have to** do a computation with a ton of allocations in the inner loop, consider Mason’s [Bumper.jl](https://github.com/MasonProtter/Bumper.jl) which provides a second allocator that is user manipulable and very fast (it is a simple bump allocator for manual memory management without garbage collection). Hopefully Mason will not be annoyed that this is being advertised while it is still stealth/experimental.

## Core repos

* The REPL is getting better and better. Check out the new [visual hints for autocompletion](https://github.com/JuliaLang/julia/pull/51229).

* Mentioned in previous issues of the newsletter, the `public` keyword for defining API boundaries is now [merged](https://github.com/JuliaLang/julia/pull/50105).

* Folks that want to learn more about “effects” (the compiler’s terminology about what properties it can prove for methods being compiled, thus enabling more aggressive optimization): Check out some of the recent work there, e.g. [changes making custom compiler like GPUCompiler](https://github.com/JuliaLang/julia/pull/51080) able to rely on the default CPU compiler predictions.

* For folks that want to customize compilation and code generation, this recent [documentation PR](https://github.com/JuliaLang/julia/pull/51140) would be helpful.

* We do not have an official way to create “standalone scripts”. Of course, we can just write a script and ask a user to execute it on the command line, but for more sophisticated self-contained public releases of executables it helps to define an “entry point” like `main` in C and `if __name__==”__main__”` in python. This caused a ton of fun and not-fun bikeshedding. [First try](https://github.com/JuliaLang/julia/pull/50974), then [discourse discussion](https://discourse.julialang.org/t/on-hold-if-you-have-a-function-called-main-you-may-need-to-tweak-it/103519), backtracking to a [second try](https://github.com/JuliaLang/julia/pull/51417) that caused even more consternation, and finally a [third try that folks seem to like](https://github.com/JuliaLang/julia/pull/51435). The difficulty was to balance expressiveness, universality, obviousness, and backward compatibility.

* `IdDict` is useful when you want to distinguish instances of what might be the “same” object, copied multiple times (for cases where `==` is not enough to distinguish objects). Now [it is twice as fast](https://github.com/JuliaLang/julia/pull/51091).

* Folks interested in the previously discussed “dynamic scope variables” can see how they are already being used to make various configurations properly thread-safe (and generally simplify the configuration management). For instance, [multiprecision BigFloat configuration](https://github.com/JuliaLang/julia/pull/51362).

* Also discussed in previous newsletter issues, many Julia routines that mutate their input are not safe when used on aliased input (e.g. “map from array A to array B” when A and B are overlapping views into the same parent array). This is a feature shared by any high-performance linear algebra or tensor library, but it frequently trips up novices. These issues are now being [thoroughly documented in every single mutating Base function](https://github.com/JuliaLang/julia/pull/50824).

* Interested in how you can write new optimization passes in the Julia compiler? Check this example of [enabling “common subexpression elimination”](https://github.com/JuliaLang/julia/pull/51120) which teaches the compiler how to simplify user code such that it does not repeat the same computation multiple times. LLVM already does this for us, but it is valuable to start doing it at a higher level, in Julia itself, as the Julia IR (intermediary representation) carries a lot more useful semantic information.

* Julia Base has a very good `Array` implementation, mostly done in C. Some work has started on abstracting away the low-level memory management from the higher level Array API, so that some of it can be written in simpler Julia code (minimizing C code to the bare necessities) and so that more “memory manipulating” functionality can be written in julia (e.g. working with simple buffers without depending on Array). This has been in the works for quite a while and is [now starting to take shape](https://github.com/JuliaLang/julia/pull/51319).

* PrecompileTools might [become a stdlib](https://github.com/JuliaLang/julia/pull/50923).

* The Julia compiler can be started in a mode where it reports each time a compilation is triggered (and the method being compiled is reported). In [51106](https://github.com/JuliaLang/julia/pull/51106) this functionality is improved to report also what line of code caused the compilation to be triggered.

* Yet more improvements to the garbage collector, [taking advantage of more parallelism and multithreading](https://github.com/JuliaLang/julia/pull/51282).

* A few more “interactive” stdlibs were removed ([here](https://github.com/JuliaLang/julia/pull/51189) and [here](https://github.com/JuliaLang/julia/pull/51399)) from the sysimg making Julia faster to compile and snappier when launching scripts.

## Ecosystem

* The JuliaRegistrator github helper now can neatly add release notes to the github release page of a project. Previously it had this capability documented, but not fully implemented. [Make your release pages neater with custom release notes](https://discourse.julialang.org/t/make-breaking-change-releases-easier-to-handle-add-release-notes-to-tags-via-juliaregistrator/103241).

* [Documenter reached version 1.0](https://discourse.julialang.org/t/ann-documenter-1-0/103888)!!! It has some neat new features for generating changelogs and for having bibtex citations (in a separate package), but maybe the most wonderful new feature is that it is “strict by default”, so now your CI can keep track of outdated documentation.

* PkgTemplates.jl now [supports](https://github.com/JuliaCI/PkgTemplates.jl/pull/415) adding Aqua to the test suite at package creation. More test utilities are on the way (like JuliaFormatter and JET). The goal is to make it easier for beginners to enforce good coding practices by default.

* BenchmarkTools.jl will soon (October?) tag a [2.0 release](https://github.com/JuliaCI/BenchmarkTools.jl/milestone/1) following a major [bug fix for mutating functions](https://github.com/JuliaCI/BenchmarkTools.jl/pull/318). If you have any guidance or suggestions for the maintainers before that happens, please open an issue on the repo.

* A ton of [new visualization tools for complex numbers](https://discourse.julialang.org/t/ann-complexvalues-complexregions-and-complexplots/103556) and functions of complex numbers.

* Also new tools for [function approximations in the complex plane](https://discourse.julialang.org/t/ann-rationalfunctionapproximation-jl/104118).

* Julia has some really cool tools for working with numerical data that carries physical units data. In particular, for quite a while we have had Unitful, which encodes a lot of unit-data in the type domain. That has some compilation and generalizability issues, so folks recently started working on a runtime alternative: [DynamicalQuantities](https://discourse.julialang.org/t/dynamicquantities-jl-v0-7-0-fast-and-lightweight-physical-quantities/103709).

* There was a joke that everyone who does graph theory in Julia creates their own package. The last few months there has been a wonderful effort to unite these disparate tools (as discussed in previous issues). Now we are setting up regular [Graph community calls](https://discourse.julialang.org/t/launching-the-graphs-community-calls/103880) to discus priorities and developments.

* [CUDA.jl v5 is out](https://info.juliahub.com/cuda-jl-5-0-changes)! Very few breaking changes, and a ton of improvements. Especially nice are the new profiling capabilities.

* A new version of [TerminalPager](https://discourse.julialang.org/t/ann-terminalpager-jl-v0-5-0/104122) is out with a ton of improvements in how you can view long textual or tabular data in Julia’s REPL.

* Every so often people prepare curated lists of useful stable packages and package comparisons. A promising fresh new effort is [JuliaPackageComparisons](https://discourse.julialang.org/t/pre-ann-juliapackagecomparisons/103567).

* JuliaActuary released a new package, FinanceModels.jl, to perform modeling and valuation of financial contracts. It is the evolution of Yields.jl and more can be read at their [blog post](https://juliaactuary.org/blog/finance_models/).

* Benchmark comparison between Symbolics.jl and SymEngine (a c++ tool that came out of the sympy team ten years ago but is separate): [github](https://github.com/symengine/symengine/issues/1973) and [discourse](https://discourse.julialang.org/t/benchmarking-symbolics-jl-against-symengine-jl/103744).

## Blogs and talks

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English)

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* [JuliaNotes](https://m3g.github.io/JuliaNotes.jl/stable/) is a useful onboarding document with tips and workflow directions for novices jumping into the language.

* A presentation about [Pluto at JupyterCon](https://discourse.julialang.org/t/pluto-jl-presentation-at-jupytercon-2023/103572) was very well received.

* There is a recent [academic publication about DataFrames.jl](https://www.jstatsoft.org/article/view/v107i04), which showcases its great design and competitive performance compared to other dataframe libraries.

## Sundry

* An interesting keynote speech at RSECon about [creating opensource scientific communities](https://drive.google.com/file/d/10hU3bA3Hm0qLjZk92zu7z2OR7ZrHpWnT/view) – mentioned on [slack](https://julialang.slack.com/archives/C67KW7401/p1693905397239579).

* Check out the winner of the [Pluto Notebook competition](https://info.juliahub.com/pluto-notebook-winner-23).

* The company JuliaHub for quite a while has been setting up a universal documentation portal (in the style of readthedocs) which has various ecosystem benefits. But if you have anything slightly non-standard in your documentation CI, probably the JuliaHub docs for your package will be mangled. The JuliaHub team is doing a lot of work on polishing this resource, but in the meantime you might want to check how your packages are rendered in the centralized documentation repository. E.g. here is [JuMP](https://docs.juliahub.com/General/JuMP/stable/) which has broken doc build in that environment. Here is a [log from QuantumClifford](https://juliahub.com/ui/Code/docs/General/QuantumClifford/stable.log) which also has a broken doc build. You might want to check whether your package works with that documentation platform, and if it does not, you can check the log to see what is broken. Then you can just fix it in your package or opt-out of this resource by saying so at [DocumentationGeneratorRegistry](https://github.com/JuliaDocs/DocumentationGeneratorRegistry). Or, of course, you can just not worry about it and wait for the JuliaHub folks to polish the doc generations over the next few years. **edit: JuMP now redirects (thanks to DocumentationGeneratorRegistry) so it does not look broken anymore**

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
