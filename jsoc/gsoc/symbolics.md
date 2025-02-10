# Symbolic computation project ideas - Summer of Code

## Efficient Tensor Differentiation

Implement the [D* algorithm](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/main-65.pdf) for tensor expressions.

**Recommended Skills**: High school/freshman calculus and basic graph theory (optional)

**Expected Results**: A working implementation of the D* algorithm that is capable of performing efficient differentiations on tensor expressions.

**Mentors**: [Yingbo Ma](https://github.com/YingboMa)

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

## Reparametrizing ODE models with scaling transformations

**Project Overview:** Many ODE models appearing in applications have hidden symmetries which makes the solution of data fitting problem nonunique. [StructuralIdentifiability.jl](https://github.com/SciML/StructuralIdentifiability.jl) offers algorithms for proposing new coordinates for the model removing this redundancy. The approach used at the moment relies on heavy computations and may be very slow for larger models. Scaling is a particular type of reparametrizations which can be discovered much faster. The goal of the project would be to implement such faster algorithms (adapting them to the context of identifiability assessment) and integrate into StructuralIdentifiability.jl.

**Mentors:** [Alexander Demin](https://github.com/sumiya11), [Gleb Pogudin](https://www.lix.polytechnique.fr/Labo/Gleb.POGUDIN/)

**Project Difficulty**: Medium

**Estimated Duration**: 350 hours

**Ideal Candidate Profile:**
- Basic experience with Julia
- Knowledge of linear algebra

**Project Goals and Deliverables:**
- Implementation of an algorithm in Julia to perform scaling reparametrization of ODEs
- Comprehensive documentation and examples
- (Bonus) Integration with [StructuralIdentifiability.jl](https://github.com/SciML/StructuralIdentifiability.jl)

**Useful References:**
- [Paper on scaling transformations](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1008248)
- [More involved paper on scaling transformations](https://inria.hal.science/hal-00668882/)
- [Implementation in Python](https://desr.readthedocs.io/en/latest/intro.html)

## Polynomialization of ordinary differential equations

**Project Overview:** Many ODE models arising in modeling involve nonpolynomial functions (fractions, exponentials, trigonometric, etc). Polynomialization is the rewriting of nonpolynomial functions as equivalent polynomial equations. It is a necessary preprocessing step in several contexts (structural identifiability, model order reduction, reaction network synthesis). The project aims at implementing a package for polynomialization of ODEs and, potentially, adapting it for use in [StructuralIdentifiability.jl](https://github.com/SciML/StructuralIdentifiability.jl).

**Mentors:** [Alexander Demin](https://github.com/sumiya11), [Gleb Pogudin](https://www.lix.polytechnique.fr/Labo/Gleb.POGUDIN/), [Chris Rackauckas](https://www.chrisrackauckas.com/)

**Project Difficulty**: Medium

**Estimated Duration**: 350 hours

**Ideal Candidate Profile:**
- Basic experience with Julia
- Knowledge of ordinary differential equations

**Project Goals and Deliverables:**
- Implementation of an algorithm in Julia to perform polynomialization of ODEs
- Comprehensive documentation and examples
- (Bonus) Integration with [StructuralIdentifiability.jl](https://github.com/SciML/StructuralIdentifiability.jl)

**Useful References:**
- [Paper on polynomialization \#1](https://inria.hal.science/hal-03220725)
- [Paper on polynomialization \#2](https://dl.acm.org/doi/10.1145/1687399.1687474)
- [Relevant GitHub issue](https://github.com/SciML/StructuralIdentifiability.jl/issues/144)
- [An implementation of similar algorithms in Python](https://github.com/AndreyBychkov/QBee/blob/master/qbee/polynomialization.py)

