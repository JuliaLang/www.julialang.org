---
layout: default
title:  Summer of Code Ideas Page
redirect_from:
  - /jsoc.html
  - /gsoc/2015/index.html
  - /gsoc/2014/index.html
  - /soc/index.html
---

# GSoC Project Ideas Page

Thanks for your interest in Summer of Code! This page outlines some ideas for student projects. Most project ideas come with a suggested set of skills and experience which will be helpful, but they aren't hard requirements and there's scope for learning and exploring before, during, and after the official Summer of Code period. Please contact us at juliasoc@googlegroups.com with your questions.

We encourage you to send us a proposal through the [GSoC website](https://summerofcode.withgoogle.com); you're welcome to flesh out one of these projects with your own ideas, or to come up with something completely different. We also have some [application guidelines](/soc/guidelines) for more suggestions on writing a proposal.

You can [**edit this page**](https://github.com/JuliaLang/julialang.github.com/edit/master/soc/ideas-page.md) through GitHub if you want to add ideas of your own. For previous Summer of Code projects, see the [Archive page](/soc/archive.html).

## Moving Forward

Once you have an idea or area of interest, the best way to move forward is to get involved in relevant areas of the Julia ecosystem – look out for packages or organisations which are working on similar things, and see what features and issues they have. It's great to start by solving some small issues, and making real patches will show us your coding skills, your ability to learn, and your commitment.

If there's no directly relevant package, you could also start your own to begin prototyping your idea. It's not an absolute requirement, but a few lines of real code will really bolster an application.

Talking to others in the community is also a good way to get introduced to potential mentors. If you've spoken to someone who has agreed to mentor, let us know, but it's not a requirement for the application.

**Table of Contents**

Please also see the [Juno project page](https://github.com/JunoLab/atom-julia-client/blob/master/projects.md) for ideas related to Julia tooling.

{% include toc.html %}

---

# Theme: Scalability of technical computing for big data applications

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.

## Standardized dataset packaging

Scientific and technical computing often makes use of publicly available datasets. Obtaining this data often involves digging through horrifically designed government websites. Julia has a robust package manager, so storing a dataset on Github and making it available through the package manager can be a convenient means of distribution (see [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl)). At the same time, many datasets are too large to store reasonably in a git repository.

This project proposal is to develop a new Julia package that will implement a standard means to write data packages to make large external datasets accessible by downloading to a local machine. When a data package is installed, it will automatically download the dataset it wraps, validate it, e.g. with stored checksums, and make that data available as a `DataFrame` or other Julia structure. In addition to a standard structure, the `Pkg.generate` function should be extended to generate data packages.



## Simple persistent distributed storage

This project proposes to implement a very simple persistent storage mechanism for Julia variables so that data can be saved to and loaded from disk with a consistent interface that is agnostic of the underlying storage layer. Data will be tagged with a minimal amount of metadata by default to support type annotations, time-stamped versioning and other user-specifiable tags, not unlike the `git stash` mechanism for storing blobs. The underlying engine for persistent storage should be generic and interoperable with any reasonable choice of binary blob storage mechanism, e.g. MongoDB, ODBC, or HDFS. Of particular interest will be persistent storage for distributed objects such as `DArray`s, and making use of the underlying storage engine's mechanisms for data movement and redundant storage for such data.


## Native Julia library for constrained optimization

The beginnings of a native library for constrained optimization can be found in the [`teh/constrained` branch of Optim.jl](https://github.com/JuliaOpt/Optim.jl/pull/50). While there are other solutions for constrained optimization available (via JuMP), a native-Julia solution would have greater flexibility.  For example, one could abstract all the linear algebra operations, which might allow efficiencies that are not achievable using standard dense or sparse linear algebra. (For example, the Hessian might be a low-rank dense matrix, or a low-rank dense modification of a sparse matrix.)

Starting either from the `teh/constrained` branch or from scratch, the project would likely involve modification or (re)design of the API, implementation of additional algorithms (e.g., primal-dual interior point), and merging with master. It is also likely that this work will involve enhancements to the test suite; see [CUTEst.jl](https://github.com/JuliaOptimizers/CUTEst.jl) and [OptimizationProblems.jl](https://github.com/JuliaOptimizers/OptimizationProblems.jl) for likely sources of good example problems.

## Support for complex numbers within Convex.jl

**Convex.jl** is a package for [Disciplined Convex Programming](http://dcp.stanford.edu/). Convex.jl makes it easy to describe optimization problems in a natural, mathematical syntax, and to solve those problems using a variety of different (commercial and open-source) solvers, through the [MathProgBase](http://mathprogbasejl.readthedocs.org/en/latest/) interface.
This project would add support for solving complex semidefinite programs (SDP) to Convex.jl.

Many problems in applied mathematics, engineering, and physics are most
naturally posed as convex optimization problems over complex valued
variables and with complex valued data. These include

a) Phase retrieval from sparse measurements.
b) Optimization problems in AC power systems
c) Frequency domain analysis in signal processing and control theory

While optimization over complex numbers can always be encoded as
optimization over real variables through transformations, this often
results in significant overhead (both in user effort and computation
time) in many applications. Support for complex convex
optimization in Convex.jl would boost the usage of Julia
as a language of choice for users working on these and other
applications.

This work entails writing functions to transform complex SDPs into equivalent
real valued SDPs, and to transform the solutions back from real to complex
variables.

Students with further background and motivation could continue to improve
the SDP solver itself. In particular, the transformations used by Convex.jl
to write a problem as an SDP often introduce many extra variables and constraints
than are necessary, and may result in poor conditioning. A presolve routine,
eliminating redundant variables and constraints and improving conditioning before
passing the problem to a solver, would be a welcome addition to the Convex.jl library.
While many tricks for presolving LPs are well known, there is significant room for
imagination in writing a presolve for SDP; the project might well lead to a publication
were the student so inclined.

## PETSc integration for scalable technical computing

[PETSc](http://www.mcs.anl.gov/petsc) is a widely used framework of data structures and computational routines suitable for massively scaling scientific computations. Many of these algorithms are also ideally suited for big data applications such as computing principal components of very large sparse matrices and solving complicated forecasting models with distributed methods for solving partial differential equations.

This project proposal is to develop a new Julia package to interface with PETsc, thus allowing users access to state of the art scalable algorithms for optimization, eigenproblem solvers, finite element mesh computations, and hyperbolic partial differential equation solvers. The more mathematically oriented student may choose to study the performance of these various algorithms as compared to other libraries and naïve implementations. Alternatively, students may also be interested in working on the LLVM BlueGene port for deploying Julia with PetSc integration in an actual supercomputing environment.

**Expected Results:** New wrappers for PETSc functions in the [PETSc.jl](https://github.com/JuliaParallel/PETSc.jl) package.



## Native Julia solvers for ordinary differential equations

Julia needs to have a full set of ordinary differential equations (ODE) and algebraic differential equation (DAE) solvers, as they are vital for numeric programming. This project aims at extending the [ODE.jl](https://github.com/JuliaLang/ODE.jl) package in the following areas: specification and implementation of an API, both internal and user-facing; documentation; and adding new solvers.

The user-facing API should have both a high-level, easy-to-use interface and a low-level API giving access to all package features.  The design goal of the internal API is that adding new solvers is straightforward and that other solvers, such as [Sundials.jl](https://github.com/JuliaLang/Sundials.jl) or [DASSL.jl](https://github.com/pwl/DASSL.jl), can be easily hooked up to be used through ODE.jl.  The package needs a manual hosted on [Read the Docs](http://readthedocs.org/) and in-line code documentation.  More solvers need to be implemented, in particular implicit solvers (e.g. [PR #72](https://github.com/JuliaLang/ODE.jl/pull/72)).

**Expected Results**: A production-quality ODE/DAE solver package.



## Native Julia implementations of iterative solvers for numerical linear algebra

Iterative methods for solving numerical linear algebraic problems are crucial for big data applications, which often involve matrices that are too large to store in memory or even to compute its matrix elements explicitly. Iterative Krylov methods such as conjugate gradients (CG) and the generalized minimal residual (GMRES) methods have proven to be particular valuable for a wide variety of applications such as eigenvalue finding, convex optimization, and even systems control.

This project proposes to implement a comprehensive suite of iterative solver algorithms in Julia's native [IterativeSolvers.jl](https://github.com/JuliaLang/IterativeSolvers.jl) package, as described in the [implementation roadmap](https://github.com/JuliaLang/IterativeSolvers.jl/issues/1). Students will be encouraged to refactor the codebase to better expose the mathematical structure of the underlying Arnoldi and Lanczos iterations, thus promoting code composability without sacrificing performance.



## Fixed-size arrays with SIMD support

Julia uses OpenBLAS for matrix algebra, but OpenBLAS is better suited for large matrices. For operations with small matrices and vectors, one can often obtain substantial speedups by implementing everything in Julia. At least two candidate implementations [already](https://github.com/twadleigh/ImmutableArrays.jl) [exist](https://github.com/JuliaLang/julia/issues/5857), with the first more thoroughly developed but the second (currently just a sketch) having some features that are attractive for inclusion in `Base`.

The project would be to flesh out operations with fixed-size arrays, and get them interoperating seamlessly with other types. It would be desirable implement operations for certain sizes using Julia's up-and-coming [SIMD support](https://github.com/JuliaLang/julia/pull/5355).

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

## Fast bignums in Julia

Julia currently supports big integers, rationals and floats, making use of the GMP library. But the current implementation
is essentially only a prototype. There exists a very wide gap between the performance of GMP bignums from a C program and from Julia.

This performance gap is due to multiple things: bignums in C can be reused, saving on initialisation and cleaning up, Julia
bignum objects are garbage collected, handwritten C programs can allocate a minimal number of temporaries and C programs can also make use of the mutable properties of GMP bignum objects, saving making copies. Further advantages exist for C implementations that store small integers as immediate words, rather than use a full multiple precision structure.

There are many ways of potentially improving bignum performance in Julia. We could keep a cache of bignum objects around instead of allocating new ones all the time. We could inline operations involving single word operations and introduce a combined immediate word/mpz struct type for BigInts. Constant propagation could be done by introducing a type for numerical constant literals. Julia could wrap the low level mpn layer of GMP directly instead of the higher level mpz, mpq, mpf layers. A set of unsafe mutating operators for bignums could be introduced, for cases where the user knows they have control over the bignum and can safely mutate it. (Theoretically, term rewriting or lazy evaluation could also eliminate the need for creating a new bignum object for every subexpression, or even reduce the number of temporaries required for any given expression, in much the same way as the old C++ wrapper for GMP used template metaprogramming to speed things up. However, this is probably beyond the scope of a GSOC project.) The Julia Cxx package could even be used to inline calls to the GMP C++ wrapper whose semantics may be closer to the Julia semantics.

Not all of these options are either practical or agreeable. And it isn't clear which options are going to lead to the best performance or to the nicest Julia code. A balance would need to be struck to use what's actually available in Julia in a way that is performant but also flexible enough to support future developer needs. The absolutely fastest option may not be the best long term option and consultation on the Julia list will be important for this project. The project should implement prototypes of a number of options, and present a performance comparison to the Julia developers before settling on a final design.

## Native Julia implementations of massively parallel dense linear algebra routines

A large portion of big data analytics is predicated upon efficient linear algebraic operations on extremely large matrices. However, massively parallel linear algebra has traditionally focussed on supercomputer architectures, and comparatively little work has been done on efficient scaling on more heterogeneous architectures such as commodity clusters and cloud computing servers, where memory hierarchies and network topologies both introduce latency and bandwidth bottlenecks that differ significantly from those on supercomputers.

This project proposal is for implementing native Julia algorithms involving efficient, cache-conscious matrix operations on tiled matrices. Students will be expected to implement tiled algorithms and tune the performance of typical algorithms such as the singular value decomposition or linear solve.



## Native Julia implementations of massively parallel sparse linear algebra routines

Modern data-intensive computations, such as Google's PageRank algorithm, can often be cast as operations involving sparse matrices of extremely large nominal dimensions. Unlike dense matrices, which decompose naturally into many homogeneous tiles, efficient algorithms for working with sparse matrices must be fully cognizant of the sparsity pattern of specific matrices at hand, which oftentimes reduce to efficiently computing partitions of extremely large graphs.

This project proposal is for implementing native Julia algorithms for massively parallel sparse linear algebra routines. Unlike the project above for dense linear algebra, efficient parallel algorithms for sparse linear algebra are comparatively less well studied and understood. Students will be expected to implement several algorithms for common tasks such as linear solvers or computing eigenvectors, and benchmark the performance of these algrithms on various real world applications.



## Dynamic distributed execution for data parallel tasks in Julia

Distributed computation frameworks like Hadoop/MapReduce have demonstrated the usefulness of an abstraction layer that takes care of low level concurrency concerns such as atomicity and fine-grained synchronization, thus allowing users to concentrate on task-level decomposition of extremely large problems such as massively distributed text processing. However, the tree-based scatter/gather design of MapReduce limits its usefulness for general purpose data parallelism, and in particular poses significant restrictions on the implementation of iterative algorithms.

This project proposal is to implement a native Julia framework for distributed execution for general purpose data parallelism, using dynamic, runtime-generated general task graphs which are flexible enough to describe multiple classes of parallel algorithms. Students will be expected to weave together native Julia parallelism constructs such as the `ClusterManager` for massively parallel execution, and automate the handling of data dependencies using native Julia `RemoteRefs` as remote data futures and handles. Students will also be encouraged to experiment with novel scheduling algorithms.


## Random number generation

[Monte Carlo methods](https://en.wikipedia.org/wiki/Monte_Carlo_method) are becoming increasingly important in large-scale numerical computations, requiring large quantities of random numbers.
To ensure accuracy of the simulated systems, it is critical that the [pseudorandom number generator](https://en.wikipedia.org/wiki/Pseudorandom_number_generator) is both fast and reliable, avoiding problems with periodicity and dependence, robust to statistical tests such as the [Crush suite](https://github.com/andreasnoack/RNGTest.jl).
Challenges are even greater in massively parallel computations, which require going beyond running many copies of serial algorithms for generating pseudorandom numbers, due to well-known synchronization effects which can compromise the quality and uniformity of of random sampling.

Some possible aims of this project:

* High-quality Julia implementations of PRNG algorithms such as the [xorshift family](http://xorshift.di.unimi.it/), seeking possible low-level optimisations along the way.
* Efficient generation of non-uniform variates, across different floating point precisions.
* Massively parallel random number generators, such as [SPRNG](http://www.sprng.org) or the [Random123](https://www.deshawresearch.com/resources_random123.html) entropy streams, and integration with [ComputeFramework.jl](https://github.com/shashi/ComputeFramework.jl).


## Writing high-performance, multithreaded kernels for image processing

The [Images.jl](https://github.com/timholy/Images.jl) package implements several algorithms that do not use, but would be well-suited for, multi-threading. This project would implement multithreaded versions of `imfilter` and `imfilter_gaussian`. While such kernels might be written by hand, it is also attractive to explore various "frameworks" that reduce the amount of boilerplate code required. One recommended approach would be to explore using the [ParallelAccelerator.jl](https://github.com/IntelLabs/ParallelAccelerator.jl); alternatively, one might leverage the [KernelTools.jl](https://github.com/timholy/KernelTools.jl) package in conjunction with julia 0.5's native threading capabilities.

**Expected Results:** multithreaded implementation of `imfilter` and `imfilter_gaussian`.

# Juno & Tooling related ideas

## Documentation search & navigation

We'd like to make finding and viewing relevant documentation a core part of the Juno/Julia experience. As well as viewing docs for a particular function, it'd be great to take advantage of the extensive Markdown docs provided by packages for other purposes. For example, a basic doc search engine could allow users to find relevant functionality even when they don't know the names of the functions involved. (This could even be extended to searching across all packages!)

Initially this project could be built as a package or as an extension to the Atom.jl package. Eventually, we'd also like to integrate the functionality with a nice UI inside of Juno, and this could serve as extension work for an enterprising student.

## Package installation UI

Juno could provide a simple way to browse available packages and view what's installed on their system. To start with, this project could simply provide a GUI that reads in package data from `~/.julia`, including available packages and installed versions, and buttons which call the relevant `Pkg.*` methods.

This could also be extended by having metadata about the package, such as a readme, github stars, activity and so on. To support this we probably need a [pkg.julialang.org](http://pkg.julialang.org) style API which provides the info in JSON format.

## Swirl-style tutorial

The [swirl](http://swirlstats.com) tutorial teaches R users through an interactive REPL experience. Something similar in Julia could provide a tutorial that takes advantage of Juno's frontend integration, e.g. for getting input and displaying results. In particular, we'd expect this project to involve building a solid *framework* for building swirl-style tutorials, and allowing the Julia community to easily create new tutorials using Julia. Some research into how Swirl itself achieves this would be a good start.

## Julia Code Analysis

The foundation for tools like refactoring, linting or autoformatting is a powerful framework for reading and writing Julia code while preserving various features of the source code; comments, original formatting, and perhaps even syntax errors. This could build on the work in JuliaParser.jl.

Related would be various tools for doing static or dynamic analysis of Julia code in order to find errors. A simple example would be linting indentation; combined with information from the parser, this could be a powerful way to reduce beginner frustration over `unexpected )` style error messages.

## Performance Linting

Concepts relevant to Julia code's performance, like 'type-stability', are often implicit in written code, making it hard for new users in particular to catch slow code early on. However, this also represents a challenge for static analysis, since in general concrete type information won't be available until runtime.

A potential solution to this is to hook into function calls (users will most likely call a function with test inputs after writing it) and then use dynamically-available information, such as the output of `code_typed`, to find performance issues such as non-concrete types, use of global variables etc, and present these as lint warnings in the IDE.

While static analysis has long been used as a tool for understanding and finding problems in code, the use of dynamically available information is unexplored (with the exception of tracing JIT compilers, which demonstrate the power of the concept). This project has plenty of interesting extensions and could have the most interesting long-term implications.

## Support for ANSI codes in the console

The Ink console has some nice features, including being able to display graphics and HTML inline. However, it could be useful to integrate some more terminal-esc features like support for ANSI colour codes.

## Workspace saving and loading

RStudio provides the option to save loaded packages and variables on shutdown, and set up the environment as before when restarting. This could be replicated in Juno using some serialisation format for Julia data (e.g. the built-in serialiser or HDF5.jl).

## Something completely different!

If there's a piece of tooling you'd like to see for Julia, don't hesitate to suggest it to us!

## Better error reporting

Julia's errors are helpful for the most part but could be improved - see [#4744](https://github.com/JuliaLang/julia/issues/4744).

**Expected Results:** Consistent printing of errors with qualified type and human-readable strings.

## Autoformat tool

This project involves creating an autoformat tool, similar to Go's `gofmt`, which automatically rewrites Julia source files into a standard format. This is a fairly experimental project - there are plenty of challanges involved with formatting such a dynamic and flexible language well. However, a well executed tool is likely to gain widespread adoption by the Julia community.

**Expected Results:** Autoformatting tool for Julia

## C Linter

Memory errors in Julia's underlying C code are sometimes difficult to trace, and missing garbage-collector
"roots" (GC roots) can lead to segfaults and other problems. One potential way
to make it easier to find such errors would be to write a package that checks Julia's `src/` directory for
missing GC roots. A Julia-based solution might leverage the [Clang.jl](https://github.com/ihnorton/Clang.jl)
package to parse the C code, determine which call chains can trigger garbage collection, and then
look for objects that lack GC root protection. Alternatively, the same strategy might be implemented in C++ by writing a plugin for [Clang's static analyzer](http://clang-analyzer.llvm.org/). Another attractive approach is to leverage [coccinelle](http://coccinelle.lip6.fr/).

**Expected Results:** A tool that, when run against Julia's `src/` directory, highlights lines that
need to have additional GC roots added.

## Specialized call-site method caching

Julia's method cache is shared by all call sites of a generic function. Although whenever single dispatch is provable we generate a direct call, there are some cases where dynamic dispatch is inevitable. When the compiler can prove (using type inference) that the possible matches for a call site is small enough, it would be a huge performance win to generate a small cache specific to this call site. Those small caches would have to be updated when new method definitions are added (even replaced by the global cache when the number of matches becomes too large).

This project has a large number of possible extensions when the basic feature is done, including : using minimal caching keys (e.g. when only one of the arguments determine the dispatch entierly), generating specific dispatch code in a separate function, sharing the small caches between call sites, ...

It has also the future benefit of putting together the infrastructure we will need to enable inline method caching when automatic recompilation is done.

**Knowledge Prerequisites:** Good understanding of C/C++. A priori knowledge of Julia internals is a plus but this project could also be a very good way to familiarize oneself with those.

# Theme: Web stack / networking improvements

Julia's web and higher level networking framework is largely consolidated within the [JuliaWeb](https://github.com/JuliaLang) github organization.

## HTTP2 Implementation

Add HTTP2 support to [HttpServer.jl](https://github.com/JuliaWeb/HttpServer.jl) and [Requests.jl](https://github.com/JuliaWeb/Requests.jl).

**Knowledge Prerequisites:** basic familiarity with HTTP

## Middlewares for common web application chores in Mux.jl

Implementation of mid-level features - specifically routing, load-balancing, cookie/session handling, and authentication - in [Mux.jl](https://github.com/JuliaWeb/Mux.jl).  The implementation should be extensible enough to allow easy interfacing with different kinds of caching, databases or authentication backends. (See [Clojure/Ring](https://github.com/ring-clojure/ring/wiki/Why-Use-Ring%3F) for inspiration)

**Expected Results:** Some experience with web development.

# Theme: Improvements to Julia interactivity and interoperability with other applications

## Enhanced clipboard

Julia's functions for getting and setting the clipboard are currently limited to text; it would be useful to extend them to allow the transfer of other data (for example, spreadsheet data or images).

**Expected Results:** Extensible `clipboard()` and `clipboard(x)` functions to get and set the richest possible representation of the system clipboard data, as well as methods for specific types.

**Knowledge Prerequisites:** Interfacing with C from Julia, clipboard APIs for different platforms.

## Calling Julia from Python

Julia could be a great replacement for C in Python projects, where it can be used to speed up bottlenecks without sacrificing ease of use. However, while the basic functionality for calling Julia exists in [IJulia](https://github.com/JuliaLang/IJulia.jl) and [pyjulia](https://github.com/jakebolewski/pyjulia), it needs to be separated out and mantained as a real Python package.

**Expected Results:** An easy-to-use Python package which allows Julia functions to be imported and called, with transparent conversion of data.

**Knowledge Prerequisites:** Python (especially C interop).



## Project: Ensure that Julia runs smoothly on current large HPC systems

Julia employs several techniques that are novel in the field of high performance computing, such as just-in-time compiling, or first-class support of an interactive environment, or dynamically adding/removing worker processes. This clashes with the traditional ahead-of-time compiled programes running in batch mode. However, the advantages of Julia's approach are clear. This project explores how "typical" Julia programs can be run efficiently on current large scale systems such as, e.g. [Blue Waters](https://bluewaters.ncsa.illinois.edu) or [Cori](http://www.nersc.gov/users/computational-systems/cori/).

**Expected Results:** Run a large, parallel Julia application on a high-end HPC system

**Knowledge Prerequisites:** High-performance computing, MPI



# Theme: Julia Graphics and User Interfaces

## 2D Graphics Improvements
The [Winston](https://github.com/nolta/Winston.jl) package can be used for plotting 2D graphs and images. The package is already very useful but compared to the full featured Matplotlib python package there are still several things missing. This project can either go into the direction of improving the plotting itself (more graph types, more customization) or could go into the direction of increasing the interactivity of plotting windows (zooming, data picking ...) In the later case a close integration with Gtk.jl would be one way to go.

## Gtk.jl Improvements
The [Gtk.jl](https://github.com/JuliaLang/Gtk.jl) package is shaping up pretty well. Still there are various corners currently unimplemented and besides documentation it is very important to get installation of Gtk completely simple on all three major platforms. Furthermore, there is currently quite some manual tweaking necessary to get Gtk looking good on OSX. These installation issues are very crutial for serious integration of Gtk.jl into the Julia universe.

## QML bindings for Julia
QML is a markup language similar to JavaScript and used by th QT library to create graphical user interfaces.
QT Creator (open source IDE) provides a graphical editor to create QML forms. QML forms are cross-platform
and can be used on Linux, Mac, Windows, Android, OSX, IPhone etc. It would be great if they could also be used
by Julia in an easy way. Implementing these bindings should be not so difficult, because C bindings already
exist: [libqmlbind](https://github.com/seanchas116/libqmlbind).

The Ruby bindings could be used as starting point for implementing Julia bindings: [ruby-qml](https://github.com/seanchas116/ruby-qml).

Another possible starting point is [QML.jl](https://github.com/barche/QML.jl), where there is a direct interfacing with C++, eliminating the need for libqmlbind.

A possible mentor can be contacted on the julia-users mailing list.

## Improvements to the Plots.jl ecosystem

[Plots.jl](https://github.com/tbreloff/Plots.jl) has become the preferred graphical interface for many users.  It has the potential to become the standard Julia interface for data visualization, and there are many potential ways that a student could contribute:

- Expanding backend support.  Integration with real-time visualization platforms (GLVisualize).  Easy latex plotting for scientific research publications (PGFPlots).
- Adding recipes for statistics, machine learning (see [MLPlots.jl](https://github.com/JuliaML/MLPlots.jl)), or any other fields which you have an interest.
- Documentation and/or tutorials.
- Better integration with Graphs, DataStreams, etc
 
# Theme: Machine Learning Frameworks

## Expanding and improving LearnBase/JuliaML

[LearnBase](https://github.com/Evizero/LearnBase.jl) is an attempt to create a complete well-abstracted set of primitives and tools for machine learning frameworks.  The goal is to find the overlap between research perspectives and create smart abstractions for common components such as loss functions, transformations, activation functions, etc.  These abstractions can be the building blocks for more flexible learning frameworks, incorporating models (SVM, regression, decision trees, neural networks, etc) into a unified framework more powerful than alternatives (Scikit-learn, TensorFlow, etc).

A student could contribute to the core abstractions, or to dependent learning frameworks, depending on their knowledge and interests.  It is expected that the student has prior knowledge of machine learning techniques which they would like to work with.  In order to meaningfully contribute to the core abstractions, a broad knowledgebase would be expected.  Specific experience with random forests or deep/recurrent neural networks would be a plus.
