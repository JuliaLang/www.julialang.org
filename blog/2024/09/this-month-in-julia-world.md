@def title = "This Month in Julia World (August 2024)"
@def authors = "Stefan Krastanov"
@def published = "8 September 2024"
@def rss_pubdate = Date(2024, 9, 8)
@def rss = """Community Newsletter for August 2024"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

A bit shorter this time, as the start of the school year is hectic. Many interesting things might have been missed, so do not hesitate to post more underneath.

\toc

## Core repos

* There is significant work on making an ahead-of-time compiler for Julia, capable of producing small static binaries (discussed in the last newsletter and at juliacon). The near-term plan is for that compiler to not support very dynamic Julia code (e.g. Julia code that is not type stable or that looks like python or that relies on compiling new specializations). There are many situations in which such code (and Julia’s capability to work with such code) is extremely valuable, which led to an interesting [slack discussion](https://julialang.slack.com/archives/C688QKS7Q/p1723302373997629) on how the ahead-of-time compiler might lack support for important Julia idioms or how its use might bias future Julia development away from interesting Julia projects that depend on dynamism (e.g. Dagger.jl).

* The Ordinary Diff Eq ecosystem is one of the jewels of Julia, and naturally it has severely taxed the Julia infrastructure. First it was an example of long import times or times-to-first-solve (not as much as Plots or Makie though), but it was also one of the project spearheadign better precompilation coverage bringing time-to-first-X to zero. But with all this precompilation, it is now one of the slowest packages to install (as compilation happens during install), and OOMs kills are not unheard of. Over the last few months, the SciML team has been carving the diff eq libraries in smaller packages, lowering dependencies and available default solvers, so that users do not compile hundreds upon hundreds of solvers when they need only one. This has now led to very interesting workflow/logistics human scalability questions, leading to a very informative [github](https://github.com/JuliaLang/julia/issues/55516) and [slack](https://julialang.slack.com/archives/CBF3Z1D7V/p1724100018014329) discussions on how to improve the ergonomics of the “package extension” feature (the one that makes it easy to have code be loaded conditionally on the presence of other packages).

* “JET, a package which can systematically analyze your code to detect runtime dispatch, now integrates conveniently with Cthulhu, a package for gaining insights about the source of runtime dispatch and other failures of inference.” as Tim [announced](https://discourse.julialang.org/t/ann-jet-cthulhu-integration/118430) recently.

* With the long compilation times we have, is it not annoying when you `add` a new package and that package decides to update an already installed package, leading to a cascade of new compilations in all other dependent packages. We have a package management configuration that basically forbids that – it is [considered](https://github.com/JuliaLang/Pkg.jl/issues/3905) to be turned on by default in upcoming versions.

* It is always fun to [discuss](https://julialang.slack.com/archives/C6A044SQH/p1725294278914049) the difference between `isequal`, `==`, and `===` and which one is used for `in` checks for various containers.

## Dustbin of history

* Local `const` is not really a thing in julia, partially because semantics for it are unclear, partially because const checking should be static for performance reasons (a problem not present with global `const`). Delving deeper into the question of semantics (and the usually unrelated fact that functions are `const`) leads to [some wild edge cases](https://github.com/JuliaLang/julia/issues/5148#issuecomment-1336341977).

## In search of contributors

* For a simple way to get into Makie development there is a new set of small changes that the team is making to every single plot recipe, and for which they are eager to onboard new developers. See on [github](https://github.com/MakieOrg/Makie.jl/issues/4304) and [slack](https://julialang.slack.com/archives/C8RQUU2KH/p1725315751399949).

* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science. Few thousand \$ will be paid out already in October for bounties from August.

* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.

* ChainRules, a foundational package to the Julia autodiff effort is looking for a [new primary maintainer](https://discourse.julialang.org/t/chainrules-project-looking-for-a-new-primary-maintainer/115636).

## Ecosystem

* A ton of [new symbolic solvers](https://discourse.julialang.org/t/new-symbolic-solver-for-symbolics-jl/118466) in Symbolics.jl.

* A in-depth post on the importance of being able to gradually add Julia-implemented capabilities to a Python codebase. This would benefit the scientific open source ecosystem as a whole and our community in particular, but currently extending Python with C or Rust is easier than extending Python with Julia. On [discourse](https://discourse.julialang.org/t/gradual-julia-ization-of-python-libraries/117828).

* Moshi.jl, the newest contender for Algebraic Data Types in julia, is receiving a lot of love and in-depth discussion on [slack](https://julialang.slack.com/archives/C6FGJ8REC/p1724745949618699).

* An interesting discussion on the design and an upcoming breaking release of DifferentiationInterface on [slack](https://julialang.slack.com/archives/C6G240ENA/p1725554566281739).

* A lot of wonderful improvements to ThreadPinning.jl, a library that tells your OS to not move your threads from core to core, helping significantly with cache coherency. On [slack](https://julialang.slack.com/archives/CBFP2PTTR/p1722879772264579).

* The `julia-actions/setup-julia` GitHub CI action now permits you to request the minimum julia version from your Project.toml instead of having to manually keep them in sink. Announced and future improvements discussed on [slack](https://julialang.slack.com/archives/C67910KEH/p1725035583791299).

* A new, very opinionated, non-configurable code formatter: [Runic.jl](https://discourse.julialang.org/t/runic-jl-a-code-formatter-with-rules-set-in-stone/117898)

* Plans to significantly rework the codebase and capabilities of [PrettyTables.jl](https://discourse.julialang.org/t/current-state-and-the-future-of-prettytables-jl/118455/)

## Blogs and talks

* [MicroGrad.jl](https://liorsinai.github.io/machine-learning/2024/07/27/micrograd-1-chainrules.html) is a wonderful tutorial on automatic differentiation.

* A new mini-course on [Topological Data Analysis](https://discourse.julialang.org/t/minicourse-topological-data-analysis-with-julia/118072) with Julia.

* JuliaHPC is running a [helpful reference website](https://juliahpc.github.io/) for anyone interested in best practices for HPC.

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack. [Minutes are kept](https://hackmd.io/@LilithHafner/HJaw__uMp).

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
