@def title = "This Month in Julia World"
@def authors = "Stefan Krastanov"
@def published = "1 August 2025"
@def rss_pubdate = Date(2025, 8, 1)
@def rss = """Community Newsletter for June and July 2025"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what a clique of us found interesting this month, with contributions from the community.

For recent news on Julia and interesting conversations with community members, check out the [JuliaDispatch](https://juliadispatch.fm/) podcast (on many platforms, including [youtube](https://www.youtube.com/@JuliaDispatch/) and [spotify](https://open.spotify.com/show/6Y1zWtFhjqPLsFQWRvZmws)). Highlights from the newsletter get discussed (with more context) during some episodes.

JuliaCon happened two weeks ago. [Here is the full list of talks](https://pretalx.com/juliacon-2025/schedule/), well worth perusing. Here are some of my favorite highlights (well-formatted recordings will be uploaded to the Julia youtube channel over the next few weeks, but you can already immediately access the [raw recordings of live streams](https://www.youtube.com/@TheJuliaLanguage/streams) and find the timestamp of each talk yourself):

* [State of Julia](https://pretalx.com/juliacon-2025/talk/3TKCZZ/) – great way to learn about the progress of the last year.
* [Past, present and future of the Julia Language Server](https://pretalx.com/juliacon-2025/talk/FNHLJL/) – a talk on the tooling that made the Julia VSCode extension possible and why it is becoming difficult to evolve these tools (partially because they were working around the lack of more foundational tools like JuliaSyntax and JuliaLowering)
* [A new language server for Julia](https://pretalx.com/juliacon-2025/talk/M7SGLS/) – building upon better static analysis tooling available in JET to make the language server more powerful, relying on JuliaSyntax and JuliaLowering for more faithful static analysis
* [Interpreting Julia code](https://pretalx.com/juliacon-2025/talk/9ADY9F/) – informative about the distinction between compilation and interpretation for julia code and why interpretation can be slow right now
* [Parting ways with our Julia simulation after 100 million miles](https://pretalx.com/juliacon-2025/talk/B7WRLT/) – a great success story of Julia in industry now ending as they transition to other tools. A discussion of why Julia was great for early prototyping but became difficult to scale for this particular team. Many lessons to be learnt for the ecosystem as a whole.
* [State of Continuous Integration in the SciML ecosystem](https://pretalx.com/juliacon-2025/talk/SHCKEL/) – great talk on how to structure a large Github org more efficiently and reliably.
* [State of `--trim`](https://pretalx.com/juliacon-2025/talk/YVU9E3/) – progress in static ahead-of-time compilation of julia code.
* [Can we achieve “invalidation freedom” for Julia?](https://pretalx.com/juliacon-2025/talk/DCDEQV/) – a speculative talk on what hints the compiler might find useful when deciding what code to compile or invalidate.
* [An Intersection of Concerns: Extended Types for Julia](https://pretalx.com/juliacon-2025/talk/ADCQMM/) – in what ways can the Julia type system be extended to make the lives of the developer and of the compiler easier, without breaking compatability or leading to unbound complexity. Contains a comparison to Rust and TypeScript features.
* [Lead, follow, or get out of the way: Julia and threaded Python](https://pretalx.com/juliacon-2025/talk/HU7YUZ/) – the difficulties of interfacing multithreaded Julia and multithreaded Python.
* [Cancellation, AKA the big red button](https://pretalx.com/juliacon-2025/talk/FK3EZL/) – going over why is it difficult to have well-behaved Ctrl-C behavior, i.e. interrupting your code gracefully.
* [Dagger 2025: Cool New Things](https://pretalx.com/juliacon-2025/talk/Z3Q8SP/) – one of the best ways to seamlessly program diverse multi-node hardware in julia for numerics
* [Reactant: Optimize Julia functions with MLIR & XLA](https://pretalx.com/juliacon-2025/talk/X7EVKM/) – pretty amazing library that takes human-readable pleasant numeric code and transforms it into high-performance less-allocating, distributed (over multiple accelerators), optimized magic
* [AcceleratedKernels.jl: Cross-Architecture Parallel Algorithms](https://pretalx.com/juliacon-2025/talk/7RLZAL/) – another piece in the story being told by Dagger and Reactant, providing seamless multi-node CPU/GPU/xPU acceleration for numerics
* [Reviving OpenCL.jl for CPU glory](https://pretalx.com/juliacon-2025/talk/WX7JLQ/) – making the OpenCL julia ecosystem much more reliable and modernized, and also using it as a CPU backend for KernelAbstractions.
* [Fixing Julia’s task-local RNG: a bother, a bug, a breakthrough](https://pretalx.com/juliacon-2025/talk/ZNBEAN/) – very educational deep dive in the intricacies of reliable multithreaded/concurrent RNG
* “[Whats new in AMDGPU.jl](https://pretalx.com/juliacon-2025/talk/9QRAXE/)” and “[What is new and improved in CUDA.jl](https://pretalx.com/juliacon-2025/talk/VTVVMG/)”
* [Pkg’s new SAT-based version resolver](https://pretalx.com/juliacon-2025/talk/Y7NPFM/) – soon-to-come improvements to how version resolving works in Pkg, permitting much more flexible configurations and goals (e.g. oldest possible package version that fulfills compat bounds)

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* Just as `@__MODULE__` refers to the enclosing module object, the internal variable `var"#self#"` can be used to refer to the enclosing function object. [This PR](https://github.com/JuliaLang/julia/pull/58940) creates an alias `@__FUNCTION__` for this variable to match the naming conventions of existing reflection macros (`@__MODULE__`, `@__FILE__`, etc.). It had to deal with an interesting amount of edge cases as discussed in linked PRs and Issues.
* A [competition to create a faster `sum`](https://discourse.julialang.org/t/performance-challenge-can-you-write-a-faster-sum/130456) and potentially have it included in `Base`.
* About a year ago there was a proposal for cleaner printing of repetitions in stack traces (e.g. due to recursion). [That proposal/implementation is now merged](https://github.com/JuliaLang/julia/pull/55841).
* The garbage collector capabilities are [now better documented](https://github.com/JuliaLang/julia/pull/58733/files).
* Some work has gone into improving the compiler’s understanding of the effects of accessing [[1](https://github.com/JuliaLang/julia/pull/58785), [2](https://github.com/JuliaLang/julia/pull/58793), [3](https://github.com/JuliaLang/julia/pull/58754), [4](https://github.com/JuliaLang/julia/pull/58768)] and [iterating](https://github.com/JuliaLang/julia/pull/58755) Vector and Memory. Because almost all code uses these fundamental operations, even tiny improvements to the effects can lead to widespread performance benefits.
* A [new function](https://github.com/JuliaLang/julia/pull/56580) has been added to get the n’th element of an iterable.

In search of contributors and new maintainers (specify novice/moderate/expert and internals/domain background necessary):

* The [Graphs.jl](http://graphs.jl) repo features a few bounties on [integrating external graph theory libraries](https://github.com/JuliaGraphs/Graphs.jl/issues?q=is%3Aissue%20state%3Aopen%20label%3Abounty) better with the rest of the Graphs ecosystem.
* [JuliaPackageComparisons](https://discourse.julialang.org/t/juliapackagecomparisons-is-looking-for-a-new-maintainer/130667) is a wiki-like resource comparing different julia tools. It is in search of a new maintainer.
* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science.
* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* The foundational package DataStructures.jl had a [breaking release](https://github.com/JuliaCollections/DataStructures.jl/blob/master/CHANGELOG.md), bringing in many new features from the last few years.
* [Dyad](https://discourse.julialang.org/t/ann-dyad-a-new-language-to-make-hardware-engineering-as-fast-as-software/129996) is a new language (Julia frontend?) with good GUI support for engineering modeling and controlling embedded hardware.
* A few packages handling URLs or other user-provided input recently issued [fixes for security vulnerabilities](https://discourse.julialang.org/t/security-advisory-http-jl-uris-jl-registrator-jl-gitforge-jl-and-github-jl/130189).
* A very detailed discussion of how AI agents like [Claude Code are successfully being used in the Julia/SciML ecosystem](https://discourse.julialang.org/t/the-use-of-claude-code-in-sciml-repos/131009/8).
* Discussion of tooling available for more advanced macro work, going over [MacroTools, ExprTools, and MLStyle](https://discourse.julialang.org/t/macro-utilities-for-working-with-function-definitions-in-2025/130687). The tooling behind Expronicon.jl and Moshi.jl might also deserve a tangential mention here.
* [MultipleInterfaces.jl](https://discourse.julialang.org/t/ann-multipleinterfaces-jl-interfaces-with-multiple-inheritance-and-multiple-dispatch/130796) is a sophisticated tool to enable trait-like interface-like multiple-inheritance capabilities in Julia. A very interesting addition to the long discussion on how to better implement interfaces and trait systems in julia. See also this [older discussion](https://discourse.julialang.org/t/interfaces-traits-in-julia-2-0-and-multiple-inheritance/124011) and this [proposal](https://hackmd.io/BbEw0_B4Q8uDSS34LOvpCw).
* [Discourse post](https://discourse.julialang.org/t/is-there-a-ruff-like-linter/130871) on linter, formatters, and other static analyzers for julia code.
* [Gettext.jl](http://gettext.jl) is now much more lightweight of a dependency, making it very easy to provide [translation and internalization for your packages](https://discourse.julialang.org/t/feedback-requested-updated-gettext-jl-for-i18n/130506).
* [Makie 0.24](https://discourse.julialang.org/t/ann-makie-v0-24/130207) is released – one of the important changes in it is moving to ComputeGraph (instead of Observable) for defining reactive graphics and user interfaces. The Observable approach lets you attach update rules to each piece of input data, so that your plot can react to changes in that date. ComputeGraph solves the issue of multiple Observables being changed at the same time (which usually resulted in redundant slow updates to the plot). Check out also the [release blog post for 0.23](https://makie.org/website/blogposts/v0.23.0/).
* A game engine is being developed in Julia. See [Cruise.jl](https://discourse.julialang.org/t/cruise-v0-1-0-a-julia-game-engine/130708). It includes a window/input manager, an ECS (entity-component system for fast simulation of diverse inhomogeneous entities in the virtual world), and a physics engine.
* A small but important part of that engine is [Arceus.jl](https://discourse.julialang.org/t/arceus-jl-a-lightning-fast-behavior-resolution-system/130321). It provides extremely fast “behavior resolution” for ECS (entity-component systems) used in games and agent simulations – it lets you call a particular update function for a given entity depending on an arbitrary combination of traits with very low overhead. It uses techniques originally developed for chess engines.
* Relatedly, see [RECS.jl](https://discourse.julialang.org/t/recs-a-reactive-ecs-framework-for-high-performance-simulations-in-julia/130098), a reactive ECS framework for high-performance simulations in Julia. This type of ECS (entity-component systems) are a standard solution to the issue of slow dynamical dispatch when iterating over a diversly typed array (i.e. when you do not have type stability and suffer from boxing and runtime dispatch). They are an alternative to the more popular Algebraic Data Types approach popular in parts of the Julia ecosystem (see [Moshi.jl](http://moshi.jl), [SumTypes.jl](http://sumtypes.jl), and others).
* A [commercial game](https://discourse.julialang.org/t/im-creating-the-worlds-first-commercial-game-written-in-julia/130412) is being developed in Julia.
* MPI (the standard tool for efficient communication during computation on supercomputing clusters) now has [much faster integration](https://discourse.julialang.org/t/faster-mpi-integration-in-dagger/130784) into [Dagger.jl](http://dagger.jl)
* A story on how to build an [e-ink dashboard powered by Julia](https://discourse.julialang.org/t/building-a-julia-powered-e-ink-dashboard-a-dev-log/130709).
* [Gasthon.jl](https://discourse.julialang.org/t/ann-gaston-v2-0-released/130358) is a convenient way to access gnuplot from julia.
* [FixedSizeArrays: What Arrays should have been](https://discourse.julialang.org/t/ann-fixedsizearrays-jl-what-array-probably-should-have-been/129724/37) – providing the compiler with more size information and promising to not change size of an array, enables more optimizations.

Numerical Math ecosystem:

* [DataInterpolationsND.jl](https://discourse.julialang.org/t/is-there-a-ruff-like-linter/130871), under the SciML umbrella, now provides the equivalent of DataInterpolations.jl for arbitrary dimensions.

Autodiff ecosystem:

* Bringing the [advanced sparse autodiff available in Julia to jax](https://github.com/gdalle/sparsediffax).
* Colab notebook showcasing [sparse autodiff on GPU](https://colab.research.google.com/drive/18tob4GCdB7T_rjxWi7LVB0rYygdNvzTE?usp=sharing).
* An informative [slack thread on the ArrayInterface.jl](https://julialang.slack.com/archives/C6G240ENA/p1752678837415059) library and a [github discussion](https://github.com/JuliaArrays/ArrayInterface.jl/issues/463) that emerged from it. ArrayInterface is frequently necessary to write generic code over AbstractArrays (appropriately specializing for different type of arrays, e.g. CUDA arrays), and the discussion delves deeper on some edgecases.
* An informative [slack thread on the Mooncake autodiff toolkit](https://julialang.slack.com/archives/C6FGJ8REC/p1751978854180429).

Events:

* [FerriteCon 2025](https://ferrite-fem.github.io/FerriteCon/2025/) is happening in Copenhagen, Denmark on August 28th and is currently open for registration.

See also: [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [minutes of triage meetings](https://hackmd.io/@LilithHafner/HJaw__uMp), [Turing.jl newsletter](https://github.com/TuringLang/Turing.jl/issues/2498)


You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
