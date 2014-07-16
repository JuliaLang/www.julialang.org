---
layout: default
title:  Julia Publications
---

* [Julia: A Fast Dynamic Language for Technical Computing](http://arxiv.org/abs/1209.5145)

Dynamic languages have become popular for scientific computing. They
are generally considered highly productive, but lacking in
performance. This paper presents Julia, a new dynamic language for
technical computing, designed for performance from the beginning by
adapting and extending modern programming language techniques. A
design based on generic functions and a rich type system
simultaneously enables an expressive programming model and successful
type inference, leading to good performance for a wide range of
programs. This makes it possible for much of the Julia library to be
written in Julia itself, while also incorporating best-of-breed C and
Fortran libraries.

* [Computing in Operations Research using Julia](http://arxiv.org/abs/1312.1431)

The state of numerical computing is currently characterized by a
divide between highly efficient yet typically cumbersome low-level
languages such as C, C++, and Fortran and highly expressive yet
typically slow high-level languages such as Python and MATLAB. This
paper explores how Julia, a modern programming language for numerical
computing which claims to bridge this divide by incorporating recent
advances in language and compiler design (such as just-in-time
compilation), can be used for implementing software and algorithms
fundamental to the field of operations research, with a focus on
mathematical optimization. In particular, we demonstrate algebraic
modeling for linear and nonlinear optimization and a partial
implementation of a practical simplex code. Extensive cross-language
benchmarks suggest that Julia is capable of obtaining state-of-the-art
performance.

* Array operators using multiple dispatch: a design methodology for array implementations in dynamic languages

[doi:10.1145/2627373.2627383](http://dx.doi.org/10.1145/2627373.2627383) [(arXiv:1407.3845)](http://arxiv.org/abs/1407.3845)

Arrays are such a rich and fundamental data type that they tend to be built into a language, either in the compiler or in a large low-level library. Defining this functionality at the user level instead provides greater flexibility for application domains not envisioned by the language designer. Only a few languages, such as C++ and Haskell, provide the necessary power to define $n$-dimensional arrays, but these systems rely on compile-time abstraction, sacrificing some flexibility. In contrast, dynamic languages make it straightforward for the user to define any behavior they might want, but at the possible expense of performance.

As part of the Julia language project, we have developed an approach that yields a novel trade-off between flexibility and compile-time analysis. The core abstraction we use is multiple dispatch. We have come to believe that while multiple dispatch has not been especially popular in most kinds of programming, technical computing is its killer application. By expressing key functions such as array indexing using multi-method signatures, a surprising range of behaviors can be obtained, in a way that is both relatively easy to write and amenable to compiler analysis. The compact factoring of concerns provided by these methods makes it easier for user-defined types to behave consistently with types in the standard library.
