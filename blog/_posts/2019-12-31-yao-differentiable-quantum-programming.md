---
layout: post
title: Yao.jl - Differentiable Quantum Programming In Julia
authors:
 - <a href="https://rogerluo.me/">Xiu-Zhe (Roger) Luo</a>
 - <a href="https://github.com/GiggleLiu">Jin-Guo Liu</a>
---

We introduce [Yao](http://yaoquantum.org/), a Julia software for solving practical problems in quantum computation research.
Quantum computation is a promising computation approach that provides a brand new platform
for scientists to explore in the near term. The name Yao comes from the first Chinese character for unitary (幺正).

<div align="center"> <img
src="http://yaoquantum.org/assets/images/logo.png"
alt="Yao Logo" width="210">
<p>The Logo of Yao</p>
</div>

Why we created Yao? To be short, we are as greedy [as Julia itself](https://julialang.org/blog/2012/02/why-we-created-julia). We want something

### Differentiable
Like many other Julia blog posts (as well as the paper, [arXiv: 1907.07587](https://arxiv.org/abs/1907.07587)) have mentioned: gradients can be a better programmer than humans sometimes. However, the automatic differentiation (AD) problem for quantum computing is very different from other general AD problems. The memory cost is extremely high in the simulation. Thus the normal reverse mode AD is impossible to use when the circuit is deep or large.

In Yao, to support recent progress in [parameterized quantum circuits](https://arxiv.org/abs/1906.07682), we developed our domain-specific high-performance automatic differentiation engine that can make use of the reversible nature of quantum circuits, that allows differentiating through the circuit with constant memory independent to its depth during the simulation. On the other hand, we also provide a forward mode gradient that can produce the quantum gradient that can be implemented on a real quantum device. Moreover, the builtin AD engine can be integrated with the general-purpose AD engine [Zygote](https://github.com/FluxML/Zygote.jl) to differentiable a quantum circuit with general classical programs.

The following is a glance for a Variational Quantum Eigensolver

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

### Extensible
As new research ideas keep emerging every day and every hour, software targeting to help daily research should be highly
modular, extensible, and coherent with the ecosystem. Since even the field, quantum software itself is a rapidly growing field. We want a hierarchical architecture that allows researchers and developers to extend it at any level for any possible type of research.

First, we make use of **Julia's package system**. The package **Yao** itself (and its CUDA version **CuYao**) is just a meta-package, and the concrete implementation is separated into several packages. Different functionalities are built around
a hardware-free intermediate representation that we call Quantum Blocks Intermediate Representation (QBIR) as shown below

![qbir](http://docs.yaoquantum.org/dev/assets/images/YaoFramework.png)

Second, thanks to Julia's **multiple dispatch and type system**. We defined an interface for quantum registers and circuit building blocks. And like many other things in Julia, the builtin implementation is written in a very generic fashion. Thus one only needs to implement a few necessary interfaces for a new quantum register or blocks. The rest will just work!

This extensibility also makes it possible for us to support several features with little efforts, such as [**symbolic computation**](http://tutorials.yaoquantum.org/v0.6.0/generated/quick-start/5.shor-9-code/), [**GPU acceleration**](https://github.com/QuantumBFS/CuYao.jl) and more!

### Efficient
Although Yao does not aim to simulate large quantum circuits (such as simulating a 50-qubit random quantum circuit) to tackle the quantum supremacy simulation, our design put a strong emphasis on small to intermediate-sized quantum circuits since the high-performance simulation of such circuits is crucial for the design of near-term algorithms that run repeatedly
or in parallel.

To be short, in the benchmark below, by making use of [the native GPU programming in Julia](https://devblogs.nvidia.com/gpu-computing-julia-programming-language/) and specialization based on multiple dispatch, we show that **Yao** achieves the-state-of-art performance on intermediate-sized quantum circuits.

![relative](http://docs.yaoquantum.org/dev/assets/images/relative_pcircuit.png)

You can view a more detailed benchmark report [here](https://github.com/Roger-luo/quantum-benchmarks/blob/master/RESULTS.md).

## What's more?
So far, we are happy to announce its birth, but the journey just starts. We want to make Yao a practical toolbox for quantum computing research in Julia. We would like to have actual hardware compilation, circuit simplification, visualization, tensor network, and more! Although, we have some beta users helping us shape this software during [real research work](http://yaoquantum.org/research/). We still need more use cases to develop it further. If you are interested in this idea, join us, and let's make it a more and more powerful tool for quantum computing research!

For more details behind our design, please check [our latest paper](https://arxiv.org/abs/1912.10877).
