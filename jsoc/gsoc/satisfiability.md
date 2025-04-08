# An Idiomatic, Native Julia Interface for SMT - Summer of Code 2025

Extending Satisfiability.jl with more SMT-LIB theories and expanded capabilities.

**Time Commitment:** 90h

Satisfiability modulo theories (SMT) is a powerful logic programming tool used (among other things) to formally verify programs and hardware for correctness and security. Currently, most solvers (that follow the SMT-LIB standard) require input to be specified in the SMT-LIB specification language, which is not really human-readable. 

[🔗 Satisfiability.jl](https://elsoroka.github.io/Satisfiability.jl/dev/) s a high-level interface that allows users to specify complex SMT formulas in pure, idiomatic Julia, and directly interfaces with solvers (e.g. Z3 or CVC5). Satisfiability.jl is **not** a solver; it is an interface to SMT solvers in the same sense that Convex.jl and Jump.jl are interfaces to numerical-optimization solvers. No experience with SMT solving algorithms is required for this project.

Goal. Satisfiability.jl supports just 3 theories so far, and is missing a few major theories: Arrays, Floating-point Numbers, and Strings.

This project aims to add support for one major SMT-LIB theory (either). This will bring us closer to our milestone of supporting all SMT-LIB theories, and allow Julia users to write more expressive constraints using these constructs to model more complex problems, and lay the groundwork for a maturing formal tools ecosystem in Julia.

Stretch goals for this project could include adding the capability for Satisfiability.jl to automatically determine what [logics] an SMT expression includes, which will help users determine what solvers are capable of solving it.

Scope. This project is scoped as a 90-hour project over 12 weeks.

**Skills:** Familiarity with automated reasoning/formal verification software such as Z3 or CVC5. Ideally, familiarity with the SMT-LIB language but this can be learned!

**Expected results:** new features added to the package along with tests, documentation, and a few examples demonstrating new features.

**Mentors:** [Emi Soroka](https://github.com/elsoroka/) and [Romeo Valentin](https://page.romeov.me/).

**Contact:** ping either mentor on the Julia slack.
