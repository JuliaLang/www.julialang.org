@def title = "This Month in Julia World (August 2023)"
@def authors = "Stefan Krastanov"
@def published = "27 August 2023"
@def rss_pubdate = Date(2023, 8, 27)
@def rss = """Community Newsletter for August 2023"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

\toc

## Internals

* It is always surprising how straightforward it is to modify the Julia compiler from within Julia. This [discourse thread](https://discourse.julialang.org/t/towards-implementing-cse-in-the-julia-compiler/102922) showcases how to implement Common Subexpression Elimination (CSE) at the julia intermediary representation level (IR) before it is sent to LLVM for compilation. LLVM of course has its own optimizations, including CSE, but there is value to doing some optimizations within Julia, where one has access to much more semantic information.

* A [slack thread](https://julialang.slack.com/archives/C67910KEH/p1692718859167549) on what “[interfaces](https://en.wikipedia.org/wiki/Interface_(object-oriented_programming))” can look like in Julia, with interesting discussion of how multiple dispatch complicates things and examples of languages with multiple dispatch and multiple inheritance at the same time (Julia does not have multiple inheritanc yet).

## Core repos

* Dynamically Scoped Variables! This really came out of left field. We have been taught in school [how terrible dynamically scoped variables are](https://stackoverflow.com/questions/321000/what-are-the-advantages-of-dynamic-scoping), just barely any better than global scope for everything. However, in recent year they have seen a resurgence in some very specific settings (e.g. multi threading, logging, configuration passing, request servers). If you are interested, you can learn more about it from the [upcoming implementation](https://github.com/JuliaLang/julia/pull/50958) in base Julia, as well as from the [previous attempt at such a capability](https://github.com/JuliaLang/julia/pull/35833).

* [Precompiled caches will soon be relocatable](https://github.com/JuliaLang/julia/pull/49866), a first step in making distributing precompiled projects (no waiting for compilation locally), and a valuable quality-of-life improvement for HPC cluster environments.

* [Many improvements](https://github.com/JuliaLang/julia/pulls?q=assume_effects) to the [“effect analysis”](https://aviatesk.github.io/posts/effects-analysis/index.html) that julia uses to prove properties of various methods necessary to permit more aggressive optimizations (e.g. proving a function is pure which might permit constant propagation or common subexpression elimination). Much of that information is also then [sent to LLVM](https://github.com/JuliaLang/julia/pull/50188) so that it can be used when optimizing the generated machine code. There was some [recent discourse discussion around this](https://discourse.julialang.org/t/does-julia-do-common-subexpression-elimination/102901) as well.

* Along those lines, there is [work underway to feed back information from the optimizer into the known effects](https://github.com/JuliaLang/julia/pull/50805), enabling yet more optimizations.

* A [terminfo parser implemented in pure julia](https://github.com/JuliaLang/julia/pull/50797) was merged, removing some external dependencies, and, more importantly, enabling future improvements to “fancy” REPL functionality.

* One such “fancy” functionality is the upcoming [“Styled strings” work](https://github.com/JuliaLang/julia/pull/49586), which will enable much richer terminal output and a much easier API for styling such output.

* Cthulhu is a piece of dark magic that lets you investigate how angry the Julia compiler is with your code. The Julia vscode plugin is [now capable of automatically visualizing this information for the user](https://github.com/JuliaDebug/Cthulhu.jl/pull/469), warning them about type-unstable functions and more.

* The [`--project` flag can now be set relative to the folder of the file being executed](https://github.com/JuliaLang/julia/pull/50864) (instead as an absolute path or a path relative to “present working directory”) . Valuable when you want to execute a script with a particular Project.toml without having to specify both.

* Improving documentation of how [low-level math functions deal with domain errors, `missing`, and other special cases](https://github.com/JuliaLang/julia/pull/50855). In spirit, a part of the slow process of documenting behaviors that are unsurprising for numerical programming folks but not obvious for newcomers. E.g. consider the discussion about [julia’s attitude to aliasing](https://discourse.julialang.org/t/whats-the-aliasing-story-in-julia/102564/) or the discussion on integer overflow rules from last month.

* [Stacktraces](https://github.com/JuliaLang/julia/pull/49795) and [method errors](https://github.com/JuliaLang/julia/pull/50809) with deeply nested parameterized types are now much easier to read in the REPL

* We might end up with a `public` keyword (new syntax) to help in [better clarifying what is public and private API](https://github.com/JuliaLang/julia/pull/50105). This has been becoming more and more pressing given how Julia’s semver conventions are somewhat informal. There is some interesting discussion in that thread about possible drawbacks to the given approach and tradeoffs to consider.

* [Lazy loading of the standard library JLLs (binary shared libraries)](https://github.com/JuliaLang/julia/pull/50687) leading to nice improvements in startup latency.

* Enhancements to [defining primitive types with more sophisticated LLVM features](https://github.com/JuliaLang/julia/pull/50607).

* The julia runtime has a vast array of profiling endpoints, used by more and more external profiling/timing tools. There is a [proposal for standardising a timing API](https://github.com/JuliaLang/julia/pull/50604) for the low-level runtime.

## Dustbin of history

* Each function in julia has its own type, which is wonderful when we want type-stable higher-order functions, but it can lead to overspecialization (compiling way to many different methods for the same function). If you dabble much in functional programming, you would probably be interested in the solution provided by [FunctionWrappers.jl](https://github.com/yuyichao/FunctionWrappers.jl) and the [very ancient issue about having this capability be in base julia](https://github.com/JuliaLang/julia/issues/13984).

## Ecosystem

* [Satisfiability.jl](https://discourse.julialang.org/t/ann-satisfiability-jl-a-simple-interface-to-theorem-provers-using-the-smt-lib-standard/102984) is an interface package for a multitude of theorem prover tools, of great value to anyone that needs state of the art SAT solvers

* A very impressive and powerful (especially given how short the implementation is) eikonal and shortest path solver in [Eikonal.jl](https://discourse.julialang.org/t/ann-announcing-eikonal-jl/102960).

* [Mousetrap.jl](https://discourse.julialang.org/t/a-new-julia-gui-engine-has-appeared-mousetrap-jl-is-now-available/103004) is a quite wonderful new GUI-building tool providing a neater API around the intimidating GTK.

* With [PlutoVSCodeDebugger](https://discourse.julialang.org/t/ann-annonuncing-plutovscodedebugger-jl/103030) you can now run your pluto notebooks through the debugger available in vscode.

* A wonderful R-like tidyverse-like tool for working with dataframes recently reached its v1.0. Check out [Tidier.jl](https://github.com/TidierOrg/Tidier.jl)

* In the same family, check out [TidierVest for web scraping](https://github.com/TidierOrg/TidierVest.jl).

* The [JuliaPlots](https://github.com/JuliaPlots) project is now able to [collect funds](https://discourse.julialang.org/t/paying-a-freelancer-to-maintain-plots-jl/61162/33) through [OpenCollective](https://opencollective.com/plotsjl).

## Blogs and talks

* Consider subscribint to the [French community newsletter](https://pnavaro.github.io/NouvellesJulia/) (much of the shared materials are in English)

* Consider adding subscribing to the [community calendar](/community/#events) to be informed of upcoming virtual meetings and talks.

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
