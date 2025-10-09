@def rss_pubdate = Date(2016, 10, 10)
@def rss = """ Julia 0.5 Release Announcement | After over a year of development, the Julia community is proud to announce... """
@def published = "10 October 2016"
@def title = "Julia 0.5 Release Announcement"
@def authors = "The Julia Community"  

After over a year of development, the Julia community is proud to announce
the release of version 0.5 of the Julia language and standard library.
This release contains major language refinements and numerous standard library improvements.
A long list of changes is available in the [NEWS log](https://github.com/JuliaLang/julia/blob/release-0.5/NEWS.md#julia-v050-release-notes) found in our main repository, with a summary reproduced below.
A separate blog post detailing some of the [highlights of the new release](/blog/2016/10/julia-0.5-highlights/) has also been posted.

We'll be releasing regular bugfix backports from the 0.5.x line, which is recommended for users requiring a stable language and API.
Major feature work is ongoing on master for 0.6-dev.

The Julia ecosystem continues to grow, and there are now over one thousand registered packages!
The third annual [JuliaCon](https://juliacon.org/) took place in Cambridge, MA in the [summer of 2016](/blog/2016/09/juliacon2016/), with an exciting line up of talks and keynotes.
Most of them are [available to view](https://www.youtube.com/playlist?list=PLP8iPy9hna6SQPwZUDtAM59-wPzCPyD_S).

Binaries are available from the [main download page](/downloads/) or visit [JuliaBox](https://juliabox.com/) to try this release from the comfort of your browser. Happy Coding!

### Notable compiler and language changes:

- The major focus of this release has been the ability to write fast functional code, removing the earlier performance penalty for anonymous functions and closures.
  This has been achieved via each function and closure now being its own type, and the captured variables of a closure are fields of its type.
  All functions, including anonymous functions, are now generic and support all features.

- Experimental support for [multi threading](https://docs.julialang.org/en/latest/manual/parallel-computing/#multi-threading-experimental).

- All dimensions indexed by [scalars are now dropped](https://github.com/JuliaLang/julia/issues/13612), whereas previously only trailing scalar dimensions would be omitted from the result.
  This is a major breaking changes, but has been made to make the indexing rules much more consistent.

- [Generator expressions](https://github.com/JuliaLang/julia/issues/4470) now can create iterators that are computed only on demand.

- Experimental support for [arrays whose indexing](https://github.com/JuliaLang/julia/issues/16260) starts from values other than 1. Standard Julia arrays are still 1-based, but external packages can implement array types with indexing from arbitrary indices.

- Major simplification of the [string types](https://github.com/JuliaLang/julia/issues/16107), unifying `ASCIIString` and `UTF8String` as `String`, as well as moving types and functions related to different encodings out of the standard library.

- [Package operations](https://github.com/JuliaLang/julia/issues/11196) now use the `libgit2` library rather than shelling out to command line git. This makes these calls to package related functions much faster, and more reliable, especially on Windows.

- And [many many more](https://github.com/JuliaLang/julia/blob/release-0.5/NEWS.md#julia-v050-release-notes) changes and improvements...

### Ports

Julia now runs on the ARM and Power architectures, making it possible to use it on the widest variety of hardware, from the smallest embedded machines to the largest HPC systems. Porting a language to a new architecture is never easy, so special thanks to the people who made it possible. Part of the work to create the Power port was supported by IBM, for which we are grateful.

### Developing with Julia

The Julia debugger, [Gallium](https://github.com/Keno/Gallium.jl), is now ready to use. It allows for a full, multi language debug experience, debugging Julia and C code with ease. The debugger is also integrated with [Juno](https://junolab.org), the Julia IDE that is now fully featured and ready to use.
