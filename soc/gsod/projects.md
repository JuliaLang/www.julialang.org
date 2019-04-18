# Julia's Google Season of Docs Projects

Below are the projects which have been proposed for Google Season of Docs.

## Differential Equations

DifferentialEquations.jl is a widely used Julia library for solving ordinary, stochastic, delay, any many more types of differential equations. Below are the proposed projects in this area. Technical writers may wish to do a combination of these projects. The mentor for the JuliaDiffEq projects is [Chris Rackauckas](https://github.com/ChrisRackauckas).

### Updated Documentation and Doc Testing

DifferentialEquations.jl's documentation at [DiffEqDocs.jl](https://github.com/JuliaDiffEq/DiffEqDocs.jl) was one of the first [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) projects, and as such much of its internals are in dire need of updates. Notably, automated reference handling would fix issues with dead links that are not uncommon. Additionally, none of the examples run doc tests, and thus currently the organization relies on user issues to find out when to update the pages. Lastly, there are many requests for a PDF form of this documentation since many of the materials are only featured in this form, yet sadly there is currently no PDF builder associated with DiffEqDocs.jl even though Documenter.jl has recently gained this functionality.

### Tutorial Writing

The JuliaDiffEq organization hosts the [DiffEqTutorials.jl](https://github.com/JuliaDiffEq/DiffEqTutorials.jl) repository which auto-builds websites and pdfs from tutorials. Tutorials generally center features of DifferentialEquations.jl or on application domains. Technical writers who have an expertise in areas like biological modeling may wish to contribute tutorials that showcase how to use DifferentialEquations.jl to solve problems arising in their discipline.

### Automated Benchmarks and Performance Regression Flagging

The organization hosts the [DiffEqBenchmarks.jl](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl) repository which generates websites and pdfs describing the performance relationships not only between the native Julia differential equation solvers, but also between the commonly used C++ and Fortran methods, making it the most comprehensive set of differential equation solver benchmarks. These benchmarking scripts utilize [Weave.jl](https://github.com/mpastell/Weave.jl) to automate the process. Technical writers can contribute benchmarks which cover new areas and types of differential equations and add explanatory details and summaries to help with the interpretation of benchmarks. Additionally, skilled technical writers may with to help setup systems to update the benchmarks in some semi-automated form, along with detection and flagging whenever performance regressions are found (i.e. the benchmark equivalent to doc tests).

## Graphs

LightGraphs.jl provides a set of abstractions, reference implementations and essential algorithms to build and work on graphs.

### Central website

The central website of [JuliaGraphs](https://juliagraphs.github.io/) offers an overview of the ecosystem packages and is still mostly a description. It can be improved to become the first resource for people getting started with graphs in Julia with a quick tour of the feature, some visual explanations of the algorithms.

### Tutorials

The documentation of all JuliaGraphs packages, such as [LightGraphs](https://juliagraphs.github.io/LightGraphs.jl/latest/) is developer-oriented, showing the API of the different types and functions of the packages.
Some step-by-step examples and motivation for the use of each feature can be added, making it more accessible for users of the package.
