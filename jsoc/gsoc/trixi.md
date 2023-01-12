# Modern computational fluid dynamics with Trixi.jl

[Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) is a Julia package for adaptive 
high-order numerical simulations of conservation laws. It is designed to be simple to use
for students and researchers, extensible for research and teaching, as well as efficient 
and suitable for high-performance computing.


## Compiler-based automatic differentiation with Enzyme.jl

**Difficulty**: Medium (up to hard, depending on the chosen subtasks)

**Project size**: 175 hours or 350 hours, depending on the chosen subtasks

[Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl) is the Julia frontend of Enzyme, 
a modern automatic differentiation (AD) framework working at the level of LLVM code. 
It can provide fast forward and reverse mode AD and - unlike some other AD packages - 
supports mutating operations. Since [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) 
relies on mutating operations and caches for performance, this feature is crucial to obtain
an implementation that works efficiently for both simulation runs and AD.

The overall goal of this project is to create a working prototype of 
[Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) (or a subset thereof) 
using [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl) for AD, and to support as 
many of Trixi's advanced features as possible, such as adaptive mesh refinement, shock capturing etc.

Possible subtasks in this project include
- Explore and implement forward/backward mode AD via [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl) 
  for a simplified simulation for the 1D advection equation or the 1D compressible Euler equations
  (e.g., compute the Jacobian of the right-hand side evaluation `Trixi.rhs!` on a simple mesh in
  serial execution)
- Explore and implement forward mode AD via
  [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl) of semidiscretizations
  provided by [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/),
  mimicking the functionality that is already
  [available via ForwardDiff.jl](https://trixi-framework.github.io/Trixi.jl/stable/tutorials/differentiable_programming/)
- Explore and implement reverse mode AD via
  [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl) of semidiscretizations
  provided by [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) as required for modern machine learning tasks
- Explore and implement AD via [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl)
  of full simulations combining semidiscretizations of
  [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) with time integration
  methods of [OrdinaryDiffEq.jl](https://github.com/SciML/OrdinaryDiffEq.jl)
  
Related subtasks in this project not related directly to [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl)
but using other packages include
- Explore and implement means to improve the current handling of caches to
  simplify AD and differentiable programming with semidiscretizations of
  [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) in general, e.g.,
  via [PreallocationTools.jl](https://github.com/SciML/PreallocationTools.jl).
- Extend the current AD support based on [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl) 
  to other functionality of [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/), e.g.,
  [shock capturing discretizations](https://github.com/trixi-framework/Trixi.jl/issues/1252),
  [MPI parallel simulations](https://github.com/trixi-framework/Trixi.jl/issues/910),
  and other [features currently not supported](https://github.com/trixi-framework/Trixi.jl/issues/462)

This project is good for both software engineers interested in the fields of
numerical analysis and scientific machine learning as well as those students who
are interested in pursuing graduate research in the field.

**Recommended skills**: Good knowledge of at least one numerical discretization scheme 
(e.g., finite volume, discontinuous Galerkin, finite differences); initial knowledge 
in automatic differentiation; preferably the ability (or eagerness to learn) to write fast code

**Expected results**: Contributions to state of the art and production-quality
automatic differentiation tools for Trixi.jl

**Mentors**: [Hendrik Ranocha](https://github.com/ranocha), [Michael Schlottke-Lakemper](https://github.com/sloede)


## Exploration of GPU computing

**Difficulty**: Medium (to hard, depending on the chosen subtasks)

**Project size**: 175 hours or 350 hours, depending on the chosen subtasks

GPUs can provide considerable speedups compard to CPUs
for computational fluid dynamic simulations of the kind performed in
[Trixi.jl](https://github.com/trixi-framework/Trixi.jl/).
Julia provides several ways to implement efficient code on GPUs such as 
[CUDA.jl](https://github.com/JuliaGPU/CUDA.jl) for Nvidia GPUs, 
[AMDGPU.jl](https://github.com/JuliaGPU/AMDGPU.jl) for AMD GPUs, and
[KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl), which
provides a single frontend to generate code for multiple GPU backends. In this project, we will
likely work with CUDA.jl due to its maturity, but other options can be explored later as well.

The goal of this project is to implement a working subset of the functionality
of [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) on GPUs, starting
with a basic numerical scheme on Cartesian meshes in 2D. Based thereon,
there are a lot of possibilities for extensions to more complex geometries and
sophisticated discretizations.

Possible subtasks in this project include
- Write a simple 1D code on for CPUs, taking the methods implemented in
  [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) as a blueprint.
- Port the simple 1D CPU code to GPUs using one of the GPU packages as a prototype.
- Prototype GPU implementations of existing kernels implemented in
  [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) by moving data from
  the CPU to the GPU and back again explicitly.
- Keep the data on the GPU after converting all kernels required for a simple simulation.
- Extend the GPU implementations to more complex numerical methods and settings.
- Extend the GPU implementations to different types of GPUs, using different
  GPU programming packages in Julia.
- Optimize and compare the performance of the implementations.

This project is good for both software engineers interested in the fields of
numerical analysis and scientific machine learning as well as those students who
are interested in pursuing graduate research in the field.

**Recommended skills**: Background knowledge in numerical analysis, working
knowledge about GPU computing, and the ability to write fast code

**Expected results**: Draft of a working subset of the functionality of [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/)
running efficiently on GPUs.

**Mentors**: [Michael Schlottke-Lakemper](https://github.com/sloede), [Hendrik Ranocha](https://github.com/ranocha)
