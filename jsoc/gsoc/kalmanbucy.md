
# Stochastic differential equations and continuous time signal processing – Summer of Code

## Filtering and smoothing large non-linear continuous time systems

The student implements a state of the art smoother for
large continuous-time systems. The system's dynamics can be described as
an ordinary differential equation with locally additive Gaussian random fluctuations.
Thus the system is modeled as a high-dimensional stochastic ordinary differential equation.

Given a series of measurements observed over time, containing statistical noise
and other inaccuracies, a *filter* produces an estimate of the unknown state of the system that led to
the current observation taking previous observations into account. The estimate is obtained from deriving a conditional probability distribution of the current system state given earlier observations.

*Linear* continuous-time systems are filtered with the continuous-time Kalman-Bucy filter,
a continuous time version of the [Kalman filter](https://en.wikipedia.org/wiki/Kalman_filter). This filter relies on a pair of ODE's describing how mean and covariance of the conditional distribution of the filtered system state evolve over time.
If the system dimension is large, this requires careful numerical linear algebra exploiting sparsity or other structures. A versatile implementation of the Kalman-Bucy filter in Julia is missing.

In [Frank van der Meulen, M. Schauer: Continuous-discrete smoothing of diffusions. arxiv:1712.03807, 2017](https://arxiv.org/abs/1712.03807) it is described how the Kalman-Bucy filter can be adapted to compute estimates of the entire unknown evolution of a *non-linear* continuous time systems which is only sporadically observed (*non-linear smoothing*). Julia misses a versatile implementation of the Kalman-Bucy filter. The task of this project is to provide linear and non-linear filtering and smoothing of continuous stochastic dynamical systems. This can be done in alignment with the two packages [Kalman.jl](https://github.com/mschauer/Kalman.jl), dedicated to statistical filtering and [Bridge.jl](https://github.com/mschauer/Bridge.jl), a package
for statistical inference for stochastic differential equations.

**Recommended Skills**: Numerical linear algebra, Gaussian random variables, Bayes' formula, Differential Equations.

**Expected Results**: Build efficient implementation of non-linear filtering and smoothing of continuous stochastic dynamical systems.

**Mentors**: [Moritz Schauer](https://github.com/mschauer)
