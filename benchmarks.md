# Julia Micro-Benchmarks

These micro-benchmarks, while not comprehensive, do test compiler performance on a range of common code patterns, such as function calls, string parsing, sorting, numerical loops, random number generation, recursion, and array operations.

It is important to note that the benchmark codes are not written for absolute maximal performance (the fastest code to compute `recursion_fibonacci(20)` is the constant literal `6765`). Instead, the benchmarks are written to test the performance of identical algorithms and code patterns implemented in each language. For example, the Fibonacci benchmarks all use the same (inefficient) doubly-recursive algorithm, and the pi summation benchmarks use the same for-loop. The “algorithm” for matrix multiplication is to call the most obvious built-in/standard random-number and matmul routines (or to directly call BLAS if the language does not provide a high-level matmul), except where a matmul/BLAS call is not possible (such as in JavaScript).

![Benchmark results](/_assets/images/benchmarks.svg)

Note that the Julia results depicted above do not include compile time.

The vertical axis shows each benchmark time normalized against the C implementation. The benchmark data shown above were computed with Julia v1.0.0, SciLua v1.0.0-b12, Rust 1.27.0, Go 1.9, Java 1.8.0\_17, Javascript V8 6.2.414.54, Matlab R2018a, Anaconda Python 3.6.3, R 3.5.0, and Octave 4.2.2. C and Fortran are compiled with gcc 7.3.1, taking the best timing from all optimization levels (-O0 through -O3). C, Fortran, Go, Julia, Lua, Python, and Octave use [OpenBLAS](https://github.com/xianyi/OpenBLAS) v0.2.20 for matrix operations; Mathematica uses Intel® MKL. The Python implementations of matrix\_statistics and matrix\_multiply use [NumPy](https://www.numpy.org/) v1.14.0 and OpenBLAS v0.2.20 functions; the rest are pure Python implementations. Raw benchmark numbers in CSV format are available [here](https://github.com/JuliaLang/Microbenchmarks/blob/a963d284b09d04b3e0374f6dd46ec4b039ed5569/bin/benchmarks.csv) and the benchmark source code for each language can be found in the perf. files listed [here](https://github.com/JuliaLang/Microbenchmarks). The plot is generated using this [IJulia benchmarks notebook](https://github.com/JuliaLang/Microbenchmarks/blob/345817f9693defe2448c6d4f50b1fbb2bfd45753/bin/benchmarks.ipynb).

These micro-benchmark results were obtained on a single core (serial execution) on an Intel® Core™ i7-3960X 3.30GHz CPU with 64GB of 1600MHz DDR3 RAM, running openSUSE LEAP 15.0 Linux.

## Other Relevant Benchmarks

- DataFrames: [https://h2oai.github.io/db-benchmark/](https://h2oai.github.io/db-benchmark/)
- Graphs: [https://www.timlrx.com/blog/benchmark-of-popular-graph-network-packages-v2](https://www.timlrx.com/blog/benchmark-of-popular-graph-network-packages-v2)
- CSV and Pandas: [https://www.queryverse.org/benchmarks/](https://www.queryverse.org/benchmarks/)
