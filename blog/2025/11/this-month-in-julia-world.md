@def title = "This Month in Julia World (October 2025)"
@def authors = "Stefan Krastanov"
@def published = "8 November 2025"
@def rss_pubdate = Date(2025, 11, 8)
@def rss = """Community Newsletter for October 2025"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

For recent news on Julia and interesting conversations with community members, check out the [JuliaDispatch](https://juliadispatch.fm/) podcast (on many platforms, including [youtube](https://www.youtube.com/@JuliaDispatch/) and [spotify](https://open.spotify.com/show/6Y1zWtFhjqPLsFQWRvZmws)). Highlights from the newsletter get discussed (with more context) during some episodes.

JuliaCon Global 2025 and JuliaCon Paris 2025 videos are continuously being released on the [Julia youtube channel](https://www.youtube.com/@TheJuliaLanguage/playlists).

\toc

## Core repos

* The GitHub bot dependabot which automates updates to compat bounds in many ecosystems now has beta support for Julia, providing a much more standard alternative to the current CompatHelper custom julia bot. Benefits over CompatHelper include: showing release notes/changelogs for the new version in the PR, updating checked-in manifests and warning when it cannot be updated, CI running automatically (without close-open), not having to worry about workflows being silently turned off after a few months of repo inactivity. It’s aligned with a push to integrate better with github’s CVE management systems. See [examples of PRs](https://github.com/IanButterworth/CSV.jl/pull/6) and [example setups](https://github.com/IanButterworth/CSV.jl/blob/master/.github/dependabot.yml). It is in a testing period and feedback would be much appreciated.

* [JET 0.11 is now released](https://discourse.julialang.org/t/ann-jet-v0-11/133366) – the main static analysis/testing tool in Julia. A lot of small niceties in the user facing API related to filtering analysis steps and reports, but also substantial internal work and simplification, providing momentum for future work.

* A mechanism for introducing [breaking changes to Julia syntax without breaking old packages](https://github.com/JuliaLang/julia/pull/60018) is being discussed, not too dissimilar to Rust Editions.

* Pkg now [supports the notion of a “deprecated” package](https://github.com/JuliaLang/Pkg.jl/pull/4433) (for which there will be a warning printed on installation). Such metadata is stored per registry. Here is an example of [use in the General package registry](https://github.com/JuliaRegistries/General/pull/141098).

* Pkg will soon [support “portable scripts”](https://github.com/JuliaLang/Pkg.jl/pull/4479), i.e. Julia scripts that embed their Project.toml and Manifest.toml in comments. Here are the related changes in [Julia](https://github.com/JuliaLang/julia/pull/59982) itself.

* Pkg will soon [support “downgrading”](https://github.com/JuliaLang/Pkg.jl/pull/4477), i.e. pushing the installed dependencies to the lowest compatible version. There have been various hacks to do this, but now with a much nicer user experience and stability. Relatedly, there is more and more work on integrating the new [SAT resolver in Pkg](https://github.com/JuliaLang/Pkg.jl/pull/4336), enabling even more sophisticated compat bound resolutions.

* Pkg will soon be [usable as a command line app](https://github.com/JuliaLang/Pkg.jl/pull/4473), similarly to how pip/uv/cargo are used from the CLI, not from inside of a REPL.

* [JuliaSyntax & JuliaLowering](https://github.com/JuliaLang/julia/pull/59870) are moving to the core julia repo to encourage more testing of these more more introspectable implementations of the julia parsing and lowering passes. JuliaSyntax has been in use for a while, but JuliaLowering is only now maturing. These are the passes that turn the text files of julia code into a clean datastructure that the compiler can understand, analyze, optimize, and finally compile into machine code. Much of the dev tooling like Cthulhu and Revise would become easier to use thanks to them.

* Work on moving julia to [LLVM v21](https://github.com/JuliaLang/julia/pull/59950) has now started.

* An incredibly powerful REPL history explorer was recently merged. Further work on [showing more metadata](https://github.com/JuliaLang/julia/pull/59953) is underway.

## In search of contributors

* [Contribute test cases to improve LLM performance on Julia code](https://discourse.julialang.org/t/help-wanted-help-contribute-test-cases-to-improve-llm-performance-on-julia-code/132991/)

* [JuliaPackageComparisons](https://discourse.julialang.org/t/juliapackagecomparisons-is-looking-for-a-new-maintainer/130667) is a wiki-like resource comparing different julia tools. It is in search of a new maintainer.

* [PyAMG.jl](https://github.com/cortner/PyAMG.jl) is looking for a new organisation or maintainer.

## Ecosystem

* [Swirl.jl](https://discourse.julialang.org/t/swirl-jl-interactive-julia-learning-in-the-repl/133705) is a fantastic “interactive lessons in the Julia REPL” package, inspired by the swirl package in R.

* [SnakeBar.jl](https://discourse.julialang.org/t/ann-snakebar-jl-a-progress-bar-that-fills-your-terminal-with-space-filling-curves/133580) is the best progress bar you might want to use in your julia apps.

* Julia-Rust interoperability is enabled by [jlrs](https://discourse.julialang.org/t/ann-jlrs-0-22-julia-version-autodetection-async-closure-support-and-more/133073) which had a recent new feature rich release.

* [MuxDisplay.jl](https://discourse.julialang.org/t/ann-muxdisplay-using-multiplexer-panes-tmux-wezterm-to-show-graphics/132998) for multiplexing Julia REPL output in terminal multiplexer panes like tmux and western.

* [BonitoBook.jl](https://discourse.julialang.org/t/ann-bonitobook-update-plugin-system-language-extensions-simplified-styling/133113), an alternative reactive notebook interface for Julia (and others), is getting a significant new release with many exciting features. BonitoBook is built around the same ecosystem that enables Makie plots in the browser.

* [AdditionalDistributions.jl](https://discourse.julialang.org/t/ann-additionaldistributions-jl-extending-distributions-jl-with-advanced-probability-models/133531) provides a wide range of statistical distributions following the Distributions.jl API, but enabling much faster development and exploration for more esoteric distributions.

* [MakieTypstEngine.jl](https://discourse.julialang.org/t/makietypstengine-jl-a-proof-of-concept-for-rendering-typst-strings-in-makie/133523) is a proof of concept for rendering Typst marked up strings in Makie. Typist is a recent alternative to the LaTeX ecosystem.

* [TerminalPager.jl](https://discourse.julialang.org/t/ann-terminalpager-jl-repl-inline-help-added/133131) has a new release, enabling more pleasant use of the built-in help browser in the REPL.

* Using Julia to [optimize and visualize a nuclear magnetic resonance control pulse](https://cncastillo.github.io/BlochHole/posts/julia-logo-rf-design/spins_draw_the_julia_logo.html), to draw Julia’s logo with an MRI machine.

* A helpful “blog style” post on [common beginner misconceptions in Julia](https://discourse.julialang.org/t/clearing-up-common-beginner-misconceptions/133404).

## Other ecosystems

* Rust has been working tirelessly on providing good [SIMD abstractions](https://shnatsel.medium.com/the-state-of-simd-in-rust-in-2025-32c263e5f53d) in the language.

## Events

* An independent [Julia conference is happening in Japan in December](https://discourse.julialang.org/t/julialang-japan-2025-sat-dec-13-2025-tokyo/133259).

See also: [JuliaHub corporate blog](https://juliahub.com/blog), [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](/community/#events), [Turing.jl newsletter](https://github.com/TuringLang/Turing.jl/issues/2498)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
