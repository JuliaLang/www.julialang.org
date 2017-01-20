# Theme: Numerical Methods for Differential Equations

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
then the library functions can must provide fallbacks using
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

**Expected Results**: A high-performance backend library for native differential equation solvers.

## Native Julia solvers for ordinary differential equations and algebraic differential equations

Julia needs to have a full set of ordinary differential equations (ODE) and algebraic differential equation (DAE) solvers, as they are vital for numeric programming. There are many advantages to having a native Julia implementation, including the ability to use Julia-defined types (for things like arbitrary precision) and composability with other packages. A library of methods can be built for the common interface, seamlessly integrating with the other available methods. Possible families of methods to implement are:

- Exponential Runge-Kutta Methods
- Implicit-Explicit (IMEX) Runge-Kutta Methods
- Higher Order Rosenbrock Methods

**Expected Results**: A production-quality ODE/DAE solver package.

## Expose the ARKODE methods of Sundials

In recent years, the popular Sundials library has added a suite of implicit-explicit Runge-Kutta methods for efficient solving of discretizations which commonly arise from PDEs. However, these new methods are not accessible from Sundials.jl. The goal of this project would be to expose the ARKODE solvers in [Sundials.jl](https://github.com/JuliaDiffEq/Sundials.jl) to the common JuliaDiffEq interface.

**Expected Results**: An interface to the Sundials ARKODE methods in Sundials.jl.

## Tools for global sensitivity analysis

Global Sensitivity Analysis is a popular tool to assess the affect that parameters have on a differential equation model. Global Sensitivity Analysis tools can be much more efficient than Local Sensitivity Analysis tools, and give a better view of how parameters affect the model in a more general sense. Julia currently has an implemention Local Sensitivity Analysis, but there is no method for Global Sensitivity Analysis. The goal of this project would be to implement methods like the Morris method in [DiffEqSensitivity.jl](https://github.com/JuliaDiffEq/DiffEqSensitivity.jl) which can be used with any differential equation solver on the common interface.

**Expected Results**: Efficient functions for performing Global Sensitivity Analysis.

## Machine learning for parameter estimation of differential equation models

Machine learning has become a popular tool for understanding data, but scientists typically want to use this data to better understand their differential equation-based models. The intersection between these two fields is parameter estimation. This is the idea of using techniques from machine learning in order to identify the values for model parameters from data. Currently, [DiffEqParamEstim.jl](https://github.com/JuliaDiffEq/DiffEqParamEstim.jl) shows how to link the differential equation solvers with the optimization packages for parameter estimation, but no link to machine learning tools have been created. The tools are all in place for this pairing between JuliaDiffEq and JuliaML.

**Expected Results**: Modular tools for using JuliaML's libraries for parameter estimation of differential equations.

## Bayesian estimation using Stan.jl for parameters of differential equations

Bayesian estimation of parameters for differential equations is a popular technique since this outputs probability distributions for the underlying parameters. Julia's `ParameterizedFunction` makes it easy to solve differential equations with explicit parameters, and holds enough information to be used with [Stan.jl](https://github.com/goedman/Stan.jl). The purpose for this project is to create a function in [DiffEqParamEstim.jl](https://github.com/JuliaDiffEq/DiffEqParamEstim.jl) which translates the saved information of the model definition in a `ParameterizedFunction` to automatically write the input to Stan.jl, and tools for tweaking the inputs.

**Expected Results**: A function which takes in a `ParameterizedFunction` and performs parameter estimation using Stan.jl

## Discretizations of partial differential equations

One of the major uses for differential equations solvers is for partial differential equations (PDEs). PDEs are solved by discretizing to create ODEs which are then solved using ODE solvers. However, in many cases a good understanding of the PDEs are required to perform this discretization and minimize the error. The purpose of this project is to produce a library with common PDE discretizations to make it easier for users to solve common PDEs.

**Expected Results**: A production-quality PDE solver package for some common PDEs.

## Improved plotting for differential equations

Plotting is a fundamental tool for analyzing the numerical solutions to differential equations. The plotting functionality in JuliaDiffEq is provided by plot recipes to [Plots.jl](https://github.com/tbreloff/Plots.jl) which create plots directly from the differential equation solution types. However, this functionality is currently limited. Some goals for this project would be:

- The ability to pass the triangular mesh into Plots.jl. This is essential for plotting the solutions to finite element PDE discretizations on non-convex domains.
- Methods for visualizing ODEs which change size.
- Visualizations for results of parameter sensitivity analysis and parameter estimation.

**Expected Results**: Publication-quality plot recipes.
