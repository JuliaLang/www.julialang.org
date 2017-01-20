# Theme: Numerical Linear Algebra

## Native Julia implementations of iterative solvers for numerical linear algebra

Iterative methods for solving numerical linear algebraic problems are crucial for big data applications, which often involve matrices that are too large to store in memory or even to compute its matrix elements explicitly. Iterative Krylov methods such as conjugate gradients (CG) and the generalized minimal residual (GMRES) methods have proven to be particular valuable for a wide variety of applications such as eigenvalue finding, convex optimization, and even systems control.
This project proposes to implement a comprehensive suite of iterative solver algorithms in Julia's native [IterativeSolvers.jl](https://github.com/JuliaLang/IterativeSolvers.jl) package, as described in the [implementation roadmap](https://github.com/JuliaLang/IterativeSolvers.jl/issues/1). Students will be encouraged to refactor the codebase to better expose the mathematical structure of the underlying Arnoldi and Lanczos iterations, thus promoting code composability without sacrificing performance.

## Native usage of LinearMaps in iterative solvers

While one normally thinks of solving the linear equation Ax=b with A being a matrix, this concept is more generally applied to A being a linear map. In many domains of science, this idea of directly using a linear map instead of a matrix allows for one to solve the equation in a more efficient manner. Iterative methods for linear solving only require the ability compute `A*x` in order solve the system, and thus these methods can be extended to use more general linear maps. By restructuring IterativeSolvers.jl to use `LinearMap` types from [LinearMaps.jl](https://github.com/Jutho/LinearMaps.jl), these applications can be directly supported in the library.

## PETSc integration for scalable technical computing

[PETSc](http://www.mcs.anl.gov/petsc) is a widely used framework of data structures and computational routines suitable for massively scaling scientific computations. Many of these algorithms are also ideally suited for big data applications such as computing principal components of very large sparse matrices and solving complicated forecasting models with distributed methods for solving partial differential equations.
This project proposal is to develop a new Julia package to interface with PETsc, thus allowing users access to state of the art scalable algorithms for optimization, eigenproblem solvers, finite element mesh computations, and hyperbolic partial differential equation solvers. The more mathematically oriented student may choose to study the performance of these various algorithms as compared to other libraries and naïve implementations. Alternatively, students may also be interested in working on the LLVM BlueGene port for deploying Julia with PetSc integration in an actual supercomputing environment.

**Expected Results:** New wrappers for PETSc functions in the [PETSc.jl](https://github.com/JuliaParallel/PETSc.jl) package.

## Native Julia implementations of massively parallel dense linear algebra routines

A large portion of big data analytics is predicated upon efficient linear algebraic operations on extremely large matrices. However, massively parallel linear algebra has traditionally focussed on supercomputer architectures, and comparatively little work has been done on efficient scaling on more heterogeneous architectures such as commodity clusters and cloud computing servers, where memory hierarchies and network topologies both introduce latency and bandwidth bottlenecks that differ significantly from those on supercomputers.

This project proposal is for implementing native Julia algorithms involving efficient, cache-conscious matrix operations on tiled matrices. Students will be expected to implement tiled algorithms and tune the performance of typical algorithms such as the singular value decomposition or linear solve.

## Native Julia implementations of massively parallel sparse linear algebra routines

Modern data-intensive computations, such as Google's PageRank algorithm, can often be cast as operations involving sparse matrices of extremely large nominal dimensions. Unlike dense matrices, which decompose naturally into many homogeneous tiles, efficient algorithms for working with sparse matrices must be fully cognizant of the sparsity pattern of specific matrices at hand, which oftentimes reduce to efficiently computing partitions of extremely large graphs.


This project proposal is for implementing native Julia algorithms for massively parallel sparse linear algebra routines. Unlike the project above for dense linear algebra, efficient parallel algorithms for sparse linear algebra are comparatively less well studied and understood. Students will be expected to implement several algorithms for common tasks such as linear solvers or computing eigenvectors, and benchmark the performance of these algrithms on various real world applications.
