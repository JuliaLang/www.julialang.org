@def title = "Tutorial on precompilation"
@def authors = "Tim Holy"
@def published = "5 January 2021"
@def rss_pubdate = Date(2021, 1, 5)
@def rss_description = """Tutorial on precompilation"""

One of the main foci of development during Julia 1.6 has been to reduce *latency*, the delay between starting your session and getting useful work done.  This is sometimes called "time to first plot," although it applies to far more than just plotting.
While a lot of work (and success) has gone into reducing latency in Julia 1.6, users and developers will naturally want to shrink it even more.  This is the inaugural post in a short series devoted to the topic of what package developers can do to reduce latency for their users.  This particular installment covers background material--some key underlying concepts and structures--that will hopefully be useful in later installments.

## Sources of latency, and reducing it with `precompile`

Most of Julia's latency is due to *code loading* and *compilation*. Julia's dynamic nature also makes it vulnerable to *invalidation* and the subsequent need to recompile previously-compiled code; this topic has been covered in a previous [blog post][invalidation], and that material will not be rehashed here.  In this series, it is assumed that invalidations are not a dominant source of latency.  (You do not need to read the previous blog post to understand this one.)

In very rough terms, `using SomePkg` loads types and/or method definitions, after which calling `SomePkg.f(args...)` forces `SomePkg.f` to be compiled (if it hasn't been already) for the specific types in `args...`.  The primary focus of this series is to explore the opportunity to reduce the cost of compilation.  We'll focus on *precompilation*,

```
julia> using SomePkg
[ Info: Precompiling SomePkg [12345678-abcd-9876-efab-1234abcd5e6f]
```

or the related `Precompiling project...` output that occurs after updating packages on Julia 1.6.  During precompilation, Julia writes module, type, and method definitions in an efficient [serialized] form.
Precompilation in its most basic form happens nearly automatically, but with a bit of manual intervention developers also have an opportunity to save additional information: partial results of compilation, specifically the *type inference* stage of compilation.
Because type inference takes time, this can reduce the latency for the first use of methods in the package.

To motivate this series, let's start with a simple demonstration in which adding a single line to a package results in a five-fold decrease in latency. We'll start with a package that we can define in a few lines (thanks to Julia's metaprogramming capabilities) and depending on very little external code, but which has been designed to have measurable latency.  You can copy/paste the following into Julia's REPL (be aware that it creates a package directory `DemoPkg` inside your current directory):

```
julia> using Pkg; Pkg.generate("DemoPkg")
  Generating  project DemoPkg:
    DemoPkg/Project.toml
    DemoPkg/src/DemoPkg.jl
Dict{String, Base.UUID} with 1 entry:
  "DemoPkg" => UUID("4d70085e-4304-44c2-b3c3-070197146bfa")

julia> typedefs = join(["struct DemoType$i <: AbstractDemoType x::Int end; DemoType$i(d::AbstractDemoType) = DemoType$i(d.x)" for i = 0:1000], '\n');

julia> codeblock = join(["    d = DemoType$i(d)" for i = 1:1000], '\n');

julia> open("DemoPkg/src/DemoPkg.jl", "w") do io
           write(io, """
           module DemoPkg

           abstract type AbstractDemoType end
           $typedefs

           function f(x)
               d = DemoType0(x)
               $codeblock
               return d
           end

           end
           """)
       end
```

After executing this, you can open the `DemoPkg.jl` file to see what `f` actually looks like. If we load the package, the first call `DemoPkg.f(5)` takes some time:

```
julia> push!(LOAD_PATH, "DemoPkg/");

julia> using DemoPkg

julia> tstart = time(); DemoPkg.f(5); tend=time(); tend-tstart
0.28725290298461914
```

but the second one (in the same session) is much faster:

```
julia> tstart = time(); DemoPkg.f(5); tend=time(); tend-tstart
0.0007619857788085938
```

The extra cost for the first invocation is the time spent compiling the method.
We can save some of this time by *precompiling* it and saving the result to disk.
All we need to do is add a single line to the module definition: either

- `f(5)`, which executes `f` while the package is being precompiled (and remember, execution triggers compilation, the latter being our actual goal)
- `precompile(f, (Int,))`, if we don't need the *output* of `f(5)` but only wish to trigger compilation of `f` for an `Int` argument.

Here we'll choose `precompile`:

```
julia> open("DemoPkg/src/DemoPkg.jl", "w") do io
           write(io, """
           module DemoPkg

           abstract type AbstractDemoType end
           $typedefs

           function f(x)
               d = DemoType0(x)
               $codeblock
               return d
           end

           precompile(f, (Int,))            # THE CRUCIAL ADDITION!

           end
           """)
       end
```

Now start a fresh session, load the package (you'll need that `push!(LOAD_PATH, "DemoPkg/")` again), and time it:

```
julia> tstart = time(); DemoPkg.f(5); tend=time(); tend-tstart
0.056242942810058594

julia> tstart = time(); DemoPkg.f(5); tend=time(); tend-tstart
0.0007371902465820312
```

It doesn't eliminate all the latency, but at just one-fifth of the original this is a major improvement in responsivity.  The fraction of compilation time saved by `precompile` depends on the balance between type inference and other aspects of code generation, which in turn depends strongly on the nature of the code: "type-heavy" code, such as this example, often seems to be dominated by inference, whereas "type-light" code (e.g., code that does a lot of numeric computation with just a few types and operations) tends to be dominated by other aspects of code generation.

While currently `precompile` can only save the time spent on type-inference, in the long run it may be hoped that Julia will also save the results from later stages of compilation.  If that happens, `precompile` will have even greater effect, and the savings will be less dependent on the balance between type-inference and other forms of code generation.

How does this magic work? During package precompilation, Julia creates a `*.ji` file typically stored in `.julia/compiled/v1.x/`, where `1.x` is your version of Julia.
Your `*.ji` file stores definitions of constants, types, and methods; this happens automatically while your package is being built.   Optionally (if you've used a `precompile` directive, or executed methods while the package is being built), it may also include the results of type-inference.

@@note
**Box 1**  It might be natural to wonder, "how does `precompile` help? Doesn't it just shift the cost of compilation to the time when I load the package?" The answer is "no," because a `*.ji` file is not a recording of all the steps you take when you define the module: instead, it's a snapshot of the *results* of those steps.  If you define a package

```
module PackageThatPrints

println("This prints only during precompilation")

function __init__()
    println("This prints every time the package is loaded")
end

end
```

you'll see that things that happen transiently do not "make it" into the precompile file: the first `println` displays only when you build the package, whereas the second one prints on subsequent `using PackageThatPrints` even when that doesn't require rebuilding the package.

To "make it" into the precompile file, statements have to be linked to constants, types, methods, and other durable code constructs.  The `__init__` function is special in that it automatically gets called, if present, at the end of [module-loading].

A `precompile` directive runs during precompilation, but the only thing relevant for the `*.ji` file are the results (the compiled code) that it produces.  Compiled objects (specifically the `MethodInstance`s described below) may be written to the `*.ji` file, and when you load the package those objects get loaded as well.  Loading the results of type inference does take some time, but typically it's a fair bit quicker than computing inference results from scratch.
@@

Now that we've introduced the promise of `precompile`, it's time to acknowledge that this topic is complex.
How do you know how much of your latency is due to type-inference?
Moreover, even when type inference is the dominant source of latency, it turns out you can still find yourself in a circumstance where it is difficult to eliminate most of its cost.
In previous Julia versions, this fact has led to more than a little frustration using `precompile`.
One source of trouble was [invalidation], which frequently "spoiled" precompilation on earlier Julia versions, but that has been greatly improved (mostly behind-the-scenes, i.e., without package developers needing to do anything) in Julia 1.6.
With invalidations largely eliminated, the trickiest remaining aspect of precompilation is one of *code ownership*: where should the results of precompilation be stored?
When a bit of code requires methods from one package or library and types from another, how do you (or how does Julia) decide where to store the compiled code?

In this blog post, we take a big step backwards and start peering under the hood.  The goal is to understand why `precompile` sometimes has dramatic benefits, why sometimes it has nearly none at all, and when it fails how to rescue the situation.  To do that, we'll have to understand some of the "chain of dependencies" that link various bits of Julia code together.


## Type-inference, MethodInstances, and backedges

We'll introduce these concepts via a simple demo (users are encouraged to try this and follow along).  First, let's open the Julia REPL and define the following methods:

```
double(x::Real) = 2x
calldouble(container) = double(container[1])
calldouble2(container) = calldouble(container)
```

`calldouble2` calls `calldouble` which calls `double` on the first element in `container`. Let's create a `container` object and run this code:

```
julia> c64 = [1.0]
1-element Vector{Float64}:
 1.0

julia> calldouble2(c64)    # running it compiles the methods for these types
2.0
```

Now, let's take a brief trip into some internals to understand what Julia's compiler did when preparing to run that statement. It will be easiest to use the [MethodAnalysis] package:

```
julia> using MethodAnalysis

julia> mi = methodinstance(double, (Float64,))
MethodInstance for double(::Float64)
```

`methodinstance` is a lot like [`which`], except it asks about *type-inferred code*.
We asked `methodinstance` to find an instance of `double` that had been inferred for a single `Float64` argument;
the fact that it returned a `MethodInstance`, rather than `nothing`,
indicates that this instance already existed--the method had already been inferred for this argument type because we ran `calldouble(c64)` which indirectly called `double(::Float64)`.
If you currently try `methodinstance(double, (Int,))`, you should get `nothing`, because we've never called `double` with an `Int` argument.

One of the crucial features of type-inference is that it keeps track of dependencies:

```
julia> using AbstractTrees

julia> print_tree(mi)
MethodInstance for double(::Float64)
└─ MethodInstance for calldouble(::Vector{Float64})
   └─ MethodInstance for calldouble2(::Vector{Float64})
```

This indicates that the result for type-inference on `calldouble2(::Vector{Float64})` depended on the result for `calldouble(::Vector{Float64})`, which in turn depended on `double(::Float64)`.
That should make sense: there is no way that Julia can know what type `calldouble2` returns unless it understands what its callees do.
This is our first example of a chain of dependencies that will be a crucial component of understanding how Julia decides where to stash the results of compilation.
In encoding this dependency chain, the callee (e.g., `double`) stores a link to the caller (e.g., `calldouble`); as a consequence, these links are typically called *[backedges]*.

@@note
**Box 2** Backedges don't just apply to code you write yourself, and they can link code across modules.  For example, to implement `2x`, our `double(::Float64)` calls `*(::Int, ::Float64)`:

```julia
julia> mi = methodinstance(*, (Int, Float64))
MethodInstance for *(::Int64, ::Float64)
```

We can see which `Method` this instance is from:

```julia
julia> mi.def
*(x::Number, y::Number) in Base at promotion.jl:322
```

This is defined in Julia's own `Base` module.  If we've run `calldouble2(c64)`, our own `double` is listed as one of its backedges:

```julia
julia> direct_backedges(mi)
5-element Vector{Core.MethodInstance}:
 MethodInstance for parse_inf(::Base.TOML.Parser, ::Int64)
 MethodInstance for init(::Int64, ::Float64)
 MethodInstance for show_progress(::IOContext{IOBuffer}, ::Pkg.MiniProgressBars.MiniProgressBar)
 MethodInstance for show_progress(::IO, ::Pkg.MiniProgressBars.MiniProgressBar)
 MethodInstance for double(::Float64)
```

`direct_backedges`, as its name implies, returns a list of the compiled direct callers. (`all_backedges` returns both direct and indirect callers.)  The specific list you get here may depend on what other packages you've loaded, and

```julia
julia> print_tree(mi)
MethodInstance for *(::Int64, ::Float64)
├─ MethodInstance for parse_inf(::Parser, ::Int64)
│  └─ MethodInstance for parse_number_or_date_start(::Parser)
│     └─ MethodInstance for parse_value(::Parser)
│        ├─ MethodInstance for parse_entry(::Parser, ::Dict{String, Any})
│        │  ├─ MethodInstance for parse_inline_table(::Parser)
│        │  │  ⋮
│        │  │
│        │  └─ MethodInstance for parse_toplevel(::Parser)
│        │     ⋮
│        │
│        └─ MethodInstance for parse_array(::Parser)
│           └─ MethodInstance for parse_value(::Parser)
│              ⋮
│
├─ MethodInstance for init(::Int64, ::Float64)
│  └─ MethodInstance for __init__()
├─ MethodInstance for show_progress(::IOContext{IOBuffer}, ::MiniProgressBar)
│  └─ MethodInstance for (::var"#59#63"{Int64, Bool, MiniProgressBar, Bool, PackageSpec})(::IOContext{IOBuffer})
├─ MethodInstance for show_progress(::IO, ::MiniProgressBar)
└─ MethodInstance for double(::Float64)
   └─ MethodInstance for calldouble(::Vector{Float64})
      └─ MethodInstance for calldouble2(::Vector{Float64})
```

might be *dramatically* more complex if you've loaded and used large packages that do a lot of computation.
@@

@@note
**Box 3** Generally, the set of backedges is a graph, not a tree: in real code, it's possible for `f` to call itself (e.g., `fibonacci(n) = fibonacci(n-1) + fibonacci(n-2)`), or for `f` to call `g` which calls `f`.
When following backedges, MethodAnalysis omits `MethodInstances` that appeared previously, thus performing a "search" of the graph.  The results of this search pattern can be visualized as a tree.

Type inference behaves similarly: it caches its results, and thus infers each `MethodInstance` only once. (One wrinkle is [constant propagation](https://en.wikipedia.org/wiki/Constant_folding), which can cause the same `MethodInstance` to be re-inferred for different constant values.)  As a consequence, inference also performs a depth-first search of the call graph.
@@

The creation of backedges is more subtle than it may seem at first glance.
To start getting a hint of some of the complexities, first note that currently these are the only inferred instances of these methods:

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

While `methodinstance(f, typs)` returns a specific `MethodInstance`, `methodinstances(f)` returns *all* inferred instances of `f`.

Let's see if we can get Julia to add some additional instances: let's create a new container, but in a twist this time we'll use one with abstract element type, so that Julia's type-inference cannot accurately predict the type of elements in the container.  The element type of our container will be `AbstractFloat`, an abstract type with several subtypes; every actual instance has to have a concrete type, and just to make sure it's a new type (triggering new compilation) we'll use `Float32`:

```
julia> cabs = AbstractFloat[1.0f0]   # store a `Float32` inside a `Vector{AbstractFloat}`
1-element Vector{AbstractFloat}:
 1.0f0

julia> calldouble2(cabs)             # compile for these new types
2.0f0
```

Now let's look at the available instances:

```
julia> mis = methodinstances(double)
3-element Vector{Core.MethodInstance}:
 MethodInstance for double(::Float64)
 MethodInstance for double(::AbstractFloat)
 MethodInstance for double(::Float32)
```

We see that there are not two but three type-inferred instances of `double`: one for `Float64`, one for `Float32`, and one for `AbstractFloat`. Let's check the backedges of each:

```
julia> print_tree(mis[1])
MethodInstance for double(::Float64)
└─ MethodInstance for calldouble(::Vector{Float64})
   └─ MethodInstance for calldouble2(::Vector{Float64})

julia> print_tree(mis[2])
MethodInstance for double(::AbstractFloat)

julia> print_tree(mis[3])
MethodInstance for double(::Float32)
```

Why does the first have backedges to `calldouble` and then to `calldouble2`, but the second two do not?
Moreover, why does every instance of `calldouble` have backedges to `calldouble2`

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

in seeming contradiction of the fact that some instances of `double` lack backedges to `calldouble`?
The results here reflect the success or failure of concrete type-inference.
In contrast with `Float64` and `Float32`, `AbstractFloat` is not a concrete type:

```
julia> isconcretetype(Float32)
true

julia> isconcretetype(AbstractFloat)
false
```

It may surprise some readers that `Vector{AbstractFloat}` is concrete:

```
julia> isconcretetype(Vector{Float32})
true

julia> isconcretetype(Vector{AbstractFloat})
true
```

The *container* is concrete--it has a fully-specified storage scheme and layout in memory--even if the *elements* are not.

@@exercise
**Exercise 1** Is `AbstractVector{AbstractFloat}` abstract or concrete? How about `AbstractVector{Float32}`? Check your answers using `isconcretetype`.
@@

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
Consequently the call with `::AbstractFloat` is made via *runtime dispatch*, where execution pauses, Julia asks for the concrete type of the object, and then it makes the appropriate call to `double` (in the case of `cabs[1]`, to `double(::Float32)`).

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

So now both concretely-inferred versions of `double` link all the way back to `calldouble2`, but only when the element type of the container is also concrete.  A single `MethodInstance` may be called by multiple `MethodInstance`s, but most commonly a backedge is created only when the call can be inferred.

@@exercise
**Exercise 2** Does Julia ever compile methods, and introduce backedges, for abstract types? Start a fresh session, and instead of using the definitions above define `double` using [`@nospecialize`] :

```julia
double(@nospecialize(x::Real)) = 2x
```

Now compare what kind of backedges you get with `c64` and `cabs`.
It may be most informative to quit your session and start fresh between trying these two different container types.
You'll see that Julia is quite the opportunist when it comes to specialization!
@@


## Precompilation and backedges

Let's turn the example above into a package:

```
julia> using Pkg; Pkg.generate("BackedgeDemo")
  Generating  project BackedgeDemo:
    BackedgeDemo/Project.toml
    BackedgeDemo/src/BackedgeDemo.jl
Dict{String, Base.UUID} with 1 entry:
  "BackedgeDemo" => UUID("35dad884-25a6-48ad-b13b-11b63ee56c40")

julia> open("BackedgeDemo/src/BackedgeDemo.jl", "w") do io
           write(io, """
           module BackedgeDemo

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

You can see we created a package and defined those three methods.  Crucially, we've also added three `precompile` directives, all for the top-level `calldouble2`. We did *not* add any explicit `precompile` directives for its callees `calldouble`, `double`, or anything needed by `double` (like `*` to implement `2*x`).

Now let's load this package and see if we have any `MethodInstance`s:

```
julia> push!(LOAD_PATH, "BackedgeDemo/")
4-element Vector{String}:
 "@"
 "@v#.#"
 "@stdlib"
 "BackedgeDemo/"

julia> using BackedgeDemo
[ Info: Precompiling BackedgeDemo [44c70eed-03a3-46c0-8383-afc033fb6a27]

julia> using MethodAnalysis

julia> methodinstances(BackedgeDemo.double)
3-element Vector{Core.MethodInstance}:
 MethodInstance for double(::Float32)
 MethodInstance for double(::Float64)
 MethodInstance for double(::AbstractFloat)
```

Hooray! Even though we've not used this code in this session, the type-inferred `MethodInstance`s are already there! (This is true only because of those `precompile` directives.)  You can also verify that the same backedges get created as when we ran this code interactively above.  We have successfully saved the results of type inference.

These `MethodInstance`s got cached in `BackedgeDemo.ji`.
It's worth noting that even though the `precompile` directive got issued from this package, `MethodInstances` for methods defined in other packages or libraries can be saved as well.
For example, Julia does not come pre-built with the inferred code for `Int * Float32`: in a fresh session,

```
julia> using MethodAnalysis

julia> mi = methodinstance(*, (Int, Float32))

```
returns `nothing` (the `MethodInstance` doesn't exist), whereas if we've loaded `BackedgeDemo` then

```
julia> mi = methodinstance(*, (Int, Float32))
MethodInstance for *(::Int64, ::Float32)

julia> mi.def        # what Method is this MethodInstance from?
*(x::Number, y::Number) in Base at promotion.jl:322
```

So even though the method is defined in `Base`, because `BackedgeDemo` needed this type-inferred code it got stashed in `BackedgeDemo.ji`.

This is *fantastic*, because it means the complete results of type-inference can be saved, even when they cross boundaries between packages and libraries.  Nevertheless, there are significant limitations to this ability to stash `MethodInstance`s from other modules.  Most crucially, `*.ji` files can only hold code they "own," either:

- for a method defined in the package
- through a chain of backedges to a method defined by the package

@@exercise
**Exercise 3** To see this limitation in action, delete the `precompile(calldouble2, (Vector{Float32},))` directive from  `BackedgeDemo.jl`, so that it has only

```julia
precompile(calldouble2, (Vector{Float64},))
precompile(calldouble2, (Vector{AbstractFloat},))
```

but then add

```julia
precompile(*, (Int, Float32))
```

in an attempt to force inference of that method anyway.

Start a fresh session and load the package (it should precompile again), and check whether `methodinstance(*, (Int, Float32))` returns a `MethodInstance` or `nothing`. Also run `print_tree` on the results of each item in `methodinstances(BackedgeDemo.double)`.
@@

Where there is no "chain of ownership" to `BackedgeDemo`, Julia doesn't know where to stash the `MethodInstance`s that get created by `precompile`; those `MethodInstance`s get created, but they do not get incorporated into the `*.ji` file because there is no particular module-owned `MethodInstance`s that they link back to.
Consequently, we can't precompile methods defined in other modules in and of themselves; we can only do it if those methods are linked by backedges to this package.

In practice, this means that even when packages add `precompile` directives, if there are a lot of type-inference failures the results can be very incomplete and the consequential savings may be small.

@@exercise
**Quiz** Add a new type to `BackedgeDemo`:

```
export SCDType
struct SCDType end
```

and a precompile directive for `Base.push!`:

```
precompile(push!, (Vector{SCDType}, SCDType))
```

Now load the package and check whether the corresponding `MethodInstance` exists. If not, can you think of a way to get that `MethodInstance` added to the `*.ji` file?

*Answer is at the bottom of this post*.
@@

@@note
**Box 4** `precompile` can also be passed a complete `Tuple`-type: `precompile(calldouble2, (Vector{AbstractFloat},))` can alternatively be written

```
precompile(Tuple{typeof(calldouble2), Vector{AbstractFloat}})
```

This form appears frequently if `precompile` directives are issued by code that inspects `MethodInstance`s, because this signature is in the `specType` field of a `MethodInstance`:

```
julia> mi = methodinstance(BackedgeDemo.double, (AbstractFloat,))
MethodInstance for double(::AbstractFloat)

julia> mi.specTypes
Tuple{typeof(BackedgeDemo.double), AbstractFloat}
```
@@

@@note
**Box 5** One other topic we've not yet discussed is that when `precompile` fails, historically (prior to Julia 1.7) it did so "almost" silently:

```julia
julia> methods(double)
# 1 method for generic function "double":
[1] double(x::Real) in BackedgeDemo at /tmp/BackedgeDemo/src/BackedgeDemo.jl:3

julia> precompile(double, (String,))
false
```

Even though `double` can't be compiled for `String`, the corresponding `precompile` doesn't error, it only returns `false`.
Julia 1.7 will warn about inactive precompile directives.
@@

## Summary

In this tutorial, we've learned about `MethodInstance`s, backedges, inference, and precompilation.
Some important take-home messages are:

- you can store the results of type-inference with explicit `precompile` directives
- to be useful, `precompile` has to be able to establish a chain of ownership to some package
- chains-of-ownership are bigger and more complete when type-inference succeeds

An important conclusion is that *precompilation works better when type inference succeeds.*
For some packages, time invested in improving inferrability can make your `precompile` directives work better.

## Looking ahead

Future installments will focus on describing some powerful new tools:

- tools to measure how inference is spending its time
- tools to help make decisions about (de)specialization
- tools to detect and fix inference failures
- tools to generate effective `precompile` directives

Stay tuned!

@@answer
**Answer to quiz**  Directly precompiling `push!(::Vector{SCDType}, ::SCDType)` fails, because while your package "owns" `SCDType`, *it does not own the method of `push!`*.

However, if you add a method that calls `push!` and then precompile it,

```
dopush() = push!(SCDType[], SCDType())
precompile(dopush, ())
```

then the `MethodInstance` for `push!(::Vector{SCDType}, ::SCDType)` will be added to the package through the backedge to `dopush` (which you do own).

This was an artificial example, but in more typical cases this happens organically through the functionality of your package.
But again, this works only for inferable calls.
@@

[package mode]: https://julialang.github.io/Pkg.jl/v1/getting-started/#Basic-Usage
[MethodAnalysis]: https://github.com/timholy/MethodAnalysis.jl
[serialized]: https://en.wikipedia.org/wiki/Serialization
[module-loading]: https://docs.julialang.org/en/v1/manual/modules/#Module-initialization-and-precompilation
[`@nospecialize`]: https://docs.julialang.org/en/v1/base/base/#Base.@nospecialize
[invalidation]: https://julialang.org/blog/2020/08/invalidations/
[`which`]: https://docs.julialang.org/en/v1/base/base/#Base.which-Tuple{Any,Any}
[backedges]: https://www.quora.com/What-is-a-back-edge?share=1
