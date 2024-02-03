# Quantum Optics and State Vector Modeling Tools

The most common way to represent and model quantum states is the state vector formalism (underlying Schroedinger's and Heisenberg's equations as well as many other master equations). The [QuantumOptics.jl](https://github.com/qojulia/QuantumOptics.jl) Julia project enables such simulations, utilizing much of the uniquely powerful DiffEq infrastructure in Julia.

## GPU accelerated operators and ODE solvers

Much of the internal representation of quantum states in QuantumOptics.jl relies on standard dense arrays. Thanks to the multiple-dispatch nature of Julia, much of these objects can already work well with GPU arrays. This project would involve a thorough investigation and validation of the current interfaces to make sure they work well with GPU arrays. In particular, attention will have to be paid to the "lazy" operators as special kernels might need to be implemented for them.

**Recommended skills:** Familiarity with performance profiling tools in Julia and Julia's GPU stack, potentially including [KernelAbstractions](https://github.com/JuliaGPU/KernelAbstractions.jl).

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumOptics.jl team members

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Medium

## Autodifferentiation

Autodifferentiation is the capability of automatically generating efficient code to evaluate the numerical derivative of a given Julia function. Similarly to the GPU case above, much of this functionality already "magically" works, but there is no detailed test suite for it and no validation has been done. This project would involve implementing, validating, and testing the use of Julia autodiff tools in QuantumOptics.jl. ForwardDiff, Enzyme, Zygote, Diffractor, and AbstractDifferentiation are all tools that should have some level of validation and support, both in ODE solving and in simple operator applications.

**Recommended skills:** Familiarity with the [Julia autodiff stack](https://juliadiff.org/) and the SciML sensitivity analysis tooling. Familiarity with the difficulties to autodiff complex numbers (in general and specifically in Julia). Understanding of the AbstractDifferentiation.jl package.

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumOptics.jl team members

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Easy-to-Medium

## Closer Integration with the SciML Ecosystem

SciML is the umbrella organization for much of the base numerical software development in the Julia ecosystem. We already use many of their capabilities, but it would be beneficial to more closely match the interfaces they expect. This project would be heavily on the software **engineering** side. Formal and informal interfaces we want to support include: better support for [DiffEq problem types](https://github.com/qojulia/QuantumOptics.jl/issues/298) (currently we wrap DiffEq problems in our own infrastructure and it is difficult to reuse them in SciML); better support for broadcast operations over state objects (so that we can treat them closer to normal arrays and [we can simply provide an initial state to a DiffEq solver without having to wrap/unwrap the data](https://github.com/qojulia/QuantumOpticsBase.jl/pull/16)); relying more heavily on [SciMLOperators](https://docs.sciml.ai/SciMLOperators/stable/) which have significant [overlap with our lazy operators](https://github.com/qojulia/QuantumOpticsBase.jl/issues/99).

**Recommended skills:** Familiarity with the SciML stack.

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumOptics.jl team members

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Easy