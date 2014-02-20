---
layout: default
title:  Google Summer of Code
---

# Google Summer of Code 2014

Julia has applied to be a Google Summer of Code mentoring organization. The following are ideas for student summer projects. To add or edit projects, please edit this page [here](https://github.com/JuliaLang/julialang.github.com/blob/master/gsoc/2014/index.md) through GitHub by making pull requests.

You may be able to find further suitable project ideas through Julia's [`up for grabs` issues](https://github.com/JuliaLang/julia/issues?labels=up+for+grabs&state=open).

Don't be put off by the knowledge prerequisites; you don't need to be an expert, and there is some scope for research and learning within the GSoC period. However, familiarity with and interest in the involved technologies will be helpful.



# Theme: Scalability of technical computing for big data applications

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.



## Project: Standardized dataset packaging

Scientific and technical computing often makes use of publicly available datasets. Obtaining this data often involves digging through horrifically designed government websites. Julia has a robust package manager, so storing a datset on Github and making it available through the package manager can be a convenient means of distribution (see [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl)). At the same time, many datasets are too large to store reasonably in a git repository.

This project proposal is to develop a new Julia package that will implement a standard means to write data packages to make large external datasets accessible by downloading to a local machine. When a data package is installed, it will automatically download the dataset it wraps, validate it, e.g. with stored checksums, and make that data available as a `DataFrame` or other Julia structure. In addition to a standard structure, the `Pkg.generate` function should be extended to generate data packages.



## Project: PETSc integration for scalable technical computing

[PETSc](http://www.mcs.anl.gov/petsc) is a widely used framework of data structures and computational routines suitable for massively scaling scientific computations. Many of these algorithms are also ideally suited for big data applications such as computing principal components of very large sparse matrices and solving complicated forecasting models with distributed methods for solving partial differential equations.

This project proposal is to develop a new Julia package to interface with PETsc, thus allowing users access to state of the art scalable algorithms for optimization, eigenproblem solvers, finite element mesh computations, and hyperbolic partial differential equation solvers. The more mathematically oriented student may choose to study the performance of these various algorithms as compared to other libraries and naïve implementations. Alternatively, students may also be interested in working on the LLVM BlueGene port for deploying Julia with PetSc integration in an actual supercomputing environment.

**Expected Results:** Wrapper package for the PETSc suite of libraries.



## Project: Native Julia solvers for ordinary differential equations

Julia should have a full set of ODE solvers, as they are vital for numeric programming. This project should build on the work of [ODE.jl](https://github.com/JuliaLang/ODE.jl). The best way forward will probably be to implement the solvers in Julia. See [#75](https://github.com/JuliaLang/julia/issues/75).

**Expected Results**: A set of production-quality ODE solvers.



## Project: Native Julia implementations of iterative solvers for numerical linear algebra

Iterative methods for solving numerical linear algebraic problems are crucial for big data applications, which often involve matrices that are too large to store in memory or even to compute its matrix elements explicitly. Iterative Krylov methods such as conjugate gradients (CG) and the generalized minimal residual (GMRES) methods have proven to be particular valuable for a wide variety of applications such as eigenvalue finding, convex optimization, and even systems control.

This project proposes to implement a comprehensive suite of iterative solver algorithms in Julia's native [IterativeSolvers.jl](https://github.com/JuliaLang/IterativeSolvers.jl) package, as described in the [implementation roadmap](https://github.com/JuliaLang/IterativeSolvers.jl/issues/1). Students will be encouraged to refactor the codebase to better expose the mathematical structure of the underlying Arnoldi and Lanczos iterations, thus promoting code composability without sacrificing performance.



## Project: Matrix functions

Matrix functions maps matrices onto other matrices, and can often be interpreted as generalizations of ordinary functions like sine and exponential, which map numbers to numbers. Once considered a niche province of numerical algorithms, matrix functions now appear routinely in applications to cryptography, aircraft design, nonlinear dynamics, and finance.

This project proposes to implement state of the art algorithms that extend the currently available matrix functions in Julia, as outlined in issue [#5840](https://github.com/JuliaLang/julia/issues/5840). In addition to matrix generalizations of standard functions such as real matrix powers, surds and logarithms, students will be challenged to design generic interfaces for lifting general scalar-valued functions to their matrix analogues for the efficient computation of arbitrary (well-behaved) matrix functions and their derivatives.



## Project: Native Julia implementations of massively parallel dense linear algebra routines

A large portion of big data analytics is predicated upon efficient linear algebraic operations on extremely large matrices. However, massively parallel linear algebra has traditionally focussed on supercomputer architectures, and comparatively little work has been done on efficient scaling on more heterogeneous architectures such as commodity clusters and cloud computing servers, where memory hierarchies and network topologies both introduce latency and bandwidth bottlenecks that differ significant from those on supercomputers.

This project proposal is for implementing native Julia algorithms involving efficient, cache-conscious matrix operations on tiled matrices. Students will be expected to implement tiled algorithms and tune the performance of typical algorithms such as the singular value decomposition or linear solve.



## Project: Native Julia implementations of massively parallel sparse linear algebra routines

Modern data-intensive computations, such as Google's PageRank algorithm, can often be cast as operations involving sparse matrices of extremely large nominal dimensions. Unlike dense matrices, which decompose naturally into many homogeneous tiles, efficient algorithms for working with sparse matrices must be fully cognizant of the sparsity pattern of specific matrices at hand, which oftentimes reduce to efficiently computing partitions of extremely large graphs.

This project proposal is for implementing native Julia algorithms for massively parallel sparse linear algebra routines. Unlike the project above for dense linear algebra, efficient parallel algorithms for sparse linear algebra are comparatively less well studied and understood. Students will be expected to implement several algorithms for common tasks such as linear solvers or computing eigenvectors, and benchmark the performance of these algrithms on various real world applications.



## Project: Dynamic distributed execution for data parallel tasks in Julia

Distributed computation frameworks like Hadoop/MapReduce have demonstrated the usefulness of an abstraction layer that takes care of low level concurrency concerns such as atomicity and fine-grained synchronization, thus allowing users to concentrate on task-level decomposition of extremely large problems such as massively distributed text processing. However, the tree-based scatter/gather design of MapReduce limits its usefulness for general purpose data parallelism, and in particular poses significant restrictions on the implementation of iterative algorithms.

This project proposal is to implement a native Julia framework for distributed execution for general purpose data parallelism, using dynamic, runtime-generated general task graphs which are flexible enough to describe multiple classes of parallel algorithms. Students will be expected to weave together native Julia parallelism constructs such as the `ClusterManager` for massively parallel execution, and automate the handling of data dependencies using native Julia `RemoteRefs` as remote data futures and handles. Students will also be encouraged to experiment with novel scheduling algorithms.



## Project: Parallel random number generation

Large scale simulations can require large quantities of random numbers to study the effects of stochastic noise on the stability and robustness of simulated systems. However, massively parallel stochastic computations often require going beyond running many copies of serial algorithms for generating pseudorandom numbers, due to well-known synchronization effects which compromise the quality and uniformity of of random sampling. Instead, new algorithms are required for the scalable generation of pseudorandom numbers in parallel.

Students interested in this project will be expected to implement wrappers for parallel (pseudo)random number generators such as [SPRNG](http://www.sprng.org) or the [Random123](https://www.deshawresearch.com/resources_random123.html) entropy streams, as well as implement statistical quality tests such as the BigCrush tests from the [TestU01](http://www.iro.umontreal.ca/~simardr/testu01/tu01.html) suite.



## Project: Julia wrappers for high performance GPU programming

Graphical processing units (GPUs) are a promising alternate architecture for massively parallel technical computing. However, making use of them today requires using computation kernels written in C. In contrast, it is desirable to deploy code and transfer data to GPUs directly within a high level language like Julia.

Students will be asked to build upon to the foundational work in the [CUDA.jl](https://github.com/lindahua/CUDA.jl) and [OpenCL.jl](https://github.com/jakebolewski/OpenCL.jl) packages to provide a consistent interface for multiple scientific libraries containing GPU-deployable kernels, such as cuFFT, cuBlas, Magma, clBlas, clMagma, etc., or a common GPU array interface with Cuda and OpenCL backends (similar to python's [compyte](https://github.com/inducer/compyte) library).

**Expected Results:** Package for high-level GPU programming.

**Knowledge Prerequisites:** GPU programming, calling C from Julia, perhaps LLVM



## Project: Computer vision using OpenCV

[OpenCV](http://opencv.org/) is the de facto standard library for computer vision applications.  Currently wrappers auto generated from OpenCV's C++ API exist for Python, Java, and Matlab.  This project would be to adapt these Python based code generation tools to create a Julia interface to OpenCV.

**Expected Results:** OpenCV Package

**Knowledge Prerequisites:** OpenCV, Python, C++, templating, calling C from Julia.



# Theme: Improvements to base Julia functionality

## Project: LibGit2 support

Julia's package manager is currently very slow due to its need to shell out to git. This could be greatly improved by incorporating LibGit2 into Base, building on the work in LibGit2.jl.

**Expected Results:** A completion of the LibGit2 wrapper, along with necessary functionality being incorporated into Base and used by the package manager.

**Knowledge Prerequisites:** Interfacing with C from Julia, git.



## Project: ARM/Android support

Julia should ideally support platforms such as the Raspberry Pi and Android, but currently has some issues building for ARM via LLVM. This project consists of working towards building Julia on these platforms.

**Expected Results:** A successful build of Julia on ARM.

**Knowledge Prerequisites:** Understanding of the LLVM infrastructure and internals.



## Project: Better error reporting

Julia's errors are helpful for the most part but could be improved - see [#4744](https://github.com/JuliaLang/julia/issues/4744).

**Expected Results:** Consistent printing of errors with qualified type and human-readable string.



## Project: Documentation system

Julia does not yet have a standard way of documenting packages and making that documentation available in the REPL. Though a number of proposals have been made (see [1](https://github.com/JuliaLang/julia/issues/4579), [2](https://github.com/JuliaLang/julia/issues/5200), [3](https://github.com/JuliaLang/julia/issues/3988), [4](https://github.com/dcarrera/Doc.jl), [5](https://github.com/dcjones/Judo.jl), [6](https://github.com/johnmyleswhite/Roxygen.jl), [7](https://github.com/JuliaLang/JuliaDoc)), no complete solution has emerged. As a result, packages use different means of documentation, which can be hard to access in a systematic way.

A complete documentation system for Julia should be able to associate doc entries with Julia objects, make those entries accessible and searchable from the REPL, and generate static documentation from those entries. This project consists of synthesizing the work that has been done to implement a core documentation system for Julia.



## Project: Autoformat tool

This project involves creating an autoformat tool, similar to Go's `gofmt`, which automatically rewrites Julia source files into a standard format. This is a fairly experimental project - there are plenty of challanges involved with formatting such a dynamic and flexible language well. However, a well executed tool is likely to gain widespread adoption by the Julia community.

**Expected Results:** Autoformatting tool for Julia



# Theme: Improvements to Julia interactivity and interoperability with other applications

## Project: Enhanced clipboard

Julia's functions for getting and setting the clipboard are currently limited to text; it would be useful to extend them to allow the transfer of other data (for example, spreadsheet data or images).

**Expected Results:** Extensible `clipboard()` and `clipboard(x)` functions to get and set the richest possible representation of the system clipboard data, as well as methods for specific types.

**Knowledge Prerequisites:** Interfacing with C from Julia, clipboard APIs for different platforms.



## Project: Light Table integration

[Light Table](http://lighttable.com) has the potential to be a great IDE for Julia - one that supports both Julia's highly interactive approach and enables development of large projects and packages.

**Expected Results:** Full integration with Light Table's standard features (inline results and graphics, autocompletion, documentation etc.), along with the foundation for more advanced features (typeset equations, inline data entry, interactive visualisations etc.)

**Knowledge Prerequisites:** Understanding of Light Table's internals; experience using ClojureScript and Javascript.



## Project: IJulia interactive widgets

The IPython protocol recently added support for custom messages, allowing for output which interacts with the server. This is a fairly open-ended project with plenty of room for experimentation, but the end goal would be something along the lines of adding interactivity to (for example) [Gadfly](https://github.com/dcjones/Gadfly.jl) output in IJulia - for example, perhaps the ability to resize a plot and have it redrawn on-the-fly, or to plot an equation with sliders to vary parameters.

**Expected Results:** Interactive plotting capabilities within IJulia.

**Knowledge Prerequisites:** Javascript and IPython/IJulia internals.
