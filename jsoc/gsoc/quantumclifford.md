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

**Difficulty:** Easy/medium if the applicant is familiar with Julia, even without understanding of Quantum Information Science (but applicants can scope it to "hard" by including the afforementioned additional topics)
