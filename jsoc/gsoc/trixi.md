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
