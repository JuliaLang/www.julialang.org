# Tensor network contraction order optimization and visualization

[OMEinsum.jl](https://github.com/under-Peter/OMEinsum.jl) is a pure Julia package for tensor network computation,
 which has been used in various projects, including
 * [GenericTensorNetworks.jl](https://github.com/QuEraComputing/GenericTensorNetworks.jl) for solving combinatorial optimization problems,
 * [YaoToEinsum.jl]() for simulating large scale quantum circuit and
 * [TensorInference.jl](https://github.com/TensorBFS/TensorInference.jl) for Bayesian inference.

Unlike other tensor contraction packages such as `ITensors.jl` and `TensorOperations.jl`, it is designed for large scale tensor networks with arbitrary topology. The key feature of `OMEinsum.jl` is that it can automatically optimize the contraction order of a tensor network. Related features are implemented in [OMEinsumContractionOrders.jl](https://github.com/TensorBFS/OMEinsumContractionOrders.jl).

We are looking for a student to work on the following tasks:
- Implement a better contraction order optimizer based on [Tamaki's algorithm](https://arxiv.org/abs/2202.07793).
- Implement a hyper-graph visualization tool based on [arXiv:2308.05043](https://arxiv.org/abs/2308.05043)

**Recommended skills:** familiarity with tensor networks, graph theory and high performance computing.

**Expected results:**
- new features added to the package `OMEinsumContractionOrders.jl` along with tests and relevant documentation.
- a new package about hyper-graph visualization, and relevant feature added to `OMEinsum.jl`.

**Mentor:** [Jin-Guo Liu](https://github.com/giggleliu)

**Contact:** feel free to ask questions via [email](cacate0129@gmail.com) or the Julia slack (user name: JinGuo Liu).
