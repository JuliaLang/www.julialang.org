## C Linter

Memory errors in Julia's underlying C code are sometimes difficult to trace, and missing garbage-collector
"roots" (GC roots) can lead to segfaults and other problems. One potential way
to make it easier to find such errors would be to write a package that checks Julia's `src/` directory for
missing GC roots. A Julia-based solution might leverage the [Clang.jl](https://github.com/ihnorton/Clang.jl)
package to parse the C code, determine which call chains can trigger garbage collection, and then
look for objects that lack GC root protection. Alternatively, the same strategy might be implemented in C++ by writing a plugin for [Clang's static analyzer](http://clang-analyzer.llvm.org/). Another attractive approach is to leverage [coccinelle](http://coccinelle.lip6.fr/).

**Expected Results:** A tool that, when run against Julia's `src/` directory, highlights lines that
need to have additional GC roots added.

## Specialized call-site method caching

Julia's method cache is shared by all call sites of a generic function. Although whenever single dispatch is provable we generate a direct call, there are some cases where dynamic dispatch is inevitable. When the compiler can prove (using type inference) that the possible matches for a call site is small enough, it would be a huge performance win to generate a small cache specific to this call site. Those small caches would have to be updated when new method definitions are added (even replaced by the global cache when the number of matches becomes too large).

This project has a large number of possible extensions when the basic feature is done, including : using minimal caching keys (e.g. when only one of the arguments determine the dispatch entierly), generating specific dispatch code in a separate function, sharing the small caches between call sites, ...

It has also the future benefit of putting together the infrastructure we will need to enable inline method caching when automatic recompilation is done.

**Knowledge Prerequisites:** Good understanding of C/C++. A priori knowledge of Julia internals is a plus but this project could also be a very good way to familiarize oneself with those.
