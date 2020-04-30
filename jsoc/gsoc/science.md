
# Scientific Projects – Summer of Code


## Computational methods using zonotopes

Zonotopes are representations of extended use in set-based analysis, since linear transformations and Minkowski sums can be computed efficiently. However, they are not closed under intersections. In the literature there exist different alternatives for overapproximation of zonotope intersections with other set types. The package [LazySets.jl](https://github.com/JuliaReach/LazySets.jl) already offers support for zonotopes but lacks some of the state-of-the-art methods.

Zonotopes provide a very good middle ground between hyper rectangular approximations and general polyhedral approximations in terms of performance and accuracy. Applications of this project are the verification of hybrid dynamical systems (see [https://juliareach.github.io/JuliaReach-website/](https://juliareach.github.io/JuliaReach-website/)) and in neural network verification (see [AI2](https://ieeexplore.ieee.org/document/8418593) and [NeuralVerification.jl](https://github.com/sisl/NeuralVerification.jl) project).

**Recommended Skills:** Basic knowledge on convex geometry and polyhedral computations is preferred but can be learned along the way. A taste for writing efficient code.

**Expected Results:** Some possibilities are: overapproximation of zonotopes with polytopes, zonotope-polytope intersections, order reduction methods, Minkowski difference of zonotopes.

**Mentors:** [Marcelo Forets](https://github.com/mforets) and [Christian Schilling](https://github.com/schillic).

**References:** See [Reachability.jl#Publications](https://juliareach.github.io/Reachability.jl/stable/publications/) and references therein, or contact us in the [gitter channel](https://gitter.im/JuliaReach/Lobby).

