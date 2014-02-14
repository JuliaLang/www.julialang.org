---
layout: default
title:  Google Summer of Code
---

# Google Summer of Code 2014

Julia has applied to be a Google Summer of Code mentoring organization. The following are ideas for student summer projects. To add or edit projects, please edit this page [here](https://github.com/JuliaLang/julialang.github.com/blob/master/gsoc/2014/index.md) through GitHub by making pull requests.


## Projects

### Better Documentation

Julia does not yet have a standard way of documenting packages and making that documentation available in the REPL. Though a number of proposoals have been made (see [1](https://github.com/JuliaLang/julia/issues/4579), [2](https://github.com/JuliaLang/julia/issues/5200), [3](https://github.com/JuliaLang/julia/issues/3988), [4](https://github.com/dcarrera/Doc.jl), [5](https://github.com/dcjones/Judo.jl), [6](https://github.com/johnmyleswhite/Roxygen.jl), [7](https://github.com/JuliaLang/JuliaDoc)), no complete solution has emerged. As a result, packages use different means of documentation, which can be hard to access in a systematic way.

A complete documentation system for Julia should be able to associate doc entries with Julia objects, make those entries accessible and searchable from the REPL, and generate static documentation from those entries. This project consists of synthesizing the work that has been done to implement a core documentation system for Julia.

### Data Packages

Scientific and technical computing often makes use of publicly available datasets. Obtaining this data often involves digging through horrifically designed government websites. Julia has a robust package manager, so storing a datset on github and making it available through the package manager can be a convenient distribution means (see [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl)). Yet, datasets are often too large to be stored reasonably git repository.

This project will consist of devising a standard means to write data packages to make large external datasets accessible. When a data package is installed, it will automatically download the dataset it wraps, validate it versus as stored checksum, and make that data available as a DataFrame or other Julia structure. In addition to a standard structure, the `Pkg.generate` function should be extended to generate data packages.

