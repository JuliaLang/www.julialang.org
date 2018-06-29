---
layout: default
title:  Tooling Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

# Tooling

## IDE Tooling

The [Juno](http://junolab.org) is open to general project ideas (from here or not); feel free to get in contact via the [forum](http://discourse.julialang.org/) to discuss!

## Progress Meter Improvements

Right now Juno's progress metre works well but is fairly basic. In particular, it could be improved by:

* Automatically reducing its own overhead, to avoid slowing down tight loops significantly,
* Supporting cancellation so that long-running computations can be safely interrupted,
* Supporting nested loops like `for i = 1:10, j = 1:10`,
* and having a real fallback in the console, rather than simply falling through.

These issues prevent package authors from using `@progress` over loops without modification, in many cases. This project would therefore involve improving on the above fronts (roughly in that order of priority).

**Expected Results**: Patches to Juno.jl implementing the above improvements.

**Recommended Skills**: Some experience with Julia and Juno is good, but only general programming skills are required.

**Mentors**: [Mike Innes](https://github.com/mikeinnes)

## Package installation UI

Juno could provide a simple way to browse available packages and view what's installed on their system. To start with, this project could simply provide a GUI that reads in package data from `~/.julia`, including available packages and installed versions, and buttons which call the relevant `Pkg.*` methods.

This could also be extended by having metadata about the package, such as a readme, github stars, activity and so on. To support this we probably need a [pkg.julialang.org](http://pkg.julialang.org) style API which provides the info in JSON format.

**Expected Results**: A UI in Juno for package operations.

**Recommended Skills**: Familiarity with javascript and/or atom package development.

**Mentors**: [Mike Innes](https://github.com/mikeinnes)

## Julia Code Analysis

The foundation for tools like refactoring, linting or autoformatting is a powerful framework for reading and writing Julia code while preserving various features of the source code; comments, original formatting, and perhaps even syntax errors. This could build on the work in [JuliaParser.jl](https://github.com/JuliaLang/JuliaParser.jl).

Related would be various tools for doing static or dynamic analysis of Julia code in order to find errors. A simple example would be linting indentation; combined with information from the parser, this could be a powerful way to reduce beginner frustration over `unexpected )` style error messages.

**Expected Results**: Tools for source-to-source transformations of Julia code, preserving comments and whitespace.

**Recommended Skills**: Experience with parsing, or even familiarity with JuliaParser.jl itself.

**Mentors**: [Keno Fischer](https://github.com/Keno)

## Performance Linting

Concepts relevant to Julia code's performance, like 'type-stability', are often implicit in written code, making it hard for new users in particular to catch slow code early on. However, this also represents a challenge for static analysis, since in general concrete type information won't be available until runtime.

A potential solution to this is to hook into function calls (users will most likely call a function with test inputs after writing it) and then use dynamically-available information, such as the output of `code_typed`, to find performance issues such as non-concrete types, use of global variables etc, and present these as lint warnings in the IDE.

While static analysis has long been used as a tool for understanding and finding problems in code, the use of dynamically available information is unexplored (with the exception of tracing JIT compilers, which demonstrate the power of the concept). This project has plenty of interesting extensions and could have the most interesting long-term implications.

**Expected Results**: IDE integration and tooling which detects performance issues.

**Required Skills:** Some familiarity with Julia, but more importantly javascript and/or Atom development.

**Mentors**: [Mike Innes](https://github.com/MikeInnes)

## Live editing for Weave files in VS Code

This project would add an interactive UI for [Weave.jl](https://github.com/mpastell/Weave.jl)
documents to the [julia VS Code extension](https://github.com/JuliaEditorSupport/julia-vscode).

**Required Skills**: Good understanding of TypeScript, web UI development,
strong general julia skills.

**Expected Results**: A highly interactive UI for julia markdown files in
VS Code.

**Mentors**: [David Anthoff](https://github.com/davidanthoff)

## VS Code extension

We are generally looking for folks that want to help with the [julia VS Code extension](https://github.com/JuliaEditorSupport/julia-vscode).
We have a long list of open issues, and some of them amount to significant
projects.

**Required Skills**: TypeScript, julia, web development.

**Expected Results**: Depends on the specific projects we would agree on.

**Mentors**: [David Anthoff](https://github.com/davidanthoff)

# Graphical user interfaces

## Interactive UI libraries and tooling

[WebIO.jl](https://github.com/JuliaGizmos/WebIO.jl) is an exciting new library that enables two-way interaction between julia and web technologies (html/css/js). We are looking for project proposals in, possibly a combination of the following areas:

- Tools for building dashboards, and easily deploying them to the web, ala R's Shiny, and Plotly's dash
- Wrapping js libraries such as D3, interact.js, Plotly's dash?
- Reliability/Testing - (tools to) enable browser based automated tests for WebIO, InteractNext, and other projects built on WebIO

We're open to your project ideas. Join us on the [#gizmos slack channel](https://julialang.slack.com/messages/gizmos/) to discuss or ping `@shashi` or `@JobJob` in a [discourse post](http://discourse.julialang.org/).

**Required Skills**: Experience with JavaScript front-end development, some familiarity with Julia

**Mentors**: [Shashi Gowda](https://github.com/shashi), [Joel Mason](https://github.com/JobJob)

## GUI library integration

[QML.jl](https://github.com/barche/QML.jl) provides an interface to connect a [QML](https://doc.qt.io/qt-5.10/qmlapplications.html) GUI to a Julia backend. Some ideas for improvement here are:
* Use [Observables.jl](https://github.com/JuliaGizmos/Observables.jl) to provide a more "Julian" way to pass data between the GUI and Julia. Work on this has already started on the [observables branch](https://github.com/barche/QML.jl/tree/observables) in QML.jl. Discussion: https://github.com/barche/QML.jl/issues/43
* Support [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) directly for creating an editable TableView. Inspiration: https://discourse.julialang.org/t/visual-workflow-tool-for-julia-lets-build-one/9384/4
* Make one [Plots.jl](https://github.com/JuliaPlots/Plots.jl) GUI to rule them all. Inspiration: https://discourse.julialang.org/t/best-plot-package/7458 and https://discourse.julialang.org/t/where-is-actual-development-in-plotting/6224
* Build QmlReactive (but using Observables maybe). Inspiration: https://github.com/JuliaGizmos/GtkReactive.jl

**Required Skills**: Some familarity with Julia, prior QML experience would also help.

**Mentors**: [Bart Janssens](https://github.com/barche), [Shashi Gowda](https://github.com/shashi) for the Observables part
