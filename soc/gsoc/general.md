---
layout: insidepage
title:  General Projects – Summer of Code
---

# {{ page.title }}

## Improving test coverage

Code coverage reports very good coverage of all of the Julia Stdlib packages, but it's not complete.
Additionally, the coverage tools themselves (--track-coverage and https://github.com/JuliaCI/Coverage.jl)
could be further enhanced, such as to give better accuracy of statement coverage, or more precision.
A successful project may combine a bit of both building code and finding faults in others' code.

Another related side-project might be to explore adding Type information to the coverage reports.

**Recommended Skills**: An eye for detail, a thrill for filing code issues, and the skill of breaking things.

**Contact:** [Jameson Nash](https://github.com/vtjnash)


## Automated performance measurements

The Nanosoldier.jl project (and related https://github.com/JuliaCI/BaseBenchmarks) tests for performance impacts of some changes.
However, there remains many areas that are not covered (such as compile time) while other areas are over-covered
(greatly increasing the duration of the test for no benefit) and some tests may not be configured appropriately for statistical power.
Furthermore, the current reports are very primitive and can only do a basic pair-wise comparison,
while graphs and other interactive tooling would be more valuable.
Thus, there would be many great projects for a summer student to tackle here!

**Contact:** [Jameson Nash](https://github.com/vtjnash), [Jarrett Revels](https://github.com/jrevels)


## Liquid Templating Library

[Liquid](http://shopify.github.io/liquid/) is a popular templating library, used primarily from Ruby. A pure Julia implementation
of Liquid would be useful for web application authors in Julia.

**Expected Results**: A pure Julia package that can compile a liquid template to Julia code.

**Recommended skills**: Basic Julia programming skills. Familiarity with parsing techniques.

**Mentors**: [Avik Sengupta](https://github.com/aviks/)


## Enhanced clipboard

Julia's functions for getting and setting the clipboard are currently limited to text; it would be useful to extend them to allow the transfer of other data (for example, spreadsheet data or images).

**Expected Results**: Extensible `clipboard()` and `clipboard(x)` functions to get and set the richest possible representation of the system clipboard data, as well as methods for specific types.

**Recommended skills**: Interfacing with C from Julia, clipboard APIs for different platforms. Familiarity with FileIO.jl.

**Mentors**: [Stefan Karpinski](https://github.com/StefanKarpinski)
