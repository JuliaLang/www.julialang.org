# Taija Projects

[Taija](https://github.com/JuliaTrustworthyAI) is an organization that hosts software geared towards Trustworthy Artificial Intelligence in Julia. Taija currently covers a range of approaches towards making AI systems more trustworthy:

- Model Explainability ([CounterfactualExplanations.jl](https://github.com/JuliaTrustworthyAI/CounterfactualExplanations.jl))
- Algorithmic Recourse ([CounterfactualExplanations.jl](https://github.com/JuliaTrustworthyAI/CounterfactualExplanations.jl), [AlgorithmicRecourseDynamics.jl](https://github.com/JuliaTrustworthyAI/AlgorithmicRecourseDynamics.jl))
- Predictive Uncertainty Quantification ([ConformalPrediction.jl](https://github.com/JuliaTrustworthyAI/ConformalPrediction.jl), [LaplaceRedux.jl](https://github.com/JuliaTrustworthyAI/LaplaceRedux.jl))
- Effortless Bayesian Deep Learning ([LaplaceRedux.jl](https://github.com/JuliaTrustworthyAI/LaplaceRedux.jl))
- Hybrid Learning ([JointEnergyModels.jl](https://github.com/JuliaTrustworthyAI/JointEnergyModels.jl))

Various meta packages can be used to extend the core functionality:

- Plotting ([TaijaPlotting.jl](https://github.com/JuliaTrustworthyAI/TaijaPlotting.jl))
- Datasets for testing and benchmarking ([TaijaData.jl](https://github.com/JuliaTrustworthyAI/TaijaData.jl))
- Interoperability with other programming languages ([TaijaInteroperability.jl](https://github.com/JuliaTrustworthyAI/TaijaInteroperability.jl))

There is a high overlap with organizations, you might be also interested in:
- [Projects with MLJ.jl](https://julialang.org/jsoc/gsoc/MLJ/) - For more traditional machine learning projects
- [Projects with FluxML](https://fluxml.ai/gsoc/) - For projects around Flux.jl, the backbone of Julia's deep learning ecosystem

## Project 1: Conformal Prediction meets Bayes (*Predictive Uncertainty*)

**Project Overview:** [ConformalPrediction.jl](https://github.com/JuliaTrustworthyAI/ConformalPrediction.jl) is a package for Predictive Uncertainty Quantification through Conformal Prediction for Machine Learning models trained in MLJ. This project aims to enhance ConformalPrediction.jl by adding support for [Conformal(ized) Bayes](https://github.com/JuliaTrustworthyAI/ConformalPrediction.jl/issues/64). 

**Mentor:** [Patrick Altmeyer](https://github.com/pat-alt) and/or [Mojtaba Farmanbar](https://nl.linkedin.com/in/mfarmanbar)

**Project Difficulty**: Medium

**Estimated Duration**: 175 hours

**Ideal Candidate Profile:**
- Basic knowledge of Julia or strong knowledge of similar programming languages (R, Python, MATLAB, ...)
- Good understanding of Bayesian methods
- Basic knowledge of Conformal Prediction

**Project Goals and Deliverables:**
- Implement support for conformalizing predictive distributions ([#109](https://github.com/JuliaTrustworthyAI/ConformalPrediction.jl/issues/109))
- Implement support for Conformal Bayes through Add-One-In Importance Sampling ([#110](https://github.com/JuliaTrustworthyAI/ConformalPrediction.jl/issues/110))
- Implement other recent approaches combining Bayes with Conformal Prediction that you find interesting
- Comprehensively test and document your work

## Project 2: Counterfactual Regression (*Model Explainability*)

**Project Overview:** [CounterfactualExplanations.jl](https://github.com/JuliaTrustworthyAI/CounterfactualExplanations.jl) is a package for Counterfactual Explanations and Algorithmic Recourse in Julia. This project aims to extend the package functionality to [regression models](https://github.com/JuliaTrustworthyAI/CounterfactualExplanations.jl/issues/388). 

**Mentor:** [Patrick Altmeyer](https://github.com/pat-alt)

**Project Difficulty**: Hard

**Estimated Duration**: 350 hours

**Ideal Candidate Profile:**
- Experience with Julia and multiple dispatch of advantage, but not crucial
- Good knowledge of machine learning and statistics
- Solid understanding of supervised models (classification and regression)

**Project Goals and Deliverables:**
- Carefully think about architecture choices: how can we fit support for regression models into the existing code base?
- Add support for the following approaches: [ad-hoc thresholding](https://github.com/JuliaTrustworthyAI/CounterfactualExplanations.jl/issues/391), [Bayesian optimisation](https://github.com/JuliaTrustworthyAI/CounterfactualExplanations.jl/issues/392), [information-theoretic saliency](https://openreview.net/forum?id=IrEYkhuxup&noteId=IrEYkhuxup).
- Comprehensively test and document your work
  
## Project 3: Counterfactuals for LLMs (*Model Explainability* and *Generative AI*)

**Project Overview:** This project aims to extend the functionality of [CounterfactualExplanations.jl](https://github.com/JuliaTrustworthyAI/CounterfactualExplanations.jl) to Large Language Models (LLMs). As a backbone for this, support for computing feature attributions for LLMs will also need to be implemented. The project will contribute to both [Taija](https://github.com/JuliaTrustworthyAI) and [JuliaGenAI](https://github.com/JuliaGenAI). 

**Mentor:** [Patrick Altmeyer](https://github.com/pat-alt) (Taija) and [Jan Siml](https://github.com/svilupp)  (JuliaGenAI)

**Project Difficulty**: Medium

**Estimated Duration**: 175 hours

**Ideal Candidate Profile:**
- Experience with Julia and multiple dispatch of advantage, but not crucial
- Good knowledge of machine learning and statistics
- Good understanding of Large Language Models (LLMs)
- Ideally previous experience with [Transformers.jl](https://github.com/chengchingwen/Transformers.jl)

**Project Goals and Deliverables:**
- Carefully think about architecture choices: how can we fit support for LLMs into the existing code base of [CounterfactualExplanations.jl](https://github.com/JuliaTrustworthyAI/CounterfactualExplanations.jl)?
- Implement current state-of-the-art approaches such as [MiCE](https://aclanthology.org/2021.findings-acl.336.pdf) and [CORE](https://aclanthology.org/2022.findings-emnlp.216.pdf)
- Comprehensively test and document your work

## Project 4: From Counterfactuals to Interventions (Recourse through Minimal Causal Interventions)

**Project Overview:**
This extension aims to enhance the CounterfactualExplanations.jl package by incorporating a module for generating actionable recourse through minimal causal interventions.

**Mentor:** [Patrick Altmeyer](https://github.com/pat-alt) (Taija) and [Moritz Schauer](https://github.com/mschauer) (CausalInference.jl)

**Project Difficulty:** Hard

**Estimated Duration:** 350 hours

**Ideal Candidate Profile:**
- Experience with Julia
- Background in causality and familiarity with counterfactual reasoning.
- Basic knowledge of minimal interventions and causal graph building.
  
**Project Goals and Deliverables:**
- Carefully think about architecture choices: how can we fit support for causal interventions into the existing code base?
- Develop code that could integrate causal graph building with other Julia libs such as [Graphs.jl](https://github.com/JuliaGraphs/Graphs.jl), [GraphPlot.jl](https://juliagraphs.org/GraphPlot.jl/) and [CausalInference.jl](https://github.com/mschauer/CausalInference.jl).
- Implement current state-of-the-art approaches for minimal interventions using structured causal models (SCMs).
- Comprehensively test and document your work.

## About Us

[Patrick Altmeyer](https://www.paltmeyer.com/) is a PhD Candidate in Trustworthy Artificial Intelligence at Delft University of Technology working on the intersection of Computer Science and Finance. He has presented work related to Taija at JuliaCon 2022 and 2023. In the past year, Patrick has mentored multiple groups of students at Delft University of Technology who have made major contributions to Taija. 

## How to Contact Us

We'd love to hear your ideas and discuss potential projects with you.

Probably the easiest way is to join our [JuliaLang Slack](https://julialang.org/slack/) and join the `#taija` channel. You can also post a GitHub Issue on our organization [repo](https://github.com/JuliaTrustworthyAI/.github/issues).

[![Taija Logo](https://raw.githubusercontent.com/TrustworthyAIJulia/.github/main/profile/www/wide_logo.png)](https://github.com/JuliaTrustworthyAI)

