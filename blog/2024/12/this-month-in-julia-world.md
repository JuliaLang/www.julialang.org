@def title = "This Month in Julia World"
@def authors = "Stefan Krastanov"
@def published = "12 December 2024"
@def rss_pubdate = Date(2024, 12, 12)
@def rss = """Community Newsletter for November 2024"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what I found interesting this month, with contributions from the community.

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* Making the creation of `Memory` an “intrinsic” – a special-cased lower-level operation for which the compiler can know more, thus providing better optimisation. Maybe soon enough small arrays will be allocated on the stack and StaticArrays.jl will be needed less. [Original PR](https://github.com/JuliaLang/julia/pull/55913) and the PR being split in more digestible [pieces](https://github.com/JuliaLang/julia/pull/56803).
* The Julia compiler is now just a normal (standard) library that you can install and develop independently of Julia, greatly improving the ergonomics of development. See the [main PR](https://github.com/JuliaLang/julia/pull/56409) and [discussion on slack](https://julialang.slack.com/archives/C6FGJ8REC/p1732091428049159).
* Quite a bit of progress on “compiler plugins”: Few months ago Valentin [prepared a draft](https://github.com/JuliaLang/julia/pull/52964) of how code analyzed by external “abstract interpreters” can be executed within Julia (tools like Enzyme/GPUCompiler/Cassette use various cumbersome workarounds for calling externally analyzed/maniputed/compiled Julia code back into the Julia runtime). He gave a [talk about it at JuliaCon](https://www.youtube.com/watch?v=3fmwk_Wo788). Recently Keno suggested related [capabilities](https://github.com/JuliaLang/julia/pull/56650) stemming from his work on making the compiler just another “independent” standard library. After further considerations, a minimal set of capabilities was distilled into a small PR that [permits `invoke` to accept `CodeInstance`](https://github.com/JuliaLang/julia/pull/56660). `invoke` is the standard way to hook into the method lookup capabilities – you give it the function you want to call, and the type signature for the method you want to call – thus it provides a neat way to override which method is being called. Now it can also be used to call into code compiled by independent Julia compiler plugins, with different semantics compared to the main compiler (e.g. during development of new compiler versions, or completely independent autodiff or GPU compilers). Check the new [docstring](https://github.com/JuliaLang/julia/pull/56660/files#diff-bd17e5243312bddd9795c6500a97b05f40d016c7b8afa33a3505b6beb6ab0adcR2060) for details.
* The “pretty printing” infrastructure in Julia is sophisticated but still quite underdocumented. Topics about it have come up often. One new summary was discussed on [slack](https://julialang.slack.com/archives/C67910KEH/p1732871510105549).
* This newsletter announced the transition to LLVM 16 only last year. We already are on our way to use LLVM 19, so [16 is going out](https://github.com/JuliaLang/julia/pull/56751).
* Fun edge cases with parsing `function()() end` discussed on [slack](https://julialang.slack.com/archives/C67910KEH/p1732783146467099).
* Standardizing how and when global `=` gets lowered, [sticking to using `setglobal!`](https://github.com/JuliaLang/julia/pull/56713), leading to fewer special cases in the compiler passes.
* [`disable_new_worlds()`](https://github.com/JuliaLang/julia/pull/56639) can now be called, freezing the world age, stopping invalidation tracking, significantly improving the performance of code loading, as long as you know that the new code does not invalidate anything. At the same time we also got a lot more [standardization and cleanup to when world ages actually get incremented](https://github.com/JuliaLang/julia/pull/56509).
* Maybe [`nth` will be added to Base](https://github.com/JuliaLang/julia/pull/56580) to generalize `first` and `last`.
* [`LinearAlgebra` was moved to its own](https://github.com/JuliaLang/julia/pull/56637) repository (but it is not yet an external independently-versioned standard library)
* The base `ReentrantLock` might get an optional [warning message on detecting lock contention](https://github.com/JuliaLang/julia/pull/56744).
* A potentially beneficial new coupling between inference and optimization, where [inference can benefit from type information revealed by optimization](https://github.com/JuliaLang/julia/pull/56687).
* An [interesting discussion and potential changes](https://github.com/JuliaLang/julia/pull/56779) to `promote_rule` and `promote_type` and when to use which. Stemming from an earlier conversation on related [antipatterns](https://github.com/JuliaLang/julia/issues/54138).
* The Julia 1.12 [feature freeze is announced](https://discourse.julialang.org/t/julia-1-12-feature-freeze-wednesday-january-8-2025/122902) – January 8th.
* An informative discussion on the lack of [non-blocking IO in Julia](https://discourse.julialang.org/t/non-blocking-network-io/123344) and what it would take to implement it.
* Proposal for significant [improvements to Julia’s IO interface](https://discourse.julialang.org/t/upcoming-video-call-improving-base-io/123171). Direct [link to the proposal itself](https://hackmd.io/@jakobnissen/SksGljkfkl).
* A dive into the [details of constant propagation](https://discourse.julialang.org/t/why-the-compiler-cant-optimize-this-simple-code/122504) and when can the compiler figure those out, with a simple example.
* Yet another insightful discussion on Julia’s type system: [nominal typing vs structural typing/traits](https://discourse.julialang.org/t/why-did-julia-choose-nominal-typing-over-structural-typing-traits/122517).

In search of contributors and new maintainers (specify novice/moderate/expert and internals/domain background necessary):

* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science.
* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.
* ChainRules, a foundational package to the Julia autodiff effort is looking for a [new primary maintainer](https://discourse.julialang.org/t/chainrules-project-looking-for-a-new-primary-maintainer/115636).

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* [Finch.jl v1](https://discourse.julialang.org/t/ann-finch-jl-sparse-and-structured-array-fusion/123178) is out! Only the best compiler for sparse and structured array fusion
* [SymbolicRegression.jl v1](https://discourse.julialang.org/t/ann-symbolicregression-jl-1-0-0-distributed-high-performance-symbolic-regression-in-julia/122791) is out! Your favorite tool for discovering symbolic models behind regression problems.
* A large family of Docstring translation and explanation tooling (including automation through LLMs) published under the umbrella of [DocstringTranslation.jl](https://discourse.julialang.org/t/docstringtranslation-jl-translate-docstrings-in-julia-using-your-preferred-language/123276)
* Interesting interactive-use tool for importing packages from otherwise independent shared environments: [ShareAdd.jl](https://discourse.julialang.org/t/ann-shareadd-jl-making-easy-to-import-packages-from-multiple-environments/121261).
* The Genie.jl web framework now comes with a GUI editor that makes the creation of apps even easier. They recently ran an [app-creation competition](https://genieframework.com/blog/genie-competition-winners).
* [FunctionChains.jl](https://github.com/oschulz/FunctionChains.jl) is a convenient way to iterate functions, while waiting on a decision whether `f^n` will be adopted in the [core language](https://github.com/JuliaLang/julia/pull/39042#issuecomment-2518544572).
* [MiniObserve.jl](https://github.com/mhinsch/MiniObserve.jl) a neat hybrid of `@show`, `@log`, and statistical summaries, on steroids.
* A brief conversation of [`deepcopy` vs `copy`](https://discourse.julialang.org/t/when-should-i-define-my-own-deepcopy-and-copy-functions-for-types-if-ever/123447) in Julia and why `deepcopy` should be avoided unless you know you have a good reason to use it (serialization-like)
* Rate limiters and REST API wrappers discussed on [slack](https://julialang.slack.com/archives/C67910KEH/p1732246972422409).
* [ClassicCiphers.jl](https://discourse.julialang.org/t/classicciphers-jl-a-julia-package-for-classical-cryptography/123564): A small package implementing old pedagogical ciphers.
* Is it not annoying when [PkgEval of your package fails because JET can not compile on nightly](https://discourse.julialang.org/t/what-to-do-when-packages-fail-pkgeval-because-of-jet/123525).
* A neat little demo of [Quarto and Typst](https://discourse.julialang.org/t/quarto-typst-tdf-saves-your-eyes-from-reading-documents/123587) in Julia.
* [Jjama3.jl](https://discourse.julialang.org/t/ann-jjama3-jl-unregistered-llama3-1-and-llama3-2-text-in-julia/122641) for running LLMs through Julia.
* [RollingWindowArrays.jl](https://discourse.julialang.org/t/ann-rollingwindowarrays-jl-flexible-and-efficient-rolling-window-operations/122682) for rolling operations over arrays with an extremely simple view-based API.
* Reminder: [DimensionalData.jl](https://github.com/rafaqz/DimensionalData.jl) is a great way to work with arrays with named axes.
* Reminder: [Z3.jl](https://github.com/ahumenberger/Z3.jl) lets you interface with the Z3 solver.
* A [full synthesizer built on Julia](https://broce.xyz/posts/julia-synth-percussion) with several mp3 tracks to highlight it.

Julia Autodiff ecosystem (enough topics for its own category this month):

* For floats `0.0 !== -0.0`. The various types of equality checks have come up often on various community forums, but this time it is about an exciting interaction between this surprising float inequality and autodiff. Discussed on [slack](https://julialang.slack.com/archives/C67910KEH/p1733134512456069) with a reference to this informative [manuscript](https://arxiv.org/pdf/2006.02080).
* Mixed-mode sparse Jacobians at insane speeds available in DifferentiationInterface.jl, discussed on [slack](https://julialang.slack.com/archives/C6G240ENA/p1731256638885619)
* How about finite-differences mode in Enzyme, discussed on [slack](https://julialang.slack.com/archives/C01J3R4FHB3/p1731439512764739)

Notes from other ecosystems:

* [Unusual Raku features](https://news.ycombinator.com/item?id=42120090) – does anyone feel inspired
* A [talk on Float semantics in LLVM](https://www.youtube.com/watch?v=sSNAGFXNXYU) (the low-level compiler at the bottom of Julia) and when they deviate from standards and how hardware can be pretty unhelpful.

Soapboxes:

* A new official Julia Bluesky account is now set up at [bsky.app/profile/julialang.org](https://bsky.app/profile/julialang.org) (discussed on [slack](https://julialang.slack.com/archives/C67910KEH/p1732552556407119))
* The [Julia GSoC team has grown](https://discourse.julialang.org/t/gsoc-admin-team-announcement/122754).

See also: [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [minutes of triage meetings](https://hackmd.io/@LilithHafner/HJaw__uMp)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)


