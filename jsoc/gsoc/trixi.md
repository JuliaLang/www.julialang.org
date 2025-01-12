# Modern computational fluid dynamics with Trixi.jl

[Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) is a Julia package for adaptive
high-order numerical simulations of conservation laws. It is designed to be simple to use
for students and researchers, extensible for research and teaching, as well as efficient
and suitable for high-performance computing.


## Advanced visualization and in-situ visualization with ParaView

**Difficulty**: Medium

**Project size**: 175 hours or 350 hours, depending on the chosen subtasks

Visualizing and documenting results is a crucial part of the scientific process. In
[Trixi.jl](https://github.com/trixi-framework/Trixi.jl/), we rely for visualization on a
combination of pure Julia packages (such as
[Plots.jl](https://github.com/JuliaPlots/Plots.jl) and
[Makie.jl](https://github.com/MakieOrg/Makie.jl))
and the open-source scientific visualization suite [ParaView](https://www.paraview.org).
While the Julia solutions are excellent for visualizing 1D and 2D data, ParaView is the
first choice for creating publication-quality figures from 3D data.

Currently, visualization with ParaView is only possible after a simulation is finished and
requires an additional postprocessing step, where the native output files of Trixi.jl
are converted to [VTK](https://vtk.org) files using
[Trixi2Vtk.jl](https://github.com/trixi-framework/Trixi2Vtk.jl). This extra step makes it
somewhat inconvenient to use, especially when the current state of a numerical solution
is to be checked during a long, multi-hour simulation run.

The goal of this project is therefore to make such visualizations easier by introducing two
significant improvements:

* Add the capability to write out native
  [VTKHDF](https://docs.vtk.org/en/latest/design_documents/VTKFileFormats.html#vtkhdf-file-format)
  files directly during a simulation, in serial and parallel.
* Enable parallel in-situ visualization of the results, i.e., to visualize results by
  connecting ParaView to a currently running, parallel Trixi.jl simulation using the
  [Catalyst API](https://catalyst-in-situ.readthedocs.io/en/latest/index.html).

Both tasks are related in that they require the student to familiarize themselves with both
the data formats internally used in Trixi.jl as well as the visualization pipelines of
VTK/ParaView. However, they can be performed independently and thus this project is suitable
for either a 175 hour or a 350 hour commitment, depending on whether one or both tasks are
to be tackled.

This project is good for both software engineers interested in the fields of
visualization and scientific data analysis as well as those students who
are interested in pursuing graduate research in the field of numerical analysis and
high-performance computing.

**Recommended skills**: Some knowledge of at least one numerical discretization scheme
(e.g., finite volume, discontinuous Galerkin, finite differences) is helpful; initial
knowledge about visualization or parallel processing; preferably the ability (or eagerness
to learn) to write fast code.

**Expected results**: Scalable, production quality visualization of scientific results
for Trixi.jl.

**Mentors**: [Michael Schlottke-Lakemper](https://github.com/sloede), [Benedict Geihe](https://www.mi.uni-koeln.de/NumSim/dr-benedict-geihe/), [Johannes Markert](https://github.com/jmark)

## Asynchronous computing for communication blocking MPI and multi-GPU computing using Trixi.jl

**Difficulty**: Medium

**Project size**: 175 hours or 350 hours, depending on the chosen subtasks

The high performance of modern scientific software is built on parallel computing using MPI and GPUs. The communication speed has not kept up with the exponential increase in compute speed and algorithms are often communication bound, leading to underutilization of hardware capabilities. Asynchronous computing avoids communication bottlenecks by performing non-blocking sends and using algorithms that can give reliable results using the currently available data. This approach gives great scalability on parallel computing systems.

[Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) currently performs distributed memory parallelization using [MPI.jl](https://github.com/JuliaParallel/MPI.jl), and has experimental GPU capabilities using [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl) and [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl). The goal of this project is to implement a subset of features of [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) that can perform parallel simulations asynchronously.

The possible subtasks in this project include:

- Explore and implement a simple code for asynchronous algorithms for solving the 1D advection equation or 1D compressible Euler equations using the API of [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/).
- Taking the simple code as a prototype, explore and implement an asynchronous algorithm starting with the basic [TreeMesh](https://trixi-framework.github.io/Trixi.jl/stable/meshes/tree_mesh/) type in [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) and potentially extending up to [P4estMesh](https://trixi-framework.github.io/Trixi.jl/stable/meshes/p4est_mesh/).
- Explore and implement asynchronous algorithms for a multi-GPU setup, in the 1D prototype and in [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/).
- Explore and implement asynchronous algorithms using [Remote Memory Access Programming using MPI.jl](https://juliaparallel.org/MPI.jl/dev/reference/onesided/).
- Optimize and compare the performance of the above implementations across different hardwares.

This project is good for both software engineers interested in the fields of scientific computing, machine learning and numerical analysis as well as those students who are interested in pursuing graduate research in the field.

**Recommended skills:** Some knowledge of GPU or MPI programming. Knowledge of any numerical analysis (e.g., finite differences) will help, but is not strictly required.

**Expected results:** Draft of a working subset of the functionality of [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) efficiently using asynchronous computing.

**Mentors**: [Arpit Babbar](https://github.com/arpit-babbar), [Hendrik Ranocha](https://github.com/ranocha), [Michael Schlottke-Lakemper](https://github.com/sloede)

## Adaptive mesh refinement on GPUs with CUDA dynamic parallelism

**Difficulty**: Hard

**Project size**: 175 hours or 350 hours, depending on the chosen subtasks

[Dynamic parallelism](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#cuda-dynamic-parallelism) is designed for applications with either a variation of work across space or a dynamically varying workload over time. It is perfect for tasks like mesh refinement. When a thread discovers that an area needs to be refined, it can launch a new grid to perform computations on the refined area without the overhead of terminating the current grid, reporting to the host, and launching the new grid from the host.

[Adaptive mesh refinement (AMR)](https://trixi-framework.github.io/Trixi.jl/stable/tutorials/adaptive_mesh_refinement/) is applied in [Trixi.jl](https://github.com/trixi-framework/Trixi.jl/) to dynamically refine the mesh during simulations, ensuring finer resolution in critical regions for improved accuracy. Currently, the mesh refinement process is performed on CPUs using parallelism with [MPI.jl](https://github.com/JuliaParallel/MPI.jl). The goal of this project is to migrate AMR to GPUs using dynamic parallelism for acceleration with [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl).

The possible subtasks in this project include:

- Implementing the abstract tree initialization process on GPUs.  
- Exploring the [`TreeMesh`](https://trixi-framework.github.io/Trixi.jl/stable/meshes/tree_mesh/) initialization processes on GPUs based on the implementation of the first task and combining them.  
- Integrating the above into [`AMRCallback`](https://trixi-framework.github.io/Trixi.jl/stable/tutorials/adaptive_mesh_refinement/#Callback) in the simulation using [dynamic parallelism](https://cuda.juliagpu.org/stable/api/kernel/#Dynamic-parallelism) (via CUDA.jl).  
- Optimizing the code for data transfer, kernel launch overhead, occupancy, etc.  
- Starting the above work in 1D and then expanding it to 2D and 3D problems.
- (Optional) Try similar work for [`P4estMesh`](https://trixi-framework.github.io/Trixi.jl/stable/meshes/p4est_mesh/) in 2D and 3D.

This project is good for people who are interested in GPU programming, parallel computing, parallel algorithm optimization, and scientific computing.

**Recommended skills:** GPU programming, knowledge of CUDA dynamic parallelism, and familiarity with mesh refinement. (For beginners or those unfamiliar with dynamic parallelism, it is recommended to start with the [CUDA quadtree example](https://github.com/NVIDIA/cuda-samples/tree/master/Samples/3_CUDA_Features/cdpQuadtree).)

**Expected results:** A working example of AMR running on GPUs.

**Mentors**: [Huiyu Xie](https://github.com/huiyuxie), [Jesse Chan](https://github.com/jlchan), [Hendrik Ranocha](https://github.com/ranocha)