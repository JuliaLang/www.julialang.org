---
layout: default
title:  Compiler Projects – Summer of Code
---

# {{page.title}}

{% include toc.html %}

## Improved code-generation for un-inferred code

Currently the quality (performance) of generated code does not degrade particularly gracefully as the quality of type-inference degrades. There are a number of different projects possible here. Some example optimization opportunities include:

- Calling convention for varargs functions (https://github.com/JuliaLang/julia/issues/5402)
- Call-site splatting optimizations (https://github.com/JuliaLang/julia/issues/13359)
- Keyword argument inference / inlining
- More calling conventions, permitting improved performance (unboxed argument passing) when the direct method target is not known
- Value domination and liveness analysis for optimizing stack space and gc-root allocation

**Recommended Skills**: Experience with reading LLVM IR or assembly. An understanding of formal logic and using it to develop improved code transformations.

**Mentors**: [Jameson Nash](https://github.com/vtjnash)

## Better Nullables

The starting point should likely be https://github.com/JuliaLang/Juleps/pull/21. This will need further elaboration and study to identify any areas that are likely to be problematic under the new approach. Also will require new code and testing to demonstrate the performance and usability of the new code patterns; and to begin deprecation and replacement of the existing code pattern with Nullables.

**Expected Results**: Initiate replacement of the `Nullable{T}` with an implementation based around `Union{T, Void}` and `Union{Some{T}, Void}`.

**Recommended Skills**: Experience with performance testing and Julia. Experience with data analysis involving missing values also a big advantage.

**Mentors**: [Jameson Nash](https://github.com/vtjnash)

## Thread-safety

There are many remaining components that need to be updated to use thread-safe algorithms before Julia's threading will be stable for general usage. Some basic data-structures (such as the TypeMap) are missing correct RCU and memory barriers to ensure race-free answers. IO is also currently unavailable for multi-threaded code. The `realloc` operation for arrays (i.e. `resize!`) may be more reliable if it was implemented using RCU `malloc` (delaying the free until a gc-safepoint has been reached on all threads).

**Expected Results**: Demonstrate that a program that fails at the beginning of the summer can now run to completion, or show what remains to be fixed to get it working. Start a test framework to help find bugs and race conditions in the current implementation, and to detect future regressions in multi-threading behavior.

**Recommended Skills**: Experience with thread-safety in C.

**Mentors**: [Jameson Nash](https://github.com/vtjnash), [Yichao Yu](https://github.com/yuyichao)

## C Linter

Memory errors in Julia's underlying C code are sometimes difficult to trace, and missing garbage-collector "roots" (GC roots) can lead to segfaults and other problems. One potential way to make it easier to find such errors would be to write a package that checks Julia's `src/` directory for missing GC roots. A Julia-based solution might leverage the [Clang.jl](https://github.com/ihnorton/Clang.jl) package to parse the C code, determine which call chains can trigger garbage collection, and then look for objects that lack GC root protection. Alternatively, the same strategy might be implemented in C++ by writing a plugin for [Clang's static analyzer](http://clang-analyzer.llvm.org/). Another attractive approach is to leverage [coccinelle](http://coccinelle.lip6.fr/).

**Expected Results**: A tool that, when run against Julia's `src/` directory, highlights lines that need to have additional GC roots added.

**Required Skills**: Familiarity with C, runtimes, and experience with (or interest in) static analysis.

**Recommended Skills**: Experience with Julia's C runtime.

**Mentors**: [Keno Fischer](https://github.com/Keno), [Yichao Yu](https://github.com/yuyichao)
