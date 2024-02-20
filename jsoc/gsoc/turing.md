# Turing Projects - Summer of Code

[Turing](https://turinglang.org/) is a universal probabilistic programming language embedded in Julia.
Turing allows the user to write models in standard Julia syntax, and provide a wide range of sampling-based inference methods for solving problems across probabilistic machine learning, Bayesian statistics and data science etc.
Since Turing is implemented in pure Julia code, its compiler and inference methods are amenable to hacking: new model families and inference methods can be easily added.

Below is a list of ideas for potential projects, though you are welcome to propose your own to the Turing team.
If you are interested in exploring any of these projects, please reach out to the listed project mentors or Xianda Sun (at xs307[at]cam.ac.uk). You can find their contact information [here](https://turinglang.org/stable/team).

## Implementing models from PosteriorDB in Turing / Julia

**Mentors:** Seth Axen, Tor Fjelde, Kai Xu, Hong Ge

**Project difficulty:** Medium

**Project length:** 175 hrs or 350 hrs

**Description:**
[posteriordb](https://github.com/stan-dev/posteriordb) is a database of 120 diverse Bayesian models implemented in Stan (with 1 example model in PyMC) with reference posterior draws, data, and metadata.
For performance comparison and for showcasing best practices in Turing, it is useful to have Turing implementations of these models.
The goal of this project is to implement a large subset of these models in Turing/Julia.

For each model, we consider the following tasks:
Correctness test: when reference posterior draws and sampler configuration are available in posteriordb, correctness of the implementation and consistency can be tested by sampling the model with the same configuration and comparing the samples to the reference draws.
Best practices: all models must be checked to be differentiable with all Turing-supported AD frameworks.

## Improving the integration between Turing and Turing’s MCMC inference packages

**Mentors:** Tor Fjelde, Jaime Ruiz Zapatero, Cameron Pfiffer, David Widmann

**Project difficulty:** Easy

**Project length:** 175 hrs

**Description:**
Most samplers in Turing.jl implements the AbstractMCMC.jl interface, allowing a unified way for the user to interact with the samplers.
The interface of AbstractMCMC.jl is currently very bare-bones and does not lend itself nicely to interoperability between samplers.

For example, it’s completely valid to compose to MCMC kernels, e.g. taking one step using the RWMH from AdvancedMH.jl, followed by taking one step using NUTS from AdvancedHMC.jl.
Unfortunately, implementing such a composition requires explicitly defining conversions between the state returned from RWMH and the state returned from NUTS, and conversion of state from NUTS to state of RWMH.
Doing this for one such sampler-pair is generally very easy to do, but once you have to do this for N samplers, suddenly the amount of work needed to be done becomes insurmountable.

One way to deal alleviate this issue would be to add a simple interface for interacting with the states of the samplers, e.g. a method for getting the current values in the state, a method for setting the current values in the state, in addition to a set of glue-methods which can be overridden in the specific case where more information can be shared between the states.

As an example of some ongoing work that attempts to take a step in this direction is: <https://github.com/TuringLang/AbstractMCMC.jl/pull/86>

## GPU support for NormalizingFlows.jl and Bijectors.jl

**Mentors:** Tor Fjelde, Xianda Sun, Kai Xu, Hong Ge

**Project difficulty:** Hard

**Project length:** 175 hrs or 350 hrs

**Description:**
Bijectors.jl, a package that facilitates transformations of distributions within Turing.jl, currently lacks full GPU compatibility.
This limitation stems partly from the implementation details of certain bijectors and also from how some distributions are implemented in the Distributions.jl package.
NormalizingFlows.jl, a newer addition to the Turing.jl ecosystem built atop Bijectors.jl, offers a user-friendly interface and utility functions for training normalizing flows but shares the same GPU compatibility issues.

The aim of this project is to enhance GPU support for both Bijectors.jl and NormalizingFlows.jl.

## Batched support for NormalizingFlows.jl and Bijectors.jl

**Mentors:** Tor Fjelde, Xianda Sun, David Widmann, Hong Ge

**Project difficulty:** Medium

**Project length:** 350 hrs

**Description:**
At the moment there is currently no support for running a Turing model in a “batched” mode.

When one wants to run, say, 2 chains in parallel for a given model, the current approach is to in effect to call `sample(model, ...)` twice.
Of course, one can parallelize these sample calls across multiple cores, etc. and this is already supported in Turing.jl.

What is not yet supported, is to, say, run 2 chains at the same time taking by “stacking” the parameters into a higher-dimensional array, e.g. if the parameters θ is a Vector of values, then we can stack them into a Matrix of size length(θ) × 2 and then execute the model on this instead.

Turing.jl supports general Julia code, which might make universal batch support challenging. However, it's feasible to implement batch support for a significant number of models, or we can at least bring batch support to packages like NormalizingFlows.jl and Bijectors.jl.

The project will likely involve:
Making changes internally to DynamicPPL.jl, the DSL of Turing.jl, to allow batching.
Develop a mechanism that signals the code to process the given input as a batch rather than an individual entry. A preliminary implementation can be found [here](https://github.com/torfjelde/Batching.jl).  
Implementing batch support for Bijectors.jl and NormalizingFlows.jl may involve similar thinking as the above GPU support project.
