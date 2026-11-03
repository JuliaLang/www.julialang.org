@def title = "This Month in Julia World (January 2024)"
@def authors = "Stefan Krastanov"
@def published = "1 February 2024"
@def rss_pubdate = Date(2024, 2, 1)
@def rss = """Community Newsletter for January 2024"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* Julia 1.10 was released around Christmass. See the [release highlights](/blog/2023/12/julia-1.10-highlights/).

* It seems we all agree that it would be incredibly valuable to have better ways to call julia from inside python. This [discourse thread](https://discourse.julialang.org/t/is-pyjulia-maintained/109277/) has plenty of discussion on the topic, but specifically check out [Chris’s comments](https://discourse.julialang.org/t/is-pyjulia-maintained/109277/30?u=krastanov) which has a bunch of constructive suggestions towards the end.

* Rounding operations on Complex numbers (into presumably complex integers) are pretty difficult to do consistently. On the issue tracker folks have been discussing various ways to do it, and the dangers of being too permissive in what interfaces might emerge by accident. It is not feasible to summarize the entire story, as the thread is a bit meandering and has some contextual miscommunications, but a valuable read nonetheless. Arbitrarily, consider starting with this [comment](https://github.com/JuliaLang/julia/pull/51141#issuecomment-1872165241).

* A lot of ongoing discussion in various places on how to deal with asynchronous exceptions (interrupts from the outside or stack overflows, that can happen at much weirder ill-defined times compared usual exceptions). This is a [good starting point for the discussion](https://github.com/JuliaLang/julia/issues/52291). There are comments with interesting references to [how other languages deal with this](https://github.com/JuliaLang/julia/issues/52291#issuecomment-1912807326) as well.

* Now that we have a `public` keyword, people are thinking about how to [better protect (or mark as sensitive) package internals](https://github.com/JuliaLang/julia/issues/52314), to avoid accidental dependencies on unstable implementation details.

* A wonderful explanation of how [“world splitting” used to be a great optimization in the compiler that can now lead to invalidating large amounts of code](https://discourse.julialang.org/t/how-is-it-that-new-julia-programmers-tend-to-abuse-type-annotations/108465/18), cause recompilation, and de-optimization. The thread as a whole has other useful pieces of wisdom, but it is a bit meandering.

* A [wonderful case study in fixing method invalidations and compilation latency](https://discourse.julialang.org/t/case-study-method-invalidations-caused-by-pkg-jl-with-julia-1-11/109038) (using Pkg.jl as an example). See this [related older post](https://discourse.julialang.org/t/how-to-help-reduce-package-load-latency/105294) on similar topics.

* An interesting discussion on the idiosyncrasies of computing type intersections (the set of types that are at the same time subtypes of two given types) in Julia. The operation is [not commutative](https://discourse.julialang.org/t/fr-provide-a-predicate-to-check-whether-a-type-intersection-subtypes-some-type/109303).

* Fun examples of how the update to a new LLVM is now changing the loop unrolling behavior (occasionally to detrimental effects) on [slack](https://julialang.slack.com/archives/C688QKS7Q/p1705009274866029) and [github](https://github.com/JuliaLang/julia/issues/48236).

## Other ecosystems

* With all the work on effect analysis in the julia compiler, [it might be fun to see some similar work discussed in Rust](https://news.ycombinator.com/item?id=39005780).

* Julia is unsurpassed in its support for writing kernels for weird non-CPU hardware, but it is worth seeing what other communities are contributing to this topic as well: [GPU programming in Chapel](https://news.ycombinator.com/item?id=38988762).

## Core repos

* If you are a developer running CI for your packages, consider turning on the new [julia caching recipe for GitHub Actions](https://github.com/julia-actions/cache#usage). In my experience, for a repo where tests take around 10min, `julia-actions/cache` makes them 3min faster (compared to when one uses the github provided `cache` action).

* If you are frequently moving between julia versions for the same project (e.g. as a developer), now you can have [separate Manifest files for each julia version](https://github.com/JuliaLang/julia/pull/43845)

* We just recently finally [transitioned Julia to LLVM v16](https://github.com/JuliaLang/julia/pull/51720). A brave new contributor is [attempting the LLVM v17 transition](https://github.com/JuliaLang/julia/pull/53070) now. Check the #llvm channel on slack for a cute story of their nerdsniping.

* Your error messages can be better if you use “error hints” – additional messages generated depending on properties of the thrown error. Check this recent example which provides a [helpful message to distinguish `max` and `maximum`](https://github.com/JuliaLang/julia/pull/52716).

* The official download page for the language now [specifically calls out juliaup as the most convenient installation tool](/downloads/).

* Steven has been spearheading the effort to ensure that [every exported symbol has a docstring](https://github.com/JuliaLang/julia/issues/52725) (a perfect place for a novice to contribute a patch to julia itself). Relatedly, now you can [add such checks to your tests and CI](https://github.com/JuliaLang/julia/pull/52723) thanks to new Base functionality.

* If you are doing a lot of metaprogramming you might like `remove_linenums!` [recently made public](https://github.com/JuliaLang/julia/pull/52911).

* Wouldn't it be convenient if we could type `using SomePackageWithLongName as ShortName`. [Lilith is working on it](https://github.com/JuliaLang/julia/pull/52821).

* A neat example of a microoptimization in Base julia, drastically [improving the performance of creating an empty Dict](https://github.com/JuliaLang/julia/pull/52912).

## Dustbin of history

* There is a story about how Fortran is better than C for scientific programming because Fortran arrays are guaranteed to not alias (to not overlap in memory), while working with a C array carried simply by a pointer does not let you guarantee that you are not also modifying some other array nearby in memory, so the compiler can not prove that values have not been modified. Julia has a long history of discussing aliassing including new ways to promise to the compiler that things do not alias (but please do not lie to the compiler). See [8087](https://github.com/JuliaLang/julia/issues/8087), [19658](https://github.com/JuliaLang/julia/issues/19658), and [31018](https://github.com/JuliaLang/julia/pull/31018), as well as [UnsafeAssume.jl](https://juliahub.com/ui/Packages/General/UnsafeAssume/)

## Ecosystem

* The autodiff zoo of tools in Julia has a newly updated and [wonderfully detailed website showcasing the richness of autodifferentiation approaches available in the language](https://juliadiff.org/).

* LoopVectorization.jl is being deprecated on julia 1.11 due to the accumulated maintenance burden. In no particular order see [[github0](https://github.com/JuliaSIMD/LoopVectorization.jl/issues/518)], [[github1](https://github.com/JuliaSIMD/LoopVectorization.jl/pull/519)], [[github2](https://github.com/JuliaSIMD/LoopVectorization.jl/pull/524)], [[slack1](https://julialang.slack.com/archives/CN00LP5UK/p1705527508651429)], [[slack2](https://julialang.slack.com/archives/CF53T1DU4/p1704998818585139)]. One day [LoopModels](https://github.com/LoopModels/LoopModels) might become a better alternative.

* A reminder that DataStructures.jl really needs some tender love and care – it is fairly foundational for the ecosystem, very stable, but it needs a few minor hurdles dealt with before a long-term v1 is released. [Please consider volunteering](https://github.com/JuliaCollections/DataStructures.jl/issues/479#issuecomment-682449805).

* Julia’s method specialization capabilities (compiling methods for each type it encounters) is fundamental to its amazing performance. However, there is code that is inherently type unstable for good reasons, which leads to incredibly bad performance (because of constant compilation of yet more specialized methods). With `@nospecializeinfer` you can mark such situations, ensuring the compiler does not go wild. [JLD2.jl](https://github.com/JuliaIO/JLD2.jl/pull/527) is an example where we get multiple orders of magnitude improvement in performance (it is a serialization library).

* A [pair](https://discourse.julialang.org/t/im-creating-a-2d-platformer-using-julia/108057) of [posts](https://discourse.julialang.org/t/i-created-a-2d-platformer-with-julia-download-link-an-update-on-julgame/108778) on creating a 2D platformer game in Julia. Pretty wonderful introduction to the language. Do not forget to check out the video recording.

* We have mentioned Tidier.jl in the past – they are a wonderful datascience tool with similar design style and breadth of capabilities to R’s tidyverse. They made a recent [“official” announcement to describe the entirety of their ecosystem](https://discourse.julialang.org/t/ann-belatedly-announcing-tidier-jl/109222).

* [Oxygen.jl](https://discourse.julialang.org/t/ann-oxygen-jl-v1-4-3-metrics-dashboard/108807), a tool for creating web APIs, is seeing a new release, including a neat performance and utilization dashboard.

* [LengthFreeStaticMatrices.jl](https://discourse.julialang.org/t/ann-lengthfreestaticmatrices-jl-drop-length-parameters-for-static-matrices/108235) is a very neat new take on Static arrays with potentially more pleasant type-specification API.

* A [brief slack discussion](https://julialang.slack.com/archives/C6G240ENA/p1704631849320479) on the status of AbstractDifferentiation.jl (a unified autodiff interface to the many Julia autodiff backends) and how plausible it is that Enzyme can be used in a high-performance fashion through it.

* JuliaFolds2 and Transducers could use some maintenance help (removing cruft / simplifying Transducers). It would be a good way to jump into the Julia ecosystem and provide volunteer service – do not hesitate to reach out to the organization.

* Not recent, but I found it only recently, [ReadableRegex.jl](https://github.com/jkrumbiegel/ReadableRegex.jl) is wonderful if you want a more pleasant way to write and understand regex incantations.

* Dynare, the macroeconomics modeling tool now has an official [Julia translation](https://dynarejulia.github.io/Dynare.jl/dev/).

* [WeatherReport.jl](https://discourse.julialang.org/t/ann-weatherreport-jl-a-simple-weather-app-for-the-julia-repl/108298) - a weather app in Julia.

* [ACAFact.jl](https://discourse.julialang.org/t/ann-acafact-jl-fast-low-rank-approximation-of-matrices-with-greedy-pivoting/108317) - fast low-rank approximation of matrices with greedy pivoting

* [Showflurry.jl](https://github.com/SnowflurrySDK/Snowflurry.jl) - a quantum circuit SDK for the Anyon Systems Inc hardware.

* [Malt.jl](https://discourse.julialang.org/t/ann-malt-jl-distributed-alternative-used-internally-by-pluto/108401) - an alternative for Distributed.jl used internally by Pluto.jl

* [MusicTheory.jl](https://discourse.julialang.org/t/ann-announcing-musictheory-jl/108444) - for representing musical objects (e.g. pitches and intervals) in Julia

* [Optim.jl](https://discourse.julialang.org/t/ann-optim-jl-updates/109340), one of the earlier function optimization toolkits in Julia is seeing quite a bit of polish in a new release.

* [ComplexityMeasures.jl](https://discourse.julialang.org/t/complexitymeasures-jl-v3-a-mathematically-rigorous-software-for-probability-entropy-and-complexity/108562) is a comprehensive package for… well, complexity measures. Large families of tools to estimate “complexity” (broadly defined) of timeseries and other data.

* [MapMaths.jl and MapMakie.jl](https://discourse.julialang.org/t/mapmaths-and-mapmakie-computing-and-plotting-in-planetary-coordinate-systems/108498) are some new tools for cartography. The linked thread briefly mentions already existing alternatives / related packages like Geodesy.jl and OSMMakie.jl and GeoMakie.jl and how the new packages related to them.

* [SatelliteAnalysis.jl](https://discourse.julialang.org/t/ann-satelliteanalysis-jl-v0-3-0/108781) is now v0.3.0 with significant improvements and changes.

## Blogs and talks

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack.

* A wonder blog, Scientific Coder, discussing the [dev-vs-scientist dichotomy](https://scientificcoder.com/my-target-audience#heading-the-two-culture-problem) in scientific computing and [the two-language](https://scientificcoder.com/how-to-solve-the-two-language-problem) problem.

## Sundry

* Enzyme will be [running their own conference](https://enzyme.mit.edu/conference). Would be of interest to compiler folks and autodiff folks.

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
