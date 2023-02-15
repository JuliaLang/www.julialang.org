# Turing Projects - Summer of Code

[Turing](https://turing.ml/) is a universal probabilistic programming language embedded in Julia. Turing allows the user to write models in standard Julia syntax, and provide a wide range of sampling-based inference methods for solving problems across probabilistic machine learning, Bayesian statistics and data science etc. Since Turing is implemented in pure Julia code, its compiler and inference methods are amenable to hacking: new model families and inference methods can be easily added. Below is a list of ideas for potential projects, though you are welcome to propose your own to the Turing team.

If you are interested in exploring any of these projects, please reach out to the listed project mentors or Tor Fjelde (at tef30[at]cam.ac.uk). You can find their contact information at [turing.ml/team](https://turing.ml/stable/team).

## Implementing models from PosteriorDB in Turing / Julia

**Mentors:** Seth Axen, Tor Fjelde, Kai Xu, Hong Ge

**Project difficulty:** Medium

**Project length:** 175 hrs or 350 hrs

**Description:**
[posteriordb](https://github.com/stan-dev/posteriordb) is a database of 120 diverse Bayesian models implemented in Stan (with 1 example model in PyMC) with reference posterior draws, data, and metadata. For performance comparison and for showcasing best practices in Turing, it is useful to have Turing implementations of these models. The goal of this project is to implement a large subset of these models in Turing/Julia.

For each model, we consider the following tasks:
Correctness test: when reference posterior draws and sampler configuration are available in posteriordb, correctness of the implementation and consistency can be tested by sampling the model with the same configuration and comparing the samples to the reference draws.
Best practices: all models must be checked to be differentiable with all Turing-supported AD frameworks.

## Improving the integration between Turing and Turing’s MCMC inference packages

**Mentors:** Tor Fjelde, Cameron Pfiffer, David Widmann

**Project difficulty:** Easy

**Project length:** 175 hrs

**Description:**
Most samplers in Turing.jl implements the AbstractMCMC.jl interface, allowing a unified way for the user to interact with the samplers.
The interface of AbstractMCMC.jl is currently very bare-bones and does not lend itself nicely to interoperability between samplers.

For example, it’s completely valid to compose to MCMC kernels, e.g. taking one step using the RWMH from AdvancedMH.jl, followed by taking one step using NUTS from AdvancedHMC.jl. 
Unfortunately, implementing such a composition requires explicitly defining conversions between the state returned from RWMH and the state returned from NUTS, and conversion of state from NUTS to state of RWMH.
Doing this for one such sampler-pair is generally very easy to do, but once you have to do this for N samplers, suddenly the amount of work needed to be done becomes insurmountable.

One way to deal alleviate this issue would be to add a simple interface for interacting with the states of the samplers, e.g. a method for getting the current values in the state, a method for setting the current values in the state, in addition to a set of glue-methods which can be overriden in the specific case where more information can be shared between the states. 

As an example of some ongoing work that attempts to take a step in this direction is: https://github.com/TuringLang/AbstractMCMC.jl/pull/86

Even if this PR makes it in before the project start, it’s going to take additional work to
Propagate these changes to the downstream packages, i.e. implementing all these functions.
Determine if the current approach is the really the way to go, or if we need to change or just add more features.

## A modular tape caching mechanism for ReverseDiff

**Mentors:** Tor Fjelde, Xianda Sun, David Widmann, Qingliang Zhuo, Hong Ge

**Project difficulty:** Hard

**Project length:** 175 hrs

**Description:**
Tape caching often leads to significant performance improvements for gradient-based sampling algorithms (e.g. HMC/NUTS). Tape caching is only possible at the complete computational level for ReverseDiff at the moment. This project is about implementing a more modular, i.e. function-as-a-caching-barrier, tape caching mechanism for ReverseDiff.jl.

## GPU support in Turing

**Mentors:** Tor Fjelde, Xianda Sun, Kai Xu, Hong Ge

**Project difficulty:** Hard

**Project length:** 175 hrs or 350 hrs

**Description:**
GPU support in Turing is not quite there yet for several reasons:

Bijectors.jl, the package which provides transformations of distributions to Turing.jl, is not fully compatible with GPU. For example, many of the transformations make use of scalar indexing which is slow on GPU.
DynamicPPL.jl, the package providing the DSL of Turing.jl, is not compatible with GPU. Again, a lot of scalar indexing is used, and likely some internal functions are simply just incompatible with GPU usage at the moment.
Others?

There might also be other issues along the way, making Turing.jl fully support GPU usage within the span of the project is very unlikely, but taking a significant step in this direction should be possible and will be very useful.

## Variational Inference

**Mentors:** Tor Fjelde, Xianda Sun, Kai Xu, Hong Ge

**Project difficulty:** Medium

**Project length:** 350 hrs

**Description:**
The variational inference functionality of Turing.jl was at some point moved into AdvancedVI.jl, but after this move the package has received very little love.

As of right now, the package only supports ADVI and the interface needs to be generalized to support more types of models and variational inference algorithms in an efficient way.

In addition, implementing more recent advanced in variational inference is also included in the project.

## Batched support in Turing.jl

**Mentors:** Tor Fjelde, David Widmann, Hong Ge

**Project difficulty:** Medium

**Project length:** 350 hrs

**Description:**
At the moment there is currently no support for running a Turing model in a “batched” mode.

When one wants to run, say, 2 chains in parallel for a given model, the current approach is to in effect to call `sample(model, ...)` twice.
Of course, one can parallelize these sample calls across multiple cores, etc. and this is already supported in Turing.jl.

What is not yet supported, is to, say, run 2 chains at the same time taking by “stacking” the parameters into a higher-dimensional array, e.g. if the parameters θ is a Vector of values, then we can stack them into a Matrix of size length(θ) × 2 and then execute the model on this instead.

It can effectively be boiled down to adding support for calling logdensity(model, θ_batch) with θ_batch being of size d × N and having the result be a vector of length `N*. Once we have this, a sampler with batched-mode can work nicely with a Turing.jl model.

This will require:
Making changes internally to DynamicPPL.jl, the DSL of Turing.jl, to allow batching.
Implement a way to indicate to the code that “Hey, this input should be treated as a batch, not a single input!*. One approach to this might be an independent package which implements a wrapper type Batch or something, which is simply unwrapped at the stages where appropriate, but this needs to be further discussed.

## Approximate inference methods for non-Gaussian likelihoods in Gaussian Processes

**Mentors:** S. T. John, Ross Viljoen

**Project difficulty:** Medium

**Project length:** 350 hrs

**Description:**
Adding [approximate inference](https://github.com/JuliaGaussianProcesses/JuliaGaussianProcesses.github.io/discussions/5#discussioncomment-1627101) methods for non-Gaussian likelihoods which are available in other GP packages but not yet within JuliaGPs. The project would start by determining which approximate inference method(s) to implement - there’s lots to do, and we’re happy to work with a contributor on whichever method they are most interested in, or to suggest one if they have no strong preference.

## GPU integration in the JuliaGPs ecosystem

**Mentors:** Ross Viljoen, S. T. John

**Project difficulty:** Medium

**Project length:** 350 hrs

**Description:**
This would involve first ensuring that common models are able to run fully on the GPU, then identifying and improving GPU-specific performance bottlenecks. This would begin by implementing a limited end-to-end example involving a GP with a standard kernel, and profiling it to debug any substantial performance bottlenecks. From there, support for a wider range of the functionality available in KernelFunctions.jl and AbstractGPs.jl can be added. Stretch goal: extension of GPU support to some functionality in ApproximateGPs.jl.
