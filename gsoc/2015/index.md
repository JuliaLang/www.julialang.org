---
layout: default
title:  Google Summer of Code
---

# Google Summer of Code 2015 application process for students

Julia has applied as a Google Summer of Code mentoring organization. The following are ideas for student summer projects. To add or edit projects, please edit this page [here](https://github.com/JuliaLang/julialang.github.com/blob/master/gsoc/2015/index.md) through GitHub by making pull requests.
When considering the following projects, don't be put off by the knowledge prerequisites – you don't need to be an expert, and there is some scope for research and learning within the GSoC period. However, familiarity with and interest in the subject area and involved technologies will be helpful.

If you're interested in participating in GSoC as a student, the best approach is to become an active and engaged contributor to the project first. You should take a look at the ["up for grabs" issues](https://github.com/JuliaLang/julia/issues?state=open) on GitHub and see if there are any you think you might be able to take a crack at. Try submitting a pull request for something and start getting the hang of the process and interacting with the Julia code base and development community. Making changes to the main Julia repo can, of course, be a bit daunting. Fortunately, it's not a requirement for engagement – some of the most active contributors to the community build great packages but don't actually make a ton of changes to the language itself. We need both – people working on the language and people building great things with the language. So if you're looking to get involved but none of the up-for-grabs issues strike your fancy, try contributing to a popular package or [creating a new package](http://docs.julialang.org/en/latest/manual/packages/#package-development) that does something useful and/or interesting. If you create a new package, send an email to the [julia-users list](https://groups.google.com/forum/#!forum/julia-users) with a link to the repo so people can check it out and give you feedback.

Please also check out the [application guidelines](http://julialang.org/gsoc/guidelines) for information on writing a proposal.

# Theme: Scalability of technical computing for big data applications

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.

## Project: Standardized dataset packaging

Scientific and technical computing often makes use of publicly available datasets. Obtaining this data often involves digging through horrifically designed government websites. Julia has a robust package manager, so storing a datset on Github and making it available through the package manager can be a convenient means of distribution (see [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl)). At the same time, many datasets are too large to store reasonably in a git repository.

This project proposal is to develop a new Julia package that will implement a standard means to write data packages to make large external datasets accessible by downloading to a local machine. When a data package is installed, it will automatically download the dataset it wraps, validate it, e.g. with stored checksums, and make that data available as a `DataFrame` or other Julia structure. In addition to a standard structure, the `Pkg.generate` function should be extended to generate data packages.



## Project: Simple persistent distributed storage

This project proposes to implement a very simple persistent storage mechanism for Julia variables so that data can be saved to and loaded from disk with a consistent interface that is agnostic of the underlying storage layer. Data will be tagged with a minimal amount of metadata by default to support type annotations, time-stamped versioning and other user-specifiable tags, not unlike the `git stash` mechanism for storing blobs. The underlying engine for persistent storage should be generic and interoperable with any reasonable choice of binary blob storage mechanism, e.g. MongoDB, ODBC, or HDFS. Of particular interest will be persistent storage for distributed objects such as `DArray`s, and making use of the underlying storage engine's mechanisms for data movement and redundant storage for such data.



## Project: Provide access to CUTEst, the standard optimization test suite

Improvements in optimization (e.g., `Optim.jl`) require a diverse set of test problems.
The de-facto test suite for optimization is [CUTEst](http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki/),
a recent update of [CUTEr](http://www.cuter.rl.ac.uk/). This test suite is used in many papers on optimization.

This project proposal is to either (1) develop tools to parse the Standard Interface Format (SIF) and generate
Julia functions, or (2) wrap `SIFDecode` with a `ccall` interface. A convenient interface should be provided to
allow usage of any objective function in the test suite.

Update: a wrapper for CUTEst has [appeared](https://github.com/lpoo/CUTEst.jl); anyone wishing to extend this should contact the repository owner.


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

## Project: Fixed-size arrays with SIMD support

Julia uses OpenBLAS for matrix algebra, but OpenBLAS is better-suited for large matrices. For operations with small matrices and vectors, one can often obtain substantial speedups by implementing everything in Julia. At least two candidate implementations [already](https://github.com/twadleigh/ImmutableArrays.jl) [exist](https://github.com/JuliaLang/julia/issues/5857), with the first more thoroughly developed but the second (currently just a sketch) having some features that are attractive for inclusion in `Base`.

The project would be to flesh out operations with fixed-size arrays, and get them interoperating seamlessly with other types. It would be desirable implement operations for certain sizes using Julia's up-and-coming [SIMD support](https://github.com/JuliaLang/julia/pull/5355).


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

Students will be asked to build upon to the foundational work in the [OpenCL.jl](https://github.com/jakebolewski/OpenCL.jl), [CUDArt.jl](https://github.com/JuliaGPU/CUDArt.jl), and [CUDA.jl](https://github.com/maleadt/CUDA.jl) packages to provide a consistent interface for multiple scientific libraries containing GPU-deployable kernels, such as Magma, clBlas, clMagma, etc., or a common GPU array interface with Cuda and OpenCL backends (similar to python's [compyte](https://github.com/inducer/compyte) library).

**Expected Results:** Package for high-level GPU programming.

**Knowledge Prerequisites:** GPU programming, calling C from Julia, perhaps LLVM



## Project: Writing high-performance, multithreaded kernels

[KernelTools.jl](https://github.com/timholy/KernelTools.jl) is an early-stage package designed for writing cache-efficient, multithreaded algorithms. Its design is inspired by [Halide](http://halide-lang.org/). Many of the features of Halide are already in place, but multithreading is still lacking. The `threading` branch of julia might be of use in this project.

**Expected Results:** The ability to run `@tile`ed algorithms in multiple threads.

## Project: Translation of Axiom to Julia

[Axiom](http://en.wikipedia.org/wiki/Axiom_%28computer_algebra_system%29), a computer algebra system, is written in a language called SPAD. SPAD's similarity to Julia may make it feasible to port Axiom into pure Julia, providing Julia with a CAS and encouraging further work to improve Axiom. See also [this thread](https://groups.google.com/forum/#!topic/julia-dev/NTfS9fJuIcE).

**Expected Results:** A port of Axiom to Julia


# Theme: Improvements to base Julia functionality

## Project: LibGit2 support

Julia's package manager is currently very slow due to its need to shell out to git. This could be greatly improved by incorporating LibGit2 into Base, building on the work in LibGit2.jl.

**Expected Results:** A completion of the LibGit2 wrapper, along with necessary functionality being incorporated into Base and used by the package manager.

**Knowledge Prerequisites:** Interfacing with C from Julia, git.



## Project: ARM/Android support

Julia should ideally support platforms such as the Raspberry Pi and Android, but currently has some [issues building for ARM](https://github.com/JuliaLang/julia/issues?q=is%3Aopen+is%3Aissue+label%3Aarm) via LLVM. This project consists of working towards building Julia on these platforms.

**Expected Results:** A successful build of Julia on ARM.

**Knowledge Prerequisites:** Understanding of the LLVM infrastructure and internals.



## Project: Better error reporting

Julia's errors are helpful for the most part but could be improved - see [#4744](https://github.com/JuliaLang/julia/issues/4744).

**Expected Results:** Consistent printing of errors with qualified type and human-readable string.

## Project: Autoformat tool

This project involves creating an autoformat tool, similar to Go's `gofmt`, which automatically rewrites Julia source files into a standard format. This is a fairly experimental project - there are plenty of challanges involved with formatting such a dynamic and flexible language well. However, a well executed tool is likely to gain widespread adoption by the Julia community.

**Expected Results:** Autoformatting tool for Julia

## Project: Syntax Checker

Users new to programming often struggle with syntax - for example, knowing which brackets to use for function calls and arrays, or remembering to put quotes around strings - but aren't able to make sense of "unexpected X" style error messages, making for a frustrating experience. This project would involve providing the ability to identify mistakes in Julia code and provide suggestions for fixing the error. This could greatly improve the Julia experience for non-programmer users.

**Expected Results:** Functionality for parsing and analysing Julia code, and providing possible fixes for mistakes. Specifying the "signature" of a mistake (e.g. via a regex or predicate function) and its solution should be easy and flexible so that the package is easily extended.

## C Linter

Memory errors in Julia's underlying C code are sometimes difficult to trace, and missing garbage-collector
"roots" (GC roots) can lead to segfaults and other problems. One potential way
to make it easier to find such errors would be to write a package that checks Julia's `src/` directory for
missing GC roots. A Julia-based solution might leverage the [Clang.jl](https://github.com/ihnorton/Clang.jl)
package to parse the C code, determine which call chains can trigger garbage collection, and then
look for objects that lack GC root protection. Alternatively, the same strategy might be implemented in C++ by writing a plugin for [Clang's static analyzer](http://clang-analyzer.llvm.org/).

**Expected Results:** A tool that, when run against Julia's `src/` directory, highlights lines that
need to have additional GC roots added.

## Project: Base Julia Restructuring

Julia's Base code currently contains several dependencies which have various license restrictions and technically non-core code. Currently, there is no easy way to build or distribute Julia without these dependencies. Functionality has been recently added that allows non-Base packages to be included in the build step of Base Julia. This opens up the potential to move current non-core Base dependencies out to separate packages, but still be included by default in the Julia build process; hence, from a user's perspective, no change in available functionality is apparent, yet the result is a more "core" Julia Base and greater flexibility in creating custom Julia distributions (e.g. for embedded systems, running Julia in the browser, etc.). This project would involve ironing out details in the process of including packages in the build process (i.e translating complicated build steps from Base to BinDeps, figuring out if default packages should be located differently than regular packages, etc.), and starting to move dependencies out to separate packages one by one. See [this open issue](https://github.com/JuliaLang/julia/issues/1906#issuecomment-30619103) for more discussion and details.

**Expected Results:** The separation of at least a few non-core Base dependencies into their own packages while still being seemlessly integrated into the default Julia build process.

## Project: Web stack / networking improvements

Julia's web and higher-level networking framework is largely consolidated within the JuliaWeb github organization. The packages there are in need of updates, bug fixes, and general improvements in robustness by individuals who are well-versed in networking fundamentals and behavior of higher-level protocols. In some cases, the bugs can be traced back to issues with the underlying C frameworks that provide the primary functionality. Where possible and where security / auditability concerns are not an issue, native Julia code should be preferred over external libraries.

In addition, there are packages offering identical functionality. A rationalization and standardization of these packages as well as the underlying C frameworks is required to provide a consistent interface to applications wishing to communicate using standard network protocols.

**Expected Results:** An overhaul of Julia's networking framework, with the creation of robust, RFC-compliant, efficient, and standard interfaces for common protocols (e.g., HTTP, HTTPS, FTP, SMTP, SSH).

**Knowledge Prerequisites:** Network fundamentals including understanding of higher-level protocols, interfacing with C from Julia, git.


# Theme: Improvements to Julia interactivity and interoperability with other applications

## Project: Enhanced clipboard

Julia's functions for getting and setting the clipboard are currently limited to text; it would be useful to extend them to allow the transfer of other data (for example, spreadsheet data or images).

**Expected Results:** Extensible `clipboard()` and `clipboard(x)` functions to get and set the richest possible representation of the system clipboard data, as well as methods for specific types.

**Knowledge Prerequisites:** Interfacing with C from Julia, clipboard APIs for different platforms.

## Project: Julietta IDE
[Julietta](https://github.com/tknopp/Julietta.jl) is an integrated developement environement for Julia that is written entirely in Julia using the Gtk.jl package. While finishing an IDE is clearly out of scope for a GSoC project, there are some neat isolated tasks to do. Julietta already uses the Julia parser and indicates errors while typing in its editor. Three very interesting next steps are:

  1. Implement code completion. This is especially interesting to get right in such a dynamic language like Julia. Again while this has a very large scope it would already be very useful if typing `using` would give a list of installed packages.
  2. Switching between function usages and implementation (code tracing)
  3. Documentation integration. When right clicking on a function it should be possible to open the help text in an integrated help browser.

## Project: Calling Julia from Python

Julia could be a great replacement for C in Python projects, where it can be used to speed up bottlenecks without sacrificing ease of use. However, while the basic functionality for calling Julia exists in [IJulia](https://github.com/JuliaLang/IJulia.jl) and [pyjulia](https://github.com/jakebolewski/pyjulia), it needs to be separated out and mantained as a real Python package.

**Expected Results:** An easy-to-use Python package which allows Julia functions to be imported and called, with transparent conversion of data.

**Knowledge Prerequisites:** Python (especially C interop).

# Theme: Julia Graphics and User Interfaces

## Project: 2D Graphics Improvements
The [Winston](https://github.com/nolta/Winston.jl) package can be used for plotting 2D graphs and images. The package is already very useful but compared to the full featured Matplotlib python package there are still several things missing. This project can either go into the direction of improving the plotting itself (more graph types, more customization) or could go into the direction of increasing the interactivity of plotting windows (zooming, data picking ...) In the later case a close integration with Gtk.jl would be one way to go.

## Gtk.jl Improvements
The [Gtk.jl](https://github.com/JuliaLang/Gtk.jl) package is shaping up pretty well. Still there are various corners currently unimplemented and besides documentation it is very important to get installation of Gtk completely simple on all three major platforms. Furthermore, there is currently quite some manual tweaking necessary to get Gtk looking good on OSX. These installation issues are very crutial for serious integration of Gtk.jl into the Julia universe.


