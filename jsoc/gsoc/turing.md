# Turing Projects - Summer of Code

[Turing.jl](https://turinglang.org/) is a universal probabilistic programming language embedded in Julia.
Turing allows the user to write statistical models in standard Julia syntax, and provides a wide range of sampling-based inference methods for solving problems across probabilistic machine learning, Bayesian statistics, and data science.
Since Turing is implemented in pure Julia code, its compiler and inference methods are amenable to hacking: new model families and inference methods can be easily added.

Below are the projects we have in mind for GSoC 2025. If you are interested in working on any of them, or want to propose your own Turing.jl-related GSoC project, please reach out to Markus Hauru (@mhauru) on Julia's [Slack](https://julialang.org/slack/) or [Discourse](https://discourse.julialang.org/).

## Mooncake.jl Performance Optimization

Difficulty: Medium

Duration: 350 hours

Description: [Mooncake.jl](https://github.com/compintell/Mooncake.jl/) is a reverse-mode AD package written entirely in Julia, which addresses many of limitations of the popular [ReverseDiff.jl](https://github.com/JuliaDiff/ReverseDiff.jl) and [Zygote.jl](https://github.com/FluxML/Zygote.jl) libraries.
While the library is typically fast, performance is not tested as systematically as it could be, meaning that there are probably a range of performance bugs waiting to be uncovered.
Additionally, there are a range of known performance limitations which need to be addressed.
This project aims to resolve known performance problems, to find new ones, and fix them too!

Skills: familiarity with Julia programming, how to make Julia code performant, and a strong desire to make existing Julia code more performant! An understanding of AD is helpful, but not essential.

## R and Python Interfaces for JuliaBUGS

Difficulty: Medium

Duration: 175 hours or 350 hours

[JuliaBUGS](https://github.com/TuringLang/JuliaBUGS.jl) is a Julia implementation of the [BUGS](https://en.wikipedia.org/wiki/WinBUGS) probabilistic programming language. It emphasizes interoperability and modularity. JuliaBUGS gives users familiar with BUGS access to Hamiltonian Monte Carlo (HMC), Automatic Differentiation (AD), and Julia’s powerful scientific computing tools. This Google Summer of Code (GSoC) project aims to create easy-to-use R and Python interfaces for JuliaBUGS.

Project Tasks:
* *Interface Design*: Develop R and Python packages similar to existing and widely used R packages like R2OpenBUGS and rjags, making it easy for users to adopt.
* *Interoperability Development*: Use Julia's existing packages ([JuliaCall](https://github.com/JuliaInterop/JuliaCall) and [PythonCall](https://github.com/JuliaPy/PythonCall.jl)) to create the interfaces. This will allow smooth data transfer and function calls between Julia, R, and Python.
* *Integration with Tools (Large Project)*: Integrate these new interfaces seamlessly with popular Bayesian visualization and diagnostics tools—such as bayesplot, posterior, and coda in R, and ArviZ in Python.
* *Documentation and Tutorials (Large Project)*: Create clear and practical documentation, including tutorials, to support users in understanding and effectively using the interfaces.

Participants will gain hands-on experience in Bayesian statistics, software engineering, computational methods, and developing software that works across multiple programming languages. This will prepare them well for future academic and professional opportunities.

## Jaxprs in Julia

Difficulty: Hard

Duration: TBD

The Turing.jl team is looking for a student to implement a lightweight Julia library to work with [Jaxprs](https://docs.jax.dev/en/latest/jaxpr.html). If this could be you, get in touch and we can discuss the details.
