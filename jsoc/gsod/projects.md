# Julia's Google Season of Docs Projects

Below are the projects which have been proposed for Google Season of Docs under the umbrella of the Julia Language. If you have questions about potential projects, the first point of contact would be the mentor(s) listed on the project. If you are unable to get ahold of the potential mentor(s), you should email `jsoc@julialang.org` and CC `logan@julialang.org`. 

We at the Julia Language are committed to making the application process and participation in GSoD with Julia accessible to everyone. If you have questions or requests, please do reach out and we will do our best to accommodate you. 

### The GSoD experience with The Julia Language

Learn from one of our technical writers about their experience with GSoD:
~~~
<iframe width="100%" height="450" src="https://www.youtube-nocookie.com/embed/6s9J-ObQaAs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

# Project Ideas for 2022

Below you can find a running list of potential GSoD projects. If any of these are of interest to you, please reachout to the respective mentor(s).

\toc

## Scientific Machine Learning (SciML) and Differential Equations

[DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl) is a widely used Julia library for solving ordinary, stochastic, delay, and many more types of differential equations. Below are the proposed projects in this area. Technical writers may wish to do a combination of these projects. The mentors for the JuliaDiffEq projects are [Chris Rackauckas](https://github.com/ChrisRackauckas), [Kanav Gupta](https://github.com/kanav99), and [Sam Isaacson](https://github.com/isaacsas).

Here are some possible projects:

- ### Unified Organization Documentation

[SciML](https://sciml.ai/) is the scientific machine learning organization. However, its documentation is spread amongst many different fairly large packages:

- [DifferentialEquations.jl](https://docs.sciml.ai/latest/)
- [DiffEqFlux.jl](https://diffeqflux.sciml.ai/dev/)
- [ModelingToolkit.jl](https://mtk.sciml.ai/dev/)
- [Surrogates.jl](https://surrogates.sciml.ai/latest/)

Just to name a few. One project would be to create a unified scientific machine learning documentation that would make it easy to move between all of these different package docs and understand the cohesive organization.

- ### Tutorial Writing

  The JuliaDiffEq organization hosts the [DiffEqTutorials.jl](https://github.com/SciML/DiffEqTutorials.jl) repository which auto-builds websites and pdfs from tutorials. Tutorials generally center on features of DifferentialEquations.jl or on application domains. Technical writers who have expertise in areas like biological modeling may wish to contribute tutorials that showcase how to use DifferentialEquations.jl to solve problems arising in their discipline.

#### Potential Impact

  Many university classes use the SciML ecosystem for its teaching, and thus classrooms all over the world will be improved. Tutorials that capture more domains will allow professors teaching biological modeling courses to not have to manually rewrite physics-based tutorials to match their curriculum, and conversion of READMEs to documentation will help such professors link to reference portions for these tools in their lecture notes.
  
  Additionally, these benchmarks are a widely referenced cross-language benchmark of differential equations, which gives a standard between Python, R, Julia, MATLAB, and many C++ and Fortran packages. Improving the technical writing around the benchmarks can make this set of documents more widely accessible, and enlarging the scope of topics will help individuals of all programming languages better assess the methods they should be choosing for their problems.


## Flux (Machine Learning)

[Flux.jl](https://github.com/FluxML/Flux.jl) is an elegant approach to machine learning in Julia. It is designed to be hackable and flexible, extendable, and exposes powerful AD tools. It also provides abstractions over the popular layers and optimizers used in neural networks. It is built with differentiable programming in mind. The mentors for this project are [Dhairya Gandhi](https://github.com/DhairyaLGandhi).

- #### Tutorials

  Flux is in dire need of complete tutorials in the [model-zoo](https://github.com/FluxML/model-zoo.git) as well as on the website. We can take inspiration from many existing projects that publish their tutorials, that take a look at common design patterns. This includes writing custom adjoints, new optimizers, transfer learning, and writing performance-sensitive code for many common kinds of networks that many people would be interested in writing.
  This could also include cases that help users write custom loss functions, and even putting Flux models behind a web server.

- ### Updated Documentation and DocTests

  Flux documentation needs a lot of rework since our generic approach to development means there are many general use cases that we support but might be a bit subtle to discover. So in that case, we need to highlight such common cases and make them known in the documentation.
  We would like to use doc tests to also increase our coverage of and documentation of many of the common patterns we see in differentiating Julia code.

#### Potential Impact

  Flux is an innovative approach to machine learning. This also means that not all the same patterns and assumptions truly hold when translating from a different framework. It also needs a way to communicate a compelling description of how to implement many of the user-facing niceties that one might need in the course of completing an ML project. Through this, we want to also find areas of improvement where we could offer a better user experience.

  This would also greatly benefit the adoption of Flux in the larger ML ecosystem, which we feel is currently held back due to not having enough of these simple patterns documented in an approachable form. We want to see an increase in the number of contributors to the various packages too since that would help us improve our stack better. Flux also utilizes simple to understand and performant code, made possible by Julia, and through this, we also want to bring awareness to how our ecosystem has matured, and increase its adoption in research and industry.


## Turing (Probabilistic Machine Learning)

[Turing.jl](https://turing.ml/dev/) is a probabilistic programming language written in Julia. The team is looking for help with several projects. Mentors for this project would be [Cameron Pfiffer](https://github.com/cpfiffer/), [Martin Trapp](https://github.com/trappmartin/), [Kai Xu](https://github.com/xukai92), or [Hong Ge](https://github.com/yebai/).

Here are some ideas:

- A structured explanation of the different inference algorithms provided in Turing with details on when to use each algorithm and what are the implications of each approach. Turing has many sampling algorithms but their value is not fully recognized by inexperienced users -- heuristics on when to use which algorithms would greatly benefit the user experience. Documentation might run speed tests, or measure convergence criteria for different sampler types. One such [blog post](https://dm13450.github.io/2019/04/10/Turing-Sampling-Speed.html) focused mostly on speed, but there are features of different models and data that make some samplers preferable to others.

- An introduction to probabilistic modelling and the Bayesian approach in Turing with a discussion of general Bayesian issues such as the choice of prior. Turing lacks a good resource for those who are just beginning with probabilistic modelling, and users tend to use [Stan's](https://mc-stan.org/docs/2_23/stan-users-guide/index.html) excellent documentation or [Probabilistic Programming & Bayesian Methods for Hackers](https://camdavidsonpilon.github.io/Probabilistic-Programming-and-Bayesian-Methods-for-Hackers/) to learn how to use probabilistic programming. Turing should be self-contained when it comes to grabbing early-phase learners.

- A better tutorial that shows how to integrate [Flux.jl](https://github.com/FluxML/Flux.jl) with Turing. Turing has an [existing tutorial](https://turing.ml/dev/tutorials/3-bayesnn/) that shows how to build a Bayesian neural network with Flux.jl, but this is very much a toy example and does not demonstrate real-world applicability. A guide that shows how to apply Flux and Turing in a useful setting would be valuable for Julia, Turing, and Flux.

- Documentation and manuals for [MCMCChains](https://github.com/TuringLang/MCMCChains.jl), [AdvancedHMC](https://github.com/TuringLang/AdvancedHMC.jl), and [Bijectors](https://github.com/TuringLang/Bijectors.jl). Turing maintains several separate packages, all of which have some documentation, but each of these could be improved dramatically. Technical writers would review current documentation, meet with the development team for each package to determine the package goals, and assess whether current documentation meets those goals. AdvancedHMC, for example, requires a much more detailed guide that explores all of AdvancedHMC's functionality.

#### Potential impact

Turing is a rapidly developing probabilistic programming language, used by machine learning researchers, data scientists, statisticians, and economists. Improving any measure of the informational tools in Turing will allow those communities to integrate better with the Julia community, which will, in turn, improve the rest of Julia's ecosystem. Better documentation and guides will attract new learners and help to transition more experienced people from tools that do not meet their needs.

