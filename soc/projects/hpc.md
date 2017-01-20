# Scalability of technical computing for big data applications

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.

## Fixed-size arrays with SIMD support

Julia uses OpenBLAS for matrix algebra, but OpenBLAS is better suited for large matrices. For operations with small matrices and vectors, one can often obtain substantial speedups by implementing everything in Julia. At least two candidate implementations [already](https://github.com/twadleigh/ImmutableArrays.jl) [exist](https://github.com/JuliaLang/julia/issues/5857), with the first more thoroughly developed but the second (currently just a sketch) having some features that are attractive for inclusion in `Base`.

The project would be to flesh out operations with fixed-size arrays, and get them interoperating seamlessly with other types. It would be desirable implement operations for certain sizes using Julia's up-and-coming [SIMD support](https://github.com/JuliaLang/julia/pull/5355).

## Writing high-performance, multithreaded kernels for image processing

The [Images.jl](https://github.com/timholy/Images.jl) package implements several algorithms that do not use, but would be well-suited for, multi-threading. This project would implement multithreaded versions of `imfilter` and `imfilter_gaussian`. While such kernels might be written by hand, it is also attractive to explore various "frameworks" that reduce the amount of boilerplate code required. One recommended approach would be to explore using the [ParallelAccelerator.jl](https://github.com/IntelLabs/ParallelAccelerator.jl); alternatively, one might leverage the [KernelTools.jl](https://github.com/timholy/KernelTools.jl) package in conjunction with julia 0.5's native threading capabilities.

**Expected Results:** multithreaded implementation of `imfilter` and `imfilter_gaussian`.

## Parallel graph development

The [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) package provides a fast, robust set of graph analysis tools. This project would implement additions to LightGraphs to support parallel computation for a subset of graph algorithms. Examples of algorithms that would benefit from adaptation to parallelism would include centrality measures and traversals.

**Expected Results:** creation of LightGraphs-based data structures and algorithms that take advantage of large-scale parallel computing environments.


## Project: Ensure that Julia runs smoothly on current large HPC systems

Julia employs several techniques that are novel in the field of high performance computing, such as just-in-time compiling, or first-class support of an interactive environment, or dynamically adding/removing worker processes. This clashes with the traditional ahead-of-time compiled programes running in batch mode. However, the advantages of Julia's approach are clear. This project explores how "typical" Julia programs can be run efficiently on current large scale systems such as, e.g. [Blue Waters](https://bluewaters.ncsa.illinois.edu) or [Cori](http://www.nersc.gov/users/computational-systems/cori/).

**Expected Results:** Run a large, parallel Julia application on a high-end HPC system

**Knowledge Prerequisites:** High-performance computing, MPI
