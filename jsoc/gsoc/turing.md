
# Turing Projects – Summer of Code

[Turing](https://turing.ml/) is a universal probabilistic programming language embedded in Julia. Turing allows the user to write models in standard Julia syntax, and provide a wide range of sampling-based inference methods for solving problems across probabilistic machine learning, Bayesian statistics and data science etc. Since Turing is implemented in pure Julia code, its compiler and inference methods are amenable to hacking: new model families and inference methods can be easily added. Below is a list of ideas for potential projects, though you are welcome to propose your own to the Turing team.

If you are interested in exploring any of these projects, please reach out to the listed project mentors. You can find their contact information at [turing.ml/team](https://turing.ml/stable/team).

## MCMCChains improvements

**Mentors**: Cameron Pfiffer, Hong Ge

**Project difficulty**: Easy

**Description**: MCMCChains is a key component of the Turing.jl ecosystem. It is the package that determines how to analyze and store MCMC samples provided by packages like Turing. It's also used outside of Turing.

For this project, a student might improve the performance of the various statistical functions provided by MCMCChains, changing the back end to use a data storage format that maintains the shape of parameter samples, or improve the general plotting functionality of the package.

There's lots of fun little things to do for MCMCChains. Check out this [meta-issue](https://github.com/TuringLang/MCMCChains.jl/issues/246) for more details and dicussions.

## Particle filtering methods

**Mentors**: Hong Ge, Cameron Pfiffer

**Project difficulty**: Medium

**Description**: Turing's support for particle sampling methods is slowing being improved with the addition of [AdvancedPS.jl](https://github.com/TuringLang/AdvancedPS.jl). If you're interested in implementing or improving particle sampling methods, this is a great project for you!


## Nested Sampling

**Mentors**: Miles Lucas, Cameron Pfiffer, Hong Ge

**Project difficulty**: Hard

**Description**: [NestedSamplers.jl](https://github.com/TuringLang/NestedSamplers.jl) is an excellent package which implements nested sampling methods. As of yet, it is not connected to Turing.jl. For this project, a student would connect the NestedSamplers.jl library to Turing.jl.

## GPU acceleration

**Mentors**: Mohamed Tarek, Hong Ge, Kai Xu, Tor Fjelde

**Project difficulty**: Medium

**Description**: Turing's native GPU support is limited in that the Metropolis-Hastings and HMC samplers do not implement GPU sampling methods. This can and should be done -- GPU methods are awesome! If you are interested with working on parallelism and GPUs, this project is for you.

Students will work with the code at [AdvancedMH](https://github.com/TuringLang/AdvancedMH.jl) or [AdvancedHMC](https://github.com/TuringLang/AdvancedHMC.jl), depending on their interests.

## Documentation and tutorial improvements

**Mentors**: Cameron Pfiffer, Martin Trapp

**Project difficulty**: Easy

**Description**: Turing's documentation and tutorials need a bit of an overhaul. Turing has changed significantly since the last time the documentation was written, and it's beginning to show. Students would use their knowledge of probabilistic programming languages and Turing to shore-up or rewrite documentation and tutorials.

## Iterative Methods for Inference in Gaussian Processes

**Mentors**: Will Tebbutt, S. T. John, Theo Galy-Fajou

**Project difficulty**: Medium

**Description**: There has recently been quite a bit of work on inference methods for GPs that use iterative methods rather than the Cholesky factorisation. They look quite promising, but no one has implemented any of these within the Julia GP ecosystem yet, but they should fit nicely within the AbstractGPs framework. If you're interested in improving the GP ecosystem in Julia, this project might be for you!

## Implement advanced variational Gaussian process models

**Mentors**: ST John, Will Tebbutt, Theo Galy-Fajou

**Project difficulty**: Easy to Medium

**Description**:  Sparse variational Gaussian process models provide the flexibility to scale to large datasets, handle arbitrary (non-conjugate) likelihoods, and to be used as building blocks for composite models such as deep GPs. This project is about making such models more readily available within the Julia GP ecosystem - depending on your interests you can focus on making it easier for end users and providing good tutorials, or on the implementations of these models to give us the same or better performance as with established Python packages such as GPflow, integrating with Flux.jl, etc.
