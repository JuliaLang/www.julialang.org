#  Machine Learning Projects - Summer of Code

### CUDA Hacking

Are you a performance nut? Help us implement cutting-edge CUDA kernels in Julia for operations important across deep learning, scientific computing and more. We also need help developing our wrappers for machine learning, sparse matrices and more, as well as CI and infrastructure. Contact us to develop a project plan.

Mentors: [Tim Besard](https://github.com/maleadt), [Dhairya Gandhi](https://github.com/DhairyaLGandhi).

### Reinforcement Learning Environments

Develop a series of reinforcement learning environments, in the spirit of the [OpenAI Gym](https://gym.openai.com). Although we have wrappers for the gym available, it is hard to install (due to the Python dependency) and, since it's written in Python and C code, we can't do more interesting things with it (such as differentiate through the environments). A pure-Julia version that supports a similar API and visualisation options would be valuable to anyone doing RL with Flux.

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/).

### Reinforcement Learning Algorithms

Recent advances in reinforcement learning led to many breakthroughs in artificial intelligence. Some of the latest deep reinforcement learning algorithms have been implemented in [ReinforcementLearning.jl](https://github.com/JuliaReinforcementLearning/ReinforcementLearning.jl) with Flux. We'd like to have more interesting and practical algorithms added to enrich the whole community, including but not limited to the following directions:

* **[Easy(175h)] Recurrent version of existing algorithms**. Students with a basic understanding of Q-learning and recurrent neural networks are preferred. We'd like to have a general implementation to easily extend existing algorithms to the sequential version.
* **[Medium(175h)] Multi-agent reinforcement learning algorithms**. Currently, we only have some CFR， MADDPG and NFSP related algorithms implemented. We'd like to see more implemented, including [COMA](https://arxiv.org/abs/1705.08926) and its variants, [PSRO](https://arxiv.org/abs/1711.00832).
* **[Medium(350h)] Model-based reinforcement learning algorithms**. Students interested in this topic may refer [Model-based Reinforcement Learning: A Survey](https://arxiv.org/abs/2006.16712) and design some general interfaces to implement typical model based algorithms.
* **[Hard(350h)] Distributed reinforcement learning framework**. Inspired by [Acme](https://arxiv.org/abs/2006.00979), a similar design is proposed in [DistributedReinforcementLearning.jl](https://github.com/JuliaReinforcementLearning/DistributedReinforcementLearning.jl). However, it is still in a very early stage. Students interested in this direction are required to have a basic understanding of distributed computing in Julia. Ideally we'd like to see some distributed reinforcement learning algorithms implemented under this framework, like [R2D2](https://openreview.net/forum?id=r1lyTjAqYX&utm_campaign=RL%20Weekly&utm_medium=email&utm_source=Revue%20newsletter), [D4PG](https://arxiv.org/abs/1804.08617v1).

#### Expected Outcomes

For each new algorithm, at least two experiments are expected to be added into [ReinforcementLearningZoo.jl](https://github.com/JuliaReinforcementLearning/ReinforcementLearningZoo.jl). A simple one to make sure it works on some toy games with CPU only and another more practical one to produce comparable results on the original paper with GPU enabled. Besides, a technical report on the implementation details and speed/performance comparison with other baselines is preferred.

Mentors: [Jun Tian](https://github.com/findmyway)

### AlphaZero.jl

The philosophy of the [AlphaZero.jl](https://github.com/jonathan-laurent/AlphaZero.jl) project is to provide an implementation of AlphaZero that is simple enough to be widely accessible for students and researchers, while also being sufficiently powerful and fast to enable meaningful experiments on limited computing resources (our latest release is consistently between one and two orders of magnitude faster than competing Python implementations).

Here are a few project ideas that build on AlphaZero.jl. Please contact us for additional details and let us know about your experience and interests so that we can build a project that best suits your profile.

- [Easy] Integrate AlphaZero.jl with the [OpenSpiel](https://github.com/JuliaReinforcementLearning/OpenSpiel.jl) game library and benchmark it on a series of simple board games.
- [Medium] Use AlphaZero.jl to train a chess agent. In order to save computing resources and allow faster bootstrapping, you may train an initial policy using supervised learning.
- [Hard] Build on AlphaZero.jl to implement the [MuZero](https://deepmind.com/blog/article/muzero-mastering-go-chess-shogi-and-atari-without-rules) algorithm.
- [Hard] Explore applications of AlphaZero beyond board games (e.g. theorem proving, chip design, chemical synthesis...).

#### Expected Outcomes

In all these projects, the goal is not only to showcase the current Julia ecosystem and test its limits, but also to push it forward through concrete contributions that other people can build on. Such contributions include:

- Improvements to existing Julia packages (e.g. AlphaZero, ReinforcementLearning, CommonRLInterface, Dagger, Distributed, CUDA...) through code, documentation or benchmarks.
- A well-documented and replicable artifact to be added to [AlphaZero.Examples](https://github.com/jonathan-laurent/AlphaZero.jl/tree/master/games), [ReinforcementLearningZoo](https://github.com/JuliaReinforcementLearning/ReinforcementLearningZoo.jl) or released in its own package.
- A blog post that details your experience, discusses the challenges you went through and identifies promising areas for future work.

**Mentors**: [Jonathan Laurent](https://github.com/jonathan-laurent)

### NLP Tools and Models

**Difficulty**: Medium to Hard

Build deep learning models for Natural Language Processing in Julia. [TextAnalysis](https://github.com/juliatext/TextAnalysis.jl)  and [WordTokenizers](https://github.com/JuliaText/WordTokenizers.jl) contains the basic algorithms and data structures to work with textual data in Julia. On top of that base, we want to build modern deep learning models based on recent research. The following tasks can span multiple students and projects.

It is important to note that we want practical, usable solutions to be created, not just research models. This implies that a large part of the effort will need to be in finding and using training data, and testing the models over a wide variety of domains. Pre-trained models must be available to users, who should be able to start using these without supplying their own training data.

@@tight-list
* Implement GPT/GPT-2 in Julia
* Implement [extractive summarisation based on Transformers](https://arxiv.org/abs/1909.03186)
* Implement practical models for
  * Dependency Tree Parsing
  * Morphological extractions
  * Translations (using Transformers)
* Indic language support -- validate and test all models for Indic languages
  * ULMFiT models for Indic languages
* Chinese tokenisation and parsing
@@

**Mentors**: [Avik Sengupta](https://github.com/aviks/)

### Automated music generation

**Difficulty**: Hard

Neural network based models can be used for music analysis and music generation (composition). A suite
of tools in Julia to enable research in this area would be useful. This is a large, complex project that
is suited for someone with an interest in music and machine learning. This project will need a mechanism
to read music files (primarily MIDI), a way to synthesise sounds, and finally a model to learn composition.
All of this is admittedly a lot of work, so the exact boundaries of the project can be flexible, but this can be an
exciting project if you are interested in both music and machine learning.

**Recommended Skills**: Music notation, some basic music theory, MIDI format, Transformer and LSTM architectures

**Resources**: [Music Transformer](https://magenta.tensorflow.org/music-transformer), [Wave2MIDI2Wave](https://magenta.tensorflow.org/maestro-wave2midi2wave), [MIDI.jl](https://github.com/JuliaMusic/MIDI.jl), [Mplay.jl](https://github.com/JuliaMusic/Mplay.jl)

**Mentors**: [Avik Sengupta](https://github.com/aviks/)
