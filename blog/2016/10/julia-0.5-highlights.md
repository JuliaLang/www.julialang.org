@def rss_pubdate = Date(2016, 10, 11)
@def rss = """ Julia 0.5 Highlights | It introduces more transformative features than any release since the first official version.... """
@def published = "11 October 2016"
@def title = "Julia 0.5 Highlights"
@def authors = "Stefan Karpinski"  
@def hascode = true


*To follow along with the examples in this blog post and run them live, you can go to [JuliaBox](https://juliabox.com/), create a free login, and open the "Julia 0.5 Highlights" notebook under "What's New in 0.5". The notebook can also be downloaded from [here](/assets/blog/Julia-0.5-highlights-notebook/Julia%200.5%20Highlights.ipynb).*

[Julia 0.5](/blog/2016/01/julia-0.5-release/) is a pivotal release.
It introduces more transformative features than any release since the first official version.
Moreover, several of these features set the stage for even more to come in the [lead up to Julia 1.0](https://www.youtube.com/watch?v=5gXMpbY1kJY).
In this post, we'll go through some of the major changes in 0.5, including improvements to functional programming, comprehensions, generators, arrays, strings, and more.

## Functions

Julia has always supported functional programming features:

- anonymous functions ([lambdas](https://en.wikipedia.org/wiki/Anonymous_function)),
- inner functions that close over local variables ([closures](https://en.wikipedia.org/wiki/Closure_(computer_programming))),
- functions passed to and from other functions ([first-class](https://en.wikipedia.org/wiki/First-class_function) and [higher-order](https://en.wikipedia.org/wiki/Higher-order_function) functions).

Before this release, however, these features all came with a significant performance cost.
In a language that targets high-performance technical computing, that's a serious limitation.
So the Julia standard library and ecosystem have been rife with work-arounds to get the expressiveness of functional programming without the performance problems.
But the right solution, of course, is to make functional programming fast – ideally just as fast as the optimal hand-written version of your code would be.
In Julia 0.5, it is.
And that changes everything.

This change is so important that there will be a separate blog post about it in the coming weeks, explaining how higher-order functions, closures and lambdas have been made so efficient, as well as detailing the kinds of zero-cost abstractions these changes enable.
But for now, I'll just tease with a little timing comparison.
First, some definitions – they're the same in both 0.4 and 0.5:

```julia
v = rand(10^7);                   # 10 million random numbers
double_it_vec(v) = 2v             # vectorized doubling of input
double_it_map(v) = map(x->2x, v)  # map a lambda over input
```

First, a timing comparison in Julia 0.4:

```julia
julia> VERSION
v"0.4.7"

julia> mean([@elapsed(double_it_vec(v)) for _=1:100])
0.024444888209999998

julia> mean([@elapsed(double_it_map(v)) for _=1:100])
0.5515606454499999
```

On 0.4, the functional version using `map` is 22 times slower than the vectorized version, which uses specialized generated code for maximal speed.
Now, the same comparison in Julia 0.5:

```julia
julia> VERSION
v"0.5.0"

julia> mean([@elapsed(double_it_vec(v)) for _=1:100])
0.024549842180000003

julia> mean([@elapsed(double_it_map(v)) for _=1:100])
0.023871925960000002
```

The version using `map` is as fast as the vectorized one in 0.5.
In this case, writing `2v` happens to be more convenient than writing `map(x->2x, v)`, so we may choose not to use `map` here, but there are many cases where functional constructs are clearer, more general, and more convenient.
Now, they are also fast.

### Ambiguous methods

One design decision that any multiple dispatch language must make is how to handle dispatch ambiguities: cases where none of the methods applicable to a given set of arguments is more specific than the rest.
Suppose, for example, that a generic function, `f`, has the following methods:

```
f(a::Int, b::Real) = 1
f(a::Real, b::Int) = 2
```

In Julia 0.4 and earlier, the second method definition causes an ambiguity warning:

```julia
WARNING: New definition
    f(Real, Int64) at none:1
is ambiguous with:
    f(Int64, Real) at none:1.
To fix, define
    f(Int64, Int64)
before the new definition.
```

This warning is clear and gets right to the point: the case `f(a,b)` where `a` and `b` are of type `Int` (aka `Int64` on 64-bit systems) is ambiguous.
Evaluating `f(3,4)` calls the first method of `f` – but this behavior is undefined.
Giving a warning whenever methods *could* be ambiguous is a fairly conservative choice: it urges people to define a method covering the ambiguous intersection before even defining the methods that overlap.
When we decided to give warnings for potentially ambiguous methods, we hoped that people would avoid ambiguities and all would be well in the world.

Warning about method ambiguities turns out to be both too strict and too lenient.
It's far too easy for ambiguities to arise when shared generic functions serve as extension points across unrelated packages.
When many packages extend the same generic functions, it's common for the methods added to have some ambiguous overlap.
This happens even when each package has no ambiguities on its own.
Worse still, slight changes to one package can introduce ambiguities elsewhere, resulting in the least fun game of [whack-a-mole](https://en.wikipedia.org/wiki/Whac-A-Mole#Colloquial_usage) ever.
At the same time, the fact that ambiguities *only* cause warnings means that people learn to ignore them, which is annoying at best, and dangerous at worst: it's far too easy for a real problem to be hidden by a barrage of insignificant ambiguity warnings.
In particular, on 0.4 and earlier if an ambiguous method is actually called, no error occurs.
Instead, one of the possible methods is called, based on the order in which methods were defined – which is essentially arbitrary when they come from different packages.
Usually the method works – it does apply, after all – but this is clearly not the right thing to do.

The solution is simple: in Julia 0.5 the existence of potential ambiguities is fine, but actually calling an ambiguous method is an immediate error.
The above method definitions for `f`, which previously triggered a warning, are now silent, but *calling* `f` with two `Int` arguments is a method dispatch error:

```julia
julia> f(3,4)
ERROR: MethodError: f(::Int64, ::Int64) is ambiguous. Candidates:
  f(a::Real, b::Int64) at REPL[2]:1
  f(a::Int64, b::Real) at REPL[1]:1
 in eval(::Module, ::Any) at ./boot.jl:231
 in macro expansion at ./REPL.jl:92 [inlined]
 in (::Base.REPL.##1#2{Base.REPL.REPLBackend})() at ./event.jl:46
```

This improves the experience of using the Julia package ecosystem considerably, while also making Julia safer and more reliable.
No more torrent of insignificant ambiguity warnings.
No more playing ambiguity whack-a-mole when someone else refactors their code and accidentally introduces ambiguities in yours.
No more risk that a method call could be silently broken because of warnings that we've all learned to ignore.

### Return type annotations

A long-requested feature has been the ability to annotate method definitions with an explicit return type.
This aids the clarity of code, serves as self-documentation, helps the compiler reason about code, and ensures that return types are what programmers intend them to be.
In 0.5, you can annotate method definitions with a return type like so:

```julia
function clip{T<:Real}(x::T, lo::Real, hi::Real)::T
    if x < lo
        return lo
    elseif x > hi
        return hi
    else
        return x
    end
end
```

This function is similar to the built-in [`clamp`](https://docs.julialang.org/en/release-0.5/stdlib/math/#Base.clamp) function, but let's consider this definition for the sake of example.
The return annotation on `clip` has the effect of inserting implicit calls to `x->convert(T, x)` at each return point of the method.
It has no effect on any other method of `clip`, only the one where the annotation occurs.
In this case, the annotation ensures that this method always returns a value of the same type as `x`, regardless of the types of `lo` and `hi`:

```julia
julia> clip(0.5, 1, 2) # convert(T, lo)
1.0

julia> clip(1.5, 1, 2) # convert(T, x)
1.5

julia> clip(2.5, 1, 2) # convert(T, hi)
2.0
```

You'll note that the annotated return type here is `T`, which is a type parameter of the `clip` method.
Not only is that allowed, but the return type can be an arbitrary expression of argument values, type parameters, and values from outer scopes.
For example, here is a variation that promotes its arguments:

```julia
function clip2(x::Real, lo::Real, hi::Real)::promote_type(typeof(x), typeof(lo), typeof(hi))
    if x < lo
        return lo
    elseif x > hi
        return hi
    else
        return x
    end
end

julia> clip2(2, 1, 3)
2

julia> clip2(2, 1, 13//5)
2//1

julia> clip2(2.5, 1, 13//5)
2.5
```

Return type annotations are a fairly simple syntactic transformation, but they make it easier to write methods with consistent and predictable return types.
If different branches of your code can lead to slightly different types, the fix is now as simple as putting a single type annotation on the entire method.

### Vectorized function calls

Julia 0.5 introduces the syntax `f.(A1, A2, ...)` for vectorized function calls.
This syntax translates to `broadcast(f, A1, A2, ...)`, where `broadcast` is a higher-order function (introduced in 0.2), which generically implements the kind of broadcasting behavior found in Julia's "dotted operators" such as `.+`, `.-`, `.*`, and `./`.
Since higher-order functions are now efficient, writing `broadcast(f,v,w)` and `f.(v,w)` are both about as fast as loops specialized for the operation `f` and the shapes of `v` and `w`.
This syntax lets you vectorize your scalar functions the way built-in vectorized functions like `log`, `exp`, and `atan2` work.
In fact, in the future, this syntax will likely replace the pre-vectorized methods of functions like `exp` and `log`, so that users will write `exp.(v)` to exponentiate a vector of values.
This may seem a little bit uglier, but it's more consistent than choosing an essentially arbitrarily set of functions to pre-vectorize, and as I'll explain below, this approach can also have significant performance benefits.

To give a more concrete sense of what this syntax can be used for, consider the `clip` function defined above for real arguments.
This scalar function can be applied to vectors using vectorized call syntax without any further method definitions:

```julia
julia> v = randn(10)
10-element Array{Float64,1}:
 -0.868996
  1.79301
 -0.309632
  1.16802
 -1.57178
 -0.223385
 -0.608423
 -1.54862
 -1.33672
  0.864448

julia> clip(v, -1, 1)
ERROR: MethodError: no method matching clip(::Array{Float64,1}, ::Int64, ::Int64)
Closest candidates are:
  clip{T<:Real}(::T<:Real, ::Real, ::Real) at REPL[2]:2

julia> clip.(v, -1, 1)
10-element Array{Float64,1}:
 -0.868996
  1.0
 -0.309632
  1.0
 -1.0
 -0.223385
 -0.608423
 -1.0
 -1.0
  0.864448
```

The second and third arguments don't need to be scalars – as with dotted operators, they can be vectors as well, and the `clip` operation will be applied to each corresponding triple of values:

```julia
julia> clip.(v, repmat([-1,0.5],5), repmat([-0.5,1],5))
10-element Array{Float64,1}:
 -0.868996
  1.0
 -0.5
  1.0
 -1.0
  0.5
 -0.608423
  0.5
 -1.0
  0.864448
```

From these examples, it may be unclear why this operation is called "`broadcast`".
The function gets its name from the following behavior:
wherever one of its arguments has a singleton dimension (i.e. dimension of size 1), it "broadcasts" that value along the corresponding dimension of the other arguments when applying the operator.
Broadcasting allows dotted operations to easily do handy tricks like mean-centering the columns of a matrix:

```julia
julia> A = rand(3,4);

julia> B = A .- mean(A,1)
3×4 Array{Float64,2}:
  0.343976   0.427378  -0.503356  -0.00448691
 -0.210096  -0.531489   0.168928  -0.128212
 -0.13388    0.104111   0.334428   0.132699

julia> mean(B,1)
1×4 Array{Float64,2}:
 0.0  0.0  0.0  0.0
```

The matrix `A` is 3×4 and `mean(A,1)` is 1×4 so the `.-` operator broadcasts the subtraction of each mean value along the corresponding column of A, thereby mean-centering each column.
Combining this broadcasting behavior with vectorized call syntax lets us write some fairly fancy custom array operations very concisely:

```julia
julia> clip.(B, [-0.3, -0.2, -0.1], [0.4, 0.3, 0.2, 0.1]')
3×4 Array{Float64,2}:
  0.343976   0.3       -0.3       -0.00448691
 -0.2       -0.2        0.168928  -0.128212
 -0.1        0.104111   0.2        0.1
```

This expression clips each element of `B` with its own specific `(hi,lo)` pair from this matrix:

```julia
julia> [(lo,hi) for lo=[-0.3, -0.2, -0.1], hi=[0.4, 0.3, 0.2, 0.1]]
3×4 Array{Tuple{Float64,Float64},2}:
 (-0.3,0.4)  (-0.3,0.3)  (-0.3,0.2)  (-0.3,0.1)
 (-0.2,0.4)  (-0.2,0.3)  (-0.2,0.2)  (-0.2,0.1)
 (-0.1,0.4)  (-0.1,0.3)  (-0.1,0.2)  (-0.1,0.1)
```

Vectorized call syntax avoids ever materializing this array of pairs, however, and the messy code to apply `clip` to each element of `B` with the corresponding `lo` and `hi` values doesn't have to be written.
When `B` is larger than a toy example, not constructing a temporary matrix of `(lo,hi)` pairs can be a big efficiency win.

There is a bit more to the story about vectorized call syntax.
It's common to write expressions applying multiple vectorized functions to some arrays.
For example, one might write something like:

```julia
max(abs(X), abs(Y))
```

This computes the absolute values of each element of `X` and `Y` and takes the larger of the corresponding elements from `abs(X)` and `abs(Y)`.
In this traditional vectorized form, the code allocates two temporary intermediate arrays – one to store each of `abs(X)` and `abs(Y)`.
If we use the new vectorized function call syntax, however, these calls are syntactically fused into a *single* call to `broadcast` with an anonymous function.
In other words, we write this:

```julia
max.(abs.(X), abs.(Y))
```

which internally becomes this:

```julia
broadcast((x, y)->max(abs(x), abs(y)), X, Y)
```

This version of the computation avoids allocating any intermediate arrays and performs the entire vectorized computation all at once, directly into the result array.
We can see this difference in memory usage and speed when we benchmark these expressions:

```julia
julia> using BenchmarkTools

julia> X, Y = rand(1000,1000), rand(1000,1000);

julia> @benchmark max(abs(X), abs(Y))
BenchmarkTools.Trial:
  memory estimate:  22.89 mb
  minimum time:     13.95 ms (1.77% GC)
  median time:      14.17 ms (1.76% GC)
  mean time:        14.32 ms (1.78% GC)
  maximum time:     17.15 ms (3.47% GC)

julia> @benchmark max.(abs.(X), abs.(Y))
BenchmarkTools.Trial:
  memory estimate:  7.63 mb
  minimum time:     2.84 ms (0.00% GC)
  median time:      2.98 ms (0.00% GC)
  mean time:        3.27 ms (18.26% GC)
  maximum time:     5.96 ms (65.68% GC)

julia> 22.89/7.63, 16.63/3.84
(3.0,4.330729166666667)
```

I'm using the [`BenchmarkTools`](https://github.com/JuliaCI/BenchmarkTools.jl) package here instead of hand-rolled timing loops. `BenchmarkTools` has been carefully designed to avoid many of the common pitfalls of benchmarking code and to provide sound statistical estimates of how much time and memory your code uses.
For the sake of brevity, I'm omitting some of the less relevant output from `@benchmark`.

As you can see, the dotted form uses 3 times less memory and is 4.3 times faster.
These improvements come from avoiding temporary allocations and performing the entire computation in a single pass over the arrays.
Even greater reduction in allocation can occur when we use the new `.=` operator to also do vectorized assignment:

```julia
julia> Z = zeros(X); # matrix of zeros similar to X

julia> @benchmark Z .= max.(abs.(X), abs.(Y))
BenchmarkTools.Trial:
  memory estimate:  96.00 bytes
  minimum time:     1.76 ms (0.00% GC)
  median time:      1.82 ms (0.00% GC)
  mean time:        1.89 ms (0.00% GC)
  maximum time:     4.24 ms (0.00% GC)
```

With in-place vectorized assignment, we can fill the pre-allocated array, `Z`, without doing any allocation (the 96 bytes is an artifact), and do so 7.3 times faster than the old-style vectorized computation.
This can be a big win in situations where we can reuse the same output array for multiple computations.

The last major missing piece of vectorized call syntax is yet to come – it will be implemented in the next version of Julia.
Dotted operators like `.+` and `.*` will cease to be their own independent operators and simply become the vectorized forms of the corresponding scalar operators, `+` and `*`.
In other words, instead of `.+` being a function as it is now, with its own behavior independent of `+`, when you write `X .+ Y` it will mean `broadcast(+, X, Y)`.
Furthermore, dotted operators will participate in the same syntax-level fusion as other vectorized calls, so an expression like `exp.(log.(X) .+ log.(Y))` will translate into a single call to broadcast:

```julia
broadcast((x, y)->exp(log(x) + log(y)), X, Y)
```

This change will complete the transition to a generalized approach to vectorized function application (including syntax-level loop fusion), which will make Julia's story for writing allocation-free array code much stronger.

## Comprehensions

Julia's array comprehensions have always supported some advanced features such as iterating with several variables to produce multidimensional arrays.
This release rounds out the functionality of comprehensions with two additional features: nested generation with multiple `for` clauses, and filtering with a trailing `if` clause.
To demonstrate these features, consider making a dollar (100¢) using quarters (25¢), dimes (10¢), nickels (5¢) and pennies (1¢).
We can generate an array of tuples of total values in each kind of coin by using a comprehension with nested `for` clauses:

```julia
julia> change = [(q,d,n,p) for q=0:25:100 for d=0:10:100-q for n=0:5:100-q-d for p=100-q-d-n]
242-element Array{NTuple{4,Int64},1}:
 (0,0,0,100)
 (0,0,5,95)
 (0,0,10,90)
 (0,0,15,85)
 (0,0,20,80)
 (0,0,25,75)
 ⋮
 (75,10,5,10)
 (75,10,10,5)
 (75,10,15,0)
 (75,20,0,5)
 (75,20,5,0)
 (100,0,0,0)
```

There are a few notable differences from the multidimensional array syntax:

- Each iteration is a new `for` clause, rather than a single compound iteration separated by commas;
- Each successive `for` clause *can* refer to variables from the previous clauses;
- The result is a single flat vector regardless of how many nested `for` clauses there are.

The tuple `(q,d,n,p)` in the comprehension body is a breakdown of monetary value into quarters, dimes, nickels and pennies.
Note that the iteration range for `p` isn't a range at all, it's a single value, `100-q-d-n`, the unique number guaranteeing that each tuple adds up to a dollar.
(This relies on the fact that a number behaves like an immutable zero-dimensional container, holding only itself, a behavior which is sometimes convenient but which has been the subject of significant debate.
As of 0.5 it still works.)
We can verify that each tuple adds up to 100:

```julia
julia> extrema([sum(t) for t in change])
(100,100)
```

Since 100 is both the minimum and maximum of all the tuple sums, we know they are all exactly 100.
So, there are 242 ways to make a dollar with common coins.
But suppose we want to ensure that the value in pennies is less than the value in nickels, and so forth.
By adding a filter clause, we can do this easily too:

```julia
julia> [(q,d,n,p) for q=0:25:100 for d=0:10:100-q for n=0:5:100-q-d for p=100-q-d-n if p < n < d < q]
4-element Array{NTuple{4,Int64},1}:
 (50,30,15,5)
 (50,30,20,0)
 (50,40,10,0)
 (75,20,5,0)
```

The only difference here is the `if p < n < d < q` clause at the end of the comprehension, which has the effect that the result only contains cases where this predicate holds true.
There are exactly four ways to make a dollar with strictly increasing value from pennies to nickels to dimes to quarters.

Nested and filtered comprehensions aren't earth-shattering features – everything you can do with them can be done in a variety of other ways – but they are expressive and convenient, found in other languages, and they allow you to try more things with your data quickly and easily, with less pointless refactoring.

## Generators

In the previous section we used an array comprehension to take the sum of each tuple, save the sums as an array, and then pass that array of sums to the `extrema` function to find the largest and smallest sum (they're all 100):

```julia
julia> @time extrema([sum(t) for t in change])
  0.000072 seconds (8 allocations: 2.203 KB)
(100,100)
```

Wrapping this in the `@time` macro shows that this expression allocates 2.2 KB of memory – mostly for the array of sums, which is thrown away after the computation.
But allocating an array just to find its extrema is unnecessary:
the minimum and maximum can be computed over streamed data by keeping the largest and smallest values seen so far.
In other words, this calculation could be expressed with constant memory overhead by interleaving the production of values with computation of extrema.
Previously, expressing this interleaved computation required some amount of refactoring, and many approaches were considerably less efficient.
In 0.5, if you simply omit the square brackets around an array comprehension, you get a *generator expression*, which instead of producing an array of values, can be iterated over, yielding one value at a time.
Since `extrema` works with arbitrary iterable objects – including generators – expressing an interleaved calculation using constant memory is now as simple as deleting `[` and `]`:

```julia
julia> @time extrema(sum(t) for t in change)
  0.000066 seconds (6 allocations: 208 bytes)
(100,100)
```

This avoids allocating a temporary array of sums entirely, instead computing the next tuple's sum only when the `extrema` function is ready to accept a new value.
Using a generator reduces the memory overhead to 208 bytes – the size of the the return value.
More importantly, the memory usage doesn't depend on the size of the `change` array anymore – it will always be just 208 bytes, even if `change` holds a trillion tuples.
It's not hard to imagine situations where such a reduction in asymptotic memory usage is crucial.
The similar syntax between array comprehensions and generator expressions makes it trivial to move back and forth between the two styles of computation as needed.

### Initializing collections

The new generator syntax dovetails particularly nicely with Julia's convention for constructing collections – to make a new collection, you call the constructor with a single iterable argument, which yields the values you want in the new collection.
In its simplest form, this looks something like:

```julia
julia> IntSet([1, 4, 9, 16, 25, 36, 49, 64])
IntSet([1, 4, 9, 16, 25, 36, 49, 64])
```

In this expression, an array of integers is passed to the `IntSet` constructor to create an object representing that set, which in this case happen to be small squares.
Once constructed, the `IntSet` object no longer refers to the original array of integers.
Instead, it uses a bitmask to efficiently store and operate on sets.
It displays itself as you would construct it from an array, but that's merely for convenience – there's no actual array anymore.

Now, I'm a human (no blogbots here) and I find typing out even short sequences of perfect squares tedious and error prone – despite a math degree, I'm awful at arithmetic.
It would be much easier to generate squares with an array comprehension:

```julia
julia> IntSet([k^2 for k = 1:8])
IntSet([1, 4, 9, 16, 25, 36, 49, 64])
```

This comprehension produces the same array of integers that I typed manually above.
As before, creating this array object is unnecessary – it would be even better to generate the desired squares as they are inserted into the new `IntSet`.
Which, of course, is precisely what generator expressions allow:

```julia
julia> IntSet(k^2 for k = 1:8)
IntSet([1, 4, 9, 16, 25, 36, 49, 64])
```

Using a generator here is just as clear, more concise, and significantly more efficient:

```julia
julia> using BenchmarkTools

julia> @benchmark IntSet([k^2 for k = 1:8])
BenchmarkTools.Trial:
  memory estimate:  320.00 bytes
  minimum time:     163.00 ns (0.00% GC)
  median time:      199.00 ns (0.00% GC)
  mean time:        245.18 ns (12.95% GC)
  maximum time:     5.36 μs (92.47% GC)

julia> @benchmark IntSet(k^2 for k = 1:8)
BenchmarkTools.Trial:
  memory estimate:  160.00 bytes
  minimum time:     114.00 ns (0.00% GC)
  median time:      139.00 ns (0.00% GC)
  mean time:        165.74 ns (11.48% GC)
  maximum time:     4.82 μs (93.20% GC)
```

As you can see from this benchmark, the version with an array comprehension uses twice as much memory and is 50% slower than constructing the same `IntSet` using a generator expression.

#### Constructing dictionaries

Generators can be used to construct dictionaries too, and this use case deserves some special attention since it completes a multi-release process of putting user-defined dictionary types on an equal footing with the built-in `Dict` type.
In Julia 0.3, the `=>` operator only existed as part of syntax for constructing `Dict` objects:
`[k₁ => v₁, k₂ => v₂]` and `[k(i) => v(i) for i = c]`.
This design was based on other dynamic languages where dictionaries are among a small set of built-in types with special syntax that are deeply integrated into the language.
As Julia's ecosystem has matured, however, it has become apparent that Julia is actually more like Java or C++ in this respect than it is like Python or Lua: the `Dict` type isn't that special – it happens to be defined in the standard library, but is otherwise quite ordinary.
Many programs use other dictionary implementations: for example, the tree-based `SortedDict` type, which sorts values by key, or `OrderedDict`, which maintains keys in the order they are inserted.
Having special syntax only for `Dict` makes using other dictionary implementations problematic.
In 0.3, there was no good syntax for constructing values of these dictionaries – the best one could do was to invoke a constructor with an array of two-tuples:

```julia
SortedDict([(k₁, v₁), (k₂, v₂)])        # fixed-size dictionaries
SortedDict([(k(i), v(i)) for i in c])   # dictionary comprehensions
```

Not only are these constructions inconvenient and ugly, they're also inefficient since they create temporary heap-allocated arrays of heap-allocated tuples of key-value pairs.
With much relief, we can now instead write:

```julia
SortedDict(k₁ => v₁, k₂ => v₂)          # fixed-size dictionaries, since 0.4
SortedDict(k(i) => v(i) for i = c)      # dictionary comprehensions, since 0.5
```

This last syntax combines two orthogonal features introduced in 0.4 and 0.5, respectively:

- `k => v` as a standalone syntax for a `Pair` object, and
- generator expressions, particularly to initialize collections.

The `Dict` type is now constructed in exactly the same way:

```julia
julia> Dict("foo" => 1, "bar" => 2)
Dict{String,Int64} with 2 entries:
  "bar" => 2
  "foo" => 1

julia> Dict("*"^k => k for k = 1:10)
Dict{String,Int64} with 10 entries:
  "**********" => 10
  "***"        => 3
  "*******"    => 7
  "********"   => 8
  "*"          => 1
  "**"         => 2
  "****"       => 4
  "*********"  => 9
  "*****"      => 5
  "******"     => 6
```

This generalization makes the syntax for constructing a `Dict` slightly longer, but we feel that the increased consistency, ability to change dictionary implementations with a simple search-and-replace, and putting user-defined dictionary-like types on the same level as the built-in `Dict` type make this change well worthwhile.

## Arrays

The 0.5 release was originally intended to include a large number of disruptive array changes, collectively dubbed "Arraymageddon".
After much discussion, experimentation and benchmarking, this set of breaking changes was significantly reduced for a variety of reasons:

- Some changes were deemed not to be good ideas after all;
- Others were of unclear benefit, so it was decided to reconsider them in the future once there is more information to support a decision;
- A few didn't get implemented due to lack of developer time, including some cases where everyone agrees there's a problem but there is not yet any complete design for a solution.

Although not many breaking changes happened in 0.5, this was a major release for Julia's array infrastructure.
The code to implement various complex polymorphic indexing operations for generic arrays and array-like structures was majorly refactored, and in the process it shrank by 40% while becoming more complete, more general, and faster.
You can read more about the very cool things you can now do with array-like types in an excellent pair of blog posts published here earlier in the year: [*Multidimensional algorithms and iteration*](/blog/2016/02/multidimensional-algorithms-and-iteration/) and [*Generalizing AbstractArrays*](/blog/2016/03/generalizing-abstractarrays-opportunities-and-challenges/).
In the next two subsections, I'll go over some of the array changes that did happen in 0.5.

### Dimension sum slices

The most significant breaking change in the 0.5 cycle affects multidimensional array slicing.
To explain it we'll need a little terminology.
A *singleton dimension* of a multidimensional array is a dimension whose size is 1.
For example, a 5x1 matrix has a trailing singleton dimension and may be called a "column matrix", and a 1x5 matrix has a leading singleton dimension and may be called a "row matrix".
A *scalar slice* refers to a dimension in a multidimensional slice expression where the index is a scalar integer (considered to be zero-dimensional), rather than a 1-dimensional range or vector, or some higher-dimensional collection of indices.
For example, in `A[1,:]` the first slice is scalar, the second is not; in `A[:,2]` the second slice is scalar, the first is not; in `A[3,4]` both slices are scalar.

All previous versions of Julia have dropped trailing scalar slices when performing multidimensional array slicing.
That is, when an array was sliced with multiple indices, the resulting array had the number of dimensions of the original array minus the number of trailing scalar slices.
So when you sliced a column out of a matrix the result was a 1-dimensional vector, but when you sliced a row the result was a 2-dimensional row matrix:

```julia
julia> VERSION
v"0.4.7"

julia> M = [i+j^2 for i=1:3, j=1:4]
3x4 Array{Int64,2}:
 2  5  10  17
 3  6  11  18
 4  7  12  19

julia> M[:,1] # vector
3-element Array{Int64,1}:
 2
 3
 4

julia> M[3,:] # row matrix
1x4 Array{Int64,2}:
 4  7  12  19
```

This rule is handy for linear algebra since row and column slices have distinct types and different orientations, but its complexity, asymmetry, and lack of generality make it less than ideal for arrays as general purpose containers.
With more dimensions, the asymmetry of this behavior can be seen even in a single slice operation:

```julia
julia> VERSION
v"0.4.7"

julia> T = [i+j^2+k^3 for i=1:3, j=1:4, k=1:2]
3x4x2 Array{Int64,3}:
[:, :, 1] =
 3  6  11  18
 4  7  12  19
 5  8  13  20

[:, :, 2] =
 10  13  18  25
 11  14  19  26
 12  15  20  27

julia> T[2,:,2]
1x4 Array{Int64,2}:
 11  14  19  26
```

The leading dimension of this slice is retained while the trailing dimension is discarded – even though both are scalar slices.
The result array is neither 3-dimensional like the original, nor 1-dimensional like the collective indexes (0 + 1 + 0); instead, it's 2-dimensional – apropos of nothing.
Here, in another fairly similar slice, all dimensions are kept:

```julia
julia> T[:,4,:]
3x1x2 Array{Int64,3}:
[:, :, 1] =
 18
 19
 20

[:, :, 2] =
 25
 26
 27
```

By comparison, the new slicing behavior in 0.5 is simple, systematic, and symmetrical.
(And not original by any means – APL pioneered this array slicing scheme in the 1960s.)
In Julia 0.5, when an array is sliced, the dimension of the result is the sum of the dimensions of the slices, and the dimension sizes of the result are the concatenation of the sizes of the slices.
Thus, row slices and column slices both produce vectors:

```julia
julia> VERSION
v"0.5.0"

julia> M[:,1] # vector: 1 + 0 = 1
3-element Array{Int64,1}:
 2
 3
 4

julia> M[1,:] # vector: 0 + 1 = 1
4-element Array{Int64,1}:
  2
  5
 10
 170
```

Similarly, slicing a 3-dimensional array with scalars in all but one dimension also produces a vector:

```julia
julia> T[2,:,2] # vector: 0 + 1 + 0 = 1
4-element Array{Int64,1}:
 11
 14
 19
 26
```

The only example from above that doesn't produce a vector is the last one:

```julia
julia> T[:,4,:] # matrix: 1 + 0 + 1 = 2
3×2 Array{Int64,2}:
 18  25
 19  26
 20  27
```

The result is a matrix since the leading and trailing slices are ranges, and the middle slice disappears since it is scalar, leaving a matrix.
The 0.5 slicing behavior naturally generalizes to higher dimensional slices:

```julia
julia> I = [1 2 1; 1 3 2]
2×3 Array{Int64,2}:
 1  2  1
 1  3  2

julia> J = [4 2 1 3]
1×4 Array{Int64,2}:
 4  2  1  3

julia> M[I,J]
2×3×1×4 Array{Int64,4}:
[:, :, 1, 1] =
 17  18  17
 17  19  18

[:, :, 1, 2] =
 5  6  5
 5  7  6

[:, :, 1, 3] =
 2  3  2
 2  4  3

[:, :, 1, 4] =
 10  11  10
 10  12  11
```

Here we have the following natural identity on dimensions:

```julia
size(M[I,J]) == (size(I,1), size(I,2), size(J,1), size(J,2))
```

In addition to being more systematic and symmetrical, this new behavior allows many complex indexing operations to be expressed concisely.

Although the change to multidimensional slicing behavior is a significant breaking change, it has caused surprisingly little havoc in the Julia package ecosystem.
It tends to primarily affect linear algebra code, and when code does break, it's usually fairly clear what is broken and what needs to be done to fix it.
When updating your code, if you need to keep a dimension that is dropped under the new indexing behavior, you can write `M[1:1,:]`:

```julia
julia> M[1:1,:]
1×4 Array{Float64,2}:
 0.950951  0.713032  0.0835119  0.897018
```

Since integer range construction can be eliminated by Julia's compiler, writing this is free but has the effect of keeping a dimension which would otherwise be dropped under the new rules.
Unfortunately, there's no way to make this change without breaking some code – we apologize in advance for the inconvenience, and we hope you find the improvement to be worthwhile.

### Array views

One of the major news items of 0.5 is a non-change:
array slices still create copies of array data.
There was a lot of discussion about changing the default behavior to creating views, but we ended up deciding against this change and keeping the old behavior.
The motivation for views by default was to improve performance drastically in a variety of slow cases, but after a lot of discussion, experiments, and benchmarks, it was decided not to make this change.
The conversation about this decision is long, so I'll summarize the major points:

- Slicing should either consistently produce views or copies.
  Unpredictably doing one or the other depending on types – or worse still, on runtime values – would be a disaster for writing reliable, generic code.

- Guaranteeing view semantics for all abstract arrays – especially sparse and custom array types – is hard and can be quite slow and/or expensive in general cases.

- Even in the case of dense arrays with cheap array views, it's not clear that views are always a performance win.

  In some cases they definitely are, but in others the fact that a copied slice is contiguous and has optimal memory ordering for iteration overwhelms the benefit of not copying.

- Copied slices are easier to reason about and less likely to lead to subtle bugs than views.

  Views can lead to situations where someone modifies the view, not realizing that it's a view, thereby unintentionally modifying the original array.

  These kinds of bugs are hard to track down and even harder to notice.

- There is no clear transition or deprecation strategy.

  Changing from copying slices to views would be a major compatibility issue.
  We generally give programmers deprecation warnings when some behavior is going to break or change in the next release.
  Sometimes we can't do that so we just bite the bullet and break code with an error. But changing slices to views wouldn't break code with an error, it would just silently cause code to produce different, incorrect results.
  There's no clear way to make this transition safely.

Taken together this makes a compelling case against changing the default slicing behavior to returning views.
That said, even if they're not the default, views are a crucial tool for performance in some situations.
Accordingly, a huge amount of work went into improving the ergonomics of views in 0.5, including:

- Renaming the function for view construction from "`sub`" to "`view`", which seems like a much better name.

- Array views now support all forms of indexing supported by arrays.
  Previously, views did not support some of the more complex forms of array indexing.

- The `@view` macro was introduced, allowing the use of natural slicing syntax for views.

  In other words you can now write `@view A[1:end-1,2:end]` instead of `view(A, 1:size(A,1)-1, 2:size(A,2))`.

Since views are an such important tool for both performance and for expressing complex mutating operations on arrays (especially with higher order functions), we may introduce a special syntax for view slices in the future.
In particular, the syntax `A@[I...]` had a fair amount of popular support.
Stay tuned!

## And more...

This is far from the full extent of the improvements introduced in Julia 0.5, but this blog post is already getting quite long, so I'll just summarize a few of the other big ticket items:

- The set of string types and operations has been significantly simplified and streamlined.

  The `ASCIIString` and `UTF8String` types have been merged into a single `String` type, and the `UTF16String` and `UTF32String` and related functions have been moved into the [`LegacyStrings`](https://github.com/JuliaArchive/LegacyStrings.jl) package, which keeps the same implementations as 0.4.

  In the future, better support for different string encodings will be developed under the [`StringEncodings`](https://github.com/nalimilan/StringEncodings.jl) package.

- Most functionality related to prime generation, primality checking and combinatorics, has been moved into two external packages: [`Primes`](https://github.com/JuliaMath/Primes.jl) and [`Combinatorics`](https://github.com/JuliaMath/Combinatorics.jl).
  To use these functions, you'll need to install these packages and do `using Primes` or `using Combinatorics` as necessary.

- Julia's LLVM version was upgraded from 3.3 to 3.7.1.
  This may not seem like a big deal, but the transition required herculean effort by many core Julia contributors.
  For a series of different and impossibly annoying reasons, LLVM versions 3.4, 3.5 and 3.6 were not usable for Julia, so we're very happy to be back to using current versions of our favorite compiler framework.

- Support for compiling and running on [ARM] chips is much improved since 0.4.
  Julia 0.5 also introduced initial support for [Power] systems, a development which has been supported and driven by IBM.
  We will be expanding and improving support for many architectures going forward.
  With support for ARM and Power, Julia is already a productive platform for technical computing from embedded systems to big iron.

[ARM]: https://en.wikipedia.org/wiki/ARM_architecture
[Power]: https://en.wikipedia.org/wiki/Power_Architecture

- The 0.5 release has experimental multithreading support.
  This isn't ready for production usage, but it's fun to play around with and you can already get impressive performance gains – scalability is a key focus.
  Julia's threading provides true concurrent execution like C++, Go or Java: different threads can do work at the same time, up to the number of physical cores available.

- Interactive debugging support has been a weak spot in the Julia ecosystem for some time, but not any more.

  On a vanilla build of Julia 0.5, you can install the [`Gallium`](https://github.com/Keno/Gallium.jl) package to get a full-fledged, high-performance debugger:

  set breakpoints, step through code, examine variables, and inspect stack frames.

I hope you've enjoyed this overview of highlights from the new release of Julia, and that you enjoy the release itself even more.
Julia 0.5 is easily the strongest release to date, but of course the next one will be even better :)

Happy coding!
