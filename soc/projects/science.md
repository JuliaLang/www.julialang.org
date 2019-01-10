---
layout: insidepage
title:  Scientific Projects – Summer of Code
---

# {{ page.title }}

## Quantum Computation: Simualation of Noisy Circuits

[Noisy Intermediate-Scale Quantum (NISQ) technology will be available in the near future.](https://arxiv.org/abs/1801.00862) However, it would be much more convenient if we could test our algorithm with noise and simulate our quantum algorithm on noisy circuits to explore their stability, efficiency. To assist the research of NISQ, enhance the quantum circuit simulator in Julia [Yao.jl](https://github.com/QuantumBFS/Yao.jl) with noisy circuit simulation would be quite useful. We are planning to implement the algorithm in a recent paper as our SoC project: [Efficient classical simulation of noisy quantum computation](https://arxiv.org/pdf/1810.03176.pdf).

**Recommended Skills**: Background knowledge in quantum information and tensor networks and the ability of coding with Julia.

**Expected Results**: Provide Yao.jl an extension package that defines different kinds of noise and provide Yao.jl with the ability to simulate certain kind of noisy circuits efficiently.

**Mentors**: [Roger Luo](https://github.com/Roger-luo/)

## Quantum Computation: Visualization of Quantum Circuits

Although, there is already a pretty printing for quantum circuits in [Yao.jl](https://github.com/QuantumBFS/Yao.jl) as a tree, we are still lack of visualizing a quantum circuit defined as [block tree](https://quantumbfs.github.io/Yao.jl/latest/man/blocks/). And we have already had basic plotting utilities in Julia, like [Luxor.jl](https://github.com/JuliaGraphics/Luxor.jl). It would be great and more convenient to provide multiple theme for plotting a quantum circuit with Yao.jl to various formats.

**Recommended Skills**: Basic knowledge in programatic visualization. Experienced with Luxor.jl is preferred but can be learned along the way.

**Expected Results**: Provide Yao.jl an extension package that converts a block tree to an image, which contains not only the circuit but also mark of composite blocks, users should be able to change theme for paper or multi-media use.

**Mentors**: [Roger Luo](https://github.com/Roger-luo/)

**References**: some demo image can be found in Yao.jl's [doc](https://quantumbfs.github.io/Yao.jl/latest/tutorial/QFT/)


## Quantum Computation: Funny Tensor Networks

A Tensor network is a constraction of tensors, it has wide applications in physics and machine learning. Now we are going to borrow state of the art technics from both fields to build our new **Julia** tensor network package with **automatic differentiation** and **GPU support**!

To make this task interesting, we will create a UTF-8 based pictograph for tensor operations, making the contraction process more intuitive. And this task is very suited for Julia, since it supports not only [UTF-8 character input](https://docs.julialang.org/en/v0.6.0/manual/unicode-input/), but also [UTF-8 operators](https://github.com/JuliaLang/julia/blob/c200b4cdb9620b6df369ae3c735cf3af30b6a47f/src/julia-parser.scm). For the details, please read this [proposal](https://github.com/QuantumBFS/FunnyTN.jl/blob/master/docs/src/dev/proposal.md).

**Recommended Skills:** Basic knowledges about Julia language and linear algebra is required. Students who has experience with tensor networks are preferred.

**Expected Results:** A high performance Julia tensor network package with GPU and autodiff support.

**Mentors:** [JinGuo Liu](https://github.com/GiggleLiu)

**References:**

Don't be scared by these fancy terms, Julia has strong support to [tensor operations](https://github.com/Jutho/TensorOperations.jl), writting [native cuda code in Julia](https://julialang.org/blog/2017/03/cudanative) has similar experience as CPU programming. Also the hard bit - [autodiff for svd](https://github.com/FluxML/Flux.jl/pull/474) has already got a PR in FLux.jl.

In this paper, we have got a pytorch implementation of "MPS + GPU + autodiff"

> Unsupervised Generative Modeling Using Matrix Product States
> Zhao-Yu Han, Jun Wang, Heng Fan, Lei Wang, and Pan Zhang
> [Phys. Rev. X 8, 031012 – Published 17 July 2018](https://journals.aps.org/prx/abstract/10.1103/PhysRevX.8.031012)
> http://lib.itp.ac.cn/html/panzhang/mps/tutorial/;jsessionid=EE5916C954A336C33871E9FB087B626B

Package ITensor in C++ for simulating quantum many body systems
* [ITensor](http://itensor.org/)

Tutorial for tensor networks:

* [Hand-waving and Interpretive Dance: An Introductory Course on Tensor Networks](https://arxiv.org/abs/1603.03039)
