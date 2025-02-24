# Rimu.jl - Projector Quantum Monte Carlo - Summer of Code

[Rimu.jl](https://github.com/RimuQMC/Rimu.jl) is a Julia package for finding ground states (and low-lying excited states) of quantum many-body problems with projector quantum Monte Carlo (using a flavour called full configuration interaction quantum Monte Carlo, FCIQMC) and with exact diagonalisation.

## Ab-Initio Quantum Chemistry with Rimu.jl
 
 **Difficulty**: Easy to medium (if the recommended skills are available)

 **Project size**: 175 - 350 hours

 **Problem**: [Rimu.jl](https://github.com/RimuQMC/Rimu.jl) provides an interface for defining a custom quantum many-body Hamiltonian and currently implements a selection of model Hamiltonians (e.g. variants of the Hubbard model and the Fröhlich polaron model).
 The high-level goal of the project is to implement the required functionality to solve ab-initio quantum chemistry problems with [Rimu.jl](https://github.com/RimuQMC/Rimu.jl) and embed the package into the [JuliaMolSim](https://github.com/JuliaMolSim) ecosystem, in particular with [ElemCo.jl](https://github.com/fkfest/ElemCo.jl).

**Minimum goal**: A minimum goal would be to enable reading in the relevant information about the molecular orbital basis set and integrals that define the molecular Hamiltonian from a file (in the standard FCIDUMP format) and defining an appropriate Hamiltonian type for Rimu.jl that enables its usage for exact diagonalisation and FCIQMC.

**Extended goal**: An extended goal would be to make the molecular Hamiltonian efficient for FCIQMC, e.g. by finding and implementing an appropriate strategy for an excitation generator, e.g. a variant of (precomputed) heat-bath sampling. Another worthwhile extension would be to implement variants of the Configuration Interaction (CI) method by filtering the configurations to a relevant subspace (e.g. CI-SD, selctive CI, etc.) for the exact-diagonalisation part of Rimu.jl.

**Recommended skills**:
- prior exposure to or strong interest in quantum chemistry
- basic familiarity with point group symmetries and their representations
- good to excellent Julia coding skills

**Mentors**: [Joachim Brand](https://github.com/joachimbrand), [Daniel Kats](https://github.com/dnkats), [Elke Pahl](https://github.com/ElkePahl)

If you are interested please get in touch by [email](mailto:j.brand@massey.ac.nz).

## Load balancing Rimu.jl for multi-node (HPC) calculations

**Difficulty**: Medium to hard

**Project size**: 175 - 350 hours

**Problem**: [Rimu.jl](https://github.com/RimuQMC/Rimu.jl) parallelises the workload of FCIQMC by making extensive use of native threading for shared-memory parallelism. In high-performance computing environments the primary data structure containing information about the sampled configurations and their amplitudes can further be distributed across nodes, which communicate using the MPI protocol in every time step (making use of [MPI.jl](https://github.com/JuliaParallel/MPI.jl)). In the current implementation the distribution of configurations to nodes is done passively (in a pseudo-random fashion using a hashing algorithm). While this is fast and easy and usually leads to a fairly even distribution of data and work across the nodes, it does not scale very well when employing hundreds of nodes as every MPI rank has to wait for the slowest one to complete the work done at each time step.

**Minimum goal**: Implement an active load-balancing approach where load information of each MPI rank is monitored and work load is shifted between nodes to even out the workload.

**Extended goal**: Explore other load-balancing strategies like agent-based approaches, possibly even exploring algorithmic alternatives (e.g. continuous-time Monte Carlo). Design communication protocols that take into account the network topology.

**Recommended skills**:
- experience with HPC environments and MPI-style programming
- good to excellent Julia coding skills

**Mentors**: [Matija Čufar](https://github.com/mtsch), [Joachim Brand](https://github.com/joachimbrand)

If you are interested please get in touch with [Matija](matijacufar@gmail.com) or [Joachim](mailto:j.brand@massey.ac.nz).

