---
layout: single
title:  Turing Projects – Summer of Code
---

# {{< get_param title >}}

[Turing](http://turing.ml/) is a universal probabilistic programming language embedded in Julia. Turing allows the user to write models in standard Julia syntax, and provide a wide range of sampling-based inference methods for solving problems across probabilistic machine learning, Bayesian statistics and data science etc. Since Turing is implemented in pure Julia code, its compiler and inference methods are amendable for hacking: new model families and inference methods can be easily added. Below is a list of ideas for potential projects, though you are welcome to propose your own to the Turing team.

Project mentors are [Hong Ge](https://github.com/yebai), [Cameron Pfiffer](https://github.com/cpfiffer), [Martin Trapp](https://github.com/trappmartin), [Will Tebbutt](https://github.com/willtebbutt), [Mohamed Tarek](https://github.com/mohamed82008) and [Kai Xu](https://github.com/xukai92).

## Probabilistic modelling: model zoo & data science workflow with Turing.jl

This project would involve implementing a model zoo for Turing, either by porting examples from another probabilistic programming language (like Stan, PyMC3) or implementing new models devised by students together with his/her mentor. We suggest that student starts with porting existing models from other PPLs and then implement more complicated models they are particularly interested in.
Students are encouraged to write models in the format of [tutorials](https://github.com/TuringLang/TuringTutorials), which would illustrate data pre-processing, designing models, performing inference, and visualising results using Turing.jl.

**Recommended Skills**: A basic understanding of probabilistic machine learning and Julia.

**Expected Outcomes**: A model zoo for Turing.

## Probabilistic programming: Gaussian process (GP) integration between Turing.jl and Stheno.jl

GPs are flexible Bayesian models for functions. They can be used to solve nonlinear regression and classification tasks and, more generally, can be used as useful building blocks in any probabilistic models. They are special / unusual in that they have particularly nice computational properties which makes inference easy.
[Stheno.jl](https://github.com/willtebbutt/Stheno.jl) is a probabilistic programming framework specialised to Gaussian Processes (GPs) which is designed to make it completely straightforward to construct complicated GP models, perform inference and learning in them and their parameters, and to make their interpretation straightforward.
While Stheno has been designed with Turing compatibility in mind, some work is required to make embedding Stheno models inside Turing models completely seamless.

**Recommended Skills**: A basic understanding of probabilistic machine learning and Julia. Some knowledge of Gaussian processes would be helpful, but can be learned over the course of the project.

**Expected Outcomes**: Integration of [Turing.jl](http://turing.ml/) and [Stheno.jl](https://github.com/willtebbutt/Stheno.jl) with a collection of example models and notebooks in Turing's model zoo and tutorials.
