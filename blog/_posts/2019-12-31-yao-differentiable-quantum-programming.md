---
layout: post
title: Yao.jl - Differentiable Quantum Programming In Julia
authors:
 - <a href="https://rogerluo.me/">Xiu-Zhe (Roger) Luo</a>
 - <a href="https://github.com/GiggleLiu">Jin-Guo Liu</a>
---

We introduce [Yao](http://yaoquantum.org/) ([**Check our latest paper**](https://arxiv.org/abs/1912.10877)), an open-source Julia software for solving practical problems in quantum computation research.
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
In Yao, we implemented a builtin **domain-specific** automatic differentiation (AD) engine make use of the reversible nature of quantum circuits. In quantum simulations, memory is often the bottleneck, the reversible AD engine can avoid the caching of intermediate states in general reverse mode AD.

Yao provides some easy to use differentiation utilities for frequently used losses like `filidety'`, `expect'`, and `operator_fidelity'`. The obtained gradient can be used for various purpose, like simulating variational algorithms, quantum control and gate learning. The following is an example of simulating variational quantum eigensolver algorithm

```julia
using Yao, YaoExtensions
# number of qubits and circuit depth
n, d = 16, 100
circuit = dispatch!(variational_circuit(n, d),:random)

h = heisenberg(n)

for i in 1:100
    _, grad = expect'(h, zero_state(n) => circuit)
    dispatch!(-, circuit, 1e-1 * grad)
    println("Step $i, energy = $(real.(expect(h, zero_state(n)=>circuit)))")
end
```

This example of trains a 100 layer parametrized circuit (4816 parameters) to find the ground state of a 16 site heisenberg model. Due to the efficient implementation, one can try this example on his laptop. This AD engine can be ported to a machine learning package like [Zygote](https://github.com/FluxML/Zygote.jl) seamlessly, like in this [gate learning example](https://github.com/QuantumBFS/QuAlgorithmZoo.jl/blob/v0.1.0/examples/PortZygote/gate\_learning.jl). More examples are included in our [tutorial](http://tutorials.yaoquantum.org/dev/) and our [Quantum Algorithm Zoo](https://github.com/QuantumBFS/QuAlgorithmZoo.jl), including:

- [Quantum Circuit Born Machine](http://tutorials.yaoquantum.org/dev/generated/quick-start/6.quantum-circuit-born-machine/)
- [Quantum generative adversarial circuits](https://github.com/QuantumBFS/QuAlgorithmZoo.jl/blob/v0.1.0/examples/QuGAN)
- [Gate learning with operator fidelity](https://github.com/QuantumBFS/QuAlgorithmZoo.jl/blob/v0.1.0/examples/PortZygote/gate\_learning.jl)
- [Variational Quantum Eigensolver](https://github.com/QuantumBFS/QuAlgorithmZoo.jl/blob/v0.1.0/examples/VQE)

### Extensible
As new research ideas keep emerging every day and every hour, we want it to be extensible enough for researchers and developers to extend it at any level for any possible type of research.

##### Register extension
Our CUDA extension [CuYao](https://github.com/QuantumBFS/CuYao.jl) reuse a lot of existing functions thanks to the [clever design of CUDAnative](https://arxiv.org/abs/1712.03112). CuYao contains only several hundread lines of device code, but has the best performance (see the figure in section Efficient) up to our knowledge.

##### Quantum gate and algorithms
Not only the quantum register can be extended easily, quantum blocks can also be extended with little effort, for example the FSim gate that appear in [Google quantum supremacy experiment](https://www.nature.com/articles/s41586-019-1666-5) can be defined as
```julia
julia> using Yao, LuxurySparse

julia> @const_gate FSim = mat((ISWAP * control(2, 2, 1=>shift(-π/6)))')
```
We have more predefined utilities in YaoExtensions, including [quantum frourier transformation circuit](https://github.com/QuantumBFS/YaoExtensions.jl/blob/master/src/easybuild/qft_circuit.jl), [hardware efficient vartiational circuit](https://github.com/QuantumBFS/YaoExtensions.jl/blob/master/src/easybuild/variational_circuit.jl), [random supremacy circuit](https://github.com/QuantumBFS/YaoExtensions.jl/blob/master/src/easybuild/supremacy_circuit.jl) and [google 53 qubit circuit](https://github.com/QuantumBFS/YaoExtensions.jl/blob/master/src/easybuild/google53.jl).
One can develop algorithms easily with this extensibility. Here is a [non-complete list of quantum algorithms](https://github.com/QuantumBFS/QuAlgorithmZoo.jl) that we wrote or contributed by Julia community.

##### Symbolic computation
Due to the generic type in Julia, [symbolic calculation is supported](https://github.com/QuantumBFS/YaoSym.jl) by porting [SymEngine](https://github.com/symengine/SymEngine.jl). One can differentiate a quantum circuit analytically, confirm shor's 9 qubit code analytically (see [our paper](https://arxiv.org/abs/1912.10877)).


### Efficient
Efficiency matters especially in parameterized quantum circuits that requires a lot numerical experiments, thus, we also
want Yao to be efficient enough on these tasks.

Besides all other exciting features, Yao achieves the-state-of-art performance on intermediate-sized quantum circuits (including [ProjectQ](https://arxiv.org/abs/1704.01127)) by making use of [the native GPU programming in Julia](https://devblogs.nvidia.com/gpu-computing-julia-programming-language/) and specialization based on multiple dispatch.

![relative](http://docs.yaoquantum.org/dev/assets/images/relative_pcircuit.png)

You can view a more detailed benchmark report [here](https://github.com/Roger-luo/quantum-benchmarks/blob/master/RESULTS.md).

## What's more?
So far, we are happy to announce its birth, but the journey just starts.
In the future, we want to make Yao a practical toolbox for quantum computing research in Julia. We would like to have actual hardware compilation (e.g. to [OpenQASM](https://github.com/QuantumBFS/YaoQASM.jl)), circuit simplification ([YaoIR](https://github.com/QuantumBFS/YaoIR.jl)), visualization, tensor network (check this [web application](http://yaoquantum.org/qbirplayground.html)), and more! Although, we have some beta users helping us shape this software during [real research work](http://yaoquantum.org/research/). We still need more use cases to develop it further. If you are interested in this idea, [join us](https://github.com/QuantumBFS/Yao.jl/blob/master/CONTRIBUTING.md), and let's make it a more and more powerful tool for quantum computing research!

For more details behind our design, please check [our latest paper](https://arxiv.org/abs/1912.10877).

Your Yao's journey starts here

[![asciicast](https://asciinema.org/a/HaDO421J58cmKhIBbVPhJHIr7.svg)](https://asciinema.org/a/HaDO421J58cmKhIBbVPhJHIr7?speed=2)
