---
type: "article"
title: "Reach Set Approximation through Decomposition with Low-dimensional Sets and High-dimensional Matrices"
journal: "HSCC '18 Proceedings of the 21st International Conference on Hybrid Systems: Computation and Control"
authors:
- Sergiy Bogomolov
- Marcelo Forets
- Goran Frehse
- Frédéric Viry
- Andreas Podelski
- Christian Schilling
year: "2018"
pages: "41--50"
doi: "10.1145/3178126.3178128"
arxiv: 1801.09526
packages:
  LazySets.jl: https://github.com/JuliaReach/LazySets.jl
  Reachability.jl: https://github.com/JuliaReach/Reachability.jl
---

Approximating the set of reachable states of a dynamical system is an algorithmic yet mathematically rigorous way to reason about its safety. Although progress has been made in the development of efficient algorithms for affine dynamical systems, available algorithms still lack scalability to ensure their wide adoption in the industrial setting. While modern linear algebra packages are efficient for matrices with tens of thousands of dimensions, set-based image computations are limited to a few hundred. We propose to decompose reach set computations such that set operations are performed in low dimensions, while matrix operations like exponentiation are carried out in the full dimension. Our method is applicable both in dense- and discrete-time settings. For a set of standard benchmarks, it shows a speed-up of up to two orders of magnitude compared to the respective state-of-the-art tools, with only modest losses in accuracy. For the dense-time case, we show an experiment with more than 10,000 variables, roughly two orders of magnitude higher than possible with previous approaches.
