@def title = "This Month in Julia World (July 2023)"
@def authors = "Stefan Krastanov"
@def published = "30 July 2023"
@def rss_pubdate = Date(2023, 7, 30)
@def rss = """Community Newsletter for July 2023"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* Guillaume has been doing a lot of valuable work on documenting proper workflows for people starting out with Julia. Check out the [documentation/blog readme](https://github.com/JuliaLang/www.julialang.org/issues/1908) with links to drafts and community discussion. Your help will be greatly appreciated.

* As previously discussed, improvements to the Julia threading model have made visible some concurrency bugs in the ecosystem. There is a detailed blog post and [community discussion on the topic](https://discourse.julialang.org/t/psa-thread-local-state-is-no-longer-recommended-common-misconceptions-about-threadid-and-nthreads/101274).

* Lilith and others have been [discussing better documentation](https://github.com/JuliaLang/julia/issues/50486) of Julia’s attitude to integer overflow (which is vaguely “no warning/error unless the check is relatively cheap or the overflow particularly common” for the base integer types and plenty of customizability for non-base types).

* There was a [long discussion](https://julialang.slack.com/archives/C67TK21LJ/p1689341566774939) about how difficult it is to decide on a good default for the number of threads that Julia starts with, including issues like mismatch between Julia and BLAS threads, hyperthreads vs actual cores, allocated cores for HPC jobs, and more.

## Core repos

* The feature freeze for the upcoming 1.10 happened and there is already a 1.10 alpha and beta.

* Minor improvement to the [inlining heuristics](https://github.com/JuliaLang/julia/pull/50428) (the cost function that decides whether a function is worth inlining). Maybe this is a place where inexperienced folks can start learning about and contributing to the compiler.

* Prem Chintalapudi and others working on a lot of extremely valuable improvements to the documentation of the internals, including [Just-int-time compilation](https://github.com/JuliaLang/julia/pull/50168), [Ahead-of-time compilation](https://github.com/JuliaLang/julia/pull/50376), and [custom compiler optimizations](https://github.com/JuliaLang/julia/pull/50319/files). Also [SSA-IR](https://github.com/JuliaLang/julia/commit/5baaafd693dd32309f5c4317a674302880fbaa0e).

* Some [small](https://github.com/JuliaLang/julia/pull/50320) [experiments](https://github.com/JuliaLang/julia/pull/50321) related to lowering the overhead from mitigating [spectre](https://en.wikipedia.org/wiki/Spectre_(security_vulnerability))-[like](https://en.wikipedia.org/wiki/Meltdown_(security_vulnerability)) CPU vulnerabilities:

* Julia’s REPL has had [suboptimal suggestions](https://github.com/JuliaLang/julia/issues/49466) in autocompletion. There are [improvements](https://github.com/JuliaLang/julia/pull/49562) on the [horizon](https://github.com/JuliaLang/julia/pull/50412).

* Improvements to `@code_llvm` and other introspection tools thanks to [more annotation in the IR](https://julialang.slack.com/archives/C6FGJ8REC/p1689719971869459).

## Dustbin of history

* [The early PL paper on Julia (“Julia: Dynamism and Performance Reconciled by Design” 2018 ACM)](https://dl.acm.org/doi/pdf/10.1145/3276490) is quite the perfect read for folks who want the condensed rigorous version of “What is Special about Julia”.

* While speaking of papers on Julia internals, “[Type stability in Julia: avoiding performance pathologies in JIT compilation](https://dl.acm.org/doi/10.1145/3485527)” (2021) and “[Julia subtyping: a rational reconstruction](https://dl.acm.org/doi/10.1145/3276483)” (2018) are both wonderful.

## Ecosystem

* [FastDifferentiation.jl](https://discourse.julialang.org/t/ann-fastdifferentiation-jl/101556/) is a new type of hybrid automatic differentiation / symbolic differentiation tool. This one did not get much discussion, but it does seem like a tool that will be a gamechanger for many autodiff tasks. As always, do not forget that different tasks require different diff approaches, and check AbstractDifferentiation, ForwardDiff, TaylorDiff, Zygote, Enzyme, StochasticAD, and the early stage Diffractor.

* The [Diffractor](https://discourse.julialang.org/t/diffractor-release/102123) autodiff research project has a release with exciting new mostly-stable functionality.

* For fans of rigorous package testing, there is now [PropCheck.jl](https://discourse.julialang.org/t/ann-propcheck-jl/101481) – a very valuable “[hypothesis](https://hypothesis.readthedocs.io/en/latest/)”-style test generator / fuzzer. If you are a fan of [JET](https://github.com/aviatesk/JET.jl) and [Aqua](https://github.com/JuliaTesting/Aqua.jl), up your bug fighting skills even more with PropCheck.jl

* From the author of PropCheck.jl we also get [RequiredInterfaces.jl](https://discourse.julialang.org/t/ann-requiredinterfaces-jl/101296) for better ways to define/test interfaces and APIs. Check out the first comment in that discussion which lists a couple of other efforts in that direction.

* The JuliaGraphs ecosystem is evolving, as Etienne and Guillaume are [pushing hard](https://github.com/JuliaGraphs/Graphs.jl/issues/146) to improve and unify the entire interface and split it into [GraphsBase.jl](https://github.com/JuliaGraphs/GraphsBase.jl). Long-term goal: support weighted graphs, hypergraphs and graphs with metadata out of the box. Help would be extremely valuable to keep the momentum going.

* The AMDGPU stack is moving ahead with many improvements, not the least being finalizing the [move to a more unified ROCM backend](https://github.com/JuliaGPU/AMDGPU.jl/pull/423#issuecomment-1623226477).

* [Citation management in Documenter.jl](https://github.com/JuliaDocs/DocumenterCitations.jl) getting much better thanks to a number of volunteers cleaning up and upstreaming previous efforts.

* A [JuliaHub client library](https://discourse.julialang.org/t/ann-juliahub-jl-client-library-for-juliahub/101456) for programmatically managing jobs.

* New release with many new features for the distributed arrays (and linear algebra) package [Dagger.jl](https://discourse.julialang.org/t/dagger-development-and-roadmap/101935). The post includes future roadmap as well.

## Blogs and talks

* A [blog post on the use of @eval](https://www.oxinabox.net/2023/06/17/resident-eval.html) but also [some pitfalls to consider](https://julialang.slack.com/archives/C688QKS7Q/p1689608941424169).

* A [talk and blog post](https://discourse.julialang.org/t/blog-post-rust-vs-julia-in-scientific-computing/101711/1) on comparisons between Rust and Julia. Please be gentle if you jump in the conversation, as folks were a bit heated for a bit. But a number of really interesting posts emerged from it: [a](https://discourse.julialang.org/t/blog-post-rust-vs-julia-in-scientific-computing/101711/22?u=krastanov), [b](https://discourse.julialang.org/t/blog-post-rust-vs-julia-in-scientific-computing/101711/24?u=krastanov), [c](https://discourse.julialang.org/t/blog-post-rust-vs-julia-in-scientific-computing/101711/34?u=krastanov), [d](https://discourse.julialang.org/t/blog-post-rust-vs-julia-in-scientific-computing/101711/56?u=krastanov), [e](https://discourse.julialang.org/t/blog-post-rust-vs-julia-in-scientific-computing/101711/64?u=krastanov), [f](https://discourse.julialang.org/t/blog-post-rust-vs-julia-in-scientific-computing/101711/80?u=krastanov)

* [JuliaCon 2023](https://juliacon.org/2023/) just finished. There were a ton of great talks. In the spirit of the newsletter though, let me focus only on ones that seem informative about internals for newcomers and veterans. These are all livestreams – these recordings will be deleted soon but captioned post-processed videos are being prepared.

  * [“The State of Julia”](https://www.youtube.com/live/2D8oRtDJEeg?feature=share&t=951)

  * [Improvements and future work for static analysis (JET.jl)](https://www.youtube.com/live/rMrHCM1Etng?feature=share&t=17129)

  * [Improvements and future work on the Garbage Collector](https://www.youtube.com/live/rMrHCM1Etng?feature=share&t=16467)

  * [The new Package Extension capabilities of Pkg.jl](https://www.youtube.com/live/vG6ZLhe9Hns?feature=share&t=23631)

  * [What is involved in releasing a new Julia version](https://www.youtube.com/live/3AFiBLHlG1A?feature=share&t=20381)

  * [Compiling Julia to “exotic” architectures under severe constraints](https://www.youtube.com/live/3AFiBLHlG1A?feature=share&t=18594)

  * [Thread pinning](https://www.youtube.com/live/rMrHCM1Etng?feature=share&t=1655)

## Sundry

* JuliaHub Receives [13 M\$ Strategic Investment](https://www.prnewswire.com/news-releases/juliahub-receives-13-million-strategic-investment-from-ae-industrial-partners-horizonx-301863793.html) from AE Industrial Partners HorizonX.

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
