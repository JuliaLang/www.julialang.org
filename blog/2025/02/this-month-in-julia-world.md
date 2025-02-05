@def title = "This Month in Julia World"
@def authors = "Stefan Krastanov"
@def published = "1 February 2025"
@def rss_pubdate = Date(2025, 2, 1)
@def rss = """Community Newsletter for January 2025"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what I found interesting this month, with contributions from the community.

The deadline for [submitting a proposal to JuliaCon 2025 is extended to Feb 14th](https://juliacon.org/2025/cfp/).

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* Pkg now supports 'apps' for running programs directly from the terminal without invoking Julia, using isolated environments for each app; more details are available in the[ PR](https://github.com/JuliaLang/Pkg.jl/pull/3772) and[ slack discussion](https://julialang.slack.com/archives/C6FGJ8REC/p1737732202321509).
* On a discussion [about introducing Rust alongside C](https://discourse.julialang.org/t/introducing-rust-alongside-c-in-julias-source-tree/124559/) in Julia’s source code, [Stefan provided interesting insight into what Julia looks like as a program](https://discourse.julialang.org/t/introducing-rust-alongside-c-in-julias-source-tree/124559/17): code generation is done mostly by C++ because it is the main interface for LLVM, and C is used for OS-interfacing, significantly limiting the utility Rust would provide.
* [PR #57049](https://github.com/JuliaLang/julia/pull/57049) introduces LLVM-based feature detection for CPU parsing.
* The difficulty of writing multithreaded code, and footguns related to the difference between thread and task, the danger of moving tasks between threads, and the subleties of properly setting up thread- or task-local storage come up often. This is [a recent good discussion of the topic](https://discourse.julialang.org/t/sharp-edge-with-threads-threadid-and-task-migration/124550). It reminds me also of the [recently merged](https://github.com/JuliaLang/julia/pull/55793) `perprocess` / `perthread` / `pertask` constructs which help manage some of these subtleties.
* An interesting suggestion for having [julia automatically logging to the terminal to current state of progress through a script](https://github.com/JuliaLang/julia/pull/57137).
* [Unicode v16 is now supported](https://github.com/JuliaLang/julia/pull/56925) in Julia source files. We get access to "face with bags under eyes" but there is still no superscript “q”.

In search of contributors and new maintainers (specify novice/moderate/expert and internals/domain background necessary):

* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science.
* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.
* ChainRules, a foundational package to the Julia autodiff effort, is looking for a [new primary maintainer](https://discourse.julialang.org/t/chainrules-project-looking-for-a-new-primary-maintainer/115636).

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* Speculator.jl is a [fun new tool to speculative precompile functions](https://discourse.julialang.org/t/speculator-jl-reduce-latency-through-speculative-compilation/124344) (in the background) to reduce latency (also in interactive dev use).
* [Makie 0.22 is now out](https://makie.org/website/blogposts/v0.22/), with further improvements to geometry primitives and 3D capabilities.
* [BorrowChecker.jl](https://github.com/MilesCranmer/BorrowChecker.jl) is a new package that introduces Rust-like ownership and borrowing semantics to Julia, aiming to improve memory safety. Related to this earlier [discourse discussion](https://discourse.julialang.org/t/package-for-rust-like-borrow-checker-in-julia/124442).
* [Statistics.median](https://github.com/JuliaArrays/StaticArrays.jl/pull/973) is now available for StaticArrays, providing efficient median computation via bitonic sorting.
* AlgebraOfGraphics.jl (inspired by R’s grammar of graphics ggplot, built on Makie) is working surprisingly well with [sophisticated edge-case composition of plots](https://aog.makie.org/stable/gallery/gallery/scales/split_scales_facet/#Split-scales-across-facets).
* SatelliteToolbox.jl is [officially v1 after 10 years](https://discourse.julialang.org/t/ann-satellitetoolbox-v1-after-almost-10-years-we-reached-v1-0/124349) – used in attitude and orbit control of actual satellites.
* [QuantumCircuitDraw.jl](https://github.com/nicolasloizeau/QuantumCircuitDraw.jl) is a new package for visualizing quantum circuits in the style of Qiskit.

Abstract Math ecosystem:

* The newly published book [The Computer Algebra System OSCAR: Algorithms and Examples (2025)](https://link.springer.com/book/10.1007/978-3-031-62127-7) delves into [OSCAR](https://github.com/oscar-system/Oscar.jl)’s role in algebra, geometry, and number theory, featuring expert-written code and interdisciplinary applications.
* The [experimental PR](https://github.com/oscar-system/Oscar.jl/pull/4370) for [Oscar.jl](https://github.com/oscar-system/Oscar.jl) introducing Clifford algebras, orders, quadratic spaces, and lattices has been merged!

Numerical Math ecosystem:

* A new version of the book [“Fundamentals of Numerical Computation” is out](https://fncbook.com/), with julia/python/matlab snippets for each algorithm.
* Interesting discussion on [techniques used for function approximation](https://discourse.julialang.org/t/truncated-power-series-in-approxfun-jl/124593) with polynomials.
* PeriodicMatrices.jl was recently released to handle [periodic time-varying matrices](https://discourse.julialang.org/t/ann-periodicmatrices-jl-handling-of-periodic-time-varying-matrices/124425).

Mathematical Optimization ecosystem:

* The JuMP Steering Committee announced a [major grant](https://jump.dev/announcements/open-energy-modeling/2024/09/16/oem/) from the Breakthrough Energy Foundation, through NumFOCUS, to enhance the performance of JuMP and HiGHS on open energy models.
* [JuMP](https://github.com/jump-dev/JuMP.jl) and its [SCIP](https://github.com/scipopt/SCIP.jl) solver enabled [recent work](https://julialang.slack.com/archives/C6FGJ8REC/p1734870518787189) on automated branching rule generation, solving a weighted minimum set covering problem with 15,782 sets in seconds!

Julia Autodiff ecosystem:

* [ChainRules Thunks](https://github.com/FluxML/Zygote.jl/pull/966) are now fully integrated into [Zygote.jl](https://github.com/FluxML/Zygote.jl), following a challenging but rewarding implementation process.
* [Effort.jl](https://github.com/CosmologicalEmulators/Effort.jl) combines [Turing.jl](https://github.com/TuringLang/Turing.jl), [SciML](https://github.com/sciml), and [Lux.jl](https://github.com/LuxDL/Lux.jl) to train fast, accurate surrogate models for cosmological analysis, with applications to[ DESI](https://www.desi.lbl.gov/) and [Euclid](https://www.cosmos.esa.int/web/euclid/euclid-survey) surveys.
* This type of discussions come up every so often and occasionally have new insight: [Autodiff in the Julia multiple-dispatch staged-compilation model vs the Python reimplement-the-universe model](https://discourse.julialang.org/t/automatic-differentiation-ad-in-julia-vs-python-or-pytorch/124553).

Notes from other ecosystems:

* Clang gets LLVM-based tooling that [checks at runtime and compile-time for realtime violations](https://discourse.julialang.org/t/can-we-get-realtimesanitizer-in-julia/119330).
* [JAX Under the Hood](https://braid-technologies.notion.site/JAX-Under-the-Hood-Optimization-Tricks-and-Profiling-Tips-105efeeba2dd4e939432cb982084ae8d) explores how understanding JAX’s architecture enhances performance optimization, efficient coding, and profiling in scientific computing.

Soapboxes (blogs/talks):

* Chris Rackauckas discusses building products for open-source sustainability, highlighting the work of MIT Julia Lab, PumasAI, and JuliaHub, in a recent [non-technical talk with OpenTeams](https://www.youtube.com/watch?v=kuzwUFuIyk4).

See also: [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [minutes of triage meetings](https://hackmd.io/@LilithHafner/HJaw__uMp)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
