@def title = "This Month in Julia World (September 2024)"
@def authors = "Stefan Krastanov"
@def published = "05 October 2024"
@def rss_pubdate = Date(2024, 10, 05)
@def rss = """Community Newsletter for September 2024"""

A monthly newsletter, mostly on Julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what I found interesting this month, with contributions from the community.

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* [Well documented tips on how to minimize latency](https://docs.julialang.org/en/v1.12-dev/manual/performance-tips/#Execution-latency,-package-loading-and-package-precompiling-time) in your packages are now organized in a new section in the “Performance Tips” docs
* The trace-compile capabilities provide a convenient way to track what the compiler is working on as you ecnounter new methods during runtime. It is extremely helpful when you want to figure out what precompile statements to add to your packages. A few quality-of-life improvements are coming up, with [better colored output for the traces](https://github.com/JuliaLang/julia/pull/55763).
* Relatedly, recently we got a special-case of trace-compile, [the new trace-dispatch](https://github.com/JuliaLang/julia/pull/55848) which prints precompile statements only for dynamically encountered methods.
* And to make this even better, both of these capabilities will now be available interactively directly from the REPL thanks to [new introspection macros](https://github.com/JuliaLang/julia/pull/55915).
* A great new capability for profiling [why the garbage collector is being triggered](https://github.com/JuliaLang/julia/pull/55826).
* Work on yet more parallelism in the gargabe collector ([parallel sweeps of stack pools](https://github.com/JuliaLang/julia/pull/55643))
* Yet more refactoring and cleanup to enable use of [external garbage collectors](https://github.com/JuliaLang/julia/pull/55608).
* Better caching of package precompiled code and package extensions drastically lowered the time-to-first-X in the ecosystem over the last couple of years. This led also to much more precompilation being possible, which leads to the trade off of long installation times. A [discussion has started on github](https://github.com/JuliaLang/julia/issues/55516) about how to enable more modular packages (lowering the amount of what is installed and compiled) without leading to a proliferation of registered subpackages with (frustratingly) independent versioning.
* New primitives for reliably expressing once-per-thread or once-per-process objects [are nearly ready](https://github.com/JuliaLang/julia/pull/55793).
* A variety of improvements to `any` and `all`: [better generic implementation for `in`](https://github.com/JuliaLang/julia/pull/55669), [simplifying the implementation for abstract arrays](https://github.com/JuliaLang/julia/pull/55671), [better implementation for Bool tuples](https://github.com/JuliaLang/julia/pull/55673)
* Looking into [enabling the use of the new LLVM 19](https://github.com/JuliaLang/julia/pull/55650) in the julia compiler.
* Improvements to the internals of how [Julia handles external signals](https://github.com/JuliaLang/julia/pull/55623).
* A neat and small improvement in how the optimizer [handles throwing errors for undefined variables](https://github.com/JuliaLang/julia/pull/55600) – it is small, so it can be a good place to start reading internal implementation code. Based on another small improvement in [how much metadata the optimizer tracks in conditionals](https://github.com/JuliaLang/julia/pull/55545).
* Minor improvements to the non-default makefile for compiling Julia with [profile guided optimization and link time optimization](https://github.com/JuliaLang/julia/pull/55581). That makefile has been discussed before in the newsletter – hopefully it will become a default in the future, but until then you can gain some compiler performance by using it manually.
* It is always frustrating when Julia or Julia’s imported BLAS does not automatically obey the number of logically-available threads. [Related fixes](https://github.com/JuliaLang/julia/pull/55574).

Dustbin of History:

* Wouldn’t it be great if we had [a type-safe `==`](https://github.com/JuliaLang/julia/issues/40717) (related to occasionally conflating `==` and `===`).

In search of contributors and new maintainers (specify novice/moderate/expert and internals/domain background necessary):

* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science. Few thousand \$ will be paid out already in October for bounties from August.
* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.
* ChainRules, a foundational package to the Julia autodiff effort is looking for a [new primary maintainer](https://discourse.julialang.org/t/chainrules-project-looking-for-a-new-primary-maintainer/115636).

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* [JuliaCon Global 2025](https://discourse.julialang.org/t/juliacon-global-2025-announcement/119656) will be in Pittsburgh from July 21 - July 26, 2025.
* Tutorials on [interoperability between Rust and Julia](https://discourse.julialang.org/t/ann-a-tutorial-for-jlrs/119651).
* A [fun discussion](https://discourse.julialang.org/t/the-unreasonable-efficiency-and-effectiveness-of-multiple-dispatch-your-favourite-examples/119477) with many examples of the surprising power of multiple dispatch (the main programming paradigm in Julia) – a good place to mine for examples.
* Discussion on planned improvements for the [low-level implementation of strings](https://discourse.julialang.org/t/redesigning-string-optimising-small-strings-and-comparison/119716) in Julia.
* https://discourse.julialang.org/t/enzyme-ready-for-everyday-use-2024/118819
* There is a new [breaking release](https://github.com/gdalle/DifferentiationInterface.jl/releases/tag/DifferentiationInterface-v0.6.0) of DifferentiationInterface (v0.6) with support for additional constant arguments. This opens DI to even more use cases, so @gdalle will try to integrate it to a bunch of SciML repos (NonlinearSolve, Optimization, OrdinaryDiffEq) as well as Turing. Other potential users are more than welcome to open issues and ask for help.
* AcceleratedKernels.jl is a new library with [primitives for parallel algorithms](https://discourse.julialang.org/t/ann-acceleratedkernels-jl-cross-architecture-parallel-algorithms-for-julias-gpu-backends/119698) on any hardware accelerator.
* OptimalTransportNetworks.jl is a new library for [optimizing paths in networks](https://discourse.julialang.org/t/ann-new-optimaltransportnetworks-jl-optimal-transport-networks-in-spatial-equilibrium/119649).
* Guidelines for setting up [Julia on HPC clusters](https://discourse.julialang.org/t/juhpc-hpc-setup-for-juliaup-julia-and-some-hpc-key-packages/119556) in a reliable and clean way.
* Brief discussion on baseline comparisons between [Lux and Jax](https://discourse.julialang.org/t/lux-jl-vs-jax/119654).

Soapboxes (blogs/talks):

* A pleasant and pedagogically valuable blog post on the [Julia type system](https://dev.to/jballanc/some-types-part-1-3b1n)
* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).
* Consider subscribing to the [community calendar](https://julialang.org/community/#events) to be informed of upcoming virtual meetings and talks.
* Consider attending the triage meetings of the Julia core contributors (organized on Slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack. [Minutes are kept](https://hackmd.io/@LilithHafner/HJaw__uMp).

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
