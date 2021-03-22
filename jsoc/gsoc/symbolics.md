# Symbolic computation project ideas

## Groebner basis and Symbolic root finding

Implement solving polynomial equation systems symbolically. (I.e. finding the variety of a set of polynomials). This involves first computing the groebner basis for a set of polynomials. Groebner basis computation is NP complete so it is essential that the implementation is practical. It should start by studying the literature on state-of-the art Groebner basis solvers.

**Recommended Skills**: Calculus and discrete mathematics. Prior knowledge of computational algebra and ring theory is preferred.

**Expected Results**: Working Groebner basis and rootfinding algorithms to be deployed in the Symbolics.jl package, along with documentation and tutorials.

**Mentors**: [Shashi Gowda](https://github.com/shashi), [Yingbo Ma](https://github.com/YingboMa), [Mason Protter](https://github.com/MasonProtter)

## Symbolic Integration

Implement the [heuristic approach to symbolic integration](https://dspace.mit.edu/handle/1721.1/11997). Then hook into a repository of rules such as [RUMI](https://rulebasedintegration.org/)

**Recommended Skills**: Calculus

**Expected Results**: A working implementation of symbolic integration in the Symbolics.jl library, along with documentation and tutorials demonstrating its use in scientific disciplines.

**Mentors**: [Shashi Gowda](https://github.com/shashi), [Yingbo Ma](https://github.com/YingboMa), [Mason Protter](https://github.com/MasonProtter)

