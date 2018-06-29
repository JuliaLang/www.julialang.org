---
layout: default
title:  Numerical Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

For all of these projects, potential mentors are [Steven Johnson](https://github.com/stevengj) and [Simon Byrne](https://github.com/simonbyrne).

# Numerical Linear Algebra

## Implementing eigenvalue problem solvers for sparse matrices

The [IterativeSolvers.jl](https://github.com/JuliaLang/IterativeSolvers.jl) package is lacking iterative methods for the (generalized) eigenvalue problem Ax = λBx. The goal of this project is to implement the Arnoldi or Lanczos method as a solver for the eigenvalue problem and to compare its performance with the `eigs` function.

For instance, the student can start by implementing the Arnoldi method for non-Hermitian eigenvalue problems Ax = λx. The method should then be improved with the implicit restart procedure (IRAM) and finally extended to the generalized eigenvalue problem Ax = λBx.

**Recommended Skills**: familiarity with numerical linear algebra.

**Expected Results**: a fast and native eigenvalue problem solver.

**Mentors:** [Harmen Stoppels](https://github.com/haampie/)

## Implementing iterative methods for linear systems of equations

High-dimensional linear systems of equations Ax = b need often to be solved by preconditioned iterative methods, simply because direct methods are too expensive. The [IterativeSolvers.jl](https://github.com/JuliaLang/IterativeSolvers.jl) package provides a variety of these iterative methods already, such as GMRES, BiCGStab and Conjugate Gradients. There are still methods to be implemented, including (variations of) QMR and Conjugate Residuals. Furthermore, the package itself can be improved by: solving the issue of the return types of solvers ([#6](https://github.com/JuliaMath/IterativeSolvers.jl/issues/6), [#185](https://github.com/JuliaMath/IterativeSolvers.jl/issues/185)) and allowing custom array types.

**Recommended Skills**: Strong linear algebra background. Familiarity with numerical linear algebra.

**Expected Results**: New iterative methods and an improved API of the IterativeSolvers.jl package.

**Mentors:** [Harmen Stoppels](https://github.com/haampie/)

## PETSc integration for scalable technical computing

[PETSc](http://www.mcs.anl.gov/petsc) is a widely used framework of data structures and computational routines suitable for massively scaling scientific computations. Many of these algorithms are also ideally suited for big data applications such as computing principal components of very large sparse matrices and solving complicated forecasting models with distributed methods for solving partial differential equations.
This project proposal is to develop a new Julia package to interface with PETsc, thus allowing users access to state of the art scalable algorithms for optimization, eigenproblem solvers, finite element mesh computations, and hyperbolic partial differential equation solvers. The more mathematically oriented student may choose to study the performance of these various algorithms as compared to other libraries and naïve implementations. Alternatively, students may also be interested in working on the LLVM BlueGene port for deploying Julia with PetSc integration in an actual supercomputing environment.

**Recommended Skills**: Some background knowledge in numerical linear algebra and parallel computing.

**Expected Results**: New wrappers for PETSc functions in the [PETSc.jl](https://github.com/JuliaParallel/PETSc.jl) package.


## Parallel dense linear algebra routines

A large portion of big data analytics is predicated upon efficient linear algebraic operations on extremely large matrices. However, massively parallel linear algebra has traditionally focussed on supercomputer architectures, and comparatively little work has been done on efficient scaling on more heterogeneous architectures such as commodity clusters and cloud computing servers, where memory hierarchies and network topologies both introduce latency and bandwidth bottlenecks that differ significantly from those on supercomputers.

This project proposal is for implementing native Julia algorithms involving efficient, cache-conscious matrix operations on tiled matrices. Students will be expected to implement tiled algorithms and tune the performance of typical algorithms such as the singular value decomposition or linear solve.

**Recommended Skills**: Strong linear algebra background. Familiarity with numerical linear algebra, and some background knowledge in parallel computing.

**Expected Results**: A native Julia package for parallel dense linear algebra methods.


**Mentors:** [Andreas Noack](https://github.com/andreasnoack)

## Parallel sparse linear algebra routines

Modern data-intensive computations, such as Google's PageRank algorithm, can often be cast as operations involving sparse matrices of extremely large nominal dimensions. Unlike dense matrices, which decompose naturally into many homogeneous tiles, efficient algorithms for working with sparse matrices must be fully cognizant of the sparsity pattern of specific matrices at hand, which oftentimes reduce to efficiently computing partitions of extremely large graphs.

This project proposal is for implementing native Julia algorithms for massively parallel sparse linear algebra routines. Unlike the project above for dense linear algebra, efficient parallel algorithms for sparse linear algebra are comparatively less well studied and understood. Students will be expected to implement several algorithms for common tasks such as linear solvers or computing eigenvectors, and benchmark the performance of these algrithms on various real world applications.

**Recommended Skills**: Strong linear algebra background. Familiarity with numerical linear algebra, especially sparse matrices, and some background knowledge in parallel computing.

**Expected Results**: A native Julia package for parallel sparse linear algebra methods.

**Mentors:** [Sacha Verweij](https://github.com/Sacha0)

# Base Mathematics Libraries

## Upgrading openlibm

[OpenLibm](http://openlibm.org) is a portable libm implementation used by Julia. It has fallen behind msun, from where it was forked a few years ago. This project seeks to update OpenLibm with all the latest bugfixes to msun. At the same time the [MUSL libm](http://git.musl-libc.org/cgit/musl/tree/src/math) implementation will be considered as an alternative to base openlibm on. A significant testsuite based on various existing [libm testsuites](http://nsz.repo.hu/libm/#tests) will be created.

**Recommended Skills**: A strong understanding of calculus.

**Expected Results**: New and faster methods for evaluating elementary mathematical functions. Benchmarks showing the performance differences for various implementations.

**Mentors:** [Simon Byrne](https://github.com/simonbyrne)

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

**Recommended Skills**: A strong understanding of calculus.

**Expected Results**: New and faster methods for evaluating properties of special functions.

**Mentors:** [Simon Byrne](https://github.com/simonbyrne)

## Matrix functions

Matrix functions maps matrices onto other matrices, and can often be interpreted as generalizations of ordinary functions like sine and exponential, which map numbers to numbers. Once considered a niche province of numerical algorithms, matrix functions now appear routinely in applications to cryptography, aircraft design, nonlinear dynamics, and finance.

This project proposes to implement state of the art algorithms that extend the currently available matrix functions in Julia, as outlined in issue [#5840](https://github.com/JuliaLang/julia/issues/5840). In addition to matrix generalizations of standard functions such as real matrix powers, surds and logarithms, students will be challenged to design generic interfaces for lifting general scalar-valued functions to their matrix analogues for the efficient computation of arbitrary (well-behaved) matrix functions and their derivatives.

**Recommended Skills**: A strong understanding of calculus and numerical analysis.

**Expected Results**: New and faster methods for evaluating matrix functions.

**Mentors:** [Jiahao Chen](https://github.com/jiahao)


# Interval arithmetic

## A standards-compliant interval arithmetic library

Interval arithmetic provides a way to perform computations with floating-point numbers that are guaranteed to be correct, by
wrapping each operand in an interval. [`ValidatedNumerics.jl`](https://github.com/dpsanders/ValidatedNumerics.jl) is a native Julia package providing interval functions that has a significant amount of functionality.

This project proposes to achieve compliance of this package with the [IEEE 1788-2015 Standard](https://standards.ieee.org/findstds/standard/1788-2015.html), which specifies how interval arithmetic packages should behave. This would make the package one of the first few packages to be fully compliant with the standard. It would involve adding some functions, writing documentation, improving the test suite, writing a compliance document, and overhauling and simplifying the code that already exists. The goal is to make this package a reference for interval arithmetic implementations.

**Recommended Skills**: Mathematical background; a basic understanding of floating-point arithmetic; an eye for detail and aesthetics; strong writing skills.

**Expected results**: A library that fulfills the IEEE 1788-2015 standard.

**Mentors:** [David P. Sanders](https://github.com/dpsanders)


## Guaranteed root finding with intervals

Interval arithmetic provides a way to perform computations with continuous sets of real  numbers or vectors, for example to bound the range of a function over a given set.

This can be used to find roots (zeros) of functions in a *guaranteed* way, by excluding regions where there are no roots and zooming in on roots, but always within a given interval.

A basic branch-and-prune algorithm has been implemented in  [`IntervalRootFinding.jl`](https://github.com/JuliaIntervals/IntervalRootFinding.jl).

This project proposes to significantly improve these methods using techniques found in the interval arithmetic literature.

**Recommended skills**: Multivariable calculus and linear algebra; a basic understanding of floating-point arithmetic.

**Expected results**: A state-of-the-art root finding library in pure Julia.

**Mentors:** [David P. Sanders](https://github.com/dpsanders), [Luis Benet](https://github.com/lbenet)


## Global optimization with intervals

Interval arithmetic provides a way to perform computations with continuous sets of real  numbers or vectors, for example to bound the range of a function over a given set.

This can be used to do global optimization of functions in a deterministic way, that is, find the global minimum of a non-convex, nonlinear function $f:\mathbb{R}^n \to \mathbb{R}$.
Interval methods for global optimization provide a guaranteed bound for the global optimum, and sets that contain the optimizers.

A basic branch-and-bound algorithm has already been implemented in  [`IntervalOptimization.jl`](https://github.com/JuliaIntervals/IntervalOptimization.jl), but it can be significantly improved.

This project proposes to develop a state-of-the-art global optimization routine in Julia, by applying techniques found in the interval arithmetic and global optimization literature.
This may involve developing code for McCormick relaxations and/or affine arithmetic.

**Recommended skills**: Multivariable calculus and linear algebra; a basic understanding of floating-point arithmetic.

**Expected results**: A state-of-the-art global optimization library in pure Julia.

**Mentors:** [David P. Sanders](https://github.com/dpsanders)


# Native Bignums

Julia currently supports big integers, rationals and floats, making use of the GMP and MPFR libraries. However, the current implementation is very basic, performance is far from optimal compared to hand-written GMP code, and the GMP license is GPL 3.

This project therefore involves exploring ways to improve bignums, possibly including:

* Reimplementation of BigInt in Julia
* Pooling bignum objects to avoid setup / teardown cost
* Exposing a mutating API for library consumers
* Lazy graph style APIs which can rewrite terms or apply optimisations

This experimentation could be carried out as a package with a new implementation, or as patches over the existing implementation in Base.

**Expected Results**: An implementation of BigNums in Julia with increased performance over the current one.

**Require Skills**: Familiarity with extended precision numerics and performance considerations. Familiarity either with Julia or GMP.

**Mentors**: [Jameson Nash](https://github.com/vtjnash), [Yichao Yu](https://github.com/yuyichao)
