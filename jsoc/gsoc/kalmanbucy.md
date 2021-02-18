
# Stochastic differential equations and continuous time signal processing – Summer of Code

## Smoothing non-linear continuous time systems

The student implements a state of the art smoother for continuous-time systems with
additive Gaussian noise. The system's dynamics can be described as
an ordinary differential equation with locally additive Gaussian random fluctuations,
in other words a stochastic ordinary differential equation.

Given a series of measurements observed over time, containing statistical noise
and other inaccuracies, the task is to produce an estimate of the unknown trajectory of the system that led to
the observations.

*Linear* continuous-time systems are smoothed with the fixed-lag Kalman-Bucy smoother (related to the [Kalman–Bucy_filter](https://en.wikipedia.org/wiki/Kalman_filter#Kalman–Bucy_filter)). It relies on coupled ODEs describing how mean and covariance of the conditional distribution of the latent system state evolve over time. A versatile implementation in Julia is missing.

**Expected Results**: Build efficient implementation of non-linear smoothing of continuous stochastic dynamical systems.

**Recommended Skills**: Gaussian random variables, Bayes' formula, Stochastic Differential Equations

**Mentors**: [Moritz Schauer](https://github.com/mschauer)

**Rating**: Hard
