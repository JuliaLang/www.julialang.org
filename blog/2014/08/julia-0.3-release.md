@def rss_pubdate = Date(2014, 8, 20)
@def rss_description = """ Julia 0.3 Release Announcement | We are pleased to announce the release of Julia 0.3.0.  This release contains numerous improvements across the... """
@def published = "20 August 2014"
@def title = "Julia 0.3 Release Announcement"
@def authors = "The Julia Community"



We are pleased to announce the release of Julia 0.3.0.  This release contains numerous improvements across the
board from standard library changes to pure performance enhancements as well as an expanded ecosystem of packages as
compared to the 0.2 releases. A summary of changes is available in [NEWS.md](https://github.com/JuliaLang/julia/blob/release-0.3/NEWS.md)
found in our main repository, and binaries are now available on our [main download page](/downloads/).

A few notable changes:

- System image caching for fast startup.
- A pure-Julia REPL was introduced, replacing readline and providing expanded functionality and customization.
- The `workspace()` function was added, to clear the environment without restarting.
- Tab substitution of Latex character codes is now supported in the REPL, IJulia, and several editor environments.
- Unicode improvements including expanded operators and NFC normalization.
- Multi-process shared memory support. (multi-threading support is in progress and has been a major summer focus)
- Improved hashing and floating point range support.
- Better tuple performance.

We are now transitioning into the 0.4 development cycle and encourage users to use the 0.3.X line if they need a stable
julia environment.  Many breaking changes will be entering the environment over the course of the next few months. To reflect this period of change, nightly builds will use the versioning scheme 0.4.0-dev.  Once the major breaking changes have been merged and the
development cycle progresses towards a stable release, the version will shift to 0.4.0-pre, at which point package authors
and users should start to think about transitioning the codebases over to the 0.4.X line.

The release-0.3 branch of the codebase will remain open for bugfixes during this time. We encourage users facing
problems to open issues on our GitHub tracker, or email the julia-users mailing list.

Happy coding.

***************************

**News**

[JuliaBloggers](https://www.juliabloggers.com/) and the [searchable package listing](https://pkg.julialang.org/) were recently introduced.

The first ever [JuliaCon](https://juliacon.org) was held in Chicago in June, 2014. Several session recordings are available, and the others will be released soon:

- [Opening session](/blog/2014/08/juliacon-opening-session/)
- [Optimization session](/blog/2014/08/juliacon-opt-session/)

The Julia community participated in Google Summer of Code 2014. Wrap-up blog posts will be coming soon from the participants:

- [Simon Danisch](https://github.com/SimonDanisch) ([3D visualization](https://randomphantasies.wordpress.com/))
- [Shashi Gowda](https://github.com/shashi) ([Interactive Widgets for IJulia](https://github.com/shashi/Interact.jl) and [React.jl](https://juliagizmos.github.io/Reactive.jl/))
- [Mike Innes](https://github.com/MikeInnes) ([Julia + LightTable](https://github.com/JuliaIDE/Juno-LT))

**Topical highlights**

 "[The colors of chemistry](https://jiahao.github.io/julia-blog/2014/06/09/the-colors-of-chemistry.html)" notebook by [Jiahao Chen](https://github.com/jiahao) demonstrating IJulia, Gadfly, dimensional computation with SIUnits, and more.

[JuliaStats](https://juliastats.github.io/) - statistical and machine learning community.

[JuliaOpt](http://www.juliaopt.org/) - optimization community.

[IJulia](https://github.com/JuliaLang/IJulia.jl) - notebook interface built on IPython.

[Images](https://github.com/timholy/Images.jl) - image processing and i/o library.

[Gadfly](https://gadflyjl.org/) - Grammar of Graphics-inspired statistical plotting.

[Winston](https://github.com/JuliaGraphics/Winston.jl) - 2D plotting.
