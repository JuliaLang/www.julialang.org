
# Turing Projects – Summer of Code

[Turing](https://turing.ml/) is a universal probabilistic programming language embedded in Julia. Turing allows the user to write models in standard Julia syntax, and provide a wide range of sampling-based inference methods for solving problems across probabilistic machine learning, Bayesian statistics and data science etc. Since Turing is implemented in pure Julia code, its compiler and inference methods are amenable to hacking: new model families and inference methods can be easily added. Below is a list of ideas for potential projects, though you are welcome to propose your own to the Turing team.

If you are interested in exploring any of these projects, please reach out to the listed project mentors. You can find their contact information at [turing.ml/team](https://turing.ml/stable/team).

## More real-world Bayesian models in Turing / Julia

**Mentors**: Kai Xu, Tor E. Fjelde, Hong Ge

**Project difficulty**: Medium

**Project length**: 175 hrs or 350 hrs

**Description**: 
There are many real-world Bayesian models out there, 
and they deserve a Turing / Julia implementation.

Examples include but not limited to 
- Forecasting ([Prophet](https://facebook.github.io/prophet/), [datasets](https://github.com/facebook/prophet/tree/main/examples))
- Recommender system ([probabilistic matrix factorisation](http://www.cs.utoronto.ca/~amnih/papers/pmf.pdf), [dataset](https://grouplens.org/datasets/movielens/))
- Ranking ([TrueSkill](https://en.wikipedia.org/wiki/TrueSkill), [dataset](https://github.com/dotnet/mbmlbook/tree/main/src/3.%20Meeting%20Your%20Match/Data))
- Bayesian revenue estimation ([example](https://www.smartly.io/blog/tutorial-how-we-productized-bayesian-revenue-estimation-with-stan))
- Political forecasting model ([example](https://github.com/sjwild/Canandian_Election_2021))
- Topic mining (latent Dirichlet allocation and new variants)
- Multiple Annotators/Combining Unreliable Observations (Dawid and Skene, 1979)

For each model, we consider the following tasks
- Correctness test: correctness of the implementation can be tested by doing inference for prior samples, for which we know the ground truth latent variables.
- Performance benchmark: this includes (i) time per MCMC step and (ii) time per effective sample; if the model is differentiable, a further break-down of (i) into (i.1) time per forward pass and (i.2) time per gradient pass are needed.
- Real-world results: if available, the final step is to apply the model to a real-world dataset; if such an experiment has been done in the literature, consistency of inference results needs to be checked

## Improving the integration between Turing and Turing's MCMC inference packages

**Mentors**: Cameron Pfiffer, Mohamed Tarek, David Widmann

**Project difficulty**: Easy

**Project length**: 175 hrs

**Description**: 
Turing.jl is based on a set of inference packages that maintained by the TuringLang group.
This project is about making use of improvements in DynamicPPL to create a generic integration between Turing.jl and the AbstractMCMC.jl sampling API. The ultimate goal is to remove or substantially reduce algorithm-specific glue code inside Turing.jl. The project would also involve improving data structures for storing model parameters in DynamicPPL.

## Directed-graphical model support for the abstract probabilistic programming library

**Mentors**: Philipp Gabler, Hong Ge

**Project difficulty**: Hard

**Project length**: 350 hrs

**Description**: 
We want to have a very light-weight representation of probabilistic models of static graphs (similar to BUGS), which can serve as a representation target of other front-end DSLs or be dynamically built. The representation should consist of the model and node representations (stochastic and deterministic, perhaps hyperparameters) and conform to the AbstractPPL model interface, with basic functions (evaluation of density, sampling, conditioning; at later stages some static analysis like extraction of Markov blankets). The model should also contain the state of the variables and implement the AbstractPPL trace interface (dictionary functions, querying of variable names). The result should be able to work with existing sampling packages through the abstract interfaces.

## A modular tape caching mechanism for ReverseDiff

**Mentors**: Qingliang Zhuo, Mohamed Tarek

**Project difficulty**: Medium

**Project length**: 175 hrs

**Description**: 
Tape caching often leads to significant performance improvements for gradient-based sampling algorithms (e.g. HMC/NUTS). Tape caching is only possible at the complete computational level for ReverseDiff at the moment. This project is about implementing a more modular, i.e. function-as-a-caching-barrier, tape caching mechanism for ReverseDiff.jl.

## Benchmarking & improving performance of the JuliaGaussianProcesses libraries

**Mentors**: Theo Galy-Fajou, Will Tebbutt, ST John

**Project difficulty**: Medium

**Project length**: 350 hrs

**Description**: 
Although KernelFunctions.jl has extensive correctness testing, our performance testing is lacking. This project aims to resolve this, and resolve performance issues wherever they are found. The student would first need to extend our existing benchmarking coverage, and debug any obvious performance problems. The next phase of the work would be to construct end-to-end examples of KernelFunctions being used in practice, profile them to determine where performance problems lie, and fix them.

## Iterative methods for inference in Gaussian Processes

**Mentors**: Will Tebbutt, S. T. John, Ross Viljoen

**Project difficulty**: Medium

**Project length**: 175 hrs

**Description**: 
There has recently been quite a bit of work on inference methods for GPs that use iterative methods rather than the Cholesky factorisation. They look quite promising, but no one has implemented any of these within the Julia GP ecosystem yet, but they should fit nicely within the AbstractGPs framework. If you're interested in improving the GP ecosystem in Julia, this project might be for you!

## Approximate inference methods for non-Gaussian likelihoods in Gaussian Processes

**Mentors**: S. T. John, Ross Viljoen, Theo Galy-Fajou

**Project difficulty**: Hard

**Project length**: 350 hrs

**Description**:
Adding [approximate inference](https://github.com/JuliaGaussianProcesses/JuliaGaussianProcesses.github.io/discussions/5#discussioncomment-1627101) methods for non-Gaussian likelihoods which are available in other GP packages but not yet within JuliaGPs. The project would start by determining which approximate inference method(s) to implement---there's lots to do, and we're happy to work with a student on whichever method they are most interested in, or to suggest one if they have no strong preference.

## GPU integration in the JuliaGPs ecosystem

**Mentors**: Ross Viljoen, Theo Galy-Fajou, Will Tebbutt

**Project difficulty**: Medium

**Project length**: 350 hrs

**Description**: 
This would involve first ensuring that common models are able to run fully on the GPU, then identifying and improving GPU-specific performance bottlenecks. This would begin by implementing a limited end-to-end example involving a GP with a standard kernel, and profiling it to debug any substantial performance bottlenecks. From there, support for a wider range of the functionality available in KernelFunctions.jl and AbstractGPs.jl can be added. Stretch goal: extension of GPU support to some functionality in ApproximateGPs.jl.