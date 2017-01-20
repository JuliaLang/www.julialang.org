---
layout: default
title:  Tooling Projects – Summer of Code
---

{% include toc.html %}

# Tooling

The [Juno](http://junolab.org) is open to general project ideas (from here or not); feel free to get in contact via the [forum](http://discourse.julialang.org/) to discuss!

## Documentation search & navigation

We'd like to make finding and viewing relevant documentation a core part of the Juno/Julia experience. As well as viewing docs for a particular function, it'd be great to take advantage of the extensive Markdown docs provided by packages for other purposes. For example, a basic doc search engine could allow users to find relevant functionality even when they don't know the names of the functions involved. (This could even be extended to searching across all packages!)

Initially this project could be built as a package or as an extension to the Atom.jl package. Eventually, we'd also like to integrate the functionality with a nice UI inside of Juno, and this could serve as extension work for an enterprising student.

## Package installation UI

Juno could provide a simple way to browse available packages and view what's installed on their system. To start with, this project could simply provide a GUI that reads in package data from `~/.julia`, including available packages and installed versions, and buttons which call the relevant `Pkg.*` methods.

This could also be extended by having metadata about the package, such as a readme, github stars, activity and so on. To support this we probably need a [pkg.julialang.org](http://pkg.julialang.org) style API which provides the info in JSON format.

## Julia Code Analysis

The foundation for tools like refactoring, linting or autoformatting is a powerful framework for reading and writing Julia code while preserving various features of the source code; comments, original formatting, and perhaps even syntax errors. This could build on the work in JuliaParser.jl.

Related would be various tools for doing static or dynamic analysis of Julia code in order to find errors. A simple example would be linting indentation; combined with information from the parser, this could be a powerful way to reduce beginner frustration over `unexpected )` style error messages.

## Performance Linting

Concepts relevant to Julia code's performance, like 'type-stability', are often implicit in written code, making it hard for new users in particular to catch slow code early on. However, this also represents a challenge for static analysis, since in general concrete type information won't be available until runtime.

A potential solution to this is to hook into function calls (users will most likely call a function with test inputs after writing it) and then use dynamically-available information, such as the output of `code_typed`, to find performance issues such as non-concrete types, use of global variables etc, and present these as lint warnings in the IDE.

While static analysis has long been used as a tool for understanding and finding problems in code, the use of dynamically available information is unexplored (with the exception of tracing JIT compilers, which demonstrate the power of the concept). This project has plenty of interesting extensions and could have the most interesting long-term implications.

## Workspace saving and loading

RStudio provides the option to save loaded packages and variables on shutdown, and set up the environment as before when restarting. This could be replicated in Juno using some serialisation format for Julia data (e.g. the built-in serialiser or HDF5.jl).

## Better error reporting

Julia's errors are helpful for the most part but could be improved - see [#4744](https://github.com/JuliaLang/julia/issues/4744).

**Expected Results:** Consistent printing of errors with qualified type and human-readable strings.

## Autoformat tool

This project involves creating an autoformat tool, similar to Go's `gofmt`, which automatically rewrites Julia source files into a standard format. This is a fairly experimental project - there are plenty of challanges involved with formatting such a dynamic and flexible language well. However, a well executed tool is likely to gain widespread adoption by the Julia community.

**Expected Results:** Autoformatting tool for Julia
