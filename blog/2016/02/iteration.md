@def rss_pubdate = Date(2016, 2, 1)
@def rss = """ Multidimensional algorithms and iteration | Julia makes it easy to write elegant and... """
@def published = "1 February 2016"
@def title = "Multidimensional algorithms and iteration"
@def authors = """ <a href="http://holylab.wustl.edu">Tim Holy</a>"""
@def hascode = true

**Note: updated December 2018 for Julia 1.1**

**Note: updated April 2020 for clarity**

Julia makes it easy to write elegant and
efficient multidimensional algorithms. The new capabilities rest on
two foundations: an iterator called `CartesianIndices`, and
sophisticated array indexing mechanisms.  Before I explain, let me
emphasize that developing these capabilities was a collaborative
effort, with the bulk of the work done by Matt Bauman (@mbauman),
Jutho Haegeman (@Jutho), and myself (@timholy).

These iterators are deceptively simple: just a few principles bring a
world of power in writing multidimensional algorithms.  However, like
many simple concepts, the implications can take a while to sink in.
It's also possible to confuse these techniques with
[`Base.Cartesian`](https://docs.julialang.org/en/latest/devdocs/cartesian/),
which is a completely different (and more painful) approach to
solving the same problem.  There are still a few occasions where
`Base.Cartesian` is helpful or necessary, but for many problems these new
capabilities represent a vastly simplified approach.

Let's introduce these iterators with an extension of an example taken
from the
[manual](https://docs.julialang.org/en/latest/manual/arrays/#Iteration-1).

# eachindex, CartesianIndex, and CartesianIndices

There are two recommended "default" ways to iterate over the elements in an
[`AbstractArray`](https://docs.julialang.org/en/v1.4/manual/arrays/):
if you don't need an index associated with each element, then you can use

```
for a in A    # A is an AbstractArray
    # Code that does something with the element a
end
```

If instead you also need the index, then use

```
for i in eachindex(A)
    # Code that does something with i and/or A[i]
end
```

In some cases, the first line of this loop expands to `for i =
1:length(A)`, and `i` is just an integer.  However, in other cases,
this will expand to the equivalent of

```
for i in CartesianIndices(A)
    # i is now a CartesianIndex
    # Code that does something with i and/or A[i]
end
```

You can see for yourself what this does with the following:

```
julia> A = rand(3,2)

julia> for i in CartesianIndices(A)
          @show i
       end
i = CartesianIndex(1, 1)
i = CartesianIndex(2, 1)
i = CartesianIndex(3, 1)
i = CartesianIndex(1, 2)
i = CartesianIndex(2, 2)
i = CartesianIndex(3, 2)
```

A `CartesianIndex{N}` represents an `N`-dimensional index.
`CartesianIndex`es are based on tuples, and indeed you can access the
underlying tuple with `Tuple(i)`.

A `CartesianIndices` acts like an array of `CartesianIndex` values:

```
julia> iter = CartesianIndices(A)
3×2 CartesianIndices{2,Tuple{Base.OneTo{Int64},Base.OneTo{Int64}}}:
 CartesianIndex(1, 1)  CartesianIndex(1, 2)
 CartesianIndex(2, 1)  CartesianIndex(2, 2)
 CartesianIndex(3, 1)  CartesianIndex(3, 2)

julia> supertype(typeof(iter))
AbstractArray{CartesianIndex{2},2}
```

As a consequence `iter[2,2]` and `iter[5]` both return `CartesianIndex(2, 2)`; indeed,
the latter is the recommended way to convert
from a [linear index](https://docs.julialang.org/en/latest/devdocs/subarrays/#Indexing:-cartesian-vs.-linear-indexing-1) to a multidimensional cartesian index.

However, internally `iter` is just a wrapper around the `axes` range for each dimension:

```
julia> iter.indices
(Base.OneTo(3), Base.OneTo(2))
```

As a consequence, in many applications the creation and usage of these objects has
little or no overhead.

You can construct these manually: for example,

```
julia> CartesianIndices((-7:7, 0:15))
15×16 CartesianIndices{2,Tuple{UnitRange{Int64},UnitRange{Int64}}}:
# remaining output suppressed
```

corresponds to an iterator that will loop over `-7:7` along the first
dimension and `0:15` along the second.

One reason that `eachindex` is recommended over `for i = 1:length(A)`
is that some `AbstractArray`s cannot be indexed efficiently with a
linear index; in contrast, a much wider class of objects can be
efficiently indexed with a multidimensional iterator.  (SubArrays are,
generally speaking, [a prime
example](https://docs.julialang.org/en/latest/devdocs/subarrays).)
`eachindex` is designed to pick the most efficient iterator for the
given array type.  You can even use

```
for i in eachindex(A, B)
    ...
```

to increase the likelihood that `i` will be efficient for accessing
both `A` and `B`.  (A second reason to use `eachindex` is that some arrays
don't starting indexing at 1, but that's a topic for a separate
[blog post](/blog/2017/04/offset-arrays).)

As we'll see below, these iterators have another purpose: independent
of whether the underlying arrays have efficient linear indexing,
multidimensional iteration can be a powerful ally when writing
algorithms.  The rest of this blog post will focus on this
latter application.

# Writing multidimensional algorithms with CartesianIndex iterators

## A multidimensional boxcar filter

Let's suppose we have a multidimensional array `A`, and we want to
compute the ["moving
average"](https://en.wikipedia.org/wiki/Boxcar_averager) over a
3-by-3-by-... block around each element.  From any given index position,
we'll want to sum over a region offset by `-1:1` along each dimension.
Edge positions have to be treated specially, of course, to avoid going
beyond the bounds of the array.

In many languages, writing a general (N-dimensional) implementation of
this conceptually-simple algorithm is somewhat painful, but in Julia
it's a piece of cake:

```
function boxcar3(A::AbstractArray)
    out = similar(A)
    R = CartesianIndices(A)
    Ifirst, Ilast = first(R), last(R)
    I1 = oneunit(Ifirst)
    for I in R
        n, s = 0, zero(eltype(out))
        for J in max(Ifirst, I-I1):min(Ilast, I+I1)
            s += A[J]
            n += 1
        end
        out[I] = s/n
    end
    out
end
```

(Note that this example is only for Julia versions 1.1 and higher.)

Let's walk through this line by line:

- `out = similar(A)` allocates the output. In a "real" implementation,
  you'd want to be a little more careful about the element type of the
  output (what if the input array element type is `Int`?), but
  we're cutting a few corners here for simplicity.

- `R = CartesianIndices(A)` creates the iterator for the array. Assuming `A`
  starts indexing at 1, this ranges from `CartesianIndex(1, 1, 1, ...)` to
  `CartesianIndex(size(A,1), size(A,2), size(A,3), ...)`.  We don't
  use `eachindex`, because we can't be sure whether that will return a
  `CartesianIndices` iterator, and here we explicitly need one.

- `Ifirst = first(R)` and `Ilast = last(R)` return the lower
  (`CartesianIndex(1, 1, 1, ...)`) and upper
  (`CartesianIndex(size(A,1), size(A,2), size(A,3), ...)`) bounds
  of the iteration range, respectively.  We'll use these to ensure
  that we never access out-of-bounds elements of `A`.

- `I1 = oneunit(Ifirst)` creates an all-1s `CartesianIndex` with the same
  dimensionality as `Ifirst`. We'll use this in arithmetic operations to
  define a region-of-interest.

- `for I in R`: here we loop over each entry of `R`, corresponding to both
  `A` and `out`.

- `n = 0` and `s = zero(eltype(out))` initialize the accumulators. `s`
  will hold the sum of neighboring values. `n` will hold the number of
  neighbors used; in most cases, after the loop we'll have `n == 3^N`,
  but for edge points the number of valid neighbors will be smaller.

- `for J in max(Ifirst, I-I1):min(Ilast, I+I1)` is
  probably the most "clever" line in the algorithm.  `I-I1` is a
  `CartesianIndex` that is lower by 1 along each dimension, and `I+I1`
  is higher by 1.
  However, when `I` represents an edge point, either `I-I1` or `I+I1`
  (or both) might be out-of-bounds.  `max(Ifirst, I-I1)` ensures that each
  coordinate of `J` is 1 or larger, while `min(Ilast, I+I1)` ensures
  that `J[d] <= size(A,d)`.

  Putting these two together with a colon, `Ilower:Iupper`,
  creates a `CartesianIndices` object that serves as an iterator.

- The inner loop accumulates the sum in `s` and the number of visited
  neighbors in `n`.

- Finally, we store the average value in `out[I]`.

Not only is this implementation simple, it is also surprisingly robust:
for edge points it computes the average of whatever nearest-neighbors
it has available.  It even works if `size(A, d) < 3` for some
dimension `d`; we don't need any error checking on the size of `A`.

## Computing a reduction

For a second example, consider the implementation of multidimensional
*reductions*. A reduction takes an input array, and returns an array
(or scalar) of smaller size.  A classic example would be summing along
particular dimensions of an array: given a three-dimensional array,
you might want to compute the sum along dimension 2, leaving
dimensions 1 and 3 intact.

### The core algorithm

An efficient way to write this algorithm requires that the output
array, `B`, is pre-allocated by the caller (later we'll see how one
might go about allocating `B` programmatically).  For example, if the
input `A` is of size `(l,m,n)`, then when summing along just dimension
2 the output `B` would have size `(l,1,n)`.

Given this setup, the implementation is shockingly simple:

```
function sumalongdims!(B, A)
    # It's assumed that B has size 1 along any dimension that we're summing,
    # and otherwise matches A
    fill!(B, 0)
    Bmax = last(CartesianIndices(B))
    for I in CartesianIndices(A)
        B[min(Bmax,I)] += A[I]
    end
    B
end
```

The key idea behind this algorithm is encapsulated in the single
statement `B[min(Bmax,I)]`.  For our three-dimensional example where
`A` is of size `(l,m,n)` and `B` is of size `(l,1,n)`, the inner loop
is essentially equivalent to

```
B[i,1,k] += A[i,j,k]
```

because `min(1,j) = 1`.

### The wrapper, and handling type-instability using function barriers

As a user, you might prefer an interface more like `sumalongdims(A,
dims)` where `dims` specifies the dimensions you want to sum along.
`dims` might be a single integer, like `2` in our example above, or
(should you want to sum along multiple dimensions at once) a tuple or
`Vector{Int}`.  This is indeed the interface used in `sum(A; dims=dims)`;
here we want to write our own (somewhat simpler) implementation.

One possible bare-bones implementation of the wrapper looks like this:

```
function sumalongdims(A, dims)
    sz = [size(A)...]
    sz[[dims...]] .= 1
    B = Array{eltype(A)}(undef, sz...)
    sumalongdims!(B, A)
end
```

Obviously, this simple implementation skips all relevant error
checking.  However, here the main point I wish to explore is that the
allocation of `B` turns out to be
[non-inferrable](https://docs.julialang.org/en/latest/manual/faq/#man-type-stability-1):
`sz` is a `Vector{Int}`, the length (number of elements) of a specific
`Vector{Int}` is not encoded by the type itself, and therefore the
dimensionality of `B` cannot be inferred.

Now, we could fix that in several ways, for example by annotating the
result:

```
B = Array{eltype(A)}(undef, sz...)::Array{eltype(A),ndims(A)}
```

or by using an implementation that *is* inferrable:

```
function sumalongdims(A, dims)
    sz = ntuple(i->i ∈ dims ? 1 : size(A, i), Val(ndims(A)))
    B = Array{eltype(A)}(undef, sz...)
    sumalongdims!(B, A)
end
```

However, here we want to emphasize that this design — having a separate
`sumalongdims!` from `sumalongdims` — often mitigates the worst aspects
of inference problems. This trick, using a [function-call to separate a
performance-critical step from a potentially type-unstable
precursor](https://docs.julialang.org/en/latest/manual/performance-tips/#kernel-functions-1),
is sometimes referred to as introducing a *function barrier*.
It allows Julia's compiler to generate a well-optimized version of
`sumalongdims!` even if the intermediate type of `B` is not known.

As a general rule, when writing multidimensional code you should
ensure that the main iteration is in a separate function from
type-unstable precursors.  (In older versions of Julia, you might see
kernel functions annotated with `@noinline` to prevent the
inliner from combining the two back together, but for more recent
versions of Julia this should no longer be necessary.)

Of course, in this example there's a second motivation for making this
a standalone function: if this calculation is one you're going to
repeat many times, re-using the same output array can reduce the
amount of memory allocation in your code.

## Filtering along a specified dimension (exploiting multiple indexes)

One final example illustrates an important new point: when you index
an array, you can freely mix `CartesianIndex`es and
integers.  To illustrate this, we'll write an [exponential
smoothing
filter](https://en.wikipedia.org/wiki/Exponential_smoothing).  An
efficient way to implement such filters is to have the smoothed output
value `s[i]` depend on a combination of the current input `x[i]` and
the previous filtered value `s[i-1]`; in one dimension, you can write
this as

```
function expfilt1!(s, x, α)
    0 < α <= 1 || error("α must be between 0 and 1")
    s[1] = x[1]
    for i = 2:length(x)
        s[i] = α*x[i] + (1-α)*s[i-1]
    end
    s
end
```

This would result in an approximately-exponential decay with timescale `1/α`.

Here, we want to implement this algorithm so that it can be used to
exponentially filter an array along any chosen dimension.  Once again,
the implementation is surprisingly simple:

```
function expfiltdim(x, dim::Integer, α)
    s = similar(x)
    Rpre = CartesianIndices(size(x)[1:dim-1])
    Rpost = CartesianIndices(size(x)[dim+1:end])
    _expfilt!(s, x, α, Rpre, size(x, dim), Rpost)
end

function _expfilt!(s, x, α, Rpre, n, Rpost)
    for Ipost in Rpost
        # Initialize the first value along the filtered dimension
        for Ipre in Rpre
            s[Ipre, 1, Ipost] = x[Ipre, 1, Ipost]
        end
        # Handle all other entries
        for i = 2:n
            for Ipre in Rpre
                s[Ipre, i, Ipost] = α*x[Ipre, i, Ipost] + (1-α)*s[Ipre, i-1, Ipost]
            end
        end
    end
    s
end
```

Note once again the use of the function barrier technique.  In the
core algorithm (`_expfilt!`), our strategy is to use *two*
`CartesianIndex` iterators, `Ipre` and `Ipost`, where the first covers
dimensions `1:dim-1` and the second `dim+1:ndims(x)`; the filtering
dimension `dim` is handled separately by an integer-index `i`.
Because the filtering dimension is specified by an integer input,
there is no way to infer how many entries will be within each
index-tuple `Ipre` and `Ipost`.  Hence, we compute the `CartesianIndices`s in
the type-unstable portion of the algorithm, and then pass them as
arguments to the core routine `_expfilt!`.

What makes this implementation possible is the fact that we can index
`x` as `x[Ipre, i, Ipost]`.  Note that the total number of indexes
supplied is `(dim-1) + 1 + (ndims(x)-dim)`, which is just `ndims(x)`.
In general, you can supply any combination of integer and
`CartesianIndex` indexes when indexing an `AbstractArray` in Julia.

The [AxisAlgorithms](https://github.com/timholy/AxisAlgorithms.jl)
package makes heavy use of tricks such as these, and in turn provides
core support for high-performance packages like
[Interpolations](https://github.com/JuliaMath/Interpolations.jl) that
require multidimensional computation.

# Additional issues

## Cache-efficiency

It's worth noting one point that has thus far remained unstated: all
of the examples here are relatively *cache efficient*.  This is a key
property to observe when writing [efficient code](/blog/2013/09/fast-numeric/). In particular, julia arrays are stored in first-to-last dimension order (for matrices, "column-major" order), and hence you should nest
iterations from last-to-first dimensions.  For example, in the filtering example above we were careful to iterate in the order

```
for Ipost ...
    for i ...
        for Ipre ...
            x[Ipre, i, Ipost] ...
```

so that `x` would be traversed in memory-order.

## Broadcasting

`CartesianIndex`es are *not* broadcastable:

```
julia> I = CartesianIndex(2, 7)
CartesianIndex(2, 7)

julia> I .+ 1
ERROR: iteration is deliberately unsupported for CartesianIndex. Use `I` rather than `I...`, or use `Tuple(I)...`
Stacktrace:
 [1] error(::String) at ./error.jl:33
 [2] iterate(::CartesianIndex{2}) at ./multidimensional.jl:154
...
```

When you want to perform broadcast arithmetic, just extract the underlying tuple:

```
julia> Tuple(I) .+ 1
(3, 8)
```

If desired you can package this back up in a `CartesianIndex`, or just
use it directly (with splatting) for indexing.
The compiler optimizes all these operations away, so there is no actual
"cost" to constucting objects in this way.

Why is iteration disallowed? One reason is to support the following:

```
julia> R = CartesianIndices((1:3, 1:3))
3×3 CartesianIndices{2,Tuple{UnitRange{Int64},UnitRange{Int64}}}:
 CartesianIndex(1, 1)  CartesianIndex(1, 2)  CartesianIndex(1, 3)
 CartesianIndex(2, 1)  CartesianIndex(2, 2)  CartesianIndex(2, 3)
 CartesianIndex(3, 1)  CartesianIndex(3, 2)  CartesianIndex(3, 3)

julia> R .+ CartesianIndex(2, 17)
3×3 CartesianIndices{2,Tuple{UnitRange{Int64},UnitRange{Int64}}}:
 CartesianIndex(3, 18)  CartesianIndex(3, 19)  CartesianIndex(3, 20)
 CartesianIndex(4, 18)  CartesianIndex(4, 19)  CartesianIndex(4, 20)
 CartesianIndex(5, 18)  CartesianIndex(5, 19)  CartesianIndex(5, 20)
```

The underlying idea is that `CartesianIndex(2, 17)` needs to act, everywhere,
like a pair of scalar indexes; consequently, a `CartesianIndex` has to be
viewed as a single (scalar) entity, rather than as a container in its own right.

# Summary

As is hopefully clear by now, much of the pain of writing generic
multidimensional algorithms is eliminated by Julia's elegant
iterators.  The examples here just scratch the surface, but the
underlying principles are very simple; it is hoped that these
examples will make it easier to write your own algorithms.
