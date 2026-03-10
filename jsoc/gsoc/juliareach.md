# JuliaReach - Summer of Code

[JuliaReach](https://github.com/JuliaReach) is the Julia ecosystem for reachability computations of dynamical systems.
Application domains of set-based reachability include formal verification, controller synthesis and estimation under uncertain model parameters or inputs.
For further context reach us on the [JuliaReach zulip](https://julialang.zulipchat.com/#narrow/stream/278609-juliareach) stream. You may also refer to the review article [Set Propagation Techniques for Reachability Analysis](https://www.annualreviews.org/doi/abs/10.1146/annurev-control-071420-081941).

## Integration with the Julia numerical modeling ecosystem

**Difficulty**: Medium.

**Description.** [ReachabilityAnalysis](https://github.com/JuliaReach/ReachabilityAnalysis.jl) is a Julia library for set propagation of dynamical systems.
This project aims at integrating ReachabilityAnalysis with the numerical modeling ecosystem in Julia.

**Expected Results.** The proposal is to let the user specify models defined in [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl) from the [SciML](https://github.com/sciml) ecosystem,
and solve them using reachability methods. This first iteration would cover purely continuous systems; a second iteration would cover systems with discrete transitions (hybrid systems).

**Expected Length.** 175 hours.

**Recommended Skills.** Familiarity with Julia and Git/GitHub is mandatory.
Familiarity with [LazySets](https://github.com/JuliaReach/LazySets.jl) and [ReachabilityAnalysis](https://github.com/JuliaReach/ReachabilityAnalysis.jl) is welcome but not required.

**Mentors**: [Marcelo Forets](https://github.com/mforets), [Christian Schilling](https://github.com/schillic).

## Efficient symbolic-numeric set computations

**Difficulty**: Medium.

**Description.** [LazySets](https://github.com/JuliaReach/LazySets.jl) is the core library of JuliaReach. It provides ways to symbolically compute with geometric sets, with a focus on lazy set representations and efficient high-dimensional processing. The library has been described in the article [LazySets.jl: Scalable Symbolic-Numeric Set Computations](https://proceedings.juliacon.org/papers/10.21105/jcon.00097).

The main interest in this project is to implement algorithms that leverage the structure of the sets. Typical examples include polytopes and zonotopes (convex), polynomial zonotopes and Taylor models (non-convex) to name a few.

**Expected Results.** The goal is to implement certain efficient state-of-the-art algorithms from the literature. The code is to be documented, tested, and evaluated in benchmarks. Specific tasks may include (to be driven by the interets of the candidate): efficient vertex enumeration of [zonotopes](https://juliareach.github.io/LazySets.jl/dev/lib/sets/Zonotope/#LazySets.Zonotope); operations on polynomial zonotopes; operations on [zonotope bundles](http://archive.www6.in.tum.de/www6/Main/Publications/Althoff2011f.pdf); efficient disjointness checks between different set types; [complex zonotopes](https://ieeexplore.ieee.org/document/7525593).

**Expected Length.** 175 hours.

**Recommended Skills.** Familiarity with Julia and Git/GitHub is mandatory. Familiarity with [LazySets](https://github.com/JuliaReach/LazySets.jl) is recommended. Basic knowledge of geometric terminology is appreciated but not required.

**Mentors**: [Marcelo Forets](https://github.com/mforets), [Christian Schilling](https://github.com/schillic).

## Improving the hybrid systems reachability API

**Difficulty**: Medium.

**Description.** [ReachabilityAnalysis](https://github.com/JuliaReach/ReachabilityAnalysis.jl) is a Julia library for set propagation of dynamical systems. One of the main aims is to handle systems with mixed discrete-continuous behaviors (known as hybrid systems in the literature). This project will focus on enhancing the capabilities of the library and overall improvement of the ecosystem for users.

**Expected Results.**   Specific tasks may include: problem-specific heuristics for hybrid systems; API for time-varying input sets; flowpipe underapproximations. The code is to be documented, tested, and evaluated in benchmarks. Integration with [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl) can also be considered if there is interest.

**Expected Length.** 175 hours.

**Recommended Skills.** Familiarity with Julia and Git/GitHub is mandatory. Familiarity with [LazySets](https://github.com/JuliaReach/LazySets.jl) and [ReachabilityAnalysis](https://github.com/JuliaReach/ReachabilityAnalysis.jl) is welcome but not required.

**Mentors**: [Marcelo Forets](https://github.com/mforets), [Christian Schilling](https://github.com/schillic).
