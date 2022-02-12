
# Scientific Machine Learning (SciML) Projects

These projects are hosted by the [SciML Open Source Scientific Machine Learning Software Organzation](https://sciml.ai/).

### Physics-Informed Neural Networks (PINNs) and Solving Differential Equations with Deep Learning

Neural networks can be used as a method for efficiently solving difficult partial
differential equations. Recently this strategy has been dubbed [physics-informed neural networks](https://www.sciencedirect.com/science/article/pii/S0021999118307125)
and has seen a resurgence because of its efficiency advantages over classical
deep learning. Efficient implementations from recent papers are being
explored as part of the [NeuralNetDiffEq.jl](https://github.com/SciML/NeuralNetDiffEq.jl)
package. The [issue tracker](https://github.com/SciML/NeuralNetDiffEq.jl/issues)
contains links to papers which would be interesting new neural network based methods to
implement and benchmark against classical techniques. Project work in this area
includes:

- [Improved training strategies](https://github.com/SciML/NeuralNetDiffEq.jl/issues/71) for PINNs.
- Implementing new neural architectures that impose physical constraints like [divergence-free criteria](https://arxiv.org/pdf/2002.00021.pdf).
- Demonstrating large-scale problems solved by PINN training.
- Improving the speed and parallelization of PINN training routines.

This project is good for both software engineers interested in the field of
scientific machine learning and those students who are interested in perusing
graduate research in the field.

**Recommended Skills**: Background knowledge in numerical analysis and machine learning.

**Expected Results**: New neural network based solver methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

### Improvements to Neural and Universal Differential Equations

[Neural ordinary differential equations](https://arxiv.org/abs/1806.07366) have
been shown to be a way to use machine learning to learn differential equation
models. Further improvements to the methodology, like
[universal differential equations](https://arxiv.org/abs/2001.04385) have incorporated
physical and biological knowledge into the system in order to make it a data and
compute efficient learning method. However, there are many computational aspects
left to explore. The purpose of this project is to enhance the universal
differential equation approximation abilities of [DiffEqFlux.jl](https://github.com/SciML/DiffEqFlux.jl),
adding features like:

- Improved adjoints for DAEs and SDEs
- [Non-neural network universal approximators](https://github.com/SciML/DiffEqFlux.jl/issues/173)
- Various [improvements to](https://github.com/SciML/DiffEqFlux.jl/issues/133) [minibatching](https://github.com/SciML/DiffEqFlux.jl/issues/118)
- Support for [second order ODEs (i.e. symplectic integrators)](https://github.com/SciML/DiffEqFlux.jl/issues/48)
- [Continuous normalizing flows](https://github.com/SciML/DiffEqFlux.jl/issues/46) and [FFJORD](https://github.com/SciML/DiffEqFlux.jl/issues/47)

See the [DiffEqFlux.jl issue tracker](https://github.com/SciML/DiffEqFlux.jl/issues)
for full details.

This project is good for both software engineers interested in the field of
scientific machine learning and those students who are interested in perusing
graduate research in the field.

**Recommended Skills**: Background knowledge in numerical analysis and machine learning.

**Expected Results**: New and improved methods for neural and universal
differential equations.

### Accelerating optimization via machine learning with surrogate models

In many cases, when attempting to optimize a function `f(p)` each calculation
of `f` is very expensive. For example, evaluating `f` may require solving a
PDE or other applications of complex linear algebra. Thus, instead of always
directly evaluating `f`, one can develop a surrogate model `g` which is
approximately `f` by training on previous data collected from `f` evaluations.
This technique of using a trained surrogate in place of the real function
is called surrogate optimization and mixes techniques from machine learning
to accelerate optimization.

Advanced techniques [utilize radial basis functions](https://www.cambridge.org/core/journals/acta-numerica/article/kernel-techniques-from-machine-learning-to-meshless-methods/00686923110F799A1537C4F02BBAAE8E) and Gaussian
processes in order to interpolate to new parameters to estimate `f` in areas
which have not been sampled. [Adaptive training techniques](http%3A%2F%2Fwww.ressources-actuarielles.net%2FEXT%2FISFA%2F1226.nsf%2F9c8e3fd4d8874d60c1257052003eced6%2Fe7dc33e4da12c5a9c12576d8002e442b%2F%24FILE%2FJones01.pdf) explore how to pick new areas
to evaluate `f` to better hone in on global optima. The purpose of this project
is to explore these techniques and build a package which performs surrogate
optimizations.

**Recommended Skills**: Background knowledge of standard machine learning,
statistical, or optimization techniques. Strong knowledge of numerical analysis
is helpful but not required.

**Expected Results**: Library functions for performing surrogate optimization
with tests on differential equation models.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas), [Francesco Martinuzzi](https://github.com/MartinuzziFrancesco)

### Parameter estimation for nonlinear dynamical models

Machine learning has become a popular tool for understanding data, but scientists
typically understand the world through the lens of physical laws and their
resulting dynamical models. These models are generally differential equations
given by physical first principles, where the constants in the equations such
as chemical reaction rates and planetary masses determine the overall dynamics.
The inverse problem to simulation, known as parameter estimation, is the process
of utilizing data to determine these model parameters.

The purpose of this project is to utilize the growing array of statistical,
optimization, and machine learning tools in the Julia ecosystem to build
library functions that make it easy for scientists to perform this parameter
estimation with the most high-powered and robust methodologies. Possible projects
include improving methods for Bayesian estimation of parameters via Stan.jl
and Julia-based libraries like Turing.jl, or global optimization-based approaches.
Novel techniques like classifying model outcomes via support vector machines
and deep neural networks can also be considered. Research and benchmarking
to attempt to find the most robust methods will take place in this project.
Additionally, the implementation of methods for estimating structure, such
as [topological sensitivity analysis](https://www.pnas.org/content/111/52/18507)
along with performance enhancements to existing methods will be considered.

Some work in this area can be found in
[DiffEqParamEstim.jl](https://github.com/SciML/DiffEqParamEstim.jl)
and [DiffEqBayes.jl](https://github.com/SciML/DiffEqBayes.jl). Examples
can be found [in the DifferentialEquations.jl documentation]( https://docs.sciml.ai/dev/analysis/parameter_estimation).

**Recommended Skills**: Background knowledge of standard machine learning,
statistical, or optimization techniques. It's recommended but not required that
one has basic knowledge of differential equations and DifferentialEquations.jl.
Using the differential equation solver to get outputs from parameters can
be learned on the job, but you should already be familiar (but not necessarily
an expert) with the estimation techniques you are looking to employ.

**Expected Results**: Library functions for performing parameter estimation
and inferring properties of differential equation solutions from parameters.
Notebooks containing benchmarks determining the effectiveness of various methods
and classifying when specific approaches are appropriate will be developed
simultaneously.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas), [Vaibhav Dixit](https://github.com/Vaibhavdixit02)

## Integration of FEniCS.jl with dolfin-adjoint + Zygote.jl for Finite Element Scientific Machine Learning

Scientific machine learning requires mixing scientific computing libraries with machine learning.
[This blog post highlights how the tooling of Julia is fairly advanced in this field](https://www.stochasticlifestyle.com/the-essential-tools-of-scientific-machine-learning-scientific-ml/) compared to alternatives such as Python,
but one area that has not been completely worked out is integration of automatic differentiation
with partial differential equations.
[FEniCS.jl](https://github.com/SciML/FEniCS.jl) is a wrapper to the
[FEniCS](https://fenicsproject.org/) project for finite element solutions of partial differential
equations. We would like to augment the Julia wrappers to allow for integration with Julia's
automatic differentiation libraries like [Zygote.jl](https://github.com/FluxML/Zygote.jl) by
using [dolfin-adjoint](http://www.dolfin-adjoint.org/en/release/). This would require setting up
this library for automatic installation for Julia users and writing adjoint passes which utilize
this adjoint builder library. It would result in the first total integration between PDEs and
neural networks.

**Recommended Skills**: A basic background in differential equations and Python. Having previous
Julia knowledge is preferred but not strictly required.

**Expected Results**: Efficient and high-quality implementations of adjoints for Zygote.jl over FEniCS.jl functions.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Multi-Start Optimization Methods

While standard machine learning can be shown to be "safe" for local optimization,
scientific machine learning can sometimes require the use of globalizing techniques
to improve the optimization process. Hybrid methods, known as multistart optimization
methods, glue together a local optimization technique together with a parameter
search over a large space of possible initial points. The purpose of this project
would be to take a [MultistartOptimization.jl](https://github.com/tpapp/MultistartOptimization.jl)
as a starting point and create a fully featured set of multistart optimization
tools for use with [Optim.jl](https://github.com/JuliaNLSolvers/Optim.jl)

**Recommended Skills**: A basic background in optimization. Having previous
Julia knowledge is preferred but not strictly required.

**Expected Results**: Efficient and high-quality implementations of multistart optimization methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Patrick Kofod Mogensen](https://github.com/pkofod)

