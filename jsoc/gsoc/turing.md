
# Turing Projects – Summer of Code

[Turing](https://turing.ml/) is a universal probabilistic programming language embedded in Julia. Turing allows the user to write models in standard Julia syntax, and provide a wide range of sampling-based inference methods for solving problems across probabilistic machine learning, Bayesian statistics and data science etc. Since Turing is implemented in pure Julia code, its compiler and inference methods are amenable to hacking: new model families and inference methods can be easily added. Below is a list of ideas for potential projects, though you are welcome to propose your own to the Turing team.

Project mentors are [Hong Ge](https://github.com/yebai), [Cameron Pfiffer](https://github.com/cpfiffer), [Martin Trapp](https://github.com/trappmartin), [Will Tebbutt](https://github.com/willtebbutt), [Mohamed Tarek](https://github.com/mohamed82008) and [Kai Xu](https://github.com/xukai92).

## Benchmarking

Turing's performance has been sporadically benchmarked against various other probabilistic programming languages (e.g. Turing, Stan, PyMC3, TensorFlow Prob), but a systemic approach to studying where Turing excels and where it falls short would be useful. A GSoC student would implement identical models in many PPLs and build tools to benchmark all PPLs against one another.

**Recommended skills:** An interest in Julia and Turing, as well as experience or desire to learn about various other PPLs. Some experience with automated tasks is useful, but not necessary at the outset.

**Expected output:** A suite of auto-updating benchmarks that track Turing's performance on models implemented in various languages.

## Nested sampling integration

Turing focuses on modularity in inference methods, and the development team would like to see more inference methods, particularly the popular nested sampling method. A Julia package ([NestedSamplers.jl](https://github.com/mileslucas/NestedSamplers.jl)) but it is not hooked up to Turing and does not currently have a stable API. A GSoC student would either integrate that package or construct their own nested sampling method and build it into Turing.

**Recommended skills:** Understanding of inference methods and general probability theory. Nested sampler knowledge useful but not required.

**Expected output:** A nested sampler that can be used with Turing models.

## Automated function memoization by model annotation

Function memoization is a way to reduce costly function evaluation by caching the output when the same inputs are given. Turing's Gibbs sampler often ends up [rerunning expensive functions](https://turing.ml/dev/docs/using-turing/performancetips#reuse-computations-in-gibbs-sampling) multiple times, and it would be a significant performance improvement to allow Turing's model compiler to automatically memoize functions where appropriate. A student working on this project would become intimately familiar with Turing's model compiler and build in various automated improvements.

**Recommended skills:** General programming skills, hopefully with an understanding of what makes code perform efficiently.

**Expected output:** Additions to the Turing compiler that automatically memoize functions where appropriate.

## Making Distributions GPU compatible
Julia's GPU tooling is generally quite good, but currently Turing is not able to reliably use GPUs while sampling because [Distributions.jl](https://github.com/JuliaStats/Distributions.jl) is not GPU compatible. A student on this project would work with the Turing developers and the Distributions developers to allow the use of GPU parallelism where possible in Turing.

**Recommended skills:** GPU computing. Understanding of various statistical distributions is useful but not required.

**Expected output:** A set of Distributions.jl objects where `logpdf` calls can be easily run through a GPU.

## GPnet extensions
One of Turing's satellite packages, [GPnet](https://github.com/TuringLang/GPnet.jl), is designed to provide a comprehensive suite of Gaussian process tools. See [this issue](https://github.com/TuringLang/GPnet.jl/issues/2) for potential tasks -- there's a lot of interesting stuff going on with GPs, and this task in particular may have some creative freedom to it.

**Recommended skills:** Gaussian processes. Some Python required, as GPnet uses PyCall.

**Expected output:** Improved GP support. The output is variable depending on the student.

## Model comparison tools

Turing and its satellite packages do not currently provide a comprehensive suite of model comparison tools, a critical tool for the applied statistician. A student who worked on this project would implement various model comparison tools like [LOO and WAIC](https://mc-stan.org/loo/), among others.

**Recommended skills:** General statistics. Bayesian inference and model comparison. Some Julia programming.

**Expected output:** An easy-to-use set of model comparison tools that allows Turing users to effortlessly compare multiple models on a variety of metrics.

## MLE/MAP tools

[Maximum likelihood estimates](https://en.wikipedia.org/wiki/Maximum_likelihood_estimation) (MLE) and [maximum a posteriori](https://en.wikipedia.org/wiki/Maximum_a_posteriori_estimation) (MAP) estimates can currently only be done by users through a [clunky set of workarounds](https://turing.ml/dev/docs/using-turing/advanced#maximum-a-posteriori-estimation). A streamlined function like `mle(model)` or `map(model)` would be very useful for many of Turing's users who want to see what the MLE or MAP estimates look like, and it may be valuable to allow for functionality that allows MCMC sampling to begin from the MLE or MAP estimates. Students working on this project will work with optimization packages such as [Optim.jl](https://github.com/JuliaNLSolvers/Optim.jl) to make MLE and MAP estimation straightforward for Turing models.

**Recommended skills:** Optimization, familiarity with maximum likelihood or MAP.

**Expected output:** `map` and `mle` (names pending) functions for Turing that yield maximum likelihood and maximum a posteriori estimates of a model, and potentially statistics about the estimate such as the standard errors.

## Static distributions

Small, fixed-size vectors and matrices are fairly common in Turing models. This means that sampling in Turing can probably benefit from using statically sized vectors and matrices from StaticArrays.jl instead of normal, dynamic Julia arrays. Beside the often superior performance of small static vectors and matrices, static arrays are also automatically compatible with the GPU stack in Julia. Currently, the main obstacle to using StaticArrays.jl is that distributions in Distributions.jl are not compatible with StaticArrays. A GSoC student would adapt the multivariate and matrix-variate distributions as well as the univariate distribution with vector parameters in Distributions.jl to make a spin-off package called StaticDistributions.jl. The student would then benchmark StaticDistributions.jl against Distributions.jl and showcase an example of using StaticDistributions.jl together with CuArrays.jl and/or CUDAnative.jl for GPU-acceleration.

**Recommended skills:** An understanding of generated functions in Julia. Some knowledge of random number generators and probability distributions. An interest in performance optimization and micro-optimization as well as general-purpose GPU programming.

**Expected output:** A package StaticDistributions.jl containing implementations of non-allocating multivariate and matrix-variate distributions with vectorized logpdf support, a benchmarking of StaticDistributions.jl against Distributions.jl, and tutorials on how to use StaticDistributions together with CuArrays and the Julia GPU stack.

