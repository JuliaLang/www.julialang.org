# Dynamical systems, complex systems & nonlinear dynamics – Summer of Code


## Agents.jl

**Difficulty**: Easy to Medium.

[Agents.jl](https://juliadynamics.github.io/Agents.jl/stable/) is a pure Julia framework for agent-based modeling (ABM). 
It has an extensive list of features, excellent performance and is
easy to learn, use, and extend. Comparisons with other popular
frameworks written in Python or Java (NetLOGO, MASON, Mesa), show that
Agents.jl outperforms all of them in computational speed, list of features
and usability.

In this project students will be paired with lead developers of Agents.jl
to improve Agents.jl with more features, better performance, and overall higher polish.
Possible features to implement are:

@@tight-list
- File IO of current state of ABM to disk
- Reading lists of human data (e.g. csv files) into `Agent` instances.
- New type of space representing a planet, which can be used in climate policy or human evolution modelling
- Automatic performance increase of mixed-agent models by eliminating dynamic dispatch on the stepping function
- Port of Open Street Map plotting to Makie.jl.
- GPU support in Agents.jl
@@

**Recommended Skills**: Familiarity with agent based modelling, Agents.jl and Julia's Type System.
Background in complex systems, sociology, or nonlinear dynamics is not required.

**Expected Results**: Well-documented, well-tested useful new features for Agents.jl.

**Mentors**: [George Datseris](https://github.com/Datseris), [Tim DuBois](https://github.com/Libbum)


## DynamicalSystems.jl

**Difficulty:** Easy to Hard, depending on the algorithm chosen

[DynamicalSystems.jl](https://juliadynamics.github.io/DynamicalSystems.jl/latest/) is an [award-winning](https://dsweb.siam.org/The-Magazine/Article/winners-of-the-dsweb-2018-software-contest)
Julia software library for dynamical systems, nonlinear dynamics, deterministic chaos and nonlinear timeseries analysis.
It has an impressive list of features, but one can never have enough. In this project students will be able to
enrich DynamicalSystems.jl with new algorithms and enrich their knowledge of nonlinear dynamics and computer-assisted
exploration of complex systems.

Possible projects are summarized in the [wanted-features of the library](https://github.com/issues?q=is%3Aopen+is%3Aissue+repo%3AJuliaDynamics%2FChaosTools.jl+repo%3AJuliaDynamics%2FDynamicalSystemsBase.jl+repo%3AJuliaDynamics%2FDelayEmbeddings.jl+repo%3AJuliaDynamics%2FRecurrenceAnalysis.jl+repo%3AJuliaDynamics%2FDynamicalSystems.jl+label%3A%22wanted+feature%22+)

Examples include but are are not limited to:

@@tight-list
- Nonlinear local Lyapunov exponents
- Final state sensitivity and fractal basin boundaries
- Kolmogorov-Sinai entropy
- Importance sampling for chaotic systems
@@

and many more.


**Recommended Skills**: Familiarity with nonlinear dynamics and/or differential equations and the Julia language.

**Expected Results**: Well-documented, well-tested new algorithms for DynamicalSystems.jl.

**Mentors**: [George Datseris](https://github.com/Datseris)
