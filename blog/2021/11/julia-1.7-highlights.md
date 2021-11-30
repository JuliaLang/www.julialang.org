+++
mintoclevel = 2
maxtoclevel = 2
title = "Julia 1.7 Highlights"
authors = "..."
published = "30 November 2021"
rss_pubdate = Date(2021, 11, 30)
rss = """Some highlights of the Julia 1.7 release."""
+++

After 4 betas and 3 release candidates, Julia version 1.7 has finally been released. We would like to thank all the contributors to this release and all the testers that helped with finding regressions and issues in the pre-releases. Without you, this release would not have been possible.

The full list of changes can be found in the [NEWS file](https://github.com/JuliaLang/julia/blob/release-1.7/NEWS.md), but here we'll give a more in-depth overview of some of the release highlights.

\toc


## New RNG (reproducible RNG in tasks)
*Jeff Bezanson*

From its very first release, Julia used the popular Mersenne Twister algorithm as its
default random number generator.
We knew we might want to re-evaluate that choice at some point, but it didn't seem
particularly urgent until Chet Hega [pointed out](https://github.com/JuliaLang/julia/pull/34852)
that by changing algorithms we could not only get a significant speed-up, but also
make random number streams *reproducible in multi-threaded programs*.

Mersenne Twister is famous for having an exceptionally long period, but that requires
a correspondingly large state, and is not truly necessary for any practical application.
We also used thread-local RNG states for thread safety, which has a bit of overhead and made
random streams task-schedule-dependent.
Chet's proposal took advantage of the much smaller state of the [Xoshiro256 family](https://prng.di.unimi.it/)
of RNGs to put a state in every *task*, and fork it on each task creation.
That makes random numbers depend only on the task spawning structure of a program, and not
on the parallel execution schedule.
It took a bit of debate for all of us to be comfortable spending precious bytes of Task
objects this way, but we are huge fans of reproducibility and so the proposal was eventually
adopted.

## New Threading Capabilities
*Jameson Nash*

The last few releases have been big ones for multithreading-demanding programs in Julia. This release is no exception: we've addressed numerous race conditions in the runtime, chased down synchronization mistakes, refined support for scheduling workloads on multiple threads, made the default random number generator more thread-friendly, and added atomics as a primitive language feature!

Support for atomic access to mutable struct fields has been added to provide more efficient build-blocks for working with threads via a set of `@atomic` macros, and their corresponding generic functions. A summary of the new functionalities was presented at JuliaCon and can be found [on youtube](https://www.youtube.com/watch?v=2rBv6sV4Xts). This work is based on the "Atomics Manifesto" that described how we envisioned threading to be a key part of the language's future, links to which can be found in the [Julia manual on multi-threading with per-field atomics](https://docs.julialang.org/en/v1.7/manual/multi-threading/#man-atomics)

We are very excited about this. We've already seen some packages in the ecosystem building about this foundation to provide thread-safe abstractions:

* [JuliaConcurrent/ConcurrentCollections.jl](https://github.com/JuliaConcurrent/ConcurrentCollections.jl): queues and dictionaries for shared state.
* [JuliaActors/Actors.jl](https://github.com/JuliaActors/Actors.jl/blob/master/README.md): patterns for making concurrency easy to understand and reason about.
* [tkf/ThreadsX.jl](https://github.com/tkf/ThreadsX.jl): Parallelized versions of some Base functions.
* [JuliaFolds/Transducers.jl](https://juliafolds.github.io/Transducers.jl/dev/parallelism/#overview-parallel): thread-based (foldxt) and process-based (foldxd) parallelisms with the same composable API; i.e. transducers.
* [JuliaFolds/FLoops.jl](https://github.com/JuliaFolds/FLoops.jl/blob/master/README.md): generates a fast generic sequential and parallel iteration over complex collections.

## Package Manager

### Automatic package installation

*Ian Butterworth*

If a package exists in a registry but is not installed, an automatic install is now offered when a package load is attempted in the REPL.

What used to be
```julia-repl
julia> using Foo
ERROR: ArgumentError: Package Foo not found in current path:
- Run `import Pkg; Pkg.add("Foo")` to install the Foo package.

Stacktrace:
 [1] require(into::Module, mod::Symbol)
   @ Base ./loading.jl:871

(@1.6) pkg> add Foo
...

julia> using Foo

julia> Foo
Foo
```
can now be achieved with just
```julia-repl
julia> using Foo
 │ Package Foo not found, but a package named Foo is available from a registry.
 │ Install package?
 │   (@v1.7) pkg> add Foo
 └ (y/n) [y]: y
 ...
julia> Foo
Foo
```
By default, the package will be installed into the current active environment, selected via `y` or a single `return` key press. To cancel select `n` or use `Ctrl-c`.

### New manifest format
*Kristoffer Carlsson*, *Ian Butterworth*

Whenever a user adds a package in Julia, the package manager (Pkg) writes out a TOML file called the "manifest" with the exact version of all the dependencies of that package. Different package versions might be compatible with different Julia versions and the output of the "resolver" (the algorithm that computes a set of compatible versions for all packages and dependencies in the project) is therefore dependent on the Julia version. It is therefore not recommended to use a manifest created in one Julia version with another Julia version. It would be convenient if Pkg could warn you when this is happening.

In order to issue such a warning, Pkg would need to know what Julia version generated a given manifest. However, the current format (or schema) of the manifest makes adding such information hard. The reason for that is that the format is such that the top-level keys in the TOML file are the package names of the dependencies. This means that there isn't any space to add something like a `julia_version` entry. Of course, it would be possible to special case an entry with this name (with the assumption that no one will name a package exactly `julia_version`) but it would be much nicer to not have the same "structural" entry refer to two completely different things.

What was done in version 1.7 was to change this manifest format so that all dependencies are instead put under a common `[deps]` key. This frees up the global namespace so that a `julia_version` entry can be added. It also opens up the possibility of adding future useful data to the manifest. The ability to read such manifests will also be backported to Julia 1.6 and thus be in Julia 1.6.2 and forward. Pkg will also keep the format of an existing manifest so only new manifests will have the new manifest format going forward.


### Improved performance for handling registries on Windows and distributed file systems

*Kristoffer Carlsson*

We noticed some complaints about the speed of the Julia package manager (Pkg) on Windows and on Network File Systems (NFSs). What is common between these is that these are systems where file operations tend to be significantly more expensive. In Julia 1.7 we have spent some time identifying and improving the situation.

[The General registry](https://github.com/JuliaRegistries/General) is the default registry that Pkg uses to look up information about packages. It is structured such that each package has four different TOML files. As of writing, General contains 5761 packages which means that it contains approximately 23 000 files. There are two ways for Pkg to get updates for a registry, either via the git-protocol or via HTTPS using something called the "Pkg Server", which is a community-driven way of hosting packages and registries where the registry is downloaded as a compressed tarball. There were reports that on Windows the initial download of the General registry would take on the order of minutes while on Linux and macOS it typically takes a few seconds. The main cause of the slow down was diagnosed to be Windows Defender causing slowdowns upon closing files which hits very hard when extracting 23 000 small files. The Rust community [faces a similar issue](https://github.com/rust-lang/rustup/issues/1540) when it comes to uncompressing their documentation. This problem is described in more detail [in this blog post](https://gregoryszorc.com/blog/2021/04/06/surprisingly-slow/) and suggests that using a thread pool just for closing files can significantly improve performance.

Instead of using a thread pool to speed up closing files, we decided to take a different route.
Julia comes bundled with [p7zip](http://p7zip.sourceforge.net/) and together with the standard library [`Tar.jl`](https://github.com/JuliaIO/Tar.jl) it is possible to directly read the compressed tarball into memory without materializing any files at all. By doing so the problem of materializing files is obliviated which significantly improves the performance of the registry on Windows, NFS and other distributed file systems like those typically used in HPC systems.

As an example, we can see the effect on a "clean" system when installing the Example package from scratch. First, with the old methods of uncompressing all files (~30 seconds):

```julia-repl
julia> @time Pkg.add("Example")
  Installing known registries into `C:\Users\Kristoffer Carlsson\.julia`
   Resolving package versions...
   Installed Example ─ v0.5.3
 29.509835 seconds (4.81 M allocations: 320.162 MiB, 0.81% gc time)
```

And then with the new method of reading the compressed registry directly into memory (~2 seconds):

```julia-repl
julia> @time Pkg.add("Example")
  Installing known registries into `C:\Users\Kristoffer Carlsson\.julia`
   Resolving package versions...
   Installed Example ─ v0.5.3
  1.953665 seconds (2.35 M allocations: 164.310 MiB, 1.96% gc time)
```

## Better path printing for standard libraries in errors

*Kristoffer Carlsson*

The path for a Julia method is set when the method is defined. This means that when one is using a Julia installation that has been compiled somewhere else (for example the official Julia installations) paths for methods shipped with Julia will refer to some cloud server that did the compilation. As an example, below the path to the "buildworker" that compiled Julia is shown:

```julia-repl
julia> using Random; Random.seed!("seed")
ERROR: MethodError: no method matching seed!(::String)
Closest candidates are:
  seed!() at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.6/Random/src/RNGs.jl:362
...
```

Some editors have support for opening files by clicking paths in the terminal but this does not work in cases like this. In v1.7, this has been fixed to instead print paths that are valid locally:

```julia-repl
julia> using Random; Random.seed!("seed")
ERROR: MethodError: no method matching seed!(::String)
Closest candidates are:
  seed!() at ~/Downloads/julia/share/julia/stdlib/v1.7/Random/src/RNGs.jl:387
...
```

The example above was for a `MethodError` but the same improvement also applies to stacktraces.


## Inference improvements

*Shuhei Kadowaki*

This release comes with many type inference improvements.
With these improvements, Julia 1.7 will more "smartly" infer types of your program and improve performance for free!

Most notably, 1.7 can propagate type constraints that can be derived from `isa` and `===` conditions _inter-procedurally_ (i.e. across any function calls).
Certain Julia programs are written in a way that their behavior changes depending on runtime types, and such programs may run much faster by the inferrability gain of this improvement. For example, now there is no inferrability difference between `x === nothing` and `isnothing(x)` (and so you no longer need to remember [this performance tip](https://docs.julialang.org/en/v1.6/manual/performance-tips/#Checking-for-equality-with-a-singleton)):
```julia-repl
julia> code_typed((Union{Nothing,Int},); optimize=false) do x
           return isnothing(x) ? 0 : x
       end |> first
```
```diff
--- v1.6
+++ v1.7
@@ -1,6 +1,6 @@
 CodeInfo(
 1 ─ %1 = Main.isnothing(x)::Bool
 └──      goto #3 if not %1
 2 ─      return 0
-3 ─      return x
-) => Union{Nothing, Int64}
+3 ─      return x::Int64
+) => Int64
```

Of course, this inter-procedural constraint propagation works for arbitrary generic functions:
```julia-repl
julia> ispositive(a) = isa(a, Number) && a > 0;
julia> code_typed((Union{Nothing,Int},); optimize=false) do x
           return ispositive(x) ? x : 0
       end |> first
```
```diff
--- v1.6
+++ v1.7
@@ -1,6 +1,6 @@
 CodeInfo(
 1 ─ %1 = Main.ispositive(x)::Bool
 └──      goto #3 if not %1
-2 ─      return x
+2 ─      return x::Int64
 3 ─      return 0
-) => Union{Nothing, Int64}
+) => Int64
```

Another remarkable improvement is more eager constant propagation.
Julia 1.7 can substitute more runtime computations with pre-computed constants, and eliminate dead code by resolving conditional branches at compile time.
As an example, in 1.7, computations of special functions can be fully folded at compile time:
```julia-repl
julia> code_typed((Int,)) do n
           n + sin(sum(sincos(42))) # no runtime computation of `sum(sincos(42))` in 1.7!
       end |> first
```
```diff
--- v1.6
+++ v1.7
@@ -1,32 +1,5 @@
 CodeInfo(
-1 ─ %1  = Base.muladd_float(0.16933292771007588, 2.7557313707070068e-6, -0.0001984126982985795)::Float64
-│   %2  = Base.muladd_float(0.16933292771007588, %1, 0.00833333333332249)::Float64
-│   %3  = Base.muladd_float(0.16933292771007588, 1.58969099521155e-10, -2.5050760253406863e-8)::Float64
-│   ... many runtime computations ...
-│   %27 = invoke Main.sin(%26::Float64)::Float64
-│   %28 = Base.sitofp(Float64, n)::Float64
-│   %29 = Base.add_float(%28, %27)::Float64
-└──       return %29
+1 ─ %1 = Base.sitofp(Float64, n)::Float64
+│   %2 = Base.add_float(%1, -0.9678422808766897)::Float64
+└──      return %2
 ) => Float64
```

For those interested, here is the list of specific PRs that implement the main inference improvements of this release:
- inter-procedural conditional constraint propagation ([#38905](https://github.com/JuliaLang/julia/pull/38905))
- constant propagation for union-split callsite ([#39305](https://github.com/JuliaLang/julia/pull/39305))
- constant propagation for `invoke` callsite ([#41383](https://github.com/JuliaLang/julia/pull/41383))
- more conditional constraint propagation ([#39936](https://github.com/JuliaLang/julia/pull/39936), [#40832](https://github.com/JuliaLang/julia/pull/40832))

These inference improvements were initially motivated by the needs of [JET.jl](https://github.com/aviatesk/JET.jl), a static analyzer for Julia, that is powered by the Julia compiler's type inference implementation.
These inference improvements in 1.7 allow JET to analyze your program more correctly and faster –
as a simple measurement, [when analyzing JET itself](https://gist.github.com/aviatesk/e2ffa4bfaee60f939ef4b65449fa394b),
JET took `90` seconds to report `93` false-positive errors in 1.6,
but in 1.7 and higher, JET can finish the analysis within `40` seconds and the number of false positives is reduced to `27`,
thanks to both the type inference improvements and [several inferrability improvements of Julia Base](https://github.com/JuliaLang/julia/pulls?q=is%3Apr+is%3Amerged+inferrability).

## `libblastrampoline` + `MKL.jl`

*Elliot Saba*, *Viral B Shah*, *Mosè Giordano*

Julia v1.7 introduces a new BLAS demuxing library called [libblastrampoline (LBT)](https://github.com/staticfloat/libblastrampoline), that provides a flexible and efficient way to switch the backing BLAS library at runtime.
Because the BLAS/LAPACK API is "pure" (e.g. each BLAS/LAPACK invocation is separate from any other; there is no carryover state from one API call to another) it is possible to switch which BLAS backend actually services a particular client API call, such as a [DGEMM](http://www.netlib.org/lapack/explore-html/d1/d54/group__double__blas__level3_gaeda3cbd99c8fb834a60a6412878226e1.html) call for a `Float64` `Matrix`-`Matrix` multiplication.
This statelessness enables us to easily switch from one BLAS backend to another without needing to modify client code, and combining this with a flexible wrapper implementation, we are able to provide a single, coherent API that automatically adjusts for a variety of BLAS/LAPACK providers across all the platforms that Julia itself supports.

The wrapper itself consists of assembly routines to jump to a stored function pointer, using the same assembly chunks that the [Procedure Linkage Table (PLT)](https://www.technovelty.org/linux/plt-and-got-the-key-to-code-sharing-and-dynamic-libraries.html) uses in every dynamic library on your operating system.
These small, efficient assembly routines act as a "trampoline", bouncing a call to its true destination within OpenBLAS, MKL, etc...

The story doesn't end with just writing high-performance forwarding routines, however; we also must deal with the complexity of differing BLAS/LAPACK ABIs.
The most user-visible ABI difference is that of BLAS libraries that are built to use 64-bit indices (ILP64) rather than 32-bit indices (LP64).
Mixing and matching client libraries that pass an index to a BLAS backend that expects indices of a different bitwidth can have disastrous consequences, from silently computing the wrong result to outright segfaulting.
The Julia project has long been a proponent of namespacing these two ABIs separately, by suffixing ILP64 BLAS symbols to differentiate them from the rest of the world and thereby avoid fatal confusion, renaming e.g. `dgemm_` to `dgemm_64_` (note the trailing underscore is a `gfortran` convention that we follow to maintain ABI compatibility).
To deal with this, LBT exports two sets of symbols; an LP64 set with the names that most software expects, and an ILP64 set with the names that many pieces of software in the Julia world already expect (e.g. suffixed with `64_`).
Internally, LBT maintains forwarding tables for the LP64 and ILP64 exported functions separately, allowing for a great degree of flexibility in managing BLAS/LAPACK backends.

Another possible ABI difference is the naming of the symbols themselves (`dgemm`, `dgemm_`, `dgemm__`, `_dgemm_` and `myblas_dgemm` are all BLAS symbol names that have been seen in the wild) and so LBT performs a simple search over different possible manglings when loading a BLAS/LAPACK backend.
Apple's Accelerate backend uses a slightly different ABI than the default `gfortran` ABI as related to passing character arguments (such as the `'U'` parameter to certain LAPACK routines marking something as an "upper" triangular matrix), and LBT automatically converts to/from this other ABI.
Finally, LBT manages some vendor-specific APIs such as setting the number of threads of the backend libraries through a single entry-point.

Most users will never need to directly interact with LBT, however, for those that are interested, you can start with looking at the metadata LBT tracks on what libraries are currently loaded:

```julia-repl
julia> LinearAlgebra.BLAS.lbt_get_config()
LinearAlgebra.BLAS.LBTConfig
Libraries:
└ [ILP64] libopenblas64_.so
```

This shows that a single ILP64 library is currently loaded, and that library is `libopenblas64_.so`.
Loading an LP64 library (such as the one provided by [OpenBLAS32_jll](https://github.com/JuliaBinaryWrappers/OpenBLAS32_jll.jl)) changes the result somewhat:

```julia-repl
julia> LinearAlgebra.BLAS.lbt_forward(OpenBLAS32_jll.libopenblas_path)
4860

julia> LinearAlgebra.BLAS.lbt_get_config()
LinearAlgebra.BLAS.LBTConfig
Libraries:
├ [ILP64] libopenblas64_.so
└ [ LP64] libopenblas.so
```

Loading `MKL` instantly switches the configuration over to using `MKL`, and all BLAS invocations from that point on will be performed by the Intel-written kernels instead.
It is possible to create truly complex setups (e.g. layering a library that provides only a few BLAS symbols on top of OpenBLAS which can provide the rest) but for most users the main impact will simply be that it is no longer necessary to recompile Julia when you want to use an alternate BLAS library.
Note that Julia's choice to use ILP64 or LP64 _is_ still a compile-time decision, and that even if you load `OpenBLAS32_jll` to provide LP64 symbols, Julia will still use ILP64 on 64-bit platforms by default.
The main reason to support LP64 on 64-bit platforms at all is to provide the symbols for other programs that may be linked into Julia's namespace, such as using [`PyCall`](https://github.com/JuliaPy/PyCall.jl) to load `numpy`.

For more information you can watch the talk "[Runtime-switchable BLAS/LAPACK backends via libblastrampoline](https://www.youtube.com/watch?v=t6hptekOR7s)" from JuliaCon 2021.

## Escaping newlines inside strings

*Simeon Schaub*

One small but hopefully useful new feature is the ability to break up long lines inside string literals. Whereas strings with long lines such as in error messages had to be split up manually into multiple strings before, in order to conform to a maximum line width, the newline can now be escaped by simply preceding it with a backslash inside the string:

```julia
function foo(x)
    if isbad(x)
        error("This is a long error message describing exactly why `x` is bad, \
               but that means it exceeds our desired column width.")
    end
    return bar(x)
end
```

which also works inside triple quotes as you would expect.

This feature has also been implemented for command literals, so that the behavior is more consistent with other POSIX-like shells:

````julia-repl
julia> run(```
           echo foo\
           bar```);
foobar
````

Note that this change otherwise only affects non-custom/non-raw string literals to avoid breaking code that relies on the existing behavior and to allow more control over how such cases should be handled by custom string literals:

```julia-repl
julia> raw"""
       a\
       b"""
"a\\\nb"
```

## Multidimensional Array Literals

*Nicholas Bauer*

Multidimensional arrays, especially with 3 or more dimensions, are useful constructs for scientific programming and in machine learning. However, programming languages have not made it easy to create and work with them.

Julia has had first-class methods to work with multidimensional arrays. However, through v1.6, there was no way to create them with pure syntax and minimal allocation overhead. You would have to first allocate 1- or 2-dimensional arrays and then `reshape()` it, or `cat()` them together one dimension at a time. It was also awkward to create a one-column matrix and single-element higher-dimensional arrays.

With Julia v1.7, we have added syntax to enable you to write a literal for multidimensional arrays. This new syntax makes multidimensional arrays much easier to manipulate in Julia than they were before, and we believe it compares favorably with the creation of multidimensional arrays in other languages:
```
Julia v1.7:
[1 2 ; 3 4 ;;; 5 6 ; 7 8]
or
[1 ; 3 ;; 2 ; 4 ;;; 5 ; 7 ;; 6 ; 8]

Python with Numpy:
import numpy as np
np.array([[[1, 2], [3, 4]], [[5, 6], [7, 8]]])

MATLAB:
A = [1 2; 3 4]
A(:,:,2) = [5 6; 7 8]

R:
array(c(1, 3, 2, 4, 5, 7, 6, 8), dim = c(2, 2, 2))
```

The syntax is a straightforward extension of the current syntax: one additional semicolon == one additional dimension:
```julia-repl
julia> [1 2 ; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> [1 2 ;;; 3 4]
1×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  2

[:, :, 2] =
 3  4

julia> [1 2 ;;;; 3 4]
1×2×1×2 Array{Int64, 4}:
[:, :, 1, 1] =
 1  2

[:, :, 1, 2] =
 3  4

julia> using BenchmarkTools

julia> @btime [1 2 ;;;; 3 4];
  44.838 ns (2 allocations: 160 bytes)

julia (v1.6)> @btime cat([1 2], [3 4], dims = 4); # clear, but slow, and gets worse with more dimensions
  1.380 μs (23 allocations: 1.05 KiB)

julia (v1.6)> @btime reshape([1; 2; 3; 4], (1, 2, 1, 2)); # fast, but intent less clear
  65.884 ns (2 allocations: 192 bytes)
```

This is a substantial improvement in performance for this basic operation, and the differential improves greatly as more dimensions become invovled.

For ease of reading a larger array expression, line breaks are of course tolerated:
```julia-repl
julia> [ 1 2
         3 4
         ;;;
         5 6
         7 8 ]
2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  2
 3  4

[:, :, 2] =
 5  6
 7  8
```

This syntax also makes it possible to write arrays in column-first order instead of row-first order, using `;;` instead of spaces for rows:
```julia-repl
julia> [1 ; 2 ;; 3 ; 4 ;;; 5 ; 6 ;; 7 ; 8]
2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  3
 2  4

[:, :, 2] =
 5  7
 6  8
```

Lower numbers of semicolons take precedence over higher numbers of semicolons, so the above expression is equivalent to:
```julia-repl
julia> [[[1 ; 2] ;; [3 ; 4]] ;;; [[5 ; 6] ;; [7 ; 8]]];
```

Note however that writing that form will allocate each intermediate array, as brackets always do in Julia.

Spaces and double semicolons cannot be mixed in the same expression, generally. However, you *can* use double semicolons to insert a line break within a row, which wasn't possible before:
```julia-repl
julia> [1 2 3 4;;
        5 6 7 8]
1×8 Matrix{Int64}:
 1  2  3  4  5  6  7  8
```

Powerfully, this syntax may also be used to concatenate multidimensional arrays along arbitrary dimensions with minimal overhead:
```julia-repl
julia> const a, b, c = fill(1, 1, 2, 1, 2), fill(2, 2, 2, 1, 2), fill(3, 3, 2, 1, 3);

julia> [a ; b ;;;; c] == [1 1 ; 2 2 ; 2 2 ;;;;
                          1 1 ; 2 2 ; 2 2 ;;;;
                          3 3 ; 3 3 ; 3 3 ;;;;
                          3 3 ; 3 3 ; 3 3 ;;;;
                          3 3 ; 3 3 ; 3 3];

julia> using BenchmarkTools

julia> @btime [a ; b ;;;; c];
  980.000 ns (18 allocations: 1.33 KiB)

julia (v1.6)> @btime cat([a ; b], c, dims = 4);
  3.056 μs (37 allocations: 1.86 KiB)
```

Under the hood, this syntax is calling `hvncat(dimsshape, row_first, xs...)`. `xs...` is the splatted series of elements to insert into the array or concatenate. `row_first` is a boolean indicating whether the values should be interpreted as written row-first (e.g. `[a b ; c d]`) or column-first (e.g. `[a ; b ;; c ; d]`). The first argument, `dimsshape`, may be one of three types that describe the shape of inputs from the syntax. A single integer (`dimsshape::Int`) means that the elements should be concatenated along the one dimension indicated by that integer (e.g. `[a ;;; b ;;; c]`). A tuple of integers (`dimsshape::NTuple{N, Int}`) indicates that there are an equal number of elements being concatenated along each dimension (e.g. `[a b ;;; c d])`). A tuple of tuples of integers (`dimsshape::NTuple{N, Tuple}`) is the general-purpose case, and describes syntax where uneven numbers of elements are present in each dimension (e.g. `[a b ;;; c]`).

Here is how the syntax is lowered:
```julia
[a ;;; b ;;; c] == hvncat(3, a, b, c) # row_first isn't needed here
[a b ;;; c d] == hvncat((1, 2, 2), true, a, b, c, d)
[a b ; c ;;; d ;;;;] == hvncat(((2, 1, 1), (3, 1), (4,), (4,)), true, a, b, c, d)
 #=
 How the shape argument is constructed:
 ___   _     _
 2     1     1 = (2, 1, 1) elements in each row
 _______     _
 3           1 = (3, 1) elements in each column
 _____________
 4             = (4,) elements in each 3d slice
 _____________
 4             = (4,) elements in each 4d slice
 =#
```

Last, but certainly not least, this syntax makes it very easy to write a one-column matrix or a 2+ dimension single-element array, a highly requested feature:
```julia-repl
julia> [1; 2; 3;;]
3×1 Matrix{Int64}:
 1
 2
 3

julia> [1;;;]
1×1×1 Array{Int64, 3}:
[:, :, 1] =
 1
```

For fun, here's an example of how you could use this syntax to generate a Sudoku-like board (h/t Matt Bauman):
```julia
[rand(1:9, 3, 3);;; rand(1:9, 3, 3);;; rand(1:9, 3, 3);;;;
 rand(1:9, 3, 3);;; rand(1:9, 3, 3);;; rand(1:9, 3, 3);;;;
 rand(1:9, 3, 3);;; rand(1:9, 3, 3);;; rand(1:9, 3, 3);;;;]
```

## Property Destructuring

*Simeon Schaub*

One fairly simple but hopefully useful new syntax addition is support for destructuring objects not only by iteration, but also by property name. This is modeled after the `(; a b)` syntax added in 1.5 for constructing `NamedTuple`s whose field names correspond to the used variable names.

A simple example of how this syntax can be used:

```julia-repl
julia> nt = (a=1, b=2)
(a = 1, b = 2)

julia> (; a, b) = nt
(a = 1, b = 2)

julia> a
1

julia> b
2
```

`(; a, b) = nt` is simply equivalent to `a = nt.a; b = nt.b`, so it can be used not just for `NamedTuple`s, but for destructuring the properties of any object and will also work with `DataFrame`s for example. It can also be used inside function arguments just like regular destructuring. A `myreal` function which just extracts the real part of a complex number could now be written as follows:

```julia-repl
julia> myreal((; re)::Complex) = re
myreal (generic function with 1 method)

julia> myreal(2 + 3im)
2
```

This syntax is also compatible with type annotations (note that these don't play any role in dispatch when used inside function arguments though):

```julia-repl
julia> let
           (; a::UInt, b::Float64) = (a=1, b=2)
           b = 5
           a, b
       end
(0x0000000000000001, 5.0)
```

## Support for Apple Silicon

*Keno Fischer*, *Elliot Saba*, *Mosè Giordano*

Julia v1.7 is also the first release which runs on Apple Silicon, for example the M1 family of ARM CPUs.  Planning for this feature actually [started](https://github.com/JuliaLang/julia/issues/36617) more than one year ago, shortly after Apple announcement of their new chips.  The road to this landmark was initially complicated by the lack of a Fortran compiler for the new platform, which is necessary to build one of the Julia binary dependencies, namely OpenBLAS.  Of course, Julia [was not](https://developer.r-project.org/Blog/public/2020/11/02/will-r-work-on-apple-silicon/index.html) the only open source project for numerical computing affected by this issue, which was finally solved by the availability of [a fork of GCC](https://github.com/iains/gcc-darwin-arm64) developed by Iain Sandoe.

While we are now able to provide pre-built Julia binaries for this platform, its support is currently considered [tier 3](https://julialang.org/downloads/#currently_supported_platforms), which means that it is experimental and [specific bugs are to be expected](https://github.com/JuliaLang/julia/labels/apple%20silicon).  The [Julia User & Developer Survey 2021](https://julialang.org/blog/2021/08/julia-user-developer-survey/) showed that 5% of Julia users were already running Julia on this platform before an official stable version for it was released!  Remember that also the x86-64 (Intel) binaries of Julia can run on these machines, thanks to the Rosetta 2 compatibility layer, albeit with a reduced performance.

## Conclusion

Please enjoy the release, and as always [let us know](https://github.com/JuliaLang/julia/issues) if you encounter any problems or have any suggestions. We hope to be back in a few months to report on even more progress in version 1.8!
