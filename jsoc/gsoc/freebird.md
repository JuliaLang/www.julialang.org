# FreeBird.jl - Summer of Code

[FreeBird.jl](https://github.com/wexlergroup/FreeBird.jl) is a Julia package of enhanced sampling methods, such as nested sampling, Wang-Landau sampling, Metropolis Monte Carlo, for accelerating materials discovery through statistical mechanics. It is designed to be an extensible platform for computationally studying phase equilibria across a diverse range of atomistic and molecular systems, with easy extension to other phenomena.

## Molecular Dynamics Nested Sampling in FreeBird.jl with Molly.jl

**Difficulty**: Easy to medium

**Project size**: 175 hours

**Problem**: Nested sampling (NS) for materials is a novel computational algorithm that efficiently explores the phase space (position and momentum) and configuration space of an atomistic system, estimates partition function and detects phase transitions. The nested sampling algorithm requires continuous generation of new atomistic configurations under a monotonously decreasing energy limit. Currently in FreeBird.jl, it is done via a chian of Monte Carlo (MC) random walks. Molecular dynamics (MD) is a proven alternative to MC for a potentially better performance, especially when running on GPUs. In this project, we will integrate the Julia MD package, [Molly.jl](https://github.com/JuliaMolSim/Molly.jl), as the MD backend of NS in FreeBird.jl.

**Expected outcome**: 

- To implement an easy conversion between FreeBird.jl's walker system and Molly's atoms objects.
- To implement a dispatch of the NS function using Molly.jl's MD as a configuration generator.
- To enable MD-NS energy evaluations using classical and machine learning interatomic potentials, as well as force fields.
- To improve FreeBird.jl's test suits and documentations related to this project.

**Recommended skills**:

- Prior exposure or strong interest in computational chemistry and/or materials science
- Prior Julia coding experience

**Mentors**: [Ray Yang](https://github.com/yangmr04) (primary), [Joe Greener](https://github.com/jgreener64), [Robert Wexler](https://github.com/rwexler)

**Contact**: Feel free to reach out to Ray Yang via [email](mailto:my@ainest.ee), #juliamolsim on the Julia Slack, or at the JuliaMolSim [Zulip(https://juliamolsim.zulipchat.com)].