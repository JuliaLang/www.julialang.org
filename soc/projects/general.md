---
layout: default
title:  General Projects – Summer of Code
---

{% include toc.html %}

## Expanding and improving LearnBase/JuliaML

[LearnBase](https://github.com/Evizero/LearnBase.jl) is an attempt to create a complete well-abstracted set of primitives and tools for machine learning frameworks.  The goal is to find the overlap between research perspectives and create smart abstractions for common components such as loss functions, transformations, activation functions, etc.  These abstractions can be the building blocks for more flexible learning frameworks, incorporating models (SVM, regression, decision trees, neural networks, etc) into a unified framework more powerful than alternatives (Scikit-learn, TensorFlow, etc).

A student could contribute to the core abstractions, or to dependent learning frameworks, depending on their knowledge and interests.  It is expected that the student has prior knowledge of machine learning techniques which they would like to work with.  In order to meaningfully contribute to the core abstractions, a broad knowledgebase would be expected.  Specific experience with random forests or deep/recurrent neural networks would be a plus.

## Standardized dataset packaging

Scientific and technical computing often makes use of publicly available datasets. Obtaining this data often involves digging through horrifically designed government websites. Julia has a robust package manager, so storing a dataset on Github and making it available through the package manager can be a convenient means of distribution (see [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl)). At the same time, many datasets are too large to store reasonably in a git repository.

This project proposal is to develop a new Julia package that will implement a standard means to write data packages to make large external datasets accessible by downloading to a local machine. When a data package is installed, it will automatically download the dataset it wraps, validate it, e.g. with stored checksums, and make that data available as a `DataFrame` or other Julia structure. In addition to a standard structure, the `Pkg.generate` function should be extended to generate data packages.

## Enhanced clipboard

Julia's functions for getting and setting the clipboard are currently limited to text; it would be useful to extend them to allow the transfer of other data (for example, spreadsheet data or images).

**Expected Results:** Extensible `clipboard()` and `clipboard(x)` functions to get and set the richest possible representation of the system clipboard data, as well as methods for specific types.

**Knowledge Prerequisites:** Interfacing with C from Julia, clipboard APIs for different platforms.

## Calling Julia from Python

Julia could be a great replacement for C in Python projects, where it can be used to speed up bottlenecks without sacrificing ease of use. However, while the basic functionality for calling Julia exists in [IJulia](https://github.com/JuliaLang/IJulia.jl) and [pyjulia](https://github.com/jakebolewski/pyjulia), it needs to be separated out and mantained as a real Python package.

**Expected Results:** An easy-to-use Python package which allows Julia functions to be imported and called, with transparent conversion of data.

**Knowledge Prerequisites:** Python (especially C interop).

Julia's web and higher level networking framework is largely consolidated within the [JuliaWeb](https://github.com/JuliaLang) github organization.

## Middlewares for common web application chores in Mux.jl

Implementation of mid-level features - specifically routing, load-balancing, cookie/session handling, and authentication - in [Mux.jl](https://github.com/JuliaWeb/Mux.jl).  The implementation should be extensible enough to allow easy interfacing with different kinds of caching, databases or authentication backends. (See [Clojure/Ring](https://github.com/ring-clojure/ring/wiki/Why-Use-Ring%3F) for inspiration)

**Expected Results:** Some experience with web development.
