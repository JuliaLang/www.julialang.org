---
layout: post
title:  Fast Numeric Computation in Julia
author: <a href="http://dahua.me">Dahua Lin</a>
---

# Fast Numeric Computation in Julia

Working on numerical problems daily, I have always dreamt of a language that provides an elegant interface while allowing me to write codes that run blazingly fast on large data sets. Julia is one language that turns this dream into a reality. 
With Julia, you can focus on your problem, keep your codes clean, and more importantly, write fast codes without diving into lower level languages such as C or Fortran when performance is critical.

However, you should not take this potential speed for granted. To get your codes fast, you should keep performance in mind and follow general best practice guidelines. Here, I would like to share with you my experience in writing efficient codes for numerical computation.

## Make It Correct First

Like in other languages, the foremost goal when you implement your algorithm is to *make it correct*. An algorithm that doesn't work correctly is useless no matter how fast it runs. One can always optimize the codes afterwards when necessary.

When there are different approaches to a problem, you should choose the one that is *asymptotically more efficient*. A loosely implemented quick-sort algorithm can easily beat a bubble-sort.

Given a particular choice of algorithm, implementing it carefully and observing common performance guidelines can still make a big difference in performance -- I will focus on this in the remaining part.

## Devectorize Expressions

Users of other high level languages such as MATLAB or Python are often advised to *vectorize* their codes as much as possible to get performance, because loops are slow in those languages. In Julia, for-loops can run as fast as those written in C and you no longer have to count on vectorization. Actually, turning vectorized expressions into for-loops, which we call *devectorization*, can usually results in even higher performance.

Consider the following:

```julia
r = exp(- abs(x - y))
```

Very simple expression, right? However, behind the scenes, it takes a lot of steps to get you the results of this expression:

```julia
n = length(x)

tmp1 = Array(Float64, n)
for i in 1 : n
    tmp1[i] = x[i] - y[i]
end

tmp2 = Array(Float64, n)
for i in 1 : n
    tmp2[i] = abs(tmp1[i])
end

tmp3 = Array(Float64, n)
for i in 1 : n
    tmp3[i] = - tmp2[i]
end

r = Array(Float64, n)
for i in 1 : n
    r[i] = exp(tmp3[i])
end
```

We can see that this procedure creates three temporary arrays and it takes four passes to complete the computation. This would introduce significant overhead:

* It takes time to allocate memory for the temporary arrays
* It takes time to reclaim the memory of these arrays during garbage collection
* It takes time to traverse the memory. Generally, fewer passes means higher efficiency.

Such overhead is significant in practice, often leading to 2x to 3x slow down. To get optimal performance, one should *devectorize* the codes:

```julia
r = similar(x) 
for i in 1 : length(x)
    r[i] = exp(-abs(x[i] - y[i]))
end
```

This version finishes the computation in one pass, without introducing any temporary arrays. Moreover, if ``r`` is pre-allocated, one can even omit the statment that creates ``r``. The [*Devectorize.jl*](https://github.com/lindahua/Devectorize.jl) package provides a macro ``@devec`` that can automatically translate vectorized expressions into loops:

```julia
using Devectorize

@devec r = exp(- abs(x - y))
```

The comprehension syntax also provides a concise syntax for devectorized computation:

```julia
r = [exp(-abs(x[i] - y[i])) for i in 1 : length(x)]
```

Note that comprehension always creates new arrays to store the results. Hence, to write results to pre-allocated arrays, you still have to devectorize the computation manually or use the ``@devec`` macro.

## Merge Computations into a Single Loop

Traversing arrays, especially large ones, may incur cache misses or even page faults, both of which can cause significant latency. Therefore, it is desirable to reduce the number of round trips when possible. 

For example, you may compute multiple maps with one loop:

```julia
for i in 1 : length(x)
    a[i] = x[i] + y[i]
    b[i] = x[i] - y[i]
end
```

This is usually faster than writing ``a = x + y; b = x - y``. 

The example below shows how you can compute multiple statistics (e.g. sum, max, and min) over a dataset efficiently.

```julia
n = length(x)

rsum = rmax = rmin = x[1]
for i in 2 : n
    xi = x[i]
    rsum += xi
    if xi > rmax
        rmax = xi
    elseif xi < rmin
        rmin = xi
    end
end
```

## Write Cache-friendly Codes

Modern computer systems have a complicated heterogeneous memory structure that combines registers, multiple levels of caches, and RAM. Data are accessed through the cache hierarchy -- a smaller and much faster memory that stores copies of frequently used data. 

Most systems do not provide ways to directly control the cache system. However, you can take steps to make it much easier for the automated cache management system to help you if you write *cache-friendly* codes. In general, you don't have to understand every detail about how a cache system works. It is often sufficient to observe the simple rule below:

> Access data in a pattern similar to how the data resides in memory. Don't jump around between non-contiguous locations in memory.

This is sometimes referred to as the *principle of locality*. For example, if ``x`` is a contiguous array, after you read ``x[i]``, then ``x[i+1]`` is much more likely to be stored in the cache than ``x[i+1000000]``, and thus it would be much faster to access ``x[i+1]`` than ``x[i+1000000]``.

Julia arrays are stored in column-major order, which means that the rows of a column are contiguous, but the columns of a row are generally not. Therefore it is generally more efficient to access data column-by-column than row-by-row. 

Consider the problem of computing the sum of each row in a matrix. It is natural to implement this as follows:

```julia
m = size(a, 1)
n = size(a, 2)
r = Array(Float64, m)

for i in 1 : m
    s = 0.
    for j in 1 : n
        s += a[i,j]
    end
    r[i] = s
end
```

The loop here accesses the elements row by row, as ``a[i, 1], a[i, 2], ..., a[i, n]``. The interval between these elements is ``m``. Intuitively, it jumps at the stride of length ``m`` from the begining of each row to the end in each inner loop, and then jumps back to the begining of next row. This is not very efficient, especially when ``m`` is large. 

This procedure can be made much more cache-friendly by changing the order of computation:

```julia
for i in 1 : m
    r[i] = a[i,1]
end

for j in 2 : n
    for i in 1 : m
        r[i] += a[i,j]
    end
end
```

Some benchmarking shows that this version can be *5 - 10 times* faster than the one above for large matrices. 

## Avoid Creating Arrays in Loops

Creating arrays requires memory allocation and adds to the workload of the garbage collector. Reusing the same array is a good way to reduce the cost of memory management.

It is not uncommon that you want to update arrays in an iterative algorithm. For example, in K-means, you may want to update both the cluster means and distances in each iteration. A straightforward way to do this might look like:

```julia
while !converged && t < maxiter
    means = compute_means(x, labels)
    dists = compute_distances(x, means)
    labels = assign_labels(dists)
    ...
end
```

In this implementation of K-means, the arrays ``means``, ``dists``, and ``labels`` are recreated at each iteration. This reallocation of memory on each step is unnecessary. The sizes of these arrays are fixed, and their storage can be reused across iterations. The following alternative code is a more efficient way to implement the same algorithm:

```julia
d = size(x, 1)
n = size(x, 2)

# pre-allocate storage
means = Array(Float64, d, K)
dists = Array(Float64, K, n)
labels = Array(Int, n)

while !converged && t < maxiter
    update_means!(means, x, labels)
    update_distances!(dists, x, means)
    update_labels!(labels, dists)
    ...
end
```

In this version, the functions invoked in the loop updates pre-allocated arrays inplace. 

If you are writing a package, it is recommended that you provide two versions for each function that outputs arrays: one that performs the update in-place, and another that returns a new array. The former can usually be implemented as a light-weight wrapper of the latter. 
A good example is the [*Distributions.jl*](https://github.com/JuliaStats/Distributions.jl) package, which provides both ``logpdf`` and ``logpdf!``, so that one can write ``lp = logpdf(d, x)`` when a new array is needed, or ``logpdf!(lp, d, x)`` when ``lp`` has been pre-allocated. 

## Identify Opportunities to Use BLAS

Julia wraps a large number of [BLAS](http://en.wikipedia.org/wiki/Basic_Linear_Algebra_Subprograms) routines for linear algebraic computation. These routines are highly optimized by experts and are often faster than hand crafted loops by orders of magnitude. Using these routines properly will certainly do you a great favor in boosting performance.

For example, if you want to accumulate weighted versions of vectors, as follows

```julia
r = zeros(size(x, 1))
for j in 1 : size(x, 2)
    r += x[:,j] * w[j]
end
```

You may replace the statement ``r += x[:,j] * w[j]`` with a call to ``axpy!`` to get better performance:

```julia
for j in 1 : size(x, 2)
    axpy!(w[j], x[:,j], r)
end
```

However, this is still far from being optimal. If you are familiar with linear algebra, you may have probably found that this is just matrix-vector multiplication, and can be written as ``r = x * w``, which runs much faster than both versions above.

Our next example is a subtler application of BLAS routines to computing pairwise Euclidean distances between columns in two matrices. Below is a straightforward implementation that directly computes pairwise distances:

```julia
m = size(a, 2)
n = size(b, 2)
r = Array(Float64, m, n)

for j in 1 : n
    for i in 1 : m
        r[i,j] = sqrt(sum(abs2(a[:,i] - b[:,j])))
    end
end
```

This is clearly suboptimal -- a lot of temporary arrays are created in evaluating the expression in the inner loop. To speed this up, we can devectorize the inner expression:

```julia
d = size(a, 1)
m = size(a, 2)
n = size(b, 2)
r = Array(Float64, m, n)

for j in 1 : n
    for i in 1 : m
        s = 0.
        for k in 1 : d
            s += abs2(a[k,i] - b[k,j])
        end
        r[i,j] = sqrt(s)
    end
end
```

This version is much more performant than the vectorized form. But is it the best we can do? By employing an alternative strategy, we can write a even faster algorithm for computing pairwise distances. The trick is that the squared Euclidean distance between two vectors can be expanded as:

```julia
sum(abs2(x - y)) = sum(abs2(x)) + sum(abs2(y)) - 2 * dot(x, y)
```

If we evaluate these three terms separately, the computation can be mapped to BLAS routines perfectly. Below, we have a new implementation of pairwise distances written using only BLAS routines, including the norm calls that are wrapped by the [*NumericExtensions.jl*](https://github.com/lindahua/NumericExtensions.jl) package:

```julia
using NumericExtensions   # for sqsum
using Base.LinAlg.BLAS    # for gemm!

m = size(a, 2)
n = size(b, 2)

sa = sqsum(a, 1)   # sum(abs2(x)) for each column in a
sb = sqsum(b, 1)   # sum(abs2(y)) for each column in b

r = sa .+ reshape(sb, 1, n)          # first two terms
gemm!('T', 'N', -2.0, a, b, 1.0, r)  # add (-2.0) * a' * b to r

for i in 1 : length(r)
    r[i] = sqrt(r[i])
end
```

This version is over *100 times* faster than our original implementation -- the ``gemm`` function in BLAS has been optimized to the extreme by many talented developers and engineers over the past few decades. 

By the way, you don't have to implement this yourself if you really want to compute pairwise distances. The [*Distance.jl*](https://github.com/lindahua/Distance.jl) package provides a collection of optimized functions for this purpose. We include it only as an illustrative of the substantial performance gains that can be achieved by writing code that relies upon BLAS routines whenever possible.

## Explore Packages

Julia has a very active community. A variety of packages have been developed that provides a large collection of optimized functions for high performance computation. Look for a package before you decide to invent your own. 

Here is an incomplete list of packages that might be useful for those interested in high performance computation:

* [Profile.jl](https://github.com/timholy/Profile.jl)

    Profiling tools for the Julia language. Profilers are mainly used for code optimization, particularly to find bottlenecks. It is a recommended practice to always profile your code before you decide which part to optimize.

* [NumericExtensions.jl](https://github.com/lindahua/NumericExtensions.jl)

    Julia extensions to provide high performance support for a variety of common computation.

* [Devectorize.jl](https://github.com/lindahua/Devectorize.jl)

    A Julia framework that provides macros and functions to de-vectorize a vector expression. With this package, users can write computations in high-level vectorized way and at the same time enjoying the high run-time performance of de-vectorized loops. 

Check out the [Julia package list](http://docs.julialang.org/en/latest/packages/packagelist/) for more packages.
