@def title = "Tutorial on precompilation"
@def authors = "Tim Holy"
@def published = "26 December 2020"
@def rss_pubdate = Date(2020, 12, 28)
@def rss = """Tutorial on precompilation"""

One of the main foci of development during Julia 1.6 has been to reduce *latency*, the delay between starting your session and getting useful work done. Most of this latency is due to *code loading* and *compilation*; the latter can be split broadly into *type inference* and *codegen*, although the latter itself has many stages.

While a lot of work has gone into Julia 1.6 to reduce latency, users and developers naturally will want more.  This is the inaugural post in a short series devoted to the topic of what package developers can do to reduce latency.  This particular installment is devoted to background material that will hopefully be useful in later installments.

## MethodInstances, type-inference, and backedges

We'll introduce these concepts via a simple demo (users are encourage to try this and follow along).  First, let's open the Julia REPL and define the following methods:

```
double(x::Real) = 2x
calldouble(container) = double(container[1])
calldouble2(container) = calldouble(container)
```

`calldouble2` calls `calldouble` which calls `double` on the first element in `container`. Let's create a `container` object and run this code:

```julia
julia> c64 = [1.0]
1-element Vector{Float64}:
 1.0

julia> calldouble2(c64)
2.0
```

Now, let's take a brief trip down to understand what Julia's compiler did when preparing to run that statement. It will be easiest to load the [MethodAnalysis] package:

```
julia> using MethodAnalysis

julia> mi = methodinstance(double, (Float64,))
MethodInstance for double(::Float64)
```

`methodinstance` is a lot like `which`, except it asks about *type-inferred code*.
This indicates that `double` has been inferred for an argument of type `Float64`.
One of the crucial features of type-inference is that it keeps track of dependencies:

```
julia> using AbstractTrees

julia> print_tree(mi)
MethodInstance for double(::Float64)
└─ MethodInstance for calldouble(::Vector{Float64})
   └─ MethodInstance for calldouble2(::Vector{Float64})
```

This indicates that the result for type-inference on `calldouble2(::Vector{Float64})` depended on the result for `calldouble(::Vector{Float64})`, which in turn depended on `double(::Float64)`.

At this point, these are the only inferred instances of these methods:

```
julia> methodinstances(double)
1-element Vector{Core.MethodInstance}:
 MethodInstance for double(::Float64)

julia> methodinstances(calldouble)
1-element Vector{Core.MethodInstance}:
 MethodInstance for calldouble(::Vector{Float64})

julia> methodinstances(calldouble2)
1-element Vector{Core.MethodInstance}:
 MethodInstance for calldouble2(::Vector{Float64})
```

Let's change that a bit: let's create a new container, one with abstract element type, so that Julia's type-inference cannot accurately predict the type of elements in the container: just for fun, we'll use a new concrete type too, `Float32`:

```
julia> cabs = AbstractFloat[1.0f0]
1-element Vector{AbstractFloat}:
 1.0f0

julia> calldouble2(cabs)
2.0f0
```

Now let's look at the available instances:

```
julia> mis = methodinstances(double)
3-element Vector{Core.MethodInstance}:
 MethodInstance for double(::Float64)
 MethodInstance for double(::AbstractFloat)
 MethodInstance for double(::Float32)

julia> print_tree(mis[1])
MethodInstance for double(::Float64)
└─ MethodInstance for calldouble(::Vector{Float64})
   └─ MethodInstance for calldouble2(::Vector{Float64})

julia> print_tree(mis[2])
MethodInstance for double(::AbstractFloat)

julia> print_tree(mis[3])
MethodInstance for double(::Float32)
```

Why does the first "link to" (more technically, have backedges to) `calldouble` and `calldouble2`, but the second two do not?
Moreover, why does every instance of `calldouble` have backedges to `calldouble2`?

```
julia> mis = methodinstances(calldouble)
2-element Vector{Core.MethodInstance}:
 MethodInstance for calldouble(::Vector{Float64})
 MethodInstance for calldouble(::Vector{AbstractFloat})

julia> print_tree(mis[1])
MethodInstance for calldouble(::Vector{Float64})
└─ MethodInstance for calldouble2(::Vector{Float64})

julia> print_tree(mis[2])
MethodInstance for calldouble(::Vector{AbstractFloat})
└─ MethodInstance for calldouble2(::Vector{AbstractFloat})
```

The results here reflect the success or failure of concrete type-inference.
`AbstractFloat` is not a concrete type:

```
julia> isconcretetype(AbstractFloat)
false

julia> isconcretetype(Float32)
true
```

It may surprise some readers that `Vector{AbstractFloat}` is concrete:

```
julia> isconcretetype(Vector{AbstractFloat})
true

julia> isconcretetype(Vector{Float32})
true
```

The *container* is concrete even if the *elements* are not.
(Exercise for the reader: what about `AbstractVector{AbstractFloat}`? How about `AbstractVector{Float32}`?)

To look more deeply into the implications of concreteness and inference, a useful tool is `@code_warntype`.
You can see difference between `c64` and `cabs`, especially if you run this in the REPL yourself where you can see the red highlighting:

```julia
julia> @code_warntype calldouble2(c64)
Variables
  #self#::Core.Const(calldouble2)
  container::Vector{Float64}

Body::Float64
1 ─ %1 = Main.calldouble(container)::Float64
└──      return %1

julia> @code_warntype calldouble2(cabs)
Variables
  #self#::Core.Const(calldouble2)
  container::Vector{AbstractFloat}

Body::Any
1 ─ %1 = Main.calldouble(container)::Any
└──      return %1
```

Note that only the return type (`::Float64` vs `::Any`) differs between these; this is what accounts for the fact that `calldouble` has backedges to `calldouble2` in both cases, because in both cases the specific caller/callee chain can be successfully inferred.
The really big differences emerge one level lower:

```julia
julia> @code_warntype calldouble(c64)
Variables
  #self#::Core.Const(calldouble)
  container::Vector{Float64}

Body::Float64
1 ─ %1 = Base.getindex(container, 1)::Float64
│   %2 = Main.double(%1)::Float64
└──      return %2

julia> @code_warntype calldouble(cabs)
Variables
  #self#::Core.Const(calldouble)
  container::Vector{AbstractFloat}

Body::Any
1 ─ %1 = Base.getindex(container, 1)::AbstractFloat
│   %2 = Main.double(%1)::Any
└──      return %2
```

In the first case, `getindex` was guaranteed to return a `Float64`, but in the second case it's only known to be an `AbstractFloat`.
Moreover, type-inference cannot predict a concrete type for the return of `double(::AbstractFloat)`, though it can for `double(::Float64)`.
Consequently the call with `::AbstractFloat` is made via *runtime dispatch*, where execution pauses, Julia asks for the concrete type of the object, and then it makes the appropriate call to `double` (in this case, to `double(::Float32)`).

For completeness, what happens if we add another container with concrete eltype?

```
julia> c32 = [1.0f0]
1-element Vector{Float32}:
 1.0

julia> calldouble2(c32)
2.0f0

julia> mis = methodinstances(double)
3-element Vector{Core.MethodInstance}:
 MethodInstance for double(::Float64)
 MethodInstance for double(::AbstractFloat)
 MethodInstance for double(::Float32)

julia> print_tree(mis[1])
MethodInstance for double(::Float64)
└─ MethodInstance for calldouble(::Vector{Float64})
   └─ MethodInstance for calldouble2(::Vector{Float64})

julia> print_tree(mis[2])
MethodInstance for double(::AbstractFloat)

julia> print_tree(mis[3])
MethodInstance for double(::Float32)
└─ MethodInstance for calldouble(::Vector{Float32})
   └─ MethodInstance for calldouble2(::Vector{Float32})
```

So now both concretely-inferred versions of `double` link all the way back to `calldouble2`, but only when the element type of the container is also concrete.

### Exercise for the reader

Does Julia ever compile methods, and introduce backedges, for abstract types? Start a fresh session, and instead of using the definitions above define `double` using `@nospecialize`:

```julia
double(@nospecialize(x::Real)) = 2x
```

Now compare what kind of backedges you get with `c64` and `cabs`.

It may be most informative to quit your session and start fresh between trying these two different container types.  You'll see that Julia is quite the opportunist when it comes to specialization!

## Precompilation

During *package precompilation*, Julia creates a `*.ji` file typically stored in `.julia/compiled/v1.x/`, where `1.x` is your version of Julia.
Your `*.ji` file might just have definitions of constants, types, and methods, but optionally you can also include the results of type-inference.
This happens automatically if you run code while your package is being built, but generally the recommended procedure is to add *precompile directives*.

Let's turn the example above into a package. In a fresh session,

```
(@v1.6) pkg> generate SnoopCompileDemo
  Generating  project SnoopCompileDemo:
    SnoopCompileDemo/Project.toml
    SnoopCompileDemo/src/SnoopCompileDemo.jl

julia> open("SnoopCompileDemo/src/SnoopCompileDemo.jl", "w") do io
           write(io, """
           module SnoopCompileDemo

           double(x::Real) = 2x
           calldouble(container) = double(container[1])
           calldouble2(container) = calldouble(container)

           precompile(calldouble2, (Vector{Float32},))
           precompile(calldouble2, (Vector{Float64},))
           precompile(calldouble2, (Vector{AbstractFloat},))

           end
           """)
       end
282
```

You can see we created a package, defined those three methods, and added three `precompile` directives, all for the top-level `calldouble2`. We did *not* add any explicit `precompile` directives for its callees `calldouble`, `double`, or anything needed by `double` (like `*` to implement `2*x`).

Now let's load this package and see if we have any `MethodInstance`s:

```
julia> push!(LOAD_PATH, "SnoopCompileDemo/")
4-element Vector{String}:
 "@"
 "@v#.#"
 "@stdlib"
 "SnoopCompileDemo/"

julia> using SnoopCompileDemo
[ Info: Precompiling SnoopCompileDemo [44c70eed-03a3-46c0-8383-afc033fb6a27]

julia> using MethodAnalysis

julia> methodinstances(SnoopCompileDemo.double)
3-element Vector{Core.MethodInstance}:
 MethodInstance for double(::Float32)
 MethodInstance for double(::Float64)
 MethodInstance for double(::AbstractFloat)
```

You can also verify that the same backedges get created as when we ran this code interactively above.

By "pre-loading" these `MethodInstance`s into our session, we can save some of the time needed to run type-inference: not much time in this case because the code is so simple, but for more complex methods the savings can be substantial.

This code got cached in `SnoopCompileDemo.ji`. It's worth noting that even though the `precompile` directive got issued from this package, it might save `MethodInstances` for methods defined in other packages. For example, Julia does not come pre-built with the inferred code for `::Int * ::Float32`: in a fresh session,

```
julia> using MethodAnalysis

julia> mi = methodinstance(*, (Int, Float32))

```
returns `nothing` (the `MethodInstance` doesn't exist), whereas if we've loaded `SnoopCompileDemo` then

```
julia> mi = methodinstance(*, (Int, Float32))
MethodInstance for *(::Int64, ::Float32)

julia> mi.def
*(x::Number, y::Number) in Base at promotion.jl:322
```

So even though the method is defined in `Base`, because `SnoopCompileDemo` needed this code it got stashed in `SnoopCompileDemo.ji`.

This is fantastic, but there are *significant limitations* to this ability to stash `MethodInstance`s from other modules.  Most crucially, `*.ji` files can only hold code they "own," either:

- for a method defined in the package
- through a chain of backedges to methods defined by the package

If we add

```julia
precompile(*, (Int, Float16))
```

to the definition of `SnoopCompileDemo.jl`, start a fresh session, and reload the package, you'll see it's completely ineffective:

```julia
julia> mi = methodinstance(*, (Int, Float16))
                                               # nothing
```

This happens because there is no "chain of ownership" to `SnoopCompileDemo`.
Consequently, we can't precompile methods defined in other modules in and of themselves; we can only do it if those methods are linked by backedges to this package.

### Time for a quiz!

Add a new type to `SnoopCompileDemo`:

```
export SCDType
struct SCDType end
```

and a precompile directive for `Base.push!`:

```
precompile(push!, (Vector{SCDType}, SCDType))
```

Now load the package and check whether the corresponding `MethodInstance` exists. If not, can you think of a way to get that `MethodInstance` added to the `*.ji` file? (*Answer is at the bottom of this post*)


### Synonyms for `precompile`

`precompile` can also be passed a complete `Tuple`-type: `precompile(calldouble2, (Vector{AbstractFloat},))` can alternatively be written

```
precompile(Tuple{typeof(calldouble2), Vector{AbstractFloat}})
```

This form appears frequently if `precompile` directives are issued by code that inspects `MethodInstance`s, because this signature is in the `specType` field of a `MethodInstance`:

```
julia> mi = methodinstance(SnoopCompileDemo.double, (AbstractFloat,))
MethodInstance for double(::AbstractFloat)

julia> mi.specTypes
Tuple{typeof(SnoopCompileDemo.double), AbstractFloat}
```

### Gotchas for `precompile`

One thing we also haven't discussed is that when `precompile` fails, it does so "almost" silently:

```julia
julia> methods(double)
# 1 method for generic function "double":
[1] double(x::Real) in SnoopCompileDemo at /tmp/SnoopCompileDemo/src/SnoopCompileDemo.jl:3

julia> precompile(double, (String,))
false
```

Even though `double` can't be compiled for `String`, the corresponding `precompile` doesn't error, it only returns `false`.
If you want to monitor the utility of your `precompile` directives, sometimes it's useful to preface them with `@assert`; all's well if precompilation succeeds, but if changes to the package mean that the precompile directive has "gone bad," then you get an error.
Hopefully, such errors would be caught before shipping the package to users!


## Summary

In this tutorial, we've learned about `MethodInstance`s, backedges, inference, and precompilation.
An important take-home message is that *precompilation works better when type inference succeeds.*
For some packages, time invested in improving inferrability can make your `precompile` directives work better.
In future installments, we'll cover some new tools that make it easier than ever to analyzing inference failures.

### Answer to quiz

Directly precompiling `push!(::Vector{SCDType}, ::SCDType)` fails, because while your package "owns" `SCDType`, *it does not own the method of `push!`*.

However, if you add a method that calls `push!` and then precompile it,

```
dopush() = push!(SCDType[], SCDType())
precompile(dopush, ())
```

then the `MethodInstance` for `push!(::Vector{SCDType}, ::SCDType)` will be added to the package through the backedge to `dopush` (which you do own).

This was a pretty artifical example, but in more typical cases this happens organically through the functionality of your package.
But, this only works when the call is inferrable.

[MethodAnalysis]: https://github.com/timholy/MethodAnalysis.jl
