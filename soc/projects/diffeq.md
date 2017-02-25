---
layout: default
title:  DiffEq Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

## DiffEq-specific differentiation library to ease development of fast native stiff solvers

Methods for solving stiff differential equations and differential algebraic equations
(DAEs) are composed of similar calculus objects: gradients, Jacobians, etc. However,
not only are these objects common, but there are also very common use patterns.
For example, the quantity `(M - gamma*J)^(-1)`, (where `M` is a mass matrix, `J`
is the Jacobian, and `gamma` is a constant), is found in Rosenbrock methods,
Newton solvers for implicit Runge-Kutta methods, and update equations for
implicit multistep methods. However, the current setup requires that every solver
implements these functions on their own, leaving the chosen options and optimizations
as repeated work throughout the ecosystem.

The goal would be to create a library which exposes many different options
for computing these quantities to allow for easier development of native solvers.
Specifically, [ParameterizedFunctions.jl](https://github.com/JuliaDiffEq/ParameterizedFunctions.jl)
symbolically computes explicit functions for these quantities in many cases,
and the user can also specify the functions. But if no function is found,
then the library functions can provide fallbacks using
[ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl)
and [ReverseDiff.jl](https://github.com/JuliaDiff/ReverseDiff.jl) for autodifferentiation,
and [Calculus.jl](https://github.com/johnmyleswhite/Calculus.jl) for a fallback
when numerical differentiation most be used. Using the traits provided by
[DiffEqBase.jl](https://github.com/JuliaDiffEq/DiffEqBase.jl), this can all be
implemented with zero runtime overhead, utilizing Julia's JIT compiler to choose the
correct method at compile-time.

Students who take on this project will encounter and utilize many of the core
tools for scientific computing in Julia, and the result will be a very useful
library for all differential equation solvers.

For more details, see
[the following issue](https://github.com/JuliaDiffEq/DiffEqDiffTools.jl/issues/1).

**Recommended Skills**: Familiarity with multivariable calculus (Jacobians).

**Expected Results**: A high-performance backend library for native differential equation solvers.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Natural syntax parsing and symbolic transformations of differential equations

[ParameterizedFunctions.jl](https://github.com/JuliaDiffEq/ParameterizedFunctions.jl)
is a component of the JuliaDiffEq ecosystem that allows for users to define differential
equations in a natural syntax (with parameters). The benefits of this setup are threefold:

- The existence of parameters allows for optimization / machine learning techniques
  to be applied to and learn parameters from data.
- The natural syntax allows [DifferentialEquations.jl Online](http://app.juliadiffeq.org/)
  to have a user-friendly programming-free frontend.
- The setup allows for [SymEngine.jl](https://github.com/symengine/SymEngine.jl)
  to symbolically calculate various mathematical objects to speed up the solvers.

However, the macros are currently only able to parse ordinary differential equations (ODEs)
and stochastic differential equations (SDEs). An extension to the language and parser
will need to be introduced in order to handle differential algebraic equations (DAEs)
and delay differential equations (DDEs). In addition, symbolic enhancements could
be applied to automatically lower the index of the DAEs and transform delay equations
into larger systems of ODEs, greatly increasing the amount of equations which can
be easily solved. Finally, this improved parser can be used to develop new pages
for DifferentialEquations.jl Online for solving DAEs and DDEs.

**Recommended Skills**: Some previous knowledge of parsing.

**Expected Results**: An improved parser within the macro which supports delay and algebraic differential equations.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Native Julia solvers for ordinary differential equations and algebraic differential equations

Julia needs to have a full set of ordinary differential equations (ODE) and algebraic differential equation (DAE) solvers, as they are vital for numeric programming. There are many advantages to having a native Julia implementation, including the ability to use Julia-defined types (for things like arbitrary precision) and composability with other packages. A library of methods can be built for the common interface, seamlessly integrating with the other available methods. Possible families of methods to implement are:

- Exponential Runge-Kutta Methods
- Implicit-Explicit (IMEX) Runge-Kutta Methods
- Higher Order Rosenbrock Methods

**Recommended Skills**: Background knowledge in numerical analysis, numerical linear algebra, and the ability to write fast code.

**Expected Results**: A production-quality ODE/DAE solver package.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Expose the ARKODE methods of Sundials

In recent years, the popular Sundials library has added a suite of implicit-explicit Runge-Kutta methods for efficient solving of discretizations which commonly arise from PDEs. However, these new methods are not accessible from Sundials.jl. The goal of this project would be to expose the ARKODE solvers in [Sundials.jl](https://github.com/JuliaDiffEq/Sundials.jl) to the common JuliaDiffEq interface.

**Recommended Skills**: Background knowledge of C++.

**Expected Results**: An interface to the Sundials ARKODE methods in Sundials.jl.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Tools for global sensitivity analysis

Global Sensitivity Analysis is a popular tool to assess the affect that parameters have on a differential equation model. Global Sensitivity Analysis tools can be much more efficient than Local Sensitivity Analysis tools, and give a better view of how parameters affect the model in a more general sense. Julia currently has an implemention Local Sensitivity Analysis, but there is no method for Global Sensitivity Analysis. The goal of this project would be to implement methods like the Morris method in [DiffEqSensitivity.jl](https://github.com/JuliaDiffEq/DiffEqSensitivity.jl) which can be used with any differential equation solver on the common interface.

**Recommended Skills**: An understanding of how to use DifferentialEquations.jl to solve equations. 

**Expected Results**: Efficient functions for performing Global Sensitivity Analysis.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Machine learning for parameter estimation of differential equation models

Machine learning has become a popular tool for understanding data, but scientists typically want to use this data to better understand their differential equation-based models. The intersection between these two fields is parameter estimation. This is the idea of using techniques from machine learning in order to identify the values for model parameters from data. Currently, [DiffEqParamEstim.jl](https://github.com/JuliaDiffEq/DiffEqParamEstim.jl) shows how to link the differential equation solvers with the optimization packages for parameter estimation, but no link to machine learning tools have been created. The tools are all in place for this pairing between JuliaDiffEq and JuliaML.

**Recommended Skills**: Background knowledge of standard machine learning techniques and the usage of DifferentialEquations.jl

**Expected Results**: Modular tools for using JuliaML's libraries for parameter estimation of differential equations.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Bayesian estimation for parameters of differential equations

Bayesian estimation of parameters for differential equations is a popular technique since this outputs probability distributions for the underlying parameters. Julia's `ParameterizedFunction` makes it easy to solve differential equations with explicit parameters, and holds enough information to be used with [Stan.jl](https://github.com/goedman/Stan.jl). The purpose for this project is to create a function in [DiffEqParamEstim.jl](https://github.com/JuliaDiffEq/DiffEqParamEstim.jl) which translates the saved information of the model definition in a `ParameterizedFunction` to automatically write the input to Stan.jl, and tools for tweaking the inputs. Additionally, one can think about writing their own computational engine for Bayesian estimation using Julia-based tools like [Mocha.jl](https://github.com/pluskid/Mocha.jl) or [Klara.jl](https://github.com/JuliaStats/Klara.jl), which would be able to use more of the JuliaDiffEq ecosystem.

**Recommended Skills**: Background knowledge in Bayesian estimation.

**Expected Results**: A function which takes in a `ParameterizedFunction` and performs parameter estimation using Stan.jl

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Discretizations of partial differential equations

One of the major uses for differential equations solvers is for partial differential equations (PDEs). PDEs are solved by discretizing to create ODEs which are then solved using ODE solvers. However, in many cases a good understanding of the PDEs are required to perform this discretization and minimize the error. The purpose of this project is to produce a library with common PDE discretizations to make it easier for users to solve common PDEs.

The core of this project will be to build tooling that can be used to make it easy to discretize any partial differential equation in an efficient manner. This will be used to build a finite difference solver for the Heat Equation, a canonical problem in many fields, which can be profiled and benchmarked to ensure speed and accuracy. From there, the student can use these tools to take other canoncial partial differential equations, doing things such as:

1) Discretizations of fluid dynamical equations, such as diffusion-advection-convection equations. 
2) Extensions of discretizations to stochastic (random) partial differential equations.
3) Tackling more efficiency issues: full utilization of operator linearity, split operator and IMEX (implicit-explicit) discretizations.
4) Discretizations of hyperbolic PDEs such as the Hamilton-Jacobi-Bellman equations.
5) Using stochastic differential equation (SDE) solvers to efficiently (and highly parallel) approximate certain PDEs.

**Recommended Skills**: Background knowledge in numerical methods for solving differential equations. Some basic knowledge of PDEs, but mostly a willingness to learn and a strong understanding of calculus and linear algebra.

**Expected Results**: A production-quality PDE solver package for some common PDEs.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## A Wrapper for the Fenics Finite Element Toolbox

[FEniCS](https://fenicsproject.org/) is a popular finite element toolbox which makes it easy to build finite element discretizations of partial differential equations. These finite element toolboxes are decades long projects which require many man hours to build. Thus a pure-Julia library may not be feasible for quite some time, but are very useful in many scientific disciplines. The purpose of this project would be to build a wrapper for this library which makes it easy to use FEniCS within Julia.

**Recommended Skills**: Prior knowledge of linear algebra and calculus is recommended to understand the concepts. An understanding of numerical methods for PDEs is not required, but the ability to learn about them (and learn to use them) is. Previous experience with Python is recommended.

**Expected Results**: A production-quality wrapper of FEniCS.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)
