---
layout: feature
slug: composable
menu_title: Composable
category: feature
---
## Julia supports composability through multiple-dispatch

Multiple-dispatch means a function can be specialized for any combination of types of its inputs. Unlike traditional object-oriented programming languages where `x.foo(y)` calls the function `foo` specific to the type only `x` and not the type of `y` (in some languages you can dispatch on the type of `y` but are forces to stay within the class definition of the class of `x`, making it feel like a restricted, and retrofitted feature), in Julia, the same code would look like `foo(x, y)` and the function `foo` can be specialized for any permutation of the types of `x` and `y`. The specific implementation of `foo` for a given pair of types of `x` and `y`, such as `foo(x::Int, y::Int)` is called a [method](http://docs.julialang.org/en/release-0.4/manual/methods/) in Julia.

Multiple-dispatch means that you can separate functionality from type definitions in arbirary ways, giving you more freedom in organizing your codebase. Moreover, you can also have *third-party* code extend your system (by way of adding the `foo` functionality for more types or optimizing certain `foo` invocations) simply by adding the methods it wants to.

Multiple-dispatch system in Julia is *dynamic* which is in contrast to *static* dispatch allowed by languages like C++, this means that you can add a method to `foo` at run time use another function `bar` defined using `foo` immediately with the new types that `foo` accepts. This is illustrated with the example of `+` and `sum` here.
