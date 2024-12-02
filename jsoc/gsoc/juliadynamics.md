# Dynamical systems, complex systems & nonlinear dynamics – Summer of Code


## Agents.jl

**Difficulty**: Medium to Hard.

**Length**: 175 to 350 hours depending on the project.

[Agents.jl](https://juliadynamics.github.io/Agents.jl/stable/) is a pure Julia framework for agent-based modeling (ABM). 
It has an extensive list of features, excellent performance and is
easy to learn, use, and extend. Comparisons with other popular
frameworks written in Python or Java (NetLOGO, MASON, Mesa), show that
Agents.jl outperforms all of them in computational speed, list of features
and usability.

In this project, contributors will be paired with lead developers of Agents.jl
to improve Agents.jl with more features, better performance, and overall higher polish.
We are open to discuss with potential candidate a project description and outline for it!

Possible features to implement are:

@@tight-list
- GPU and/or HPC support in Agents.jl by integrating existing ABM packages (Vanaha.jl or CellBasedModels.jl) into Agents.jl API.
- Integrating Agents.jl with ReinforcementLearning.jl
- Differentiation / parameter fitting of ABMs in Agents.jl by utilizing StochasticAD.jl or similar frameworks. 
@@

**Pre-requisite**: Having already contributed to a Julia package either in JuliaDynamics or of sufficient relevance to JuliaDynamics.

**Recommended Skills**: Familiarity with agent based modelling, Agents.jl and Julia's Type System, 
and achieving high-end computational performance within Julia.
Research background in complex systems, sociology, agent based modelling, or nonlinear dynamics is not required but would be advantageous.

**Expected Results**: Well-documented, well-tested useful new features for Agents.jl.

**Mentors**: [George Datseris](https://github.com/Datseris).


## DynamicalSystems.jl

**Difficulty:** Easy to Medium to Hard, depending on the project.

**Length**: 175 to 350 hours, depending on the project.

[DynamicalSystems.jl](https://juliadynamics.github.io/DynamicalSystems.jl/latest/) is an [award-winning](https://dsweb.siam.org/The-Magazine/Article/winners-of-the-dsweb-2018-software-contest)
Julia software library for dynamical systems, nonlinear dynamics, deterministic chaos, and nonlinear time series analysis.
It has an impressive list of features, but one can never have enough. In this project, contributors will be able to
enrich DynamicalSystems.jl with new algorithms and enrich their knowledge of nonlinear dynamics and computer-assisted
exploration of complex systems.

Here is a list of high-impact, Hard (350 hours) projects that we want to prioritize.

@@tight-list
- Local and global continuation in dynamical systems combined in one.
  This will be a ground-breaking feature, combining cutting edge research on multistable dynamical systems with the
  established bifurcation-continuation analysis.
@@

Other than that, we do not outline more possible projects here, and instead we invite interested candidates 
to explore the documentation and list of open features of any of the subpackages of DynamicalSystems.jl.
Then the candidates can reach out to one of the developers of the subpackage to devise a project outline.
We strongly welcome candidates that already have potential project ideas in mind already irrespectively of the open list of issues.

**Pre-requisite**: Having already contributed to a Julia package either in JuliaDynamics or of sufficient relevance to JuliaDynamics.

**Recommended Skills**: Familiarity with nonlinear dynamics and/or differential equations and/or timeseries analysis based on the Julia language.

**Expected Results**: Well-documented, well-tested new algorithms for DynamicalSystems.jl.

**Mentors**: [George Datseris](https://github.com/Datseris)
