@def rss_pubdate = Date(2015, 10, 9)
@def rss = """ Julia 0.4 Release Announcement | We are pleased to announce the release of Julia 0.4.0.  This release contains... """
@def published = "9 October 2015"
@def title = "Julia 0.4 Release Announcement"
@def authors = "The Julia Community"  


We are pleased to announce the release of Julia 0.4.0.  This release contains
major language refinements and numerous standard library improvements.
A summary of changes is available in the
[NEWS log](https://github.com/JuliaLang/julia/blob/release-0.4/NEWS.md)
found in our main repository. We will be making regular 0.4.x bugfix releases from
the release-0.4 branch of the codebase, and we recommend the 0.4.x line for users
requiring a more stable Julia environment.

The Julia ecosystem continues to grow, and there are now
over 700 registered packages! (highlights below).
JuliaCon 2015 was held in June, and >60 talks are [available to view](https://www.youtube.com/playlist?list=PLP8iPy9hna6Sdx4soiGrSefrmOPdUWixM). [JuliaCon India](https://www.juliacon.in/2015) will be held in Bangalore on 9 and 10 October.

We welcome bug reports on our GitHub tracker, and general usage questions on the
users mailing list, StackOverflow, and several [community forums](/community/).

Binaries are available from the
[main download page](/downloads/), or visit [JuliaBox](https://juliabox.org/)
to try 0.4 from the comfort of your browser. Happy Coding!

***************************

**Notable compiler and language news:**

- [Incremental code caching for packages](https://github.com/JuliaLang/julia/issues/8745),
  resulting in a major reduction in loading time for [Gadfly](https://gadflyjl.org/) and other large,
  inter-dependent packages.
- [Generational garbage collector](https://github.com/JuliaLang/julia/issues/5227) which greatly
  reduces GC overhead for many common workloads.
- [Function call overloading for arbitrary objects](https://github.com/JuliaLang/julia/pull/8712)
- [Generated functions](https://github.com/JuliaLang/julia/issues/7311) (sometimes known as "staged functions") introduce finer control
  over compile-time specialization.
  [Docs](https://docs.julialang.org/en/v1/manual/metaprogramming/#)
  and related [JuliaCon talk](https://www.youtube.com/watch?v=KAN8zbM659o&list=PLP8iPy9hna6Sdx4soiGrSefrmOPdUWixM&index=55).
- [Support for documenting user functions and other objects](https://github.com/JuliaLang/julia/pull/8791)
  and retrieving the documentation via the help system.
- Improvements in the performance and flexibility of [multidimensional abstract arrays](https://github.com/JuliaLang/julia/pull/10525),
  [SubArrays (array views)](https://github.com/JuliaLang/julia/pull/8501),
  and efficient [multidimensional iterators](https://github.com/JuliaLang/julia/pull/8432).
- [Inter-task channels](https://github.com/JuliaLang/julia/pull/12264) for faster communication between parallel tasks
- [Tuple type improvements](https://github.com/JuliaLang/julia/issues/10380): the type tuple `(A,B)`
  now written `Tuple{A,B}`. This change has improved the performance of many tuple-related operations, and allowed one to write fixed-size aggregate fields
  as `field::NTuple{N,T}` (`N`umber of elements of given `T`ype).
- Major improvements in Julia's test coverage and the ability to analyze the test coverage of packages
- The command line (REPL) now supports [tab-completion of emoji characters](https://github.com/JuliaLang/julia/issues/10709) (common LaTeX symbols have been supported since 0.3!)

***************************

**Upcoming work for 0.5**

Nightly builds will use the versioning scheme 0.5.0-dev.

- A major focus of 0.5 will be further (breaking) improvements to core array functionality, as detailed
  in [this issue](https://github.com/JuliaLang/julia/issues/13157).
- We plan to merge the [threading branch](https://github.com/JuliaLang/julia/pull/13410),
  but the functionality will be considered experimental and only available as a compile-
  time flag for the near future.

***************************

**Community News**

The Julia ecosystem continues to grow, and there are now
over 700 registered packages! (highlights below)

The second [JuliaCon](https://juliacon.org) was held in Cambridge (USA) in June, 2015.
Over 60 talks were recorded and
[are available for viewing](https://www.youtube.com/playlist?list=PLP8iPy9hna6Sdx4soiGrSefrmOPdUWixM).

[JuliaCon India](https://www.juliacon.in/2015) will be held in Bangalore on 9 and 10 October.

[JuliaBloggers](https://www.juliabloggers.com/) is going strong! A notable recent feature is
the #MonthOfJulia series exploring the core language and a number of packages.

**Topical Highlights**

[JuliaStats](https://juliastats.github.io/) - statistical and machine learning community.

[JuliaOpt](http://www.juliaopt.org/) - optimization community.

[JuliaQuantum](https://juliaquantum.github.io/) - Julia libraries for quantum-science and technology.

[JuliaGPU](https://github.com/JuliaGPU) - GPU libraries and tooling.

[IJulia](https://github.com/JuliaLang/IJulia.jl) - notebook interface built on IPython.

[Images](https://github.com/timholy/Images.jl) - image processing and i/o library.

[Gadfly](https://gadflyjl.org/) - Grammar of Graphics-inspired statistical plotting.

[Winston](https://github.com/JuliaGraphics/Winston.jl) - 2D plotting.

[JunoLab](https://junolab.org/) - LightTable-based interactive environment.
