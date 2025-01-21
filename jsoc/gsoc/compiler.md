# Compiler Projects – Summer of Code

There are a number of compiler projects that are currently being worked on. Please contact Jameson Nash for
additional details and let us know what specifically interests you about this area of contribution.
That way, we can tailor your project to better suit your interests and skillset.

- **Better debug information output for variables (175 hours)**

  We have part of the infrastructure in place for representing DWARF information for our variables,
  but only from limited places. We could do much better since there are numerous opportunities for
  improvement!

**Expected Outcomes**: Ability to see more variable, argument, and object details in gdb\
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
