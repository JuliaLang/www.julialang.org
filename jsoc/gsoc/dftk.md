# DFTK.jl development projects – Summer of Code

## Automatic differentiation in density-functional theory

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

Aside from computing the DFT energy itself, most applications of DFT
require also derivatives of the energy with respect to various
computational parameters. Examples are the forces (derivative energy
with respect to atomic positions) and stresses (derivative energy with
respect to lattice parameters). While the expressions of these
derivatives are well-known for the standard DFT approaches implementing
these is still a laborious (and sometimes boring) task. Additionally
deriving these forces and stresses expressions for novel models
currently boils down to manually doing so on pen and paper, which for
the more involved models can be non-trivial.

As an alternative we want to take a look at combining the
automatic-differentiation (AD) capabilities of the Julia ecosystem with
DFTK in order to compute stresses without implementing the derivatives
by hand. Instead we want to make DFTK suitable for AD, such that stresses
for our current (and future) DFT models can be computed automatically.
Being able to combine DFTK and AD would not only give us stresses,
but it would also pave the road for computing even more involved properties
using AD. In this final stage of the project it would be required to
AD through the whole of DFTK (including several layers of solvers).

**Project type:** Risky and exploratory (essentially a small research project)

**Level of difficulty:** Hard

**Recommended skills:** Interest to work on an multidisciplinary project
bordering physics, mathematics and computer science with a good
working knowledge of differential calculus and Julia.
Detailed knowledge in the physical background (electrostatics, material science)
or about automatic differentiation is not required,
but be prepared to take a closer look at these domains during the project.

**Expected results:** Use automatic differentiation to implement
stresses (derivatives of the total energy with respect to lattice
parameters) into DFTK.

**Mentors:** Keno Fischer, Michael F. Herbst, Antoine Levitt

**References:** For a nice intro to DFT and DFTK.jl see [Michael's talk
at JuliaCon 2020](https://www.youtube.com/watch?v=-RomkxjlIcQ) and the
literature given in the [DFTK
documentation](https://docs.dftk.org/stable/guide/density_functional_theory/).
A concise introduction into AD are [Antoine's notes on the adjoint
trick](http://antoine.levitt.fr/adjoint.pdf).

**Contact:** For any questions, feel free to email
[@mfherbst](https://github.com/mfherbst), [@antoine-levitt](https://github.com/antoine-levitt)
or write us on [our gitter chat](https://gitter.im/DFTK-jl/community).
