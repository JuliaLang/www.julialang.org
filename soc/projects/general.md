---
layout: default
title:  General Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

## Expanding and improving LearnBase/JuliaML

[LearnBase](https://github.com/Evizero/LearnBase.jl) is an attempt to create common abstractions and tools for machine learning frameworks. Common functionality like data loading, loss functions or training processes can be defined generically, and then easily combined with a specific approach (e.g. an SVM).

Possible projects are:
  * Contributing to the generic functionality in JuliaML (e.g. creating or improving a package for loading data sets, or implementing training process, etc)
  * Pure-Julia implementations of specific model types (e.g. decision trees or SVMs) which integrate with the JuliaML ecosystem.

**Required Skills**: Knowledge of the machine learning technique(s) to be implemented.

**Recommended Skills**: General knowledge of the JuliaML project and aims, or wide knowledge of machine learning as a field, is a plus.

**Mentors**: [Christof Stocker](https://github.com/Evizero), [Tom Breloff](https://github.com/tbreloff), [JuliaML Members](https://github.com/orgs/JuliaML/people)

## Standardized dataset packaging

Scientific and technical computing often makes use of publicly available datasets. Often, there's a lot of overhead to finding these data sets and coercing them into a usable format. Packages like [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl/) and [MNIST.jl](https://github.com/johnmyleswhite/MNIST.jl) attempt to make this easier by downloading data automatically and providing it as a Julia data structure.

This project involves building a "[BinDeps.jl](https://github.com/JuliaLang/BinDeps.jl) for data" which would make the creation of data-providing packages easier. The package would make it easy to download / unzip large files and check their integrity them in a cross-platform way. Facilities for downloading specific datasets can then be built on top of this.

**Expected Results**: A BinDeps-like package for downloading and managing data, as well as examples of this package used with specific data sets.

**Recommended Skills**: Only standard programming skills are needed for this project. Familiarity with Julia is a plus.

**Mentors**: [JuliaML Members](https://github.com/orgs/JuliaML/people)

## Enhanced clipboard

Julia's functions for getting and setting the clipboard are currently limited to text; it would be useful to extend them to allow the transfer of other data (for example, spreadsheet data or images).

**Expected Results**: Extensible `clipboard()` and `clipboard(x)` functions to get and set the richest possible representation of the system clipboard data, as well as methods for specific types.

**Recommended skills**: Interfacing with C from Julia, clipboard APIs for different platforms. Familiarity with FileIO.jl.

**Mentors**: [Stefan Karpinski](https://github.com/StefanKarpinski)

## Calling Julia from Python

Julia could be a great replacement for C in Python projects, where it can be used to speed up bottlenecks without sacrificing ease of use. However, while the basic functionality for communicating with Julia exists in [PyCall.jl](https://github.com/JuliaPy/PyCall.jl) and [pyjulia](https://github.com/jakebolewski/pyjulia), it needs to be separated out and mantained as a real Python package.

**Expected Results**: An easy-to-use Python package which allows Julia functions to be imported and called, with transparent conversion of data.

**Recommended skills**: Familiarity with both Python and Julia, especially C interop.

**Mentors**: [Steven Johnson](https://github.com/stevengj)

## Middlewares for common web application chores in Mux.jl

Implementation of mid-level features - specifically routing, load-balancing, cookie/session handling, and authentication - in [Mux.jl](https://github.com/JuliaWeb/Mux.jl).  The implementation should be extensible enough to allow easy interfacing with different kinds of caching, databases or authentication backends. (See [Clojure/Ring](https://github.com/ring-clojure/ring/wiki/Why-Use-Ring%3F) for inspiration).

**Expected Results**: Improvements to the Mux.jl package.

**Required Skills**: Experience with web development.

**Recommended Skills**: Knowledge of various web frameworks, especially the design decisions and tradeoffs behind them.

**Mentors**: [Mike Innes](https://github.com/MikeInnes)

## QML.jl Improvements

The [QML.jl](https://github.com/barche/QML.jl) package provides Julia bindings for [Qt QML](http://doc.qt.io/qt-5/qtqml-index.html) on Windows, OS X and Linux. In the current state, basic functionality is available, but there is room for improvement regarding integration with [GLVisualize](https://github.com/JuliaGL/GLVisualize.jl) and plotting packages such as [GR](https://github.com/jheinen/GR.jl) (see also [issue 23](https://github.com/barche/QML.jl/issues/23)) or [Plots](https://github.com/JuliaPlots/Plots.jl). Another area of work is supporting more elaborate data models.

**Expected Results**: Improvements to the QML.jl package along one of these lines.

**Recommended Skills**: Familiarity with both Julia and the QT framework.

**Mentors**: [Bart Janssens](https://github.com/barche)

## Data Structure Algorithm Improvements

While many common data structures are encouraged to be implemented in packages, to encourage more experimentation, some are so basic they need to be in Base. There are a number of projects that could be done to improve the quality, performance, or usability of these builtin structures. Some ideas include:

- Changing Base.Dict to an ordered dict representation (http://datastructuresjl.readthedocs.io/en/latest/ordered_containers.html, https://github.com/JuliaLang/julia/pull/10116)
- Experiment with using alternative Dict hash structures (such as Robin Hood Hashing, used by [Rust](https://doc.rust-lang.org/beta/std/collections/struct.HashMap.html))
- Implementation and tests for assorted asynchronous, threaded storage primitives and data channels

**Recommended Skills**: Ability to write type-stable Julia code. Ability to find performance issues. Knowledge about data structures and related algorithms.

**Mentors:** [Jameson Nash](https://github.com/vtjnash)
