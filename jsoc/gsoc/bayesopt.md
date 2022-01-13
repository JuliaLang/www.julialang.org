# BayesianOptimization

Bayesian optimization is a global optimization strategy for (potentially noisy) functions with unknown derivatives.
With well-chosen priors, it can find optima with fewer function evaluations than alternatives, making it well suited for the optimization of costly objective functions.
Well known examples include hyper-parameter tuning of machine learning models (see e.g. [Taking the Human Out of the Loop: A Review of Bayesian Optimization](https://www.cs.ox.ac.uk/people/nando.defreitas/publications/BayesOptLoop.pdf)).
The Julia package [BayesianOptimization.jl](https://github.com/jbrea/BayesianOptimization.jl) currently supports only basic Bayesian optimization methods.
There are multiple directions to improve the package, including (but not limited to)

- **Hybrid Bayesian Optimization (duration: 175h, expected difficulty: medium)** with discrete and continuous variables. Implement e.g. [HyBO](https://arxiv.org/abs/2106.04682v1) see also [here](https://github.com/jbrea/BayesianOptimization.jl/issues/26).
- **Scalable Bayesian Optimization (duration: 175h, expected difficulty: medium)**: implement e.g. [TuRBO](https://proceedings.neurips.cc/paper/2019/hash/6c990b7aca7bc7058f5e98ea909e924b-Abstract.html) or [SCBO](http://proceedings.mlr.press/v130/eriksson21a.html).
- **Better Defaults (duration: 175h, expected difficulty: easy)**: write an extensive test suite and implement better defaults; draw inspiration from e.g. [dragonfly](https://github.com/dragonfly/dragonfly).

**Recommended Skills:** Familiarity with Bayesian inference, non-linear optimization, writing Julia code and reading Python code.
**Expected Outcome:** Well-tested and well-documented new features.
**Mentor:** [Johanni Brea](https://github.com/jbrea)
