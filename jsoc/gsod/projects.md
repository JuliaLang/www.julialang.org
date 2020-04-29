# Julia's Google Season of Docs Projects

Below are the projects which have been proposed for Google Season of Docs.

## Differential Equations

DifferentialEquations.jl is a widely used Julia library for solving ordinary, stochastic, delay, any many more types of differential equations. Below are the proposed projects in this area. Technical writers may wish to do a combination of these projects. The mentor for the JuliaDiffEq projects is [Chris Rackauckas](https://github.com/ChrisRackauckas).

- ### Updated Documentation and Doc Testing

  DifferentialEquations.jl's documentation at [DiffEqDocs.jl](https://github.com/SciML/DiffEqDocs.jl) was one of the first [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) projects, and as such much of its internals are in dire need of updates. Notably, automated reference handling would fix issues with dead links that are not uncommon. Additionally, none of the examples run doc tests, and thus currently the organization relies on user issues to find out when to update the pages. Lastly, there are many requests for a PDF form of this documentation since many of the materials are only featured in this form, yet sadly there is currently no PDF builder associated with DiffEqDocs.jl even though Documenter.jl has recently gained this functionality.

- ### Tutorial Writing

  The JuliaDiffEq organization hosts the [DiffEqTutorials.jl](https://github.com/SciML/DiffEqTutorials.jl) repository which auto-builds websites and pdfs from tutorials. Tutorials generally center features of DifferentialEquations.jl or on application domains. Technical writers who have an expertise in areas like biological modeling may wish to contribute tutorials that showcase how to use DifferentialEquations.jl to solve problems arising in their discipline.

- ### Automated Benchmarks and Performance Regression Flagging

  The organization hosts the [DiffEqBenchmarks.jl](https://github.com/SciML/DiffEqBenchmarks.jl) repository which generates websites and pdfs describing the performance relationships not only between the native Julia differential equation solvers, but also between the commonly used C++ and Fortran methods, making it the most comprehensive set of differential equation solver benchmarks. These benchmarking scripts utilize [Weave.jl](https://github.com/mpastell/Weave.jl) to automate the process. Technical writers can contribute benchmarks which cover new areas and types of differential equations and add explanatory details and summaries to help with the interpretation of benchmarks. Additionally, skilled technical writers may with to help setup systems to update the benchmarks in some semi-automated form, along with detection and flagging whenever performance regressions are found (i.e. the benchmark equivalent to doc tests).

## Graphs

LightGraphs.jl provides a set of abstractions, reference implementations, and essential algorithms to build and work on graphs. The mentor for this project is [Seth Bromberger](https://github.com/sbromberger).

- ### Central website

  The central website of [JuliaGraphs](https://juliagraphs.github.io/) offers an overview of the ecosystem packages and is still mostly a description. It can be improved to become the first resource for people getting started with graphs in Julia with a quick tour of the feature, some visual explanations of the algorithms.

- ### LightGraphs 2.0 documentation

  The upcoming version 2.0 of LightGraphs, due later this summer, represents a fundamental change in the LightGraphs API. Assistance is needed to make sure the documentation represents the latest and greatest features.

- ### Tutorials

  The documentation of all JuliaGraphs packages, such as [LightGraphs](https://juliagraphs.github.io/LightGraphs.jl/latest/) is developer-oriented, showing the API of the different types and functions of the packages.
  Some step-by-step examples and motivation for the use of each feature can be added, making it more accessible for users of the package.

## JuliaStats (Statistics)

The [JuliaStats](https://github.com/juliastats) organization hosts packages solving various problems in data analysis and statistics, from computing [distances](https://github.com/JuliaStats/Distances.jl/) to [grouping data points together](https://juliastats.github.io/Clustering.jl/stable).
  This breadth of scope makes it challenging to keep track of which task is performed in each package.

- ### JuliaStats website

  The [main website](https://juliastats.github.io) is at the moment displaying a brief list of packages from the ecosystem. We could use this central place to map the features to the different packages, and how to use them in different situations. We envison this could potentially look like the "Compare Features" section of the [GitHub pricing page](https://github.com/pricing) with additional pages that highlight the use cases of the different packages in various domains. 
  
__This project would/could include the following:__
 - Performing an audit of the existing website to make sure the features highlighted are still relevant and supported.  
 - Comparing the features in a fashion which highlights the potential overlap and differences.
 - Including use cases and potential examples to highlight the functionality without overwhelmeing vistors with technical jargon. 
 - Creating a section which highlights the different uses of the various packages in different domains (Healthcare, Education, Etc.)
 - If time allows and there is interest from the writer, certain packages that are part of the JuliaStats org (like [GLM.jl](https://github.com/JuliaStats/GLM.jl) are in need of more examples (which can be taken/solcited from community members), and a clarification of the relationships with DataFrames / Stats Models). While this requires a bit more interest in delving into the technical details, the addition of more examples would help the packages use. 
 
__Potential impact and the Why?:__
 - As Julia was origionally written as a scientific computing language, JuliaStats represents a core pillar of the community. Ensuring that those interested in transitioning from another language to Julia are able to understand the JuliaStats ecosystem better is the primary motivation for this project. By properly documenting and aggreating the feature sets of these packages, we will not only help more easily onboard new folks into the JuliaStats ecosystem but also help minimize any duplication of efforts that may arise from someone re-writting existing features that already exist. 
 
 - The impact of this project can be quantified by measuring if the number of questions related to the features available in the [JuliaStats ecosystem on Discourse](https://discourse.julialang.org/c/domain/stats) goes down. 
  
## Flux (Machine Learning)

[Flux.jl](https://github.com/FluxML/Flux.jl) is an elegant approach to machine learning in Julia. It is designed to be hackable and flexible, extendable and exposes powerful AD tools. It also provides abstractions over the popular layers and optimisers used in neural networks. It is built with differentiable programming in mind. The mentor for this project would be [Dhairya Gandhi](https://github.com/dhairyagandhi96).

- ### Reinventing the FluxML Website

  As a part of this, the content on the main landing page https://fluxml.ai can be revamped to highlight some of the interesting progress. The website could use some poilsh with regards to further clarify the messaging without overwhelming a newcomer, while showing off some of the finer grained details to a veteran eye.


## VS Code extension

The [Julia VS Code extension](https://github.com/JuliaEditorSupport/julia-vscode) currently has hardly any documentation. We are looking for someone to flesh out the docs and the [homepage](https://www.julia-vscode.org/) for the extension. The mentor for this project would be [David Anthoff](https://github.com/davidanthoff).

__This project would/could include the following:__
 - Performing an audit of what existing aspects of the Julia VS Code extension are documented. 
 - Documenting the remaining features of the extension (this does not require too much technical background but applicants should be familiar with the functionality of an Integrated Development Enviorment - "IDE")
 - The documentation for the Atom IDE is paticularly well done so we hope to be able to take inspiration from that to improve the docs for the Julia VS Code extension. You can find the Atom docs [here](https://flight-manual.atom.io). 
 - If time allows, there is also a desire for the creation of a "Getting started in Julia using VS Code" guide which will help more quickly onboard folks into the Julia Community from other languages who may already use VS Code. 
 
__Potential impact and the Why?:__
 - IDE's are commonplace amoung developers. Currently, the Julia Community heavily favors the use of Atom. We hope that by properly documenting how to use the Julia VS Code Extension we will not only help diversify the use of IDE's in the community but also improve our ability to onborad new folks into our community who may not be comfortable starting a new language plus a new IDE. 

 - The impact of this project can be quantified by assessing potential increases in the usage of the extension and by soliciting feedback from the community on the docs after they have been updated. 

## Queryverse

[Queryverse](https://www.queryverse.org/) is a family of packages in the data science space. Many packages have rudimentary documentation but could use updates, polish, proper tutorials etc. We are looking for help with documentation for all packages, and to build out the homepage for the project. The mentor for this project would be [David Anthoff](https://github.com/davidanthoff).
