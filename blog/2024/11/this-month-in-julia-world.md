@def title = "This Month in Julia World"
@def authors = "Stefan Krastanov"
@def published = "07 November 2024"
@def rss_pubdate = Date(2024, 10, 07)
@def rss = """Community Newsletter for October 2024"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what I found interesting this month, with contributions from the community.

“Internals” Fora and Core Repos (Slack/Zulip/Discourse/Github):

* With the introduced of the new `Memory` low-level type, a lot of new compiler optimizations became possible. Particularly exciting is [turning `memorynew` into an intrinsic](https://github.com/JuliaLang/julia/pull/55913), bringing up the possibility to stack-allocate small arrays. This would be an amazing improvement, especially for newbies frustrated by the fact that they have to use temporary tuples instead of temporary arrays in tight inner loops.
* “[A Roadmap to Interfaces](https://hackmd.io/BbEw0_B4Q8uDSS34LOvpCw)” - thoughts by Keno and others on the past, current, and future of supporting interfaces naturally in the language.
* The compiler was recently [restructured to do much less “internal state”-tracking](https://github.com/JuliaLang/julia/pull/55575) (a more stackless setup), opening up the door for many possible improvements.
* The “package extension” capabilities might become quite a bit [more sophisticated](https://hackmd.io/@KristofferC/ryyTJl_R0) as discussed in this memo. This popped up in response to extension management [bottlenecks](https://github.com/JuliaLang/julia/issues/55516) as reported by the SciML team, discussed in the previous issue of this letter.
* The fact that we do not do the typical object-oriented language rewriting of `obj.method()` into `method(obj)` comes up often. Given that Julia is multiple-dispatch oriented, that rewriting makes quite a bit less sense here, but we lose some nice autocompletion features. I liked this [comment that describes the difficulty](https://discourse.julialang.org/t/oop-like-dot-notation-in-julia/120971/26).
* Do we want `-f` to automatically create a new function that is the [negation of a function `f`](https://github.com/JuliaLang/julia/pull/55920) the way `!f` is a new function that is the logical not of `f`.
* [Package extensions occasionally hamper parallelism](https://github.com/JuliaLang/julia/pull/55910) of compilation (they block the package dependants from starting to compile). That PR addresses the issue.
* Great work on [bringing more clarity and simplicity to stack traces](https://github.com/JuliaLang/julia/pull/55841).
* Consideration of permitting the [syntax `for else` and `while else`](https://github.com/JuliaLang/julia/pull/56153). But there is a long discussion of folks wondering whether it should have a [different meaning from the one in python](https://github.com/JuliaLang/julia/issues/1289).
* Adding an [`--experimental` CLI flag](https://github.com/JuliaLang/julia/pull/56045) to make it easier to opt into new experimental julia features.
* Now that Julia has version-specific Manifest.toml files, juliaup will be set up to take advantage of that and [launch the appropriate version](https://github.com/JuliaLang/juliaup/pull/1059).

Compiler Internals:

* “[Julia as a Statically Compiled Language](https://www.youtube.com/watch?v=hUxnLunOU4w)” by Jeff, discussing the upcoming ahead-of-time compiler mode for Julia. Related to that, check out the new `--trim` option for smaller binaries and some [fun experiments community members have been doing with small binaries](https://discourse.julialang.org/t/pushing-the-limits-of-small-binary-creation/120989). Are we one step closer to Julia being a backend to other languages?
* The (julia-side, before LLVM) Compiler can become an independent package soon enough. Work started here with [moving it into Base](https://github.com/JuliaLang/julia/pull/56128). The work continues [here](https://github.com/JuliaLang/julia/pull/56409).
* For a while there has been an effor to [“partition” variable bindings by World-age](https://github.com/JuliaLang/julia/pull/54654), enabling many neat future features, including struct-aware Revise. Recently, [the compiler learnt how to handle such binding partitions](https://github.com/JuliaLang/julia/pull/56299).
* The optimizer might be able to [call finalizers much earlier](https://github.com/JuliaLang/julia/pull/55990) soon enough.

Garbage Collector Internals:

* [`threadcall` might become gc safe soon](https://github.com/JuliaLang/julia/pull/55956)
* We are getting closer to having [MMTk as an optional alternative garbage collection toolkit](https://github.com/JuliaLang/julia/pull/56288) in julia.

Dustbin of History:

* ENV["JULIA_DEBUG"] = "loading"
* For those interested in archeology, this is not the [first attempt](http://thisweekinjulia.github.io/) to run a julia newsletter.
* https://github.com/JuliaLang/julia/issues/51183 and https://discourse.julialang.org/t/why-does-let-allow-comma-separated-assignments/113812

In search of contributors and new maintainers (specify novice/moderate/expert and internals/domain background necessary):

* @avik and @thecedarprince (the Co-Admins for Julia’s Participation in Google Summer of Code) are looking for new Google Summer of Code admin volunteers – low-effort and low-time commitment with a big impact on the Julia community!
* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science. Few thousand $ will be paid out already in October for bounties from August.
* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.
* ChainRules, a foundational package to the Julia autodiff effort is looking for a [new primary maintainer](https://discourse.julialang.org/t/chainrules-project-looking-for-a-new-primary-maintainer/115636).

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

* [Tensorial](https://discourse.julialang.org/t/ann-tensorial-jl-statically-sized-tensors-and-related-operations-for-julia/121588) is a great new package for tensor math. Also [discussed on slack](https://julialang.slack.com/archives/C6FGJ8REC/p1729174454227819), including in terms of how it compares to other Julia tools.
* A wonderful new docstring linter for julia: [CheckDoc](https://github.com/tecosaur/CheckDoc.jl)
* New experimental package to check that a struct is defined with inferrable concrete types: [CheckConcreteStructs](https://github.com/gdalle/CheckConcreteStructs.jl)
* Fun workarounds for broadcast nesting and general discussion of broadcast hacks on [slack](https://julialang.slack.com/archives/C67TK21LJ/p1730789206177099).
* Hackable belief propagation algorithm implementations in Julia: [BeliefPropagation.jl](https://github.com/stecrotti/BeliefPropagation.jl)
* [CodingTheory](https://github.com/esabo/CodingTheory) is a new package built on top of Oscar for work with classical and quantum error-correction codes.
* Another magic trick from Lilith: having your Julia session lazily autoload commonly used packages [BasicAutoloads.jl](https://github.com/LilithHafner/BasicAutoloads.jl)

Julia Autodiff ecosystem (enough topics for its own category this month):

* The DifferentiationInterface.jl (DI.jl) repository has been transferred to the [JuliaDiff](https://github.com/JuliaDiff/DifferentiationInterface.jl) organization to ensure continued maintenance.
* DI.jl: A breaking release v0.6 was tagged. Thanks to recent changes, it is now possible to pass non-differentiated arguments (first constants, and soon caches/buffers) to the function, in addition to the one active argument.
* DI.jl: Testing for StaticArrays has been drastically improved and allocations have been nearly eliminated with ForwardDiff & forward mode Enzyme for functions working on SArrays. There’s some concern how sustainable this is though, as the sensitive and fragile performance requirements for most StaticArrays use cases may be very easy to break in one or multiple backends.
* DI.jl: Mainly for fun, we tried to interface DI with JAX in [DifferentiationInterfaceJAX.jl](https://github.com/gdalle/DifferentiationInterfaceJAX.jl). There is still some overhead from Julia-Python tensor conversion with [DLPack.jl](https://github.com/pabloferz/DLPack.jl), any help is welcome.
* [Reactant.jl](https://github.com/EnzymeAD/Reactant.jl) can take a Julia function, compile it in MLIR, do a plethora of optimization and autodifferentiation tricks on it, and compile it to a very wide variety of accelerators.
* What does `compile` in `ReverseDiff` [mean](https://github.com/SciML/ADTypes.jl/issues/91)?

Notes from other ecosystems:

* NumPy now supports a [much more general data type](https://quansight.com/post/my-numpy-year-creating-a-dtype-for-the-next-generation-of-scientific-computing/) for its arrays.
* Useful [CUDA primitives](https://github.com/HazyResearch/ThunderKittens) for various linear-algebra related kernels.
* Can we get [inspiration from C#](https://em-tg.github.io/csborrow/) for how to put mutable objects on the stack.
* A julia slack discussion on how [C# implements elegant abstractions for SIMD-accelerated arrays](https://julialang.slack.com/archives/C688QKS7Q/p1728398666009809). Brings up related [Julia work on implementing similar capabilities](https://github.com/JuliaLang/julia/pull/55118).

Soapboxes (blogs/talks):

* [Looking to build more of a Julia presence on BlueSky](https://bsky.app/profile/thecedarprince.bsky.social/post/3l7lmnjewv52e)
* The [Julia Dispatch podcast](https://www.youtube.com/@JuliaDispatch) has started as [discussed on slack](https://julialang.slack.com/archives/C67910KEH/p1729107731948489) as well
* @TheCedarPrince wrote about [his experience at the 2024 Google Summer of Code Mentor Summit](https://discourse.julialang.org/t/perspectives-from-2024-gsoc-mentor-summit/121488) and led a [talk](https://docs.google.com/document/d/1fmKEmA8iKCO4QuSWto8rHiCKCuNm7nLUIxW2jPWINws/edit?tab=t.0) across organizations about research software engineering across orgs
* The Julia Optimization Days 2024 in Toulouse (France) featured a [tutorial on code optimization](https://gdalle.github.io/JuliaOptimizationDays2024-FastJulia/) and an [introduction to autodiff](https://gdalle.github.io/JuliaOptimizationDays2024-AutoDiff/). If there is community interest, those tutorials could be recorded by the author and put on the YouTube channel of the Julia language.
* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English). If you’re in/near France, consider presenting your optimization-related Julia work at the upcoming conference on operations research [ROADEF 2025](https://roadef2025.org/) (next February in Paris).
* Consider subscribing to the [community calendar](https://julialang.org/community/#events) to be informed of upcoming virtual meetings and talks.
* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack. [Minutes are kept](https://hackmd.io/@LilithHafner/HJaw__uMp).

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
