Fast Numeric Computation in Julia
===================================

Working on numerical problems daily, I have been always dreaming of a language that provides elegant interface while allowing you to write codes that run blazingly fast on large data. Julia is one that turns this into reality. 
With Julia, you can focus on your problem, keep your codes clean, and more importantly, write fast codes without diving into lower level languages such as C or Fortran when performance is critical.

However, you should not take this for granted. To get your codes fast, you should keep performance in mind and follow general guidelines in practice. Here, I would like to share with you my experience in writing efficient codes for numerical computation.

Make It Correct First
-----------------------

Like in other languages, the foremost goal when you implement your algorithm is to *make it correct*. An algorithm that doesn't work correctly is useless no matter how fast it runs. One can always optimize the codes afterwards when necessary.

When there are different approaches to a problem, you should choose the one that is *asymptotically more efficient*. A loosely implemented quick-sort algorithm can easily beat a bubble-sort.

Given a particular choice of algorithm, implementing it carefully and observing common performance guidelines can still make a big difference in performance -- I will focus on this in the remaining part.


Devectorize Expressions
------------------------

Users of other high level languages such as MATLAB or Python are often advised to *vectorize* their codes as much as possible to get performance, because loops are slow in those languages. In Julia, for-loops can run as fast as those written in C and you no longer have to count on vectorization. Actually, turning vectorized expressions into for-loops -- which we call *devectorization*, can usually results in even higher performance.

Consider the following:

```julia
r = exp(- abs(x - y))
```

Very simple expression, right? However, behind the scene, it takes a lot of steps to get you the results:

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


Merge Computation into a Single Loop
------------------------------------

Traversing arrays, especially large ones, may incur cache miss or even page fault, causing significant latency. Therefore, it is desirable to reduce the number of round trips when possible. 

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


Write Cache-friendly Codes
--------------------------

Modern computer systems have a complicated heterogeneous memory structure that combines registers, multiple levels of caches, and RAM. Data are accessed through the cache hierarchy -- a smaller and much faster memory that stores copies of frequently used data. 

Most systems do not provide ways to directly control the cache system. However, it would make it much easier for the cache system to help you if you write *cache-friendly* codes. In general, you don't have to understand every detail about how a cache system works. It is often sufficient to observe the simple rule below:

> Access data in a similar pattern as they reside in the memory. Don't jump around.

This is sometimes referred to as the *principle of locality*. For example, if ``x`` is a contiguous array, after you read ``x[i]``, then ``x[i+1]`` is much more likely in the cache than ``x[i+1000000]``, and thus it would be much faster to access ``x[i+1]`` than ``x[i+1000000]``.

Julia arrays are stored in the column-major order. Therefore it is generally more efficient to access data column-by-column than row-by-row. 

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

This is not very efficient especially when ``m`` is large. The inner loop in this code snippet accesses ``a[i,j+1]`` after accessing ``a[i,j]`` -- the distance between these two elements are ``m``. 














