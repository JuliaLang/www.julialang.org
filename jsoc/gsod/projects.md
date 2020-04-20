# Julia's Google Season of Docs Projects

Below are the projects which have been proposed for Google Season of Docs.

## Differential Equations

DifferentialEquations.jl is a widely used Julia library for solving ordinary, stochastic, delay, any many more types of differential equations. Below are the proposed projects in this area. Technical writers may wish to do a combination of these projects. The mentor for the JuliaDiffEq projects is [Chris Rackauckas](https://github.com/ChrisRackauckas).

### Updated Documentation and Doc Testing

DifferentialEquations.jl's documentation at [DiffEqDocs.jl](https://github.com/SciML/DiffEqDocs.jl) was one of the first [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) projects, and as such much of its internals are in dire need of updates. Notably, automated reference handling would fix issues with dead links that are not uncommon. Additionally, none of the examples run doc tests, and thus currently the organization relies on user issues to find out when to update the pages. Lastly, there are many requests for a PDF form of this documentation since many of the materials are only featured in this form, yet sadly there is currently no PDF builder associated with DiffEqDocs.jl even though Documenter.jl has recently gained this functionality.

### Tutorial Writing

The JuliaDiffEq organization hosts the [DiffEqTutorials.jl](https://github.com/SciML/DiffEqTutorials.jl) repository which auto-builds websites and pdfs from tutorials. Tutorials generally center features of DifferentialEquations.jl or on application domains. Technical writers who have an expertise in areas like biological modeling may wish to contribute tutorials that showcase how to use DifferentialEquations.jl to solve problems arising in their discipline.

### Automated Benchmarks and Performance Regression Flagging

The organization hosts the [DiffEqBenchmarks.jl](https://github.com/SciML/DiffEqBenchmarks.jl) repository which generates websites and pdfs describing the performance relationships not only between the native Julia differential equation solvers, but also between the commonly used C++ and Fortran methods, making it the most comprehensive set of differential equation solver benchmarks. These benchmarking scripts utilize [Weave.jl](https://github.com/mpastell/Weave.jl) to automate the process. Technical writers can contribute benchmarks which cover new areas and types of differential equations and add explanatory details and summaries to help with the interpretation of benchmarks. Additionally, skilled technical writers may with to help setup systems to update the benchmarks in some semi-automated form, along with detection and flagging whenever performance regressions are found (i.e. the benchmark equivalent to doc tests).

## Graphs

LightGraphs.jl provides a set of abstractions, reference implementations and essential algorithms to build and work on graphs.

### Central website

The central website of [JuliaGraphs](https://juliagraphs.github.io/) offers an overview of the ecosystem packages and is still mostly a description. It can be improved to become the first resource for people getting started with graphs in Julia with a quick tour of the feature, some visual explanations of the algorithms.

### LightGraphs 2.0 documentation

The upcoming version 2.0 of LightGraphs, due later this summer, represents a fundamental change in the LightGraphs API. Assistance is needed to make sure the documentation represents the latest and greatest features.

### Tutorials

The documentation of all JuliaGraphs packages, such as [LightGraphs](https://juliagraphs.github.io/LightGraphs.jl/latest/) is developer-oriented, showing the API of the different types and functions of the packages.
Some step-by-step examples and motivation for the use of each feature can be added, making it more accessible for users of the package.

## Statistics

The [JuliaStats](https://github.com/juliastats) organization hosts packages solving various problems in data analysis and statistics, from computing [distances](https://github.com/JuliaStats/Distances.jl/) to [grouping data points together](https://juliastats.github.io/Clustering.jl/stable).
This breadth of scope makes it challenging to keep track of which task is performed in each package.

### JuliaStats website

The [main website](https://juliastats.github.io) is at the moment displaying a brief list of packages from the ecosystem. We could use this central place to map the features to the different packages, and how to use them in different situations.

### Problem-oriented documentation

For key packages such as [Distributions.jl](https://juliastats.github.io/Distributions.jl/stable), tutorials could be written in the same fashion as introductions to the analysis problem at hand and how it gets solved in the package using the API.

## Flux (Machine Learning)

[Flux.jl](https://github.com/FluxML/Flux.jl) is an elegant approach to machine learning in Julia. It is designed to be hackable and flexible, extendable and exposes powerful AD tools. It also provides abstractions over the popular layers and optimisers used in neural networks. It is built with differentiable programming in mind.

### Updated Documentation and Website

The [documentation](https://fluxml.ai/Flux.jl/stable/) for Flux.jl needs updating and references to model examples where necessary. Flux.jl runs doctests with every commit. The docs only expose a limited subset of the possible ways the APIs can function, and while efforts have been made to ensure that most usecases have been represented, we would like the user to get a feel of how they can leverage a more expressive training loop, or carry out very custom optimisation routines, etc. This could be done by way of motivating use cases in the API design.

As a part of this, the content on the main landing page https://fluxml.ai can be revamped to highlight some of the interesting progress. The website could use some poilsh with regards to further clarify the messaging without overwhelming a newcomer, while showing off some of the finer grained details to a veteran eye.

### Port ML Tutorials

There are a lot of high quality open-source ML tutorials for users to not just learn a new conept but also get a feel for the underlying tooling they use. The PyTorch tutorials and the Fast.ai courses are some of our favorites. We would like Flux ports of the same which can be published on the website.

### Model-Zoo Examples

The model-zoo is where a lot of the examples of modeling lives. From basic MLPs to advanced reinforcement learning and differentiable programming demos, we would like to have literature around them in a manner that can be understood by [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl). This way we have an awesome range of models and examples in a notebook style format available automatically for tinkering by users.

## VS Code extension

The [Julia VS Code extension](https://github.com/JuliaEditorSupport/julia-vscode) currently has hardly any documentation. We are looking for someone to flesh out the docs and the [homepage](https://www.julia-vscode.org/) for the extension.

## Queryverse

[Queryverse](https://www.queryverse.org/) is a family of packages in the data science space. Many packages have rudimentary documentation but could use updates, polish, proper tutorials etc. We are looking for help with documentation for all packages, and to build out the homepage for the project.
