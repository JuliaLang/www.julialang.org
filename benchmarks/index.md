---
layout: default
title:  Julia Benchmarks
---

<center>
<div class="figure" style="align: center; width: 77%">
{% include benchmarks.svg %}
<p class="caption"><b>Figure:</b>
benchmark times relative to C (smaller is better, C performance = 1.0).
</p>
<p class="note">
C and Fortran compiled with gcc 5.1.1. C timing is the best timing from all optimization levels (-O0 through -O3).
C, Fortran and Julia use <a href="https://github.com/xianyi/OpenBLAS">OpenBLAS</a> v0.2.14.
The Python implementations of <tt>rand_mat_stat</tt> and <tt>rand_mat_mul</tt> use NumPy (v1.9.2) functions; the rest are pure Python implementations.
Plot created with <a href="https://github.com/dcjones/Gadfly.jl">Gadfly</a> and <a href="https://github.com/JuliaLang/IJulia.jl">IJulia</a> from <a href="http://nbviewer.ipython.org/url/julialang.org/benchmarks.ipynb">this notebook</a>.
</p>
</div>
</center>
