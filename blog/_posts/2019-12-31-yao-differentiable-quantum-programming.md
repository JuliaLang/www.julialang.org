---
layout: post
title:  Yao.jl - Differentiable Quantum Programming In Julia
authors:
    - <a href="https://rogerluo.me/">Xiu-Zhe (Roger) Luo</a>
    - <a href="https://github.com/GiggleLiu">Jin-Guo Liu</a>
---

We introduce [Yao](http://yaoquantum.org/), a Julia software for solving practical problems in quantum computation research.
Quantum computation is a promising computation approach that provides a brand new platform
for scientists to explore in near term. The name Yao comes from the first Chinese character for unitary (幺正).

Why we created Yao? To be short, we are as greedy [as Julia itself](https://julialang.org/blog/2012/02/why-we-created-julia). We want something

### Differentiable
As many other Julia blog posts (as well as the paper, [arXiv: 1907.07587](https://arxiv.org/abs/1907.07587)) have mentioned: gradients can be a better programmer than humans sometimes. In Yao, to support recent progress in [parameterized quantum circuits](https://arxiv.org/abs/1906.07682), we developed our own domain specific automatic differentiation (AD) engine that is able to make use of the reversible nature of quantum circuits, which allows differentiating through the circuit with constant memory independent to its depth during simulation. On the other hand, we also provide a forward mode gradient that can produce quantum gradients implementable on real quantum device. Moreover, the builtin AD engine can be integrated with the general purpose AD engine [Zygote](https://github.com/FluxML/Zygote.jl) to differentiable a quantum circuit with general classical programs.

The following is an glance for a Variational Quantum Eigensolver

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
As new research ideas keep emerging in every day and every hour, a software targeting to help daily research should be highly
modular and extensible. Since even the field, quantum software itself, is a rapid growing field, we would like a hierarchical architecture that allows researchers and developers to extend it at any level for any possible type of research.

First, we make use of **Julia's package system**. The package **Yao** itself (and its CUDA version **CuYao**) is just a meta-package and the concrete implementation is separated into several packages as shown below.

![stack](http://docs.yaoquantum.org/dev/assets/images/stack.png)

Second, thanks to Julia's **multiple dispatch and type system**. We defined an interface for quantum registers and circuit building blocks. Like many other things in Julia, one only need to implement a few necessary interfaces for a new quantum register or blocks, the rest will just work!

This extensibility also make it possible for us to support several features with tiny effort, such as [symbolic computation](http://tutorials.yaoquantum.org/dev/generated/quick-start/5.shor-9-code/), GPU acceleration.

### Efficient
Although, Yao does not aim to simulate large quantum circuits (such as simulating a 50-qubit random quantum circuit) to tackle the quantum supremacy simulation, our design put a strong emphasis on small to intermediate-sized quantum circuits since the high-performance simulation of such circuits is crucial for the design of near-term algorithms that run repeatedly
or in parallel.

To be short, in the benchmark below, by making use of [the native GPU programming in Julia](https://devblogs.nvidia.com/gpu-computing-julia-programming-language/) and specialization based on multiple dispatch, we show that **Yao** achieves the-state-of-art performance on intermediate-sized quantum circuits.

![](https://github.com/Roger-luo/quantum-benchmarks/raw/master/images/pcircuit_relative.png)

You can view more detailed benchmark report [here](https://github.com/Roger-luo/quantum-benchmarks/blob/master/RESULTS.md).

## What's more?
So far, we are happy to announce its birth, but the journey just starts. We want to make Yao a practical toolbox for quantum computing research in Julia. We want compilation to actual hardware, circuit simplification, visualization, tensor network
and more! Although, we have some beta users helping us shape this software during [actual research work](http://yaoquantum.org/research/). We still need more use cases to shape it further. If you are interested in this idea, join us and let's make it a more and more powerful tool for quantum computing research!

For more details behind the design, please check our paper: 