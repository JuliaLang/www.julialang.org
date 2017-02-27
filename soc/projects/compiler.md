---
layout: default
title:  Compiler Projects – Summer of Code
---

# {{page.title}}

{% include toc.html %}

## C Linter

Memory errors in Julia's underlying C code are sometimes difficult to trace, and missing garbage-collector "roots" (GC roots) can lead to segfaults and other problems. One potential way to make it easier to find such errors would be to write a package that checks Julia's `src/` directory for missing GC roots. A Julia-based solution might leverage the [Clang.jl](https://github.com/ihnorton/Clang.jl) package to parse the C code, determine which call chains can trigger garbage collection, and then look for objects that lack GC root protection. Alternatively, the same strategy might be implemented in C++ by writing a plugin for [Clang's static analyzer](http://clang-analyzer.llvm.org/). Another attractive approach is to leverage [coccinelle](http://coccinelle.lip6.fr/).

**Expected Results**: A tool that, when run against Julia's `src/` directory, highlights lines that need to have additional GC roots added.

**Required Skills**: Familiarity with C, runtimes, and experience with (or interest in) static analysis.

**Recommended Skills**: Experience with Julia's C runtime.

**Mentors**: [Jameson Nash](https://github.com/vtjnash), [Yichao Yu](https://github.com/yuyichao)

## Specialized call-site method caching

Julia's method cache is shared by all call sites of a generic function. Although whenever single dispatch is provable we generate a direct call, there are some cases where dynamic dispatch is inevitable. When the compiler can prove (using type inference) that the possible matches for a call site is small enough, it would be a huge performance win to generate a small cache specific to this call site.

**Expected Results**: A PR for Base Julia implementing this optimisation.

**Required Skills**: Good understanding of C/C++.

**Recommended Skills**: Knowledge of LLVM and Julia's compiler.

**Mentors**: [Jameson Nash](https://github.com/vtjnash), [Yichao Yu](https://github.com/yuyichao)
