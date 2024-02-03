# Tools for simulation of Quantum Clifford Circuits

Clifford circuits are a class of quantum circuits that can be simulated efficiently on a classical computer. As such, they do not provide the computational advantage expected of universal quantum computers. Nonetheless, they are extremely important, as they underpin most techniques for quantum error correction and quantum networking. Software that efficiently simulates such circuits, at the scale of thousands or more qubits, is essential to the design of quantum hardware. The [QuantumClifford.jl](https://github.com/Krastanov/QuantumClifford.jl) Julia project enables such simulations.

## GPU accelerated simulator of Clifford Circuits.

Simulation of Clifford circuits involves significant amounts of linear algebra with boolean matrices. This enables the use of many standard computation accelerators like GPUs, as long as these accelerators support bit-wise operations.
The main complications is that the elements of the matrices under consideration are usually packed in order to increase performance and lower memory usage, i.e. a vector of 64 elements would be stored as a single 64 bit integer instead of as an array of 64 bools.
A Summer of Code project could consist of implement the aforementioned linear algebra operations in GPU kernels, and then seamlessly integrating them in the rest of the QuantumClifford library.
At a minimum that would include [Pauli-Pauli products](https://github.com/Krastanov/QuantumClifford.jl/blob/v0.4.0/src/QuantumClifford.jl#L725) and certain [small Clifford operators](https://github.com/Krastanov/QuantumClifford.jl/blob/v0.4.0/src/symbolic_cliffords.jl), but could extend to general [stabilizer tableau multiplication](https://github.com/Krastanov/QuantumClifford.jl/blob/v0.4.0/src/QuantumClifford.jl#L1385) and even [tableau diagonalization](https://github.com/Krastanov/QuantumClifford.jl/blob/v0.4.0/src/QuantumClifford.jl#L985). Some of these features are already implemented, but significant polish and further improvements and implementation of missing features is needed.

**Recommended skills:** Basic knowledge of the [stabilizer formalism](https://krastanov.github.io/QuantumClifford.jl/dev/references/) used for simulating Clifford circuits. Familiarity with performance profiling tools in Julia and Julia's GPU stack, including [KernelAbstractions](https://github.com/JuliaGPU/KernelAbstractions.jl) and [Tullio](https://github.com/mcabbott/Tullio.jl).

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumClifford.jl team members

**Expected duration:** 175 hours (but applicants can scope it to a longer project by including work on GPU-accelerated Gaussian elimination used in the canonicalization routines)

**Difficulty:** Medium if the applicant is familiar with Julia, even without understanding of Quantum Information Science (but applicants can scope it to "hard" by including the aforementioned additional topics)

## A Zoo of Quantum Error Correcting codes and/or decoders

Quantum Error Correcting codes are typically represented in a form similar to the parity check matrix of a classical code. This form is referred to as a Stabilizer tableaux. This project would involve creating a comprehensive library of frequently used quantum error correcting codes and/or implementing syndrome-decoding algorithms for such codes. The library already includes some simple codes and interfaces to a few decoders -- adding another small code or providing a small documentation pull request could be a good way to prove competence when applying for this project. The project can be extended to a much longer one if work on decoders is included. A large part of this project would involve literature surveys. Some suggestions for codes to include: color codes, higher-dimensional topological codes, hyper graph product codes, twists in codes, newer LDPC codes, honeycomb codes, Floquet codes. Some suggestions for decoders to work on: iterative, small-set flip, ordered statistical decoding, belief propagation, neural belief propagation.

**Recommended skills:** Knowledge of the [stabilizer formalism](https://krastanov.github.io/QuantumClifford.jl/dev/references/) used for simulating Clifford circuits. Familiarity with tools like python's `ldpc`, `pymatching`, and `stim` can help. Consider checking out the `PyQDecoders.jl` julia wrapper package as well.

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumClifford.jl team members

**Expected duration:** 175 hours (but applicants can scope it as longer, depending on the list of functionality they plan to implement)

**Difficulty:** Medium. Easy with some basic knowledge of quantum error correction

## Left/Right multiplications with small gates.

Applying an n-qubit Clifford gate to an n-qubit state (tableaux) is an operation similar to matrix multiplication, requiring O(n^3) steps. However, applying a single-qubit or two-qubit gate to an n-qubit tableaux is much faster as it needs to address only one or two columns of the tableaux. This project would focus on extending the left-multiplication special cases already started in [symbolic_cliffords.jl](https://github.com/Krastanov/QuantumClifford.jl/blob/master/src/symbolic_cliffords.jl) and creating additional right-multiplication special cases (for which [the Stim library is a good reference](https://github.com/Krastanov/QuantumClifford.jl/commit/d3e84c16b7b08ef6f1bc24e2bcf98641c2fff1ab#r67183201)).

**Recommended skills:** Knowledge of the [stabilizer formalism](https://krastanov.github.io/QuantumClifford.jl/dev/references/) used for simulating Clifford circuits. Familiarity with performance profiling tools in Julia. Understanding of C/C++ if you plan to use the Stim library as a reference.

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumClifford.jl team members

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan for other significant optimization and API design work)

**Difficulty:** Easy

## Generation of Fault Tolerant ECC Circuits, Flag Qubit Circuits and more

The QuantumClifford library already has some [support for generating different types of circuits related to error correction](https://github.com/QuantumSavory/QuantumClifford.jl/blob/v0.8.19/src/ecc/circuits.jl) (mostly in terms of syndrome measurement circuits like Shor's) and for evaluating the quality of error correcting codes and decoders. Significant improvement can be made by implementing more modern compilation schemes, especially ones relying on flag qubits.

**Recommended skills:** Knowledge of the variety of flag qubit methods. Some useful references could be [a](https://link.aps.org/accepted/10.1103/PhysRevLett.121.050502), [b](https://www.nature.com/articles/s41534-018-0085-z), [c](https://journals.aps.org/prxquantum/pdf/10.1103/PRXQuantum.1.010302), and this [video lecture](https://www.youtube.com/watch?v=etA9l2NUCXI).

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumClifford.jl team members

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Hard

## Measurement-Based Quantum Computing (MBQC) compiler

The MBQC model of quantum computation has a lot of overlap with the study of Stabilizer states. This project would be about the creation of an MBQC compiler and potentially simulator in Julia. E.g. if one is given an arbitrary graph state and a circuit, how is this circuit to be compiled in an MBQC model.

**Recommended skills:** Knowledge of the MBQC model of quantum computation. This [paper and the related python library](https://arxiv.org/pdf/2212.11975.pdf) can be a useful reference. Consider also [this reference](https://quantum-journal.org/papers/q-2021-03-25-421/).

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumClifford.jl team members

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Hard

## Implementing a Graph State Simulator

The graph states formalism is a way to work more efficiently with stabilizer states that have a sparse tableaux. This project would involve creation of the necessary gate simulation algorithms and conversions tools between graph formalism and stabilizer formalism (some of which are [already available in the library](https://github.com/QuantumSavory/QuantumClifford.jl/blob/master/src/graphs.jl)).

**Recommended skills:** Understanding of the graph formalism. This [paper can be a useful reference](https://arxiv.org/abs/quant-ph/0504117).

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumClifford.jl team members

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Medium

## Simulation of Slightly Non-Clifford Circuits and States

There are various techniques used to augment Clifford circuit simulators to model circuits that are only "mostly" Clifford. Particularly famous are the Clifford+T gate simulators. This project is about implementing such extensions.

**Recommended skills:** In-depth understanding of the Stabilizer formalism, and understanding of some of the extensions to that method. We have some [initial implementations](https://github.com/QuantumSavory/QuantumClifford.jl/blob/master/src/nonclifford.jl). This [IBM paper](https://arxiv.org/pdf/1808.00128.pdf) can also be a useful reference for other methods.

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumClifford.jl team members

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Hard

## Magic State Modeling - Distillation, Injection, Etc

Magic states are important non-stabilizer states that can be used for inducing non-Clifford gates in otherwise Clifford circuits. They are crucial for the creation of error-corrected universal circuits. This project would involve contributing tools for the analysis of such states and for the evaluation of distillation circuits and ECC circuits involving such states.

**Recommended skills:** In-depth understanding of the theory of magic states and their use in fault tolerance.

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov) and QuantumClifford.jl team members

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Hard