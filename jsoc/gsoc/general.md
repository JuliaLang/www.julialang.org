
# General Projects – Summer of Code

## Improving test coverage

Code coverage reports very good coverage of all of the Julia Stdlib packages, but it's not complete.
Additionally, the coverage tools themselves (--track-coverage and https://github.com/JuliaCI/Coverage.jl)
could be further enhanced, such as to give better accuracy of statement coverage, or more precision.
A successful project may combine a bit of both building code and finding faults in others' code.

Another related side-project might be to explore adding Type information to the coverage reports.

**Recommended Skills**: An eye for detail, a thrill for filing code issues, and the skill of breaking things.

**Contact:** [Jameson Nash](https://github.com/vtjnash)


## Automated performance measurements

The Nanosoldier.jl project (and related https://github.com/JuliaCI/BaseBenchmarks.jl) tests for performance impacts of some changes.
However, there remains many areas that are not covered (such as compile time) while other areas are over-covered
(greatly increasing the duration of the test for no benefit) and some tests may not be configured appropriately for statistical power.
Furthermore, the current reports are very primitive and can only do a basic pair-wise comparison,
while graphs and other interactive tooling would be more valuable.
Thus, there would be many great projects for a summer student to tackle here!

**Contact:** [Jameson Nash](https://github.com/vtjnash), [Tim Besard](https://github.com/maleadt)


## Extend RegEx support for invalid UTF-8

Currently, encountering invalid unicode encodings can cause undefined behavior in PCRE2. However, verifying the content is valid is expensive. It'd be faster to simply give it some defined behavior. For the standard code-path, this is pretty simple. For the JIT compiler, this is nearly undocumented and requires more knowledge thus of working with code transpilers (aka compilers). There's two possible avenues here to investigate:

@@tight-list
 - Implement a series of patches to make PCRE2 more robust to "invalid" input. Together, we'll work with upstream to identify how to contribute these back.
 - Switch away from PCRE2 to another regex library as the default. This may possibly also imply patching the alternate library. You'd be expected to present the comparison between the possible options and explain why the switch is warranted.
@@

**Contact:** [Jameson Nash](https://github.com/vtjnash)
