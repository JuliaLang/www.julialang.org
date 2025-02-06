# Integrate FastDifferentiation.jl into Symbolics.jl

FastDifferentiation.jl uses a new symbolic algorithm for automatic differentiation that can be orders of magnitude faster than conventional symbolic differentiation methods. Symoblics.jl could compute derivatives much faster using the FastDifferentiation algorithm. However implementation and data structure differences between the two systems make it difficult to add FastDifferentiation capabilities to Symbolics.jl.

For example, Symbolics.jl allows you to define a function $q(t)$ and then to compute a symbolic derivative $\dot{q}(t)$ without defining $q$. Adding this capability to FastDifferentiation.jl requires a change in the graph representation of derivatives. 

The goal of this project is to first analyze the sources of the incompatibilities between the two systems and then to modify FastDifferentiation.jl, and perhaps Symbolics.jl, so that they interoperate.

**Recommended Skills:** Julia programming experience, previous work with graph algorithms helpful but not required.

**Expected Outcome:** Well-tested and well-documented integration of FastDifferentiation into Symbolics.jl.

**Mentor:** [BrianGuenter](https://github.com/brianguenter/FastDifferentiation.jl)