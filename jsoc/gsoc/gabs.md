# Simulations of Gaussian quantum information - Summer of Code

Quantum harmonic oscillators are important modalities for quantum computation and quantum networking. A class of them, known as Gaussian bosonic systems, are efficient to simulate on a classical computer. Although such systems do not provide quantum computational advantage, they are present in most protocols and algorithms in continuous variable quantum information. [Gabs.jl](https://github.com/apkille/Gabs.jl) is a Julia library designed to enable fast simulations of Gaussian bosonic circuits and serve as a sandbox for quantum hardware and protocol design.

## Efficient classical simulations of linear combinations of Gaussian quantum states

Non-Gaussian quantum states cannot be simulated via their first- and second-order statistical moments in the phase space representation like Gaussian states. However, there exist fast classical algorithms for simulating superpositions of Gaussian states, which are non-Gaussian in nature. This project involves implementing such algorithmic support for analyzing certain classes of non-Gaussian states.

**Recommended skills:** In-depth understanding of the quantum phase space formalism. [This paper](https://journals.aps.org/pra/abstract/10.1103/PhysRevA.110.042402) and [also this paper](https://arxiv.org/abs/2404.07115) are useful references.

**Mentors:** [Andrew Kille](https://github.com/apkille) and [Stefan Krastanov](https://github.com/Krastanov).

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Medium

## Matrix product state representations of Gaussian and non-Gaussian quantum states

A matrix product state (MPS) is a valuable tensor network method for simulating quantum many-body systems.
In particular, large continuous variable quantum systems that contain low entanglement can be simulated extremely fast with the MPS method. This project involves implementing support for MPS representations of Gaussian and non-Gaussian systems.

**Recommended skills:** In-depth understanding of the quantum phase space formalism. In addition, familiarity with tensor network methods and software such as [ITensors.jl](https://github.com/ITensor/ITensors.jl). For this project, [this paper](https://opg.optica.org/optica/fulltext.cfm?uri=optica-8-10-1306&id=460148) and [also this paper](https://journals.aps.org/pra/abstract/10.1103/PhysRevA.104.012415) are useful references.

**Mentors:** [Andrew Kille](https://github.com/apkille) and [Stefan Krastanov](https://github.com/Krastanov).

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Hard

## Gaussian cluster states

Due to the technological maturity of quantum measurement schemes for photons, one-way quantum computation is an attractive approach for photonic quantum processing. In the continuous variable formalism, Gaussian cluster states serve as an important piece of the measurement-based quantum computation model. This project involves the creation of conversion tools between phase space representations of Gaussian bosonic systems and Gaussian cluster states in the graph formalism.

**Recommended skills:** Understanding of the quantum phase space formalism and the measurement-based quantum computation model. [This review article](https://journals.aps.org/rmp/pdf/10.1103/RevModPhys.84.621) and [recent paper](https://journals.aps.org/prxquantum/abstract/10.1103/PRXQuantum.2.030343) is a useful reference.

**Mentors:** [Andrew Kille](https://github.com/apkille) and [Stefan Krastanov](https://github.com/Krastanov).

**Expected duration:** 175 hours (but applicants can scope it as longer if they plan more extensive work)

**Difficulty:** Easy