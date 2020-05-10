@def authors = "Tim Holy"
@def published = "10 May 2020"
@def title = "Analyzing sources of compiler latency in Julia: method invalidations"
@def rss_pubdate = Date(2020, 5, 10)
@def rss = """Julia is fast, but compiling Julia code takes time. This post analyzes why it's sometimes necessary to repeat that work, and what might be done to fix it."""


[The Julia programming language][Julia] has wonderful flexibility with types, and this allows you to combine packages in unanticipated ways to solve new kinds of problems.
Crucially, it achieves this flexibility without sacrificing performance.
It does this by running versions of code or algorithms that have been "specialized" for the specific types you are using.
Creating these specializations is compilation, and when done on the fly (as is common in Julia) this is called "just in time" (JIT) compilation.
Unfortunately, JIT-compilation takes time, and this contributes to *latency*
when you first run Julia code.
This problem is often summarized as "time-to-first-plot," though there is nothing specific about plotting other than the fact that plotting libraries tend to involve large code bases, and these must be JIT-compiled.

Many people have spent a lot of time analyzing and reducing Julia's latency.
These efforts have met with considerable success: the upcoming Julia 1.5 feels "snappier" than any recent version I've used.
But the job of reducing latency is not over yet.
Recently I got interested in a specific source of this latency, and this blog post is a summary of some of what I've learned about the scope of this problem and opportunities for further improvement.

# Method invalidation: what is it and when does it happen?

## An example: compilation in the presence of Union-splitting

When Julia compiles a method for specific types, it saves the resulting code
so that it can be used by any caller.
This is crucial to performance, because it means generally compilation has to be done only once for a specific type.
To keep things really simple, I'm going to use a very artificial example.

```julia
f(x::Int) = 1
f(x::Bool) = 2

function applyf(container)
    x1 = f(container[1])
    x2 = f(container[2])
    return x1 + x2
end
```

If you call `applyf([100, 200])`, it will compile a version of `applyf`
knowing that only `f(::Int)` will be used: the call will be "hard-wired" into the code that Julia produces.
You can see this using `@code_typed`:

```
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

If you pass a `Vector{Bool}`, it will compile `applyf` again, this time specializing it for `x::Bool`:

```
julia> @code_typed applyf([true,false])
CodeInfo(
1 ─     Base.arrayref(true, container, 1)::Bool
│       Base.arrayref(true, container, 2)::Bool
└──     return 4
) => Int64
```

In this case, you can see that Julia knew those two `arrayref` statements would
return a `Bool`, and since it knows the value of `f(::Bool)` it just went
ahead and computed the result for you.

At the end of these experiments, hidden away in Julia's "method cache" there will
be two `MethodInstance`s of `applyf`, one specialized for `Vector{Int}` and the other specialized for `Vector{Bool}`.
You don't normally see these, but Julia manages them for you; anytime you write
code that calls `applyf`, it checks to see if this previous compilation work can be reused.

For the purpose of this blog post, things start to get especially interesting if we try the following:
```
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

```julia
if isa(x, Bool)
    value = 2
elseif isa(x, Int)
    value = 1
else
    value = f(x)::Int
end
```

This is [union-splitting], a key optimization for performance in the face of uncertain types.

## Triggering method invalidation

One point in particular is worth noting: what's up with that final `f(x)::Int` call?
Didn't it already handle all the possibilities?
Well, all the possibilities *so far*.
But we might next define some new method of `f` for a different type:

```
f(::String) = 3
```

and Julia has prepared the way to make sure it will still give the right answer even if we add new methods to `f`.

However, if you try `@code_typed applyf(c)` again, you'll notice something curious:
Julia has gone to the trouble to create a new-and-improved implementation of `applyf`,
one which also union-splits for `String`.
This brings us to the topic of this blog post: the old compiled method has been *invalidated*.
Given new information---which here comes from defining or loading new methods---
Julia changes its mind about how things should be implemented,
and this forces Julia to recompile `applyf`.

If you add fourth and fifth methods,

```
f(::AbstractArray) = 4
f(::Missing) = 5
```

then Julia produces

```
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
It doesn't even try to enforce the fact that `f` returns and `Int`,
in part because determining such facts takes time (adding to compiler latency)
and because functions with many methods typically tend to return multiple types
anyway.

Compiling each of these new implementations takes JIT-time.
If Julia knew in advance that you'd arrive at this place, it would never have bothered to produce that first, heavily-optimized version of `applyf`.
But the performance benefits of such optimizations are so large that, when applicable, they are well worth it.
For example, if you start a fresh Julia session and just define the `f(::Int)`
and `f(::Bool)` methods, then

```
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
If method invalidation happens often, this might contribute to making Julia "feel" sluggish.

# How common is method invalidation?

Unfortunately, method invalidation is pretty common.
First, let's get some baseline statistics.
Using the [MethodAnalysis] package (which is at a very early stage of development
at the time of this writing), you can find out that a fresh Julia session
(albeit one that has loaded the MethodAnalysis package and used it to perform some analysis) has almost 50,000 `MethodInstance`s tucked away in its cache.
These are mostly for `Base` and the standard libraries.

Using some not-yet merged work in both Julia itself and [SnoopCompile], we can count the number of invalidations when we load various packages into a fresh Julia session:

| Package | # of unique invalidations |
|:------- | ------------------:|
| Example | 0 |
| Revise | 27 |
| FixedPointNumbers | 429 |
| SIMD | 2799 |
| StaticArrays | 2852 |
| Optim | 3171 |
| Images | 3638 |
| Flux | 3697 |
| Plots | 4002 |
| DataFrames | 4048 |
| JuMP | 4666 |
| Makie | 6118 |
| DifferentialEquations | 6777 |

You can see that key packages used by large portions of the Julia ecosystem invalidate
hundreds or thousands of MethodInstances, sometimes more than 10% of the total
number of MethodInstances present before loading the package.

# How serious is method invalidation?

The next time you want to call functionality that gets invalidated,
you have to wait for recompilation.
We can illustrate this using everyone's favorite example, plotting:

```julia
julia> using Plots

julia> @time display(plot(rand(5)))
  7.717729 seconds (15.27 M allocations: 797.207 MiB, 3.59% gc time)
```

As is well known, it's much faster the second time, because it's already compiled:

```julia
julia> @time display(plot(rand(5)))
  0.311226 seconds (19.93 k allocations: 775.055 KiB)
```

Now load a package that does a lot of invalidation, and try again:

```julia
julia> using SIMD

julia> @time display(plot(rand(5)))
  7.238336 seconds (26.50 M allocations: 1.338 GiB, 7.88% gc time)
```

Because so much got invalidated by loading SIMD, Julia had to recompile many methods before it could once again produce a plot, so that in terms of time it was almost as expensive as the first usage.
The size of the effect varies substantially depending on what task you are trying to achieve and what packages you load to do the invalidation.
(If you do this with StaticArrays rather than SIMD there's no increase in latency,
but that's because StaticArrays was already loaded as an internal dependency of Plots.)

It's worth noting that you can escape much of this cost by loading all
packages at the outset.
Loading time is somewhat increased by invalidation, but the cost of
first-time usage is typically larger. When possible, it's best to get
the invalidation out of the way before starting your work.

# Can and should this be fixed?

Invalidations affect latency on their own, but they also impact other potential strategies for reducing latency.
For example, julia creates "precompile" (`*.ji`) files to speed up package usage.
Currently, it saves type-inferred but not "native" code to its precompile files.
In principle, saving native code would eliminate latency (for the method and type combinations that have been precompiled), but this will be ineffective if most of this code ends up getting invalidated.
Indeed, it could make it even worse, because you're doing work (loading more stuff from disk) without much reward.
Consequently, reducing invalidation seems likely to be useful on its own, and a necessary prerequisite to other potential strategies.

As to "can it be fixed?", that depends on the goal.
We will never get rid of invalidation altogether; as the `applyf` example above shows,
invalidation is sometimes necessary if you want both good runtime performance and interactive usage, and this combination is one of the best things about Julia.
The real question is whether there are *unnecessary* invalidations,
or a strategy to limit their impact.
Determining the answer to that question requires that we develop an understanding the common reasons for the large number of invalidations listed in the table above.

# An analysis of the causes of invalidation

This section relies on a recent [pull request to Julia][PRJulia] and
the [invalidations branch][PRSC] of [SnoopCompile].
If you try to replicate these, remember that invalidations occur only
for methods that have been compiled, which generally means you have to
execute them.

As we analyze causes of invalidation, you'll note that in some cases we can begin to think about how they might be fixed.
However, we'll save more detailed recommendations for the final section.

## New methods with greater specificity

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

using SnoopCompile
```

Then,
```
julia> invalidation_trees(@snoopr f(x::String) = 3)
1-element Array{SnoopCompile.MethodInvalidations,1}:
 insert f(x::String) in Main at REPL[7]:1 invalidated:
   mt_backedges: signature Tuple{typeof(f),Any} triggered MethodInstance for applyf(::Array{Any,1}) (0 children) more specific
```

Let's walk through this output a bit.
`@snoopr` turns on some debugging code inside Julia, and then executes the supplied statment;
it returns a fairly opaque list that can be parsed by `invalidation_trees`.
Entries in the returned array correspond to method additions (or deletions, if relevant) that triggers one or more invalidations.
In this case, the output means that the new `f(x::String)` method triggered an invalidation of `applyf(::Array{Any,1})`,
due to intersection with the signature `f(::Any)`.
`(0 children)` means that `applyf(::Vector{Any})` does not yet have any methods that called it and which in turn need to be invalidated.
Finally, `more specific` (which is printed in cyan) indicate that the new method was strictly more specific than the one that got invalidated.

As we mentioned above, there are good reasons to think this invalidation is "necessary," meaning that it is an unavoidable consequence of the choices made to optimize runtime performance while also allowing one to dynamically extend functions.
However, that doesn't mean there is nothing that you, as a developer, could do to eliminate this invalidation.
Perhaps there is no real need to ever call `applyf` with a `Vector{Any}`;
perhaps you can fix one of its upstream callers to supply a concretely-type vector.
Or perhaps it may be well-typed, but inference fails to realize that;
you could annotate the result of some call with `Vector{String}`, for instance,
if you were certain of the result type.
Of course, in some cases you might really need to call `applyf` with a `Vector{Any}`, in which case the best choice is to accept this invalidation as necessary and move on.

## New methods with ambiguous specificity

Now let's try a real-world case, where the outcomes are more complex.

```
julia> invalidation_trees(@snoopr using FixedPointNumbers)
6-element Array{SnoopCompile.MethodInvalidations,1}:
 insert promote_rule(::Type{T}, ::Type{Tf}) where {T<:Normed, Tf<:AbstractFloat} in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/normed.jl:310 invalidated:
   backedges: MethodInstance for promote_rule(::Type{Union{}}, ::Type{Float64}) triggered MethodInstance for promote_type(::Type{Float64}, ::Type{S} where S<:Integer) (0 children) less specific
              MethodInstance for promote_rule(::Type{S} where S<:Integer, ::Type{Float64}) triggered MethodInstance for promote_type(::Type{Float64}, ::Type{S} where S<:Integer) (0 children) ambiguous

 insert oneunit(::Type{X}) where X<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:93 invalidated:
   backedges: MethodInstance for oneunit(::Type{T} where T<:AbstractChar) triggered MethodInstance for first(::Base.OneTo{T}) where T<:AbstractChar (0 children) ambiguous
   7 mt_cache

 insert one(::Type{X}) where X<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:94 invalidated:
   mt_backedges: signature Tuple{typeof(one),Type{T} where T<:AbstractChar} triggered MethodInstance for oneunit(::Type{T} where T<:AbstractChar) (0 children) ambiguous
   5 mt_cache

 insert sizeof(::Type{X}) where X<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:100 invalidated:
   backedges: MethodInstance for sizeof(::DataType) triggered MethodInstance for Base.CyclePadding(::DataType) (25 children) ambiguous
              MethodInstance for sizeof(::Type) triggered MethodInstance for padding(::DataType) (3 children) more specific
              MethodInstance for sizeof(::Type{T} where T) triggered MethodInstance for array_subpadding(::Type{T} where T, ::Type{T} where T) (0 children) more specific
   1 mt_cache

 insert reduce_empty(::typeof(Base.mul_prod), ::Type{F}) where F<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:225 invalidated:
   backedges: MethodInstance for reduce_empty(::Function, ::Type{T} where T) triggered MethodInstance for reduce_empty(::Base.BottomRF{typeof(max)}, ::Type{VersionNumber}) (136 children) more specific
   3 mt_cache

 insert (::Type{X})(x::Real) where X<:FixedPoint in FixedPointNumbers at /home/tim/.julia/packages/FixedPointNumbers/w2pxG/src/FixedPointNumbers.jl:51 invalidated:
   mt_backedges: signature Tuple{Type{T} where T<:Int64,Int64} triggered MethodInstance for convert(::Type{T}, ::Int64) where T<:Int64 (1 children) ambiguous
   backedges: MethodInstance for (::Type{T} where T<:AbstractChar)(::Int32) triggered MethodInstance for +(::AbstractChar, ::UInt8) (157 children) ambiguous
              MethodInstance for (::Type{T} where T<:AbstractChar)(::UInt32) triggered MethodInstance for (::Type{T} where T<:AbstractChar)(::UInt32) (197 children) ambiguous
   1 mt_cache
```

This list is ordered from least-consequential to most consequential in terms of total number of invalidations.
The final entry, for `(::Type{X})(x::Real) where X<:FixedPoint`, triggered the invalidation of what nominally appear to be more than 350 MethodInstances.
(It is not certain that these methods are all disjoint from one another.)
In contrast, the first entry is responsible for just two invalidations.

One does not have to look at this list for very long to see that the majority of the invalidated methods are due to [method ambiguity].
From

```julia
julia> which(Char, (Int32,))
(::Type{T})(x::Number) where T<:AbstractChar in Base at char.jl:48
```

You may find it surprising that this method signature is ambiguous with `(::Type{X})(x::Real) where X<:FixedPoint`: after all, an `AbstractChar` is quite different from a `FixedPoint` number.
We can discover why with

```
julia> typeintersect(FixedPoint, AbstractChar)
Union{}
```

which shows that there is one type, the "empty type", that lies in their intersection.

There are good reasons to believe that the right way to fix such methods is to exclude ambiguous pairs from invalidation.
If such a change gets made to Julia, then all the ones marked "ambiguous" should magically disappear.
Consequently, we can turn our attention to other cases.
`reduce_empty(::typeof(Base.mul_prod), ::Type{F}) where F<:FixedPoint` is strictly more specific than `reduce_empty(::Function, ::Type{T} where T)`.
It's curious that this is listed as a backedge of `reduce_empty(::Base.BottomRF{typeof(max)}, ::Type{VersionNumber})`, since the latter is a concrete signature on its own.
This case too seems like something that should be fixed in Julia's invalidation logic.

Moving backward, we get to `sizeof(::Type{X}) where X<:FixedPoint`.
Simply put, this looks like a method that we don't need; perhaps it dates from some confusion, or an era where perhaps it was necessary.
So we've discovered the first place where a developer could do something to productively decrease the number of invalidations, in this case by just deleting the method.

You'll also notice one example where the new method is *less specific*.
It is not clear why such methods should be invalidating, and this may be a Julia bug.

## Partial specialization

If you try

```julia
julia> trees = invalidation_trees(@snoopr using StaticArrays)
```

you'll see a much longer output.
A large number of invalidations derive from the fact that StaticArrays defines a method for `!=`, which invalidates the fallback definition

```julia
!=(x, y) = !(x == y)
```

Since such definitions account for hundreds of nominal invalidations, it would be well worth considering whether it is possible to delete the custom `!=` methods.
For example, if they are purely for internal use you could modify each caller to
use the default method.

The vast majority of the rest appear to derive from ambiguities.
However, one more interesting case we've not seen before is

```julia
julia> tree = trees[end-7]
insert unsafe_convert(::Type{Ptr{T}}, m::Base.RefValue{FA}) where {N, T, D, FA<:FieldArray{N,T,D}} in StaticArrays at /home/tim/.julia/packages/StaticArrays/mlIi1/src/FieldArray.jl:124 invalidated:
   mt_backedges: signature Tuple{typeof(Base.unsafe_convert),Type{Ptr{_A}} where _A,Base.RefValue{_A} where _A} triggered MethodInstance for unsafe_convert(::Type{Ptr{Nothing}}, ::Base.RefValue{_A} where _A) (159 children) more specific
```

In this case, the signature that triggered the invalidation, `Base.unsafe_convert(::Type{Ptr{_A}} where _A, ::Base.RefValue{_A} where _A)`,
has been only partially specified: it depends on a type parameter `_A`.
Where does such a signature come from?
You can extract this line with

```
julia> trigger = tree[:mt_backedges, 1]
MethodInstance for unsafe_convert(::Type{Ptr{Nothing}}, ::Base.RefValue{_A} where _A) at depth 0 with 159 children

julia> trigger.children
5-element Array{SnoopCompile.InstanceTree,1}:
 MethodInstance for unsafe_convert(::Type{Ptr{Nothing}}, ::Base.RefValue{_A} where _A) at depth 1 with 0 children
 MethodInstance for unsafe_convert(::Type{Ptr{T}}, ::Base.RefValue{Tuple{Vararg{T,N}}}) where {N, T} at depth 1 with 2 children
 MethodInstance for _show_default(::Base.GenericIOBuffer{Array{UInt8,1}}, ::Any) at depth 1 with 113 children
 MethodInstance for _show_default(::IOContext{Base.GenericIOBuffer{Array{UInt8,1}}}, ::Any) at depth 1 with 37 children
 MethodInstance for _show_default(::IOContext{REPL.Terminals.TTYTerminal}, ::Any) at depth 1 with 2 children
```

and see all the `MethodInstance`s that called this one.
You'll notice three `_show_default` `MethodInstance`s here;
a little digging reveals that this is defined as

```julia
function _show_default(io::IO, @nospecialize(x))
    t = typeof(x)
    ...
end
```

So the `@nospecialize` annotation, designed to reduce the number of cases when `_show_default` needs to be recompiled, causes the methods *it* uses to become triggers for invalidation.
So here we see that a technique that very successfully reduces latencies also has a side effect of increasing the number of invalidations.
Fortunately, these cases of partial specialization also seem to count as ambiguities, and so if ambiguous matches are eliminated it should also solve partial specialization.

## Some summary statistics

Let's go back to our table above, and augment it with "sources" of invalidation:

| Package | greater specificity | lesser specificity | ambiguity |
|:------- | ------------------:| --------:| -----:|
| Example | 0 | 0 | 0 | 0 |
| Revise | 6 | 0 | 0 |
| FixedPointNumbers | 139 | 0 | 381 |
| SIMD | 3040 | 0 | 1017 |
| StaticArrays | 1382 | 13 | 2540 |
| Optim | 1385 | 13 | 2941 |
| Images | 1513 | 113 | 3102 |
| Flux | 1177 | 49 | 4107 |
| Plots | 1104 | 48 | 4604 |
| DataFrames | 2725 | 0 | 2680 |
| JuMP | 1549 | 14 | 5164 |
| Makie | 5147 | 92 | 4145 |
| DifferentialEquations | 3776 | 53 | 7419 |

The numbers in this table don't add up to those in the first, for a variety of reasons (here there is no attempt to remove duplicates, here we don't count "mt_cache" invalidations which were included in the first table, etc.).
In general terms, the last two columns should probably be fixed by changes in how Julia does invalidations; the first column indicates invalidations that should either be fixed in packages, Julia's own code, or will need to remain unfixed.
The good news is that much will likely be fixed by "automated" means,
but it appears that there will need to be a second round in which package developers inspect individual invalidations to determine what, if anything, can be done to remediate them.

[Julia]: https://julialang.org/
[union-splitting]: https://julialang.org/blog/2018/08/union-splitting/
[MethodAnalysis]: https://github.com/timholy/MethodAnalysis.jl
[SnoopCompile]: https://github.com/timholy/SnoopCompile.jl
[PRJulia]: https://github.com/JuliaLang/julia/pull/35768
[PRSC]: https://github.com/timholy/SnoopCompile.jl/pull/79
[method ambiguity]: https://docs.julialang.org/en/latest/manual/methods/#man-ambiguities-1
