---
layout: homepage
title:  Julia Micro-Benchmarks
---

{% include mainmenu.html %}

<br>
<br>

<div class = "container">

<h1 id="julia-micro-benchmarks">Julia Micro-Benchmarks</h1>

<p>These micro-benchmarks, while not comprehensive, do test compiler
performance on a range of common code patterns, such as function
calls, string parsing, sorting, numerical loops, random number
generation, recursion, and array operations.</p>

<p>It is important to note that the benchmark codes are not written for
absolute maximal performance (the fastest code to compute
<code class="highlighter-rouge">recursion_fibonacci(20)</code> is the constant literal <code class="highlighter-rouge">6765</code>).  Instead,
the benchmarks are written to test the performance of <em>identical
algorithms and code patterns</em> implemented in each language.  For
example, the Fibonacci benchmarks all use the same (inefficient)
doubly-recursive algorithm, and the pi summation benchmarks use the
same for-loop.  The “algorithm” for matrix multiplication is to call
the most obvious built-in/standard random-number and matmul routines
(or to directly call BLAS if the language does not provide a
high-level matmul), except where a matmul/BLAS call is not possible
(such as in JavaScript).</p>

<img src="/images/benchmarks.svg">

<p>The data presented here is generated using <a href="http://nbviewer.ipython.org/url/julialang.org/benchmarks/benchmarks.ipynb">
this IJulia benchmarks notebook</a>.</p>

<p>C and Fortran compiled with gcc 4.8.5, taking best timing from all
optimization levels (-O0 through -O3).  C, Fortran, Go, Julia, Lua,
Python, and Octave use <a href="https://github.com/xianyi/OpenBLAS">OpenBLAS</a> v0.2.19 for
matrix operations; Mathematica uses Intel(R) MKL.  The Python
environment is <a href="https://anaconda.org/anaconda/python">Anaconda
Python</a> v3.6.3.  The Python implementations of
<tt>rand_mat_stat</tt> and <tt>rand_mat_mul</tt> use <a href="http://www.numpy.org/">NumPy</a> v1.13.1 and OpenBLAS v0.2.19
functions; the rest are pure Python implementations. Raw benchmark
numbers in CSV format are available <a href="/benchmarks/benchmarks.csv">here</a> and the
benchmark source code for each language can be found in the <tt>perf.</tt>
files listed <a href="https://github.com/JuliaLang/Microbenchmarks">here</a>.</p>

<p>These micro-benchmark results were obtained on a single core (serial
execution) on an Intel(R) Core(TM) i7-3960X 3.30GHz CPU with 64GB of
1600MHz DDR3 RAM, running openSUSE LEAP 42.3 Linux.</p>


</div>
