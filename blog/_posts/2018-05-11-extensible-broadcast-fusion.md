---
layout: post
title:  "Extensible broadcast fusion"
author: <a href="https://github.com/mbauman">Matt Bauman (Julia Computing)</a>
---

Julia version 0.7 brings with it an exciting new feature: the ability to customize broadcast
fusion! This recently-merged change is the culmination of a long iterative design process
that involved many members of the community. We have converged on a highly extensible
interface that should satisfy many use-cases. In this blog post I'll explain why this is a
big deal by reviewing some of the key features and just scratch the surface of all that is
possible with this new design. I'm quite certain that our enterprising community will come
up with many more clever ways to exploit this new structure in the future.

[Broadcasting][] is a core feature of Julia: it allows you to compactly and efficiently
express an elementwise operation over containers and scalars by annotating operators and
function calls with a `.`. In cases where the sizes don't match, broadcasting will virtually
extend missing dimensions or "singleton" dimensions (which contain only one value) by
repeating them to fill the outer shape. For example, the expression `([1, 2, 3] .+ [10 20 30
40]) ./ 10` combines a 3-element column vector, a 1x4 matrix, and a scalar to compute a 3x4
result. I imagine this as "extruding" the vector across the columns of the one-row matrix
and spreading the division by 10 across the entire result:

```julia
julia> ([1, 2, 3] .+ [10 20 30 40]) ./ 10
3×4 Array{Float64,2}:
 1.1  2.1  3.1  4.1
 1.2  2.2  3.2  4.2
 1.3  2.3  3.3  4.3
```

Since version 0.6, Julia has executed this expression by ["fusing"][] the two operations
into a single kernel. That is, instead of first constructing an integer matrix resulting
from the addition (`[11 21 31 41; 12 22 ...]`) and then subsequently using a second loop to
divide each element by 10, Julia does both the addition and division for each element at the
same time, making just one pass through the output array and skipping intermediate array(s)
entirely. This fusion optimization happens as a syntax-level transformation so it is
guaranteed to occur and easy to reason about. Version 0.7 adds an extensible API on top of
this feature that allows arrays to customize precisely how this operates.

Julia now uses a first-class data structure to "lazily" represent a fused broadcast
expression before executing it. If you're not a package developer this may not mean all that
much to you, but you'll still reap the many rewards. In Base Julia and its standard
libraries alone, this means:

* [`BitArray`s][] can identify cases where they can operate on 64 boolean elements at once,
  yielding huge performance gains — often two orders of magnitude or more! For an easy
  example, I'll just use random data with a simple `A` and not `B` predicate:

	```julia
	julia> using BenchmarkTools, Random
	       srand(0)
	       A = bitrand(10^6)
	       B = bitrand(10^6)
	       @benchmark $A .& .!$B
	BenchmarkTools.Trial:
	  memory estimate:  122.23 KiB
	  allocs estimate:  3
	  --------------
	  minimum time:     7.891 μs (0.00% GC)
	  median time:      13.152 μs (0.00% GC)
	  mean time:        17.826 μs (9.62% GC)
	  maximum time:     591.497 μs (95.73% GC)
	  --------------
	  samples:          10000
	  evals/sample:     1
	```

	Compare this to previously on 0.6:

	```julia
	BenchmarkTools.Trial:
	  memory estimate:  126.45 KiB
	  allocs estimate:  6
	  --------------
	  minimum time:     3.615 ms (0.00% GC)
	  median time:      3.741 ms (0.00% GC)
	  mean time:        3.764 ms (0.18% GC)
	  maximum time:     7.744 ms (50.18% GC)
	  --------------
	  samples:          1328
	  evals/sample:     1
    ```

	That's upwards of a **450x performance gain**.

* Broadcasted operations over ranges can now simply re-compute a new range instead of
  working element-wise if it's possible. For example, the expression `((1:10000) .+ 20) .* 7`
  doesn't need to allocate a vector for 10,000 elements — it doesn't even need to do 10,000
  computations. It can instead operate in terms of the start, stop, and step and return a
  new range that represents the result: `147:7:70140`. This new feature allows them to
  **transform _O(N)_ computations into _O(1)_**. On version 0.6, ranges were in this strange
  place where `(1:10000) + 20` implemented the fast _O(1)_ computation of a new range, but
  all other array types had deprecated addition with numbers in favor of explicit `.+`
  broadcasting for clearer semantics and improved performance. Thanks to this new API,
  ranges can now identify these cases and fully support broadcasting in an efficient manner.

* The [structured matrices][] in the [`LinearAlgebra` standard library][] no longer return
  sparse arrays as the result of a broadcasted operation. They'll now either maintain an
  appropriate structure or return a dense array. For example:

    ```julia
	julia> using LinearAlgebra
	       d = Diagonal(1:3)
	3×3 Diagonal{Int64,UnitRange{Int64}}:
	 1  ⋅  ⋅
	 ⋅  2  ⋅
	 ⋅  ⋅  3

	julia> d ./ 10
	3×3 Diagonal{Float64,Array{Float64,1}}:
	 0.1   ⋅    ⋅
	  ⋅   0.2   ⋅
	  ⋅    ⋅   0.3

	julia> t = d .+ LowerTriangular(rand(3,3))
	3×3 LowerTriangular{Float64,Array{Float64,2}}:
	 1.5446     ⋅         ⋅
	 0.529211  2.26095    ⋅
	 0.533674  0.373702  3.88408

	julia> t .+ 100
	3×3 Array{Float64,2}:
	 101.327  100.0    100.0
	 100.85   102.138  100.0
	 100.575  100.129  103.839
    ```

	Previously, Julia 0.6 would have returned a `SparseMatrixCSC` for `d ./ 10` and an `Array` for `d .+ LowerTriangular(rand(3,3))`.

* Finally, broadcasting at the global scope is now pre-compilable, and you can use
  dot-broadcast inside generated functions. This wasn't a huge limitation in the past, but
  it did surprise folks timing an in-place broadcast like `@time y .*= 2` and seeing thousands of allocations:

    ```julia
	# Previously:
	julia> y = rand(1000);

	julia> @time y .*= 2;
	  0.032775 seconds (17.43 k allocations: 947.671 KiB)

	julia> @time y .*= 2;
	  0.020790 seconds (4.27 k allocations: 233.457 KiB)

	# Now on Julia 0.7:
	julia> y = rand(1000);

	julia> @time y .*= 2;
	  0.060494 seconds (90.41 k allocations: 5.529 MiB)

	julia> @time y .*= 2;
	  0.000020 seconds (6 allocations: 208 bytes)
	```

I'll now dive deeper into exactly how this new API works.

### The representation of a fused broadcast

You can see precisely how a fused broadcast is represented with [`Meta.@lower`][], but in
simpler terms the expression `([1, 2, 3] .+ [10 20 30 40]) ./ 10` is effectively a syntax
transformation for:

```julia
julia> using .Broadcast: materialize, broadcasted
       bc = broadcasted(/, broadcasted(+, [1, 2, 3], [10 20 30 40]), 10)
       materialize(bc)
3×4 Array{Float64,2}:
 1.1  2.1  3.1  4.1
 1.2  2.2  3.2  4.2
 1.3  2.3  3.3  4.3
```

In this case, that `bc` object is an instance of a `Broadcasted` struct. It just holds onto
the function and its arguments — and its arguments may include other nested `Broadcasted`
structs. The `materialize` function does a bit of pre-processing and then calls `copy(bc)`,
which allocates the result and then finally loops over the result and executes the functions.

Each step along the way is extensible, leveraging the power of Julia's multiple dispatch,
inlining and argument specialization for near-zero overhead. With this basic framework in
mind, you can begin to see how the built-in and standard library arrays are able to
implement all those new features mentioned above:

* When broadcasting into a `BitArray`, it can first introspect the functions and their
  arguments in the expression tree to see if it can operate at the level of the packed
  64-bit chunks as `UInt64`s instead of working bit-by-bit. It can even convert boolean-only
  operators like `!` to their equivalent bitwise operators like `~`.

* Ranges are able to "opt-out" of fusion by defining specialized `Broadcast.broadcasted`
  methods that immediately return those re-computed ranges. This means that they do not fuse
  multiple operations at all, but in exchange they get an _O(1)_ algorithm.

* When `LinearAlgebra`'s structured matrices are asked to allocate the result, their
  specialized `broadcast_similar` methods can walk through the `Broadcasted` expression tree
  and identify if any structure will remain.

* Fused broadcast expressions no longer construct an anonymous function behind your back;
  they just construct new instances of a Julia data structure that simply call functions
  that are already defined. This is what allows them to be precompiled and work in generated
  functions.

### Looking to the future

Of course, this is all [documented and available to packages][]. There's no secret sauce that
we're hoarding for ourselves. It'll be exciting to see how the many creative minds in the
package ecosystem manage to take advantage of all this new functionality. Some of the places
where I see this yielding a significant benefit include machine learning applications and
computation on GPUs.

Historically, some of the machine learning libraries have put in place [hacks][] to allow their arrays to
opt-out of fusion. The new broadcasting API instead allows them to opt-out of fusion with a first-class and fully
supported mechanism that is much simpler to implement. Further, many deep learning
techniques are heavily dependent upon differentiation; in some cases introspecting a
broadcasted kernel will allow them to use an exact analytical result instead of computing
differentials.

Finally, fusing a complicated broadcast expression into a single kernel has already been a
huge boon to the performance of arrays on GPUs. Most GPU programming packages won't
necessarily need to introspect or customize the broadcasted expression, but they're looking
to the future to a potential extension that would allow fusing _a reduction_ with the
broadcasted expression. While not possible yet, the bulk of the machinery is in place to
operate directly upon the `Broadcasted` lazy wrapper instead of allocating the intermediate
array in an expression like `sum(X.^2 .+ Y.^2)`.


[Broadcasting]: https://docs.julialang.org/en/latest/manual/arrays/#Broadcasting-1 "Julia documentation for Broadcasting"
["fusing"]: https://julialang.org/blog/2017/01/moredots "More Dots: Syntactic Loop Fusion in Julia"
[hacks]: https://github.com/MikeInnes/TakingBroadcastSeriously.jl "TakingBroadcastSeriously.jl"
[documented and available to packages]: https://docs.julialang.org/en/latest/manual/interfaces/#man-interfaces-broadcasting-1 "Julia manual: Customizing broadcast"
[`BitArray`s]: https://docs.julialang.org/en/latest/base/arrays/#Base.BitArray "Julia documentation for BitArray"
[`LinearAlgebra` standard library]: https://docs.julialang.org/en/latest/stdlib/LinearAlgebra/#Linear-Algebra-1 "Julia documentation for LinearAlgebra"
[structured matrices]: https://docs.julialang.org/en/latest/stdlib/LinearAlgebra/#Special-matrices-1 "Special matrices in LinearAlgebra"
[`Meta.@lower`]: https://docs.julialang.org/en/latest/base/base/#Base.Meta.@lower "Julia documentation: `Meta.@lower`"
