# Tools for simulation of Quantum Clifford Circuits

Clifford circuits are a class of quantum circuits that can be simulated efficiently on a classical computer. As such, they do not provide the computational advantage expected of universal quantum computers. Nonetheless, they are extremely important, as they underpin most techniques for quantum error correction and quantum networking. Software that efficiently simulates such circuits, at the scale of thousands or more qubits, is essential to the design of quantum hardware. The [QuantumClifford.jl](https://github.com/Krastanov/QuantumClifford.jl) Julia project enables such simulations.

## GPU accelerated simulator of Clifford Circuits.

Simulation of Clifford circuits involves significant amounts of linear algebra with boolean matrices. This enables the use of many standard computation accelerators like GPUs, as long as these accelerators support bit-wise operations.
The main complications is that the elements of the matrices under consideration are usually packed in order to increase performance and lower memory usage, i.e. a vector of 64 elements would be stored as a single 64 bit integer instead of as an array of 64 bools.
A Summer of Code project could consist of implement the aforementioned linear algebra operations in GPU kernels, and then seamlessly integrating them in the rest of the QuantumClifford library.
At a minimum that would include [Pauli-Pauli products](https://github.com/Krastanov/QuantumClifford.jl/blob/v0.4.0/src/QuantumClifford.jl#L725) and certain [small Clifford operators](https://github.com/Krastanov/QuantumClifford.jl/blob/v0.4.0/src/symbolic_cliffords.jl), but could extend to general [stabilizer tableau multiplication](https://github.com/Krastanov/QuantumClifford.jl/blob/v0.4.0/src/QuantumClifford.jl#L1385) and even [tableau diagonalization](https://github.com/Krastanov/QuantumClifford.jl/blob/v0.4.0/src/QuantumClifford.jl#L985). 

**Recommended skills:** Basic knowledge of the [stabilizer formalism](https://krastanov.github.io/QuantumClifford.jl/dev/references/) used for simulating Clifford circuits. Familiarity with performance profiling tools in Julia and Julia's GPU stack, including [KernelAbstractions](https://github.com/JuliaGPU/KernelAbstractions.jl) and [Tullio](https://github.com/mcabbott/Tullio.jl).

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov)

**Expected duration:** 175 hours (but applicants can scope it to a longer project by including work on GPU-accelerated Gaussian elimination used in the canonicalization routines)

**Difficulty:** Medium if the applicant is familiar with Julia, even without understanding of Quantum Information Science (but applicants can scope it to "hard" by including the aforementioned additional topics)

## Pauli Frames for faster sampling.

Often, stabilizer circuit simulations are structured as a repeated simulation of the same circuit with random Pauli errors superimposed on it. This is useful, for instance, when studying the performance of error-correcting codes. In such simulations it is possible to run one single relatively expensive simulation of the noise-less circuit in order to get a reference and then run a large number of much faster "Pauli Frame" simulations that include the random noise. By utilizing the reference simulation, the random noise simulations could more efficiently provide samples of the performance of the circuit under noise. This project would involve creating an API for such simulations in QuantumClifford.jl. A useful reference would be the [Stim C++ library](https://arxiv.org/abs/2103.02202).

**Recommended skills:** Knowledge of the [stabilizer formalism](https://krastanov.github.io/QuantumClifford.jl/dev/references/) used for simulating Clifford circuits. Familiarity with performance profiling tools in Julia.

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov)

**Expected duration:** 350 hours

**Difficulty:** Hard, due to requiring in-depth knowledge of the stabilizer formalism.

## A Zoo of Quantum Error Correcting codes.

Quantum Error Correcting codes are typically represented in a form similar to the parity check matrix of a classical code. This form is called a Stabilizer tableaux. This project would involve creating a comprehensive library of frequently used quantum error correcting codes. As an initial step that would involve implementing the tableaux corresponding to simple pedagogical codes like the Steane and Shor codes, toric and surface codes, some CSS codes, etc. The project can be extended to a much longer one by including work on decoders for some of these codes. A large part of this project would involve literature surveys.

**Recommended skills:** Knowledge of the [stabilizer formalism](https://krastanov.github.io/QuantumClifford.jl/dev/references/) used for simulating Clifford circuits.

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov)

**Expected duration:** 175 hours (but applicants can scope it as longer, depending on the list of functionality they plan to implement)

**Difficulty:** Medium. Easy with some basic knowledge of quantum error correction

## Left/Right multiplications with small gates.

Applying an n-qubit Clifford gate to an n-qubit state (tableaux) is an operation similar to matrix multiplication, requiring O(n^3) steps. However, applying a single-qubit or two-qubit gate to an n-qubit tableaux is much faster as it needs to address only one or two columns of the tableaux. This project would focus on extending the left-multiplication special cases already started in [symbolic_cliffords.jl](https://github.com/Krastanov/QuantumClifford.jl/blob/master/src/symbolic_cliffords.jl) and creating additional right-multiplication special cases (for which [the Stim library is a good reference](https://github.com/Krastanov/QuantumClifford.jl/commit/d3e84c16b7b08ef6f1bc24e2bcf98641c2fff1ab#r67183201)).

**Recommended skills:** Knowledge of the [stabilizer formalism](https://krastanov.github.io/QuantumClifford.jl/dev/references/) used for simulating Clifford circuits. Familiarity with performance profiling tools in Julia. Understanding of C/C++ if you plan to use the Stim library as a reference.

**Mentors:** [Stefan Krastanov](https://github.com/Krastanov)

**Expected duration:** 175 hours (but applicants can scope it as longer if they )

**Difficulty:** Easy
