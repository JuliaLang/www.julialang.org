# Tooling - Summer of Code

## Development of a new language server for Julia (350 hours)

The goal of this project is to develop a new language server for Julia, currently called [JETLS](https://github.com/aviatesk/JETLS.jl).
This language server aims to enhance developer productivity by providing advanced static analysis and seamless integration with the Julia runtime.
By leveraging tooling technologies like JET, Revise and JuliaLowering, JETLS aims to offer enhanced language features such as type-sensitive diagnostics and macro-aware code completions.

The project is currently in the very early stages of prototyping. We've implemented the basic JSON message communication system and the protocol, but the core functionalities of the language server, including its analysis routines and incremental state management system, is still pretty primitive. The plan is to have the core functionalities of the language server more solid by the summer when GSoC 2025 starts, through working on implementing "diagnostics" and "completion" features. During GSoC, we expect to combine these core features with new tooling technologies like JuliaLowering.jl to implement new language server features, such as "go to definition" and "outline."

Also, as preparation, we hope that by the time GSoC starts, you'll have gained some knowledge about the implementation of JETLS.jl and tools like [JET.jl](https://github.com/aviatesk/JET.jl), [Revise.jl](https://github.com/timholy/Revise.jl) and [JuliaLowering.jl](https://github.com/c42f/JuliaLowering.jl/pulls).

- **Expected Outcomes**: A functional language server that significantly improves the developer experience for Julia users, with enhanced language capabilities including type-sensitive diagnostics and macro-aware code completions.
- **Skills Required**:
    - Proficiency in Julia programming and familiarity with its compiler and runtime systems
    - Interest in and/or experience with LSP and developer tools like JET.jl and Revise.jl
- **Difficulty**: Hard
- **Contact**: [Shuhei Kadowaki](https://github.com/aviatesk)

## Automation of testing / performance benchmarking (350 hours)

The Nanosoldier.jl project (and related <https://github.com/JuliaCI/BaseBenchmarks.jl>) tests for
performance impacts of some changes. However, there remains many areas that are not covered (such as
compile time) while other areas are over-covered (greatly increasing the duration of the test for no
benefit) and some tests may not be configured appropriately for statistical power. Furthermore, the
current reports are very primitive and can only do a basic pair-wise comparison, while graphs and
other interactive tooling would be more valuable. Thus, there would be many great projects for a
summer contributor to tackle here!

- **Expected Outcomes**: Improvement of Julia's automated testing/benchmarking framework.
- **Skills**: Interest in and/or experience with CI systems.
- **Difficulty**: Medium
- **Contact:** [Jameson Nash](https://github.com/vtjnash), [Tim Besard](https://github.com/maleadt)
