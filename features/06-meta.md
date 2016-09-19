---
layout: feature
slug: meta
menu_title: Metaprogramming
category: feature
---
## Julia can write itself

Julia programs can be represented as [objects in Julia itself](http://docs.julialang.org/en/latest/manual/metaprogramming/#expressions-and-evaluation). This is in similar vein to languages in the Lisp family where the program can be represented as data (this property of a language is called [homoiconicity](https://en.wikipedia.org/wiki/Homoiconicity)).

This might seem like a cute feature at first, but it has deeper implications. Being able to represent code as data means that you can use Julia to transform code written in one way to act like code written another way! A `macro` is a piece of code which does exactly this. `macro` definitions are akin to function definitions, but they get as input the *expression* of the argument given (as opposed to the value of the argument, as in the case of a function), and must return the transformed expression to run in its place.

Here is a simple macro which reverses the arguments of a function call.

Note that macros are prefixed with `@` when calling them making the switch to macro-world easy to spot.

Macros can be used to good effect to create domain-specific-languages: a mini-language embedded in Julia to describe your own problem domain conciesly and more precisely. This feature is used to good effect by many much-loved packages like [JuMP](https://github.com/JuliaOpt/JuMP.jl), [PyCall](https://github.com/stevengj/PyCall.jl) and [Interact](https://github.com/JuliaLang/Interact.jl).


