# Tooling - Summer of Code

## Development of a new language server for Julia (350 hours)

The goal of this project is to develop a new language server for Julia, currently called [JETLS](https://github.com/aviatesk/JETLS.jl), that enhances developer productivity through advanced static analysis and seamless integration with the Julia runtime.

JETLS has made significant progress and now implements a broad set of core LSP features.
Type-sensitive diagnostics are powered by [JET.jl](https://github.com/aviatesk/JET.jl), which uses [JuliaInterpreter.jl](https://github.com/JuliaDebug/JuliaInterpreter.jl) to load and analyze code.
Features like code completion, workspace symbols, find references, and rename are built by running [JuliaLowering.jl](https://github.com/JuliaLang/julia/tree/master/JuliaLowering) as a post-analysis step on top of the module context that JET/JuliaInterpreter has established.

The next major milestone is to feed JuliaLowering-generated code directly into JET's analysis, rather than running JuliaLowering as a post-processing step.
This deeper integration, combined with [Revise.jl](https://github.com/timholy/Revise.jl) for incremental analysis, will enable advanced features such as type-on-hover, inlay type hints, and argument-type-aware completions, as well as more precise diagnostic locations (currently reported at line granularity rather than column-precise positions).

During GSoC, we expect the contributor to work on these deeper integrations and implement the advanced language features that depend on them.
As preparation, we hope that by the time GSoC starts, you have studied the implementations of JETLS.jl and related tools: [JET.jl](https://github.com/aviatesk/JET.jl), [JuliaInterpreter.jl](https://github.com/JuliaDebug/JuliaInterpreter.jl), [Revise.jl](https://github.com/timholy/Revise.jl), and [JuliaLowering.jl](https://github.com/JuliaLang/julia/tree/master/JuliaLowering).

- **Expected Outcomes**: Advanced language server features built on top of full JuliaLowering/JET/Revise integration, such as type-on-hover, inlay type hints, and argument-type-aware completions.
- **Skills Required**:
    - Proficiency in Julia programming and familiarity with its compiler and runtime systems
    - Deep understanding of Julia's compiler internals, including lowering, type inference, and abstract interpretation as implemented in JET.jl, JuliaInterpreter.jl, and JuliaLowering.jl
    - Interest in and/or experience with LSP and developer tooling
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
