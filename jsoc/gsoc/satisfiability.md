# An Idiomatic, Native Julia Interface for SMT - Summer of Code 2025

Extending Satisfiability.jl with more SMT-LIB theories and expanded capabilities.

**Time Commitment:** 175h
**Difficulty:** Medium

Satisfiability modulo theories (SMT) is a powerful logic programming tool used (among other things) to formally verify programs and hardware for correctness and security. Currently, most solvers (that follow the SMT-LIB standard) require input to be specified in the SMT-LIB specification language, which is not really human-readable. 

[🔗 Satisfiability.jl](https://elsoroka.github.io/Satisfiability.jl/dev/) s a high-level interface that allows users to specify complex SMT formulas in pure, idiomatic Julia, and directly interfaces with solvers (e.g. Z3 or CVC5). Satisfiability.jl is **not** a solver; it is an interface to SMT solvers in the same sense that Convex.jl and Jump.jl are interfaces to numerical-optimization solvers. No experience with SMT solving algorithms is required for this project.

This project aims to extend Satisfiability.jl, a Julia package that provides an native, direct interface to SMT (Satisfiability Modulo Theories) solvers via the SMT-LIB specification language. Currently, Satisfiability.jl supports only three theories, and this project will implement one major additional theory (Arrays, Floating-point Numbers, or Strings) to bring the package closer to supporting all SMT-LIB theories.

This work will enhance the Julia ecosystem for formal verification and constraint satisfaction, allowing researchers and developers to interact with SMT solvers directly in pure

Approach
- Consult the SMT-LIB standard to design a clean, idiomatic Julia API
- Implement the selected theory with appropriate Julia types and operators
- Create comprehensive tests to ensure correctness and usability
- Write thorough documentation and examples to help users understand the new functionality

Main goals
- A fully implemented SMT-LIB theory with 100% test coverage
- Documentation and examples demonstrating usage
- An API design that feels natural in Julia and consistent with the package

Stretch goals
- Implementing a second theory
- Automated logic detection
- Improved parser for SMT solver output
- Performance benchmarking

**Skills:** Familiarity with automated reasoning/formal verification software such as Z3 or CVC5. Ideally, familiarity with the SMT-LIB language but this can be learned!

**Expected results:** new features added to the package along with tests, documentation, and a few examples demonstrating new features.

**Mentors:** [Emi Soroka](https://github.com/elsoroka/) and [Romeo Valentin](https://page.romeov.me/).

**Contact:** ping either mentor on the Julia slack.
