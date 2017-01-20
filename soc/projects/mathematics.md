# Base Mathematics Libraries

## Upgrading openlibm

[OpenLibm](http://openlibm.org) is a portable libm implementation used by Julia. It has fallen behind msun, from where it was forked a few years ago. This project seeks to update OpenLibm with all the latest bugfixes to msun. At the same time the [MUSL libm](http://git.musl-libc.org/cgit/musl/tree/src/math) implementation will be considered as an alternative to base openlibm on. A significant testsuite based on various existing [libm testsuites](http://nsz.repo.hu/libm/#tests) will be created.

## Special functions

As a technical computing language, Julia provides a huge number of
[special functions](https://en.wikipedia.org/wiki/Special_functions), both in Base as well
as packages such as [StatsFuns.jl](https://github.com/JuliaStats/StatsFuns.jl). At the
moment, many of these are implemented in external libraries such as
[Rmath](https://github.com/JuliaLang/Rmath-julia) and
[openspecfun](https://github.com/JuliaLang/openspecfun). This project would involve
implementing these functions in native Julia (possibly utilising the work in
[SpecialFunctions.jl](https://github.com/nolta/SpecialFunctions.jl)),
seeking out opportunties for possible improvements along the way, such as supporting
`Float32` and `BigFloat`, exploiting fused multiply-add operations, and improving errors
and boundary cases.

## Matrix functions

Matrix functions maps matrices onto other matrices, and can often be interpreted as generalizations of ordinary functions like sine and exponential, which map numbers to numbers. Once considered a niche province of numerical algorithms, matrix functions now appear routinely in applications to cryptography, aircraft design, nonlinear dynamics, and finance.

This project proposes to implement state of the art algorithms that extend the currently available matrix functions in Julia, as outlined in issue [#5840](https://github.com/JuliaLang/julia/issues/5840). In addition to matrix generalizations of standard functions such as real matrix powers, surds and logarithms, students will be challenged to design generic interfaces for lifting general scalar-valued functions to their matrix analogues for the efficient computation of arbitrary (well-behaved) matrix functions and their derivatives.

## Fast bignums in Julia

Julia currently supports big integers, rationals and floats, making use of the GMP library. But the current implementation
is essentially only a prototype. There exists a very wide gap between the performance of GMP bignums from a C program and from Julia.

This performance gap is due to multiple things: bignums in C can be reused, saving on initialisation and cleaning up, Julia
bignum objects are garbage collected, handwritten C programs can allocate a minimal number of temporaries and C programs can also make use of the mutable properties of GMP bignum objects, saving making copies. Further advantages exist for C implementations that store small integers as immediate words, rather than use a full multiple precision structure.

There are many ways of potentially improving bignum performance in Julia. We could keep a cache of bignum objects around instead of allocating new ones all the time. We could inline operations involving single word operations and introduce a combined immediate word/mpz struct type for BigInts. Constant propagation could be done by introducing a type for numerical constant literals. Julia could wrap the low level mpn layer of GMP directly instead of the higher level mpz, mpq, mpf layers. A set of unsafe mutating operators for bignums could be introduced, for cases where the user knows they have control over the bignum and can safely mutate it. (Theoretically, term rewriting or lazy evaluation could also eliminate the need for creating a new bignum object for every subexpression, or even reduce the number of temporaries required for any given expression, in much the same way as the old C++ wrapper for GMP used template metaprogramming to speed things up. However, this is probably beyond the scope of a GSOC project.) The Julia Cxx package could even be used to inline calls to the GMP C++ wrapper whose semantics may be closer to the Julia semantics.

Not all of these options are either practical or agreeable. And it isn't clear which options are going to lead to the best performance or to the nicest Julia code. A balance would need to be struck to use what's actually available in Julia in a way that is performant but also flexible enough to support future developer needs. The absolutely fastest option may not be the best long term option and consultation on the Julia list will be important for this project. The project should implement prototypes of a number of options, and present a performance comparison to the Julia developers before settling on a final design.

## Random number generation

[Monte Carlo methods](https://en.wikipedia.org/wiki/Monte_Carlo_method) are becoming increasingly important in large-scale numerical computations, requiring large quantities of random numbers.
To ensure accuracy of the simulated systems, it is critical that the [pseudorandom number generator](https://en.wikipedia.org/wiki/Pseudorandom_number_generator) is both fast and reliable, avoiding problems with periodicity and dependence, robust to statistical tests such as the [Crush suite](https://github.com/andreasnoack/RNGTest.jl).
Challenges are even greater in massively parallel computations, which require going beyond running many copies of serial algorithms for generating pseudorandom numbers, due to well-known synchronization effects which can compromise the quality and uniformity of of random sampling. A previous Google Summer of Code project created [RNG.jl](https://github.com/sunoru/RNG.jl), and there are more random number generating algorithms to explore.

Some possible aims of this project:

* High-quality Julia implementations of PRNG algorithms such as the [xorshift family](http://xorshift.di.unimi.it/), seeking possible low-level optimisations along the way.
* Efficient generation of non-uniform variates, across different floating point precisions.
* Massively parallel random number generators, such as [SPRNG](http://www.sprng.org) or the [Random123](https://www.deshawresearch.com/resources_random123.html) entropy streams, and integration with [ComputeFramework.jl](https://github.com/shashi/ComputeFramework.jl).
* Support for fast parallel random number generators on GPUs
