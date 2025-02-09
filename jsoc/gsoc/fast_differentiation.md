[FastDifferentiation.jl](https://github.com/brianguenter/FastDifferentiation.jl) is a Julia package for computing very efficient symbolic derivatives of Julia functions and for compiling the derivatives into  efficient executables. It can differentiate much larger expressions than other symbolic systems, such as Symbolics.jl, and the resulting derivatives are also much more efficient, rivaling hand computed derivatives in some cases (see the website for benchmark examples).

[FastDifferentiation.jl](https://github.com/brianguenter/FastDifferentiation.jl) also computes the exact sparsity patterns of Jacobians and Hessians (and any other order derivative) and detects common terms in derivatives of Rⁿ->Rᵐ functions for large n,m. As a consequence computation time of Jacobians generally scales sub-linearly as a function of n,m.


However, the current system has several weaknesses. It is not currently possible to differentiate through conditional expressions so many commonly used Julia functions cannot be differentiated.
Derivatives of any order can be computed but orders above 3 or 4 become increasingly inefficient. These projects aim to address these weaknesse.

# Add Conditionals to FastDifferentiation.jl

FastDifferentiation supports conditionals in function definitions but cannot yet compute derivatives of functions with conditionals:
```julia
julia> @variables x y

julia> f = if_else(x>y,x^2,y^2)
(if_else  (x > y) (x ^ 2) (y ^ 2))

julia> derivative(f,x)
ERROR: Your expression contained a if_else expression. FastDifferentiation does not yet support differentiation through this function
```

>The goal of this project is to modify the derivative graph analysis code so that it detects conditional subgraphs and then generates run time code to evaluate conditionals and branches to correct derivative expressions.

**Medium difficulty, 175 hours.**

**Recommended Skills:** Julia programming experience, previous work with graph algorithms helpful but not required.

**Expected Outcome:** Well-tested and well-documented support for conditionals.

**Mentor:** [BrianGuenter](https://github.com/brianguenter/FastDifferentiation.jl)

# Add higher order derivatives to FastDifferentiation.jl
FastDifferentiation.jl produces extremely efficient first derivatives. But, higher order derivatives become increasingly less efficient since they are computed by repeatedly applying the differentiation algorithm. 

The fundamental cause of this behavior is that repeated higher order intermediate derivative terms are not detected and reused; instead they are computed from scratch. The goal of this project is to extend the FastDifferentiation algorithm to detect these common higher order terms and to reuse, rather than recompute them.

This will require a rewrite of the graph factorization code as well as some theoretical work to determine which higher order terms can be reused.

**Hard, 350 hours.**

**Recommended Skills:** Julia programming experience, previous work with graph algorithms helpful but not required. Understanding of [Faa Di Bruno's](https://en.wikipedia.org/wiki/Fa%C3%A0_di_Bruno%27s_formula) and [Leibniz's rule](https://en.wikipedia.org/wiki/General_Leibniz_rule).

**Expected Outcome:** Well-tested and well-documented support for higher order derivatives.

**Mentor:** [BrianGuenter](https://github.com/brianguenter/FastDifferentiation.jl)

# Integrate FastDifferentiation.jl into Symbolics.jl

FastDifferentiation.jl uses a new symbolic algorithm for automatic differentiation that can be orders of magnitude faster than conventional symbolic differentiation methods. Symoblics.jl could compute derivatives much faster using the FastDifferentiation algorithm. However implementation and data structure differences between the two systems make it difficult to add FastDifferentiation capabilities to Symbolics.jl.

For example, Symbolics.jl allows you to define a function $q(t)$ and then to compute a symbolic derivative $\dot{q}(t)$ without defining $q$. Adding this capability to FastDifferentiation.jl requires a change in the graph representation of derivatives. 

The goal of this project is to first analyze the sources of the incompatibilities between the two systems and then to modify FastDifferentiation.jl, and perhaps Symbolics.jl, so that they interoperate.

See [this](https://github.com/brianguenter/Proposals) page for a more detailed description of tasks.

**Medium difficulty, 175 hours.**

**Recommended Skills:** Julia programming experience, previous work with graph algorithms helpful but not required.

**Expected Outcome:** Well-tested and well-documented integration of FastDifferentiation into Symbolics.jl.

**Mentor:** [BrianGuenter](https://github.com/brianguenter/FastDifferentiation.jl)