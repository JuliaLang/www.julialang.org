---
layout: default
title:  The Julia Language
---

Julia is a high-level, high-performance dynamic programming language for technical computing, with syntax that is familiar to users of other technical computing environments.
It provides a sophisticated compiler, [distributed parallel execution](http://docs.julialang.org/en/stable/manual/parallel-computing/), numerical accuracy, and an [extensive mathematical function library](http://docs.julialang.org/en/stable/stdlib/).
Julia's Base library, largely written in Julia itself, also integrates mature, best-of-breed open source C and Fortran libraries for [linear algebra](http://docs.julialang.org/en/stable/stdlib/linalg/), [random number generation](http://docs.julialang.org/en/stable/stdlib/numbers/#random-numbers), [signal processing](http://docs.julialang.org/en/stable/stdlib/math/#signal-processing), and [string processing](http://docs.julialang.org/en/stable/stdlib/strings/#strings).
In addition, the Julia developer community is contributing a number of [external packages](http://pkg.julialang.org) through Julia's built-in package manager at a rapid pace. [IJulia](https://github.com/JuliaLang/IJulia.jl), a collaboration between the [Jupyter](http://jupyter.org) and Julia communities, provides a powerful browser-based graphical notebook interface to Julia.

[JuliaCon 2015](http://juliacon.org/2015) at MIT was a huge success. The [videos](https://www.youtube.com/playlist?list=PLP8iPy9hna6Sdx4soiGrSefrmOPdUWixM) are now online, and a random video from JuliaCon 2015 is presented here.

{% include juliacon-player-2015.html %}

Julia programs are organized around [multiple dispatch](http://docs.julialang.org/en/stable/manual/methods/#man-methods); by defining functions and overloading them for different combinations of argument types, which can also be user-defined.
For a more in-depth discussion of the rationale and advantages of Julia over other systems, see the following highlights or read the [introduction](http://docs.julialang.org/en/stable/manual/introduction/) in the [online manual](http://docs.julialang.org).

# A Summary of Features

* [Multiple dispatch](http://en.wikipedia.org/wiki/Multiple_dispatch): providing ability to define function behavior across many combinations of argument types
* Dynamic type system: types for documentation, optimization, and dispatch
* Good performance, approaching that of statically-compiled languages like C
* Built-in package manager
* [Lisp-like macros](http://docs.julialang.org/en/stable/manual/metaprogramming/#macros) and other [metaprogramming facilities](http://docs.julialang.org/en/stable/manual/metaprogramming/)
* Call Python functions: use the [PyCall](https://github.com/stevengj/PyCall.jl) package
* [Call C functions](http://docs.julialang.org/en/stable/manual/calling-c-and-fortran-code/) directly: no wrappers or special APIs
* Powerful shell-like capabilities for [managing other processes](http://docs.julialang.org/en/stable/manual/running-external-programs/)
* Designed for [parallelism and distributed computation](http://docs.julialang.org/en/stable/manual/parallel-computing/)
* [Coroutines](http://en.wikipedia.org/wiki/Coroutine): lightweight "green" threading
* [User-defined types](http://docs.julialang.org/en/stable/manual/types/) are as fast and compact as built-ins
* Automatic generation of efficient, specialized code for different argument types
* Elegant and extensible [conversions and promotions](http://docs.julialang.org/en/stable/manual/conversion-and-promotion/) for numeric and other types
* Efficient support for [Unicode](http://en.wikipedia.org/wiki/Unicode), including but not limited to [UTF-8](http://en.wikipedia.org/wiki/UTF-8)
* [MIT licensed](https://github.com/JuliaLang/julia/blob/master/LICENSE.md): free and open source

# High-Performance JIT Compiler

Julia's LLVM-based just-in-time (JIT) compiler combined with the language's design allow it to approach and often match the performance of C.
To get a sense of relative performance of Julia compared to other languages that can or could be used for numerical and scientific computing, we've written a small set of micro-benchmarks in a variety of languages:
[C](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.c),
[Fortran](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.f90),
[Julia](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.jl),
[Python](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.py),
[Matlab/Octave](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.m),
[R](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.R),
[JavaScript](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.js),
[Java](https://github.com/JuliaLang/julia/tree/master/test/perf/micro/java/src/main/java),
[Lua](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.lua),
[Go](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.go), and
[Mathematica](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.nb).
We encourage you to skim the code to get a sense for how easy or difficult numerical programming in each language is.
The following micro-benchmark results were obtained on a single core (serial execution) on an Intel(R) Xeon(R) CPU E7-8850 2.00GHz CPU with 1TB of 1067MHz DDR3 RAM, running Linux:

<div class="figure">
{% include benchmarks.html %}
<p class="caption"><b>Figure:</b>
benchmark times relative to C (smaller is better, C performance = 1.0).
</p>
<p class="note">
C and Fortran compiled by gcc 5.1.1, taking best timing from all optimization levels (-O0 through -O3).
C, Fortran, Go, and Julia use <a href="https://github.com/xianyi/OpenBLAS">OpenBLAS</a> v0.2.14.
Python 3 was installed from the <a href="https://www.continuum.io/downloads">Anaconda distribution</a>.
The Python implementations of <tt>rand_mat_stat</tt> and <tt>rand_mat_mul</tt>
use NumPy (v1.9.2) functions; the rest are pure Python implementations.<br/>
Benchmarks can also be seen <a href="/benchmarks/">here as a plot</a> created
with <a href="https://github.com/dcjones/Gadfly.jl">Gadfly</a>.
</p>
</div>

These benchmarks, while not comprehensive, do test compiler performance on a range of common code patterns, such as function calls, string parsing, sorting, numerical loops, random number generation, and array operations.
It is important to note that these benchmark implementations are not written for absolute maximal performance (the fastest code to compute `fib(20)` is the constant literal `6765`).
Rather, all of the benchmarks are written to test the performance of specific algorithms implemented in each language.
In particular, all languages use the same algorithm: the Fibonacci benchmarks are all recursive while the pi summation benchmarks are all iterative; the "algorithm" for random matrix multiplication is to call LAPACK, except where that's not possible, such as in JavaScript.
The point of these benchmarks is to compare the performance of specific *algorithms* across language implementations, not to compare the fastest means of computing a result, which in most high-level languages relies on calling C code.
Raw benchmark numbers in CSV format are available [here](/benchmarks.csv).


To give a quick taste of what Julia looks like, here is the code used in the Mandelbrot and random matrix statistics benchmarks:

{% highlight julia %}
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
{% endhighlight %}

The code above is quite clear, and should feel familiar to anyone who has programmed in other mathematical languages.
The Julia implementation of `randmatstat` is considerably simpler than the equivalent [C implementation](https://github.com/JuliaLang/julia/blob/master/test/perf/micro/perf.c#L126), without giving up much performance. Planned compiler optimizations will close this performance gap in the future.
By design, Julia allows you to range from tight low-level loops, up to a high-level programming style, while sacrificing some performance, but gaining the ability to express complex algorithms easily.
This continuous spectrum of programming levels is a hallmark of the Julia approach to programming and is very much an intentional feature of the language.

# Designed for Parallelism and Cloud Computing

Julia does not impose any particular style of parallelism on the user.
Instead, it provides a number of [key building blocks for distributed computation](/manual/parallel-computing), making it flexible enough to support a number of styles of parallelism, and allowing users to add more.
The following simple example demonstrates how to count the number of heads in a large number of coin tosses in parallel.

{% highlight julia %}
nheads = @parallel (+) for i=1:100000000
  int(randbool())
end
{% endhighlight %}

This computation is automatically distributed across all available compute nodes, and the result, reduced by summation (`+`), is returned at the calling node.

Here is a screenshot of a web-based interactive [IJulia Notebook](https://github.com/JuliaLang/IJulia.jl) session, using [Gadfly](https://github.com/dcjones/Gadfly.jl). [JuliaBox](http://www.juliabox.org) provides a way to run IJulia notebooks in your browser on Docker sandboxed containers provisioned on demand.

<a href="/images/ijulia.png" target="_blank"><img class="u-center" src="/images/ijulia.png" width="90%" /></a>

This paves the way for fully cloud-based operation, including data management, code editing and sharing, execution, debugging, collaboration, analysis, data exploration, and visualization.
The eventual goal is to let people stop worrying about administering machines and managing data and get straight to the real problem.

[Gadfly](https://github.com/dcjones/Gadfly.jl) can produce various plots with various rendering backends in the browser (SVG, PDF, PNG and various other backends are also supported). Interactivity can be added to graphs and plots with the [Interact.jl](https://github.com/JuliaLang/Interact.jl) package. A small sampling of the capabilities of Gadfly is presented below.

<a href="/images/gadfly-demo.png" target="_blank"><img src="/images/gadfly-demo.png" width="100%" /></a>

# Free, Open Source and Library-Friendly

The core of the Julia implementation is licensed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License).
Various libraries used by the Julia environment include their own licenses such as the [GPL](http://en.wikipedia.org/wiki/GNU_General_Public_License), [LGPL](http://en.wikipedia.org/wiki/GNU_Lesser_General_Public_License), and [BSD](http://en.wikipedia.org/wiki/BSD_licenses)
(therefore the environment, which consists of the language, user interfaces, and libraries, is under the GPL).
The language can be built as a shared library, so users can combine Julia with their own C/Fortran code or proprietary third-party libraries.
Furthermore, Julia makes it [simple to call external functions](http://docs.julialang.org/en/stable/manual/calling-c-and-fortran-code/) in C and Fortran shared libraries, without writing any wrapper code or even recompiling existing code.
You can try calling external library functions directly from Julia's interactive prompt, getting immediate feedback.
See [LICENSE](https://github.com/JuliaLang/julia/blob/master/LICENSE.md) for the full terms of Julia's licensing.
