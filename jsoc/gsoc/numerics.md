@def mintoclevel = 2

# Numerical Projects – Summer of Code

\toc

## Numerical Linear Algebra

### Efficient Sparse linear algebra routines

Modern data-intensive computations, such as Google's PageRank algorithm, can often be cast as operations involving sparse matrices of extremely large nominal dimensions. Unlike dense matrices, which decompose naturally into many homogeneous tiles, efficient algorithms for working with sparse matrices must be fully cognizant of the sparsity pattern of specific matrices at hand, which oftentimes reduce to efficiently computing partitions of extremely large graphs.

This project proposal is for implementing efficient native Julia algorithms for sparse linear algebra routines.
Students will be expected to

* implement several algorithms for common tasks such as factorizing square and rectangular matrices, computing eigenvalues and eigenvectors, or computing singular values and singular vectors;
* evaluate how to take advantage of Julia's threading facilities and multi-core computing so as to further improve computational performance;
* benchmark the performance of those algorithms on various real world applications.

Native Julia algorithms will be generic and support different numeric types, as in the *Generic linear algebra* project below.

**Recommended Skills**: Strong linear algebra background. Familiarity with numerical linear algebra, especially sparse matrices, and some background knowledge in parallel computing.

**Expected Results**: A native Julia package for parallel sparse linear algebra methods.

**Mentors**: [Dominique Orban](https://dpo.github.io)

### Matrix functions

Matrix functions map matrices onto other matrices, and can often be interpreted as generalizations of ordinary functions like sine and exponential, which map numbers to numbers. Once considered a niche province of numerical algorithms, matrix functions now appear routinely in applications to cryptography, aircraft design, nonlinear dynamics, and finance.

This project proposes to implement state of the art algorithms that extend the currently available matrix functions in Julia, as outlined in issue [#5840](https://github.com/JuliaLang/julia/issues/5840). In addition to matrix generalizations of standard functions such as real matrix powers, surds and logarithms, students will be challenged to design generic interfaces for lifting general scalar-valued functions to their matrix analogues for the efficient computation of arbitrary (well-behaved) matrix functions and their derivatives.

**Recommended Skills**: A strong understanding of calculus and numerical analysis.

**Expected Results**: New and faster methods for evaluating matrix functions.

**Mentors:** [Jiahao Chen](https://github.com/jiahao), [Steven Johnson](https://github.com/stevengj).

## Interval arithmetic

### A standards-compliant interval arithmetic library

Interval arithmetic provides a way to perform computations with floating-point numbers that are guaranteed to be correct, by
wrapping each operand in an interval. [`ValidatedNumerics.jl`](https://github.com/dpsanders/ValidatedNumerics.jl) is a native Julia package providing interval functions that has a significant amount of functionality.

This project proposes to achieve compliance of this package with the [IEEE 1788-2015 Standard](https://standards.ieee.org/findstds/standard/1788-2015.html), which specifies how interval arithmetic packages should behave. This would make the package one of the first few packages to be fully compliant with the standard. It would involve adding some functions, writing documentation, improving the test suite, writing a compliance document, and overhauling and simplifying the code that already exists. The goal is to make this package a reference for interval arithmetic implementations.

**Recommended Skills**: Mathematical background; a basic understanding of floating-point arithmetic; an eye for detail and aesthetics; strong writing skills.

**Expected results**: A library that fulfills the IEEE 1788-2015 standard.

**Mentors:** [David P. Sanders](https://github.com/dpsanders)


### Guaranteed root finding with intervals

Interval arithmetic provides a way to perform computations with continuous sets of real  numbers or vectors, for example to bound the range of a function over a given set.

This can be used to find roots (zeros) of functions in a *guaranteed* way, by excluding regions where there are no roots and zooming in on roots, but always within a given interval.

A basic branch-and-prune algorithm has been implemented in  [`IntervalRootFinding.jl`](https://github.com/JuliaIntervals/IntervalRootFinding.jl).

This project proposes to significantly improve these methods using techniques found in the interval arithmetic literature.

**Recommended skills**: Multivariable calculus and linear algebra; a basic understanding of floating-point arithmetic.

**Expected results**: A state-of-the-art root finding library in pure Julia.

**Mentors:** [David P. Sanders](https://github.com/dpsanders), [Luis Benet](https://github.com/lbenet)


### Global optimization with intervals

Interval arithmetic provides a way to perform computations with continuous sets of real  numbers or vectors, for example to bound the range of a function over a given set.

This can be used to do global optimization of functions in a deterministic way, that is, find the global minimum of a non-convex, nonlinear function $f:\mathbb{R}^n \to \mathbb{R}$.
Interval methods for global optimization provide a guaranteed bound for the global optimum, and sets that contain the optimizers.

A basic branch-and-bound algorithm has already been implemented in  [`IntervalOptimisation.jl`](https://github.com/JuliaIntervals/IntervalOptimisation.jl), but it can be significantly improved.

This project proposes to develop a state-of-the-art global optimization routine in Julia, by applying techniques found in the interval arithmetic and global optimization literature.
This may involve developing code for McCormick relaxations and/or affine arithmetic.

**Recommended skills**: Multivariable calculus and linear algebra; a basic understanding of floating-point arithmetic.

**Expected results**: A state-of-the-art global optimization library in pure Julia.

**Mentors:** [David P. Sanders](https://github.com/dpsanders)


### Taylor models and a guaranteed ODE solver

By combining interval arithmetic and Taylor series, we get **Taylor models**, which are guaranteed (rigorous) approximations of functions.
Using these, it is possible to
write a Taylor integrator for ordinary differential equations (ODEs) that gives guaranteed results, i.e. we get a "tube" that is guaranteed to contain the true solution of the ODE.

Some groundwork for this has been laid in the `TaylorModels.jl` package.
 The project will require reading papers on the subject and experimenting with different implementations for performance, for example using different polynomial representations.


**Recommended skills**: Multivariable calculus and linear algebra; understanding of floating-point arithmetic; ability to read papers and implement generic algorithms which allow to swap different libraries in and out.

**Expected results**: A state-of-the-art library for Taylor models.

**Mentors:** [David P. Sanders](https://github.com/dpsanders), [Luis Benet](https://github.com/lbenet), [Marcelo Forets](https://github.com/mforets)


## Better Bignums Integration

Julia currently supports big integers and rationals, making use of the GMP. However, GMP currently doesn't permit good integration with a garbage collector.

This project therefore involves exploring ways to improve BigInt, possibly including:

@@tight-list
* Modifying GMP to support high-performance garbage-collection
* Reimplementation of aspects of BigInt in Julia
* Lazy graph style APIs which can rewrite terms or apply optimisations
@@

This experimentation could be carried out as a package with a new implementation, or as patches over the existing implementation in Base.

**Expected Results**: An implementation of BigInt in Julia with increased performance over the current one.

**Require Skills**: Familiarity with extended precision numerics OR performance considerations. Familiarity either with Julia or GMP.

**Mentors**: [Jameson Nash](https://github.com/vtjnash)

### PETSc integration for scalable technical computing

[PETSc](https://www.mcs.anl.gov/petsc) is a widely used framework of data structures and computational routines suitable for massively scaling scientific computations. Many of these algorithms are also ideally suited for big data applications such as computing principal components of very large sparse matrices and solving complicated forecasting models with distributed methods for solving partial differential equations.
This project proposal is to develop a new Julia package to interface with PETsc, thus allowing users access to state of the art scalable algorithms for optimization, eigenproblem solvers, finite element mesh computations, and hyperbolic partial differential equation solvers. The more mathematically oriented student may choose to study the performance of these various algorithms as compared to other libraries and naïve implementations. Alternatively, students may also be interested in working on the LLVM BlueGene port for deploying Julia with PetSc integration in an actual supercomputing environment.

**Recommended Skills**: Some background knowledge in numerical linear algebra and parallel computing.

**Expected Results**: New wrappers for PETSc functions in the [PETSc.jl](https://github.com/JuliaParallel/PETSc.jl) package.

**Mentors:** **Mentors:** Ask on Discourse or the linear-algebra channel on slack

### Parallel dense linear algebra routines

A large portion of big data analytics is predicated upon efficient linear algebraic operations on extremely large matrices. However, massively parallel linear algebra has traditionally focussed on supercomputer architectures, and comparatively little work has been done on efficient scaling on more heterogeneous architectures such as commodity clusters and cloud computing servers, where memory hierarchies and network topologies both introduce latency and bandwidth bottlenecks that differ significantly from those on supercomputers.

This project proposal is for implementing native Julia algorithms involving efficient, cache-conscious matrix operations on tiled matrices. Students will be expected to implement tiled algorithms and tune the performance of typical algorithms such as the singular value decomposition or linear solve.

**Recommended Skills**: Strong linear algebra background. Familiarity with numerical linear algebra, and some background knowledge in parallel computing.

**Expected Results**: A native Julia package for parallel dense linear algebra methods.

**Mentors:** Ask on Discourse or the linear-algebra channel on slack

### Parallel sparse linear algebra routines

Modern data-intensive computations, such as Google's PageRank algorithm, can often be cast as operations involving sparse matrices of extremely large nominal dimensions. Unlike dense matrices, which decompose naturally into many homogeneous tiles, efficient algorithms for working with sparse matrices must be fully cognizant of the sparsity pattern of specific matrices at hand, which oftentimes reduce to efficiently computing partitions of extremely large graphs.

This project proposal is for implementing native Julia algorithms for massively parallel sparse linear algebra routines. Unlike the project above for dense linear algebra, efficient parallel algorithms for sparse linear algebra are comparatively less well studied and understood. Students will be expected to implement several algorithms for common tasks such as linear solvers or computing eigenvectors, and benchmark the performance of these algorithms on various real world applications.

**Recommended Skills**: Strong linear algebra background. Familiarity with numerical linear algebra, especially sparse matrices, and some background knowledge in parallel computing.

**Expected Results**: A native Julia package for parallel sparse linear algebra methods.

**Mentors:** **Mentors:** Ask on Discourse or the linear-algebra channel on slack

### Generic linear algebra

Julia supports many different numeric types, both in Base (e.g. `Float32`, `Float64`, `BigFloat`, `Complex`, `Rational`), as well as other packages (e.g. [Quaternions.jl](https://github.com/JuliaGeometry/Quaternions.jl), [ArbFloats.jl](https://github.com/JuliaArbTypes/ArbFloats.jl), [FixedPointNumbers.jl](https://github.com/JuliaMath/FixedPointNumbers.jl), [Unitful.jl](https://github.com/ajkeller34/Unitful.jl)).

Currently there exists some limited support for generic linear algebra in the LinearAlgebra stdlib (e.g. matrix multiplication and LU factorizations), as well as more experimental code in [GenericLinearAlgebra.jl](https://github.com/JuliaLinearAlgebra/GenericLinearAlgebra.jl) and [GenericSVD.jl](https://github.com/JuliaLinearAlgebra/GenericSVD.jl) packages.

The focus of this project will be to improve this functionality. Potential tasks include:

@@tight-list
- Implementing more operations, based on standard algorithms in books like [Golub and Van Loan](https://jhupbooks.press.jhu.edu/content/matrix-computations-0), or translating similar concepts from LAPACK.
- General code maintenance: improving generality, reducing duplicate code, clarifying and documenting interfaces.
- Developing accurate test cases, e.g. by deriving appropriate error bounds.
- Documenting the necessary interfaces required by numeric types for these to work correctly.
@@

**Recommended Skills**: An understanding of linear algebra and basic numerical analysis.

**Expected results**: Linear algebra routines which work on different numeric types, and corresponding tests.

**Mentors:** Ask on Discourse or the linear-algebra channel on slack

### Special functions

As a technical computing language, Julia provides a huge number of
[special functions](https://en.wikipedia.org/wiki/Special_functions), both in Base as well
as packages such as [StatsFuns.jl](https://github.com/JuliaStats/StatsFuns.jl). At the
moment, many of these are implemented in external libraries such as
[Rmath](https://github.com/JuliaLang/Rmath-julia) and
[openspecfun](https://github.com/JuliaLang/openspecfun). This project would involve
implementing these functions in native Julia (possibly utilising the work in
[SpecialFunctions.jl](https://github.com/nolta/SpecialFunctions.jl)),
seeking out opportunities for possible improvements along the way, such as supporting
`Float32` and `BigFloat`, exploiting fused multiply-add operations, and improving errors
and boundary cases.

**Recommended Skills**: A strong understanding of calculus.

**Expected Results**: New and faster methods for evaluating properties of special functions.

**Mentors:** [Steven Johnson](https://github.com/stevengj). Ask on Discourse or on slack

### A Julia-native CCSA optimization algorithm

The CCSA algorithm by [Svanberg (2001)](https://epubs.siam.org/doi/10.1137/S1052623499362822) is a [nonlinear programming algorithm](https://en.wikipedia.org/wiki/Nonlinear_programming) widely used in [topology optimization](https://en.wikipedia.org/wiki/Topology_optimization) and for other large-scale optimization problems: it is a robust algorithm that can handle arbitrary nonlinear inequality constraints and huge numbers of degrees of freedom.  Moreover, the relative simplicity of the algorithm makes it possible to easily incorporate sparsity in the Jacobian matrix (for handling huge numbers of constraints), approximate-Hessian preconditioners, and as special-case optimizations for affine terms in the objective or constraints.  However, currently it is only available in Julia via the [NLopt.jl](https://github.com/JuliaOpt/NLopt.jl) interface to an external C implementation, which greatly limits its flexibility.

**Recommended Skills**: Experience with nonlinear optimization algorithms and understanding of [Lagrange duality](https://en.wikipedia.org/wiki/Duality_(optimization)), familiarity with sparse matrices and other Julia data structures.

**Expected Results**: A package implementing a native-Julia CCSA algorithm.

**Mentors:** [Steven Johnson](https://github.com/stevengj).

