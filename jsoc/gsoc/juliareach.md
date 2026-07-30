# JuliaReach - Summer of Code

[JuliaReach](https://github.com/JuliaReach) is the Julia ecosystem for reachability computations of dynamical systems.
Application domains of set-based reachability include formal verification, controller synthesis and estimation under uncertain model parameters or inputs.
For further context reach us on the [JuliaReach zulip](https://julialang.zulipchat.com/#narrow/stream/278609-juliareach) stream. You may also refer to the review article [Set Propagation Techniques for Reachability Analysis](https://www.annualreviews.org/doi/abs/10.1146/annurev-control-071420-081941).

## Efficient symbolic-numeric set computations

**Difficulty**: Medium.

**Description.** [LazySets](https://github.com/JuliaReach/LazySets.jl) is the core library of JuliaReach. It provides ways to symbolically compute with geometric sets, with a focus on lazy set representations and efficient high-dimensional processing. The library has been described in the article [LazySets.jl: Scalable Symbolic-Numeric Set Computations](https://proceedings.juliacon.org/papers/10.21105/jcon.00097).

The main interest in this project is to implement algorithms that leverage the structure of the sets. Typical examples include polytopes and zonotopes (convex), polynomial zonotopes and Taylor models (non-convex) to name a few.

**Expected Results.** The goal is to implement certain efficient state-of-the-art algorithms from the literature. The code is to be documented, tested, and evaluated in benchmarks. Specific tasks may include (to be driven by the interets of the candidate): efficient vertex enumeration of [zonotopes](https://juliareach.github.io/LazySets.jl/dev/lib/sets/Zonotope/#LazySets.Zonotope); operations on polynomial zonotopes; operations on [zonotope bundles](http://archive.www6.in.tum.de/www6/Main/Publications/Althoff2011f.pdf); efficient disjointness checks between different set types; [complex zonotopes](https://ieeexplore.ieee.org/document/7525593).

**Expected Length.** 175 hours.

**Recommended Skills.** Familiarity with Julia and Git/GitHub is mandatory. Familiarity with [LazySets](https://github.com/JuliaReach/LazySets.jl) is recommended. Basic knowledge of geometric terminology is appreciated but not required.

**Mentors**: [Marcelo Forets](https://github.com/mforets), [Christian Schilling](https://github.com/schillic).

## Reachability with sparse polynomial zonotopes

**Difficulty**: Medium.

**Description.** Sparse polynomial zonotopes are a new non-convex set representation that are well-suited for reachability analysis of nonlinear dynamical systems. This project is a continuation of [GSoC'2022 - Reachability with sparse polynomial zonotopes](https://summerofcode.withgoogle.com/archive/2022/projects/feZrZfQX), which implemented the basics in [LazySets](https://github.com/JuliaReach/LazySets.jl).

**Expected Results.** It is expected to add efficient Julia implementations of a reachability algorithm for dynamical systems in [ReachabilityAnalysis](https://github.com/JuliaReach/ReachabilityAnalysis.jl) which leverages polynomial zonotopes. A successful project should:

- Replicate the results from the article [Reachability Analysis for Linear Systems with Uncertain Parameters using Polynomial Zonotopes
](https://dl.acm.org/doi/abs/10.1145/3575870.3587130).

- The code shall be documented, tested, and evaluated extensively in benchmarks.

For ambitious candidates it is possible to draw connections with neural-network control systems as implemented in [ClosedLoopReachability.jl](https://github.com/JuliaReach/ClosedLoopReachability.jl).

**Expected Length.** 175 hours.

**Recommended Skills.** Familiarity with Julia and Git/GitHub is mandatory. Familiarity with the mentioned Julia packages is appreciated but not required. The project does not require theoretical contributions, but it requires reading a research literature, hence a certain level of academic experience is recommended.

**Literature and related packages.** [This video](https://www.youtube.com/watch?v=iMtq6YeIsjA) explains the concept of polynomial zonotopes (slides [here](https://github.com/JuliaReach/juliareach-days-3-reachathon/blob/master/Challenge_5/Challenge5_PolynomialZonotopes.pdf)). The relevant theory is described in [this research article](https://arxiv.org/pdf/1901.01780). There exists a Matlab implementation in [CORA](https://tumcps.github.io/CORA/) (the implementation of polynomial zonotopes can be found in [this folder](https://github.com/TUMcps/CORA/tree/master/contSet/%40polyZonotope)).

**Mentors**: [Marcelo Forets](https://github.com/mforets), [Christian Schilling](https://github.com/schillic).

## Improving the hybrid systems reachability API

**Difficulty**: Medium.

**Description.** [ReachabilityAnalysis](https://github.com/JuliaReach/ReachabilityAnalysis.jl) is a Julia library for set propagation of dynamical systems. One of the main aims is to handle systems with mixed discrete-continuous behaviors (known as hybrid systems in the literature). This project will focus on enhancing the capabilities of the library and overall improvement of the ecosystem for users.

**Expected Results.**   Specific tasks may include: problem-specific heuristics for hybrid systems; API for time-varying input sets; flowpipe underapproximations. The code is to be documented, tested, and evaluated in benchmarks. Integration with [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl) can also be considered if there is interest.

**Expected Length.** 175 hours.

**Recommended Skills.** Familiarity with Julia and Git/GitHub is mandatory. Familiarity with [LazySets](https://github.com/JuliaReach/LazySets.jl) and [ReachabilityAnalysis](https://github.com/JuliaReach/ReachabilityAnalysis.jl) is welcome but not required.

**Mentors**: [Marcelo Forets](https://github.com/mforets), [Christian Schilling](https://github.com/schillic).
