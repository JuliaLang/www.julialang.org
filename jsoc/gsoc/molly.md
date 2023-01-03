# Molecular Simulation - Summer of Code

Much of science can be explained by the movement and interaction of molecules. Molecular dynamics (MD) is a computational technique used to explore these phenomena, from noble gases to biological macromolecules. [Molly.jl](https://github.com/JuliaMolSim/Molly.jl) is a pure Julia package for MD, and for the simulation of physical systems more broadly. The package is currently under development for research with a focus on proteins and differentiable molecular simulation. There are a number of ways that the package could be improved:

- **Machine learning potentials (duration: 175h, expected difficulty: easy to medium):** in the last few years machine learning potentials have been improved significantly. Models such as ANI, ACE, NequIP and Allegro can be added to Molly.
- **Simulators (duration: 175h, expected difficulty: easy to medium):** a variety of standard approaches to simulating molecules can be added including FIRE minimisation, pressure coupling (NPT ensemble) and enhanced sampling approaches.
- **Constraint algorithms (duration: 175h, expected difficulty: medium):** many simulations keep fast degrees of freedom such as bond lengths and bond angles fixed using approaches such as SHAKE, RATTLE and SETTLE. A fast implementation of these algorithms would be a valuable contribution.
- **Electrostatic summation (duration: 175h, expected difficulty: medium to hard):** methods such as particle-mesh Ewald (PME) are in wide use for molecular simulation. Developing fast, flexible implementations and exploring compatibility with GPU acceleration and automatic differentiation would be an [important contribution](https://discourse.julialang.org/t/electrostatics-in-julia/41633).

**Recommended skills:** familiarity with computational chemistry, structural bioinformatics or simulating physical systems.

**Expected results:** new features added to the package along with tests and relevant documentation.

**Mentor:** [Joe Greener](https://github.com/jgreener64)

**Contact:** feel free to ask questions via [email](http://jgreener64.github.io) or the [JuliaMolSim Zulip](https://juliamolsim.zulipchat.com).
