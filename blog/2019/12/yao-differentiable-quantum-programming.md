@def rss_pubdate = Date(2019, 12, 28)
@def rss_description = """Yao.jl - Differentiable Quantum Programming In Julia"""
@def published = "28 December 2019"
@def title = "Yao.jl - Differentiable Quantum Programming In Julia"
@def authors = """<a href="https://rogerluo.me/">Xiu-Zhe (Roger) Luo</a> and <a href="https://github.com/GiggleLiu">Jin-Guo Liu</a>"""
@def hascode = true

We introduce [**Yao**](https://yaoquantum.org/) ([check our latest paper](https://arxiv.org/abs/1912.10877)), an open-source Julia package for solving practical problems in quantum computation research. The name Yao comes from the first Chinese character for unitary (幺正).

~~~
<div align="center"> <img
src="/assets/images/logo_yao.png"
alt="Yao Logo" width="210">
<p>The Logo of Yao</p>
</div>
~~~

Why we created Yao? To be short, we are as greedy [as Julia itself](/blog/2012/02/why-we-created-julia/). We want something that is:

### Differentiable
Like many other Julia blog posts (as well as the [Zygote paper](https://arxiv.org/abs/1907.07587)) have mentioned: gradients can be a better programmer than humans sometimes. In quantum computing, they can be used for variational algorithms, quantum control, gate learning, etc. Thus, we want to have differentiable programming on quantum circuits as well!

However, automatic differentiation (AD) for quantum circuits is quite different from regular programs: the memory allocation cost in circuit simulation can be extremely high due to caching the intermediate states in the general context. And in forward mode AD, we need extra semantics to preserve the quantum circuit -- so that it can be implemented on the real device.

In Yao, to accomplish this goal, we implemented a builtin **domain-specific** automatic differentiation (AD) engine to make use of the reversible nature of quantum circuits. The following is an example of a variational quantum eigensolver algorithm. With our efficient AD engine, you should be able to try it on your laptop

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

This example trains a 100 layer parametrized circuit (4816 parameters) to find the ground state of a 16 site Heisenberg model. The engine can also be integrated with general AD framework such as [Zygote](https://github.com/FluxML/Zygote.jl) seamlessly, e.g., in our [gate learning example](https://github.com/QuantumBFS/QuAlgorithmZoo.jl/blob/v0.1.0/examples/PortZygote/gate\_learning.jl). We use differentiable programming to find the decomposition of a given unitary. You can learn more in our [tutorial](https://tutorials.yaoquantum.org/dev/) and [Quantum Algorithm Zoo](https://github.com/QuantumBFS/QuAlgorithmZoo.jl).

### Extensible
New research ideas keep emerging every day and every hour. The field quantum software itself grows rapidly. We want a framework that is flexible enough for researchers and developers to extend it at any level for any possible type of research.

First, we designed and developed a hardware-free intermediate representation (the Quantum Block Intermediate Representation, QBIR) to represent and manipulate quantum circuits and a set of quantum register interface. This design enables one to extend Yao to customized algorithms, hardware and more by overloading the relevant interfaces. For example, while achieving the state-of-the-art performance as shown in next section, we extend our CUDA backend in [CuYao](https://github.com/QuantumBFS/CuYao.jl) with only a few hundred lines of code written in native Julia with [CUDAnative](https://arxiv.org/abs/1712.03112). With some patches and syntax sugar, Yao just works with the symbolic engine [SymEngine](https://github.com/symengine/SymEngine.jl) that allows you to differentiate, and calculate a quantum circuit with symbolic computation.

Second, like other projects in Julia, we make Yao extensible at the architecture level. The package Yao (or its CUDA backend CuYao) is only a meta-package that re-exports other component packages.  Developers can customize their own
software with light-weight dependencies and develop new features rapidly.

### Efficient
Efficiency also matters especially in research that evolves numerical experiments, such as variational quantum algorithms. Besides all other exciting features, we still want this framework to achieve the-state-of-art performance in the simulation.

By making use of [native GPU programming in Julia](https://devblogs.nvidia.com/gpu-computing-julia-programming-language/) and specialization based on multiple dispatch, Yao achieves state-of-the-art performance on intermediate-sized quantum circuits.

![relative](https://docs.yaoquantum.org/dev/assets/images/relative_pcircuit.png)

*You can view a more [detailed benchmark](https://github.com/Roger-luo/quantum-benchmarks/blob/master/RESULTS.md)* here.

## What's more?
So far, we are happy to announce its birth, but the journey just starts.

We still want actual hardware compilation (e.g. to [OpenQASM](https://github.com/QuantumBFS/YaoQASM.jl)), circuit simplification and compilation ([YaoIR](https://github.com/QuantumBFS/YaoIR.jl)), visualization, tensor network (check the [online playground](https://yaoquantum.org/qbirplayground.html)), and more!

Although some beta users helped us shape this software during [real research work](https://yaoquantum.org/research/), we still need more use cases to develop it further and more people to join us. If you are interested in this idea, [join us](https://github.com/QuantumBFS/Yao.jl/blob/master/CONTRIBUTING.md), and let's build a powerful tool for quantum computing research!
