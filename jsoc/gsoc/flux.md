#  Machine Learning Projects - Summer of Code

### CUDA Hacking

Are you a performance nut? Help us implement cutting-edge CUDA kernels in Julia for operations important across deep learning, scientific computing and more. We also need help developing our wrappers for machine learning, sparse matrices and more, as well as CI and infrastructure. Contact us to develop a project plan.

Mentors: [Tim Besard](https://github.com/maleadt), [Mike Innes](https://github.com/MikeInnes).

### Reinforcement Learning Environments

Develop a series of reinforcement learning environments, in the spirit of the [OpenAI Gym](https://gym.openai.com). Although we have wrappers for the gym available, it is hard to install (due to the Python dependency) and, since it's written in Python and C code, we can't do more interesting things with it (such as differentiate through the environments). A pure-Julia version that supports a similar API and visualisation options would be valuable to anyone doing RL with Flux.

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/).

### NLP Tools and Models

Build deep learning models for Natural Language Processing in Julia. [TextAnalysis](https://github.com/juliatext/TextAnalysis.jl)  and [WordTokenizers](https://github.com/JuliaText/WordTokenizers.jl) contains the basic algorithms and data structures to work with textual data in Julia. On top of that base, we want to build modern deep learning models based on recent research. The following tasks can span multiple students and projects.

It is important to note that we want practical, usable solutions to be created, not just research models. This implies that a large part of the effort will need to be in finding and using training data, and testing the models over a wide variety of domains. Pre-trained models must be available to users, who should be able to start using these without supplying their own training data.

* Implement [ELMo](https://allennlp.org/elmo) in Julia
* Implement [ALBERT](https://ai.googleblog.com/2019/12/albert-lite-bert-for-self-supervised.html) in Julia
* Implement GPT/GPT-2 in Julia
* Implement [extractive summarisation based on Transformers](https://arxiv.org/abs/1909.03186)
* Implement practical models for
  * Dependency Tree Parsing  
  * Morphological extractions  
  * Translations (using Transformers)  
* Indic language support -- validate and test all models for Indic languages
  * ULMFiT models for Indic languages
* Chinese tokenisation and parsing

**Mentors**: [Avik Sengupta](https://github.com/aviks/)

### Automated music generation

Neural network based models can be used for music analysis and music generation (composition). A suite
of tools in Julia to enable research in this area would be useful. This is a large, complex project that
is suited for someone with an interest in music and machine learning. This project will need a mechanism
to read music files (primarily MIDI), a way to synthesise sounds, and finally a model to learn composition.
All of this is admittedly a lot of work, so the exact boundaries of the project can be flexible, but this can be an
exciting project if you are interested in both music and machine learning.

**Recommended Skills**: Music notation, some basic music theory, MIDI format, Transformer and LSTM architectures

**Resources**: [Music Transformer](https://magenta.tensorflow.org/music-transformer), [Wave2MIDI2Wave](https://magenta.tensorflow.org/maestro-wave2midi2wave)

**Mentors**: [Avik Sengupta](https://github.com/aviks/)

## Flux.jl

Flux usually takes part in [Google Summer of Code](https://summerofcode.withgoogle.com), as part of the wider Julia organisation. We follow the same [rules and application guidelines](/jsoc/projects/) as Julia, so please check there for more information on applying. Below are a set of ideas for potential projects (though you are welcome to explore anything you are interested in).

Flux projects are typically very competitive; we encourage you to get started early, as successful students typically have early PRs or working prototypes as part of the application. It is a good idea to simply start contributing via issue discussion and PRs and let a project grow from there; you can take a look at [this list of issues](https://github.com/FluxML/Flux.jl/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) for some starter contributions.

### Port ML Tutorials

There are many high-quality open-source tutorials and learning materials available, for example from PyTorch and fast.ai. We'd like to have Flux ports of these that we can add to the model zoo, and eventually publish to the Flux website.

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/).

### Port the Fast.ai book:"Deep Learning for Coders with fastai and PyTorch" to Julia

In this task, you will be porting the "Deep Learning for Coders with fastai and PyTorch" into Julia using Flux.jl

Experience with implementing machine learning and Julia's Flux.jl package are required in order to be successful on this project. You will also likley work with others in the community on this since it's a 19 chapter book. Feel free to check out the `#fast-ai-port` channel on Slack for more details.

Please post in the `#fast-ai-port` channel on Slack to get a preview of the book for a better idea of the projects scope.

### Differentiable Rendering [HARD]

Expected Outcome: This is motivated to create SoftRasterizer/DiB-R based projects. We already have RayTracer.jl which is motivated by OpenDR. (Of course, if someone wants to implement NERF - like models they are most welcome to submit a proposal). We would ideally target at least 2 of these models.

Skills: GPU Programming, Deep Learning, (deep) familiarity with the literature, familiarity with defining (a lot of) Custom Adjoints

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/), [Avik Pal](https://github.com/avik-pal)

### Core Development [MEDIUM]

Expected Outcomes:
* Some of the functions require custom adjoints for speedup
* Functions require GPU kernels. Some of these are of common interest to the community like -- knn, etc.
* Benchmarking with Tensorflow Graphics and Pytorch3D. We already have the scripts for kaolin, need to extend that.
* Most of these problems are listed as issues in the main repo.

Skills: GPU Programming, Deep Learning, familiarity with defining (a lot of) Custom Adjoints

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/)

### Differentiable Computer Vision [HARD]

Expected Outcome:

Create a library of utliity functions that can consume Julia's Imaging libraries to make them differentiable. With Zygote.jl, we have the platform to take a general purpose package and apply automatic differentiation to it. This project is motivated to use existing libraries that offer perform computer vision tasks, and augment them with AD to perform tasks such as homography regression.

Skills: Familiarity with automatic differentiation, deep learning, and defining (a lot of) Custom Adjoints

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/)
