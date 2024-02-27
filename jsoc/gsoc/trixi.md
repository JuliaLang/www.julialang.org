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

**Mentors**: [Michael Schlottke-Lakemper](https://github.com/sloede), [Benedict Geihe](https://www.mi.uni-koeln.de/NumSim/dr-benedict-geihe/)
