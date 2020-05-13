@def authors = "Tim Holy"
@def published = "11 May 2020"
@def title = "Analyzing sources of compiler latency in Julia: method invalidations"
@def rss_pubdate = Date(2020, 5, 11)
@def rss = """Julia is fast, but compiling Julia code takes time. This post analyzes why it's sometimes necessary to repeat that work, and what might be done to fix it."""

\toc

[The Julia programming language][Julia] has wonderful flexibility with types, and this allows you to combine packages in unanticipated ways to solve new kinds of problems.
Crucially, it achieves this flexibility without sacrificing performance.
It does this by running versions of code or algorithms that have been "specialized" for the specific types you are using.
Creating these specializations is compilation, and when done on the fly (as is common in Julia) this is called "just in time" (JIT) compilation.
Unfortunately, JIT-compilation takes time, and this contributes to *latency*
when you first run Julia code.
This problem is often summarized as "time-to-first-plot," though there is nothing specific about plotting other than the fact that plotting libraries tend to involve large code bases, and these must be JIT-compiled.

Many people have spent a lot of time analyzing and reducing Julia's latency.
These efforts have met with considerable success: the upcoming Julia 1.5 feels snappier than any recent version I've used.
But the job of reducing latency is not over yet.
Recently I got interested in a specific source of this latency, and this blog post is a summary of some of what I've learned about the scope of this problem and opportunities for further improvement.

## Method invalidation: what is it and when does it happen?

### An example: compilation in the presence of Union-splitting

When Julia compiles a method for specific types, it saves the resulting code
so that it can be used by any caller.
This is crucial to performance, because it means that compilation generally has to be done only once for a specific type.
To keep things really simple, I'm going to use a very artificial example.

```
f(x::Int) = 1
f(x::Bool) = 2

function applyf(container)
    x1 = f(container[1])
    x2 = f(container[2])
    return x1 + x2
end
```

Here I've defined two functions; `f` is a function with two very simple methods,
and `applyf` is a function with just one method that supports `Any` argument at all.
When you call `applyf`, Julia will compile _specialized_ versions on demand for the
particular types of `container` that you're using at that moment, even though I didn't
specify a single type in its definition.

If you call `applyf([100, 200])`, Julia will compile and use a version of `applyf` specifically
created for `Vector{Int}`.  Since the element type (`Int`) is a part of the `container`'s type, it
will compile this specialization
knowing that only `f(::Int)` will be used: the call will be "hard-wired" into the code that Julia produces.
You can see this using `@code_typed`:

```julia-repl
julia> @code_typed applyf([100,200])
CodeInfo(
1 ─     Base.arrayref(true, container, 1)::Int64
│       Base.arrayref(true, container, 2)::Int64
└──     return 2
) => Int64
```

The compiler itself knows that the answer will be 2, as long as the input array
has elements indexable by 1 and 2. (Those `arrayref` statements enforce
bounds-checking, and ensure that Julia will throw an appropriate error if you
call `applyf([100])`.)

If you pass a `Vector{Bool}`, it will compile `applyf` again, this time specializing it for `Bool` elements:

```julia-repl
julia> @code_typed applyf([true,false])
CodeInfo(
1 ─     Base.arrayref(true, container, 1)::Bool
│       Base.arrayref(true, container, 2)::Bool
└──     return 4
) => Int64
```

In this case, you can see that Julia knew those two `arrayref` statements would
return a `Bool`, and since it knows the value of `f(::Bool)` it just went
ahead and computed the result at compile time for you.

After calling `applyf` with both sets of arguments, hidden away in Julia's "method cache" there will
be two `MethodInstance`s of `applyf`, one specialized for `Vector{Int}` and the other specialized for `Vector{Bool}`.
You don't normally see these, but Julia manages them for you; anytime you write
code that calls `applyf`, it checks to see if this previous compilation work can be reused.

For the purpose of this blog post, things start to get especially interesting if use a container that can store elements with different types (here, type `Any`):

```julia-repl
julia> c = Any[1, false];

julia> applyf(c)
3

julia> @code_typed applyf(c)
CodeInfo(
1 ── %1  = Base.arrayref(true, container, 1)::Any
│    %2  = (isa)(%1, Bool)::Bool
└───       goto #3 if not %2
2 ──       goto #6
3 ── %5  = (isa)(%1, Int64)::Bool
└───       goto #5 if not %5
4 ──       goto #6
5 ── %8  = Main.f(%1)::Int64
└───       goto #6
6 ┄─ %10 = φ (#2 => 2, #4 => 1, #5 => %8)::Int64
│    %11 = Base.arrayref(true, container, 2)::Any
│    %12 = (isa)(%11, Bool)::Bool
└───       goto #8 if not %12
7 ──       goto #11
8 ── %15 = (isa)(%11, Int64)::Bool
└───       goto #10 if not %15
9 ──       goto #11
10 ─ %18 = Main.f(%11)::Int64
└───       goto #11
11 ┄ %20 = φ (#7 => 2, #9 => 1, #10 => %18)::Int64
│    %21 = Base.add_int(%10, %20)::Int64
└───       return %21
) => Int64
```

This may seem a lot more complicated, but the take-home message is actually
quite simple. First, look at those `arrayref` statements: they are annotated
`Any`, meaning that Julia can't predict in advance what they will return.
Immediately after each reference, notice that there are two `isa` statements
followed by a `ϕ`; all of this is essentially equivalent to

```
if isa(x, Bool)
    value = 2
elseif isa(x, Int)
    value = 1
else
    value = f(x)::Int
end
```

This is [union-splitting], a performance optimization for cases where an object might be of one of several types.

### Triggering method invalidation

One point in particular is worth noting: what's up with that final `f(x)::Int` call?
Didn't it already handle all the possibilities?
Well, all the possibilities *so far*.
But we might next define some new method of `f` for a different type:

```
f(::String) = 3
```

and Julia has prepared the way to make sure it will still give the right answer even if we add new methods to `f`.

However, if you try `@code_typed applyf(Any[1, false])` again, you'll notice something curious:
Julia has gone to the trouble to create a new-and-improved implementation of `applyf`,
one which also union-splits for `String`.
This brings us to the topic of this blog post: the old compiled method has been *invalidated*.
Given new information--which here comes from defining or loading new methods--Julia changes its mind about how things should be implemented,
and this forces Julia to recompile `applyf`.

If you add fourth and fifth methods,

```
f(::AbstractArray) = 4
f(::Missing) = 5
```

then Julia produces

```julia-repl
julia> @code_typed applyf(c)
CodeInfo(
1 ─ %1 = Base.arrayref(true, container, 1)::Any
│   %2 = Main.f(%1)::Any
│   %3 = Base.arrayref(true, container, 2)::Any
│   %4 = Main.f(%3)::Any
│   %5 = (%2 + %4)::Any
└──      return %5
) => Any
```

There are now so many possibilities that Julia just gives up and
uses "runtime dispatch" to decide what method of `f` to call.
It doesn't even try to enforce the fact that `f` returns an `Int`,
in part because determining such facts takes time (adding to compiler latency)
and because functions with many methods typically tend to return multiple types
anyway.  Adding further methods of `f` would no longer cause invalidations of this very generic implementation or any of its callers.

Compiling each of these new implementations takes JIT-time.
If Julia knew in advance that you'd arrive at this place, it would never have bothered to produce that first, heavily-optimized version of `applyf`.
But the performance benefits of such optimizations are so large that, when applicable, they can be well worth it.
For example, if you start a fresh Julia session and just define the `f(::Int)`
and `f(::Bool)` methods, then

```julia-repl
julia> using BenchmarkTools

julia> @btime applyf($c)
  4.659 ns (0 allocations: 0 bytes)
3

julia> f(::String) = 3
f (generic function with 3 methods)

julia> f(::AbstractArray) = 4
f (generic function with 4 methods)

julia> f(::Missing) = 5
f (generic function with 5 methods)

julia> @btime applyf($c)
  33.537 ns (0 allocations: 0 bytes)
3
```
It's almost a tenfold difference.
If `applyf` is performance-critical, you'll be very happy that Julia tries to give you the best version it can, given the available information.
But this leaves the door open to invalidation, which means recompilation the next time you use `applyf`.
If method invalidation happens often, this might contribute to making Julia feel sluggish.

## How common is method invalidation?

Unfortunately, method invalidation is pretty common.
First, let's get some baseline statistics.
Using the [MethodAnalysis] package (which is at a very early stage of development
at the time of this writing), you can find out that a fresh Julia session has almost 50,000 `MethodInstance`s tucked away in its cache.
These are mostly for `Base` and the standard libraries.
(There are some additional `MethodInstance`s that get created to load the MethodAnalysis package and do this analysis, but these are surely a very small fraction of the total.)

Using some not-yet merged work in both Julia itself and [SnoopCompile], we can count the number of invalidations when we load various packages into a fresh Julia session:

| Package | Version | # of unique invalidations |
|:------- | -------:| ------------------:|
| Example | 0.5.3 | 0 |
| Revise | 2.6.6 | 27 |
| FixedPointNumbers | 0.8.0 | 429 |
| SIMD | 2.8.0 | 2799 |
| StaticArrays | 0.12.3 | 2852 |
| Optim | 0.21.0 | 3171 |
| Images | 0.22.2 | 3638 |
| Flux | 0.10.4 | 3697 |
| Plots | 1.2.3 | 4002 |
| DataFrames | 0.21.0 | 4048 |
| JuMP | 0.21.2 | 4666 |
| Makie | 0.10.0 | 6118 |
| DifferentialEquations | 6.13.0 | 6777 |

You can see that key packages used by large portions of the Julia ecosystem invalidate
hundreds or thousands of `MethodInstance`s, sometimes more than 10% of the total
number of `MethodInstance`s present before loading the package.

## How serious is method invalidation?

The next time you want to call functionality that gets invalidated,
you have to wait for recompilation.
We can illustrate this using everyone's favorite example, plotting:

```julia-repl
julia> using Plots

julia> @time display(plot(rand(5)))
  7.717729 seconds (15.27 M allocations: 797.207 MiB, 3.59% gc time)
```

As is well known, it's much faster the second time, because it's already compiled:

```julia-repl
julia> @time display(plot(rand(5)))
  0.311226 seconds (19.93 k allocations: 775.055 KiB)
```

Moreover, if you decide you want some additional functionality and decide to load a new package, sometimes it's essentially as fast again:

```julia-repl
julia> using StaticArrays

julia> @time display(plot(rand(5)))
  0.305394 seconds (19.96 k allocations: 781.836 KiB)
```

But if you load a package that does a lot of invalidation:

```julia-repl
julia> using SIMD

julia> @time display(plot(rand(5)))
  7.238336 seconds (26.50 M allocations: 1.338 GiB, 7.88% gc time)
```

Because so much got invalidated by loading SIMD, Julia had to recompile many methods before it could once again produce a plot, so that in terms of time it was almost as expensive as the first usage.
The size of the effect varies substantially depending on what task you are trying to achieve and what packages you load to do the invalidation.

It's worth noting that you can escape much of this cost by loading all
packages at the outset.
Loading time is somewhat increased by invalidation, but the cost of
first-time usage is typically larger. When possible, it's best to get
the invalidation out of the way before starting your work.

## Can and should this be fixed?

Invalidations affect latency on their own, but they also impact other potential strategies for reducing latency.
For example, julia creates "precompile" (`*.ji`) files to speed up package usage.
Currently, it saves type-inferred but not "native" code to its precompile files.
In principle, saving native code would eliminate latency for the method and type combinations that have been precompiled, but this will be ineffective if most of this code ends up getting invalidated.
Indeed, it could make it even worse, because you're doing work (loading more stuff from disk) without much reward.
Consequently, reducing invalidation seems likely to be useful on its own, and a necessary prerequisite to other potential strategies for reducing latency.

As to "can it be fixed?", that depends on the goal.
We will never get rid of invalidation altogether; as the `applyf` example above shows,
invalidation is sometimes necessary if you want both good runtime performance and interactive usage, and this combination is one of the best things about Julia.
The real question is whether there are *unnecessary* invalidations,
or an unexploited strategy to limit their impact.
Determining the answer to that question requires that we develop an understanding the common reasons for the large number of invalidations listed in the table above.

## An analysis of the causes of invalidation

This section relies on a recent [pull request to Julia][PRJulia] and
the [invalidations branch][PRSC] of [SnoopCompile].
If you try to replicate these results, remember that invalidations occur only
for methods that have been compiled, which generally means you have to
execute them first.

As we analyze causes of invalidation, you'll note that in some cases we can begin to think about how they might be fixed.
However, we'll save more detailed recommendations for the final section.

### New methods with greater specificity

It will be simplest to start with a case we already understand, the `applyf` example above. In a fresh Julia session,

```
f(x::Int) = 1
f(x::Bool) = 2
function applyf(container)
    x1 = f(container[1])
    x2 = f(container[2])
    return x1 + x2
end
c = Any[1, false];
applyf(c)
```

Then,

```julia-repl
julia> using SnoopCompile

julia> invalidation_trees(@snoopr f(x::String) = 3)
1-element Array{SnoopCompile.MethodInvalidations,1}:
 insert f(x::String) in Main at REPL[7]:1 invalidated:
   mt_backedges: signature Tuple{typeof(f),Any} triggered MethodInstance for applyf(::Array{Any,1}) (0 children) more specific
```

Let's walk through this output a bit.
`@snoopr` turns on some debugging code inside Julia, and then executes the supplied statment;
it returns a fairly opaque list that can be parsed by `invalidation_trees`.
Entries in the array returned by `invalidation_trees` correspond to method additions (or deletions, if relevant) that trigger one or more invalidations.
In this case, the output means that the new `f(x::String)` method triggered an invalidation of `applyf(::Array{Any,1})`,
due to intersection with the signature `f(::Any)`.
`(0 children)` means that `applyf(::Vector{Any})` does not yet have any methods that called it and which in turn need to be invalidated.
Finally, `more specific` (which is printed in cyan) indicate that the new method `f(::String)` was strictly more specific than the signature `f(::Any)` used by the `applyf` `MethodInstance` that got invalidated.

As we mentioned above, there are good reasons to think this invalidation is "necessary," meaning that it is an unavoidable consequence of the choices made to optimize runtime performance while also allowing one to dynamically extend functions.
However, that doesn't mean there is nothing that you, as a developer, could do to eliminate this invalidation.
Perhaps there is no real need to ever call `applyf` with a `Vector{Any}`;
perhaps you can fix one of its upstream callers to supply a concretely-type vector.
Or perhaps you could define more `f` methods at the outset, so that Julia has a better understanding of the different types that `applyf` needs to handle.
In some cases, though, you might really need to call `applyf` with a `Vector{Any}`, in which case the best choice is to accept this invalidation as necessary and move on.

### New methods with ambiguous specificity

Now let's try a real-world case, where the outcomes are more complex.

```julia-repl
julia> trees = invalidation_trees(@snoopr using FixedPointNumbers)
6-element Array{SnoopCompile.MethodInvalidations,1}:
 insert one(::Type{X}) where X<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:94 invalidated:
   mt_backedges: signature Tuple{typeof(one),Type{T} where T<:AbstractChar} triggered MethodInstance for oneunit(::Type{T} where T<:AbstractChar) (0 children) ambiguous
   1 mt_cache

 insert oneunit(::Type{X}) where X<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:93 invalidated:
   backedges: superseding oneunit(::Type{T}) where T in Base at number.jl:300 with MethodInstance for oneunit(::Type{T} where T<:AbstractChar) (1 children) more specific
   3 mt_cache

 insert promote_rule(::Type{T}, ::Type{Tf}) where {T<:Normed, Tf<:AbstractFloat} in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/normed.jl:310 invalidated:
   backedges: superseding promote_rule(::Type{var"#s822"} where var"#s822"<:AbstractIrrational, ::Type{T}) where T<:Real in Base at irrationals.jl:42 with MethodInstance for promote_rule(::Type{Union{}}, ::Type{Float64}) (1 children) ambiguous
              superseding promote_rule(::Type{var"#s92"} where var"#s92", ::Type{var"#s91"} where var"#s91") in Base at promotion.jl:235 with MethodInstance for promote_rule(::Type{S} where S<:Integer, ::Type{Float64}) (1 children) more specific
   6 mt_cache

 insert sizeof(::Type{X}) where X<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:100 invalidated:
   backedges: superseding sizeof(x) in Base at essentials.jl:449 with MethodInstance for sizeof(::DataType) (26 children) more specific
              superseding sizeof(x) in Base at essentials.jl:449 with MethodInstance for sizeof(::Type) (4 children) more specific
              superseding sizeof(x) in Base at essentials.jl:449 with MethodInstance for sizeof(::Type{T} where T) (1 children) more specific
   4 mt_cache

 insert reduce_empty(::typeof(Base.add_sum), ::Type{F}) where F<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:222 invalidated:
   backedges: superseding reduce_empty(op, T) in Base at reduce.jl:309 with MethodInstance for reduce_empty(::Function, ::Type{T} where T) (137 children) more specific

 insert (::Type{X})(x::Real) where X<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:51 invalidated:
   mt_backedges: signature Tuple{Type{T} where T<:Int64,Int64} triggered MethodInstance for convert(::Type{T}, ::Int64) where T<:Int64 (1 children) ambiguous
   backedges: superseding (::Type{T})(x::Number) where T<:AbstractChar in Base at char.jl:48 with MethodInstance for (::Type{T} where T<:AbstractChar)(::Int32) (187 children) ambiguous
              superseding (::Type{T})(x::Number) where T<:AbstractChar in Base at char.jl:48 with MethodInstance for (::Type{T} where T<:AbstractChar)(::UInt32) (198 children) ambiguous
   3 mt_cache
```

This list is ordered from least- to most-consequential in terms of total number of invalidations.
The final entry, for `(::Type{X})(x::Real) where X<:FixedPoint`, triggered the invalidation of what nominally appear to be more than 350 `MethodInstance`s.
(There is no guarantee that these methods are all disjoint from one another;
the results are represented as a tree, where each node links to its callers.)
In contrast, the first three entries are responsible for a tiny handful of invalidations.

One does not have to look at this list for very long to see that the majority of the invalidated methods are due to [method ambiguity].
Consider the line `...char.jl:48 with MethodInstance for (::Type{T} where T<:AbstractChar)(::Int32)`.
We can see which method this is by the following:

```julia-repl
julia> which(Char, (Int32,))
(::Type{T})(x::Number) where T<:AbstractChar in Base at char.jl:48
```

or directly as

```julia-repl
julia> tree = trees[end]
insert (::Type{X})(x::Real) where X<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:51 invalidated:
   mt_backedges: signature Tuple{Type{T} where T<:Int64,Int64} triggered MethodInstance for convert(::Type{T}, ::Int64) where T<:Int64 (1 children) ambiguous
   backedges: superseding (::Type{T})(x::Number) where T<:AbstractChar in Base at char.jl:48 with MethodInstance for (::Type{T} where T<:AbstractChar)(::Int32) (187 children) ambiguous
              superseding (::Type{T})(x::Number) where T<:AbstractChar in Base at char.jl:48 with MethodInstance for (::Type{T} where T<:AbstractChar)(::UInt32) (198 children) ambiguous
   3 mt_cache

julia> tree.method
(::Type{X})(x::Real) where X<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:51

julia> node = tree[:backedges,1]
MethodInstance for (::Type{T} where T<:AbstractChar)(::Int32) at depth 0 with 187 children

julia> node.mi.def
(::Type{T})(x::Number) where T<:AbstractChar in Base at char.jl:48
```

`trees[end]` selected the last (most consequential) method and the invalidations it triggered; indexing this with `:backedges` selected the category (`:mt_backedges`, `:backedges`, or `:mt_cache`), and the integer index selected the particular entry from that category.
This returns an `InstanceTree`, where the latter is a type encoding the tree.
(`:mt_backedges` will return a `sig=>node` pair, where `sig` is the invalidated signature.)

You may find it surprising that this method signature is ambiguous with `(::Type{X})(x::Real) where X<:FixedPoint`: after all, an `AbstractChar` is quite different from a `FixedPoint` number.
We can discover why with

```julia-repl
julia> tree.method.sig
Tuple{Type{X},Real} where X<:FixedPoint

julia> node.mi.specTypes
Tuple{Type{T} where T<:AbstractChar,Int32}

julia> typeintersect(tree.method.sig, node.mi.specTypes)
Tuple{Type{Union{}},Int32}
```

These two signatures have non-empty intersection.
The second parameter, `Int32`, makes sense as the intersection of `Int32` and `Real`.
The first arises from

```julia-repl
julia> typeintersect(Type{<:FixedPoint}, Type{<:AbstractChar})
Type{Union{}}
```

which shows that there is one Type, the "empty Type", that lies in their intersection.

There are good reasons to believe that the right way to fix such methods is to exclude ambiguous pairs from invalidation--if it were to be called by the compiled code, it would trigger an error anyway.
If this gets changed in Julia, then all the ones marked "ambiguous" should magically disappear.
Consequently, we can turn our attention to other cases.

For now we'll skip `trees[end-1]`, and consider `tree[end-2]` which results from defining
`sizeof(::Type{X}) where X<:FixedPoint`.
There's a perfectly good default definition, and this looks like a method that we don't need; perhaps it dates from some confusion, or an era where perhaps it was necessary.
So we've discovered an easy place where a developer could do something to productively decrease the number of invalidations, in this case by just deleting the method.

Rarely (in other packages) you'll notice cases where the new method is *less specific*.
It is not clear why such methods should be invalidating, and this may be either a SnoopCompile or Julia bug.

### Partial specialization

Let's return now to

```julia-repl
julia> tree = trees[end-1]
insert reduce_empty(::typeof(Base.add_sum), ::Type{F}) where F<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:222 invalidated:
   backedges: superseding reduce_empty(op, T) in Base at reduce.jl:309 with MethodInstance for reduce_empty(::Function, ::Type{T} where T) (137 children) more specific

julia> node = tree[:backedges, 1]
MethodInstance for reduce_empty(::Function, ::Type{T} where T) at depth 0 with 137 children
```

Our new method certainly looks more specific method than the one that triggered the invalidation,
so at face value this looks like one of those "necessary" invalidations we'd be hard-pressed to avoid.
However, appearances can be deceptive.
We can look at the callers of this `reduce_empty` method:

```julia-repl
julia> node.children
5-element Array{SnoopCompile.InstanceTree,1}:
 MethodInstance for reduce_empty(::Base.BottomRF{typeof(max)}, ::Type{VersionNumber}) at depth 1 with 39 children
 MethodInstance for reduce_empty(::Base.BottomRF{typeof(max)}, ::Type{Int64}) at depth 1 with 39 children
 MethodInstance for mapreduce_empty(::typeof(identity), ::typeof(max), ::Type{Pkg.Resolve.FieldValue}) at depth 1 with 21 children
 MethodInstance for mapreduce_empty(::typeof(identity), ::Pkg.Resolve.var"#132#134"{Pkg.Resolve.var"#smx#133"{Pkg.Resolve.Graph,Pkg.Resolve.Messages}}, ::Type{Int64}) at depth 1 with 10 children
 MethodInstance for mapreduce_empty(::typeof(identity), ::typeof(max), ::Type{Int64}) at depth 1 with 23 children
```

If we look at the source for these definitions, we can figure out that they'd call `reduce_empty` with one of two functions, `max` and `identity`.
Neither of these is consistent with the method for `add_sum` we've defined:

```julia-repl
julia> tree.method
reduce_empty(::typeof(Base.add_sum), ::Type{F}) where F<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:222
```

What's happening here is that we're running up against the compiler's heuristics for specialization:
it's not actually possible that any of these callers would end up calling our new method,
but because the compiler decides to create a "generic" version of the method, the signature gets flagged by the invalidation machinery as matching.


### Some summary statistics

Let's go back to our table above, and count the number of invalidations in each of these categories:

| Package | more specific | less specific | ambiguous |
|:------- | ------------------:| --------:| -----:|
| Example | 0 | 0 | 0 | 0 |
| Revise | 7 | 0 | 0 |
| FixedPointNumbers | 170 | 0 | 387 |
| SIMD | 3903 | 0 | 187 |
| StaticArrays | 989 | 0 | 3133 |
| Optim | 1643 | 0 | 2921 |
| Images | 1749 | 14 | 3671 |
| Flux | 1991 | 26 | 3460 |
| Plots | 1542 | 11 | 4302 |
| DataFrames | 4919 | 0 | 783 |
| JuMP | 2145 | 0 | 4670 |
| Makie | 6233 | 46 | 5526 |
| DifferentialEquations | 5152 | 18 | 6218 |

The numbers in this table don't add up to those in the first, for a variety of reasons (here there is no attempt to remove duplicates, here we don't count "mt_cache" invalidations which were included in the first table, etc.).
In general terms, the last two columns should probably be fixed by changes in how Julia does invalidations; the first column is a mixture of ones that might be removed by changes in Julia (if they are due to partial specialization) or ones that should either be fixed in packages, Base and the standard libraries, or will need to remain unfixed.
The good news is that these counts reveal that more than half of all invalidations will likely be fixed by "automated" means.
However, it appears that there will need to be a second round in which package developers inspect individual invalidations to determine what, if anything, can be done to remediate them.

## Fixing invalidations

You may have noticed that two packages, `Example` and `Revise`, trigger far fewer invalidations that the rest of the packages in our analysis.
`Example` is quite trivial, but `Revise` and its dependencies are quite large.
How does it avoid this problem?
First, Revise does not extend very many Base methods;
most of its methods are for functions it "owns," and the same is true for its dependencies.
Second, in the closing days of Julia 1.5's merge window,
Revise (and Julia) underwent a process of tracking down invalidations and eliminating them;
for comparison, on Julia 1.4, Revise triggers more than a 1000 non-unique invalidations.
The success of this effort gives one hope that other packages too may one day have fewer invalidations.

As stated above, there is reason to hope that most of the invalidations marked as "ambiguous" will be fixed by changes to Julia's compiler.
Here our focus is on those marked "more specific," since those are cases where it is harder to imagine a generic fix.

### Fixing type instabilities

In engineering Julia and Revise to reduce invalidations, at least two cases were fixed by resolving type-instabilities.
For example, one set of invalidations happened because CodeTracking, a dependency of Revise's, defines new methods for `Base.PkgId`.
It turns out that this triggered an invalidation of `_tryrequire_from_serialized`, which is used to load packages.
Fortunately, it turned out to be an easy fix: one section of `_tryrequire_from_serialized` had a passage

```
for M in mod::Vector{Any}
    if PkgId(M) == modkey && module_build_id(M) === build_id
        return M
    end
end
```

and since `M` had type `Any`, the compiler couldn't predict which version of `PkgId` would be called.
It sufficed to add

```
    M = M::Module
```

immediately after the `for` statement to fix the problem.
Not only does this fix the invalidation, but it lets the compiler generate better code.

The other case was a call from `Pkg` of `keys` on an AbstractDict of unknown type
(due to partial specialization).
Replacing `keys(dct)` with `Base.KeySet(dct)` (which is the default return value of `keys`) eliminated a very consequential invalidation, one that triggered seconds-long latencies in the next `Pkg` command after loading Revise.
The benefits of this change in Pkg's code went far beyond helping Revise; any package depending on the OrderedCollections package (which is a dependency of Revise and what actually triggered the invalidation) got the same benefit.
With these and a few other relatively simple changes, loading Revise no longer forces Julia to recompile much of Pkg's code the next time you try to update packages.

### Redirecting call chains

Let's return to our FixedPointNumbers `reduce_empty` example above.
A little prodding as done above reveals that this corresponds to the definition

```julia-repl
julia> node = tree[:backedges, 1]
MethodInstance for reduce_empty(::Function, ::Type{T} where T) at depth 0 with 137 children

julia> node.mi.def
reduce_empty(op, T) in Base at reduce.jl:309
```

If you look up this definition, you'll see it's

```
reduce_empty(op, T) = _empty_reduce_error()
```

which indicates that it is the fallback method for reducing over an empty collection, and as you might expect from the name, calling it results in an error:

```julia-repl
julia> op = Base.BottomRF(Base.max)
Base.BottomRF{typeof(max)}(max)

julia> Base.reduce_empty(op, VersionNumber)
ERROR: ArgumentError: reducing over an empty collection is not allowed
Stacktrace:
 [1] _empty_reduce_error() at ./reduce.jl:299
 [2] reduce_empty(::Function, ::Type{T} where T) at ./reduce.jl:309
 [3] reduce_empty(::Base.BottomRF{typeof(max)}, ::Type{T} where T) at ./reduce.jl:324
 [4] top-level scope at REPL[2]:1
```

This essentially means that no "neutral element" has been defined for this operation and type.

For the purposes of illustration, let's ignore the fact that this might be a case where the fix might in principle be made in the compiler.
Using ordinary Julia code, can we avoid this fallback?
One approach is to define the method directly: modify Julia to add

```
reduce_empty(::typeof(max), ::Type{VersionNumber}) = _empty_reduce_error()
```

so that we get the same result but don't rely on the fallback.

Given our observation above that this *apparent* invalidating method is not actually reachable by this call chain,
another approach is to force the compiler to specialize the method by adding type parameters:

```
reduce_empty(op::F, ::Type{T}) where {F,T} = _empty_reduce_error()
```

While there's little actual reason to force specialization on a method that just issues an error, in this case it does have the effect of allowing the compiler to realize that our new method is not reachable from this call path.

For addressing this purely at the level of Julia code, perhaps the best approach is to see who's calling it. We looked at `node.children` above, but now let's get a more expansive view:

```julia-repl
julia> show(node)
MethodInstance for reduce_empty(::Function, ::Type{T} where T)
 MethodInstance for reduce_empty(::Base.BottomRF{typeof(max)}, ::Type{VersionNumber})
  MethodInstance for reduce_empty_iter(::Base.BottomRF{typeof(max)}, ::Set{VersionNumber}, ::Base.HasEltype)
   MethodInstance for reduce_empty_iter(::Base.BottomRF{typeof(max)}, ::Set{VersionNumber})
    MethodInstance for foldl_impl(::Base.BottomRF{typeof(max)}, ::NamedTuple{(),Tuple{}}, ::Set{VersionNumber})
     MethodInstance for mapfoldl_impl(::typeof(identity), ::typeof(max), ::NamedTuple{(),Tuple{}}, ::Set{VersionNumber})
      MethodInstance for #mapfoldl#201(::Base.Iterators.Pairs{Union{},Union{},Tuple{},NamedTuple{(),Tuple{}}}, ::typeof(mapfoldl), ::typeof(identity), ::typeof(max), ::Set{VersionNumber})
       MethodInstance for mapfoldl(::typeof(identity), ::typeof(max), ::Set{VersionNumber})
        MethodInstance for #mapreduce#205(::Base.Iterators.Pairs{Union{},Union{},Tuple{},NamedTuple{(),Tuple{}}}, ::typeof(mapreduce), ::typeof(identity), ::typeof(max), ::Set{VersionNumber})
         MethodInstance for mapreduce(::typeof(identity), ::typeof(max), ::Set{VersionNumber})
          MethodInstance for maximum(::Set{VersionNumber})
           MethodInstance for set_maximum_version_registry!(::Pkg.Types.Context, ::Pkg.Types.PackageSpec)
            MethodInstance for collect_project!(::Pkg.Types.Context, ::Pkg.Types.PackageSpec, ::String, ::Dict{Base.UUID,Array{Pkg.Types.PackageSpec,1}})
             MethodInstance for collect_fixed!(::Pkg.Types.Context, ::Array{Pkg.Types.PackageSpec,1}, ::Dict{Base.UUID,String})
             ⋮
```

This indicates that this invalidation path resulted from a call to `maximum` from a function in `Pkg`, `set_maximum_version_registry!`.  A little digging reveals that it is defined as

```
function set_maximum_version_registry!(ctx::Context, pkg::PackageSpec)
    pkgversions = Set{VersionNumber}()
    for path in registered_paths(ctx, pkg.uuid)
        pathvers = keys(load_versions(ctx, path; include_yanked=false))
        union!(pkgversions, pathvers)
    end
    if length(pkgversions) == 0
        pkg.version = VersionNumber(0)
    else
        max_version = maximum(pkgversions)
        pkg.version = VersionNumber(max_version.major, max_version.minor, max_version.patch, max_version.prerelease, ("",))
    end
end
```

From that error above, we know that this invalidation is produced by an error-path triggered by trying to reduce over an empty collection.
Interestingly, we can see that `set_maximum_version_registry!` handles an empty collection by other means:
there is, in fact, no chance that `maximum(pkgversions)` will ever reach the error case.
However, the compiler does not realize that, and therefore generates code that has been prepared to call `reduce_empty`, and that makes it vulnerable to invalidation.

There are a couple of potential fixes.
From here, we see that a potentially better definition `reduce_empty` for `VersionNumber`s might be

```
reduce_empty(::Base.BottomRF{typeof(max)}, ::Type{VersionNumber}) = VersionNumber(0)
```

In that case we could delete the `length` check and rely on this to produce the desired outcome.
One should take this approach only if one can be convinced that version 0 can act as a universal "neutral element" for reductions involving `max` over `VersionNumber`s.
Adding this to `Pkg` would be type-piracy, since `max`, `BottomRF`, and `VersionNumber` are all defined in `Base`, so fixing it this way would best be done in Base.

But there are other possible fixes.
A little higher up the tree we see a call to `mapreduce`, and this presents another opportunity because `mapreduce` allows you to supply an `init` value:

```julia-repl
julia> mapreduce(identity, max, Set(VersionNumber[]); init=VersionNumber(0))
v"0.0.0"
```

Perhaps we could just call this instead of `maximum`.
However, it's a bit uglier than the original;
perhaps a nicer approach would be to allow one to supply `init` as a keyword argument to `maximum` itself.
While this is not supported on Julia versions up through 1.5, it's a feature that seems to make sense, and this analysis suggests that it might also allow developers to make code more robust against certain kinds of invalidation.

As this hopefully illustrates, there's often more than one way to "fix" an invalidation.
Finding the best approach may require some experimentation.

## Summary

Julia's remarkable flexibility and outstanding code-generation open many new horizons.
These advantages come with a few costs, and here we've explored one of them, method invalidation.
While Julia's core developers have been aware of its cost for a long time,
we're only now starting to get tools to analyze it in a manner suitable for a larger population of users and developers.
Because it's not been easy to measure previously, it would not be surprising if there are numerous opportunities for improvement waiting to be discovered.
One might hope that the next period of development might see significant improvement in getting packages to work together gracefully without stomping on each other's toes.

[Julia]: https://julialang.org/
[union-splitting]: https://julialang.org/blog/2018/08/union-splitting/
[MethodAnalysis]: https://github.com/timholy/MethodAnalysis.jl
[SnoopCompile]: https://github.com/timholy/SnoopCompile.jl
[PRJulia]: https://github.com/JuliaLang/julia/pull/35768
[PRSC]: https://github.com/timholy/SnoopCompile.jl/pull/79
[method ambiguity]: https://docs.julialang.org/en/latest/manual/methods/#man-ambiguities-1
