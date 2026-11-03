@def title = "This Month in Julia World (May 2024)"
@def authors = "Stefan Krastanov"
@def published = "6 June 2024"
@def rss_pubdate = Date(2024, 6, 6)
@def rss = """Community Newsletter for May 2024"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

Pardon the delay with this release -- end of semester is always hectic. 

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Core repos

* With a lot of difficulty to contain my excitement and hype-proneness, it is wonderful to observe the progress Claire is making in her crusade to rewrite the parsing and lowering passes of the Julia compiler in Julia itself, while also producing much tighter, reusable, and introspectable implementation than previously available. Check out the issue tracker of [JuliaLowering.jl](https://github.com/c42f/JuliaLowering.jl). In terms of lowering, the discussion on what [folks from Racket](https://github.com/c42f/JuliaLowering.jl/issues/1) do is quite informative. Docstrings are [also an interesting can of worms](https://github.com/c42f/JuliaLowering.jl/issues/3). In terms of parsing, there are interesting considerations in making iterations syntax produce better parsed abstract syntax trees ([here](https://github.com/JuliaLang/JuliaSyntax.jl/issues/432) and [here](https://github.com/JuliaLang/JuliaSyntax.jl/pull/433)). She also posted a wonderful demo of the [new scope-resolution capabilities on slack](https://julialang.slack.com/archives/C67910KEH/p1716527195906449).

* While functions can be easily redefined “live” in julia (especially with the use of Revise.jl), struct redefinition is less ergonomic and requires restarting the julia process. This is mostly due to functions existing in different “worlds” depending on when they were compiled, while bindings do not have the notion of world and age. This might be changing soon (enabling Revise to redefine structs). See this [old proposal](https://github.com/JuliaLang/julia/issues/40399) and [recent (well documented) work on implementation](https://github.com/JuliaLang/julia/pull/54654).

* The REPL auto-completion was really finicky for explicitly imported symbols. This is [fixed](https://github.com/JuliaLang/julia/pull/54610) now.

* Handling Ctrl+C interrupts properly is a pain in any language, but Julia is particularly hands-off in terms of how to deal with them (chiefly due to the complication of responding to interrupts from a multi-threaded program). Some interesting approaches to improving the situation were [discussed on slack](https://julialang.slack.com/archives/C688QKS7Q/p1717428027130989).

* The [transition to LLVM 17](https://julialang.slack.com/archives/C6FGJ8REC/p1714574655368929) is now complete! Thank you Sergio!

* Timothy has created a [neat tool to visualize the nanosoldier](https://julialang.slack.com/archives/C67910KEH/p1715189287301279) logs (the tool used to test julia nightlies against the entire ecosystem of packages).

* It is easy to make a struct that does not have a fully specified constructor, i.e. fields of the struct are left undefined. [What is the point](https://julialang.slack.com/archives/C67TK21LJ/p1716920870524629), being discussed on slack…

* A [neat little script](https://discourse.julialang.org/t/precompilation-after-julia-update/113792/3) that you can run after updating your local version of julia so that all environments you have get precompiled (instead of being surprised when you open an environment you have not touched in a while and having to wait 5 minutes before you can use it).

* A very old well-known performance pitfall in Julia is “[variable capture in closures](https://github.com/JuliaLang/julia/issues/15276)”, due to the fact that the closure needs to check whether the variable was modified outside of the closure. There are standard tricks to get around it most of the time (e.g. with a `let` block to isolate the closure), but there is also recent work on fixing at least some cases without modifying code, [here](https://github.com/JuliaLang/julia/issues/53367) and [here](https://github.com/JuliaLang/julia/pull/53385).

* A very exciting development with a [3rd-party ahead-of-time compiler for julia](https://discourse.julialang.org/t/syslabcc-suzhou-tongyuans-proprietary-julia-aot-compiler-is-now-available-for-free-use-personal-educational-license-only/114633) being made available.

* A generalization of `Fix1` and `Fix2` for preparing partially applied functions is [being proposed](https://github.com/JuliaLang/julia/pull/54653).

## In search of contributors

* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.

* [FixedPointNumbers.jl](https://discourse.julialang.org/t/ann-fixedpointnumbers-jl-v0-8-5/114203) is looking for volunteer maintainers.

* [Northeastern University](https://discourse.julialang.org/t/northeastern-university-looking-for-research-projects-for-student-teams/114880) is looking for research projects to be tackled (with Julia) by teams of their students.

## Ecosystem

* The [Julia User and Developer Survey](https://discourse.julialang.org/t/2024-julia-user-developer-survey/115188) for 2024 is up.

* A very exciting development in autodiff-world: [DifferentiationInterface.jl](https://discourse.julialang.org/t/ann-differentiationinterface-gradients-for-everyone/113644) provides a much cleaner way to interact with the universe of different autodiff tools available in Julia.

* What do various julia autodiff packages [promise about second-order derivatives](https://discourse.julialang.org/t/second-order-autodiff-which-combinations-should-work/114892) (including nesting of different autodiff packages).

* A [very informative discussion](https://discourse.julialang.org/t/how-to-high-performance-differentiable-programming-with-broad-ad-library-support/113884) on current best practices and capabilities of Julia autodiff packages.

* A new package in the hazy category of “interfaces” and “duck typing” is out, with a really interesting new take on defining (something like) Interfaces in julia. The [discourse post](https://discourse.julialang.org/t/rfc-wip-duckdispatch-jl/114930) also lists the other experimental players in that area of julia language development. However, make sure you check the [readme of this new DuckDispatch.jl package](https://github.com/mrufsvold/DuckDispatch.jl), as it provides a lot of useful context as well.

* [DispatchDoctor.jl](https://discourse.julialang.org/t/ann-dispatchdoctor-jl-offers-you-a-prescription-for-type-stability/114837) for providing guarantees that your code is typestable. See some of the discussion on [runtime dispatch detection](https://discourse.julialang.org/t/improving-speed-of-runtime-dispatch-detector/114697) that happened during development.

* [ArguMend.jl](https://discourse.julialang.org/t/ann-announcing-argumend-jl-for-more-helpful-methoderrors/113878) for better, more informative MethodErrors.

* PerfChecker.jl is a new tool for performance tracking of julia packages (mostly to be employed by developers). Similar to AirspeedVelocity.jl and BenchmarkCI.jl.

* A [proposal](https://hackmd.io/@quinnj/HkJ96bxCa) for a new `Structs` module in `Base` to drastically simplify the management of constructors and struct definition. Made available as a registered package for experimentation as StructUtils.jl.

* A [proposal](https://github.com/jakobnissen/MemViews.jl) for a “memory views” API.

* Makie v0.21 is [now out](https://discourse.julialang.org/t/ann-makie-0-21/114678).

* [MakieTeX.jl](https://juliaplots.org/MakieTeX.jl/dev/) is becoming a very capable tool for working not only with TeX, but also with PDF and SVG in Makie.

* A [discussion](https://discourse.julialang.org/t/workflow-for-faster-testing-of-julia-packages/113836) on making test-running more ergonomic and low-latency for package developers.

* UnitfulTensors.jl, a new package for working with numerical data with units, as well as alternatives and competitors, [were recently discussed](https://discourse.julialang.org/t/ann-unitfultensors-jl-efficient-arrays-with-units/114028).

* [CliffordNumbers.jl](https://discourse.julialang.org/t/cliffordnumbers-jl-fast-static-geometric-algebra-with-multivectors-as-number-subtypes/114073), a new Geometric Algebra package.

* The idiosyncrasies of GPU/TPU/CPU-dependent `rand`, `fill`, `zero` (and the use of `similar`) [discussed on slack](https://julialang.slack.com/archives/C689Y34LE/p1715619305189049).

* [QuartoDocBuilder.jl](https://vituri.github.io/QuartoDocBuilder.jl/) is a package inspired by R pkgdown. It provides an easy way to generate a website with documentation and vignettes, by creating a Quarto project.

* [CUDA.jl 5.4](https://juliagpu.org/post/2024-05-28-cuda_5.4/) is out.

## Other ecosystems

* [Alice’s adventures in a differentiable wonderland](https://news.ycombinator.com/item?id=40213292) – a neat new book on a common topic of interest here.

* [Preemption and garbage collection](https://www.youtube.com/watch?v=1I1WmeSjRSw) in Go and its relationship to Go “threads”.

* A new programming language with focus on GPU: [Bend](https://discourse.julialang.org/t/bend-a-new-gpu-native-language/114440) (and their [homepage](https://higherorderco.com/)).

## Blogs and talks

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack. [Minutes are kept](https://hackmd.io/@LilithHafner/HJaw__uMp).

* A fun post on [UTF8 string validation (or not)](https://viralinstruction.com/posts/utf8/) in Rust and Julia, also discussed on [hacker news](https://news.ycombinator.com/item?id=40381511).

* A book on [Calculus with Julia](https://news.ycombinator.com/item?id=40401343).

* [Lecture notes](https://web.eecs.umich.edu/~fessler/course/100/) for a class on Music Signal Processing with Julia.

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
