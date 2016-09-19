---
layout: feature
slug: general
menu_title: General
category: feature
---
## Julia is general-purpose

Julia is not meant only for technical computing although that is the core focus in the development of the language. Julia itself is a small, elegant, general purpose language (arguably smaller than Scheme) that can be used to build all kinds of computing tools. It is so general that the various kinds of number types and their conversion rules and promotion rules are themselves written in Julia.

The standard library itself comes with general purpose tools for [string processing](http://docs.julialang.org/en/release-0.4/manual/strings/), regular expression matching, file and [network](http://docs.julialang.org/en/release-0.5/manual/networking-and-streams/) IO, sane primitives to [interact with the OS shell](http://julialang.org/blog/2012/03/shelling-out-sucks) and more.

Most features that make Julia great, like its type system, [macros](http://docs.julialang.org/en/release-0.4/manual/metaprogramming/) (also the cute string macros), fast anonymous functions, the [package manager](http://docs.julialang.org/en/release-0.4/manual/packages/) are not specific to numerical computing at all. People have built, plotting libraries, game engines, web applications with Julia and little else.
