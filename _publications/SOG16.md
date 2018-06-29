---
type: "article"
title: "Second-Order Switching Time Optimization for Switched Dynamical Systems"
authors:
- Stellato, B.
- Ober-Blöbaum, S.
- Goulart, P. J.
year: "2017"
month: "October"
doi: 10.1109/TAC.2017.2697681
journal: "IEEE Transactions on Automatic Control"
volume: "62"
issue: "10"
pages: "5407--5414"
packages:
  SwitchTimeOpt.jl: https://github.com/oxfordcontrol/SwitchTimeOpt.jl
---
Switching time optimization arises in finite-horizon optimal control for switched systems where, given a sequence of continuous dynamics, one minimizes a cost function with respect to the switching times. We propose an efficient method for computing the optimal switching times for switched linear and nonlinear systems. A novel second-order optimization algorithm is introduced where, at each iteration, the dynamics are linearized over an underlying time grid to compute the cost function, the gradient and the Hessian efficiently. With the proposed method, the most expensive operations at each iteration are shared between the cost function and its derivatives, thereby greatly reducing the computational burden. We implemented the algorithm in the Julia package SwitchTimeOpt allowing the user to easily solve switching time optimization problems. In the case of linear dynamics, many operations can be further simplified and benchmarks show that our approach is able to provide optimal solutions in just a few ms. In the case of nonlinear dynamics, two examples show that our method provides optimal solutions with up to two orders of magnitude time reductions over state-of-the-art approaches.
