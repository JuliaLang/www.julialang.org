---
layout: post
title: Yao.jl - Differentiable Quantum Programming In Julia
authors:
 - <a href="https://rogerluo.me/">Xiu-Zhe (Roger) Luo</a>
 - <a href="https://github.com/GiggleLiu">Jin-Guo Liu</a>
---

We introduce [Yao](http://yaoquantum.org/), an open-source Julia software for solving practical problems in quantum computation research.
Quantum computation is a promising computation approach that provides a brand new platform
for scientists to explore in the near term. The name Yao comes from the first Chinese character for unitary (幺正).

<div align="center"> <img
src="http://yaoquantum.org/assets/images/logo.png"
alt="Yao Logo" width="210">
<p>The Logo of Yao</p>
</div>

Why we created Yao? To be short, we are as greedy [as Julia itself](https://julialang.org/blog/2012/02/why-we-created-julia). We want something

### Differentiable
Like many other Julia blog posts (as well as the [Zygote paper](https://arxiv.org/abs/1907.07587)) have mentioned: gradients can be a better programmer than humans sometimes.
In Yao, we implemented a builtin **domain-specific** automatic differentiation (AD) engine make use of the reversible nature of quantum circuits. In quantum simulations, memory is often the bottlenet, the reversible AD engine can avoid the caching of intermediate states in traditonal reverse mode AD.
One can still port this builtin AD engine to a machine learning package like [Zygote](https://github.com/FluxML/Zygote.jl), e.g. this [gate learning example](https://github.com/QuantumBFS/QuAlgorithmZoo.jl/blob/v0.1.0/examples/PortZygote/gate\_learning.jl).

Yao provides some easy to use differentiation utilities for frequently used losses like `filidety'`, `expect'`, and `operator_fidelity'`. The following is a glance for a Variational Quantum Eigensolver

```julia
using Yao, YaoExtensions
# number of qubits and circuit depth
n, d = 10, 10000
circuit = dispatch!(variational_circuit(n, d),:random)

h = heisenberg(n)

for i in 1:1000
    _, grad = expect'(h, zero_state(n) => circuit)
    dispatch!(-, circuit, 1e-2 * grad)
    println("Step $i, energy = $(real.(expect(h, zero_state(n)=>circuit)))")
end
```

This example of trains a 10000 layer parametrized circuit (~300000 parameters) to find the ground state of a 10 site heisenberg model. One can try it on a laptop. More examples are included in our [tutorial](http://tutorials.yaoquantum.org/dev/) and our [Quantum Algorithm Zoo](https://github.com/QuantumBFS/QuAlgorithmZoo.jl), including:

- [Quantum Circuit Born Machine](http://tutorials.yaoquantum.org/dev/generated/quick-start/6.quantum-circuit-born-machine/)
- [Quantum generative adversarial circuits](https://github.com/QuantumBFS/QuAlgorithmZoo.jl/blob/v0.1.0/examples/QuGAN)
- [Gate learning with operator fidelity](https://github.com/QuantumBFS/QuAlgorithmZoo.jl/blob/v0.1.0/examples/PortZygote/gate\_learning.jl)
- [Variational Quantum Eigensolver](https://github.com/QuantumBFS/QuAlgorithmZoo.jl/blob/v0.1.0/examples/VQE)

### Extensible
The package **Yao** itself (and its CUDA version **CuYao**) is only a meta-package, and the concrete implementation is separated into several packages. The core includes the following packages:

- [YaoBase](https://github.com/QuantumBFS/YaoBase.jl) Abstract interface definitions and some common tools
- [YaoArrayRegister](https://github.com/QuantumBFS/YaoArrayRegister.jl) The implementation of quantum simulator instructions and the full amplitude simulated quantum register.
- [YaoBlocks](https://github.com/QuantumBFS/YaoBlocks.jl) The implementation of Yao's hadware free Quantum Blocks Intermediate Representation (QBIR) and some specialization for certain quantum blocks.

On the other hand, different functionalities in Yao are built around QBIR as shown below

![qbir](http://docs.yaoquantum.org/dev/assets/images/YaoFramework.png)

Thanks to Julia's **multiple dispatch and type system**. We defined an interface for quantum registers and circuit building blocks. And like many other things in Julia, the builtin implementation is written in a very generic fashion. Thus one only needs to implement a few necessary interfaces for a new quantum register or blocks. The rest will just work!

By making use of this extensibility from core, we developed more features. This includes:

- Symbolic Calculation for Quantum Circuits in [YaoSym](https://github.com/QuantumBFS/YaoSym.jl)
- CUDA acceleration for classical simulation in [CuYao](https://github.com/QuantumBFS/CuYao.jl)
- Pre-defined circuits and extensions for Yao in [YaoExtensions](https://github.com/QuantumBFS/YaoExtensions.jl)
- and [more work-in-progress packages](https://github.com/QuantumBFS)

### Efficient
Efficiency matters especially in parameterized quantum circuits that requires a lot numerical experiments, thus, we also
want Yao to be efficient enough on these tasks.

Besides all other exciting features, Yao achieves the-state-of-art performance on intermediate-sized quantum circuits by making use of [the native GPU programming in Julia](https://devblogs.nvidia.com/gpu-computing-julia-programming-language/) and specialization based on multiple dispatch.

![relative](http://docs.yaoquantum.org/dev/assets/images/relative_pcircuit.png)

You can view a more detailed benchmark report [here](https://github.com/Roger-luo/quantum-benchmarks/blob/master/RESULTS.md).

## What's more?
So far, we are happy to announce its birth, but the journey just starts. We want to make Yao a practical toolbox for quantum computing research in Julia. We would like to have actual hardware compilation, circuit simplification, visualization, tensor network, and more! Although, we have some beta users helping us shape this software during [real research work](http://yaoquantum.org/research/). We still need more use cases to develop it further. If you are interested in this idea, [join us](https://github.com/QuantumBFS/Yao.jl/blob/master/CONTRIBUTING.md), and let's make it a more and more powerful tool for quantum computing research!

For more details behind our design, please check [our latest paper](https://arxiv.org/abs/1912.10877).
