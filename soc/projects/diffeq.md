---
layout: default
title:  DiffEq Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

## Native Julia ODE, SDE, DAE, DDE, and (S)PDE Solvers

The DifferentialEquations.jl ecosystem has an extensive set of state-of-the-art
methods for solving differential equations. By mixing native methods and wrapped
methods under the same dispatch system, [DifferentialEquations.jl serves both as a system to deploy and research the most modern efficient methodologies](https://arxiv.org/abs/1807.06430).
While most of the basic methods have been developed and optimized, many newer
methods need high performance implementations and real-world tests of their
efficiency claims. In this project students will be paired with current
researchers in the discipline to get a handle on some of the latest techniques
and build efficient implementations into the \*DiffEq libraries
(OrdinaryDiffEq.jl, StochasticDiffEq.jl, DelayDiffEq.jl). Possible families of
methods to implement are:

- Implicit-Explicit (IMEX) Methods
- Geometric (exponential) integrators
- Low memory Runge-Kutta methods
- Multistep methods specialized for second order ODEs (satellite simulation)
- Parallel (multithreaded) extrapolation (both explicit and implicit)
- Parallel Implicit Integrating Factor Methods (PDEs and SPDEs)
- Parallel-in-time ODE Methods
- Rosenbrock-W methods
- Approximate matrix factorization
- Runge-Kutta-Chebyschev Methods (high stability RK methods)
- Fully Implicit Runge-Kutta (FIRK) methods
- Anderson Acceleration 
- Boundary value problem (BVP) solvers like MIRK and collocation methods
- BDF methods for differential-algebraic equations (DAEs)
- Methods for stiff stochastic differential equations

Many of these methods are the basis of high-efficiency partial differential
equation (PDE) solvers and are thus important to many communities like
computational fluid dynamics, mathematical biology, and quantum mechanics.

**Recommended Skills**: Background knowledge in numerical analysis, numerical
linear algebra, and the ability (or eagerness to learn) to write fast code.

**Expected Results**: Contributions of production-quality solver methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Performance enhancements for differential equation solvers

Wouldn't it be cool to have had a part in the development of widely used efficient 
differential equation solvers? DifferentialEquations.jl has a wide range of existing
methods and [an extensive benchmark suite](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl)
which is used for tuning the methods for performance. Many of its methods are already the fastest
in their class, but there is still a lot of performance enhancement work that can be done. 
In this project you can learn the details about a wide range of methods and dig into the 
optimization of the algorithm's strategy and the implementation in order to improve benhcmarks. 
Projects that could potentially improve the performance of the full differential equations 
ecosystem include:

- Alternative adaptive stepsize techniques and step optimization
- Pointer swapping tricks
- Quasi-Newton globalization and optimization
- Cache size reductions
- Enhanced within-method multithreading, distributed parallelism, and GPU usage
- Improved automated method choosing
- Adaptive preconditioning on large-scale (PDE) discretizations

**Recommended Skills**: Background knowledge in numerical analysis, numerical
linear algebra, and the ability (or eagerness to learn) to write fast code.

**Expected Results**: Improved benchmarks to share with the community.

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

## Automatic Computation of Sparse Jacobians

Differential equation systems which arise from partial differential equation
discretizations and large-scale chemical interaction networks from climate and
biological sciences often exhibit sparse connections. These models require
implicit and exponential methods in order to handle the stiffness involved in
the equations. However, using a stiff solver can be costly since it requires
calculating or factorizing a Jacobian. In many cases this can be heavily sped
up if the Jacobian is sparse, but this requires the user to provide an
analytically-derived calculation for the full Jacobian.

However, alternative methods can be used in order to automatically calculate
sparse Jacobians. Matrix coloring algorithms can be utilized to speed up
calculations of derivatives when a known sparsity pattern is given, and this
can be combined with both numerical differentiation and automatic differentiation
via dual number seeding. Additionally, automatic detection of sparsity patterns
can be employed to allow for building sparse matrices for use in the coloring
algorithm. This would give a pipeline for simplified sparsity handling in the
differential equation solvers.

**Recommended Skills**: Basic calculus and linear algebra is most of what's
needed with strong programming skills. Background knowledge in numerical analysis
can be helpful.

**Expected Results**: Implementations of matrix coloring and automatic sparsity
detection employed in the defaults of DifferentialEquations.jl.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Scalable Bifurcation Plotting via Deflation

Bifurcation plotting allows a scientist to determine how the steady states of
an equation evolve as a given parameter is changed. Existing software such as
PyDSTool, MatCont, and AUTO utilize a classic technique called arclength
continuation in order to generate a plot. However, this method has three major
issues: (1) signatures for detecting each type of bifurcation must be explicitly
coded, (2) it does not scale to high dimensions, and (3) it is not able to
detect disconnected bifurcations.

A [newer technique known as deflation](http://people.maths.ox.ac.uk/beentjes/Essays/MScThesis2015-10.pdf)
can be used instead to compute bifurcation diagrams in a way that does not
require specialization on every possible type of bifurcation, allowing the
method to easily scale to higher dimensions and be more robust. In addition,
this method does not require continuation from previous branches and thus
is able to detect disconnection bifurcation branches. However, since
the [method is quite recent](https://arxiv.org/pdf/1603.00809.pdf), no open
source software make use of this technique. The goal of this project is to
implement this method in order to create a bifurcation visualizer that works
well with the JuliaDiffEq ecosystem, and demonstrate its ability to handle
new classes of bifurcations beyond that of the previous software.

**Recommended Skills**: Knowledge of calculus and linear algebra (Newton's
method) is all that's required. Previous experience with dynamical systems
theory is preferred but can be picked up along the way.

**Expected Results**: A functional bifurcation plotting package.

**Mentors**: [Chris Rackauckas](www.github.com/ChrisRackauckas) and
[Christoph Ortner](https://github.com/cortner)

## Tools for global and adjoint sensitivity analysis

Global Sensitivity Analysis is a popular tool to assess the affect that parameters
have on a differential equation model. A good introduction [can be found in this thesis](http://discovery.ucl.ac.uk/19896/). Global Sensitivity Analysis tools can be
much more efficient than Local Sensitivity Analysis tools, and give a better
view of how parameters affect the model in a more general sense.
The goal of this project would be to implement more global
sensitivity analysis methods like the eFAST method into [DiffEqSensitivity.jl](https://github.com/JuliaDiffEq/DiffEqSensitivity.jl) which
can be used with any differential equation solver on the common interface.

**Recommended Skills**: An understanding of how to use DifferentialEquations.jl
to solve equations.

**Expected Results**: Efficient functions for performing global sensitivity
analysis.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Quantum Algorithms for Differential Equations

Quantum computing might be the next big thing. Using
[Yao.jl](https://github.com/QuantumBFS/Yao.jl) one can efficiently simulate
quantum algorithms, making Julia the perfect place to start implementing
quantum differential equation solvers! Papers describing such possible algorithms
[already exist](https://arxiv.org/abs/0812.4423) and an experimental GSoC can
implement these algorithms to try them out.

**Recommended Skills**: An understanding of differential equation solvers and
and quantum mechanics is a must.

**Expected Results**: Implementations of quantum ODE solvers.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

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
