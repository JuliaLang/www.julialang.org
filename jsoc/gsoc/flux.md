#  Machine Learning Projects - Summer of Code

### CUDA Hacking

Are you a performance nut? Help us implement cutting-edge CUDA kernels in Julia for operations important across deep learning, scientific computing and more. We also need help developing our wrappers for machine learning, sparse matrices and more, as well as CI and infrastructure. Contact us to develop a project plan.

Mentors: [Tim Besard](https://github.com/maleadt), [Dhairya Gandhi](https://github.com/DhairyaLGandhi).

### Reinforcement Learning Environments

Develop a series of reinforcement learning environments, in the spirit of the [OpenAI Gym](https://gym.openai.com). Although we have wrappers for the gym available, it is hard to install (due to the Python dependency) and, since it's written in Python and C code, we can't do more interesting things with it (such as differentiate through the environments). A pure-Julia version that supports a similar API and visualisation options would be valuable to anyone doing RL with Flux.

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/).

### Reinforcement Learning Algorithms

Recent advances in reinforcement learning led to many breakthroughs in artificial intelligence. Some of the latest deep reinforcement learning algorithms have been implemented in [ReinforcementLearning.jl](https://github.com/JuliaReinforcementLearning/ReinforcementLearning.jl) with Flux. We'd like to have more interesting and practical algorithms added to enrich the whole community, including but not limited to the following directions:

* **[Easy] Recurrent version of existing algorithms**. Students with a basic understanding of Q-learning and recurrent neural networks are preferred. We'd like to have a general implementation to easily extend existing algorithms to the sequential version.
* **[Medium] Offline reinforcement learning algorithms**. A bunch of offline reinforcement learning algorithms are proposed in recent years, including [BCQ](https://arxiv.org/pdf/1910.01708.pdf), [CRR](https://arxiv.org/abs/2006.15134), [CQL](https://arxiv.org/abs/2006.04779) and so on. The expected output is to have some typical offline reinforcement learning algorithms and experiments added into [ReinforcementLearningZoo.jl](https://github.com/JuliaReinforcementLearning/ReinforcementLearningZoo.jl).
* **[Medium] Model-based reinforcement learning algorithms**. Students interested in this topic may refer [Model-based Reinforcement Learning: A Survey](https://arxiv.org/abs/2006.16712) and design some general interfaces to implement typical model based algorithms.
* **[Medium] Multi-agent reinforcement learning algorithms**. Currently, we only have some CFR related algorithms implemented. We'd like to have more implemented, including [MADDPG](https://arxiv.org/abs/1706.02275v4), [COMA](https://arxiv.org/abs/1705.08926), [NFSP](https://arxiv.org/abs/1603.01121), [PSRO](https://arxiv.org/abs/1711.00832).
* **[Hard] Distributed reinforcement learning framework**. Inspired by [Acme](https://arxiv.org/abs/2006.00979), a similar design is proposed in [DistributedReinforcementLearning.jl](https://github.com/JuliaReinforcementLearning/DistributedReinforcementLearning.jl). However, it is still in a very early stage. Students interested in this direction are required to have a basic understanding of distributed computing in Julia. Ideally we'd like to see some distributed reinforcement learning algorithms implemented under this framework, like [R2D2](https://openreview.net/forum?id=r1lyTjAqYX&utm_campaign=RL%20Weekly&utm_medium=email&utm_source=Revue%20newsletter), [D4PG](https://arxiv.org/abs/1804.08617v1).

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

## Flux.jl

Flux usually takes part in [Google Summer of Code](https://summerofcode.withgoogle.com), as part of the wider Julia organisation. We follow the same [rules and application guidelines](/jsoc/projects/) as Julia, so please check there for more information on applying. Below are a set of ideas for potential projects (though you are welcome to explore anything you are interested in).

Flux projects are typically very competitive; we encourage you to get started early, as successful students typically have early PRs or working prototypes as part of the application. It is a good idea to simply start contributing via issue discussion and PRs and let a project grow from there; you can take a look at [this list of issues](https://github.com/FluxML/Flux.jl/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) for some starter contributions.

### Port ML Tutorials

There are many high-quality open-source tutorials and learning materials available, for example from PyTorch and fast.ai. We'd like to have Flux ports of these that we can add to the model zoo, and eventually publish to the Flux website.

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/).

### FermiNets: Generative Synthesis for Automating the Choice of Neural Architectures

The application of machine learning requires an understanding a practitioner to optimize a neural architecture for a given problem, or does it? Recently techniques in automated machine learning, also known as AutoML, have dropped this requirement by allowing for good architectures to be found automatically. One such method is the [FermiNet](https://arxiv.org/abs/1809.05989) which employs generative synthesis to give a neural architecture which respects certain operational requirements. The goal of this project is to implement the FermiNet in Flux to allow for automated synthesis of neural networks.

Mentors: [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Dhairya Gandhi](https://github.com/DhairyaLGandhi/).

### Differentiable Rendering [HARD]

Expected Outcome: This is motivated to create SoftRasterizer/DiB-R based projects. We already have RayTracer.jl which is motivated by OpenDR. (Of course, if someone wants to implement NERF - like models they are most welcome to submit a proposal). We would ideally target at least 2 of these models.

Skills: GPU Programming, Deep Learning, (deep) familiarity with the literature, familiarity with defining (a lot of) Custom Adjoints

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/), [Julian Samaroo](https://github.com/jpsamaroo), [Avik Pal](https://github.com/avik-pal)

### Core Development [MEDIUM]

Expected Outcomes:
* Some of the functions require custom adjoints for speedup
* Functions require GPU kernels. Some of these are of common interest to the community like -- knn, etc.
* Benchmarking with Tensorflow Graphics and Pytorch3D. We already have the scripts for kaolin, need to extend that.
* Most of these problems are listed as issues in the main repo.

Skills: GPU Programming, Deep Learning, familiarity with defining (a lot of) Custom Adjoints

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/)

### FastAI.jl Development

**Difficulty:** Medium

In this project, you will assist the [ML community team](https://julialang.zulipchat.com/#narrow/stream/237432-ml-ecosystem-coordination) with building FastAI.jl on top of the existing JuliaML + FluxML ecosystem packages. The primary goal is to create an equivalent to [docs.fast.ai](https://docs.fast.ai). This will require building the APIs, documenting them, and creating the appropriate tutorials. Some familiarity with the following Julia packages is preferred, but it is not required:

@@tight-list
* [MLDataPattern.jl](https://github.com/JuliaML/MLDataPattern.jl.git)
* [FluxTraining.jl](https://github.com/lorenzoh/FluxTraining.jl.git)
* [DataAugmentation.jl](https://github.com/lorenzoh/DataAugmentation.jl)
@@

A stretch goal can include extending FastAI.jl beyond its Python-equivalent by leveraging the flexibility in the underlying Julia packages. For example, creating and designing abstractions for distributed data parallel training.

**Skills:** Familiarity with deep learning pipelines, common practices, Flux.jl, and MLDataPattern.jl

**Mentors:** [Kyle Daruwalla](https://github.com/darsnack)

### Differentiable Computer Vision [HARD]

Expected Outcome:

Create a library of utility functions that can consume Julia's Imaging libraries to make them differentiable. With Zygote.jl, we have the platform to take a general purpose package and apply automatic differentiation to it. This project is motivated to use existing libraries that offer perform computer vision tasks, and augment them with AD to perform tasks such as homography regression.

Skills: Familiarity with automatic differentiation, deep learning, and defining (a lot of) Custom Adjoints

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/)

## Deep Learning for source code analysis

**Difficulty**: Easy to Medium

The use of deep learning tools to source code is an active area of research. With the runtime being able to easily introspect into Julia code (for example, with a clean, accessible AST format), using theses techniques on Julia code would be a fruitful exercise.

@@tight-list
* Use of RNNs for syntax error correction: https://arxiv.org/abs/1603.06129
* Implement Code2Vec for Julia: https://arxiv.org/abs/1803.09473
@@

**Recommended Skills:** Familiarity with compiler techniques as well as deep learning tools will be required. The "domain expertise" in this task is Julia programming, so it will need someone who has a reasonable experience of the Julia programming language.

**Expected Outcome:**  Packages for each technique that is usable by general programmers.

**Mentors**: [Avik Sengupta](https://github.com/aviks/)
