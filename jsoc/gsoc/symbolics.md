# Symbolic computation project ideas

## Symbolic root finding

Symbolics.jl have robust ways to convert symbolic expressions into multi-variate polynomials. There is now a robust Groebner basis implementation in (Groebner.jl). Finding roots and varieties of sets of polynomials would be extremely useful in many applications. This project would involve implementing various techniques for solving polynomial systems, and where possible other non-linear equation systems. A good proposal should try to enumerate a number of techniques that are worth implementing, for example:

1. Analytical solutions for polynomial systems of degree <= 4
2. Use of HomotopyContinuations.jl for testing for solvability and finding numerical solutions
3. Newton-raphson methods
4. Using Groebner basis computations to find varieties

The API for these features should be extremely user-friendly:

1. A single `roots` function should take the sets of equations and result in the right type of roots as output (either varieties or numerical answers)
2. It should automatically find the fastest strategy to solve the set of equations and apply it.
3. It should fail with descriptive error messages when equations are not solvable, or degenerate in some way.
4. This should allow implementing symbolic eigenvalue computation when `eigs` is called.


**Mentors**: [Shashi Gowda](https://github.com/shashi), [Alexander Demin](https://github.com/sumiya11)
**Duration**: 350 hours

## Symbolic Integration in Symbolics.jl

Implement the [heuristic approach to symbolic integration](https://dspace.mit.edu/handle/1721.1/11997). Then hook into a repository of rules such as [RUMI](https://rulebasedintegration.org/). See also the potential of using symbolic-numeric integration techniques (https://github.com/SciML/SymbolicNumericIntegration.jl)

**Recommended Skills**: High school/Freshman Calculus

**Expected Results**: A working implementation of symbolic integration in the Symbolics.jl library, along with documentation and tutorials demonstrating its use in scientific disciplines.

**Mentors**: [Shashi Gowda](https://github.com/shashi), [Yingbo Ma](https://github.com/YingboMa)

**Duration**: 350 hours


## XLA-style optimization from symbolic tracing

Julia functions that take arrays and output arrays or scalars can be traced using Symbolics.jl variables to produce a trace of operations. This output can be optimized to use fused operations or call highly specific NNLib functions. In this project you will trace through Flux.jl neural-network functions and apply optimizations on the resultant symbolic expressions. This can be mostly implemented as rule-based rewriting rules (see https://github.com/JuliaSymbolics/Symbolics.jl/pull/514).


**Recommended Skills**: Knowledge of space and time complexities of array operations, experience in optimizing array code.

**Mentors**: [Shashi Gowda](https://github.com/shashi)

**Duration**: 175 hours


## Automatically improving floating point accuracy (Herbie)

[Herbie](https://herbie.uwplse.org/) documents a way to optimize floating point functions so as to reduce instruction count while reorganizing operations such that floating point inaccuracies do not get magnified. It would be a great addition to have this written in Julia and have it work on Symbolics.jl expressions. An ideal implementation would use the e-graph facilities of Metatheory.jl to implement this.

**Mentors**: [Shashi Gowda](https://github.com/shashi), [Alessandro Cheli](https://github.com/0x0f0f0f)

**Duration**: 350 hours
