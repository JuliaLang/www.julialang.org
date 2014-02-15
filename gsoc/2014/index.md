---
layout: default
title:  Google Summer of Code
---

# Google Summer of Code 2014

Julia has applied to be a Google Summer of Code mentoring organization. The following are ideas for student summer projects. To add or edit projects, please edit this page [here](https://github.com/JuliaLang/julialang.github.com/blob/master/gsoc/2014/index.md) through GitHub by making pull requests.

You may be able to find further suitable project ideas through Julia's [`up for grabs` issues](https://github.com/JuliaLang/julia/issues?labels=up+for+grabs&state=open).

# Packages

## Data Packages

Scientific and technical computing often makes use of publicly available datasets. Obtaining this data often involves digging through horrifically designed government websites. Julia has a robust package manager, so storing a datset on github and making it available through the package manager can be a convenient distribution means (see [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl)). Yet, datasets are often too large to be stored reasonably git repository.

This project will consist of devising a standard means to write data packages to make large external datasets accessible. When a data package is installed, it will automatically download the dataset it wraps, validate it versus as stored checksum, and make that data available as a DataFrame or other Julia structure. In addition to a standard structure, the `Pkg.generate` function should be extended to generate data packages.

## ODE Solvers

Julia should have a full set of ODE solvers, as they are vital for numeric programming. This project should build on the work of [ODE.jl](https://github.com/JuliaLang/ODE.jl). The best way forward will probably be to implement the solvers in Julia. See [#75](https://github.com/JuliaLang/julia/issues/75).

**Expected Results**: A set of production-quality ODE solvers.

**Estimated Difficulty:** Hard

## PETSc Solvers

[PETSc](http://www.mcs.anl.gov/petsc/index.html) provides data structures and routines for working with PDEs and sparse matrix - it could be extremely useful integrated with Julia.

**Expected Results:** Wrapper library for PETSc.

**Estimated Difficulty:** Medium

## GPU Programming

It would be useful to leverage GPUs in a natural way, directly from Julia and without relying on CUDA C code. The foundation for this is in [CUDA.jl](https://github.com/lindahua/CUDA.jl), but much more work is needed.

**Expected Results:** Package for high-level GPU programming.

**Knowledge Prerequisites:** GPU programming

**Estimated Difficulty:** Hard

# Base

## Enhanced Clipboard

Julia's functions for getting and setting the clipboard are currently limited to text; it would be useful to extend them to allow the transfer of other data (for example, spreadsheet data or images).

**Expected Results:** Extensible `clipboard()` and `clipboard(x)` functions to get and set the richest possible representation of the system clipboard data, as well as methods for specific types.

**Knowledge Prerequisites:** Interfacing with C from Julia, clipboard APIs for different platforms.

**Estimated Difficulty:** Medium

## LibGit2 Support

Julia's package manager is currently very slow due to it's need to shell out to git. This could be greatly improved by incorporating LibGit2 into Base, building on the work in LibGit2.jl.

**Expected Results:** A completion of the LibGit2 wrapper, along with necessary functionality being incorporated into Base and used by the package manager.

**Knowledge Prerequisites:** Interfacing with C from Julia, git.

**Estimated Difficulty:** Medium

## ARM/Android Support

Julia should ideally support platforms such as the Raspberry Pi and Android, but currently has some issues building for ARM via LLVM. This project consists of working towards building Julia on these platforms.

**Expected Results:** A successful build of Julia on ARM.

**Knowledge Prerequisites:** Understanding of the LLVM infrastructure and internals.

**Estimated Difficulty:** Hard

## Better error reporting

Julia's errors are helpful for the most part but could be improved - see [#4744](https://github.com/JuliaLang/julia/issues/4744).

**Expected Results:** Consistent printing of errors with qualified type and human-readable string.

**Estimated Difficulty:** Easy

# Tooling

## Documentation System

Julia does not yet have a standard way of documenting packages and making that documentation available in the REPL. Though a number of proposoals have been made (see [1](https://github.com/JuliaLang/julia/issues/4579), [2](https://github.com/JuliaLang/julia/issues/5200), [3](https://github.com/JuliaLang/julia/issues/3988), [4](https://github.com/dcarrera/Doc.jl), [5](https://github.com/dcjones/Judo.jl), [6](https://github.com/johnmyleswhite/Roxygen.jl), [7](https://github.com/JuliaLang/JuliaDoc)), no complete solution has emerged. As a result, packages use different means of documentation, which can be hard to access in a systematic way.

A complete documentation system for Julia should be able to associate doc entries with Julia objects, make those entries accessible and searchable from the REPL, and generate static documentation from those entries. This project consists of synthesizing the work that has been done to implement a core documentation system for Julia.

## Light Table Integration

Light Table has the potential to be a great IDE for Julia - one that supports both Julia's highly interactive approach and enables development of large projects and packages.

**Expected Results:** Full integration with Light Table's standard features (inline results and graphics, autocompletion etc.), along with the foundation of more advanced features (typeset equations, inline data entry, interactive visualisations etc.)

**Knowledge Prerequisites:** Understanding of Light Table's internals; experience using ClojureScript and Javascript.

**Estimated Difficulty:** Hard
