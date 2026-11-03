@def title = "This Month in Julia World (November 2023)"
@def authors = "Stefan Krastanov"
@def published = "2 December 2023"
@def rss_pubdate = Date(2023, 12, 2)
@def rss = """Community Newsletter for November 2023"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* George Datseris (from JuliaDynamics) wrote a [high quality “manifesto” on the advantages of Julia](https://github.com/Datseris/whyjulia-manifesto). It is very detailed and technical and well defended, but I particularly liked its post scriptum on “Why do you try so hard to convince people?”. Also discussed on [Discourse](https://discourse.julialang.org/t/why-julia-a-manifesto/106404).

* Another piece of Julia compiler dark magic: [AllocChecks.jl is a library capable of making static guarantees about whether your code will require allocations](https://discourse.julialang.org/t/ann-alloccheck-jl-static-code-analysis-to-prove-allocation-free-behavior/106414) (one of the common reasons for slowdown or garbage-collection indeterminism).

* Julia is known as a great platform to experiment with weird compiler techniques, but it is also known to be rather underdocumented (and fairly rapidly evolving) in that respect. Along these lines, recently we had a conversation on [Discourse on CodeInfo and Core.Compiler.IRCode representations and how to manipulate them](https://discourse.julialang.org/t/what-is-the-difference-between-codeinfo-and-core-compiler-ircode/106089).

* A [brief discussion on the use of Traits](https://discourse.julialang.org/t/why-traits/105591) (as a programming concept) in Julia. In summary, simple functions probably do not benefit from using Traits over the typical type structure in Julia thanks to constant-propagation optimization passes, but these optimizations might fail in large programs. Using Traits encodes the requirement in the type system, making for a much stronger guarantee that dynamical dispatch would not be necessary.

* People coming from Python have frequently asked why we do not have reliable Ctrl+C exception handler like Python’s KeyboardException. A handwavy reason is that we do not have a GIL, but [Keno gives a very detailed expossion of this and possible future steps](https://github.com/JuliaLang/julia/issues/52291).

* With more parallelism in precompilation now we have the occasional annoying hangs when a precompilation step in a package spawns its own parallel Task. [Aqua now provides checks for such cases](https://github.com/JuliaTesting/Aqua.jl/pull/174), and the devdocs were updated with [more detailed explanation for package authors](https://github.com/JuliaLang/julia/pull/51895).

* A discussion on whether [we should have a NotImplementedError](https://github.com/JuliaLang/julia/issues/50196) to signify declared but not implemented abstract APIs. [A potential implementation PR](https://github.com/JuliaLang/julia/pull/51873).

## Core repos

* The new StyledStrings stdlib is starting to be used in a few places: [REPL](https://github.com/JuliaLang/julia/pull/51887), [Logging](https://github.com/JuliaLang/julia/pull/51829) and more [Logging](https://github.com/JuliaLang/julia/pull/51802), [stack traces](https://github.com/JuliaLang/julia/pull/51816),

* Even a full [syntax highlighting stdlib](https://github.com/JuliaLang/julia/pull/51810) thanks to StyledStrings.

* Work on [a better internal datastructure for storing compiled methods](https://github.com/JuliaLang/julia/pull/52073) (it could lead to a pleasant speedup in compilation).

* Julia has had `unsafe_wrap` to create arrays out of pointers, but now with the new Memory type discussed in the last issue, we are getting a [safe `wrap`](https://github.com/JuliaLang/julia/pull/52049).

## Dustbin of history

* Sometime ago [custom Method Tables were implemented as a way to have a completely separate multiple-dispatch tree](https://github.com/JuliaLang/julia/pull/39697), useful e.g. for GPU compilers. A userfriendly interface to this is [CassetteOverlay.jl](https://github.com/JuliaDebug/CassetteOverlay.jl/).

* Some types of interactive tab-completion have been failing in Julia’s REPL [since forever](https://github.com/JuliaLang/julia/issues/29275).

* Some time ago Giordano wrote a [great tutorial on how to write your first macro](https://giordano.github.io/blog/2022-06-18-first-macro/).

* If you are wondering what it really means to be “homoiconic like Lisp”, [Stefan gave agreat answer a few years ago](https://stackoverflow.com/questions/31733766/in-what-sense-are-languages-like-elixir-and-julia-homoiconic/31734725#31734725).

* Maybe a bit surprisingly, it has been forever that [Julia does not support mutually-referencing types](https://github.com/JuliaLang/julia/issues/269). But where it matters, there are [workarounds, e.g. in SumTypes.jl](https://github.com/MasonProtter/SumTypes.jl/issues/15).

## Ecosystem

* Julia’s “official” [GitHub action for package testing now provides better caching](https://github.com/julia-actions/cache/pull/71), significantly lowering test runs.

* AppBuilder.jl was recently released, making the [creation of pre-packaged apps for Linux/Mac/Windows](https://discourse.julialang.org/t/ann-appbundler-jl-bundle-your-julia-gui-application/106971) easier.

* We have discussed OptimalSortingNetworks before. Now we are getting a related [TupleSorting.jl](https://discourse.julialang.org/t/ann-tuplesorting-sort-tuples-efficiently-and-with-good-type-inference/105756) for typestable fast sort of tuples (even large ones).

* DataFrames.jl is solidifying its [great performance in multi-language multi-library dataframes benchmark](https://discourse.julialang.org/t/the-state-of-dataframes-jl-h2o-benchmark/43081).

* [CUDA.jl 5.1 released with yet more great improvements](https://info.juliahub.com/cuda-jl-5-1-unified-memory).

* [Jello.jl for generating manufacturable geometry](https://github.com/paulxshen/Jello.jl) (whether by hobby 3D printing or by million-dollar lithography machines and ion beams).

* [Impostor.jl a synthetic data generator](https://discourse.julialang.org/t/ann-impostor-jl-a-highly-versatile-synthetic-data-generator/106166) for mocking up DataFrame algorithms.

* A [slack discussion on how to visualize (and debug) Makie layouts](https://julialang.slack.com/archives/C8RQUU2KH/p1700748941798839).

* BioMakie.jl a [visualization tool for biology-related data had a significant new release](https://discourse.julialang.org/t/ann-biomakie-jl-v0-3-0-stable-with-examples/106428).

* RxInfer.jl has existed for a while, but [their new webpage is a thing of beauty](https://rxinfer.ml/). RxInfer aims to automate inference in your probabilistic models.

* [The minutes from the JuliaGraphs community call this month](https://github.com/JuliaGraphs/JuliaGraphs-meta/issues/12).

* A new, simpler but very fast [dense-sparse matrix multiplication implementation release in ThreadedDenseSparseMul.jl](https://discourse.julialang.org/t/ann-threadeddensesparsemul-jl/106734)

* ReactiveToolkit.jl is new tool to conveniently [set up reactive asynchronous “soft-realtime” tasks in julia](https://discourse.julialang.org/t/ann-reactivetoolkit-jl-build-reactive-soft-real-time-systems-in-julia-for-hardware-in-the-loop-controls/106781).

## Blogs and talks

* Consider subscribing to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English).

* Consider subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

* Consider attending the triage meetings of the julia core contributors (organized on slack) – being a fly on the wall can be a great way to learn the nitty-gritty details of current priorities and development work. These are organized on the triage channel in slack.

I have started linking to fewer slack threads, as slack references are starting to be more and more unreliable on my end (threads getting lost, etc).

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
