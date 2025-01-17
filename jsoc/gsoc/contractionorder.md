# Tensor network contraction order optimization and visualization – Summer of Code

[OMEinsum.jl](https://github.com/under-Peter/OMEinsum.jl) is a pure Julia package for tensor network computation,
 which has been used in various projects, including
 * [GenericTensorNetworks.jl](https://github.com/QuEraComputing/GenericTensorNetworks.jl) for solving combinatorial optimization problems,
 * [YaoToEinsum.jl](https://github.com/QuantumBFS/YaoToEinsum.jl) for simulating large scale quantum circuit and
 * [TensorInference.jl](https://github.com/TensorBFS/TensorInference.jl) for Bayesian inference.

Unlike other tensor contraction packages such as `ITensors.jl` and `TensorOperations.jl`, it is designed for large scale tensor networks with arbitrary topology. The key feature of `OMEinsum.jl` is that it can automatically optimize the contraction order of a tensor network. Related features are implemented in [OMEinsumContractionOrders.jl](https://github.com/TensorBFS/OMEinsumContractionOrders.jl).

We are looking for a student to work on the following tasks:
- Implement a better contraction order optimizer based on [Tamaki's algorithm](https://arxiv.org/abs/2202.07793).
- Implement a hyper-graph visualization tool based on [arXiv:2308.05043](https://arxiv.org/abs/2308.05043)
- Port the contraction order optimizers to [TensorOperations.jl](https://github.com/Jutho/TensorOperations.jl)

**Recommended skills:** familiarity with tensor networks, graph theory and high performance computing.

**Expected results:**
- new features added to the package `OMEinsumContractionOrders.jl` along with tests and relevant documentation.
- a new package about hyper-graph visualization, and relevant feature added to `OMEinsum.jl`.
- a pull request to `TensorOperations.jl` for better contraction order optimization.

**Mentors:** [Jin-Guo Liu](https://github.com/giggleliu), [Jutho Haegeman](https://github.com/Jutho) and [Lukas Devos](https://github.com/lkdvos)

**Project difficulty:** Medium to Hard

**Project length:** 350 hrs

**Contact:** feel free to ask questions via [email](cacate0129@gmail.com) or the Julia slack (user name: JinGuo Liu).
