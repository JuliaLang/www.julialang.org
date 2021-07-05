# GSOC projects

# 2021 Ideas

# Titles & possible mentors

* [Particle swarm optimization of machine learning models](#Particle-swarm-optimization-of-machine-learning-models)
* [In-processing methods for fairness in machine learning](#In-processing-methods-for-fairness-in-machine-learning)
* [Causal and counterfactual methods for fairness in machine learning](#Causal-and-counterfactual-methods-for-fairness-in-machine-learning)
* [Time series forecasting at scale - speed up via Julia](#Time-series-forecasting-at-scale---speed-up-via-Julia)
* [Interpretable Machine Learning in Julia](#Interpretable-Machine-Learning-in-Julia)
* [Model visualization in MLJ](#Model-visualization-in-MLJ)
* [Deeper integration with Bayesian methods and Bayesian Stacking](#Deeper-Bayes)
* [MLJ and MLFlow integration](#MLJ-and-MLFlow-integration)
* [Speed demons only need apply](#Speed-demons-only-need-apply)

# MLJ Projects – Summer of Code

[MLJ](https://github.com/alan-turing-institute/MLJ.jl) is a machine learning framework for Julia aiming to provide a convenient way to use and combine a multitude of tools and models available in the Julia ML/Stats ecosystem.

MLJ is released under the MIT license and sponsored by the Alan Turing Institute.

## Particle swarm optimization of machine learning models

Bring particle swarm optimization to the MLJ machine learning
platform to help users tune machine learning models.

**Difficulty.** Easy - moderate.

### Description

Imagine your search for the optimal machine learning model as the
meandering flight of a bee through hyper-parameter space, looking for
a new home for the queen.  Parallelize your search, and you've created
a swarm of bees. Introduce communication between the bees about their
success so far, and you introduce the possibility of the bees
ultimately converging on good candidate for the best model.

PSO (particle swarm optimization) is a large, promising, and active
area of research, but also one that is used in real data science
practice. The method is based on a very simple idea inspired by nature
and makes essentially no assumptions about the nature of the cost
function (unlike other methods, such as gradient descent, which might
require a handle on derivatives). The method is
simple to implement, and applicable to a wide
range of hyper-parameter optimization problems.

**Mentors.** [Anthony Blaom](https://ablaom.github.io), [Sebastian Vollmer](https://www.turing.ac.uk/people/programme-directors/sebastian-vollmer)

### Prerequisites
@@tight-list
- Julia language fluency essential.
- Git-workflow familiarity strongly preferred.
- Some prior contact with optimization algorithms of some kind
- A passing familiarity with machine learning goals and workflow preferred
@@

### Your contribution

The aim of this project is to implement one or more variants of PSO
algorithm, for use in the MLJ machine learning platform, for the purpose of optimizing hyper-parameters. *Integration* with MLJ is crucial, so there will be opportunity to spend time familiarizing yourself with this popular tool.

Specifically, you will:
- familiarize yourself with the training, evaluation and tuning of machine learning models in MLJ
- learn about the PSO algorithm and its variants, conducting a short survey of some of the literature and existing implementations in Julia and other languages, and preparing a short summary
- familiarize yourself intimately with the  [MLJ tuning
API](https://github.com/alan-turing-institute/MLJTuning.jl#how-do-i-implement-a-new-tuning-strategy)
- implement a simple PSO variant, complete with testing and documentation
- experiment with the variant to learn more about its shortcomings and advantages, help recommend default parameter settings
- add variants, as time permits

### References
- [Wiki entry on PSO](https://en.wikipedia.org/wiki/Particle_swarm_optimization)
- [Zhang et al. (2015): A Comprehensive Survey on Particle Swarm Optimization Algorithm and Its Applications](https://www.hindawi.com/journals/mpe/2015/931256/)
- [Elbes et al. (2015): A survey on particle swarm optimization with emphasis on engineering and network applications](https://link.springer.com/article/10.1007/s12065-019-00210-z)
- [The MLJ tuning API](https://github.com/alan-turing-institute/MLJTuning.jl#how-do-i-implement-a-new-tuning-strategy)




## In-processing methods for fairness in machine learning

Mentors: [Jiahao Chen](https://jiahao.github.io/), [Moritz Schauer](https://github.com/mschauer), and [Sebastian Vollmer](https://www.turing.ac.uk/people/programme-directors/sebastian-vollmer)

[Fairness.jl](https://github.com/ashryaagr/Fairness.jl) is a package to audit and mitigate bias, using the MLJ machine learning framework and other tools. It has implementations of some preprocessing and postprocessing methods for improving fairness in classification models, but could use more implementations of other methods, especially inprocessing algorithms like adversarial debiasing.

*Difficulty* Hard.

### Prerequisites

@@tight-list
- Essential: working knowledge of the Julia language
- Strongly preferred: git workflow familiarity
- Desirable: Experience with flux and autodiff
@@

### Description

Machine learning models are developed to support and make high-impact decisions like who to hire or who to give a loan to. However, available training data can exhibit bias against race, age, gender, or other prohibited bases, reflecting a complex social and economic history of systemic injustic. For example, women in the United Kingdom, United States and other countries were only allowed to have their own bank accounts and lines of credit in the 1970s! That means that training a credit decisioning model on historical data would encode implicit biases, that women are less credit-worthy because few of them had lines of credit in the past. Surely we would want to be fair and not hinder an applicant's ability to get a loan on the basis of their race, gender and age?

So how can we fix data and models that are unfair? A common first reaction is to remove the race, gender and age attributes from the training data, and then say we are done. But as described in detail in the references, we cam have to consider if other features like one's name or address could encode such prohibited bases too. To mitigate bias and improve fairness in models, we can change the training data (pre-processing), the way we define and train the model (in-processing), and/or alter the predictions made (post-processing). Some algorithms for the first and third approaches have already been implemented in Fairness.jl, which have the advantage of treating the ML model as a black box. However, our latest resarch [(arXiv:2011.02407)](https://arxiv.org/abs/2011.02407) shows that pur black box methods have fundamental limitations in their ability to mitigate bias.

### Your contribution

This project is to implement more bias mitigation algorithms and invent new ones too. We will focus on in-processing algorithms that alter the training process or alter ML model. Some specific stages are to:

1. Use [Flux.jl](https://github.com/FluxML/Flux.jl) or [MLJFlux.jl](https://github.com/alan-turing-institute/MLJFlux.jl) to develop in-processing algorithms,
2. Study research papers proposing in-processing algorithms and implement them, and
3. Implement fairness algorithms and metrics for individual fairness as described in papers like [arXiv:2006.11439](https://arxiv.org/abs/2006.11439).

### References

1. High-level overview: [https://towardsdatascience.com/a-tutorial-on-fairness-in-machine-learning-3ff8ba1040cb](https://julialang.org/jsoc/gsoc/MLJ/)
2. [https://nextjournal.com/ashryaagr/fairness](https://nextjournal.com/ashryaagr/fairness)
3. IBM’s AIF360 resources: [https://aif360.mybluemix.net/](https://aif360.mybluemix.net/)

    AIF360 Inprocessing algorithms: Available [here](https://aif360.readthedocs.io/en/latest/modules/algorithms.html#module-aif360.algorithms.inprocessing).

4. [https://dssg.github.io/fairness_tutorial/](https://dssg.github.io/fairness_tutorial/)


## Causal and counterfactual methods for fairness in machine learning

Mentors: [Jiahao Chen](https://jiahao.github.io/), [Moritz Schauer](https://github.com/mschauer), [Zenna Tavares](https://github.com/zenna), and [Sebastian Vollmer](https://www.turing.ac.uk/people/programme-directors/sebastian-vollmer)

[Fairness.jl](https://github.com/ashryaagr/Fairness.jl) is a package to audit and mitigate bias, using the MLJ machine learning framework and other tools. This project is to implement algorithms for counterfactual ("what if") reasoning and causal analysis to Fairness.jl and MLJ.jl, integrating and extending Julia packages for causal analysis.

*Difficulty* Hard.

### Prerequisites

@@tight-list
- Essential: working knowledge of the Julia language
- Strongly preferred: git workflow familiarity
- Desirable: Experience in causal inference
- Desirable: Experience with graphical models
@@


### Description

Machine learning models are developed to support and make high-impact decisions like who to hire or who to give a loan to. However, available training data can exhibit bias against race, age, gender, or other prohibited bases, reflecting a complex social and economic history of systemic injustic. For example, women in the United Kingdom, United States and other countries were only allowed to have their own bank accounts and lines of credit in the 1970s! That means that training a credit decisioning model on historical data would encode implicit biases, that women are less credit-worthy because few of them had lines of credit in the past. Surely we would want to be fair and not hinder an applicant's ability to get a loan on the basis of their race, gender and age?

So how can we fix unfairness in models? Arguably, we should first identify the underlying _causes_ of bias, and only then can we actually remediate bias successfully.
However, one major challenge is that a proper evaluation often requires data that we don't have. For this reason, we also need counterfactual analysis, to identify actions we can take that can mitigate fairness not just in our training data, but also in situations we haven't seen yet but could encounter in the future. Ideas for identifying and mitigating bias using such causal interventions have been proposed in papers such as [Equality of Opportunity in Classification: A Causal Approach](https://causalai.net/r37.pdf) and the references below.

### Your contribution

This project is to implement algorithms for counterfactual ("what if") reasoning and causal analysis to Fairness.jl and MLJ.jl, integrating and extending Julia packages for causal analysis. Some specific stages are:

@@tight-list
1. Implement interfaces in MLJ.jl for Julia packages for causal inference and probabilistic programming such as [Omega.jl](https://github.com/zenna/Omega.jl) and CausalInference.jl](https://github.com/mschauer/CausalInference.jl)
2. Implement and benchmark causal and counterfactual definitons for measuring unfairness
3. Implement and benchmark causal and counterfactual approaches to mitigate bias

@@

### References
@@tight-list
- [Repository of Causal-Fairness links](https://github.com/yongkaiwu/Causal-Fairness)
- [Causal fairness for predictive models](https://causalai.net/r37.pdf)
- [High-level overview: Fair Multiple Decision Making Through Soft Interventions](https://papers.nips.cc/paper/2020/file/d0921d442ee91b896ad95059d13df618-Paper.pdf)
- [Fairness in Decision-Making — The Causal Explanation Formula](https://www.aaai.org/ocs/index.php/AAAI/AAAI18/paper/view/16949/15911)
- [CausalML tool from Uber](https://causalml.readthedocs.io/en/latest/methodology.html#t-learner)
- [end-to-end causal](https://www2.slideshare.net/AmitSharma315/dowhy-an-endtoend-library-for-causal-inference)
- [Equality of Opportunity in Classification: A Causal Approach](https://causalai.net/r37.pdf).
@@




## Time series forecasting at scale - speed up via Julia
Time series are ubiquitous - stocks, sensor reading, vital signs. This projects aims at adding time series forecasting to MLJ and perform benchmark comparisons to [sktime](https://github.com/alan-turing-institute/sktime), [tslearn](https://github.com/rtavenar/tslearn), [tsml](https://github.com/uea-machine-learning/tsml/)).

**Difficulty.** Easy - moderate.

### Prerequisites
- Julia language fluency essential.
- Git-workflow essebtial
- Some prior contact with time series forecasting
- HPC in julia is a desirable

### Your contribution
MLJ is so far focused on tabular data and time series classification. This project is to add support for time series data in a modular, composable way.

Time series are everywhere in real-world applications and there has been an increase in interest in time series frameworks recently (see e.g. [sktime](https://github.com/alan-turing-institute/sktime), [tslearn](https://github.com/rtavenar/tslearn), [tsml](https://github.com/uea-machine-learning/tsml/)).

But there are still very few principled time-series libraries out there, so you would be working on something that could be very useful for a large number of people. To find out more, check out this [paper](http://learningsys.org/neurips19/assets/papers/sktime_ml_systems_neurips2019.pdf) on sktime.

**Mentors**: [Sebastian Vollmer](https://www.turing.ac.uk/people/programme-directors/sebastian-vollmer), [Markus Löning](https://github.com/mloning) (sktime developer).

### References
* [sktime](https://github.com/alan-turing-institute/sktime)
* [tslearn](https://github.com/rtavenar/tslearn)
* [tsml](https://github.com/uea-machine-learning/tsml/)
* [sktime paper](http://learningsys.org/neurips19/assets/papers/sktime_ml_systems_neurips2019.pdf)


## Interpretable Machine Learning in Julia

Interpreting and explaining black box interpretation crucial to estabilish trust and improve performance

**Difficulty.** Easy - moderate.

### Description
It is important to have mechanisms in place to interpret the results of machine learning models. Identify the relevant factors of a decision or scoring of a model.

This project will implement methods for model and feature interpretability.

**Mentors.** [Diego Arenas](https://github.com/darenasc), [Sebastian Vollmer](https://www.turing.ac.uk/people/programme-directors/sebastian-vollmer).

### Prerequisites
- Julia language fluency essential.
- Git-workflow familiarity strongly preferred.
- Some prior contact with explainable AI/ML methods is desirable.
- A passing familiarity with machine learning goals and workflow preferred

### Your contribution

The aim of this project is to implement multiple  variants implementation algorithms such as:

- Implement methods to show feature importance
- Partial dependence plots
- Tree surrogate
- LocalModel: Local Interpretable Model-agnostic Explanations
- Add Dataset loaders for standard interpretability datasetss.
- Add performance metrics for interpretability
- Add interpretability algorithms
- Glue code to SHAP package

Specifically you will
- Familiarize yourself with MLJ
- Survey of some of the literature and existing implementations in Julia and other languages, and preparing a short summary
- Implement visualisations of explanations
- Implement use cases
- You will learn about the benefits and short comings of model interpretation and how to use them.

### References
- [Interpretable Machine Learning - A Guide for Making Black Box Models Explainable by Christoph Molnalr](https://christophm.github.io/interpretable-ml-book/)
- [iml R package](https://github.com/christophM/iml/)
- [AI Explainability 360 by IBM]: A survey on particle swarm optimization with emphasis on engineering and network applications](https://github.com/Trusted-AI/AIX360)

Tutorials
- [AI explainability 360: hands-on tutorial](https://dl.acm.org/doi/abs/10.1145/3351095.3375667)
- [IML tutorial](https://mlr3book.mlr-org.com/iml.html)

## Model visualization in MLJ

Design and implement a data visualization module for MLJ.

**Difficulty**. Easy.

### Description

Design and implement a data visualization module for MLJ to visualize numeric and categorical features (histograms, boxplots, correlations, frequencies), intermediate results, and metrics generated by MLJ machines.

Using a suitable Julia package for data visualization.

The idea is to implement a similar resource to what [mlr3viz](https://github.com/mlr-org/mlr3viz) does for [mlr3](https://mlr3.mlr-org.com).

### Prerequisites
* Julia language fluency essential.
* Git-workflow essential.
* Some prior work on data visualization is desirable

### Your contribution
So far visualizing data or features in MLJ is an ad-hoc task. Defined by the user case by case. You will be implementing a standard way to visualize model performance, residuals, benchmarks and predictions  for MLJ users.

The structures and metrics will be given from the results of models or data sets used; your task will be to implement the right visualizations depending on the data type of the features.

A relevant part of this project is to visualize the target variable against the rest of the features.

You will enhance your visualisation skills as well as your ability to "debug" and understand models and their prediction visually.

### References
* [mlr3viz](https://github.com/mlr-org/mlr3viz)
* [StatsPlots](https://github.com/JuliaPlots/StatsPlots.jl)

**Mentors**: [Sebastian Vollmer](https://www.turing.ac.uk/people/programme-directors/sebastian-vollmer), [Diego Arenas](https://github.com/darenasc).

## Deeper Bayesian Integration
Bayesian methods and probabilistic supervised learning provide uncertainty quantification. This project aims increasing integration to combine Bayeisan and non-Bayesian methods using Turing.

### Description
As an initial step reproduce [SOSSMLJ](https://github.com/cscherrer/SossMLJ.jl) in Turing. The bulk of the project is to implement methods that combine multiple predictive distributinons.

### Your contributions
- Interface between Turing and MLJ
- Comparisons of ensambling, stacking of predictive distribution
- reproducible benchmarks across various settings.

### References
[Bayesian Stacking](http://www.stat.columbia.edu/~gelman/research/published/stacking_paper_discussion_rejoinder.pdf)
[SKpro](https://github.com/alan-turing-institute/skpro/blob/master/README.md)
### Difficulty: Medium to Hard

**Mentors**: [Hong Ge](https://github.com/yebai) [Sebastian Vollmer](https://www.turing.ac.uk/people/programme-directors/sebastian-vollmer)

## MLJ and MLFlow integration
Integrate MLJ with [MLFlow](https://mlflow.org).

**Difficulty.** Easy.

### Description

MLFlow is a flexible model management tool. The project consists of writing the necessary functions to integrate MLJ with [MLFlow REST API](https://mlflow.org/docs/latest/rest-api.html) so models built using MLJ can keep track of its runs, evaluation metrics, parameters, and can be registered and monitored using MLFlow.

### Prerequisites
- Julia language fluency essential.
- Git-workflow familiarity strongly preferred.

### Your contribution
* Provide to MLJ users a way to keep track of their machine learning models using MLflow, as a local or remote server.
* Implement a reproducible way to store and load machine learning models.
* Implement functions wraping the REST API calls that makes possible the use of MLflow.

### References
* [MLFlow](https://mlflow.org) website.
* [MLFlow REST API](https://mlflow.org/docs/latest/rest-api.html).

## Speed demons only need apply

Diagnose and exploit opportunities for speeding up common MLJ
workflows.

**Difficulty.** Moderate.

### Description

In addition to investigating a number of known performance bottlenecks, you will have some free reign in this to identify opportunities to speed up common MLJ workflows, as well as making better use of memory resources.

### Prerequisites
- Julia language fluency essential.
- Experience with multi-threading and multi-processor computing essential, preferably in Julia.
- Git-workflow familiarity strongly preferred.
- Familiarity with machine learning goals and  workflow preferred

### Your contribution
In this project you will:
- familiarize yourself with the training, evaluation and tuning of machine learning models in MLJ
- work towards addressing a number of known performance issues, including:
- limitations of the generic Tables.jl interface for interacting with tabular data which, in common cases (DataFrames), has extra functionality that can be exploited
- rolling out new data front-end for models to avoid unnecessary copying of data
- in conjuction with your mentor, identify best design for introducing better sparse data support to MLJ models (e.g., naive Bayes)
- implement a multi-threading and/or multi-processor parallelism to the current learning networks scheduler
- benchmark and profile common workflows to identify opportunities for further code optimizations
- implement some of these optimizations

### References
- [MLJ Roadmap](https://github.com/alan-turing-institute/MLJ.jl/blob/dev/ROADMAP.md#scalability). See, in particular "Scalability" section.
- [Taking performance more seriously GitHub issue](https://github.com/alan-turing-institute/MLJBase.jl/issues/309)
- [Data front end](https://alan-turing-institute.github.io/MLJ.jl/dev/adding_models_for_general_use/#Implementing-a-data-front-end-1) for MLJ models.

**Mentors.** [Anthony Blaom](https://ablaom.github.io)
