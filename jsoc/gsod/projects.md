# Julia's Google Season of Docs Projects

Below are the projects which have been proposed for Google Season of Docs under the umbrella of the Julia Language. If you have questions about potential projects, the first point of contact would be the mentor(s) listed on the project. If you are unable to get ahold of the potential mentor(s), you should email `jsoc@julialang.org` and CC `logan@julialang.org`. 

We at the Julia Language are committed to making the application process and participation in GSoD with Julia accessible to everyone. If you have questions or requests, please do reach out and we will do our best to accomodate you. 

## Differential Equations

DifferentialEquations.jl is a widely used Julia library for solving ordinary, stochastic, delay, any many more types of differential equations. Below are the proposed projects in this area. Technical writers may wish to do a combination of these projects. The mentor for the JuliaDiffEq projects is [Chris Rackauckas](https://github.com/ChrisRackauckas).

- ### Updated Documentation and Doc Testing

  DifferentialEquations.jl's documentation at [DiffEqDocs.jl](https://github.com/SciML/DiffEqDocs.jl) was one of the first [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) projects, and as such much of its internals are in dire need of updates. Notably, automated reference handling would fix issues with dead links that are not uncommon. Additionally, none of the examples run doc tests, and thus currently the organization relies on user issues to find out when to update the pages. Lastly, there are many requests for a PDF form of this documentation since many of the materials are only featured in this form, yet sadly there is currently no PDF builder associated with DiffEqDocs.jl even though Documenter.jl has recently gained this functionality.

- ### Tutorial Writing

  The JuliaDiffEq organization hosts the [DiffEqTutorials.jl](https://github.com/SciML/DiffEqTutorials.jl) repository which auto-builds websites and pdfs from tutorials. Tutorials generally center features of DifferentialEquations.jl or on application domains. Technical writers who have an expertise in areas like biological modeling may wish to contribute tutorials that showcase how to use DifferentialEquations.jl to solve problems arising in their discipline.

- ### Automated Benchmarks and Performance Regression Flagging

  The organization hosts the [DiffEqBenchmarks.jl](https://github.com/SciML/DiffEqBenchmarks.jl) repository which generates websites and pdfs describing the performance relationships not only between the native Julia differential equation solvers, but also between the commonly used C++ and Fortran methods, making it the most comprehensive set of differential equation solver benchmarks. These benchmarking scripts utilize [Weave.jl](https://github.com/mpastell/Weave.jl) to automate the process. Technical writers can contribute benchmarks which cover new areas and types of differential equations and add explanatory details and summaries to help with the interpretation of benchmarks. Additionally, skilled technical writers may with to help setup systems to update the benchmarks in some semi-automated form, along with detection and flagging whenever performance regressions are found (i.e. the benchmark equivalent to doc tests).

## Julia (Main Documentation)

[The Julia docs](https://docs.julialang.org/en/v1/) provide provide a robust set of examples and context for the available functionality in the Julia Programming Language. The mentor for this project is [Logan Kilpatrick](https://github.com/logankilpatrick) with support from [other Julia Language members](https://github.com/orgs/JuliaLang/people). 

### Audit the existing documentation

  While the [Julia documentation](https://docs.julialang.org/en/v1/) is robust, it has been written and worked on by hundreds of contributors over many years. This has led to potential instances where the docs do not represent a singular voice and may not be as clear as they can be. 
  
  __This project would/could include the following:__
  - Identifying pain points in the docs and conducting an audit on those sections (the docs are robust and long, so auditing all of the docs may be enough work for a stand alone project). 
  - Rewording/rewriting the sections in questions (perhaps with more examples) to ensure clarity. 
  - Optionally, updating the [FAQ section of the docs](https://docs.julialang.org/en/v1/manual/faq/) to reflect more popular questions from the Julia Discourse and Stack Overflow. 
  - If time allows, adding additional docs tests (which are just examples of the use of a function, see [here](https://github.com/JuliaLang/julia/pull/35647)) to ensure it is clear what each function does, just by reading the docs. 
  
  __Potential impact and the Why?:__
  - This project represents a unique opportunity to work on a core aspect of the Julia Language. Given the high visibility level of the Julia docs, making sure they are done well and truly help developers is very important. Since we are a open source and community driven project, it is very diffidult to keep a singular voice and extensively vett each and every doc change. This project presents the chance to ensure Julia devs will have clear and useful documentation for years to come. 
  
  - Success for this project could be quantified by keeping track of the number of issues raised on the parts of the docs that were audited and updated. 


### Updating contributing guide

  The [Julia contributing guide](https://github.com/JuliaLang/julia/blob/master/CONTRIBUTING.md) provides details on how one who is either a new Julia contributor or returning contributor, can make a change to the Julia docs or the core Julia code base. 
  
   __This project would/could include the following:__
   - Auditing the existing contributing guide to ensure it covers developer usecases correctly. 
   - Moving the guide to a more robust and user friendly section of the [Julia Website](https://julialang.org) (potentially making a "contributing" folder and then having details on different usecases rather than just one long doc). 
   - Optionally, making a contributing guide template so that all of the 3,000+ Julia Packages also have guidelines for contributors. 
   - If time allows, making a step by step "first time contributor" guide which highlights common first time contributions, where to find potential things to contribute/change, and how to contribute those. 
   
   __Potential impact and the Why?:__
   - Ensuring that the Julia Language provides an open, inclusive, and friendly community for first time and returning contributors is a high priority. Historically, Julia has been used in mostly scientific domains, thus the docs and other materials are written with that audience in mind. As the community countinues to grow, it is evident that we need to be approaching documents, like the contributing guide, differently so we can warmly welcome the next generation of Julia developers. 
   
   - Success for this project could be quantified by keeping track of whether or not the number of first time contributors goes up and if they are able to open a Pull Request that follows the suggestions in the contributing guide successfully. 

  
## JuliaGraphs

[JuliaGraphs](https://github.com/JuliaGraphs) provides a set of abstractions, reference implementations, and essential algorithms to build and work on graphs. The mentor for this project is [Seth Bromberger](https://github.com/sbromberger). This project could include one or more of the following documentation efforts:

#### Central website

  The central website of [JuliaGraphs](https://juliagraphs.github.io/) offers an overview of the ecosystem's packages and is still mostly a description. It can be improved to become the first resource for people getting started with graphs in Julia.
   - This includes highlighting features of various packages in the ecosystem. 
   - Visual explanations of the algorithms used in Graphs
   - Begginer guides for those taking their first step into the world of using grpahs in Julia. 
   
   __This project would/could include the following:__
 - Performing an audit of the existing website to make sure the features highlighted are still relevant and supported.  
 - Highlighting features of various packages in the ecosystem such that one will know what is possible with JuliaGraphs. 
 - Including use cases and potential examples to highlight the functionality without overwhelmeing vistors with technical jargon. 
 - Creating a section which highlights the different uses of the various packages in different domains (Healthcare, Education, Etc.)
 - Optionally, creating beginner guides for those taking their first step into the world of using graphs in Julia. 
 - If time allows, researching visual explanations of the algorithms used in Graphs

#### LightGraphs 2.0 documentation

  The upcoming version 2.0 of LightGraphs, due later this summer, represents a fundamental change in the LightGraphs API. Assistance is needed to make sure the documentation represents the latest and greatest features.
  
  __This project would/could include the following:__
 - Performing an audit of the existing API docs to see what documentation can stay the same.  
 - Analysing the changes made in the 2.0 release to ensure they are properly documented with examples. 
 - Writing an blog post/discourse post which highlights major changes in the 2.0 release. 
 - Optionally, creating beginner guides for those taking their first step into the world of using graphs in Julia. 
 - If time allows, creating a template of materials to support future major version releases. 
 
#### Tutorials

  The documentation of all JuliaGraphs packages, such as [LightGraphs](https://juliagraphs.github.io/LightGraphs.jl/latest/) is developer-oriented, showing the API of the different types and functions of the packages.
  Some step-by-step examples and motivation for the use of each feature can be added, making it more accessible for users of the package.
  
  __This project would/could include the following:__
 - Performing an audit of the existing tutorials to see what materials exist already.  
 - Working with maintainers to document motivation for various features. 
 - Integrating the motivation into the existing tutorials to further learners understanding. 
 - Optionally, creating beginner guides to fill any gaps left by existing tutorials (this would be more indepth and technical). 
 - If time allows, creating a template for tutorials across all packages in the LightGraphs ecosystem. 

### Potential Impact
  The JuliaGraphs ecosystem is used by end-users and library developers alike. Each of these communities requires a different type of documentation: end users need to understand how to use the functions to solve scientific/technical problems; library developers need to understand how to integrate the APIs into their own code. 

  The potential impact of the GSOD effort – that is, the development of comprehensive, easy-to-understand documentation for one or both of these communities – would be the increased adoption of LightGraphs as one of the fastest single-language open-source graph analytic toolkits. From a well-regulated corpus of developer documentation, we should expect an increase in the number of contributors to the JuliaGraphs ecosystem and increased interest in development of new packages that incorporate JuliaGraphs libraries, while a thorough set of end-user documentation would increase the usage of LightGraphs in scientific research. Furthermore, general awareness of JuliaGraphs and the Julia Programming Language would be improved with a revamp of the main JuliaGraphs website, which could serve as the central landing point for all graph-related activity in Julia.
  
  The impact can be quantified by the monitoring the number of users who visit the main JuliaGraphs website pre and post update. 

## JuliaStats (Statistics)

The [JuliaStats](https://github.com/juliastats) organization hosts packages solving various problems in data analysis and statistics, from computing [distances](https://github.com/JuliaStats/Distances.jl/) to [grouping data points together](https://juliastats.github.io/Clustering.jl/stable).
  This breadth of scope makes it challenging to keep track of which task is performed in each package. The mentors for this project can be found [here](https://github.com/orgs/JuliaStats/people). 

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

  As a part of this project, the content on the main landing page <https://fluxml.ai> can be revamped to highlight some of the interesting progress. The website could use some polish with regards to further clarify the messaging without overwhelming a newcomer, while showing off some of the finer grained details to a veteran eye.
  Tools developed by FluxML are widely used by many projects, from Graph Neural Network libraries [Mill.jl](https://github.com/pevnak/Mill.jl), [GeometricFlux.jl](https://github.com/yuehhua/GeometricFlux.jl) and Probabilistic Programming libraries [Turing.jl](https://github.com/TuringLang/Turing.jl) to Scientific ML projects [DiffEqFlux.jl](https://github.com/SciML/DiffEqFlux.jl) and modern large scale Transformer networks [Transformers.jl](https://github.com/chengchingwen/Transformers.jl). We would like to show off the flexibility and use cases that we fit in.

- ### Tutorials

  Flux is in dire need of complete tutorials in the [model-zoo](https://github.com/FluxML/model-zoo.git) as well as in the website. We can take inspiration from many existing projects that publish their tutorials, that take a look at common design patterns. This includes writing custom adjoints, new optimisers, transfer learning, and writing performance sensitive code for many common kinds of networks that many people would be interested in writing.
  This could also include cases that help users write custom loss functions, and even putting Flux models behind a web server.

- ### Updated Documentation and DocTests

  Flux documentation needs a lot of rework, since our generic approach to development means there are many general use cases that we support but might be a bit subtle to discover. So in that case, we need to highlight such common cases, and make them known in the documentation.
  We would like to use doc tests to also increase our coverage of and documentation of many of the common patterns we see in differentiating Julia code.

### Potential Impact

  Flux is an innovative approach to machine learning. This also means that not all the same patterns and assumptions truly hold when translating from a different framework. It also needs a way to communicate a compelling description of how to implement many of the user facing niceties that one might need in the course of completing an ML project. Through this, we want to also find areas of improvement where we could offer a better user experience.

  This would definitely also greatly benefit the adoption of Flux in the larger ML ecosystem, which we feel is currently held back due to not having enough of these simple patterns documented in an approachable form. We want to see an increase in the number of contributors to the various packages too, since that would help us improve our stack better. Flux also utilises simple to understand and performant code, made possible by Julia, and through this, we also want to bring awareness to how our ecosystem has matured, and increase its adoption in research and in industry.

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

## Turing

[Turing.jl](https://turing.ml/dev/) is a probabilistic programming language written in Julia. The team is looking for help with several projects. Mentors for this project would be [Cameron Pfiffer](https://github.com/cpfiffer/), [Martin Trapp](https://github.com/trappmartin/), [Kai Xu](https://github.com/xukai92), or [Hong Ge](https://github.com/yebai/).

Here are some ideas:

- A structured explanation of the different inference algorithms provided in Turing with details on when to use each algorithm and what are the implications of each approach. Turing has many sampling algorithms but their value is not fully recognized by inexperienced users -- heuristics on when to use which algorithms would greatly benefit the user experience. Documentation might run speed tests, or measure convergence criteria for different sampler types. One such [blog post](https://dm13450.github.io/2019/04/10/Turing-Sampling-Speed.html) focused mostly on speed, but there are features of different models and data that make some samplers preferrable to others.

- An introduction to probabilistic modelling and the Bayesian approach in Turing with a discussion of general Bayesian issues such as the choice of prior. Turing lacks a good resource for those who are just beginning with probabilistic modelling, and users tend to use [Stan's](https://mc-stan.org/docs/2_23/stan-users-guide/index.html) excellent documentation or [Probabilistic Programming & Bayesian Methods for Hackers](https://camdavidsonpilon.github.io/Probabilistic-Programming-and-Bayesian-Methods-for-Hackers/) to learn how to use probabilistic programming. Turing should be self-contained when it comes to grabbing early-phase learners.

- A better tutorial that shows how to integrate [Flux.jl](https://github.com/FluxML/Flux.jl) with Turing. Turing has an [existing tutorial](https://turing.ml/dev/tutorials/3-bayesnn/) that shows how to build a Bayesian neural network with Flux.jl, but this is very much a toy example and does not demonstrate real-world applicability. A guide that shows how to apply Flux and Turing in a useful setting would be valuable for Julia, Turing, and Flux.

- Documentation and manuals for [MCMCChains](https://github.com/TuringLang/MCMCChains.jl), [AdvancedHMC](https://github.com/TuringLang/AdvancedHMC.jl), and [Bijectors](https://github.com/TuringLang/Bijectors.jl). Turing maintains several separate packages, all of which have some documentation, but each of these could be improved dramatically.

### Potential impact

Turing is a rapidly developing probabilistic programming language, used by machine learning researchers, data scientists, statisticians, and economists. Improving any measure of the informational tools in Turing will allow those communities to integrate better with the Julia community, which will in turn improve the rest of Julia's ecosystem. Better documentation and guides will attract new learners and help to transition more experienced people from tools that do not meet their needs.
