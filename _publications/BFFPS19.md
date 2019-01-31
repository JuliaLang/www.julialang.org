---
type: "article"
title: "JuliaReach: a Toolbox for Set-Based Reachability"
journal: "HSCC '19 Proceedings of the 22nd ACM International Conference on Hybrid Systems: Computation and Control"
authors:
- Sergiy Bogomolov
- Marcelo Forets
- Goran Frehse
- Kostiantyn Potomkin
- Christian Schilling
year: "2019"
pages:
doi: 
arxiv: 1901.10736
packages:
  LazySets.jl: https://github.com/JuliaReach/LazySets.jl
  Reachability.jl: https://github.com/JuliaReach/Reachability.jl
---

We present JuliaReach, a toolbox for set-based reachability analysis of
dynamical systems. JuliaReach consists of two main packages: Reachability,
containing implementations of reachability algorithms for continuous and hybrid
systems, and LazySets, a standalone library that implements state-of-the-art
algorithms for calculus with convex sets. The library offers both concrete and
lazy set representations, where the latter stands for the ability to delay set
computations until they are needed. The choice of the programming language
Julia and the accompanying documentation of our toolbox allow researchers to
easily translate set-based algorithms from mathematics to software in a
platform-independent way, while achieving runtime performance that is
comparable to statically compiled languages. Combining lazy operations in high
dimensions and explicit computations in low dimensions, JuliaReach can be
applied to solve complex, large-scale problems.
