---
layout: default
title: Machine Learning General Projects – Summer of Code
---

{% include toc.html %}

## Torch.jl

The [Torch](https://github.com/torch/torch7) library provides a fast implementation of N-dimensional arrays which can run on the CPU or GPU. This has been used to build popular machine learning libraries in Lua (torch itself) and Python (via [PyTorch](http://pytorch.org/)). Wrapping Torch in Julia would be a great way to get general GPU acceleration of Julia code, and could also be integrated with higher-level Julia ML libraries like Knet, ReverseDiff and Flux.

**Expected Results**: A Julia package wrapping the Torch C library.

**Recommended Skills**: Knowledge of Julia's C FFI and calling C code.

**Mentors**: Mike Innes, Pontus Stenetorp

## Data loading and training processes for Flux.jl

Currently [Flux](https://github.com/MikeInnes/Flux.jl) best supports a basic (stochastic) gradient descent training process. This project would involve implementing other optimisers like ADAM in the library, as well as extending the training processes to carry out user-configurable analysis or reporting during training.

**Expected Results**: New optimisers for the Flux library.

**Recommended Skills**: Familiarity with neural networks.

**Mentors**: Mike Innes

## Model Loading for Flux.jl

It would be useful to load existing trained models created with other frameworks – say Caffe, TensorFlow or MXNet – into Flux. This project would involve investigating the model formats and building readers so that those models can be run in native Julia.

**Expected Results**: A package which can load external model files into Flux data structures.

**Recommended Skills**: Familiarity with neural network libraries.

**Mentors**: Mike Innes

## GPUArrays

### Integration with existing GPU libraries

In GPUArrays we don't want to reinvent the wheel and leverage the great power of CU/CL - BLAS ( or even CU/CL - FFT).
Fortunately, Julia's abstract array interface makes it fairly straightforward to integrate these libraries in a natural way, since Julia already has OpenBLAS deeply integrated in the base array abstraction.
We have a basic strategy laid out for the integration and can mentor someone who is willing to write the it!

### JIT compiling GPU Code

GPUArrays heavily relies on just in time compilation of high performance kernels on the arrays. 
The foundation for this is already part of GPUArrays in form of a basic map/reduce/broadcast implementation, using a Transpiler and CUDAnative.
What we now need is a lot of tests, improvements to the compiler/transpiler, benchmarks and fine tuning the performance of our kernels.
Someone who is more experienced in writing GPU kernels is also welcome to enrich GPUArrays with the implementation of more advanced kernels, e.g.
tiled iterations, filtering primitives, moving windows, etc.

**Mentors**: Simon Danisch

## Standardized dataset packaging

Scientific and technical computing often makes use of publicly available datasets. Often, there's a lot of overhead to finding these data sets and coercing them into a usable format. Packages like [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl/) and [MNIST.jl](https://github.com/johnmyleswhite/MNIST.jl) attempt to make this easier by downloading data automatically and providing it as a Julia data structure.

This project involves building a "[BinDeps.jl](https://github.com/JuliaLang/BinDeps.jl) for data" which would make the creation of data-providing packages easier. The package would make it easy to download / unzip large files and check their integrity them in a cross-platform way. Facilities for downloading specific datasets can then be built on top of this.

**Expected Results**: A BinDeps-like package for downloading and managing data, as well as examples of this package used with specific data sets.

**Recommended Skills**: Only standard programming skills are needed for this project. Familiarity with Julia is a plus.

**Mentors**: [JuliaML Members](https://github.com/orgs/JuliaML/people)
