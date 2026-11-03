@def title = "This Month in Julia World (July 2024)"
@def authors = "Stefan Krastanov"
@def published = "5 August 2024"
@def rss_pubdate = Date(2024, 8, 5)
@def rss = """Community Newsletter for July 2024"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

JuliaCon2024 happened this month and some of the entries below refer to talks from the conference. Cleaned up recordings will be up on Julia’s Youtube channel in the next months, but for now you can look at the [unprocessed live recordings](https://www.youtube.com/@TheJuliaLanguage/streams) and find the timestamps for a given talk yourself. The schedule of all talks is on [pretalx](https://pretalx.com/juliacon2024/schedule).

\toc

## Core repos

* Julia’s capabilities to produce small compiled binaries have progressed significantly. See this [PR](https://github.com/JuliaLang/julia/pull/55047), and [this talk](https://pretalx.com/juliacon2024/talk/FUTLND/) by Jeff and Gabriel at JuliaCon2024

* Julia has a lot of impressive SIMD-focused libraries. At the JuliaCon hackathon work started on support for [SIMD intrinsics in base Julia,](https://github.com/JuliaLang/julia/pull/55118) which can potentially help future work on the aforementioned libraries and more.

* Updating Julia to use LLVM 18 is [nearly merged](https://github.com/JuliaLang/julia/pull/54848).

* Many conversations on custom optimizations and compiler passes happened at JuliaCon. This [work on aggressive recursive constant-propagation](https://github.com/JuliaLang/julia/issues/55100) is one example, mentioned on [slack](https://julialang.slack.com/archives/C67910KEH/p1720647189026709).

* People that compile Julia themselves, now have the option to run pretty aggressive optimizers (profile-guided, link-time, and the new [LLVM BOLT optimizer](https://github.com/JuliaLang/julia/pull/54107)). See the [NEWS](https://github.com/JuliaLang/julia/pull/55282/files) entries on the topic.

* Exciting work on the [`map` and `reduce` families of functions in Julia](https://github.com/JuliaLang/julia/pull/55318), addressing a ton of technical debt.

* JuliaCon talk: [The State of Julia](https://pretalx.com/juliacon2024/talk/3EZMQM/)

* JuliaCon talk: [Adventures in Julia IR: Plundering Core.Compiler](https://pretalx.com/juliacon2024/talk/D3H79J/)

* JuliaCon talk: [Compiler plugins and non-native execution caching](https://pretalx.com/juliacon2024/talk/D88XFU/)

* JuliaCon talk: [`Memory` in Julia](https://pretalx.com/juliacon2024/talk/CYJ7V7/)

* JuliaCon talk: [App support in Pkg](https://pretalx.com/juliacon2024/talk/UKX9BF/)

* JuliaCon talk: [ScopedValues – What are they good for](https://pretalx.com/juliacon2024/talk/FR8MVT/)

* JuliaCon talk: [The `public` keyword and how public APIs work in Julia](https://pretalx.com/juliacon2024/talk/KGQ8KL/)

* JuliaCon talk: [BinaryBuilder 2: Return of the Compilers](https://pretalx.com/juliacon2024/talk/EJVFMF/)

* JuliaCon talk: [Dude, where's my code?](https://pretalx.com/juliacon2024/talk/HRRRET/) (about code provenance and lowering)

* JuliaCon talk: [Julia Compiler Secrets - Static Analysis](https://pretalx.com/juliacon2024/talk/UTGSDT/)

* JuliaCon talk: [Interfaces.jl: base and package interface tests for your objects](https://pretalx.com/juliacon2024/talk/GXWLAW/)

* JuliaCon talk: [Writing allocation-free Julia code with AllocCheck.jl](https://pretalx.com/juliacon2024/talk/EJXYNM/)

## Dustbin of history

* An [interesting discussion](https://github.com/JuliaLang/julia/issues/30845) on the differences between scalar indexing, non-scalar indexing, and broadcasting, and how there are still a few places where the Julia broadcasting and indexing APIs can evolve.

## In search of contributors

* The Center for Quantum Networks is running [many bounties and minigrants](https://github.com/QuantumSavory/.github/blob/main/BUG_BOUNTIES.md) on a variety of support packages for quantum information science.

* [SciML is running a large set of funded small projects](https://sciml.ai/small_grants/) – a great opportunity to contribute to the community and be paid for it.

* ChainRules, a foundational package to the Julia autodiff effort is looking for a [new primary maintainer](https://discourse.julialang.org/t/chainrules-project-looking-for-a-new-primary-maintainer/115636).

## Ecosystem

* The journey for Sum Types or ADTs and maybe pattern matching in Julia continues with [DynamicSumTypes.jl](https://discourse.julialang.org/t/ann-dynamicsumtypes-jl-v3/116741) and [Moshi.jl](https://discourse.julialang.org/t/ann-moshi-v0-3-the-next-gen-mlstyle-gadt-extensible-pattern-matching-and-more/117613). My read on these development is that DynamicSumTypes provides the simplest way to hook many pre-existing types into a simple sum type in order to avoid runtime dispatch. Such runtime dispatch is frequently the cause of severe slowdown when iterating over arrays containing elements of many diverse types (i.e. a large `Union{...}` type) as the compiler and type inference give up. Because of this I think of DynamicSumTypes as “union splitting on steroids”. Moshi is more of a first-principles deep dive into all of the compiler theory and type theory necessary to bring the full richness of a ADTs and pattern matching to julia, with a lot of introspection among the authors about what worked and did not work in previous attempts.

* A neat Makie recipe for labeled arrays (arrays in which different dimensions have descriptive metadata) was [shared on slack](https://julialang.slack.com/archives/C8RQUU2KH/p1720473337380729). Implemented [here](https://github.com/JuliaAPlavin/AxisKeysExtra.jl/blob/master/ext/MakieExt.jl) if you would like to avoid the slackhole.

* A [slack discussion](https://julialang.slack.com/archives/C6FGJ8REC/p1720688119964779) on how Julia’s BinaryBuilder and the Pkg.jl upcoming app support can be a full-fledged distro package manager, together with a mention of the pre-existing RunBinary.jl and ygg which can be used today for the same purpose.

* [Python.jl](https://pretalx.com/juliacon2024/talk/ZH3JN3/) is an unholy way to run a REPL that is both Python and Julia at the same time. For the naysayers, Python also has a [multiple dispatch library](https://pypi.org/project/multipledispatch/)

* zotero [https://julialang.slack.com/archives/C67910KEH/p1722333675465019](https://julialang.slack.com/archives/C67910KEH/p1722333675465019)

* [`print` vs `show` vs `show` with MIME](https://discourse.julialang.org/t/print-vs-two-argument-show-repr-vs-three-argument-show-repr-with-mime-text-plain/117790) – how to properly pretty-print in Julia.

* JuliaCon talk: [Infiltrator.jl - No-Overhead Breakpoints in Julia](https://pretalx.com/juliacon2024/talk/STRAXA/)

* JuliaCon talk: [Train a Llama(2) in Julia!](https://pretalx.com/juliacon2024/talk/ZSHGHJ/)

* JuliaCon talk: [What's next for Transducers.jl?](https://pretalx.com/juliacon2024/talk/FJMTXH/)

* JuliaCon talk: [Updates and Advances in CUDA.jl and oneAPI.jl](https://pretalx.com/juliacon2024/talk/GGQFJR/)

* JuliaCon talk: [Applications of Distributed Task Parallelism](https://pretalx.com/juliacon2024/talk/XJFGYJ/)

## Other ecosystems

* A cute little RPG story game / set of tutorials to learn [how dangerous multithreading can be](https://deadlockempire.github.io/).

## Blogs and talks

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack. [Minutes are kept](https://hackmd.io/@LilithHafner/HJaw__uMp).

## Sundry

* [JuliaDynamics is starting a monthly meetup](https://discourse.julialang.org/t/monthly-meetups-kickstart-juliadynamics-and-beyond/117359).

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
