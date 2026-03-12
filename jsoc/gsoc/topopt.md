# TopOpt Projects – Summer of Code

[TopOpt.jl](https://github.com/JuliaTopOpt/TopOpt.jl) is a [topology optimization](https://en.wikipedia.org/wiki/Topology_optimization) package written in pure Julia. Topology optimization is an exciting field at the intersection of shape representation, physics simulations and mathematical optimization, and the Julia language is a great fit for this field. To learn more about `TopOpt.jl`, check the following [JuliaCon talk](https://www.youtube.com/watch?v=sBqdkxPXluU).

The following is a tentative list of projects in topology optimization that you could be working on in the coming Julia Season of Contributions or Google Summer of Code. If you are interested in exploring any of these topics or if you have other interests related to topology optimization, please reach out to the main mentor [Mohamed Tarek](https://github.com/mohamed82008) via email.

## Testing and benchmarking of TopOpt.jl

**Project difficulty**: Medium

**Work load**: 350 hours

**Description**: The goal of this project is to improve the unit test coverage and reliability of TopOpt.jl by testing its implementations against other software's outputs. Testing and benchmarking stress and buckling constraints and their derivatives will be the main focus of this project. Matlab scripts from papers may have to be translated to Julia for correctness and performance comparison.

**Knowledge prerequisites**: structural mechanics, optimization, Julia programming

## Machine learning in topology optimization

**Project difficulty**: Medium

**Work load**: 350 hours

**Description**: There are numerous ways to use machine learning for design optimization in topology optimization. The following are all recent papers with applications of neural networks and machine learning in topology optimization. There are also exciting research opportunities in this direction.

- [DNN-based Topology optimization: Spatial Invariance and Neural Tangent Kernel](https://openreview.net/pdf?id=DUy-qLzqvlU)
- [NTopo: Mesh-free Topology Optimization using Implicit Neural Representations](https://openreview.net/pdf?id=bBHHU4dW88g)
- [TONR: An exploration for a novel way combining neural network with topology optimization](https://www.sciencedirect.com/science/article/pii/S004578252100414X?via%3Dihub)
- [TOuNN: Topology Optimization using Neural Networks](https://link.springer.com/article/10.1007/s00158-020-02748-4)

In this project you will implement one of the algorithms discussed in any of these papers.

**Knowledge prerequisites**: neural networks, optimization, Julia programming

## Optimization on a uniform rectilinear grid

**Project difficulty**: Medium

**Work load**: 350 hours

**Description**: Currently in TopOpt.jl, there are only unstructured meshes supported. This is a very flexible type of mesh but it's not as memory efficient as uniform rectilinear grids where all the elements are assumed to have the same shape. This is the most common grid used in topology optimization in practice. Currently in TopOpt.jl, the uniform rectilinear grid will be stored as an unstructured mesh which is unnecessarily inefficient. In this project, you will optimize the finite element analysis and topology optimization codes in TopOpt.jl for uniform rectilinear grids.

**Knowledge prerequisites**: knowledge of mesh types, Julia programming

## Adaptive mesh refinement for topology optimization

**Project difficulty**: Medium

**Work load**: 350 hours

**Description**: Topology optimization problems with more mesh elements take longer to simulate and to optimize. In this project, you will explore the use of adaptive mesh refinement starting from a coarse mesh, optimizing and only refining the elements that need further optimization. This is an effective way to accelerate topology optimization algorithms.

**Knowledge prerequisites**: adaptive mesh refinement, Julia programming

## Heat transfer design optimization

**Project difficulty**: Medium

**Work load**: 175 or 350 hours

**Description**: All of the examples in TopOpt.jl and problem types are currently of the linear elasticity, quasi-static class of problems. The goal of this project is to implement more problem types and examples from the field of heat transfer. Both steady-state heat transfer problems and linear elasticity problems make use of elliptic partial differential equations so the code from linear elasticity problems should be largely reusable for heat transfer problems with minimum changes.

**Knowledge prerequisites**: finite element analysis, heat equation, Julia programming
