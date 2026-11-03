@def title = "This Month in Julia World (October 2023)"
@def authors = "Stefan Krastanov"
@def published = "1 November 2023"
@def rss_pubdate = Date(2023, 11, 1)
@def rss = """Community Newsletter for October 2023"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* A wonderful [essay on microbenchmarks and volunteer labor and community](https://discourse.julialang.org/t/how-i-learned-to-stop-worrying-about-being-fastest-and-love-microbenchmarks/105268) by Jakob.

* Julia now has a generic memory type, representing simply a reserved buffer space in the computer’s memory which can then be used to implement higher level containers like Array. One of the big wins here is that Array is now fully implemented in Julia, making it much simpler. Moreover, the compiler now can reason about and optimize Array operations, because they are not implemented in opaque C code. See [the initial design document](https://hackmd.io/NnLXBeoyRymWgPtHYlW7-A?view#Julep-Redesigning-Array-using-a-new-lower-level-container-type), the [pull request](https://github.com/JuliaLang/julia/pull/51319), and this [slack thread](https://app.slack.com/client/T68168MUP/C688QKS7Q).

* A [long slack discussion](https://julialang.slack.com/archives/C67910KEH/p1696772134653049) on allocating and non-allocating inplace sort implementations, in particular noting that allocating sort implementations can be faster than the nonalocating ones.

* In Julia’s type system, the type of types can be quite confusing. Recently popped up in this [slack discussion](https://julialang.slack.com/archives/C67TK21LJ/p1697437685593249), but consult also these very old issues and discussions: [[redesign plans]](https://github.com/JuliaLang/julia/issues/29368), [[tuples of types dispatch confusion]](https://github.com/JuliaLang/julia/issues/10947)

* Is `@assert` [misused in the Julia ecosystem](https://julialang.slack.com/archives/C67910KEH/p1697459641994669), is it supposed to mean “debug-time checks that can be turned off” or “data validation checks that are always on”?

* A discussion of the subtleties and edge cases of what is [reasonably called “type piracy”](https://julialang.slack.com/archives/C67TK21LJ/p1697567034280449)

* What can potentially be done to make [Julia’s garbage collection more “realtime friendly”](https://julialang.slack.com/archives/C03A7RP2ZMW/p1697571169667689).

* A [slack discussion](https://julialang.slack.com/archives/C67910KEH/p1697650494495729) on the unfortunate issues in the way the trait API of iterables is designed and potential future improvements.

* A [discourse thread](https://discourse.julialang.org/t/compilation-options-for-downfall-mitigation/104844) on workarounds for when your CPU is modified by an update meant to protect you from sidechannel attacks (at the price of much worse performance).

## Core repos

* Precompile files (i.e. the cache files containing the compiled machine code, usually stored in a hidden .julia folder, and which are the recent solution to the TTFX problem) [are now relocatable](https://github.com/JuliaLang/julia/pull/49866). This is a prerequisite for future endeavors like distributing precompiled files so that users do not need to compile installed libraries themselves.

* There has been work for a while to support alternative Garbage Collectors in Julia. An [official interface](https://github.com/JuliaLang/julia/pull/51788) for hooking up such alternatives is now in a draft state.

* [libffi](https://en.wikipedia.org/wiki/Libffi) is a library that lets you call functions “compiled by someone else” in runtime, without needing a compiler/linker. It is particularly useful for interpreters that might want to call into a C library without access to a compiler. This [draft PR](https://github.com/JuliaLang/julia/pull/51552) explores using libffi in compiler-less sessions of the Julia interpreter for ccall support.

* [AnnotatedStrings](https://github.com/JuliaLang/julia/pull/49586#issuecomment-1747210713) is now merged!!! It was a grueling endeavor, but thanks to @tecosaur we now have support for wonderfully richly formatted strings in base julia (in the terminal and beyond).

* [Julia is transitioning to LLVM 16](https://github.com/JuliaLang/julia/pull/51591). The [last step](https://github.com/JuliaLang/julia/pull/51720) is still pending. Relatedly, [LLVM 16 is now being build and made available in Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil/pull/6777), Julia’s repository of compiled external packages.

* An [interesting new optimization in the compiler](https://github.com/JuliaLang/julia/pull/51674) which might be a good spot for newbies to learn more about how optimizations are written in Julia itself. This new one simplifies try-catch blocks if it can prove that no exceptions can be triggered.

## Ecosystem

* [StatisticalMeasures.jl](https://discourse.julialang.org/t/ann-two-new-packages-for-metrics-in-statistics-and-ml/104374) was recently released, a package providing a wide [variety of measures](https://juliaai.github.io/StatisticalMeasures.jl/dev/auto_generated_list_of_measures/#aliases) that can be calculated for probability distributions (e.g. entropies, mean errors, etc). Would be of use to anyone doing ML or probability programming or Bayesian “stuff”.

* [Conditions.jl](https://discourse.julialang.org/t/ann-package-conditions-jl/104863) provides a very interesting alternative to exception-based control flow. It implements the Common Lisp “signaling a condition” approach instead of the typical “throwing an exception”.

* [AbstractDifferentiation.jl](https://juliadiff.org/AbstractDifferentiation.jl/stable/) has a new more polished stable version 0.6. This package is of great use to people that want to ensure their code works with many different differentiation frameworks.

* [Finch.jl](https://github.com/willow-ahrens/Finch.jl) is a fantastic “nested loop optimizer” that supports sparse and dense multidimensional arrays. It evolved out of the older [TACO](https://discourse.julialang.org/t/100x-tensor-algebra-speedup/6807/44) project.

* The [standard libraries shipped in Julia are becoming more decoupled](https://discourse.julialang.org/t/psa-compat-requirements-in-the-general-registry-are-changing/104958) from Julia itself, with a ton of logistics benefits in terms of faster bugfixes, faster development, easier testing, and more. That would [require some minor changes](https://discourse.julialang.org/t/how-does-compat-requirement-changes-for-general-registry-affect-package-maintainers/104960) in how people declare compat bounds in newly released versions of their packages. The Compat bot on github [mostly automated that work](https://github.com/JuliaRegistries/CompatHelper.jl/pull/457).

* Consider adding the [“typos” CI action](https://github.com/crate-ci/typos) to your repository – it was recently [added to Documenter.jl](https://github.com/JuliaDocs/Documenter.jl/blob/master/.github/workflows/SpellCheck.yml) and it catches a lot of annoying spelling errors with virtually no false positives.

* [Quantica.jl](https://discourse.julialang.org/t/ann-announcing-quantica-jl/105190) is a wonderful new tool for modeling crystals and other solid state structures.

* We discussed Mousetrap.jl recently - a tool for building GTK GUIs. It is a wonderful project that has gained [many new features in a short time, including support for embedding GLMakie](https://discourse.julialang.org/t/mousetrap-the-new-julia-gui-engine-now-supports-glmakie-macos/105252).

* [OptimalSortingNetworks.jl](https://discourse.julialang.org/t/ann-optimalsortingnetworks-sort-small-tuples-efficiently-and-with-good-type-inference/105544/) is a ridiculously fast tool for sorting small containers, in particularly typestable sort of tuples.

## Blogs and talks

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English)

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* There is an irregular “[Julia Gender Inclusive Community Hour](https://discourse.julialang.org/t/announcing-julia-gender-inclusive-s-community-hour/105100)”, frequently with very interesting technical presentations. Consider clicking “watching” on these Discourse threads for future announcements.

## Sundry

* [Ousterhout's dichotomy](https://en.wikipedia.org/wiki/Ousterhout%27s_dichotomy) is a useful to know principle that Julia proves to be a fallacy. It distinguishes scripting languages from systems languages, i.e. another name for the two-language problem.

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
