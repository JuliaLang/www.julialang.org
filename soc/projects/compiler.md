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

## Thread-safety

There are many remaining components that need to be updated to use thread-safe algorithms before Julia's threading will be stable for general usage. Some basic data-structures (such as the TypeMap) are missing correct RCU and memory barriers to ensure race-free answers. IO is also currently unavailable for multi-threaded code. The `realloc` operation for arrays (i.e. `resize!`) may be more reliable if it was implemented using RCU `malloc` (delaying the free until a gc-safepoint has been reached on all threads).

**Expected Results**: Demonstrate that a program that fails at the beginning of the summer can now run to completion, or show what remains to be fixed to get it working. Start a test framework to help find bugs and race conditions in the current implementation, and to detect future regressions in multi-threading behavior.

**Recommended Skills**: Experience with thread-safety in C.

**Mentors**: [Jameson Nash](https://github.com/vtjnash), [Yichao Yu](https://github.com/yuyichao)

## C Linter

Memory errors in Julia's underlying C code are sometimes difficult to trace, and missing garbage-collector "roots" (GC roots) can lead to segfaults and other problems. One way to find such errors is to check Julia's `src/` directory for missing GC roots by determining which call chains can trigger garbage collection, and then looking for objects that lack GC root protection. Toward this end, a tool called [ClangSA.jl](https://github.com/Keno/ClangSA.jl) was developed using [Clang's static analyzer](http://clang-analyzer.llvm.org/) (as well as the [Cxx](https://github.com/Keno/Cxx.jl) package) and has been used to find some GC bugs. (alternatively, [coccinelle](http://coccinelle.lip6.fr/) could be investigated)

**Expected Results**: Expand and improve the ClangSA tool; potentially provide continuous integration support (for example, a [Nanosoldier](https://github.com/JuliaCI/Nanosoldier.jl) command).

**Required Skills**: Familiarity with C, runtimes, and experience with (or interest in) static analysis.

**Recommended Skills**: Experience with Julia's C runtime.

**Mentors**: [Keno Fischer](https://github.com/Keno), [Yichao Yu](https://github.com/yuyichao)
