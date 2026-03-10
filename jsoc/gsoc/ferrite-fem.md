# Ferrite.jl - Finite Element Toolbox - Summer of Code

[Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl) is a Julia package providing the basic building blocks to develop finite element simulations of partial differential equations.
The package provides extensive examples to start from and is designed as a compromise between simplicity and generality, trying to map finite element concepts 1:1 with the code in a low-level .
Ferrite is actively used in teaching finite element to students at several universities across different countries (e.g. Ruhr-University Bochum and Chalmers University of Technology).
Further infrastructure is provided in the form of different mesh parsers and a Julia based visualizer called [FerriteViz.jl](https://github.com/Ferrite-FEM/FerriteViz.jl).

Below we provide a two of potential project ideas in [Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl).
However, interested students should feel free to explore ideas they are interested in. Please contact any of the mentors listed below, or join the `#ferrite-fem` channel on the Julia slack to discuss.
Projects in finite element visualization are also possible with for example [FerriteViz.jl](https://github.com/Ferrite-FEM/FerriteViz.jl).
As a starting point, or to gather inspiration for a potential project, please check out issues marked with [Good First Issue](https://github.com/Ferrite-FEM/Ferrite.jl/issues?q=is%3Aissue%20state%3Aopen%20label%3A%22good%20first%20issue%22).



## Arbitrary Order Interpolations in 3D

**Difficulty**: Medium

**Project size**: 300-350 hours

**Problem**: [Ferrite.jl](https://github.com/ferrite-fem/Ferrite.jl) supports arbitrary order interpolations in 1D and 2D. However, for 3D problems the order for the interpolations is right now limited to interpolations with at most a single dof per face. The difficulty here is of geometric nature. Faces in typical finite element meshes typically have a non-trivial relative orientation, and therefore the facet dofs of the neighboring elements do not match spatially.

**Minimum goal**: A minimal goal would be to add the necessary infrastructure to support the adjustment of the dof location for high order Lagrange polynomial interpolation on all 3D elements interpolations during the dof assignment phase.

**Extended goal**: With this minimally functional example it is possible to extend the project into different directions, e.g. high-order H(div) and H(curl) elements or optimizing the CellCache for these higher order elements by exploiting the tensor-product structure.

**Recommended skills**:
- Basic knowledge about the finite element method
- Good geometric thinking
- The ability (or eagerness to learn) to write fast code

**Mentors**: [Dennis Ogiermann](https://github.com/termi-official) and [Fredrik Ekre](https://github.com/fekre)



## Forest-based Adaptive Mesh Refinement

**Difficulty**: Hard

**Project size**: 350 hours

**Problem**: Adaptive mesh refinement is an attractive technique to speed up simulations with localized features, like for example steep traveling wave-fronts. Over the last years multiple prototypes have been developed and adopted for a specific use-case. Our generic implementation utilizes ideas from the [p4est](https://p4est.github.io/papers/BursteddeWilcoxGhattas11.pdf) research paper and lives in a separate branch for quite a bit of time now (see [here](https://github.com/Ferrite-FEM/Ferrite.jl/pull/780)). We need more hands to finish the last steps.

**Minimum goal**: As the PR is almost done, the bare minimum would be to push the PR over the finish line. This includes more adding more extensive tests, help with missing documentation, more debug coverage to track down failures and completing a nice user-interface. THe user interface is partially done and needs to cover the marking, error estimation, refinement, coarsening and efficient transfer operations between two nested grids.

**Extended goal**: We see are essentially four ways to can explore as an extended goal. The first one would be to expend the approach as described in the subsequent work by the group (t8code) to allow more element types that just line/quad/hex. The second possible extension would be to parallelize the algorithms and making them GPU ready, so we do not need a roundtrip for the grid through the main memory. The third option would be to allow MPI parallelization and (SFC-based) load balancing. The fourth one is to extend the data structures to 4D hypercubes to allow space-time adaptive simulations.

**Recommended skills**:
- Basic knowledge about either the finite element method and/or tree-based data structures
- Good geometric thinking
- The ability (or eagerness to learn) to write fast code

**Mentors**: [Dennis Ogiermann](https://github.com/termi-official) and [Maximilian Köhler](https://github.com/koehlerson)



## Proper Subdomain Support for FerriteDistributed.jl

**Difficulty**: Hard

**Project size**: 350 hours

**Problem**: [FerriteDistributed.jl](https://github.com/ferrite-fem/FerriteDistributed.jl) is the MPI variant of Ferrite allowing scalable distributed assembly. However, it has been initially developed during the Ferrite v1.0 release window, right before proper subdomain has been added to Ferrite. Therefore, right now the upgrade to Ferrite v1 is primarily blocked by adding proper support for subdomains through the newly introduced SubDofHandler.


**Minimum goal**: At the very least a DistributedSubDofHandler must be added. Therefore the internal communication infrastructure must be upgraded to properly subdomains instead of the full domain.

**Extended goal**: Probably the most useful extended goal right now is to refactor the internal communication infrastructure to better integrate with MPI.jl, as we do not use the full potential of MPI.jl yet. Alternatively, we would like to also allow users to use other distributed memory backends to be used, as for example Reactant.jl.

**Recommended skills**:
- Basic knowledge about the finite element method
- Basic knowledge about benchmarking
- The ability (or eagerness to learn) to write fast code

**Mentors**: [Dennis Ogiermann](https://github.com/termi-official) and [Maximilian Köhler](https://github.com/koehlerson)
