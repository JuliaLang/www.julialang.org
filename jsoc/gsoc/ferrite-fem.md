# Ferrite.jl - Finite Element Toolbox - Summer of Code

[Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl) is a Julia package providing the basic building blocks to develop finite element simulations of partial differential equations.
The package provides extensive examples to start from and is designed as a compromise between simplicity and generality, trying to map finite element concepts 1:1 with the code in a low-level .
Ferrite is actively used in teaching finite element to students at several universities across different countries (e.g. Ruhr-University Bochum and Chalmers University of Technology).
Further infrastructure is provided in the form of different mesh parsers and a Julia based visualizer called [FerriteViz.jl](https://github.com/Ferrite-FEM/FerriteViz.jl).

Below we provide a four of potential project ideas in [Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl).
However, interested students should feel free to explore ideas they are interested in. Please contact any of the mentors listed below, or join the `#ferrite-fem` channel on the Julia slack to discuss.
Projects in finite element visualization are also possible with [FerriteViz.jl](https://github.com/Ferrite-FEM/FerriteViz.jl).



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
