---
layout: default
title:  Numerical Projects – Summer of Code
---

{% include toc.html %}

# Numerical Linear Algebra

## Native Julia implementations of iterative solvers for numerical linear algebra

Iterative methods for solving numerical linear algebraic problems are crucial for big data applications, which often involve matrices that are too large to store in memory or even to compute its matrix elements explicitly. Iterative Krylov methods such as conjugate gradients (CG) and the generalized minimal residual (GMRES) methods have proven to be particular valuable for a wide variety of applications such as eigenvalue finding, convex optimization, and even systems control.
This project proposes to implement a comprehensive suite of iterative solver algorithms in Julia's native [IterativeSolvers.jl](https://github.com/JuliaLang/IterativeSolvers.jl) package, as described in the [implementation roadmap](https://github.com/JuliaLang/IterativeSolvers.jl/issues/1). Students will be encouraged to refactor the codebase to better expose the mathematical structure of the underlying Arnoldi and Lanczos iterations, thus promoting code composability without sacrificing performance.

## Native usage of LinearMaps in iterative solvers

While one normally thinks of solving the linear equation Ax=b with A being a matrix, this concept is more generally applied to A being a linear map. In many domains of science, this idea of directly using a linear map instead of a matrix allows for one to solve the equation in a more efficient manner. Iterative methods for linear solving only require the ability compute `A*x` in order solve the system, and thus these methods can be extended to use more general linear maps. By restructuring IterativeSolvers.jl to use `LinearMap` types from [LinearMaps.jl](https://github.com/Jutho/LinearMaps.jl), these applications can be directly supported in the library.

## PETSc integration for scalable technical computing

[PETSc](http://www.mcs.anl.gov/petsc) is a widely used framework of data structures and computational routines suitable for massively scaling scientific computations. Many of these algorithms are also ideally suited for big data applications such as computing principal components of very large sparse matrices and solving complicated forecasting models with distributed methods for solving partial differential equations.
This project proposal is to develop a new Julia package to interface with PETsc, thus allowing users access to state of the art scalable algorithms for optimization, eigenproblem solvers, finite element mesh computations, and hyperbolic partial differential equation solvers. The more mathematically oriented student may choose to study the performance of these various algorithms as compared to other libraries and naïve implementations. Alternatively, students may also be interested in working on the LLVM BlueGene port for deploying Julia with PetSc integration in an actual supercomputing environment.

**Expected Results:** New wrappers for PETSc functions in the [PETSc.jl](https://github.com/JuliaParallel/PETSc.jl) package.

## Parallel dense linear algebra routines

A large portion of big data analytics is predicated upon efficient linear algebraic operations on extremely large matrices. However, massively parallel linear algebra has traditionally focussed on supercomputer architectures, and comparatively little work has been done on efficient scaling on more heterogeneous architectures such as commodity clusters and cloud computing servers, where memory hierarchies and network topologies both introduce latency and bandwidth bottlenecks that differ significantly from those on supercomputers.

This project proposal is for implementing native Julia algorithms involving efficient, cache-conscious matrix operations on tiled matrices. Students will be expected to implement tiled algorithms and tune the performance of typical algorithms such as the singular value decomposition or linear solve.

## Parallel sparse linear algebra routines

Modern data-intensive computations, such as Google's PageRank algorithm, can often be cast as operations involving sparse matrices of extremely large nominal dimensions. Unlike dense matrices, which decompose naturally into many homogeneous tiles, efficient algorithms for working with sparse matrices must be fully cognizant of the sparsity pattern of specific matrices at hand, which oftentimes reduce to efficiently computing partitions of extremely large graphs.

This project proposal is for implementing native Julia algorithms for massively parallel sparse linear algebra routines. Unlike the project above for dense linear algebra, efficient parallel algorithms for sparse linear algebra are comparatively less well studied and understood. Students will be expected to implement several algorithms for common tasks such as linear solvers or computing eigenvectors, and benchmark the performance of these algrithms on various real world applications.

# Base Mathematics Libraries

## Upgrading openlibm

[OpenLibm](http://openlibm.org) is a portable libm implementation used by Julia. It has fallen behind msun, from where it was forked a few years ago. This project seeks to update OpenLibm with all the latest bugfixes to msun. At the same time the [MUSL libm](http://git.musl-libc.org/cgit/musl/tree/src/math) implementation will be considered as an alternative to base openlibm on. A significant testsuite based on various existing [libm testsuites](http://nsz.repo.hu/libm/#tests) will be created.

## Special functions

As a technical computing language, Julia provides a huge number of
[special functions](https://en.wikipedia.org/wiki/Special_functions), both in Base as well
as packages such as [StatsFuns.jl](https://github.com/JuliaStats/StatsFuns.jl). At the
moment, many of these are implemented in external libraries such as
[Rmath](https://github.com/JuliaLang/Rmath-julia) and
[openspecfun](https://github.com/JuliaLang/openspecfun). This project would involve
implementing these functions in native Julia (possibly utilising the work in
[SpecialFunctions.jl](https://github.com/nolta/SpecialFunctions.jl)),
seeking out opportunties for possible improvements along the way, such as supporting
`Float32` and `BigFloat`, exploiting fused multiply-add operations, and improving errors
and boundary cases.

## Matrix functions

Matrix functions maps matrices onto other matrices, and can often be interpreted as generalizations of ordinary functions like sine and exponential, which map numbers to numbers. Once considered a niche province of numerical algorithms, matrix functions now appear routinely in applications to cryptography, aircraft design, nonlinear dynamics, and finance.

This project proposes to implement state of the art algorithms that extend the currently available matrix functions in Julia, as outlined in issue [#5840](https://github.com/JuliaLang/julia/issues/5840). In addition to matrix generalizations of standard functions such as real matrix powers, surds and logarithms, students will be challenged to design generic interfaces for lifting general scalar-valued functions to their matrix analogues for the efficient computation of arbitrary (well-behaved) matrix functions and their derivatives.

## Random number generation

[Monte Carlo methods](https://en.wikipedia.org/wiki/Monte_Carlo_method) are becoming increasingly important in large-scale numerical computations, requiring large quantities of random numbers.
To ensure accuracy of the simulated systems, it is critical that the [pseudorandom number generator](https://en.wikipedia.org/wiki/Pseudorandom_number_generator) is both fast and reliable, avoiding problems with periodicity and dependence, robust to statistical tests such as the [Crush suite](https://github.com/andreasnoack/RNGTest.jl).
Challenges are even greater in massively parallel computations, which require going beyond running many copies of serial algorithms for generating pseudorandom numbers, due to well-known synchronization effects which can compromise the quality and uniformity of of random sampling. A previous Google Summer of Code project created [RNG.jl](https://github.com/sunoru/RNG.jl), and there are more random number generating algorithms to explore.

Some possible aims of this project:

* High-quality Julia implementations of PRNG algorithms such as the [xorshift family](http://xorshift.di.unimi.it/), seeking possible low-level optimisations along the way.
* Efficient generation of non-uniform variates, across different floating point precisions.
* Massively parallel random number generators, such as [SPRNG](http://www.sprng.org) or the [Random123](https://www.deshawresearch.com/resources_random123.html) entropy streams, and integration with [ComputeFramework.jl](https://github.com/shashi/ComputeFramework.jl).
* Support for fast parallel random number generators on GPUs
