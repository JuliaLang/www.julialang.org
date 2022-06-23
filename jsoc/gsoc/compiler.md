# Compiler Projects – Summer of Code

There are a number of compiler projects that are currently being worked on. Please contact Ian Atol or Jameson Nash for
additional details and let us know what specifically interests you about this area of contribution.
That way, we can tailor your project to better suit your interests and skillset.

- **Julia Optimization Passes (350 hours)**

  The Julia compiler performs optimizations at two distinct times during native code generation: first at the "Julia level", and then at the "LLVM level".
  At the Julia level, we have some basic optimization passes (inlining, basic DCE,
  SROA), but currently many other interesting passes simply don't yet exist, or have a partial PR
  but need significant effort to finish. We see potential for many future optimizations at this phase of compilation, especially with some new analyses that have been recently added. For this proposal, we can work together to define which
  optimizations we could tackle next.

  **Expected Outcomes**: Improve upon the "Julia level" suite of optimizations and analyses. Ideally merge an optimization that improves Julia codegen by the end of the project timeline.
  **Skills**: Julia programming, some prior knowledge of compiler optimization techniques, creative thinking, and passion for performance!
  **Difficulty**: Medium


- **LLVM (350 hours)**
  As previously mentioned, the Julia language utilizes LLVM as a backend for code generation. This means that there are plenty of opportunities for those with knowledge of or interest in LLVM to contribute via working on Julia's code generation process. Together, we can figure out an appropriate task if you would like to work in this area. Below are some LLVM-related projects that may be of interest.

  **Expected Outcomes**: Improve upon the "LLVM level" of Julia codegen.
  **Skills**: C/C++ programming and some prior knowledge of LLVM (in the context of clang, Rust, Swift, etc... is fine)
  **Difficulty**: Hard

  - Investigating OrcJIT v2 improvements (350 hours)

    The LLVM JIT has gained many new features. This project would involve finding out what they are
    and making use of them. Some examples include better resource tracking, parallel compilation, a
    new linker (which may need upstream work too), and fine-grained tracking of relocations.


- **Parser error messages (and other parts) (350 hours)**

  Error messages and infrastructure could use some work to track source locations more precisely.
  This may be a large project. Contact me and @c42f for more details if this interests you.

  **Expected Outcomes**: Improve upon Julia parser error messages.
  **Skills**: Some familiarity with parsers
  **Difficulty**: Medium

- **Macro hygiene re-implementation, to eliminate incorrect predictions inherent in current approach (350 hours)**

  This may be a good project for someone that wants to learn lisp/scheme! Our current algorithm runs
  in multiple passes, which means sometimes we compute the wrong scope for a variable in the earlier
  pass than when we assign the actual scope to each value. See
  <https://github.com/JuliaLang/julia/labels/macros>, and particularly issues such as
  <https://github.com/JuliaLang/julia/issues/20241> and
  <https://github.com/JuliaLang/julia/issues/34164>.

  **Expected Outcomes**: Ideally, re-implementation of hygienic macros. Realistically, resolving some or any of the `macros` issues.
  **Skills**: Lisp/Scheme/Racket experience desired but not necessarily required.
  **Difficulty**: Medium

- **Better debug information output for variables (350 hours)**

  We have part of the infrastructure in place for representing DWARF information for our variables,
  but only from limited places. We could do much better since there are numerous opportunities for
  improvement!

**Expected Outcomes**: Varies by project.
**Recommended Skills**: Most of these projects involve algorithms work, requiring
a willingness and interest in seeing how to integrate with a large system.
**Difficulty**: Varies by project.

**Mentors**: [Jameson Nash](https://github.com/vtjnash), [Ian Atol](https://github.com/ianatol)

## Improving test coverage (350 hours)

Code coverage reports very good coverage of all of the Julia Stdlib packages, but it's not complete.
Additionally, the coverage tools themselves (--track-coverage and
<https://github.com/JuliaCI/Coverage.jl>) could be further enhanced, such as to give better accuracy
of statement coverage, or more precision. A successful project may combine a bit of both building
code and finding faults in others' code.

Another related side-project might be to explore adding Type information to the coverage reports?

**Recommended Skills**: An eye for detail, a thrill for filing code issues, and the skill of breaking things.

**Contact:** [Jameson Nash](https://github.com/vtjnash)

## Multi-threading Improvement Projects (350 hours)

A few ideas to get you started, in brief:

- Make better use of threads for GC (and particularly, make the page-allocator multi-threaded)

- Improve granularity of codegen JIT for multi-threading

- Improve granularity of IO operations for multi-threading (and set up a worker thread for running
  the main libuv event loop)

- Measure and optimize the performance of the `partr` algorithm, and add the ability to dynamically
  scale it by workload size

- Automatic insertion of GC safe-points/regions, particularly around loops

- Work towards supporting a dynamic number of threads

Join the regularly scheduled multithreading call for discussion of any of these at [#multithreading
BoF calendar invite][threadcall] on the Julia Language Public Events calendar.

[threadcall]: https://calendar.google.com/event?action=TEMPLATE&tmeid=MzQ1MnZxMGNucGt2NGQwYW1zZjA4MzM5dGtfMjAyMTAyMTdUMTYzMDAwWiBqdWxpYWxhbmcub3JnX2tvbWF1YXFldDE0ZW9nOW9pdjNwNm83cG1nQGc&tmsrc=julialang.org_komauaqet14eog9oiv3p6o7pmg%40group.calendar.google.com&scp=ALL

**Recommended Skills**: Varies by project

**Contact:** [Jameson Nash](https://github.com/vtjnash)


## Automation of testing / performance benchmarking (350 hours)

The Nanosoldier.jl project (and related <https://github.com/JuliaCI/BaseBenchmarks.jl>) tests for
performance impacts of some changes. However, there remains many areas that are not covered (such as
compile time) while other areas are over-covered (greatly increasing the duration of the test for no
benefit) and some tests may not be configured appropriately for statistical power. Furthermore, the
current reports are very primitive and can only do a basic pair-wise comparison, while graphs and
other interactive tooling would be more valuable. Thus, there would be many great projects for a
summer contributor to tackle here!

**Expected Outcomes**: Improvement of Julia's automated testing/benchmarking framework.
**Skills**: Interest in and/or experience with CI systems.
**Difficulty**: Medium

**Contact:** [Jameson Nash](https://github.com/vtjnash), [Tim Besard](https://github.com/maleadt)
