# Rimu.jl - Projector Quantum Monte Carlo - Summer of Code

[Rimu.jl](https://github.com/RimuQMC/Rimu.jl) is a Julia package for finding ground states (and low-lying excited states) of quantum many-body problems with projector quantum Mote Carlo (using a flavour called full configuration interaction quantum Monte Carlo, FCIQMC) and exact diagonalisation.

## Ab-Initio Quantum Chemistry with Rimu.jl
 
 **Difficulty**: Easy to Medium (if the recommended skills are available)

 **Project size**: 175 - 350 hours

 **Problem**: [Rimu.jl](https://github.com/RimuQMC/Rimu.jl) provides an interface for defining a custom quantum many-body Hamiltonian and currently implements a selection of model Hamiltonians (e.g. variants of the Hubbard model and the Fröhlich polaron model).
 The high-level goal of the project is to implement the required functionality to solve ab-initio quantum chemistry problems with [Rimu.jl](https://github.com/RimuQMC/Rimu.jl) and embed the package into the [JuliaMolSim](https://github.com/JuliaMolSim) ecosystem, in particular with [ElemCo.jl](https://github.com/fkfest/ElemCo.jl).

**Minimum goal**: A minimum goal would be to enable reading in the relevant information about the molecular orbital basis set and integral that define the molecular Hamiltonian from a file (in the standard FCIDUMP format) and defining an appropriate Hamiltonian type for Rimu.jl that enables its usage for exact diagonalisation and FCIQMC.

**Extended goal**: An extended goal would be to make the molecular Hamiltonian efficient for FCIQMC, e.g. by finding and implementing an appropriate strategy, e.g. a variant of (precomputed) heat-bath sampling.

**Recommended skills**:
- prior exposure to or strong interest in quantum chemistry
- basic familiarity with point groups and representations
- good to excellent Julia coding skills

**Mentors**: [Joachim Brand](https://github.com/joachimbrand), [Daniel Kats](https://github.com/dnkats), [Elke Pahl](https://github.com/ElkePahl)


