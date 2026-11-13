# Constraint Programming in Julia

[JuliaConstraints](https://github.com/JuliaConstraints) is an organization supporting packages for Constraint Programming in Julia. Although it is independent of it, it aims for a tight integration with JuMP.jl over time. For a detailed overview of basic Constraint Programming in Julia, please have a look at our video from JuliaCon 2021 [Put some constraints into your life with JuliaCon(straints)](https://youtu.be/G4siuvNMj0c).

### General goal of JuliaConstraints

Often, problem-solving involves taking two actions: model and solve. Typically, there is a trade-off between ease of modeling and efficiency of solving. Therefore, one is often required to be a specialist to model and solve an optimization problem efficiently. We investigate the theoretical fundamentals and the implementation of tools to automize and make optimization frameworks. A general user should focus on the model of practical problems, regardless of the software or hardware available. Furthermore, we aim to encourage technical users to use our tools to improve their solving efficiency.

**Mentor:** [Jean-Francois Baffier](http://baffier.fr/) ([azzaare@github](https://github.com/Azzaare))

## [PerfChecker.jl](https://github.com/JuliaConstraints/PerfChecker.jl)

This package consists of a set of tools designed to check the performance of packages over time and versions. The targeted audience is the whole community of packages' developers in Julia (not only JuliaConstraints).

The [README](https://github.com/JuliaConstraints/PerfChecker.jl) provides a short *demo* on how PerfChecker can be used.

Basic features to implement (*length* ≈ 175 hours)

    - PerfCheck environment similar to Test.jl and Pkg.jl
      - Sugar syntax `@bench`, `@alloc`, `@profile` similar to Test.jl and Pkg.jl
      - Interactive REPL interface
    - Interactive GUI interface (using for instance Makie)
    - Automatic Profiling ? (not sure how, there already is a bunch of super cool packages)
    - Automatic plotting of previous features

Advanced features (length +≈ 175 hours)

    - *Smart* semi-automatic analysis of performances
      - performances bottlenecks
      - regressions
      - allocations vs speed trade-off
      - descriptive plot captions
    - Handle Julia and other packages versions
      - Integrates with juliaup
      - Automatically generate versions parametric space for both packages and Julia

Note that some features are interchangeable depending on the interest of the candidate. For candidates with a special interest in the JuliaConstraints ecosystem, checking the performances of some packages is an option.

**Length**: 175 hours -- 350 hours (depending on features)

**Recommended Skills (||)**:

    - Familiarity with package development
    - REPL and/or GUI interfaces
    - Coverage, Benchmarks, and Profiling tools

**Difficulty:** Easy to Medium, depending on the features implemented

## [Constraints.jl](https://github.com/JuliaConstraints/Constraints.jl) integrations into JuMP.jl

Constraints.jl provides an interface to work with and store information about constraints, a predicate over a set of variables that is the core of modeling and solving in constraint programming.
Recently, a [few common constraints](https://jump.dev/JuMP.jl/stable/moi/reference/standard_form/#Constraint-programming-sets) have been natively integrated into the JuMP modeling language for mathematical optimization. In Constraints.jl, we provide an implementation of about 20 core constraints from XCSP³-core. Our target here is to integrate the constraints currently missing in JuMP to provide a wider spectrum to CP and mathematical optimization users when using JuMP.
Additionally, these constraints should be plugged with [CBLS.jl](https://github.com/JuliaConstraints/CBLS.jl), the JuMP interface of [LocalSearchSolvers.jl](https://github.com/JuliaConstraints/LocalSearchSolvers.jl).

Ideally, we want to provide basic JuMP(MOI) [bridges](https://jump.dev/JuMP.jl/stable/moi/tutorials/bridging_constraint/) to translate those constraints to classical optimization sets.

(Note: at the time of writing this proposal, CBLS.jl is yet to be updated to interface JuMP v1 which would be a nice first issue to get familiar with the project)

**Length**: 175 hours -- 350 hours (depending on features such as bridges)

**Recommended Skills**:

    - Familiarity with JuMP and MOI packages
    - Understanding of basic constraint programming

**Difficulty:** Medium to hard, depending on the features implemented
