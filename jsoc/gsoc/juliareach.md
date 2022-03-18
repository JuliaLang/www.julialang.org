# JuliaReach - Summer of Code

[JuliaReach](https://github.com/JuliaReach) is the Julia ecosystem for reachability computations of dynamical systems.

## Efficient low-dimensional symbolic-numeric set computations

**Difficulty**: Medium.

**Description.** [LazySets](https://github.com/JuliaReach/LazySets.jl) is a Julia library for computing with geometric sets, whose focus is on lazy set representations and efficient high-dimensional processing. The main interest in this project is to develop algorithms that leverage the structure of the sets. The special focus will be on low-dimensional (typically 2D and 3D) cases.

**Expected Results.** The goal is to implement certain efficient algorithms from the literature. The code is to be documented, tested, and evaluated in benchmarks. Specific tasks may include: efficient vertex enumeration of [zonotopes](https://juliareach.github.io/LazySets.jl/dev/lib/sets/Zonotope/#LazySets.Zonotope); operations on [zonotope bundles](http://archive.www6.in.tum.de/www6/Main/Publications/Althoff2011f.pdf); efficient disjointness checks between different set types; [complex zonotopes](https://ieeexplore.ieee.org/document/7525593).

**Expected Length.** 175 hours.

**Recommended Skills.** Familiarity with Julia and Git/GitHub is mandatory. Familiarity with [LazySets](https://github.com/JuliaReach/LazySets.jl) is recommended. Basic knowledge of geometric terminology is appreciated but not required.

**Mentors**: [Marcelo Forets](github.com/mforets), [Christian Schilling](github.com/schillic).

## Reachability with sparse polynomial zonotopes

**Difficulty**: Hard.

**Description.** Sparse polynomial zonotopes are a new non-convex set representation that are well-suited for reachability analysis of nonlinear dynamical systems. The task is to add efficient Julia implementations of:

(1) sparse polynomial zonotopes in [LazySets](https://github.com/JuliaReach/LazySets.jl),

(2) the corresponding reachability algorithm for dynamical systems in [ReachabilityAnalysis](https://github.com/JuliaReach/ReachabilityAnalysis.jl).

**Expected Results.** The goal is to efficiently implement sparse polynomial zonotopes and the corresponding reachability algorithms. The code is to be documented, tested, and evaluated extensively in benchmarks. If the candidate is interested, it is possible to change task (2) with 

(3) an integration of the new set representation for neural-network control systems in [NeuralNetworkAnalysis](https://github.com/JuliaReach/NeuralNetworkAnalysis.jl).

**Expected Length.** 350 hours.

**Recommended Skills.** Familiarity with Julia and Git/GitHub is mandatory. Familiarity with the mentioned Julia packages is appreciated but not required. The project does not require theoretical contributions, but it requires reading a research article (see below); hence a certain level of academic experience is recommended.

**Literature and related packages.** [This video](https://www.youtube.com/watch?v=iMtq6YeIsjA) explains the concept of polynomial zonotopes (slides [here](https://github.com/JuliaReach/juliareach-days-3-reachathon/blob/master/Challenge_5/Challenge5_PolynomialZonotopes.pdf)). The relevant theory is described in [this research article](https://arxiv.org/pdf/1901.01780). There exists a Matlab implementation in [CORA](https://tumcps.github.io/CORA/) (the implementation of polynomial zonotopes can be found in [this folder](https://github.com/TUMcps/CORA/tree/master/contSet/%40polyZonotope)).

**Mentors**: [Marcelo Forets](github.com/mforets), [Christian Schilling](github.com/schillic).

## Improving the hybrid systems reachability API

**Difficulty**: Hard.

**Description.** [ReachabilityAnalysis](https://github.com/JuliaReach/ReachabilityAnalysis.jl) is a Julia library for set propagation of dynamical systems. One of the main aims is to handle systems with mixed discrete-continuous behaviors (known as hybrid systems in the literature). This project will focus on enhancing the capabilities of the library and overall improvement of the ecosystem for users.

**Expected Results.**   Specific tasks may include: problem-specific heuristics for hybrid systems; API for time-varying input sets; flowpipe underapproximations. The code is to be documented, tested, and evaluated in benchmarks. Integration with [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl) can also be considered if there is interest.

**Expected Length.** 350 hours.

**Recommended Skills.** Familiarity with Julia and Git/GitHub is mandatory. Familiarity with [LazySets](https://github.com/JuliaReach/LazySets.jl) and [ReachabilityAnalysis](https://github.com/JuliaReach/ReachabilityAnalysis.jl) is also required.

**Mentors**: [Marcelo Forets](github.com/mforets), [Christian Schilling](github.com/schillic).
