@def title = "This Month in Julia World (March 2024)"
@def authors = "Stefan Krastanov"
@def published = "2 April 2024"
@def rss_pubdate = Date(2024, 4, 2)
@def rss = """Community Newsletter for March 2024"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* A convenient way to run [Julia in Google Colab notebooks](https://github.com/ageron/julia_notebooks).

* The [Modern Julia Workflows blog](https://modernjuliaworkflows.github.io/) is becoming a great resource to new and established users interested in best practices and quality-of-life improvements.

* A discussion on the utility and feasibility-of-implementation of immutable arrays in Julia that emerged on a [recently closed PR](https://github.com/JuliaLang/julia/pull/44381#issuecomment-2018340889).

## Core repos

* A subproject/workspace feature is [now available in the package manager](https://github.com/JuliaLang/Pkg.jl/pull/3841/). This feels like it came out of nowhere, but it will drastically simplify the lives of developers keeping doc and test environments in sync with the corresponding package. Discussed also on [slack](https://julialang.slack.com/archives/C6FGJ8REC/p1711585454972049).

* A bit of a long story in the type domain. `Tuple` has many special properties not shared by other types and `Tuple{Union{}}` has been problematic for a while. Here is a sequence of interesting fixes and side effects from these fixes over the last few months: [gh49111](https://github.com/JuliaLang/julia/pull/49111), [gh52385](https://github.com/JuliaLang/julia/issues/52385), and [gh53452](https://github.com/JuliaLang/julia/pull/53452) (among many other discussions).

* We now have [`waitany` and `waitall`](https://github.com/JuliaLang/julia/pull/53341#) functions for waiting on multiple tasks at once.

* Shadowing / redefining methods [is slightly different now](https://github.com/JuliaLang/julia/pull/53415). It seems it has been used to great effect in Pluto, but now that it is a core part of julia, it has [caused some minor confusion as well](https://github.com/JuliaLang/julia/issues/53814).

* Claire, the awesome hacker who brought the new JuliaSyntax parser (and its much better error message), might be [tackling the lowering stage in the future](https://github.com/c42f/JuliaLowering.jl). If you are interested in julia internals, this could be a great place to contribute.

* [ExplicitImports.jl](https://ericphanson.github.io/ExplicitImports.jl/stable/) is a wonderful new linter for import statements in julia packages, recently discussed on [slack](https://julialang.slack.com/archives/C6FGJ8REC/p1710877621096429).

## Dustbin of history

* `literal_pow` is a neat trick Julia uses as a workaround for the lack of dispatch on values. Discussed recently on [slack](https://julialang.slack.com/archives/C6FGJ8REC/p1710162962309629) and [github issues](https://github.com/JuliaLang/julia/issues/28685). It led to a [fun discussion on the potential future of literal integer types](https://julialang.slack.com/archives/C67910KEH/p1710168731930689).

## In search of contributors

- no one this month, but do not forget to announce here if you are searching for helping hands

## Ecosystem

* [Documenter 1.3 was recently released](https://discourse.julialang.org/t/ann-documenter-v1-3-0-inventories/111139), with support for “inventories”, a standard permitting cross-package documentation reference, also supported by the Python ecosystem.

* [StringUnits.jl](https://discourse.julialang.org/t/ann-stringunits-jl/112202) is a wonderful “string indexing” library that lets you easily ask for bytes/characters/graphemes or other units in unicode strings.

* [Chairmarks.jl](https://discourse.julialang.org/t/chairmarks-jl/111096) is a recent alternative to BenchmarkTools.jl taking a different approach for the sake of developer UX and potentially future automated regression testing.

* A long [slack discussion](https://julialang.slack.com/archives/C6G240ENA/p1710268737562409) about the new [DifferentiationInterface.jl](https://gdalle.github.io/DifferentiationInterface.jl/dev/), an experimental package trying to work around some of the limitations of AbstractDifferentiation.jl. The thread also contains remarks on how these limitations can potentially be fixed without the need for a new package (but experimentation here seems to be valuable).

* [About.jl](https://github.com/tecosaur/About.jl) discussed on [slack](https://julialang.slack.com/archives/C67910KEH/p1710269849595409) – a wonderful small package about introspecting type instances in a pretty-printed fashion.

* [SIMDFastMath.jl](https://discourse.julialang.org/t/ann-simdmathfunctions-jl-fast-vectorized-mathematical-functions-for-simd-jl-using-sleefpirates-jl/111021) for SIMD-ified math functions.

* [Supposition.jl](https://discourse.julialang.org/t/ann-supposition-jl/111338) – a new property-based-testing and fuzzing tool.

* A neat [variables exploration](https://discourse.julialang.org/t/wip-rfc-ann-plutovariableexplorer-inspect-the-variables-definined-in-a-pluto-notebook/112327) tool for the Pluto notebook.

* A fun discussion about some of the [weirder internals of the Enzyme.jl](https://discourse.julialang.org/t/what-are-autodiff-deferred-and-autodiff-thunk-for-in-enzyme/112065) autodiff tool.

* [PAndQ.jl](https://discourse.julialang.org/t/pandq-jl-a-computer-algebra-system-for-propositional-logic/111752) is a new computer algebra tool for propositional logic (with a wonderful name).

* The agent modeling toolkit [Agents.jl has a significant new release](https://discourse.julialang.org/t/agents-jl-v6-releases-announcement-post/111678) with a great deal of new capabilities.

* [HampelOutliers.jl](https://discourse.julialang.org/t/ann-hampeloutliers-jl/111844) can help significantly with outliers detection and rejection from time series data.

* Anyone working with with stable probability distributions would probably be interested in [StableDistributions.jl](https://discourse.julialang.org/t/ann-stabledistributions-jl-stable-distributions-in-julia/111711), which extends the already sophisticated Distributions.jl

* Tidier is a Julia org for data science work in the style of R’s tidyverse that we have mentioned here before. They are nearly ready with their [TidierDB.jl](https://github.com/drizk1/TidierDB.jl) database interface as discussed on [slack](https://julialang.slack.com/archives/C674VR0HH/p1710941523197439).

* Yet more tools for working with geographic map projections and plots thanks to [CoordRefSystems.jl](https://discourse.julialang.org/t/ann-coordrefsystems-jl/111950) – seems to be a pretty hot topic in Julia.

* WriteDocx.jl for generating high-quality word documents and SummaryTables.jl for generating publication-quality tables (in various formats) were [recently contributed by PumasAI](https://discourse.julialang.org/t/ann-summarytables-jl-writedocx-jl/112240).

## Other ecosystems

* A wonderful new [book on Differentiable Programming](https://news.ycombinator.com/item?id=39793191).

* [Batched BLAS](https://icl.utk.edu/bblas/) – an extension to BLAS for better batched operations, now frequently needed in ML workloads.

* The new NonlinearSolve.jl [discussed on Hacker News](https://news.ycombinator.com/item?id=39824019).

* You might have heard the fantastic story of the recently uncovered backdoor in the XZ compression utility. Julians [do not have anything to worry about](https://discourse.julialang.org/t/psa-backdoor-in-xz-utils-and-relevance-for-the-julia-ecosystem/112328).

## Blogs and talks

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack.

* EnzymeCon – an impressive conference on autodiff tooling and specifically on the Enzyme ecosystem [has published its videorecorded talks](https://discourse.julialang.org/t/enzymecon-live-stream-links/112102).

* The Genie framework is a great tool for creation of (data-focused) web apps in julia. Recently featured in a [blog](https://genieframework.com/blog/best-low-code-tools-for-building-julia-web-apps).

* A lovely little online book on introduction to Julia and statistics with an original title: [Romeo and Julia, where Romeo is basic statistics](https://b-lukaszuk.github.io/RJ_BS_eng/).

## Sundry

* [Glass Notebook](https://discourse.julialang.org/t/publish-interactive-pluto-notebooks-with-glassnotebook-io/102801) – a new service for hosting static and interactive Pluto notebooks.

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
