---
layout: post
title:  "Generalizing AbstractArrays: opportunities and challenges"
author: <a href="http://holylab.wustl.edu">Tim Holy</a>
---

# Introduction: generic algorithms with AbstractArrays

Somewhat unusually, this blog post is future-looking: it mostly
focuses on things that don't yet exist. Its purpose is to lay out the
background for community discussion about possible changes to the core
API for `AbstractArray`s, and serves as background reading and
reference material for a more focused "julep" (a julia enhancement
proposal).  Here, often I'll use the shorthand "array" to mean
`AbstractArray`, and use `Array` if I explicitly mean julia's concrete
`Array` type.

As the reader is likely aware, in julia it's possible to write
algorithms for which one or more inputs are only assumed to be
`AbstractArray`s.  This is "generic" code, meaning it should work
(i.e., produce a correct result) on any specific concrete array type.
In an ideal world---which julia approaches rather well in many
cases---generality of code should not have a negative impact on its
performance: a generic implementation should be approximately as fast
as one restricted to specific array type(s).  This implies that
generic algorithms should be written using lower-level operations that
give good performance across a wide variety of array types.

Providing efficient low-level operations is a different kind of design
challenge than one experiences with programming languages that
"vectorize" everything.  When successful, it promotes much greater
reuse of code, because efficient, generic low-level parts allow you to
write a wide variety of efficient, generic higher-level functions.

Naturally, as the diversity of array types grows, the more careful we
have to be about our abstractions for these low-level operations.

# Examples of arrays

In discussing general operations on arrays, it's useful to have a
diverse collection of concrete arrays in mind.

In core julia, some types we support fairly well are:

- `Array`: the prototype for all arrays

- `Range`s: a good example of what I often consider a "computed"
  array, where essentially none of the values are stored in
  memory. Since there is no storage, these are immutable containers:
  you can't set values in individual slots.

- `BitArray`s: arrays that can only store 0 or 1 (`false` or `true`),
  and for which the internal storage is packed so that each entry
  requires only one bit.

- `SubArray`s: the problems this type introduced, and the resolution
  we adopted, probably serves as the best model for the
  generalizations considered here. Therefore, this case is discussed
  in greater detail below.

Another important class of array types in Base are sparse arrays:
`SparseMatrixCSC` and `SparseVector`, as well as other sparse
representations like `Diagonal`, `Bidiagonal`, and `Tridiagonal`.
These are good examples of array types where access patterns deserve
careful thought. Notably, despite many commonalities in "strategy"
among the 5 or so sparse parametrizations we have, implementations of
core algorithms (e.g., matrix multiplication) are specialized for each
sparse-like type---in other words, these mimic the "high level
vectorized functions" strategy common to other languages. What we lack
is a "sparse iteration API" that lets you write the main algorithms of
sparse linear algebra efficiently in a generic way.  Our current model
is probably fine for `SparseLike*Dense` operations, but gets to be
harder to manage if you want to efficiently compute, e.g., `Bidiagonal*SparseMatrixCSC`: the number of possible combinations you have to
support grows rapidly with more sparse types, and thus represents a
powerful incentive for developing efficient, generic low-level
operations.

Outside of Base, there are some other mind-stretching examples of
arrays, including:

- `DataFrames`: indexing arrays with symbols rather than
  integers. Other related types include `NamedArrays`, `AxisArrays`.

- `Interpolations`: indexing arrays with non-integer floating-point
  numbers

- `DistributedArrays`: another great example of a case in which you
  need to think through access patterns carefully

# SubArrays: a case study

For arrays of fixed dimension, one can write algorithms that index
arrays as `A[i,j,k,...]` (good examples can be found in our linear
algebra code, where everything is a vector or matrix).  For algorithms
that have to support arbitrary dimensionality, for a long time our
fallback was linear indexing, `A[i]` for integer `i`. However, in
general SubArrays cannot be efficiently accessed by a linear index
because it results in call(s) to `div`, and `div` is slow. This is a
CPU problem, not a Julia-specific problem. The slowness of `div` is
still true despite the [recent addition of
infrastructure](https://github.com/JuliaLang/julia/pull/15357) to make
it much faster---now one can make it merely "really bad" rather than
["Terrible, Horrible, No Good, and Very
Bad"](https://en.wikipedia.org/wiki/Alexander_and_the_Terrible,_Horrible,_No_Good,_Very_Bad_Day).

The way we (largely) resolved this problem was to make it possible to
do cartesian indexing, `A[i,j,k,...]`, for arrays of arbitrary
dimensionality (the `CartesianIndex` type).  To leverage this in
practical code, we also had to extend our iterators with the `for I in
eachindex(A)` construct.  This allows one to select an iterator that
optimizes the efficiency of access to elements of `A`.  In generic
algorithms, the performance gains were not small, sometimes on the
scale of ten- to fifty-fold.  These types were described in a
[previous blog post](http://julialang.org/blog/2016/02/iteration).

To my knowledge, this approach has given Julia one of the most
flexible yet efficient "array view" types in any programming language.
Many languages base views on array *strides*, meaning situations in
which the memory offset is regular along each dimension.  Among other
things, this requires that the underlying array is dense.  In
contrast, in Julia we can easily handle non-strided arrays (e.g.,
sampling at `[1,3,17,428,...]` along one dimension, or creating a view
of a `SparseMatrixCSC`).  We can also handle arrays for which there is
no underlying storage (e.g., `Range`s).  Being able to do this with a
common infrastructure is part of what makes different optimized array
types useful in generic programming.

It's also worth pointing out some problems:

- Most importantly, it requires that one adopt a slightly different
  programming style. Despite being well into another release cycle,
  this transition is still [not complete, even in Base](https://github.com/JuliaLang/julia/pull/15434#issuecomment-194991739).

- For algorithms that involve two or more arrays, there's a
  possibility that their "best" iterators will be of different
  types. *In principle*, this is a big problem. Consider matrix-vector
  multiplication, `A[i,j]*v[j]`, where `j` needs to be in-sync for
  both `A` and `v`, yet you'd also like all of these accesses to be
  maximally-efficient.  *In practice*, right now this isn't a burning
  problem: even if our arrays don't all have efficient linear
  indexing, to my knowledge all of our (dense) array types have
  efficient cartesian indexing. Since indexing by `N` integers (where
  `N` is equal to the dimensionality of the array) is always
  performant, this serves as a reliable default for generic code.
  (It's worth noting that this isn't true for sparse arrays, and the
  lack of a corresponding generic solution is probably the main reason
  we lack a generic API for writing sparse algorithms.)

Unfortunately, I suspect that if we want to add support for certain
new operations or types (specific examples below), it will force us to
set the latter problem on fire.

# Challenging examples

Some possible new `AbstractArray` types pose novel challenges.

## ReshapedArrays ([#15449](https://github.com/JuliaLang/julia/pull/15449))

These are the front-and-center motivation for this post. These are
motivated by a desire to ensure that `reshape(A, dims)` always returns
a "view" of `A` rather than allocating a copy of `A`. (Much of the
urgency of this julep goes away if we decide to abandon this goal, in
which case for consistency we should always return a copy of `A`.)
It's worth noting that besides an explicit `reshape`, we have some
mechanisms for reshaping that currently cause a copy to be created,
notably `A[:]` or `A[:, :]` applied to a 3D array.

Similar to `SubArrays`, the main challenge for `ReshapedArrays` is
getting good performance.  If `A` is a 3D array, and you reshape it to
a 2D array `B`, then `B[i,j]` must be expanded to `A[k,l,m]`.  The
problem is that computing the correct `k,l,m` might result in a call
to `div`. So ReshapedArrays violate a crutch of our current ecosystem,
in that indexing with `N` integers might not be the fastest way to
access elements of `B`. From a performance perspective, this problem
is substantial (see [#15449](https://github.com/JuliaLang/julia/pull/15449), about five- to ten-fold).

In simple cases, there's an easy way to circumvent this performance
problem: define a new iterator type that (internally) iterates over
the parent `A`'s indexes directly.  In other words, create an iterator
so that `B[I]` immediately expands to `A[I']`, and so that the latter
has "ideal" performance.

Unfortunately, this strategy runs into a lot of trouble when you need
to keep two arrays in sync: if you want to adopt this strategy, you
simply can't write `B[i,j]*v[j]` for matrix-vector multiplication
anymore.  A potential way around *this* problem is to define a new class
of iterators that operate on specific dimensions of an array ([#15459](https://github.com/JuliaLang/julia/pull/15459)),
writing `B[ii,jj]*v[j]`.  `jj` (whatever that is) and `j` need to be
in-sync, but they don't necessarily need to both be integers. Using
this kind of strategy, matrix-vector multiplication

```jl
for j = 1:size(B, 2)
    vj = v[j]
    for i = 1:size(B, 1)
        dest[i] += B[i,j] * vj
    end
end
```

might be written in a more performant manner like this:

```jl
for (jj, vj) in zip(eachindex(B, Dimension{2}), v)
    for (i, ii) in zip(eachindex(dest), eachindex(B, (:, jj)))
        dest[i] += B[ii,jj]*vj
    end
end
```

It's not too hard to figure out what `eachindex(B, Dimension{2})` and
`eachindex(B, (:, jj))` should do: `ii`, for example, could be a
`CartesianInnerIndex` (a type that does not yet exist) that for a
particular column of `B` iterates from `A[3,7,4]` to `A[5,8,4]`, where
the `d`th index component wraps around at `size(A, d)`.  The
big performance advantage of this strategy is that you only have to
compute a `div` to set the bounds of the iterator on each column; the
inner loop doesn't require a `div` on each element access. No doubt,
given suitable definition of `jj` one could be even more clever and
avoid calculating `div` altogether.  To the author, this strategy
seems promising as a way to resolve the majority of the performance
concerns about ReshapedArrays---only if you needed "random access"
would you require slow (integer-based) operations.

However, a big problem is that compared to the "naive" implementation,
this is rather ugly.


## Row-major matrices, PermutedDimensionArrays, and "taking transposes seriously"

Julia's `Array` type stores its entries in column-major order, meaning
that `A[i,j]` and `A[i+1,j]` are in adjacent memory locations.  For
certain applications---or for interfacing with certain external code
bases---it might be convenient to support row-major arrays, where
instead `A[i,j]` and `A[i,j+1]` are in adjacent memory locations. More
fundamentally, this is partially related to one of the most
commented-on issues in all of julia's development history, known as
"taking transposes seriously" aka [#4774](https://github.com/JuliaLang/julia/issues/4774).  There have been at least two
attempts at implementation, [#6837](https://github.com/JuliaLang/julia/pull/6837) and the `mb/transpose` branch, and
for the latter a summary of benefits and challenges was [posted](https://github.com/JuliaLang/julia/issues/4774#issuecomment-149349751).

One of the biggest challenges mentioned was the huge explosion of
methods that one would need to support.  Can generic code come to the
rescue here?  There are two related concerns.  The first is linear
indexing: oftentimes this is conflated with "storage order," i.e.,
given two linear indexes `i` and `j` for the same array, the offset in
memory is proportional to `i-j`.  For row-major arrays, this
notion is not viable, because otherwise a loop

```jl
function copy!(dest, src)
    for i = 1:length(src)
        dest[i] = src[i]  # trouble if `i` means "memory offset"
    end
    dest
end
```

would end up taking a transpose if `src` and `dest` don't use the same
storage order.  Consequently, a linear index has to be defined in
terms of the corresponding cartesian (full-dimensionality) index.
This isn't much of a real problem, because it's one we know how to
solve: use `ind2sub` (which is slow) when you have to, but for
efficiency make row major arrays belong to the category (`LinearSlow`)
of arrays that defaults to iteration with cartesian indexes.  Doing so
will ensure that if one uses generic constructs like `eachindex(src)`
rather than `1:length(src)`, then the loop above can be fast.

The far more challenging problem concerns cache-efficiency: it's much
slower to access elements of an array in anything other than
[storage-order](http://julialang.org/blog/2013/09/fast-numeric).  Some
reasonably fast ways to write matrix-vector multiplication are

```jl
for j = 1:size(B, 2)
    vj = v[j]
    for i = 1:size(B, 1)
        dest[i] += B[i,j] * vj
    end
end
```
for a column-major matrix `B`, and

```jl
for i = 1:size(B, 1)
    for j = 1:size(B, 2)
        dest[i] += B[i,j] * v[j]
    end
end
```

for a row-major matrix.  (One can do even better than this by using a
scalar temporary accumulator, but let's not worry about that here.)
The key point to note is that the order of the loops has been
switched.

One could generalize this by defining a `RowMajorRange` iterator
that's a lot like our `CartesianRange` iterator, but traverses the
array in row-major order.  `eachindex` claims to return an "efficient
iterator," and without a doubt the `RowMajorRange` is a (much) more
efficient iterator than a `CartesianRange` iterator for row-major
arrays. So let's imagine that `eachindex` does what it says, and
returns a `RowMajorRange` iterator.  Using this strategy, the two
algorithms above can be combined into a single generic implementation:

```
for I in eachindex(B)
    dest[I[1]] += B[I]*v[I[2]]
end
```

Yay! Score one for efficient generic implementations.

But our triumph is short-lived. Let's return to the example of
`copy!` above, and realize that `dest` and `src` might be two
different array types, and therefore might be most-efficiently indexed
with different iterator types.  We're tempted to write this as

```jl
function copy!(dest, src)
    for (idest, isrc) in zip(eachindex(dest), eachindex(src))
        dest[idest] = src[isrc]
    end
    dest
end
```

Up until we introduced our `RowMajorRange` return-type for
`eachindex`, this implementation would have been fine.  But we just
broke it, because now this will incorrectly take a transpose in
certain situations.

In other words, without careful design the goals of
"maximally-efficient iteration" and "keeping accesses in-sync" are in
conflict.

## OffsetArrays and the meaning of AbstractArray

Julia's arrays are indexed starting at 1, whereas some other languages
start numbering at 0. If you take comments on various blog posts at
face value, there are vast armies of programmers out there eagerly
poised to adopt julia, but who won't even try it because of this
difference in indexing.  Since recruiting those armies will lead to
world domination, this is clearly a problem of the utmost urgency.

More seriously, there *are* algorithms which simplify if you can index
outside of the range from `1:size(A,d)`.  In my own lab's internal
code, we've long been using a `CenterIndexedArray` type, in which such
arrays (all of which have odd sizes) are indexed over the range `-n:n`
and for which 0 refers to the "center" element. One package which
generalizes this notion is `OffsetArrays`.  Unfortunately, in practice
both of these array types produce segfaults (due to built-in
assumptions about when `@inbounds` is appropriate) for many of julia's
core functions; over time my lab has had to write implementations
specialized for `CenterIndexedArrays` for quite a few julia functions.

`OffsetArrays` illustrates another conceptual challenge, which can
easily be demonstrated by `copy!`.  When `dest` is a 1-dimensional
`OffsetArray` and `src` is a standard `Vector`, what should `copy!`
do? In particular, where does `src[1]` go? Does it go in the `first`
element of `dest`, or does it get stored in `dest[1]` (which may not
be the first element).

Such examples force us to think a little more deeply about what an
array really is.  There seem to be two potential conceptions.  One is
that arrays are lists, and multidimensional arrays are
lists-of-lists-of-lists-of...  In such a world view, the right thing
to do is to put `src[1]` into the first slot of `dest`, because 1 is
just a synonym for `first`.  However, this world view doesn't really
endow any kind of "meaning" to the index-tuple of an array, and in
that sense doesn't even include the distinction conveyed by an
`OffsetArray`. In other words, in this world an `OffsetArray` is
simply nonsensical, and shouldn't exist.

If instead one thinks `OffsetArray`s should exist, this essentially
forces one to adopt a different world view: arrays are effectively
associative containers, where each index-tuple is the "key" by which
one retrieves a value.  With this mode of thinking, `src[1]` should be
stored in `dest[1]`.

# Formalizing AbstractArray

These examples suggest a formalization of `AbstractArray`:

- `AbstractArray`s are specialized associative containers, in that the
  allowable "keys" may be restricted by more than just their julia
  type.  Specifically, the allowable keys must be representable as a
  cartesian product of one-dimensional lists of values.  The allowed
  keys may depend not just on the array type but also the specific
  array (e.g., its size).  Attempted access by keys that cannot be
  converted to one of the allowed keys, for that specific array,
  result in `BoundsError`s.

- For any given array, one must be able to generate a
  finite-dimensional parametrization of the full domain of valid keys
  from the array itself.  This might only require knowledge of the
  array size, or the keys might depend on some internal storage (think
  `DataFrames` and `OffsetArrays`).  In some cases, just the array
  type might be sufficient (e.g., `FixedSizeArrays`).  By this
  definition, note that a `Dict{ASCII5,Int}`, where `ASCII5` is a type
  that means an ASCII string with 5 characters, would qualify as a
  5-dimensional (sparse) array, but that a `Dict{ASCIIString,Int}`
  would not (because there is no length limit to an `ASCIIString`, and
  hence no finite dimensionality).

- An array may be indexed by more than one key type (i.e., keys may
  have multiple parametrizations).  Different key parametrizations are
  equivalent when they refer to the same element of a given
  array. Linear indexes and cartesian indexes are simple examples of
  interconvertable representations, but specialized iterators can
  produce other key types as well.

- Arrays may support multiple iterators that produce non-equivalent
  key sequences.  In other words, a row-major matrix may support both
  `CartesianRange` and `RowMajorRange` iterators that access elements
  in different orders.

# Finding a way forward

Resolving these conflicting demands is not easy. One approach might be
to decree that some of these array types simply can't be supported
with generic code. It is possible that this is the right
strategy. Alternatively, one can attept to devise an array API that
handles all of these types (and hopefully more).

In GitHub issue
[#15648](https://github.com/JuliaLang/julia/issues/15648), we are
discussing APIs that may resolve these challenges. Readers are
encouraged to contribute to this discussion.
