---
layout: insidepage
title:  Programs
redirect_from:
  - /jsoc.html
  - /gsoc/2015/index.html
  - /gsoc/2014/index.html
  - /soc/index.html
---

# The Julia Language Organization Programs

The Julia Language Organization participates in various programming to fund students and other developers to contribute to the open source ecosystem. Below are the current programs that the Julia Language is participating in. For any questions, please consult the program administrators at programs@julialang.org

## Google Season of Docs (GSoD)

The Julia organization will be a participant in the 2019 Google Season of Docs which runs from August 1st to November 29th for most projects, with long running projects finishing on February 28th. Participants in this program are technical writers with a willingness to help Julia and its package ecosystem's documentation. Unlike the GSoC program, writers are not required to be students. Technical writers will pair with organization mentors to learn about their favorite Julia modules and packages and help appropriately document their capabilities.

Below we have a list of broad areas in the Julia open source ecosystem which are participating in the GSoD program. If interested in these areas, get in touch with the mentors through the `#jsoc` channel or through email. Check out the [application guidelines](guidelines/) once you have a project in mind.

**Table of Contents**

The following topics have been proposed for technical writers:

### Differential Equations

DifferentialEquations.jl is a widely used Julia library for solving ordinary, stochastic, delay, any many more types of differential equations. Below are the proposed projects in this area. Technical writers may wish to do a combination of these projects. The mentor for the JuliaDiffEq projects is [Chris Rackauckas](https://github.com/ChrisRackauckas).

#### Updated Documentation and Doc Testing

DifferentialEquations.jl's documentation at [DiffEqDocs.jl](https://github.com/JuliaDiffEq/DiffEqDocs.jl) was one of the first [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) projects, and as such much of its internals are in dire need of updates. Notably, automated reference handling would fix issues with dead links that are not uncommon. Additionally, none of the examples run doc tests, and thus currently the organization relies on user issues to find out when to update the pages. Lastly, there are many requests for a PDF form of this documentation since many of the materials are only featured in this form, yet sadly there is currently no PDF builder associated with DiffEqDocs.jl even though Documenter.jl has recently gained this functionality.

#### Tutorial Writing

The JuliaDiffEq organization hosts the [DiffEqTutorials.jl](https://github.com/JuliaDiffEq/DiffEqTutorials.jl) repository which auto-builds websites and pdfs from tutorials. Tutorials generally center features of DifferentialEquations.jl or on application domains. Technical writers who have an expertise in areas like biological modeling may wish to contribute tutorials that showcase how to use DifferentialEquations.jl to solve problems arising in their discipline.

#### Automated Benchmarks and Performance Regression Flagging

The organization hosts the [DiffEqBenchmarks.jl](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl) repository which generates websites and pdfs describing the performance relationships not only between the native Julia differential equation solvers, but also between the commonly used C++ and Fortran methods, making it the most comprehensive set of differential equation solver benchmarks. These benchmarking scripts utilize [Weave.jl](https://github.com/mpastell/Weave.jl) to automate the process. Technical writers can contribute benchmarks which cover new areas and types of differential equations and add explanatory details and summaries to help with the interpretation of benchmarks. Additionally, skilled technical writers may with to help setup systems to update the benchmarks in some semi-automated form, along with detection and flagging whenever performance regressions are found (i.e. the benchmark equivalent to doc tests).

## NumFOCUS Small Development Grants

## Google Summer of Code (GSoC)

The Julia organization is a participant in Google Summer of Code. The Julia organization generally fields a large number of students (>20) mentored by open source developers and university professors at leading institutions from all around the world. Students who are accepted into this prestigious program are paid a summer salary to contribute to the open source tooling around Julia and its package ecosystem.

This page lists a bunch of project ideas, meant to serve as starting points as you develop your own plan. You're free to modify them to your tastes, or propose something totally different in an area you're interested in.

Check out the [application guidelines](guidelines/) once you have a project in mind.

**Table of Contents**

We have our project ideas organized roughly into the skillsets required:

* [Turing projects](projects/turing.html) for probabilistic modelling and probabilistic programming.
* [Flux projects](https://fluxml.ai/gsoc.html) for machine learning.
* [Compiler](projects/compiler.html) – work on the Julia compiler's internals to make things better for everyone.
* [Web Platform](projects/wasm.html) – work on the Julia wasm backend or other aspects of julia in the browser.
* [HPC](projects/hpc.html) – write code that runs on lots of machines, goes really fast, processes lots of data, or all three.
* [Numerics](projects/numerics.html) – Challenges for the hard–core number-cruncher, including linear algebra routines and basic mathematical functions.
* [Science](projects/science.html) – provide Julia with the ability for scientific research in various fields.
* [Differential Equations](projects/diffeq.html) - Numerical methods for high-performance solving of differential equation models.
* [Tooling](projects/tooling.html) – The projects that make the people that make Julia go, go. Help us make a really amazing IDE!
* [Images](projects/images.html) – extend Julia's suite of tools for visualization and analysis of images.
* [General](projects/general.html) – jack-of-all-trades projects that don't require special skills.
* [Graphs](projects/graphs.html) – extend the JuliaGraphs ecosystem with new algorithms and tools.
* [Graphics](projects/graphics.html) – projects ranging from low level OpenGL rendering to high level plotting.
* [Tabular Data](projects/tables.html)
* [Continuous time signal processing](projects/kalmanbucy.html)

You can see previous Summer of Code projects at the [Archive page](archive.html).
