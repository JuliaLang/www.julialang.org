---
layout: default
title:  Compiler Projects – Summer of Code
---

{% include toc.html %}

## C Linter

Memory errors in Julia's underlying C code are sometimes difficult to trace, and missing garbage-collector "roots" (GC roots) can lead to segfaults and other problems. One potential way to make it easier to find such errors would be to write a package that checks Julia's `src/` directory for missing GC roots. A Julia-based solution might leverage the [Clang.jl](https://github.com/ihnorton/Clang.jl) package to parse the C code, determine which call chains can trigger garbage collection, and then look for objects that lack GC root protection. Alternatively, the same strategy might be implemented in C++ by writing a plugin for [Clang's static analyzer](http://clang-analyzer.llvm.org/). Another attractive approach is to leverage [coccinelle](http://coccinelle.lip6.fr/).

**Expected Results:** A tool that, when run against Julia's `src/` directory, highlights lines that
need to have additional GC roots added.

## Specialized call-site method caching

Julia's method cache is shared by all call sites of a generic function. Although whenever single dispatch is provable we generate a direct call, there are some cases where dynamic dispatch is inevitable. When the compiler can prove (using type inference) that the possible matches for a call site is small enough, it would be a huge performance win to generate a small cache specific to this call site. Those small caches would have to be updated when new method definitions are added (even replaced by the global cache when the number of matches becomes too large).

This project has a large number of possible extensions when the basic feature is done, including : using minimal caching keys (e.g. when only one of the arguments determine the dispatch entierly), generating specific dispatch code in a separate function, sharing the small caches between call sites, ...

It has also the future benefit of putting together the infrastructure we will need to enable inline method caching when automatic recompilation is done.

**Knowledge Prerequisites:** Good understanding of C/C++. A priori knowledge of Julia internals is a plus but this project could also be a very good way to familiarize oneself with those.

## Faster Bignums

Julia currently supports big integers, rationals and floats, making use of the GMP library. But the current implementation
is essentially only a prototype. There exists a very wide gap between the performance of GMP bignums from a C program and from Julia.

This performance gap is due to multiple things: bignums in C can be reused, saving on initialisation and cleaning up, Julia
bignum objects are garbage collected, handwritten C programs can allocate a minimal number of temporaries and C programs can also make use of the mutable properties of GMP bignum objects, saving making copies. Further advantages exist for C implementations that store small integers as immediate words, rather than use a full multiple precision structure.

There are many ways of potentially improving bignum performance in Julia. We could keep a cache of bignum objects around instead of allocating new ones all the time. We could inline operations involving single word operations and introduce a combined immediate word/mpz struct type for BigInts. Constant propagation could be done by introducing a type for numerical constant literals. Julia could wrap the low level mpn layer of GMP directly instead of the higher level mpz, mpq, mpf layers. A set of unsafe mutating operators for bignums could be introduced, for cases where the user knows they have control over the bignum and can safely mutate it. (Theoretically, term rewriting or lazy evaluation could also eliminate the need for creating a new bignum object for every subexpression, or even reduce the number of temporaries required for any given expression, in much the same way as the old C++ wrapper for GMP used template metaprogramming to speed things up. However, this is probably beyond the scope of a GSOC project.) The Julia Cxx package could even be used to inline calls to the GMP C++ wrapper whose semantics may be closer to the Julia semantics.

Not all of these options are either practical or agreeable. And it isn't clear which options are going to lead to the best performance or to the nicest Julia code. A balance would need to be struck to use what's actually available in Julia in a way that is performant but also flexible enough to support future developer needs. The absolutely fastest option may not be the best long term option and consultation on the Julia list will be important for this project. The project should implement prototypes of a number of options, and present a performance comparison to the Julia developers before settling on a final design.
