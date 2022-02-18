@def mintoclevel = 2

# Numerical Projects – Summer of Code

\toc

## Numerical Linear Algebra

### Matrix functions

Matrix functions map matrices onto other matrices, and can often be interpreted as generalizations of ordinary functions like sine and exponential, which map numbers to numbers. Once considered a niche province of numerical algorithms, matrix functions now appear routinely in applications to cryptography, aircraft design, nonlinear dynamics, and finance.

This project proposes to implement state of the art algorithms that extend the currently available matrix functions in Julia, as outlined in issue [#5840](https://github.com/JuliaLang/julia/issues/5840). In addition to matrix generalizations of standard functions such as real matrix powers, surds and logarithms, contributors will be challenged to design generic interfaces for lifting general scalar-valued functions to their matrix analogues for the efficient computation of arbitrary (well-behaved) matrix functions and their derivatives.

**Recommended Skills**: A strong understanding of calculus and numerical analysis.

**Expected Results**: New and faster methods for evaluating matrix functions.

**Mentors:** [Jiahao Chen](https://github.com/jiahao), [Steven Johnson](https://github.com/stevengj).

**Difficulty:** Hard

<!--- Commented out since it was not updated for Summer 2021. 

## Interval arithmetic

### A standards-compliant interval arithmetic library

Interval arithmetic provides a way to perform computations with floating-point numbers that are guaranteed to be correct, by
wrapping each operand in an interval. [`ValidatedNumerics.jl`](https://github.com/dpsanders/ValidatedNumerics.jl) is a native Julia package providing interval functions that has a significant amount of functionality.

This project proposes to achieve compliance of this package with the [IEEE 1788-2015 Standard](https://standards.ieee.org/findstds/standard/1788-2015.html), which specifies how interval arithmetic packages should behave. This would make the package one of the first few packages to be fully compliant with the standard. It would involve adding some functions, writing documentation, improving the test suite, writing a compliance document, and overhauling and simplifying the code that already exists. The goal is to make this package a reference for interval arithmetic implementations.

**Recommended Skills**: Mathematical background; a basic understanding of floating-point arithmetic; an eye for detail and aesthetics; strong writing skills.

**Expected results**: A library that fulfills the IEEE 1788-2015 standard.

**Mentors:** [David P. Sanders](https://github.com/dpsanders)


### Guaranteed root finding with intervals

Interval arithmetic provides a way to perform computations with continuous sets of real  numbers or vectors, for example to bound the range of a function over a given set.

This can be used to find roots (zeros) of functions in a *guaranteed* way, by excluding regions where there are no roots and zooming in on roots, but always within a given interval.

A basic branch-and-prune algorithm has been implemented in  [`IntervalRootFinding.jl`](https://github.com/JuliaIntervals/IntervalRootFinding.jl).

This project proposes to significantly improve these methods using techniques found in the interval arithmetic literature.

**Recommended skills**: Multivariable calculus and linear algebra; a basic understanding of floating-point arithmetic.

**Expected results**: A state-of-the-art root finding library in pure Julia.

**Mentors:** [David P. Sanders](https://github.com/dpsanders), [Luis Benet](https://github.com/lbenet)


### Global optimization with intervals

Interval arithmetic provides a way to perform computations with continuous sets of real  numbers or vectors, for example to bound the range of a function over a given set.

This can be used to do global optimization of functions in a deterministic way, that is, find the global minimum of a non-convex, nonlinear function $f:\mathbb{R}^n \to \mathbb{R}$.
Interval methods for global optimization provide a guaranteed bound for the global optimum, and sets that contain the optimizers.

A basic branch-and-bound algorithm has already been implemented in  [`IntervalOptimisation.jl`](https://github.com/JuliaIntervals/IntervalOptimisation.jl), but it can be significantly improved.

This project proposes to develop a state-of-the-art global optimization routine in Julia, by applying techniques found in the interval arithmetic and global optimization literature.
This may involve developing code for McCormick relaxations and/or affine arithmetic.

**Recommended skills**: Multivariable calculus and linear algebra; a basic understanding of floating-point arithmetic.

**Expected results**: A state-of-the-art global optimization library in pure Julia.

**Mentors:** [David P. Sanders](https://github.com/dpsanders)


### Taylor models and a guaranteed ODE solver

By combining interval arithmetic and Taylor series, we get **Taylor models**, which are guaranteed (rigorous) approximations of functions.
Using these, it is possible to
write a Taylor integrator for ordinary differential equations (ODEs) that gives guaranteed results, i.e. we get a "tube" that is guaranteed to contain the true solution of the ODE.

Some groundwork for this has been laid in the `TaylorModels.jl` package.
 The project will require reading papers on the subject and experimenting with different implementations for performance, for example using different polynomial representations.


**Recommended skills**: Multivariable calculus and linear algebra; understanding of floating-point arithmetic; ability to read papers and implement generic algorithms which allow to swap different libraries in and out.

**Expected results**: A state-of-the-art library for Taylor models.

**Mentors:** [David P. Sanders](https://github.com/dpsanders), [Luis Benet](https://github.com/lbenet), [Marcelo Forets](https://github.com/mforets)
-->

## Better Bignums Integration

Julia currently supports big integers and rationals, making use of the GMP. However, GMP currently doesn't permit good integration with a garbage collector.

This project therefore involves exploring ways to improve BigInt, possibly including:

@@tight-list
* Modifying GMP to support high-performance garbage-collection
* Reimplementation of aspects of BigInt in Julia
* Lazy graph style APIs which can rewrite terms or apply optimisations
@@

This experimentation could be carried out as a package with a new implementation, or as patches over the existing implementation in Base.

**Expected Results**: An implementation of BigInt in Julia with increased performance over the current one.

**Require Skills**: Familiarity with extended precision numerics OR performance considerations. Familiarity either with Julia or GMP.

**Mentors**: [Jameson Nash](https://github.com/vtjnash)

**Difficulty:** Hard

### Special functions

As a technical computing language, Julia provides a huge number of
[special functions](https://en.wikipedia.org/wiki/Special_functions), both in Base as well
as packages such as [StatsFuns.jl](https://github.com/JuliaStats/StatsFuns.jl). At the
moment, many of these are implemented in external libraries such as
[Rmath](https://github.com/JuliaLang/Rmath-julia) and
[openspecfun](https://github.com/JuliaLang/openspecfun). This project would involve
implementing these functions in native Julia (possibly utilising the work in
[SpecialFunctions.jl](https://github.com/nolta/SpecialFunctions.jl)),
seeking out opportunities for possible improvements along the way, such as supporting
`Float32` and `BigFloat`, exploiting fused multiply-add operations, and improving errors
and boundary cases.

**Recommended Skills**: A strong understanding of calculus.

**Expected Results**: New and faster methods for evaluating properties of special functions.

**Mentors:** [Steven Johnson](https://github.com/stevengj), [Oscar Smith](https://github.com/oscardssmith). Ask on Discourse or on slack

### A Julia-native CCSA optimization algorithm

The CCSA algorithm by [Svanberg (2001)](https://epubs.siam.org/doi/10.1137/S1052623499362822) is a [nonlinear programming algorithm](https://en.wikipedia.org/wiki/Nonlinear_programming) widely used in [topology optimization](https://en.wikipedia.org/wiki/Topology_optimization) and for other large-scale optimization problems: it is a robust algorithm that can handle arbitrary nonlinear inequality constraints and huge numbers of degrees of freedom.  Moreover, the relative simplicity of the algorithm makes it possible to easily incorporate sparsity in the Jacobian matrix (for handling huge numbers of constraints), approximate-Hessian preconditioners, and as special-case optimizations for affine terms in the objective or constraints.  However, currently it is only available in Julia via the [NLopt.jl](https://github.com/JuliaOpt/NLopt.jl) interface to an external C implementation, which greatly limits its flexibility.

**Recommended Skills**: Experience with nonlinear optimization algorithms and understanding of [Lagrange duality](https://en.wikipedia.org/wiki/Duality_(optimization)), familiarity with sparse matrices and other Julia data structures.

**Expected Results**: A package implementing a native-Julia CCSA algorithm.

**Mentors:** [Steven Johnson](https://github.com/stevengj).

