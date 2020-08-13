@def authors = "Tim Holy, Jeff Bezanson, and Jameson Nash"
@def published = "15 August 2020"
@def title = "Analyzing sources of compiler latency in Julia: method invalidations"
@def rss_pubdate = Date(2020, 8, 15)
@def rss = """Julia runs fast, but suffers from latency due to compilation. This post analyzes one source of excess compilation and tools for detecting and eliminating its causes."""

\toc

[The Julia programming language][Julia] has wonderful flexibility with types, and this allows you to combine packages in unanticipated ways to solve new kinds of problems.
Crucially, it achieves this flexibility without sacrificing runtime performance.
It does this by running versions of code or algorithms that have been "specialized" for the specific types you are using.
Creating these specializations is compilation, and when done on the fly (as is common in Julia) this is called "just in time" (JIT) compilation.
Unfortunately, JIT-compilation takes time, and this contributes to *latency*
when you first run Julia code.
This problem is often summarized as "time-to-first-plot," though there is nothing specific about plotting other than the fact that plotting libraries tend to involve large code bases, and these must be JIT-compiled.

Many people have spent a lot of time analyzing and reducing Julia's latency.
These efforts have met with considerable success: Julia 1.5 feels snappier than any version in memory,
and benchmarks support that impression.
But the job of reducing latency is not over yet.
Recent work on Julia's master branch has made considerable progress in significantly reducing a specific source of latency,
method invalidation.

## Method invalidation: what is it and when does it happen?

### An example: compilation for containers with unknown element types

When Julia compiles a method for specific types, it saves the resulting code
so that it can be used by any caller.
This is crucial to performance, because it means that compilation generally has to be done only once for a specific type.
To keep things really simple, we'll use a very artificial example.

```julia
f(x::Int) = 1
applyf(container) = f(container[1])
```

Here we've defined two functions; `f` supports `Int`,
and `applyf` supports `Any` argument at all.
When you call `applyf`, Julia will compile _specialized_ versions on demand for the
particular types of `container` that you're using at that moment, even though there isn't
any type annotation in its definition.
These versions that have been specialized for particular input types are `MethodInstance`s,
an internal type in `Core.Compiler`.

If you call `applyf([100])`, Julia will compile and use a version of `applyf` specifically
created for `Vector{Int}`.  Since the element type (`Int`) is a part of the `container`'s type, it
will compile this specialization
knowing that only `f(::Int)` will be used: the call will be "hard-wired" into the code that Julia produces.
You can see this using `@code_typed`:

```julia-repl
julia> applyf([100])
1

julia> @code_typed applyf([100])
CodeInfo(
1 ─     Base.arrayref(true, container, 1)::Int64
└──     return 1
) => Int64
```

The compiler knows that the answer will be 1, as long as the input array
has an element indexable by 1. (That `arrayref` statement enforces
bounds-checking, and ensure that Julia will throw an appropriate error if you
call `applyf([])`.)

For the purpose of this blog post, things start to get especially interesting if we use a container that can store elements with different types (here, type `Any`):

```julia-repl
julia> c = Any[100];

julia> applyf(c)
1

julia> @code_typed applyf(c)
CodeInfo(
1 ─ %1 = Base.arrayref(true, container, 1)::Any
│   %2 = (isa)(%1, Int64)::Bool
└──      goto #3 if not %2
2 ─      goto #4
3 ─ %5 = Main.f(%1)::Core.Const(1, false)
└──      goto #4
4 ┄ %7 = φ (#2 => 1, #3 => %5)::Core.Const(1, false)
└──      return %7
) => Int64
```

This may seem a lot more complicated, but the take-home message is actually
quite simple. First, look at that `arrayref` statement: it is annotated
`Any`, meaning that Julia can't predict in advance what it will return.
Immediately after the reference, notice the `isa` statement
followed by a `φ`; all of this is essentially equivalent to:

```julia
if isa(x, Int)
    value = 1
else
    value = f(x)::Int
end
```

The compiler might not know in advance what type `container[1]` will have, but it knows there's a method of `f` specialized for `Int`.
To improve performance, it checks (as efficiently as possible at runtime) whether that method might be applicable,
and if so calls the method it knows.
In this case, `f` just returns a constant, so when applicable the compiler even "hard-wires" the return value in for you.

However, the compiler also acknowledges the possiblity that `container[1]` *won't* be an `Int`.
That allows the above code to throw a MethodError:

```julia-repl
julia> applyf(Any[true])
ERROR: MethodError: no method matching f(::Type{Bool})
Closest candidates are:
  f(::Int64) at REPL[1]:1
[...]
```

That's similar to what happens if we see how a well-typed call gets inferred:

```julia-repl
julia> @code_typed applyf([true])
CodeInfo(
1 ─ %1 = Base.getindex(container, 1)::Bool
│        Main.f(%1)::Union{}
└──      unreachable
) => Union{}
```
where in this case the compiler knows that the call won't succeed.

### Triggering method invalidation

**NOTE**: This demo is begin run on Julia's master branch (which will become 1.6).
Depending on your version of Julia, you might get different results and/or need to define more than one
additional method for `f` to see the outcome shown here.

Julia is interactive: we can define new methods on the fly and try them out.
Let's see what happens when we define a new method for `f`:

```julia
f(::Bool) = 2
```

While the `Vector{Int}`-typed version of `applyf` is not changed by this new definition (try it and see),
both the `Bool`-typed version and the untyped version are different than previously:

```julia
julia> @code_typed applyf([true])
CodeInfo(
1 ─     Base.arrayref(true, container, 1)::Bool
└──     return 2
) => Int64

julia> @code_typed applyf(Any[true])
CodeInfo(
1 ─ %1 = Base.arrayref(true, container, 1)::Any
│   %2 = Main.f(%1)::Int64
└──      return %2
) => Int64
```

This shows that defining a new method for `f` forced *recompilation* of these `MethodInstance`s.

You can see that Julia no longer uses that optimization for when `container[1]` happens to be an `Int`.
Experience has shown that once a method has a couple of specializations, it may accumulate yet more,
and to reduce the amount of recompilation needed Julia quickly abandons attempts to optimize the
case handling containers with unknown element types.
If you look carefully, you'll notice one remaining optimization: the call to `Main.f` is type-asserted as `Int`,
since both known methods of `f` return an `Int`.
This can be a very useful performance optimization for any code that uses the output of `applyf`.
But define two additional methods of `f`,

```julia
julia> f(::String) = 3
f (generic function with 4 methods)

julia> f(::Dict) = 4
f (generic function with 4 methods)

julia> @code_typed applyf(Any[true])
CodeInfo(
1 ─ %1 = Base.arrayref(true, container, 1)::Any
│   %2 = Main.f(%1)::Any
└──      return %2
) => Any
```

and you'll see that even this optimization is now abandoned.
This is because checking lots of methods, to see if they all return `Int`, is too costly an operation to be worth doing in all cases.

Altogether, `apply(::Vector{Any})` has been compiled three times: once when `f(::Int)` was the only method for `f`,
once where there were two methods, and once when there were four.
Had Julia known in advance that we'd end up here, it never would have bothered to compile those intermediate versions;
recompilation takes time, and we'd rather avoid spending that time if it's not absolutely necessary.
Fortunately, from where we are now Julia has stopped making assumptions about how many methods of `f` there will be,
so from this point forward we won't need to recompile `applyf` for a `Vector{Any}` even if we define further methods of `f`.

Recompilation is triggered by two events:
- when a new method is defined, old compiled methods that made now-incorrect assumptions get *invalidated*
- when no valid compiled method can be found to handle a call, Julia (re)compiles the necessary code.

It's the moment of method definition, triggering invalidations of other previously-compiled code,
that will be the focus of this blog post.

## How common is method invalidation?

Unfortunately, method invalidation is (or rather, used to be) pretty common.
First, let's get some baseline statistics.
Using the [MethodAnalysis] package, you can find out that a fresh Julia session has almost 50,000 `MethodInstance`s tucked away in its cache.
These are mostly for `Base` and the standard libraries.
(There are some additional `MethodInstance`s that get created to load the MethodAnalysis package and do this analysis, but these are surely a very small fraction of the total.)

Using [SnoopCompile], we can count the number of invalidations triggered by loading various packages into a fresh Julia session:

| Package | Version | # invalidations (Julia 1.5) | # invalidations (Julia 1.6) |
|:------- | -------:| ---------:| ---------:|
| Example | 0.5.3 | 0 | 0 |
| Revise | 2.7.3 | 23 | 0 |
| FixedPointNumbers | 0.8.4 | 335 | 22 |
| StaticArrays | 0.12.4 | 2181 | 47 |
| Images | 0.22.4 | 2881 | 332 |
| Optim | 0.22.0 | 2902 | 155 |
| SIMD | 2.8.0 | 2949 | 13 |
| Plots | 1.5.8 | 3156 | 278 |
| Makie | 0.11.1 | 3273 | 306 |
| Flux | 0.10.4 | 3461 | x |
| DataFrames | 0.21.6 | 4126 | 2822 |
| JuMP | 0.21.3 | 4281 | 2215 |
| DifferentialEquations | 6.15.0 | 6373 | 3251 |

('x' indicates that the package cannot be loaded)

You can see that key packages used by large portions of the Julia ecosystem have traditionally
invalidated hundreds or thousands of `MethodInstance`s, sometimes more than 10% of the total
number of `MethodInstance`s present before loading the package.
The situation has been dramatically improved on Julia 1.6, but there remains more
work left to do for particular packages.

## What are the impacts of method invalidation?

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

But if you load a package that does a lot of invalidation (on Julia versions 1.5 and below),

```julia-repl
julia> using SIMD

julia> @time display(plot(rand(5)))
  7.238336 seconds (26.50 M allocations: 1.338 GiB, 7.88% gc time)
```

Because so much got invalidated by loading SIMD, Julia had to recompile many methods before it could once again produce a plot, so that in terms of time it was almost as expensive as the first usage.
The size of the effect is strongly dependent on the particular packages and tasks,
and this particular example is already fixed on Julia 1.6.

This doesn't just affect plotting or packages. For example, loading packages could transiently make the REPL, the next Pkg update, or the next call to a distributed worker lag for several seconds.

You can minimize some of the costs of invalidation by loading all packages at the outset--if all invalidations happen before you start compiling very much code, then the first compilation already takes the full suite of methods into account.

On versions of Julia prior to 1.5 and 1.6, package load time was substantially increased by invalidation.
Especially on Julia 1.6, invalidation only rarely affects package load times,
largely because Pkg and the loading code have been made reasonably resistant to invalidation using some of the strategies described below.

## Can and should this be fixed?

Invalidations affect latency on their own, but they also impact other potential strategies for reducing latency.
For example, julia creates "precompile" (`*.ji`) files to speed up package usage.
Currently, it saves type-inferred but not [native code](https://www.techopedia.com/definition/3846/native-code) to its precompile files.
In principle, we could greatly reduce latency by also saving native code, since that would eliminate the need to do any compilation at all.
However, this strategy would be ineffective if most of this code ends up getting invalidated.
Indeed, it could make latency even worse, because you're doing work (loading more stuff from disk) without much reward.
However, if we get rid of most invalidations, then we can expect to get more benefit from caching native code,
and so if the community eliminates most invalidations then it begins to make much more sense to work to develop this new capability.

As to "can invalidations be fixed?", that depends on the goal.
We will never get rid of invalidation altogether; as the `applyf` example above shows,
invalidation is sometimes necessary if you want both good runtime performance and interactive usage, and this combination is one of the best things about Julia.
The real question is whether there are *unnecessary* invalidations,
or an unexploited strategy to limit their impact.
Determining the answer to that question requires that we develop an understanding the common sources of invalidation and what can be done to fix them.

## Changes in Julia that have reduced the number of invalidations

Much of the progress in reducing invalidations in Julia 1.6 come from changes to generic mechanisms in the compiler.
A [crucial change](https://github.com/JuliaLang/julia/pull/36733) was the realization that some invalidations were formerly triggered by new methods of *ambiguous specificity* for particular argument combinations; since calling a function with this argument combination would have resulted in a `MethodError` anyway, it is unnecessary to invalidate their (nominal) dependents.

Another [pair](https://github.com/JuliaLang/julia/pull/36208) of [fundamental](https://github.com/JuliaLang/julia/pull/35904) changes led to subtle but significant alterations in how much Julia specializes poorly-inferred code to reflect the current state of the world.
By making Julia less eager to specialize in such circumstances, huge swaths of the package ecosystem became more robust against invalidation.

Most of the remaining improvements stem from more directed changes that improved inferrability of dozens of specific methods.  You find many examples by searching for the [latency tag](https://github.com/JuliaLang/julia/pulls?q=is%3Apr+label%3Alatency+is%3Aclosed) among closed pull requests.

Most of these changes were at least partially inspired by new tools to analyze the source of invalidations, and we briefly touch on this final topic below.

## Tools for analyzing and fixing invalidations

Recently, the [SnoopCompile] package gained the ability to analyze invalidations and help developers fix them.
Because these tools will likely change over time, this blog post will only touch the surface; people who want to help fix invalidations are encouraged to read [SnoopCompile's documentation](https://timholy.github.io/SnoopCompile.jl/stable/snoopr/) for further detail.
There is also a [video]() available with a live-session fixing a real-world invalidation, which might serve as a useful example.

But to give you a taste of what this looks like, here are a couple of screenshots.
These were taken in Julia's REPL, but you can also use these tools in [vscode] or other environments.

First, let's look at a simple way (one that is not always precisely accurate, see SnoopCompile's documentation) to collect data on a package (in this case, loading the SIMD package):

![snoopr_simd](/assets/blog/2020-invalidations/SIMD_invalidations.png)

This prints out a list of method definitions (shown in light purple) that triggered invalidations (shown in yellow).
In very rough terms, you can tell how "important" these are by the number of children;
the ones with more children are listed last.
You can gain more insight into exactly what happened, and what the consequences were,
with `ascend`:

![snoopr_simd_ascend](/assets/blog/2020-invalidations/SIMD_ascend.png)

The [SnoopCompile documentation](https://timholy.github.io/SnoopCompile.jl/stable/snoopr/) has information about how to navigate this interactive menu,
and how to interpret the results to identify a fix, but in very rough terms
what's happening is that `deserialize_msg` is creating a [`Distributed.CallWaitMsg`](https://github.com/JuliaLang/julia/blob/5be3a544250a3c13de8d8ef2b434953005aee5c3/stdlib/Distributed/src/messages.jl#L26-L30) with very poor *a priori* type information (all arguments are inferred to be of type `Any`);
since the `args` field of a `CallWaitMsg` must be a `Tuple`, and because inference doesn't know that the supplied argument is already a `Tuple`, it calls `convert(Tuple, args)` so as to ensure it can construct the `CallWaitMsg` object.
But SIMD defines a new `convert(Tuple, v::Vec)` method which has greater specificity,
and so loading the SIMD package triggers invalidation of everything that depends on the less-specific method `convert(Tuple, ::Any)`.

As is usually the case, there are several ways to fix this: we could drop the `::Tuple` in the definition of `CallWaitMsg` (it doesn't need to call `convert` if there are no restrictions on the type), or we could assert that `args` is *already* a tuple in `deserialize_msg`, thus informing Julia that it can afford to skip the call to `convert`.
This is intended only as a taste of what's involved in fixing invalidations; more extensive descriptions are available in [SnoopCompile's documentation](https://timholy.github.io/SnoopCompile.jl/stable/snoopr/) and the [video]().

But it also conveys an important point: most invalidations come from poorly-inferred code, so by fixing invalidations you're often improving quality in other ways.  Julia's [performance tips] page has a wealth of good advice about avoiding non-inferrable code, and in particular cases (where you might know more about the types than inference is able to determine on its own) you can help inference by adding type-assertions.
Again, some of the recently-merged `latency` pull requests to Julia might serve as instructive examples.

## Summary

Julia's remarkable flexibility and outstanding code-generation open many new horizons.
These advantages come with a few costs, and here we've explored one of them, method invalidation.
While Julia's core developers have been aware of its cost for a long time,
we're only now starting to get tools to analyze it in a manner suitable for a larger population of users and developers.
Because it's not been easy to measure previously, there are still numerous opportunities for improvement waiting to be discovered.
One might hope that the next period of Julia's development might see significant progress in getting packages to work together gracefully without inadvertently stomping on each other's toes.

[Julia]: https://julialang.org/
[union-splitting]: https://julialang.org/blog/2018/08/union-splitting/
[MethodAnalysis]: https://github.com/timholy/MethodAnalysis.jl
[SnoopCompile]: https://github.com/timholy/SnoopCompile.jl
[performance tips]: https://docs.julialang.org/en/latest/manual/performance-tips/
[vscode]: https://www.julia-vscode.org/
