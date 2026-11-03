@def title = "This Month in Julia World (February 2024)"
@def authors = "Stefan Krastanov"
@def published = "1 March 2024"
@def rss_pubdate = Date(2024, 3, 1)
@def rss = """Community Newsletter for February 2024"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* The VS Code julia extension now shows inline type hints as [discussed on slack](https://julialang.slack.com/archives/C6FGJ8REC/p1707648298734779).

* The juliaup installer (the official one) now provides for an [easy way to run the latest nightly version of julia](https://discourse.julialang.org/t/nightly-channel-in-juliaup/110080).

* For folks that want to learn more about warts in the type system, [check out this slack thread about `Tuple{Type{Int}}`](https://julialang.slack.com/archives/C67910KEH/p1707840126142799)

* Fun discussion of weird edge-cases in the type system, together with a few PRs that fix them: [discourse](https://discourse.julialang.org/t/intransitivities-in-subtyping/109266), [pr1](https://github.com/JuliaLang/julia/issues/53019), [pr2](https://github.com/JuliaLang/julia/issues/53021), [pr3](https://github.com/JuliaLang/julia/pull/53034)

* This has started coming up very regularly: [how do you export a type from a package extension](https://julialang.slack.com/archives/C67910KEH/p1707831201662289) (you do not, really).

* A very exciting proposal to provide precompiled caches through the pkg servers, so that users do not need to wait for precompilation when they install a library. A [detailed proposal](https://hackmd.io/@StefanKarpinski/H1eY_uKiT) and [a slack discussion](https://julialang.slack.com/archives/CBF3Z1D7V/p1708010885588819).

* There is [growing consensus](https://github.com/JuliaLang/julia/pull/42080) that `using Foo` is too polluting to the namespace of a library, and people are encouraged to switch to `using Foo: Bar`. There is even now [testing/CI tools for that](https://discourse.julialang.org/t/ann-explicitimports-jl-tooling-to-help-use-and-maintain-explicit-imports-in-your-package/110973).

* How difficult would it be to support pre-emptible threads in Julia, similar to Erlang or Go. See this [slack discussion](https://app.slack.com/client/T68168MUP/C688QKS7Q).

* More experiments with better support for fixed-sized arrays and all the potential compiler guarantees that brings [discussed on slack](https://julialang.slack.com/archives/C677F4ABD/p1708616180360289).

* Educational discussion on the difference between a `struct` and a `mutable struct` with all fields marked `const` [on slack](https://julialang.slack.com/archives/C67910KEH/p1708704454889209).

* An [interesting slack thread](https://julialang.slack.com/archives/C67TK21LJ/p1709020641276729) on “errors as return types” and the `Option` and `Some` types, of course ending up with discussion of sum types again.

## Core repos

* The way the compiler allocates memory is very different from how other allocations happen. There is a suggestion to set up the garbage collector so that separate memory pool is used for allocations done by the compiler, significantly lowering memory fragmentation. See [issue](https://github.com/JuliaLang/julia/issues/52860), [draft PR](https://github.com/JuliaLang/julia/pull/53131), and [slack](https://julialang.slack.com/archives/C688QKS7Q/p1706642377537749) discussion.

* You can now use the -m CLI flag to directly [run the `main` function of a module.](https://github.com/JuliaLang/julia/pull/52103)

* Many improvements to the [registration process for the General registry](https://discourse.julialang.org/t/improvements-to-the-package-registration-workflow-in-the-general-registry/109595).

* Now it is [much easier to customize the printing of your own testset types](https://github.com/JuliaLang/julia/pull/53215) (for when you want custom testing behavior).

* Project.toml files will soon support [`[sources]` sections that specify paths to installed packages](https://github.com/JuliaLang/Pkg.jl/pull/3783), making many dev workflows more convenient.

* Long ago a profile-guided-optimization recipe for Julia was prepared. It is [now merged](https://github.com/JuliaLang/julia/pull/45641).

* Convenient CLI flag for Julia to [start a temporary environment](https://github.com/JuliaLang/julia/pull/51149).

## In search of contributors

* [FillArrays.jl](https://github.com/JuliaArrays/FillArrays.jl) is looking for people to contribute to the package. No specific domain expertise is necessary, just a general understanding of writing performant code in Julia. Contributions will mainly be in improving the interoperability with other packages, which may be either through bug fixes, testing package composition, or through adding package extensions. FillArrays is a transitive dependency of nearly two thousand packages, so any contribution would have a significant impact across the ecosystem.

* Looking for contributors to the PySR/[SymbolicRegression.jl](https://github.com/MilesCranmer/SymbolicRegression.jl)/DynamicExpressions.jl ecosystem. There is a variety work related to “PySR v2” — significant contributors will be invited to coauthor, when PySR will become more of a community tool for symbolic discovery. Of particular need: (1) CUDA.jl kernel optimization, (2) interfacing with PythonCall.jl, (3) making the SymbolicRegression API more generic and idiomatic, and (4) interfaces with Flux.jl(/other). For general contributions, all skill levels are welcome to get in touch (mc2473@cam.ac.uk).

## Ecosystem

* The new [Codecov action requires a bit more setup](https://discourse.julialang.org/t/psa-new-version-of-codecov-action-requires-additional-setup/109857). If you use it in your CI, make sure it has not broken. Discussed also on [slack](https://julialang.slack.com/archives/C67TK21LJ/p1707166568107289).

* A [new CI tool exists now to test lower bounds](https://discourse.julialang.org/t/psa-add-downgrade-ci-to-better-check-version-compatability/110063) of your Project.toml compat sections. Quite useful if you want to ensure that your package is resilient when installed together with other ancient libraries.

* [Pluto now visualizes stack traces](https://discourse.julialang.org/t/new-stack-traces-in-pluto-more-colorful-less-intimidating/110507) in an awesome, detailed, user friendly way.

* A well-known frustration is that Revise does not automatically revise struct/type definitions. [This thread discusses tools](https://discourse.julialang.org/t/ann-strucrev-revise-type-definitions-as-you-go/109959) to work around that issue.

* JuliaHealth now has two monthly meeting to better accommodate timezones: one starting at 12PM EST for Americas/Africa/Europe areas, and another at 12PM IST for folks in Asia/Oceania. Check the [community calendar for dates](/community/#events)

* [Handcalcs.jl](https://discourse.julialang.org/t/handcalcs-jl-for-more-readable-calculations/109891) for visualizing your Julia computational kernels in pretty LaTeX math.

* A [detailed comparison of many different optimizers](https://discourse.julialang.org/t/comparison-of-derivative-free-black-box-optimization-algorithms-in-julia/109614) in Julia.

* For those interested in sum types, another interesting development is [MixedStructTypes.jl](https://discourse.julialang.org/t/ann-mixedstructtypes-jl-pack-heterogeneous-types-in-a-single-one/109204).

* More tools for simplifying the implementation of pretty printing methods with [AutoPrettyPrinting.jl](https://discourse.julialang.org/t/ann-announcing-autoprettyprinting-jl/109410).

## Blogs and talks

* An interesting [comparison of high-performance toy parser implementations in Julia and Mojo](https://viralinstruction.com/posts/mojo/), together with some personal reflections of the feelings a Julia power user has for Mojo.

* The blog Modern Julia Workflows has published a second tutorial, [showing all the details of package creation](https://modernjuliaworkflows.github.io/sharing/).

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack.

## Sundry

* Jacob Zelko (TheCedarPrince) has stepped up as one of the community administrators for this year’s Google Summer of Code.

* Google Summer of Code season is here! Make sure to update your [projects on the JuliaLang website](/jsoc/projects/).

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
