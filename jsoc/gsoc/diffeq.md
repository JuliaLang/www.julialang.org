# Numerical Differential Equations Projects – Summer of Code


## Native Julia ODE, SDE, DAE, DDE, and (S)PDE Solvers

The DifferentialEquations.jl ecosystem has an extensive set of state-of-the-art
methods for solving differential equations hosted by the [SciML Scientific Machine
Learning Software Organization](https://sciml.ai/). By mixing native methods and wrapped
methods under the same dispatch system, [DifferentialEquations.jl serves both as a system to deploy and research the most modern efficient methodologies](https://arxiv.org/abs/1807.06430).
While most of the basic methods have been developed and optimized, many newer
methods need high performance implementations and real-world tests of their
efficiency claims. In this project contributors will be paired with current
researchers in the discipline to get a handle on some of the latest techniques
and build efficient implementations into the \*DiffEq libraries
(OrdinaryDiffEq.jl, StochasticDiffEq.jl, DelayDiffEq.jl). Possible families of
methods to implement are:

@@tight-list
- Global error estimating ODE solvers
- Implicit-Explicit (IMEX) Methods
- Geometric (exponential) integrators
- Low memory Runge-Kutta methods
- Multistep methods specialized for second order ODEs (satellite simulation)
- Parallel (multithreaded) extrapolation (both explicit and implicit)
- Parallel Implicit Integrating Factor Methods (PDEs and SPDEs)
- Parallel-in-time ODE Methods
- Rosenbrock-W methods
- Approximate matrix factorization
- Runge-Kutta-Chebyshev Methods (high stability RK methods)
- Fully Implicit Runge-Kutta (FIRK) methods
- Anderson Acceleration
- Boundary value problem (BVP) solvers like MIRK and collocation methods
- BDF methods for differential-algebraic equations (DAEs)
- Methods for stiff stochastic differential equations
@@

Many of these methods are the basis of high-efficiency partial differential
equation (PDE) solvers and are thus important to many communities like
computational fluid dynamics, mathematical biology, and quantum mechanics.

This project is good for both software engineers interested in the field of
numerical analysis and those contributors who are interested in pursuing graduate
research in the field.

**Recommended Skills**: Background knowledge in numerical analysis, numerical
linear algebra, and the ability (or eagerness to learn) to write fast code.

**Expected Results**: Contributions of production-quality solver methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Improvements to Physics-Informend Neural networks (PINN) for solving differential equations

Neural networks can be used as a method for efficiently solving difficult partial differential equations. 
Efficient implementations of physics-informed machine learning from recent papers are being explored as 
part of the [NeuralPDE.jl](https://github.com/SciML/NeuralPDE.jl) package.
The [issue tracker](https://github.com/SciML/NeuralPDE.jl/issues) contains links to papers which 
would be interesting new neural network based methods to implement and benchmark against classical techniques.

**Recommended Skills**: Background knowledge in numerical analysis and machine learning.

**Expected Results**: New neural network based solver methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Performance enhancements for differential equation solvers

Wouldn't it be cool to have had a part in the development of widely used efficient differential equation solvers?
DifferentialEquations.jl has a wide range of existing methods and [an extensive benchmark suite](https://github.com/SciML/DiffEqBenchmarks.jl) which is used for tuning the methods for performance.
Many of its methods are already the fastest in their class, but there is still a lot of performance enhancement work that can be done.
In this project you can learn the details about a wide range of methods and dig into the optimization of the algorithm's strategy and the implementation in order to improve benchmarks.
Projects that could potentially improve the performance of the full differential equations ecosystem include:

@@tight-list
- Alternative adaptive stepsize techniques and step optimization
- Pointer swapping tricks
- Quasi-Newton globalization and optimization
- Cache size reductions
- Enhanced within-method multithreading, distributed parallelism, and GPU usage
- Improved automated method choosing
- Adaptive preconditioning on large-scale (PDE) discretizations
@@

**Recommended Skills**: Background knowledge in numerical analysis, numerical
linear algebra, and the ability (or eagerness to learn) to write fast code.

**Expected Results**: Improved benchmarks to share with the community.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Discretizations of partial differential equations

There are two ways to approach libraries for partial differential equations (PDEs): one can build "toolkits" which enable users to discretize any PDE but require knowledge
of numerical PDE methods, or one can build "full-stop" PDE solvers for specific
PDEs. There are many different ways solving PDEs could be approached, and here
are some ideas for potential projects:

@@tight-list
1. Automated PDE discretization tooling. We want users to describe a PDE in its mathematical form and automate the rest of the solution process. See [this issue for details](https://github.com/SciML/DifferentialEquations.jl/issues/469).
2. Enhancement of existing tools for discretizing PDEs. The finite differencing (FDM) library [DiffEqOperators.jl](https://github.com/SciML/DiffEqOperators.jl) could be enhanced to allow non-uniform grids or composition of operators. The finite element method (FEM) library [FEniCS.jl](https://github.com/SciML/FEniCS.jl) could wrap more of the FEniCS library.
3. Full stop solvers of common fluid dynamical equations, such as diffusion-advection-convection equations, or of hyperbolic PDEs such as the Hamilton-Jacobi-Bellman equations would be useful to many users.
4. Using stochastic differential equation (SDE) solvers to efficiently (and highly parallel) approximate certain PDEs.
5. Development of ODE solvers for more efficiently solving specific types of PDE discretizations. See the "Native Julia solvers for ordinary differential equations" project.
@@

**Recommended Skills**: Background knowledge in numerical methods for solving
differential equations. Some basic knowledge of PDEs, but mostly a willingness
to learn and a strong understanding of calculus and linear algebra.

**Expected Results**: A production-quality PDE solver package for some common PDEs.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Tools for global sensitivity analysis

Global Sensitivity Analysis is a popular tool to assess the effect that parameters
have on a differential equation model. A good introduction [can be found in this thesis](https://discovery.ucl.ac.uk/id/eprint/19896/). Global Sensitivity Analysis tools can be
much more efficient than Local Sensitivity Analysis tools, and give a better
view of how parameters affect the model in a more general sense.
The goal of this project would be to implement more global
sensitivity analysis methods like the eFAST method into [DiffEqSensitivity.jl](https://github.com/SciML/DiffEqSensitivity.jl) which
can be used with any differential equation solver on the common interface.

**Recommended Skills**: An understanding of how to use DifferentialEquations.jl
to solve equations.

**Expected Results**: Efficient functions for performing global sensitivity
analysis.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas), [Vaibhav Dixit](https://github.com/Vaibhavdixit02)

## Parameter identifiability analysis

Parameter identifiability analysis is an analysis that describes whether the
parameters of a dynamical system can be identified from data or whether they
are redundant. There are two forms of identifiability analysis: structural
and practical. Structural identifiability analysis relates changes in the
solution of the ODE directly to other parameters, showcasing that it is
impossible to distinguish between parameter A being higher and parameter B
being lower, or the vice versa situation, given only data about the solution
because of how the two interact. This could be done directly on the symbolic
form of the equation as part of
[ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl).
Meanwhile, practical identifiability analysis looks as to whether the parameters
are non-identifiable in a practical sense, for example if two parameters are
numerically indistinguishable (given possibly noisy data). In this case, numerical
techniques being built in DiffEqSensitivity.jl, such as a
[nonlinear likelihood profiler](https://github.com/SciML/DiffEqSensitivity.jl/issues/109)
or an
[information sensitivity measure](https://github.com/SciML/DiffEqSensitivity.jl/issues/108)
can be used to showcase whether a parameter has a unique enough effect to be determined.

**Recommended Skills**: A basic background in differential equations and the ability to use
numerical ODE solver libraries. Background in the numerical analysis of differential equation
solvers is not required.

**Expected Results**: Efficient and high-quality implementations of parameter identifiability
methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Model Order Reduction

Model order reduction is a technique for automatically finding a small model which approximates
the large model but is computationally much cheaper. We plan to use the infrastructure built
by ModelingToolkit.jl to [implement a litany of methods](https://github.com/SciML/ModelingToolkit.jl/issues/58)
and find out the best way to accelerate differential equation solves.

**Recommended Skills**: A basic background in differential equations and the ability to use
numerical ODE solver libraries. Background in the numerical analysis of differential equation
solvers is not required.

**Expected Results**: Efficient and high-quality implementations of model order reduction methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Automated symbolic manipulations of differential equation systems

Numerically solving a differential equation can be difficult, and thus it can be helpful for
users to simplify their model before handing it to the solver. Alas this takes time... so
let's automate it! [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl) is
a project for automating the model transformation process. Various parts of the library are
still open, such as:

@@tight-list
- Support for DAEs, DDEs, and SDEs
- Pantelides algorithm for DAE index reduction
- Lamperti transforms
- Automatic construction of adjoint solutions
- Tearing in nonlinear solvers
- Solving distributed delay equations
@@

**Recommended Skills**: A basic background in differential equations and the ability to use
numerical ODE solver libraries. Background in the numerical analysis of differential equation
solvers is not required.

**Expected Results**: Efficient and high-quality implementations of model transformation methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

