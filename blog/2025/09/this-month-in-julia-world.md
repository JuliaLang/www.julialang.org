@def title = "This Month in Julia World (August 2025)"
@def authors = "Stefan Krastanov"
@def published = "1 September 2025"
@def rss_pubdate = Date(2025, 9, 1)
@def rss = """Community Newsletter for August 2025"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what a clique of us found interesting this month, with contributions from the community.

For recent news on Julia and interesting conversations with community members, check out the [JuliaDispatch](https://juliadispatch.fm/) podcast (on many platforms, including [youtube](https://www.youtube.com/@JuliaDispatch/) and [spotify](https://open.spotify.com/show/6Y1zWtFhjqPLsFQWRvZmws)). Highlights from the newsletter get discussed (with more context) during some episodes.

[JuliaCon 2026 will happen from August 10th to August 15th 2026 in Germany](https://discourse.julialang.org/t/juliacon-2026-save-the-date/132172).

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* A fun little example of how to properly “cast” from one type to another type in Julia. Calling `Int(x)` is not guaranteed to convert the instance x of some arbitrary type into an `Int`. Of course, only a sociopath would create a method `Int(::MyEvilType)` that does not return an `Int`, but nonetheless, the trick to protect yourself from such evil is to add a type assert like `Int(x)::Int` – now instead of being at risk of bad behavior and stack overflows due to poorly written user code, you get an early type assertion error. See this being recently suggested as a guardrail in some low level Julia code in [#59506](https://github.com/JuliaLang/julia/pull/59506/files).
* JuliaC, the ahead-of-time julia compiler is now living in its own [repo](https://github.com/JuliaLang/JuliaC.jl) and will be available as a Julia app.
* `--trace-compile` is a very useful flag to learn why your package loads slowly and what `precompile` statements to add. There is an interesting interplay between type inference and the compiler, where the compiler might need to run a function (with actual runtime dispatch) in order to learn something about it – an event that does not happen during actual use of the compiled code. This can cause unnecessary precompile statements to be logged. PR [#59366](https://github.com/JuliaLang/julia/pull/59366) marks such precompile statements, but consider perusing the comments in that PR to learn more about these intricacies.
* Since early this year, Sam has been contributing significant improvements to Julia ergonomics. Looking from the sidelines, it seems like they hit the ground running with their first ever contribution (my favorite): a drastic simplification of the [REPL auto-completion implementation from a few months ago](https://github.com/JuliaLang/julia/pull/57767). Now they have a PR on [significantly reducing memory pressure during heavy compilation loads](https://github.com/JuliaLang/julia/pull/59348) (and [another reduction here](https://github.com/JuliaLang/julia/pull/59329)), and on [compressing the sysimage (cache of compiled code)](https://github.com/JuliaLang/julia/pull/59227) which drastically reduces its size (leading to a ~70% size reduction for untrimmed apps produced by PackageCompiler).
* They are also contributing a much faster way to [enable Memory/Thread/AddressSanitizer compile passes in Julia](https://github.com/JuliaLang/julia/pull/59035). These tools can be used to detect and debug common safety, correctness, and performance issues.
* Who knew that segfaults can be “fake” triggered by a signal, as opposed to by… an actual segmentation fault due to accessing memory you do not own? [PR #59275 will warn about such segfaults](https://github.com/JuliaLang/julia/pull/59275), hopefully simplifying the debugging of messy nesting of runtimes from different languages.
* Interesting [discussion on the word “functor”](https://github.com/JuliaLang/julia/pull/59414) and its minor historic use in the julia docs.
* A few months ago Julia gained the capability to redefine structs (not just methods). Due to how this interacts with worldage (the mechanism for tracking what is the most recent definition of methods and structs), subtle changes to the `@testset` and `@allocated` macros was needed. Short version is that `@allocated` has always been a bit of a heuristic test and there are better alternatives to it if you are going to test for allocations in your package’s tests. See comments in [#58780](https://github.com/JuliaLang/julia/issues/58780) for details. Also [#58057](https://github.com/JuliaLang/julia/pull/58057) and [#59278](https://github.com/JuliaLang/julia/pull/59278).
* A common performance pitfall in julia is iterating over diversely typed array where the innermost part of the loop can not be type stable, leading to runtime dispatch of which function to call (basically a dictionary lookup for the appropriate function to call). Frequently discussed solutions are Algebraic Data Types (ADT), as implemented in Moshi.jl, LightSumTypes.jl, or SumTypes.jl. The Julia compiler also does the extra work to “union split” if the diversely typed array does not contain instances of “too many” different types. Here is a neat manual example of how to solve this type of problem without relying on general frameworks like ADTs: Lilith sped up the [hashing of julia abstract syntax trees by implementing a manual union split](https://github.com/JuliaLang/julia/pull/59378) (tree structures are another place that frequently has this type of issues).
* An in-depth high-quality discussion by Jakob on [when and why you should use ScopedValues (a better nestable alternative of global variables) vs task-local storage (dedicated semi-temporary storage within a task, simplifying multithreading algorithms)](https://discourse.julialang.org/t/task-local-storage-and-scoped-values-what-they-are-used-for/132045).
* [ScopedThunk](https://github.com/JuliaLang/julia/pull/59402) now permits you to take a snapshot of the state of scoped values (a more structured way to deal with global variables defining a context) and use that snapshot at a later time.
* [LazyScopedValue](https://github.com/JuliaLang/julia/pull/59372) can be used to create a scoped value which lazily computes the actual value the first time it is requested, thus supporting reading the initial state of a scoped value from the environment.
* [TestSets now use ScopedValues](https://github.com/JuliaLang/julia/pull/53462) for storing results, showcasing the simplicity ScopedValues provide when dealing with multiple tasks reading and writing in global storage.
* Julia uses the general purpose platform-independent high-performance [rapidhash](https://github.com/Nicoshev/rapidhash) algorithm in much of its hashing utilities. There are recent improvements to internals related to it in PRs [#59177](https://github.com/JuliaLang/julia/pull/59177) and [#59185](https://github.com/JuliaLang/julia/pull/59185).
* Much of the precompile logic in the julia compiler was moved from C code to a [pure-julia implementation](https://github.com/JuliaLang/julia/pull/59361).
* Now you can send a signal to the Julia runtime to [trigger `--trace-compile` at an arbitrary time](https://github.com/JuliaLang/julia/pull/59424) without having requested it at the start of the process. Just send `SIGUSR1/SIGINFO1` (`ctrl+T` on many systems).
* `[Iterators.findeach](https://github.com/JuliaLang/julia/pull/54124)` is a lazy version of `findall` that avoids allocating an array.
* Another one of Lilith’s surprising drive-by performance optimization – an order of magnitude faster `prod(::AbstractArray{BigInt})` by more intelligently pre-allocating buffers for `BigInt` instances and traversing the array in a more efficient order. In [#59456](https://github.com/JuliaLang/julia/pull/59456).
* Neven has been working for quite a while on simplifying unnecessarily complicated method dispatch in `Base` (which also lowers the potential for method invalidation). See [“eliminate some nongeneric methods of `length` and `size`”](https://github.com/JuliaLang/julia/pull/59442), [“generic `size`: avoid method static parameters and abstract type assert”](https://github.com/JuliaLang/julia/pull/59465), [“avoid method proliferation for Tuple functions”](https://github.com/JuliaLang/julia/pull/59421), and many more.
* Work on making [`@threads` work on array comprehensions](https://github.com/JuliaLang/julia/pull/59019).
* A fun question on [weird type queries with UnionAll](https://discourse.julialang.org/t/determining-if-unionall-corresponds-to-a-single-type-union/132088).

In search of contributors and new maintainers (specify novice/moderate/expert and internals/domain background necessary):

* The [Graphs.jl](http://graphs.jl) repo features a few bounties on [integrating external graph theory libraries](https://github.com/JuliaGraphs/Graphs.jl/issues?q=is%3Aissue%20state%3Aopen%20label%3Abounty) better with the rest of the Graphs ecosystem.
* [JuliaPackageComparisons](https://discourse.julialang.org/t/juliapackagecomparisons-is-looking-for-a-new-maintainer/130667) is a wiki-like resource comparing different julia tools. It is in search of a new maintainer.
* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science.
* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* [Julia for Research Software Engineering](https://discourse.julialang.org/t/julia-for-research-software-engineering/131528) is a recent talk by Mosè and Valentin in a larger series on scientific software.
* [BufIO.jl is a new low-level abstraction for input/output interfaces in Julia](https://discourse.julialang.org/t/ann-bufio-new-i-o-interfaces-for-julia/132347), created by Jakob after he spent a few years documenting many of the frustrations of the current Base IO. This is a very valuable prototype that can lead to much more robust buffer and stream interface for Julia.
* [BonitoBook.jl](https://discourse.julialang.org/t/ann-bonitobook-jl/131442) is an interesting new take on reactive notebooks in the Julia ecosystem, with deep integration with Makie.
* A short tutorial on how sum types (think Moshi/SumTypes/LightSumTypes) can be used to define dynamic C APIs that can be compiled with `--trim`, for elegant C interfaces to your Julia libraries.
* [Introduction to Julia for R users](https://nrennie.rbind.io/blog/introduction-julia-r-users/)
* [IJulia.jl 1.30 is released](https://discourse.julialang.org/t/ann-ijulia-1-30-0/131811), with significant usability improvements when running julia notebooks in Jupyter.
* [LuaNova.jl](https://discourse.julialang.org/t/ann-luanova-jl-easy-lua-julia-integration/132324) released, providing easy Lua-Julia integration.
* [Eyeball.jl](https://github.com/tshort/Eyeball.jl) is an interactive introspection tool for objects and types in julia.
* [OneTimePasswords.jl](https://discourse.julialang.org/t/ann-onetimepasswords-jl/131679) provides a number of standard algorithms for working with single-use confirmation codes like TOTPs.
* PrettyTables releases version 3 with significant new features (see [discourse](https://discourse.julialang.org/t/current-state-and-the-future-of-prettytables-jl/118455/143), [github](https://github.com/ronisbr/PrettyTables.jl/pull/259))

Numerical Math ecosystem:

* [Implicit ODE Solvers Are Not Universally More Robust than Explicit ODE Solvers](https://www.stochasticlifestyle.com/implicit-ode-solvers-are-not-universally-more-robust-than-explicit-ode-solvers-or-why-no-ode-solver-is-best/)

Mathematical Optimization ecosystem:

* A series of [textbooks on algorithms for optimization, decision making, and more](https://algorithmsbook.com/), with heavy use of Julia, by Stanford’s Prof. Mykel J. Kochenderfer.
* Disciplined Convex Programming is a family of techniques for propagating convexity information about the functions you are optimizing over. A few past and future [developments related to DCP in julia are discussed here](https://discourse.julialang.org/t/state-of-dcp-disciplined-convex-programming/131743).

Autodiff ecosystem:

* A question about [autodiff of FFTs in the julia ecosystem](https://discourse.julialang.org/t/which-direction-differentiatoninterface-enzyme-zygote-with-cuda-and-ffts/132225) led to an informative discussion of a few of the autodiff frameworks we have.

Notes from other ecosystems:

* A discussion about monomorphisation (the process of creating brand new specialized compiled function behind the scenes for each concrete type your runtime might face, i.e. one of the main features that makes julia fast), its relationship to boxed types, and its great compilation time cost, if it was to be added to [OCaml](https://discourse.julialang.org/t/why-can-julia-be-better-about-boxing-types-than-ocaml/131628).
* A great primer on [how GPUs work and how to think about them](https://jax-ml.github.io/scaling-book/gpus/) from the JAX community.

See also: [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [Turing.jl newsletter](https://github.com/TuringLang/Turing.jl/issues/2498)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
