# Molecular Simulation - Summer of Code

Much of science can be explained by the movement and interaction of molecules. Molecular dynamics (MD) is a computational technique used to explore these phenomena, from noble gases to biological macromolecules. [Molly.jl](https://github.com/JuliaMolSim/Molly.jl) is a pure Julia package for MD, and for the simulation of physical systems more broadly. The package is currently under development with a focus on proteins and differentiable molecular simulation. There are a number of ways that the package could be improved:

- **Machine learning potentials (duration: 175h, expected difficulty: easy to medium):** in the last few years machine learning potentials have been improved significantly. Models such as ANI, ACE, NequIP and Allegro can be added to Molly.
- **Alchemical simulation features (duration: 175h, expected difficulty: medium):** binding free energy methods are now used routinely in drug discovery. Appropriate potentials and protocols could be added to Molly based on software like OpenFE.
- **Reactant compatibility (duration: 175h, expected difficulty: medium to hard):** Reactant.jl allows improved performance and Enzyme support. Molly could be made compatible with Reactant to access these features.

**Recommended skills:** familiarity with computational chemistry, structural bioinformatics or simulating physical systems.

**Expected results:** new features added to the package along with tests and relevant documentation.

**Mentor:** [Joe Greener](https://github.com/jgreener64)

**Contact:** feel free to ask questions via [email](http://jgreener64.github.io) or #juliamolsim on the [Julia Slack](https://join.slack.com/t/julialang/shared_invite/zt-2a5wdtotu-H52pQQTMDOa4NwsTSgQ_lQ).
