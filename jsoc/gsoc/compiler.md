# Compiler Projects – Summer of Code

There are a number of compiler projects that are currently being worked on. Please contact Jameson Nash for
additional details and let us know what specifically interests you about this area of contribution.
That way, we can tailor your project to better suit your interests and skillset.

- **LLVM AliasAnalysis (175-350 hours)**
  The Julia language utilizes LLVM as a backend for code generation, so the quality of code generation is very important for performance. This means that there are plenty of opportunities for those with knowledge of or interest in LLVM to contribute via working on Julia's code generation process. We have recently encountered issues with memcpy information only accepting a single aliasing metadata argument, rather than separate information for the source and destination. There are other similar missing descriptive or optimization steps in the aliasing information we produce or consume by LLVM's passes.

  **Expected Outcomes**: Improve upon the alias information "LLVM level" of Julia codegen.\
  **Skills**: C/C++ programming\
  **Difficulty**: Hard

- **Macro hygiene re-implementation, to eliminate incorrect predictions inherent in current approach (350 hours)**

  This may be a good project for someone that wants to learn lisp/scheme! Our current algorithm runs
  in multiple passes, which means sometimes we compute the wrong scope for a variable in the earlier
  pass than when we assign the actual scope to each value. See
  <https://github.com/JuliaLang/julia/labels/macros>, and particularly issues such as
  <https://github.com/JuliaLang/julia/issues/20241>,
  <https://github.com/JuliaLang/julia/issues/53667>,
  <https://github.com/JuliaLang/julia/issues/53673> and
  <https://github.com/JuliaLang/julia/issues/34164>.

  **Expected Outcomes**: Ideally, re-implementation of hygienic macros. Realistically, resolving some or any of the `macros` issues.\
  **Skills**: Lisp/Scheme/Racket experience desired but not necessarily required.\
  **Difficulty**: Medium

- **Better debug information output for variables (175 hours)**

  We have part of the infrastructure in place for representing DWARF information for our variables,
  but only from limited places. We could do much better since there are numerous opportunities for
  improvement!

**Expected Outcomes**: Ability to see more variable, argument, and object details in gdb
**Recommended Skills**: Most of these projects involve algorithms work, requiring
a willingness and interest in seeing how to integrate with a large system.\
**Difficulty**: Medium\
**Mentors**: [Jameson Nash](https://github.com/vtjnash), [Gabriel Baraldi
](https://github.com/gbaraldi)

## Improving test coverage (175 hours)

Code coverage reports very good coverage of all of the Julia Stdlib packages, but it's not complete.
Additionally, the coverage tools themselves (--track-coverage and
<https://github.com/JuliaCI/Coverage.jl>) could be further enhanced, such as to give better accuracy
of statement coverage, or more precision. A successful project may combine a bit of both building
code and finding faults in others' code.

Another related side-project might be to explore adding Type information to the coverage reports?

**Recommended Skills**: An eye for detail, a thrill for filing code issues, and the skill of breaking things.\
**Contact:** [Jameson Nash](https://github.com/vtjnash)

## Multi-threading Improvement Projects (175 hours each)

Continuous on-going work is being done to improve the correctness and threaded code.
A few ideas to get you started on how to join this effort, in brief, include:

- Measure and optimize the performance of the scheduler `partr` algorithm, and add the ability to dynamically
  scale it by workload size. Or replace it with a `workstealing` implementation in Julia.

- Automatic insertion, and subsequent optimization, of GC safe-points/regions, particularly around loops.
  Similarly for `ccall`, implement the ability to define a particular `ccall` as being a safe-region.

- Solve various thread-safety and data-race bugs in the runtime.
  (e.g. <https://github.com/JuliaLang/julia/issues/49778> and <https://github.com/JuliaLang/julia/pull/42810>)

Join the regularly scheduled multithreading call for discussion of any of these at [#multithreading
BoF calendar invite][threadcall] on the Julia Language Public Events calendar.

[threadcall]: https://calendar.google.com/event?action=TEMPLATE&tmeid=MzQ1MnZxMGNucGt2NGQwYW1zZjA4MzM5dGtfMjAyMTAyMTdUMTYzMDAwWiBqdWxpYWxhbmcub3JnX2tvbWF1YXFldDE0ZW9nOW9pdjNwNm83cG1nQGc&tmsrc=julialang.org_komauaqet14eog9oiv3p6o7pmg%40group.calendar.google.com&scp=ALL

**Recommended Skills**: Varies by project, but generally some multi-threading and C experience is needed\
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
