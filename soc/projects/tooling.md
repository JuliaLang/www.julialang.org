---
layout: default
title:  Tooling Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

# Tooling

The [Juno](http://junolab.org) is open to general project ideas (from here or not); feel free to get in contact via the [forum](http://discourse.julialang.org/) to discuss!

## Progress Metre Improvements

Right now Juno's progress metre works well but is fairly basic. In particular, it could be improved by:

* Automatically reducing its own overhead, to avoid slowing down tight loops significantly,
* Supporting cancellation so that long-running computations can be safely interrupted,
* Supporting nested loops like `for i = 1:10, j = 1:10`,
* and having a real fallback in the console, rather than simply falling through.

These issues prevent package authors from using `@progress` over loops without modification, in many cases. This project would therefore involve improving on the above fronts (roughly in that order of priority).

**Expected Results**: Patches to Juno.jl implementing the above improvements.

**Recommended Skills**: Some experience with Julia and Juno is good, but only general programming skills are required.

**Mentors**: [Mike Innes](https://github.com/mikeinnes)

## Documentation search & navigation

We'd like to make finding and viewing relevant documentation a core part of the Juno/Julia experience. As well as viewing docs for a particular function, it'd be great to take advantage of the extensive Markdown docs provided by packages for other purposes. For example, a basic doc search engine could allow users to find relevant functionality even when they don't know the names of the functions involved. (This could even be extended to searching across all packages!)

Initially this project could be built as a package or as an extension to the Atom.jl package. Eventually, we'd also like to integrate the functionality with a nice UI inside of Juno, and this could serve as extension work for an enterprising student.

**Expected Results**: Tools in Julia for collating and working with package documentation, as well as a plan for how this can become part of the IDE or other tooling.

**Recommended Skills**: The Julia-side parts of this could be done by anyone with programming experience. For Juno integration, familiarity with javascript or Atom development is a big plus.

**Mentors**: [Mike Innes](https://github.com/mikeinnes), [Michael Hatherly](https://github.com/michaelhatherly)

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
