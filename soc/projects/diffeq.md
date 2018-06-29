---
layout: default
title:  DiffEq Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

## Stiffness Detection and Automatic Switching Algorithms

Stiffness is a phenomena in differential equations which requires implicit methods
in order to be efficiently solved. However, implicit methods are inherently
more costly and thus inefficient when they are not needed. This is an issue
because many problems are not always stiff, and instead switch from stiff
and non-stiff modes. The purpose of this project would be to develop functionality
for detecting stiffness during integration and testing algorithms for automatic
switching between appropriate algorithms. These would not only be more efficient
on a large class of problems, but also decrease the cognitive burden on the
user by being efficient for a large class of algorithms and likely become the
new default methods.

**Recommended Skills**: Background knowledge in numerical methods for solving
differential equations. The student is expected to already be familiar with
the concept of stiffness in ODEs, but not necessarily an expert.

**Expected Results**: Implementation of a trait-based engine for
algorithm-specific stiffness metrics, and implementations of new algorithms
for switching strategies.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Native Julia solvers for ordinary differential equations and algebraic differential equations

Julia needs to have a full set of ordinary differential equations (ODE) and
algebraic differential equation (DAE) solvers, as they are vital for numeric
programming. There are many advantages to having a native Julia implementation,
including the ability to use Julia-defined types (for things like arbitrary
precision) and composability with other packages. A library of methods can be
built for the common interface, seamlessly integrating with the other available
methods. Possible families of methods to implement are:

- High Order Exponential Runge-Kutta Methods, including efficient expmv methods
- Implicit-Explicit (IMEX) Methods
- Parallel ODE Methods
- Runge-Kutta-Chebyschev Methods
- Boundary value problem (BVP) solvers like MIRK and collocation methods

These methods are the basis of high-efficiency partial differential equation (PDE)
solvers and are thus important to many communities like computational fluid
dynamics, mathematical biology, and quantum mechanics.

**Recommended Skills**: Background knowledge in numerical analysis, numerical
linear algebra, and the ability (or eagerness to learn) to write fast code.

**Expected Results**: Contributions of production-quality ODE/DAE solver methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Tooling for molecular dynamics and N-body simulations

Molecular dynamics simulations are large N-body problems which predict the
properties of materials. While in theory anyone with an ODE solver can write
the ODE to be solved, in practice these problems can be very large and thus
very difficult to specify. The purpose of this project is to expand on the
tooling of [DiffEqPhysics.jl](https://github.com/JuliaDiffEq/DiffEqPhysics.jl)
to build methods for these types of simulations. Extensions to force-field
simulators which allow for constant temperature or use Lennard-Jones potentials,
along with tools for easily calculating system properties like temperature and
pressure, would make the Julia ecosystem much friendlier to these forms of
modeling.

**Recommended Skills**: Background knowledge in physics.

**Expected Results**: Tools for performing molecular dynamics simulations and
examples which show the usage of such tools.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas),
[David Sanders](https://github.com/dpsanders)

## Parallelization of the Sundials Solver Library

The Sundials set of solvers is a popular library for performing the time stepping
portion of large-scale partial differential equation (PDE) solvers. This library
has the ability to be internally parallelized, supporting threading, multi-node
distributed parallelism, and GPUs. The Julia package
[Sundials.jl](https://github.com/JuliaDiffEq/Sundials.jl) is a wrapper for the
Sundials library which is almost feature-complete with the wrapped code. However,
the functionality that it does not make use of is the parallelization. The purpose
of this project is to build the tooling to be able to utilize the parallelization
parts from within Julia, and benchmarking their effectiveness on large PDEs.

**Recommended Skills**: Background knowledge in C++. Some knowledge of parallel
computing is preferred.

**Expected Results**: Examples showing how to utilize the direct wrappers to
perform calculations in parallel and the ability to "flip a switch" to turn on
parallelism in high-level APIs.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Tools for global and adjoint sensitivity analysis

Global Sensitivity Analysis is a popular tool to assess the affect that parameters
have on a differential equation model. A good introduction [can be found in this thesis](http://discovery.ucl.ac.uk/19896/). Global Sensitivity Analysis tools can be
much more efficient than Local Sensitivity Analysis tools, and give a better
view of how parameters affect the model in a more general sense. Julia currently
has an implementation Local Sensitivity Analysis, but there is no method for Global
Sensitivity Analysis. The goal of this project would be to implement methods like
the Morris method in [DiffEqSensitivity.jl](https://github.com/JuliaDiffEq/DiffEqSensitivity.jl) which
can be used with any differential equation solver on the common interface.

In addition, adjoint sensitivity analysis is a more efficient method than
standard local sensitivity analysis when the number of parameters is large.
It is the differential equations extension of "backpropagation" and is used
in many other domains like parameter estimation as part of the optimization
process. An introduction to the adjoint sensitivity equations
[can be found in this documentation](https://computation.llnl.gov/casc/nsde/pubs/cvs_guide.pdf).

**Recommended Skills**: An understanding of how to use DifferentialEquations.jl
to solve equations.

**Expected Results**: Efficient functions for performing global and adjoint
sensitivity analysis.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Discretizations of partial differential equations

There are two ways to approach libraires for partial differential equations (PDEs):
one can build "toolkits" which enable users to discretize any PDE but require knowledge
of numerical PDE methods, or one can build "full-stop" PDE solvers for specific
PDEs. There are many different ways solving PDEs could be approached, and here
are some ideas for potential projects:

1. Enhancement of existing tools for discretizing PDEs. The finite differencing
   (FDM) library [DiffEqOperators.jl](https://github.com/JuliaDiffEq/DiffEqOperators.jl)
   could be enahnced to allow non-uniform grids or composition of operators. The
   finite element method (FEM) library [FEniCS.jl](https://github.com/JuliaDiffEq/FEniCS.jl)
   could wrap more of the FEniCS library.
2. Full stop solvers of common fluid dynamical equations, such as diffusion-advection-
   convection equations, or of hyperbolic PDEs such as the Hamilton-Jacobi-Bellman
   equations would be useful to many users.
3. Using stochastic differential equation (SDE) solvers to efficiently (and
   highly parallel) approximate certain PDEs.
4. Development of ODE solvers for more efficiently solving specific types of
   PDE discretizations. See the "Native Julia solvers for ordinary differential
   equations" project.

**Recommended Skills**: Background knowledge in numerical methods for solving
differential equations. Some basic knowledge of PDEs, but mostly a willingness
to learn and a strong understanding of calculus and linear algebra.

**Expected Results**: A production-quality PDE solver package for some common PDEs.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)
