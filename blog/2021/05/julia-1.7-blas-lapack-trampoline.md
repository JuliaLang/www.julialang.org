@def title = "BLAS and LAPACK trampolines in Julia 1.7"
@def authors = "Elliot Saba, Viral Shah"
@def published = "5 May 2021"
@def rss_pubdate = Date(2021, 5, 5)
@def rss = """"BLAS and LAPACK trampolines in Julia 1.7"""

The BLAS and LAPACK libraries have been a corner stone of technical computing for at least 20 years now, if not more! The APIs in BLAS and LAPACK have been so successful, that hardware vendors provide their own implementations of these APIs in order to extract the highest performance from their hardware. While Julia has always supported using your own BLAS, it has historically required either building Julia from source, or rebuilding the system image (as was the case with MKL.jl).

Julia 1.7 will ship with [libblastrampoline](https://github.com/staticfloat/libblastrampoline) (LBT). A famous aphorism of Butler Lampson goes: "All problems in computer science can be solved by another level of indirection". Using [PLT trampolines](https://en.wikipedia.org/wiki/Trampoline_(computing)) to provide a BLAS and LAPACK demuxing library. Essentially, going forward, Julia is linked against LBT. LBT in turn will call a user configured BLAS and LAPACK library. By default, Julia will ship with OpenBLAS, which LBT will forward calls to - but with a simple configuration, any other BLAS or LAPACK library can be used.

In order to use `MKL` now, all a user has to do is `Pkg.add("MKL")` and `using MKL`, which will initialize LBT to forward all BLAS and LAPACK calls to MKL. This works on all the OSes where MKL is available (and yes the MKL package automatically installs the `MKL_jll` package containing the MKL binaries).

## Basic usage of LBT

We use a linux example. Build `libblastrampoline.so`, then link your BLAS-using library against it instead of `libblas.so`.
When `libblastrampoline` is loaded, it will inspect the `LBT_DEFAULT_LIBS` environment variable and attempt to forward BLAS calls made to it on to that library (this can be a list of semicolon-separated libraries if your backing implementation is split across multiple libraries, such as in the case of separate `BLAS` and `LAPACK` libraries).
At any time, you may call `lbt_forward(libname, clear, verbose)` to redirect forwarding to a new BLAS library.
If you set `clear` to `1` it will clear out all previous mappings before setting new mappings, while if it is set to `0` it will leave symbols that do not exist within the given `libname` alone.
This is used to implement layering of libraries, such as between a split BLAS and LAPACK library:
```
lbt_forward("libblas.so", 1, 0);
lbt_forward("liblapack.so", 0, 0);
```
