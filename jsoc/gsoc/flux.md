# FluxML Projects - Summer of Code

Flux usually takes part in [Google Summer of Code](https://summerofcode.withgoogle.com) as a NumFocus organization. We follow the same [rules and application guidelines](/jsoc/projects/) as Julia, so please check there for more information on applying. Below are a set of ideas for potential projects (though you are welcome to explore anything you are interested in).

Flux projects are typically very competitive; we encourage you to get started early, as successful contributors typically have early PRs or working prototypes as part of the application. It is a good idea to simply start contributing via issue discussion and PRs and let a project grow from there; you can take a look at [this list of issues](https://github.com/FluxML/Flux.jl/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) for some starter contributions.

### Metalhead.jl Developement

**Difficulty:** Medium

Help us improve [Metalhead.jl](https://github.com/FluxML/Metalhead.jl) by adding new models, porting pre-trained weights, and extending the model interfaces to make them more customizable.

**Skills:** Familiarity with vision model architectures and Flux.jl

**Mentors:** [Kyle Daruwalla](https://github.com/darsnack)

### FastAI.jl Time Series Development

**Difficulty:** Medium

In this project, you will assist the [ML community team](https://julialang.zulipchat.com/#narrow/stream/237432-ml-ecosystem-coordination) with building time series methods for FastAI.jl on top of the existing JuliaML + FluxML ecosystem packages. This will require building the models/learners, documenting them, and creating the appropriate tutorials. Some familiarity with the following Julia packages is preferred, but it is not required:

@@tight-list
* [MLDataPattern.jl](https://github.com/JuliaML/MLDataPattern.jl.git)
* [FluxTraining.jl](https://github.com/lorenzoh/FluxTraining.jl.git)
* [DataAugmentation.jl](https://github.com/lorenzoh/DataAugmentation.jl)
@@

**Skills:** Familiarity with deep learning pipelines, common practices, Flux.jl, and recurrent neural networks

**Mentors:** [Lorenz Ohly](https://github.com/lorenzoh), [Kyle Daruwalla](https://github.com/darsnack), [Brian Chen](https://github.com/ToucheSir)

### FastAI.jl Text Development

**Difficulty:** Medium

In this project, you will assist the [ML community team](https://julialang.zulipchat.com/#narrow/stream/237432-ml-ecosystem-coordination) with building text methods for FastAI.jl on top of the existing JuliaML + FluxML ecosystem packages. This will require building the models/learners, documenting them, and creating the appropriate tutorials. Some familiarity with the following Julia packages is preferred, but it is not required:

@@tight-list
* [MLDataPattern.jl](https://github.com/JuliaML/MLDataPattern.jl.git)
* [FluxTraining.jl](https://github.com/lorenzoh/FluxTraining.jl.git)
* [JuliaText](https://github.com/JuliaText)
@@

**Skills:** Familiarity with deep learning pipelines, common practices, Flux.jl, and JuliaText

**Mentors:** [Lorenz Ohly](https://github.com/lorenzoh), [Kyle Daruwalla](https://github.com/darsnack), [Brian Chen](https://github.com/ToucheSir)

### Differentiable Computer Vision [HARD]

Expected Outcome:

Create a library of utility functions that can consume Julia's Imaging libraries to make them differentiable. With Zygote.jl, we have the platform to take a general purpose package and apply automatic differentiation to it. This project is motivated to use existing libraries that offer perform computer vision tasks, and augment them with AD to perform tasks such as homography regression.

Skills: Familiarity with automatic differentiation, deep learning, and defining (a lot of) Custom Adjoints

Mentors: [Dhairya Gandhi](https://github.com/DhairyaLGandhi/)

### FermiNets: Generative Synthesis for Automating the Choice of Neural Architectures

**Difficulty:** Hard

The application of machine learning requires an understanding a practitioner to optimize a neural architecture for a given problem, or does it? Recently techniques in automated machine learning, also known as AutoML, have dropped this requirement by allowing for good architectures to be found automatically. One such method is the [FermiNet](https://arxiv.org/abs/1809.05989) which employs generative synthesis to give a neural architecture which respects certain operational requirements. The goal of this project is to implement the FermiNet in Flux to allow for automated synthesis of neural networks.

**Mentors:** [Chris Rackauckas](https://github.com/ChrisRackauckas) and [Dhairya Gandhi](https://github.com/DhairyaLGandhi/)

### Differentiable Rendering [HARD]

Expected Outcome: This is motivated to create SoftRasterizer/DiB-R based projects. We already have RayTracer.jl which is motivated by OpenDR. (Of course, if someone wants to implement NERF - like models they are most welcome to submit a proposal). We would ideally target at least 2 of these models.

**Skills:** GPU Programming, Deep Learning, (deep) familiarity with the literature, familiarity with defining (a lot of) Custom Adjoints

**Mentors:** [Dhairya Gandhi](https://github.com/DhairyaLGandhi/), [Julian Samaroo](https://github.com/jpsamaroo), [Avik Pal](https://github.com/avik-pal)

## Deep Learning for source code analysis

**Difficulty**: Easy to Medium

The use of deep learning tools to source code is an active area of research. With the runtime being able to easily introspect into Julia code (for example, with a clean, accessible AST format), using theses techniques on Julia code would be a fruitful exercise.

@@tight-list
* Use of RNNs for syntax error correction: https://arxiv.org/abs/1603.06129
* Implement Code2Vec for Julia: https://arxiv.org/abs/1803.09473
@@

**Skills:** Familiarity with compiler techniques as well as deep learning tools will be required. The "domain expertise" in this task is Julia programming, so it will need someone who has a reasonable experience of the Julia programming language.

**Expected Outcome:**  Packages for each technique that is usable by general programmers.

**Mentors**: [Avik Sengupta](https://github.com/aviks/)
