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

Given the large scope and breadth of the SciML Ecosystem, the project will be participating independently from the Julia umbrealla. SciML is also a NumFOCUS sponsored project since 2020 and runs other dev programs seperate from the Julia umbrealla. You can find the [SciML GSoD projects on their website](https://sciml.ai/gsod/).

## Flux (Machine Learning)

The [Flux.jl](https://github.com/FluxML/Flux.jl) project will be applying seperatly from the Julia umbrealla since Flux is now a NumFOCUS affiliated project. You can find the [GSoD projects proposed for Flux on their wesbite](https://fluxml.ai/gsod.html).

## Turing (probabilistic machine learning)

[Turing.jl](https://turing.ml/dev/) is a probabilistic programming language written in Julia. The team is looking for help with documentation and tutorials for several projects. Mentors for this project would be [Cameron Pfiffer](https://github.com/cpfiffer/), [Martin Trapp](https://github.com/trappmartin/), [Kai Xu](https://github.com/xukai92), or [Hong Ge](https://github.com/yebai/).

Some ideas include:

- Documentation and manuals for [MCMCChains](https://github.com/TuringLang/MCMCChains.jl), [AdvancedHMC](https://github.com/TuringLang/AdvancedHMC.jl), and [Bijectors](https://github.com/TuringLang/Bijectors.jl). Turing maintains several separate packages, all of which have some documentation, but each of these could be improved dramatically with a dedicated documentation website and better coverage of docstrings. Technical writers would review current documentation, meet with the development team for each package to determine the package goals, and assess whether current documentation meets those goals. AdvancedHMC, for example, requires a much more detailed guide that explores all of AdvancedHMC's functionality.

- A more comprehensive tutorial that sow how to use Turing.jl with [DifferenceEquations.jl](https://github.com/SciML/DifferenceEquations.jl). Turing has an [existing tutorial](https://turing.ml/dev/tutorials/10-bayesian-differential-equations/) that demonstrates how to perform Bayesian parameter estimation for the Lotka-Volterra model with DifferenceEquations.jl, but this is very much a toy example and does not demonstrate real-world applicability. A guide that shows how to apply Turing and Flux in a useful setting would be valuable for Julia, Turing, and Flux.

- A more comprehensive tutorial that shows how to use Turing with [Flux.jl](https://github.com/FluxML/Flux.jl). Turing has an [existing tutorial](https://turing.ml/dev/tutorials/3-bayesnn/) that demonstrates how to build a Bayesian neural network with Flux.jl, but this is very much a toy example and does not demonstrate real-world applicability. A guide that shows how to apply Turing and Flux in a useful setting would be valuable for Julia, Turing, and Flux. One possibility is to reproduce some results from [Radford Neal's PhD thesis](https://www.cs.toronto.edu/~radford/ftp/thesis.pdf).

- Polishing other existing Turing tutorials. Turing currently has more than 10 tutorials at https://turing.ml/dev/tutorials/ and most of them were written in early days of Turing.jl. Some of them requires an update to the latest syntax and most of them would benefit from a general writing improvement.

- A structured explanation of the different inference algorithms provided in Turing with details on when to use each algorithm and what are the implications of each approach. Turing has many sampling algorithms, but their value is not fully recognized by inexperienced users -- heuristics on when to use which algorithms would greatly benefit the user experience. Documentation might run speed tests, or measure convergence criteria for different sampler types. One such [blog post](https://dm13450.github.io/2019/04/10/Turing-Sampling-Speed.html) focused mostly on speed, but there are features of different models and data that make some samplers preferable to others.

- An introduction to probabilistic modelling and the Bayesian approach in Turing with a discussion of general Bayesian issues such as the choice of prior. Turing lacks a good resource for those who are just beginning with probabilistic modelling, and users tend to use [Stan's](https://mc-stan.org/docs/2_23/stan-users-guide/index.html) excellent documentation or [Probabilistic Programming & Bayesian Methods for Hackers](https://camdavidsonpilon.github.io/Probabilistic-Programming-and-Bayesian-Methods-for-Hackers/) to learn how to use probabilistic programming. Turing should be self-contained when it comes to grabbing early-phase learners.

#### Potential impact

Turing is a rapidly developing probabilistic programming language, used by machine learning researchers, data scientists, statisticians, and economists. Improving any measure of the informational tools in Turing will allow those communities to integrate better with the Julia community, which will, in turn, improve the rest of Julia's ecosystem. Better documentation and guides will attract new learners and help to transition more experienced people from tools that do not meet their needs.


## MLJ (multi-paradigm machine learning)

[MLJ](https://alan-turing-institute.github.io/MLJ.jl/dev/) (Machine
Learning in Julia) is the most popular multi-paradigm machine learning
toolbox written in the Julia language. It provides a common interface
and meta-algorithms for selecting, tuning, evaluating, composing and
almost 200 machine learning models written in Julia and other
languages. Such models include neural networks (based on the popular
[Flux.jl](https://fluxml.ai/Flux.jl/stable/) package) tree-based
models (such as random forests) support vector machines, nearest
neighbor models, outlier detection models, general linear models,
clustering algorithms (such as K-means), and more.  In particular MLJ
wraps a large number of models from the python toolbox
[scikit-learn](https://scikit-learn.org/stable/).


While the the MLJ ecosystem is spread over some [two dozen
repositories](https://github.com/JuliaAI) the reference documentation
is mostly collected in a [single
manual](https://alan-turing-institute.github.io/MLJ.jl/dev/). Additional
learning resources, which include a dedicated [tutorial
site](https://juliaai.github.io/DataScienceTutorials.jl/), are listed
[here](https://github.com/alan-turing-institute/MLJ.jl/blob/more-doc-updates/docs/src/learning_mlj.md).

The reference manual is comprehensive from the point-of-view of what
you can *do* with models (train, tune, evaluated, combined, etc) but
has no model-specific documentation at all. Only some models have
document strings, but these usually lack detail or examples, and do
not conform to any standard.


The present project can be divided
into two parts:

### 1. Model documentation

Create a detailed document string for each model in MLJ's model
registry, as outlined in [this github
issue](https://github.com/alan-turing-institute/MLJ.jl/issues/913), or
at least the most popular models.  A key part of each document string
is **a short example illustrating basic usage**. Most models are provided
by third party packages, which generally have their own documentation,
so this is often a simple matter of adapting existing documentation to
MLJ syntax. 

The models wrapped from sckit-learn (about 70) constitute a separate
case, as the available documentation is in python and not
Julia. Initially, docstrings for these models will simply quote the
python documentation. However, generating these [may
require](https://github.com/JuliaAI/MLJScikitLearnInterface.jl/issues/37)
some coding (e.g., Julia macros, artifacts) and so is optional for
this project.


### 2. Integration of model documentation into the reference manual

Models can be loosely grouped into families (regressors, classifiers,
clustering algorithms, etc) and integrating the new document strings
into the reference manual could fit into such an organization -
something resembling the model documentation in
[scikit-learn](https://scikit-learn.org/stable/).


#### Requisite knowledge

Writers will need some familiarity with basic machine learning
workflows, and very basic Julia, but will also have the opportunity to
develop both.


#### Potential Impact

Julia is perceived as a potential game-changer for machine learning.
Current practice is dominated by platforms in python and R, but there
innovation is increasingly stifled by the [two language
problem](https://www.nature.com/articles/d41586-019-02310-3) solved by
Julia. Good documentation is essential both to ensure MLJ.jl is an
attractive option to practicing data scientists, and to those training
new data scientists. 

## [Plots](https://github.com/JuliaPlots/Plots.jl)

Plots.jl is a unified API for several plotting libraries popular for its composable recipe system.

### Projects

#### Add demos to the user gallery with a focus on aesthetics

Plots.jl had for long time a list of examples demonstrating basic functionality.
Recently, a user gallery was added that should show particular good looking demos (chloropleths, gradients, animations, ... ) using DemoCards.jl.
Interested writers would add new examples potentially taking inspiration from other existing galleries.

### Requisite knowledge

Writers will need some experience in producing visualisations and have a good sense for aesthetics.

### Mentors

 - [@BeastyBlacksmith](https://github.com/BeastyBlacksmith)
 - [@johnnychen94](https://github.com/johnnychen94)
