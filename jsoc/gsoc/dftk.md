# DFTK.jl development projects – Summer of Code

## Bringing DFTK to graphics-processing units (GPUs)

Density-functional theory (DFT) is probably the most widespread method
for simulating the quantum-chemical behaviour of electrons in matter
and applications cover a wide range of fields such as materials
research, chemistry or pharmacy. For aspects like designing the
batteries, catalysts or drugs of tomorrow DFT is nowadays a key
building block of the ongoing research. The aim to tackle even larger
and more involved systems with DFT, however, keeps posing novel
challenges with respect to physical models, reliability and
performance. For tackling these aspects in the multidisciplinary
context of DFT we recently started the [density functional toolkit
(DFTK)](https://dftk.org), a DFT package written in pure Julia.

Employing GPUs to bring speed improvements to DFT simulations
is an established idea. However, in state-of-the-art DFT simulation
packages the GPU version of the solution algorithm is usually implemented
in a separate code base. In other words the CPU and the GPU version
co-exist, which has the drawback of the duplicated effort to fix bugs or
for keeping both code bases in sync whenever a novel method or algorithm
becomes available. Since conventional GPU programming frameworks feature
a steep learning curve for newcomers, oftentimes the GPU version is
lagging behind and features an increased code complexity making the
investigation of novel GPU algorithms challenging.

In this project we want to build on the extensive GPU programming capabilities of the
Julia ecosystem to enable DFTK to offload computations to a local GPU. Key aim will
be to minimise the code which needs to be adapted from the present CPU code base in DFTK
to achieve this. Since GPU counterparts already exist for most computational bottlenecks
of a DFT computation, the key challenge of this project will be to handle the overall
orchestration of the computational workflow as well as the data transfer between the
CPU and the GPU. To keep the task manageable we will not directly tackle the full DFT
problem (a non-linear eigenvalue problem), but restrict ourselves to the reduced setting
of linear eigenvalue problems. Expanding from there towards the full DFT is an optional
stretch goal of the project.

**Level of difficulty:** Medium to difficult

**Project size:** large, i.e. 12 weeks a 30 hours

**Recommended skills:** Interest to work on an multidisciplinary project
bordering physics, mathematics and computer science with a good
working knowledge of numerical linear algebra and Julia.
Detailed knowledge in the physical background (electrostatics, material science)
or about GPU programming is not required,
but be prepared to take a closer look at these domains during the project.

**Expected results:** Use Julias GPU programming ecosystem to implement
an algorithm for solving the type of eigenvalue problems arising
in density-functional theory.

**Mentors:** Valentin Churavy, Michael F. Herbst, Antoine Levitt

**References:** For a nice intro to DFT and DFTK.jl see [Michael's talk
at JuliaCon 2020](https://www.youtube.com/watch?v=-RomkxjlIcQ) and the
literature given in the [DFTK
documentation](https://docs.dftk.org/stable/guide/density_functional_theory/).
For an introduction to GPU computing in Julia, see [the GPU workshop
at JuliaCon 2021](https://www.youtube.com/watch?v=Hz9IMJuW5hU)
by Tim Besard, Julian Samaroo and Valentin.

**Contact:** For any questions, feel free to email
[@mfherbst](https://github.com/mfherbst), [@antoine-levitt](https://github.com/antoine-levitt)
or write us on the [JuliaMolSim slack](https://join.slack.com/t/juliamolsim/shared_invite/zt-tc060co0-HgiKApazzsQzBHDlQ58A7g).
