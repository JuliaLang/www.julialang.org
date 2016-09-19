---
layout: feature
slug: dynamic
menu_title: Dynamic
title: Julia is Dynamic
category: feature
---

Julia is a [just-in-time compiled](https://en.wikipedia.org/wiki/Just-in-time_compilation) language. This means that you can execute, modify and re-execute code at run time and Julia will compile/re-compile your code on-the-fly. This makes for an easy programming model, shallow learning curve, and is great for prototyping. This also means no extra build steps for the users of your code written in Julia.

The [Julia REPL](http://docs.julialang.org/en/release-0.4/manual/interacting-with-julia/) is a powerful cross-platform utility that you can use to try out new ideas quickly, you can also use the [Juno IDE](http://junolabs.org/) to execute parts of the code as you're building it. There is also the powerful [Jupyter notebooks](https://github.com/JuliaLang/IJulia.jl) interface which you can use for exploratory data analysis, documentation or to create teaching material.

That said, however, the Julia Language is also designed to be friendly for static compilation, the compiler and the package manager make use of this feature under-the-hood caching compiled fragments of packages to provide a faster load time when the same compiled fragment can be reused.
