#  Machine Learning Projects - Summer of Code

### CUDA Hacking

Time: 175h

Are you a performance nut? This project is aimed at expanding our coverage of high performance kernels and libraries widely used across machine learning workflows. 

#### Expected Outcomes

Help us implement cutting-edge CUDA kernels in Julia for operations important across deep learning, scientific computing and more. We also need help developing our wrappers for machine learning, sparse matrices and more, as well as CI and infrastructure. Contact us to develop a project plan.

Mentors: [Tim Besard](https://github.com/maleadt), [Dhairya Gandhi](https://github.com/DhairyaLGandhi).

### Reinforcement Learning Environments

Time: 175h

Develop a series of reinforcement learning environments, in the spirit of the [OpenAI Gym](https://gym.openai.com). Although we have wrappers for the gym available, it is hard to install (due to the Python dependency) and, since it's written in Python and C code, we can't do more interesting things with it (such as differentiate through the environments).

#### Expected Outcome

A pure-Julia version of selected environments that supports a similar API and visualisation options would be valuable to anyone doing RL with Flux.

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/).

### AlphaZero.jl

The philosophy of the [AlphaZero.jl](https://github.com/jonathan-laurent/AlphaZero.jl) project is to provide an implementation of AlphaZero that is simple enough to be widely accessible for contributors and researchers, while also being sufficiently powerful and fast to enable meaningful experiments on limited computing resources (our latest release is consistently between one and two orders of magnitude faster than competing Python implementations).

Here are a few project ideas that build on AlphaZero.jl. Please contact us for additional details and let us know about your experience and interests so that we can build a project that best suits your profile.

- [Easy (175h)] Integrate AlphaZero.jl with the [OpenSpiel](https://github.com/JuliaReinforcementLearning/OpenSpiel.jl) game library and benchmark it on a series of simple board games.
- [Medium (175h)] Use AlphaZero.jl to train a chess agent. In order to save computing resources and allow faster bootstrapping, you may train an initial policy using supervised learning.
- [Hard (350h)] Build on AlphaZero.jl to implement the [MuZero](https://deepmind.com/blog/article/muzero-mastering-go-chess-shogi-and-atari-without-rules) algorithm.
- [Hard (350h)] Explore applications of AlphaZero beyond board games (e.g. theorem proving, chip design, chemical synthesis...).

#### Expected Outcomes

In all these projects, the goal is not only to showcase the current Julia ecosystem and test its limits, but also to push it forward through concrete contributions that other people can build on. Such contributions include:

- Improvements to existing Julia packages (e.g. AlphaZero, ReinforcementLearning, CommonRLInterface, Dagger, Distributed, CUDA...) through code, documentation or benchmarks.
- A well-documented and replicable artifact to be added to [AlphaZero.Examples](https://github.com/jonathan-laurent/AlphaZero.jl/tree/master/games), [ReinforcementLearningZoo](https://github.com/JuliaReinforcementLearning/ReinforcementLearningZoo.jl) or released in its own package.
- A blog post that details your experience, discusses the challenges you went through and identifies promising areas for future work.

**Mentors**: [Jonathan Laurent](https://github.com/jonathan-laurent)
