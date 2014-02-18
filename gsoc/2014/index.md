---
layout: default
title:  Google Summer of Code
---

# Google Summer of Code 2014

Julia has applied to be a Google Summer of Code mentoring organization. The following are ideas for student summer projects. To add or edit projects, please edit this page [here](https://github.com/JuliaLang/julialang.github.com/blob/master/gsoc/2014/index.md) through GitHub by making pull requests.

You may be able to find further suitable project ideas through Julia's [`up for grabs` issues](https://github.com/JuliaLang/julia/issues?labels=up+for+grabs&state=open).

Don't be put off by the knowledge prerequisites; you don't need to be an expert, and there is some scope for research and learning within the GSoC period. However, familiarity with and interest in the involved technologies will be helpful.



# Scalability for big data applications

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.



## Standardized dataset packaging

Scientific and technical computing often makes use of publicly available datasets. Obtaining this data often involves digging through horrifically designed government websites. Julia has a robust package manager, so storing a datset on Github and making it available through the package manager can be a convenient means of distribution (see [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl)). At the same time, many datasets are too large to store reasonably in a git repository.

This project proposal is to develop a new Julia package that will implement a standard means to write data packages to make large external datasets accessible by downloading to a local machine. When a data package is installed, it will automatically download the dataset it wraps, validate it, e.g. with stored checksums, and make that data available as a `DataFrame` or other Julia structure. In addition to a standard structure, the `Pkg.generate` function should be extended to generate data packages.



## PETSc integration for scalable technical computing

[PETSc](http://www.mcs.anl.gov/petsc) is a widely used framework of data structures and computational routines suitable for massively scaling scientific computations. Many of these algorithms are also ideally suited for big data applications such as computing principal components of very large sparse matrices and solving complicated forecasting models with distributed methods for solving partial differential equations.

This project proposal is to develop a new Julia package to interface with PETsc, thus allowing users access to state of the art scalable algorithms for optimization, eigenproblem solvers, finite element mesh computations, and hyperbolic partial differential equation solvers. The more mathematically oriented student may choose to study the performance of these various algorithms as compared to other libraries and naïve implementations. Alternatively, students may also be interested in working on the LLVM BlueGene port for deploying Julia with PetSc integration in an actual supercomputing environment.

**Expected Results:** Wrapper package for the PETSc suite of libraries.



## Native Julia solvers for ordinary differential equations

Julia should have a full set of ODE solvers, as they are vital for numeric programming. This project should build on the work of [ODE.jl](https://github.com/JuliaLang/ODE.jl). The best way forward will probably be to implement the solvers in Julia. See [#75](https://github.com/JuliaLang/julia/issues/75).

**Expected Results**: A set of production-quality ODE solvers.



## Native Julia implementations of iterative solvers for numerical linear algebra

Iterative methods for solving numerical linear algebraic problems are crucial for big data applications, which often involve matrices that are too large to store in memory or even to compute its matrix elements explicitly. Iterative Krylov methods such as conjugate gradients (CG) and the generalized minimal residual (GMRES) methods have proven to be particular valuable for a wide variety of applications such as eigenvalue finding, convex optimization, and even systems control.

This project proposes to implement a comprehensive suite of iterative solver algorithms in Julia's native [IterativeSolvers.jl](https://github.com/JuliaLang/IterativeSolvers.jl) package, as described in the [implementation roadmap](https://github.com/JuliaLang/IterativeSolvers.jl/issues/1). Students will be encouraged to refactor the codebase to better expose the mathematical structure of the underlying Arnoldi and Lanczos iterations, thus promoting code composability without sacrificing performance.



# Packages

## GPU programming

It would be useful to leverage GPUs in a natural way, directly from Julia and without writing kernels in C. The foundation for this has been laid in [CUDA.jl](https://github.com/lindahua/CUDA.jl) and [OpenCL.jl](https://github.com/jakebolewski/OpenCL.jl), but much more work is needed. Specific projects might include Julia wrappers for GPU scientific libraries (cuFFT, cuBlas, Magma, clBlas, clMagma, etc.), or a common GPU array interface with Cuda and OpenCL backends (similar to python's [compyte](https://github.com/inducer/compyte) library).

**Expected Results:** Package for high-level GPU programming.

**Knowledge Prerequisites:** GPU programming, calling C from Julia, perhaps LLVM



## OpenCV wrapper
[OpenCV](http://opencv.org/) is the de facto standard library for computer vision applications.  Currently wrappers auto generated from OpenCV's C++ API exist for Python, Java, and Matlab.  This project would be to adapt these Python based code generation tools to create a Julia interface to OpenCV.

**Expected Results:** OpenCV Package

**Knowledge Prerequisites:** OpenCV, Python, C++, templating, calling C from Julia.

# Base

## Enhanced clipboard

Julia's functions for getting and setting the clipboard are currently limited to text; it would be useful to extend them to allow the transfer of other data (for example, spreadsheet data or images).

**Expected Results:** Extensible `clipboard()` and `clipboard(x)` functions to get and set the richest possible representation of the system clipboard data, as well as methods for specific types.

**Knowledge Prerequisites:** Interfacing with C from Julia, clipboard APIs for different platforms.

## LibGit2 support

Julia's package manager is currently very slow due to its need to shell out to git. This could be greatly improved by incorporating LibGit2 into Base, building on the work in LibGit2.jl.

**Expected Results:** A completion of the LibGit2 wrapper, along with necessary functionality being incorporated into Base and used by the package manager.

**Knowledge Prerequisites:** Interfacing with C from Julia, git.



## ARM/Android support

Julia should ideally support platforms such as the Raspberry Pi and Android, but currently has some issues building for ARM via LLVM. This project consists of working towards building Julia on these platforms.

**Expected Results:** A successful build of Julia on ARM.

**Knowledge Prerequisites:** Understanding of the LLVM infrastructure and internals.



## Better error reporting

Julia's errors are helpful for the most part but could be improved - see [#4744](https://github.com/JuliaLang/julia/issues/4744).

**Expected Results:** Consistent printing of errors with qualified type and human-readable string.



# Tooling

## Documentation system

Julia does not yet have a standard way of documenting packages and making that documentation available in the REPL. Though a number of proposals have been made (see [1](https://github.com/JuliaLang/julia/issues/4579), [2](https://github.com/JuliaLang/julia/issues/5200), [3](https://github.com/JuliaLang/julia/issues/3988), [4](https://github.com/dcarrera/Doc.jl), [5](https://github.com/dcjones/Judo.jl), [6](https://github.com/johnmyleswhite/Roxygen.jl), [7](https://github.com/JuliaLang/JuliaDoc)), no complete solution has emerged. As a result, packages use different means of documentation, which can be hard to access in a systematic way.

A complete documentation system for Julia should be able to associate doc entries with Julia objects, make those entries accessible and searchable from the REPL, and generate static documentation from those entries. This project consists of synthesizing the work that has been done to implement a core documentation system for Julia.



## Autoformat tool

This project involves creating an autoformat tool, similar to Go's `gofmt`, which automatically rewrites Julia source files into a standard format. This is a fairly experimental project - there are plenty of challanges involved with formatting such a dynamic and flexible language well. However, a well executed tool is likely to gain widespread adoption by the Julia community.

**Expected Results:** Autoformatting tool for Julia



## Light Table Integration

[Light Table](http://lighttable.com) has the potential to be a great IDE for Julia - one that supports both Julia's highly interactive approach and enables development of large projects and packages.

**Expected Results:** Full integration with Light Table's standard features (inline results and graphics, autocompletion, documentation etc.), along with the foundation for more advanced features (typeset equations, inline data entry, interactive visualisations etc.)

**Knowledge Prerequisites:** Understanding of Light Table's internals; experience using ClojureScript and Javascript.



## IJulia interactive widgets

The IPython protocol recently added support for custom messages, allowing for output which interacts with the server. This is a fairly open-ended project with plenty of room for experimentation, but the end goal would be something along the lines of adding interactivity to (for example) [Gadfly](https://github.com/dcjones/Gadfly.jl) output in IJulia - for example, perhaps the ability to resize a plot and have it redrawn on-the-fly, or to plot an equation with sliders to vary parameters.

**Expected Results:** Interactive plotting capabilities within IJulia.

**Knowledge Prerequisites:** Javascript and IPython/IJulia internals.
