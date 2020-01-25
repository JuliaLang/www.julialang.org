---

title: "Construction of quasipotentials for stochastic dynamical systems: An optimization approach"
authors:
- Rowan D. Brackston
- Andrew Wynn
- Michael P. H. Stumpf
year: "2018"
journal: "Physical Review E"
volume: "98"
pages: "022136"
doi: "10.1103/PhysRevE.98.022136"
arxiv: "1805.07273"
packages:
  JuMP.jl: https://github.com/JuliaOpt/JuMP.jl
  SumOfSquares.jl: https://github.com/JuliaOpt/SumOfSquares.jl
---
The construction of effective and informative landscapes for stochastic dynamical systems has proven a long-standing and complex problem. In many situations, the dynamics may be described by a Langevin equation while constructing a landscape comes down to obtaining the quasipotential, a scalar function that quantifies the likelihood of reaching each point in the state space. In this work we provide a novel method for constructing such landscapes by extending a tool from control theory: the sum-of-squares method for generating Lyapunov functions. Applicable to any system described by polynomials, this method provides an analytical polynomial expression for the potential landscape, in which the coefficients of the polynomial are obtained via a convex optimization problem. The resulting landscapes are based on a decomposition of the deterministic dynamics of the original system, formed in terms of the gradient of the potential and a remaining “curl” component. By satisfying the condition that the inner product of the gradient of the potential and the remaining dynamics is everywhere negative, our derived landscapes provide both upper and lower bounds on the true quasipotential; these bounds becoming tight if the decomposition is orthogonal. The method is demonstrated to correctly compute the quasipotential for high-dimensional linear systems and also for a number of nonlinear examples.
