---
layout: default
title:  The Julia Language
---

Julia is a high-level, high-performance dynamic programming language for technical computing, with syntax that is familiar to users of other technical computing environments.
It provides a sophisticated compiler, distributed parallel execution, numerical accuracy, and an extensive mathematical function library.
The library, largely written in Julia itself, also integrates mature, best-of-breed C and Fortran libraries for linear algebra, random number generation, signal processing, and string processing.
In addition, the Julia developer community is contributing a number of [external packages](http://docs.julialang.org/en/latest/packages/packagelist/) through Julia's built-in package manager at a rapid pace.
Julia programs are organized around multiple dispatch; by defining functions and overloading them for different combinations of argument types, which can also be user-defined.
For a more in-depth discussion of the rationale and advantages of Julia over other systems, see the following highlights or read the [introduction](http://docs.julialang.org/en/latest/manual/introduction/) in the [online manual](http://docs.julialang.org/en/latest/manual/).

# High-Performance JIT Compiler

Julia's LLVM-based just-in-time (JIT) compiler combined with the language's design allow it to approach and often match the performance of C.
To get a sense of relative performance of Julia compared to other languages that can or could be used for numerical and scientific computing, we've written a small set of micro-benchmarks in a variety of languages.
The source code for the various implementations can be found here:
[C](https://github.com/JuliaLang/julia/blob/master/test/perf/perf.c),
[Fortran](https://github.com/JuliaLang/julia/blob/master/test/perf/perf.f90),
[Julia](https://github.com/JuliaLang/julia/blob/master/test/perf/perf.jl),
[Python](https://github.com/JuliaLang/julia/blob/master/test/perf/perf.py),
[Matlab/Octave](https://github.com/JuliaLang/julia/blob/master/test/perf/perf.m),
[R](https://github.com/JuliaLang/julia/blob/master/test/perf/perf.R), and
[JavaScript](https://github.com/JuliaLang/julia/blob/master/test/perf/perf.js).
We encourage you to skim the code to get a sense for how easy or difficult numerical programming in each language is.
The following micro-benchmark results are from a MacBook Pro with a 2.53GHz Intel Core 2 Duo CPU and 8GB of 1066MHz DDR3 RAM:

<div class="figure">
{% include benchmarks.html %}
<p class="caption"><b>Figure:</b>
benchmark times relative to C (smaller is better).
</p>
<p class="note">
C compiled by Clang 4.0, taking best timing from all optimization levels (-O0 through -O3).<br>
The Python implementations of <tt>rand_mat_stat</tt> and <tt>rand_mat_mul</tt> use NumPy (v1.5.1) functions; the rest are pure Python implementations.
</p>
</div>

These benchmarks, while not comprehensive, do test compiler performance on a range of common code patterns, such as function calls, string parsing, sorting, numerical loops, random number generation, and array operations.
It is important to note that these benchmark implementations are not written for absolute maximal performance (the fastest code to compute `fib(20)` is the constant literal `6765`).
Rather, all of the benchmarks are written to test the performance of specific algorithms, expressed in a reasonable idiom in each language.
In particular, all languages use the same algorithm: the Fibonacci benchmarks are all recursive while the pi summation benchmarks are all iterative; the "algorithm" for random matrix multiplication is calling LAPACK, except where that's not possible, such as JavaScript.
The point of these benchmarks is to compare the performance of specific *algorithms* across language implementations, not to compare the fastest means of computing a result, which in most high-level languages relies on calling C code.

Julia beats all other high-level systems (i.e. everything besides C and Fortran) on all micro-benchmarks.
Relative performance between languages on [other systems](https://github.com/JuliaLang/julia#Supported-Platforms) is similar.
Raw benchmark numbers in CSV format are available [here](/benchmarks.csv).
In particular, Julia is strong in an area that high-level languages have traditionally been weak:
scalar arithmetic loops, such as that found in the pi summation benchmark.
Matlab's JIT for floating-point arithmetic does well here too, as does the V8 JavaScript engine.
(In general, V8 is very impressive in providing such C-like performance in a very dynamic language.
JavaScript, however, is unable to utilize technical computing libraries such as LAPACK, resulting in poor performance on benchmarks like matrix multiplication.)
In contrast with both Matlab and JavaScript, Julia has a more comprehensive approach to eliminating overhead that allows it to consistently optimize all kinds of code for arbitrary user-defined data types, not just certain special cases.

To give a quick taste of what Julia looks like, here is the code used in the Mandelbrot and random matrix statistics benchmarks:

    function mandel(z)
        c = z
        maxiter = 80
        for n = 1:maxiter
            if abs(z) > 2
                return n-1
            end
            z = z^2 + c
        end
        return maxiter
    end

    function randmatstat(t)
        n = 5
        v = zeros(t)
        w = zeros(t)
        for i = 1:t
            a = randn(n,n)
            b = randn(n,n)
            c = randn(n,n)
            d = randn(n,n)
            P = [a b c d]
            Q = [a b; c d]
            v[i] = trace((P.'*P)^4)
            w[i] = trace((Q.'*Q)^4)
        end
        std(v)/mean(v), std(w)/mean(w)
    end

As you can see, the code is quite clear, and should feel familiar to anyone who has programmed in other mathematical languages.
Although C beats Julia in the random matrix statistics benchmark by a significant factor, consider how much simpler this code is than the [C implementation](https://github.com/JuliaLang/julia/blob/master/test/perf/perf.c#L126).
There are more compiler optimizations planned that we hope will close this performance gap in the future.
By design, Julia allows you to range from low-level loop and vector code, up to a high-level programming style, sacrificing some performance, but gaining the ability to express complex algorithms easily.
This continuous spectrum of programming levels is a hallmark of the Julia approach to programming and is very much an intentional feature of the language.

# Designed for Parallelism & Cloud Computing

Julia does not impose any particular style of parallelism on the user.
Instead, it provides a number of [key building blocks for distributed computation](/manual/parallel-computing), making it flexible enough to support a number of styles of parallelism, and allowing users to add more.
The following simple example demonstrates how to count the number of heads in a large number of coin tosses in parallel.

    nheads = @parallel (+) for i=1:100000000
      int(randbool())
    end

This computation is automatically distributed across all available compute nodes, and the result, reduced by summation (`+`), is returned at the calling node.

Although it is in the early stages, Julia already supports a fully remote cloud computing mode.
Here is a screenshot of a web-based interactive Julia session, plotting an oscillating function and a Gaussian random walk:</p>

<a href="/images/web_repl.png" target="_blank"><img src="/images/web_repl.png" width="95%" /></a>

There will eventually be full support for cloud-based operation, including data management, code editing and sharing, execution, debugging, collaboration, analysis, data exploration, and visualization.
The goal is to allow people who work with big data to stop worrying about administering machines and managing data and get straight to the real problem.

# Free, Open Source & Library-Friendly

The core of the Julia implementation is licensed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License).
Various libraries used by the Julia environment include their own licenses such as the [GPL](http://en.wikipedia.org/wiki/GNU_General_Public_License), [LGPL](http://en.wikipedia.org/wiki/GNU_Lesser_General_Public_License), and [BSD](http://en.wikipedia.org/wiki/BSD_licenses)
(therefore the environment, which consists of the language, user interfaces, and libraries, is under the GPL).
The language can be built as a shared library, so users can combine Julia with their own C/Fortran code or proprietary third-party libraries.
Furthermore, Julia makes it [simple to call external functions](http://docs.julialang.org/en/latest/manual/calling-c-and-fortran-code/) in C and Fortran shared libraries, without writing any wrapper code or even recompiling existing code.
You can try calling external library functions directly from Julia's interactive prompt, getting immediate feedback.
See [LICENSE](https://github.com/JuliaLang/julia/blob/master/LICENSE.md) for the full terms of Julia's licensing.
