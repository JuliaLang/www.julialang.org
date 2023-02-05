# Ferrite.jl - Finite Element Toolbox - Summer of Code

[Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl) is a Julia package providing the basic building blocks to develop finite element simulations of partial differential equations.
The package provides extensive examples to start from and is designed as a compromise between simplicity and generality, trying to map finite element concepts 1:1 with the code in a low-level .
Ferrite is actively used in teaching finite element to students at several universities across different countries (e.g. Ruhr-University Bochum and Chalmers University of Technology).
Further infrastructure is provided in the form of different mesh parsers and a Julia based visualizer called [FerriteViz.jl](https://github.com/Ferrite-FEM/FerriteViz.jl).

Below we provide a four of potential project ideas in [Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl).
However, interested students should feel free to explore ideas they are interested in. Please contact any of the mentors listed below, or join the `#ferrite-fem` channel on the Julia slack to discuss.
Projects in finite element visualization are also possible with [FerriteViz.jl](https://github.com/Ferrite-FEM/FerriteViz.jl).


## Adaptive Mesh Refinement

**Difficulty**: Medium-Hard

**Project size**: 300-350 hours

**Problem**: While [Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl) provides infrastructure for the most common tasks in finite element assembly, it lacks an adaptive mesh infrastructure for adaptive finite element technology.
A preliminary implementation of a p4est type adaptive mesh refinement has been started, but not finalized yet.
Information about the existing implementation is summarized [here](https://github.com/Ferrite-FEM/Ferrite.jl/blob/mk/p4est/p4est-ferrite.md).

**Minimum goal**: Finalize the basic p4est implementation as described in the original paper [1], either starting from the [existing branch](https://github.com/Ferrite-FEM/Ferrite.jl/tree/mk/p4est) (recommended) or from scratch together with a set of tests.

**Extended goal**: Interesting extensions might be to implement the optimizations proposed by Tobin Isaac [2], anisotropic refinement as in p6est [3] or generalizations to other geometries as in t8code [4].

**Recommended skills**:
- Basic knowledge the finite element method
- Basic knowledge about mesh geometries

**Mentors**: [Maximilian Köhler](https://github.com/koehlerson) and [Dennis Ogiermann](https://github.com/termi-official)

**References**

1. Burstedde, C., Wilcox, L. C., & Ghattas, O. (2011). p4est: Scalable algorithms for parallel adaptive mesh refinement on forests of octrees. SIAM Journal on Scientific Computing, 33(3), 1103-1133.
2. Isaac, T., Burstedde, C., Wilcox, L. C., & Ghattas, O. (2015). Recursive algorithms for distributed forests of octrees. SIAM Journal on Scientific Computing, 37(5), C497-C531.
3. Isaac, T., Stadler, G., & Ghattas, O. (2015). Solution of nonlinear Stokes equations discretized by high-order finite elements on nonconforming and anisotropic meshes, with application to ice sheet dynamics. SIAM Journal on Scientific Computing, 37(6), B804-B833.
4. Holke, J. (2019). t8code-Extreme Scale Adaptive Mesh Refinement with Arbitrary Elements.



## Discontinuous Galerkin Infrastructure

**Difficulty**: Medium-Hard

**Project size**: 300-350 hours

**Problem**: Discontinuous Galerkin methods combine different advantages of finite element and finite volume schemes at the cost of having more degrees of freedom than classical continuous Galerkin methods.
Currently [Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl) can not handle such problems, because there is no H(div) conforming (i.e. Raviart-Thomas) element implemented.

**Minimum goal**: A minimum goal is to implement a H(div) conforming element together with a mixed Poisson example and introduce corresponding test coverage.

**Extended goal**: If the time allows then it might be interesting to move one step further and explore Runge-Kutta Discontinuous Galerkin (RKDG) schemes for a convection-dominated problem.

**Recommended skills**:
- Knowledge the finite element method

**Mentors**: [Dennis Ogiermann](https://github.com/termi-official) and [Fredrik Ekre](https://github.com/fredrikekre/)



## Fluid-Structure Interaction Example

**Difficulty**: Easy-Medium (depending on your specific background)

**Project size**: 150-300 hours

**Problem**: [Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl) is designed with the possibility to define partial differential equations on subdomains.
This makes it well-suited for interface-coupled multi-physics problems, as for example fluid-structure interaction problems.
However, we currently do not have an example showing this capability in our documentation.
We also do not provide all necessary utilities for interface-coupled problems.

**Minimum goal**: The minimal goal of this project is to create a functional and documented linear fluid-structure interaction example coupling linear elasticity with a stokes flow in a simple setup.
The code should come with proper test coverage.

**Extended goal**: With this minimally functional example it is possible to extend the project into different directions, e.g. optimized solvers or nonlinear fluid-structure interaction.

**Recommended skills**:
- Basic knowledge the finite element method
- Basic knowledge about solids or fluids
- The ability (or eagerness to learn) to write fast code

**Mentors**: [Dennis Ogiermann](https://github.com/termi-official) and [Fredrik Ekre](https://github.com/fredrikekre/)



## Investigation of Performant Assembly Strategies

**Difficulty**: Medium

**Project size**: 250-350 hours

**Problem**: [Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl) has an outstanding performance in single-threaded finite element simulations due to elaborate elimination of redundant workloads.
However, we recently identified that the way the single-threaded assembly works makes parallel assembly memory bound, rendering the implementation for "cheap" assembly loops not scalable on a wide range of systems.
This problem will also translate to high-order schemes, where the single-threaded strategy as is prevents certain common optimization strategies (e.g. sum factorization).

**Minimum goal**: As a first step towards better parallel assembly performance it is the investion of different assembly strategies.
Local and global matrix-free schemes are a possibility to explore here.
The code has to be properly benchmarked and tested to identify different performance problems.

**Extended goal**: With this minimally functional example it is possible to extend the project into different directions, e.g. optimized matrix-free solvers or GPU assembly.

**Recommended skills**:
- Basic knowledge the finite element method
- Basic knowledge about benchmarking
- The ability (or eagerness to learn) to write fast code

**Mentors**: [Maximilian Köhler](https://github.com/koehlerson) and [Dennis Ogiermann](https://github.com/termi-official)
