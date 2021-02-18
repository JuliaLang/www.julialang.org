# Julia's Google Season of Docs Projects

Below are the projects which have been proposed for Google Season of Docs under the umbrella of the Julia Language. If you have questions about potential projects, the first point of contact would be the mentor(s) listed on the project. If you are unable to get ahold of the potential mentor(s), you should email `jsoc@julialang.org` and CC `logan@julialang.org`. 

We at the Julia Language are committed to making the application process and participation in GSoD with Julia accessible to everyone. If you have questions or requests, please do reach out and we will do our best to accommodate you. 

## Scientific Machine Learning (SciML) and Differential Equations

[DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl) is a widely used Julia library for solving ordinary, stochastic, delay, and many more types of differential equations. Below are the proposed projects in this area. Technical writers may wish to do a combination of these projects. The mentors for the JuliaDiffEq projects are [Chris Rackauckas](https://github.com/ChrisRackauckas), [Kanav Gupta](https://github.com/kanav99), and [Sam Isaacson](https://github.com/isaacsas).

Here are some possible projects:

- ### Updated Documentation and Doc Testing

  DifferentialEquations.jl's documentation at [DiffEqDocs.jl](https://github.com/SciML/DiffEqDocs.jl) was one of the first [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) projects, and as such much of its internals are in dire need of updates. Notably, automated reference handling would fix issues with deadlinks that are not uncommon. Additionally, none of the examples run doc tests, and thus currently the organization relies on user issues to find out when to update the pages. Lastly, there are many requests for a PDF form of this documentation since many of the materials are only featured in this form, yet sadly there is currently no PDF builder associated with DiffEqDocs.jl even though Documenter.jl has recently gained this functionality.

- ### Conversion of READMEs to full Documentation

  There are many areas in the SciML which have READMEs but not full documentation. One prominent example is [DiffEqFlux.jl](https://github.com/SciML/DiffEqFlux.jl) which has had [multiple blog posts written on it](https://julialang.org/blog/2019/01/fluxdiffeq/) but still has just a README! Changing from the README to proper documentation, utilizing the same information but re-styling the writing into the proper tutorial and reference portions, would be a major win. Global sensitivity analysis is another area where it would be useful to restyle towards full documentation.

- ### Unified Organization Documentation

[SciML](https://sciml.ai/) is the scientific machine learning organization. However, its documentation is spread amongst many different fairly large packages:

- [DifferentialEquations.jl](https://docs.sciml.ai/latest/)
- [DiffEqFlux.jl](https://diffeqflux.sciml.ai/dev/)
- [ModelingToolkit.jl](https://mtk.sciml.ai/dev/)
- [Surrogates.jl](https://surrogates.sciml.ai/latest/)

Just to name a few. One project would be to create a unified scientific machine learning documentation that would make it easy to move between all of these different package docs and understand the cohesive organization.

- ### Tutorial Writing

  The JuliaDiffEq organization hosts the [DiffEqTutorials.jl](https://github.com/SciML/DiffEqTutorials.jl) repository which auto-builds websites and pdfs from tutorials. Tutorials generally center on features of DifferentialEquations.jl or on application domains. Technical writers who have expertise in areas like biological modeling may wish to contribute tutorials that showcase how to use DifferentialEquations.jl to solve problems arising in their discipline.

- ### Automated Benchmarks and Performance Regression Flagging

  The organization hosts the [DiffEqBenchmarks.jl](https://github.com/SciML/DiffEqBenchmarks.jl) repository which generates websites and pdfs describing the performance relationships not only between the native Julia differential equation solvers but also between the commonly used C++ and Fortran methods, making it the most comprehensive set of differential equation solver benchmarks. These benchmarking scripts utilize [Weave.jl](https://github.com/mpastell/Weave.jl) to automate the process. Technical writers can contribute benchmarks that cover new areas and types of differential equations and add explanatory details and summaries to help with the interpretation of benchmarks. Additionally, skilled technical writers may wish to help set up systems to update the benchmarks in some semi-automated form, along with detection and flagging whenever performance regressions are found (i.e. the benchmark equivalent to doc tests).
  
### Potential Impact

  Many university classes use the SciML ecosystem for its teaching, and thus classrooms all over the world will be improved. Tutorials that capture more domains will allow professors teaching biological modeling courses to not have to manually rewrite physics-based tutorials to match their curriculum, and conversion of READMEs to documentation will help such professors link to reference portions for these tools in their lecture notes.
  
  Additionally, these benchmarks are a widely referenced cross-language benchmark of differential equations, which gives a standard between Python, R, Julia, MATLAB, and many C++ and Fortran packages. Improving the technical writing around the benchmarks can make this set of documents more widely accessible, and enlarging the scope of topics will help individuals of all programming languages better assess the methods they should be choosing for their problems.

## Julia (Main Documentation)

[The Julia docs](https://docs.julialang.org/en/v1/) provide a robust set of examples and context for the available functionality in the Julia Programming Language. The mentors for this project are [Logan Kilpatrick](https://github.com/logankilpatrick) and [Avik Sengupta](https://github.com/aviks) with support from [other Julia Language members](https://github.com/orgs/JuliaLang/people). 

### Audit the existing documentation

  While the [Julia documentation](https://docs.julialang.org/en/v1/) is robust, it has been written and worked on by hundreds of contributors over many years. This has led to potential instances where the docs do not represent a singular voice and may not be as clear as they can be. 
  
  __This project would/could include the following:__
  - Identifying pain points in the docs and conducting an audit on those sections (the docs are robust and long, so auditing all of the docs may be enough work for a stand-alone project). 
  - Rewording/rewriting the sections in questions (perhaps with more examples) to ensure clarity. 
  - Optionally, updating the [FAQ section of the docs](https://docs.julialang.org/en/v1/manual/faq/) to reflect more popular questions from the Julia Discourse and Stack Overflow. 
  - If time allows, adding additional docs tests (which are just examples of the use of a function, see [here](https://github.com/JuliaLang/julia/pull/35647)) to ensure it is clear what each function does, just by reading the docs. 
  
  __Potential impact and the Why?:__
  - This project represents a unique opportunity to work on a core aspect of the Julia Language. Given the high visibility level of the Julia docs, making sure they are done well and truly help developers is very important. Since we are an open-source and community-driven project, it is very difficult to keep a singular voice and extensively vet every doc change. This project presents the chance to ensure Julia devs will have clear and useful documentation for years to come. 
  
  - Success for this project could be quantified by keeping track of the number of issues raised on the parts of the docs that were audited and updated. 


### Updating contributing guide

  The [Julia contributing guide](https://github.com/JuliaLang/julia/blob/master/CONTRIBUTING.md) provides details on how one who is either a new Julia contributor or returning contributor, can make a change to the Julia docs or the core Julia codebase. 
  
   __This project would/could include the following:__
   - Auditing the existing contributing guide to ensure it covers developer use-cases correctly. 
   - Moving the guide to a more robust and user-friendly section of the [Julia Website](https://julialang.org) (potentially making a "contributing" folder and then having details on different use-cases rather than just one long doc). 
   - Optionally, making a contributing guide template so that all of the 3,000+ Julia Packages also have guidelines for contributors. 
   - If time allows, making a step by step "first-time contributor" guide which highlights common first-time contributions, where to find potential things to contribute/change, and how to contribute those. 
   
   __Potential impact and the Why?:__
   - Ensuring that the Julia Language provides an open, inclusive, and friendly community for the first time and returning contributors is a high priority. Historically, Julia has been used in mostly scientific domains, thus the docs and other materials are written with that audience in mind. As the community continues to grow, it is evident that we need to be approaching documents, like the contributing guide, differently so we can warmly welcome the next generation of Julia developers. 
   
   - Success for this project could be quantified by keeping track of whether or not the number of first-time contributors goes up and if they can open a Pull Request that follows the suggestions in the contributing guide successfully. 

  
## JuliaGraphs

[JuliaGraphs](https://github.com/JuliaGraphs) provides a set of abstractions, reference implementations, and essential algorithms to build and work on graphs. The mentors for this project are [Seth Bromberger](https://github.com/sbromberger) and [Katharine Hyatt](https://github.com/kshyatt). This project could include one or more of the following documentation efforts:

#### Central website

  The central website of [JuliaGraphs](https://juliagraphs.github.io/) offers an overview of the ecosystem's packages and is still mostly a description. It can be improved to become the first resource for people getting started with graphs in Julia.
   - This includes highlighting features of various packages in the ecosystem. 
   - Visual explanations of the algorithms used in Graphs
   - Beginner guides for those taking their first step into the world of using graphs in Julia. 
   
   __This project would/could include the following:__
 - Performing an audit of the existing website to make sure the features highlighted are still relevant and supported.  
 - Highlighting features of various packages in the ecosystem such that one will know what is possible with JuliaGraphs. 
 - Including use cases and potential examples to highlight the functionality without overwhelming visitors with technical jargon. 
 - Creating a section which highlights the different uses of the various packages in different domains (Healthcare, Education, Etc.)
 - Optionally, creating beginner guides for those taking their first step into the world of using graphs in Julia. 
 - If time allows, researching visual explanations of the algorithms used in Graphs

#### LightGraphs 2.0 documentation

  The upcoming version 2.0 of LightGraphs, due later this summer, represents a fundamental change in the LightGraphs API. Assistance is needed to make sure the documentation represents the latest and greatest features.
  
  __This project would/could include the following:__
 - Performing an audit of the existing API docs to see what documentation can stay the same.  
 - Analyzing the changes made in the 2.0 release to ensure they are properly documented with examples. 
 - Writing a blog post/discourse post which highlights major changes in the 2.0 release. 
 - Optionally, creating beginner guides for those taking their first step into the world of using graphs in Julia. 
 - If time allows, creating a template of materials to support future major version releases. 
 
#### Tutorials

  The documentation of all JuliaGraphs packages, such as [LightGraphs](https://juliagraphs.github.io/LightGraphs.jl/latest/) is developer-oriented, showing the API of the different types and functions of the packages.
  Some step-by-step examples and motivation for the use of each feature can be added, making it more accessible for users of the package.
  
  __This project would/could include the following:__
 - Performing an audit of the existing tutorials to see what materials exist already.  
 - Working with maintainers to document motivation for various features. 
 - Integrating the motivation into the existing tutorials to further learners' understanding. 
 - Optionally, creating beginner guides to fill any gaps left by existing tutorials (this would be more in-depth and technical). 
 - If time allows, creating a template for tutorials across all packages in the LightGraphs ecosystem. 

### Potential Impact
  The JuliaGraphs ecosystem is used by end-users and library developers alike. Each of these communities requires a different type of documentation: end-users need to understand how to use the functions to solve scientific/technical problems; library developers need to understand how to integrate the APIs into their code. 

  The potential impact of the GSOD effort – that is, the development of comprehensive, easy-to-understand documentation for one or both of these communities – would be the increased adoption of LightGraphs as one of the fastest single-language open-source graph analytic toolkits. From a well-regulated corpus of developer documentation, we should expect an increase in the number of contributors to the JuliaGraphs ecosystem and increased interest in the development of new packages that incorporate JuliaGraphs libraries, while a thorough set of end-user documentation would increase the usage of LightGraphs in scientific research. Furthermore, general awareness of JuliaGraphs and the Julia Programming Language would be improved with a revamp of the main JuliaGraphs website, which could serve as the central landing point for all graph-related activity in Julia.
  
  The impact can be quantified by monitoring the number of users who visit the main JuliaGraphs website pre and post update. 

## Flux (Machine Learning)

[Flux.jl](https://github.com/FluxML/Flux.jl) is an elegant approach to machine learning in Julia. It is designed to be hackable and flexible, extendable, and exposes powerful AD tools. It also provides abstractions over the popular layers and optimizers used in neural networks. It is built with differentiable programming in mind. The mentors for this project are [Dhairya Gandhi](https://github.com/dhairyagandhi96) and [Mike Innes](https://github.com/MikeInnes).

- ### Reinventing the FluxML Website

  As a part of this project, the content on the main landing page <https://fluxml.ai> can be revamped to highlight some of the interesting progress. The website could use some polish with regards to further clarify the messaging without overwhelming a newcomer while showing off some of the finer-grained details to a veteran eye.
  Tools developed by FluxML are widely used by many projects, from Graph Neural Network libraries [Mill.jl](https://github.com/pevnak/Mill.jl), [GeometricFlux.jl](https://github.com/yuehhua/GeometricFlux.jl) and Probabilistic Programming libraries [Turing.jl](https://github.com/TuringLang/Turing.jl) to Scientific ML projects [DiffEqFlux.jl](https://github.com/SciML/DiffEqFlux.jl) and modern large scale Transformer networks [Transformers.jl](https://github.com/chengchingwen/Transformers.jl). We would like to show off the flexibility and use cases that we fit in.

- ### Tutorials

  Flux is in dire need of complete tutorials in the [model-zoo](https://github.com/FluxML/model-zoo.git) as well as on the website. We can take inspiration from many existing projects that publish their tutorials, that take a look at common design patterns. This includes writing custom adjoints, new optimizers, transfer learning, and writing performance-sensitive code for many common kinds of networks that many people would be interested in writing.
  This could also include cases that help users write custom loss functions, and even putting Flux models behind a web server.

- ### Updated Documentation and DocTests

  Flux documentation needs a lot of rework since our generic approach to development means there are many general use cases that we support but might be a bit subtle to discover. So in that case, we need to highlight such common cases and make them known in the documentation.
  We would like to use doc tests to also increase our coverage of and documentation of many of the common patterns we see in differentiating Julia code.

### Potential Impact

  Flux is an innovative approach to machine learning. This also means that not all the same patterns and assumptions truly hold when translating from a different framework. It also needs a way to communicate a compelling description of how to implement many of the user-facing niceties that one might need in the course of completing an ML project. Through this, we want to also find areas of improvement where we could offer a better user experience.

  This would also greatly benefit the adoption of Flux in the larger ML ecosystem, which we feel is currently held back due to not having enough of these simple patterns documented in an approachable form. We want to see an increase in the number of contributors to the various packages too since that would help us improve our stack better. Flux also utilizes simple to understand and performant code, made possible by Julia, and through this, we also want to bring awareness to how our ecosystem has matured, and increase its adoption in research and industry.

## VS Code extension

The [Julia VS Code extension](https://github.com/JuliaEditorSupport/julia-vscode) currently has hardly any documentation. We are looking for someone to flesh out the docs and the [homepage](https://www.julia-vscode.org/) for the extension. The mentors for this project are [David Anthoff](https://github.com/davidanthoff) and [Zac Nugent](https://github.com/ZacLN).

__This project would/could include the following:__
 - Performing an audit of what existing aspects of the Julia VS Code extension are documented. 
 - Documenting the remaining features of the extension (this does not require too much technical background but applicants should be familiar with the functionality of an Integrated Development Environment - "IDE")
 - The documentation for the Atom IDE is particularly well done so we hope to be able to take inspiration from that to improve the docs for the Julia VS Code extension. You can find the Atom docs [here](https://flight-manual.atom.io). 
 - If time allows, there is also a desire for the creation of a "Getting started in Julia using VS Code" guide which will help more quickly onboard folks into the Julia Community from other languages who may already use VS Code. 
 
__Potential impact and the Why?:__
 - IDE's are commonplace among developers. Currently, the Julia Community heavily favors the use of Atom. We hope that by properly documenting how to use the Julia VS Code Extension we will not only help diversify the use of IDE's in the community but also improve our ability to onboard new folks into our community who may not be comfortable starting a new language plus a new IDE. 

 - The impact of this project can be quantified by assessing potential increases in the usage of the extension and by soliciting feedback from the community on the docs after they have been updated. 

## Turing (Probabilistic Machine Learning)

[Turing.jl](https://turing.ml/dev/) is a probabilistic programming language written in Julia. The team is looking for help with several projects. Mentors for this project would be [Cameron Pfiffer](https://github.com/cpfiffer/), [Martin Trapp](https://github.com/trappmartin/), [Kai Xu](https://github.com/xukai92), or [Hong Ge](https://github.com/yebai/).

Here are some ideas:

- A structured explanation of the different inference algorithms provided in Turing with details on when to use each algorithm and what are the implications of each approach. Turing has many sampling algorithms but their value is not fully recognized by inexperienced users -- heuristics on when to use which algorithms would greatly benefit the user experience. Documentation might run speed tests, or measure convergence criteria for different sampler types. One such [blog post](https://dm13450.github.io/2019/04/10/Turing-Sampling-Speed.html) focused mostly on speed, but there are features of different models and data that make some samplers preferable to others.

- An introduction to probabilistic modelling and the Bayesian approach in Turing with a discussion of general Bayesian issues such as the choice of prior. Turing lacks a good resource for those who are just beginning with probabilistic modelling, and users tend to use [Stan's](https://mc-stan.org/docs/2_23/stan-users-guide/index.html) excellent documentation or [Probabilistic Programming & Bayesian Methods for Hackers](https://camdavidsonpilon.github.io/Probabilistic-Programming-and-Bayesian-Methods-for-Hackers/) to learn how to use probabilistic programming. Turing should be self-contained when it comes to grabbing early-phase learners.

- A better tutorial that shows how to integrate [Flux.jl](https://github.com/FluxML/Flux.jl) with Turing. Turing has an [existing tutorial](https://turing.ml/dev/tutorials/3-bayesnn/) that shows how to build a Bayesian neural network with Flux.jl, but this is very much a toy example and does not demonstrate real-world applicability. A guide that shows how to apply Flux and Turing in a useful setting would be valuable for Julia, Turing, and Flux.

- Documentation and manuals for [MCMCChains](https://github.com/TuringLang/MCMCChains.jl), [AdvancedHMC](https://github.com/TuringLang/AdvancedHMC.jl), and [Bijectors](https://github.com/TuringLang/Bijectors.jl). Turing maintains several separate packages, all of which have some documentation, but each of these could be improved dramatically. Technical writers would review current documentation, meet with the development team for each package to determine the package goals, and assess whether current documentation meets those goals. AdvancedHMC, for example, requires a much more detailed guide that explores all of AdvancedHMC's functionality.

### Potential impact

Turing is a rapidly developing probabilistic programming language, used by machine learning researchers, data scientists, statisticians, and economists. Improving any measure of the informational tools in Turing will allow those communities to integrate better with the Julia community, which will, in turn, improve the rest of Julia's ecosystem. Better documentation and guides will attract new learners and help to transition more experienced people from tools that do not meet their needs.


## JuliaIntervals (Interval arithmetic methods)

The [JuliaIntervals organization](https://github.com/JuliaIntervals) develops a suite of packages based on [interval arithmetic](https://github.com/JuliaIntervals/IntervalArithmetic.jl) for performing numerical computations with guaranteed results.
We are looking for help with several projects, with
mentors [David P. Sanders](https://github.com/dpsanders) and [Luis Benet](https://github.com/lbenet).

Here are some possible projects:

- Modernize the documentation for [`IntervalArithmetic.jl`](https://github.com/JuliaIntervals/IntervalArithmetic.jl).
The documentation has not kept pace with the development of the package; e.g. methods for constructing intervals have changed significantly since most of the documentation was written. It is also unclear who the target audience is. The documentation should be split up into tutorial material, more advanced "how-to's", reference documentation, and explanation of the underlying mathematical concepts. There should be a discussion of performance implications of the different approaches to directed rounding that includes results from a benchmark suite. There should also be a section explaining how to use different floating-point types with the package, and a section discussing composability with other packages, and possible pitfalls, as highlighted in the [`NumberIntervals.jl`](https://github.com/gwater/NumberIntervals.jl) package.

- Several of the packages currently have rather minimal documentation, in particular [`IntervalOptimization.jl`](https://github.com/BryanCorzo/IntervalOptimization), [`IntervalConstraintProgramming.jl`](https://github.com/JuliaIntervals/IntervalConstraintProgramming.jl) and [`TaylorModels.jl`](https://github.com/JuliaIntervals/TaylorModels.jl). These need full tutorials and "how-to's" for solving example problems, as well as reference documentation. Preferably they should also be compared their use to other techniques for solving similar problems. Potential pitfalls should also be highlighted.

- Design a web page for the [`JuliaIntervals`](https://github.com/JuliaIntervals) suite of packages. This web page should provide information about the various packages in the suite, as well as related packages in the Julia ecosystem, showing what they can be used for and exhibiting interesting examples. The web page should also contain a guide to orient a user towards the relevant package for their needs, for example using some kind of decision tree.

### Potential impact

[`IntervalArithmetic.jl`](https://github.com/JuliaIntervals/IntervalArithmetic.jl) is heading towards full compliance with the international standard IEEE-1788. Once compliance is reached we will release v1.0 of the package and will advertise the package to the wider interval arithmetic community.

We anticipate that there may be significant interest and adoption by new users at that time. For this reason, it will be crucial to have documentation that is up-to-date, correct, and usable, for both new users and as a reference.

Furthermore, since there are now an increasing number of packages built on top of [`IntervalArithmetic.jl`](https://github.com/JuliaIntervals/IntervalArithmetic.jl) which will also be of interest to these users, a guide to both which package is suitable for which application and how to use them correctly is required.

## Julia GPU programming

Julia has several GPU back-ends, like CUDA.jl and AMDGPUnative.jl, that aim to provide a flexible and high-performance GPU programming environment in a high-level, productive programming language. These back-ends are organized under the JuliaGPU organization, with a landing page at https://juliagpu.org/. There are several possible projects to improve documentation for the JuliaGPU organization, guided by mentors [Tim Besard](https://github.com/maleadt) and [Valentin Churavy](https://github.com/vchuravy).

- Landing page: the current landing page hosts a short blurb on each back-end, but for users to decide which back-end they should use it would need to better reflect the tradeoffs, hardware and software compatibility, maturity, etc.

- GPU programming tutorials: to demonstrate Julia's GPU programming capabilities, a technical writer could work on tutorials that demonstrate common parallel programming patterns in Julia, and contrast that to GPU programming in the official toolkit languages (e.g. CUDA C) and/or other parallel programming possibilities that Julia has to offer (e.g. multithreaded programming). Example of such a tutorial: https://juliagpu.gitlab.io/CUDA.jl/tutorials/introduction/

CUDA.jl is currently the most popular back-end of the JuliaGPU ecosystem, and its documentation can be significantly improved on several aspects:

- High-level usage examples and documentation: CUDA.jl makes it possible to program GPUs using much higher-level programming paradigms than GPU programmers are used to, e.g. using arrays and higher-order abstractions. A technical writer could work on explaining these possibilities, the necessary tools and APIs, and how it relates to lower-level kernel programming.

- Kernel programming documentation: CUDA.jl mimics CUDA C, but several of its APIs are slightly different than their C counterparts. The documentation should explain this, and list which CUDA features are or are not supported. A technical writer could work on this, possibly adding inline examples to demonstrate these features with actual examples.

- API documentation: Many of CUDA's APIs are available in CUDA.jl via high-level wrappers, but that is not always obvious to users. The documentation of these wrappers should be checked for completeness, and presented in a structured manner so that users can easily consult it and do not need to consult the documentation of the underlying C APIs.

### Potential impact 

Julia's GPU programming capabilities are widely used, but users currently are all but required to already have GPU programming experience in order to know how to navigate the Julia GPU back-ends. Improving the technical documentation for the JuliaGPU organization and the CUDA.jl back-end would make it possible to skip this step, and make it possible for users to program GPUs without previous experience, greatly democratizing the ever-increasing compute capabilities that GPUs have to offer.

## Towards DeepChem.jl: Combining Machine Learning with Chemical Knowledge

We have been developing the AtomicGraphNets.jl package, which began modestly as a Julia port of [CGCNN](https://github.com/txie-93/cgcnn), but now has plans to expand to a variety of more advanced graph-based methods for state-of-the-art ML performance making predictions on atomic systems. In support of this package, we are also developing ChemistryFeaturization.jl, which contains functions for building and featurizing atomic graphs from a variety of standard input files. ChemistryFeaturization will eventually form the bedrock of a DeepChem.jl umbrella organization to host a Julia-based port of the popular [Deepchem](http://deepchem.io) Python package.

As part of this project, you would have the opportunity to learn all about how these packages work and apply them to new test cases for the purpose of building out our lists of examples, as well as helping to make tutorials to make sure our work is as accessible to the broader community as possible!

(See also: [cross-posting on GSoc projects page](/jsoc/gsoc/deepchem/))

**Recommended Skills**: Basic graph theory and linear algebra, some knowledge of chemistry

**Expected Results**: Contributions of new examples, documentation, and tutorials  in the eventual DeepChem.jl ecosystem

**Mentors**: [Rachel Kurchin](https://github.com/rkurchin)