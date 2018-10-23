---
layout: default
title:  Scientific Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}



## Quantum Computation: Simualation of Noisy Circuits

[Noisy Intermediate-Scale Quantum (NISQ) technology will be available in the near future.](https://arxiv.org/abs/1801.00862) However, it would be much more convenient if we could test our algorithm with noise and simulate our quantum algorithm on noisy circuits to explore their stability, efficiency. To assist the research of NISQ, enhance the quantum circuit simulator in Julia [Yao.jl](https://github.com/QuantumBFS/Yao.jl) with noisy circuit simulation would be quite useful. We are planning to implement the algorithm in a recent paper as our SoC project: [Efficient classical simulation of noisy quantum computation](https://arxiv.org/pdf/1810.03176.pdf).

**Recommended Skills**: Background knowledge in quantum information and tensor networks and the ability of coding with Julia.
**Expected Results**: Provide Yao.jl an extension package that defines different kinds of noise and provide Yao.jl with the ability to simulate certain kind of noisy circuits efficiently.
**Mentors**: [Roger Luo](https://github.com/Roger-luo/)

## Quantum Computation: Visualization of Quantum Circuits

Although, there is already a pretty printing for quantum circuits in [Yao.jl](https://github.com/QuantumBFS/Yao.jl) as a tree, we are still lack of visualizing a quantum circuit defined as [block tree](https://quantumbfs.github.io/Yao.jl/latest/man/blocks/). And we have already have basic plotting utilities in Julia, like [Luxor.jl](https://github.com/JuliaGraphics/Luxor.jl). It would be great and more convenient to provide multiple theme for plotting a quantum circuit with Yao.jl to various formats.

**Recommended Skills**: Basic knowledge in plotting in Julia with Luxor.jl.
**Expected Results**: Provide Yao.jl an extension package that converts a block tree to an image, which contains not only the circuit but also mark of composite blocks, users should be able to change theme for paper or multi-media use.
**Mentors**: [Roger Luo](https://github.com/Roger-luo/)
**References**: some demo image can be found in Yao.jl's [doc](https://quantumbfs.github.io/Yao.jl/latest/tutorial/QFT/)


## Quantum Computation: Tensor Network for Quantum Circuit Simulation

A Tensor network is a constraction of tensors, it has wide applications in physics and machine learning. Especially, the similation scheme based on treewidth algorithm help us better simulate intermediate size quantum circuits with limited entanglement.

> Simulating quantum computation by contracting tensor networks
> Igor L. Markov, Yaoyun Shi
> https://arxiv.org/abs/quant-ph/0511069

To make this task interesting, we will create a UTF-8 based pictograph for tensor operations, making the contraction process more intuitive. And this task is very suited for Julia, since it supports not only [UTF-8 character input](https://docs.julialang.org/en/v0.6.0/manual/unicode-input/), but also [UTF-8 operators](https://github.com/JuliaLang/julia/blob/c200b4cdb9620b6df369ae3c735cf3af30b6a47f/src/julia-parser.scm). For the details, please read this [proposal](https://github.com/QuantumBFS/FunnyTN.jl/blob/master/docs/src/dev/proposal.md).

**Recommended Skills:** Background knowledge in Julia language and linear algebra.

**Expected Results:** A high performance tensor network contraction package based on treewidth algorithm, and use it as a kind of Register in Yao for quantum circuit simulation.

**Mentors:** [JinGuo Liu](https://github.com/GiggleLiu)

**References:**

Tensor Networks used in quantum machine learning

> Unsupervised Generative Modeling Using Matrix Product States
> Zhao-Yu Han, Jun Wang, Heng Fan, Lei Wang, and Pan Zhang
> [Phys. Rev. X 8, 031012 – Published 17 July 2018](https://journals.aps.org/prx/abstract/10.1103/PhysRevX.8.031012)

> Towards Quantum Machine Learning with Tensor Networks
> William Huggins, Piyush Patel, K. Birgitta Whaley, E. Miles Stoudenmire
> https://arxiv.org/abs/1803.11537

Package ITensor in C++ for simulating quantum many body systems
* [ITensor](http://itensor.org/)
