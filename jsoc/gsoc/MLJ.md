# GSOC projects

# 2021 Ideas

# Titles & possible mentors

* [Time series forecasting at scale - speed up via Julia](#Time-series-forecasting-at-scale---speed-up-via-Julia)
* [Interpretable Machine Learning in Julia](#Interpretable-Machine-Learning-in-Julia)
* [Model visualization in MLJ](#Model-visualization-in-MLJ)
* [Deeper integration with Bayesian methods and Bayesian Stacking](#Deeper-Bayes)
* [MLJ and MLFlow integration](#MLJ-and-MLFlow-integration)
* [Speed demons only need apply](#Speed-demons-only-need-apply)

# MLJ Projects – Summer of Code

[MLJ](https://github.com/alan-turing-institute/MLJ.jl) is a machine learning framework for Julia aiming to provide a convenient way to use and combine a multitude of tools and models available in the Julia ML/Stats ecosystem.

MLJ is released under the MIT license and sponsored by the Alan Turing Institute.


## Time series forecasting at scale - speed up via Julia

Time series are ubiquitous - stocks, sensor reading, vital signs. This projects aims at adding time series forecasting to MLJ and perform benchmark comparisons to [sktime](https://github.com/alan-turing-institute/sktime), [tslearn](https://github.com/rtavenar/tslearn), [tsml](https://github.com/uea-machine-learning/tsml/)).

**Difficulty.** Easy - moderate.

### Prerequisites
- Julia language fluency essential.
- Git-workflow essential
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

Interpreting and explaining black box interpretation crucial to establish trust and improve performance

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
- Add Dataset loaders for standard interpretability datasets.
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
So far visualizing data or features in MLJ is an ad-hoc task. Defined by the user case by case. You will be implementing a standard way to visualize model performance, residuals, benchmarks and predictions for MLJ users.

The structures and metrics will be given from the results of models or data sets used; your task will be to implement the right visualizations depending on the data type of the features.

A relevant part of this project is to visualize the target variable against the rest of the features.

You will enhance your visualisation skills as well as your ability to "debug" and understand models and their prediction visually.

### References
* [mlr3viz](https://github.com/mlr-org/mlr3viz)
* [StatsPlots](https://github.com/JuliaPlots/StatsPlots.jl)

**Mentors**: [Sebastian Vollmer](https://www.turing.ac.uk/people/programme-directors/sebastian-vollmer), [Diego Arenas](https://github.com/darenasc).

## Deeper Bayesian Integration
Bayesian methods and probabilistic supervised learning provide uncertainty quantification. This project aims increasing integration to combine Bayesian and non-Bayesian methods using Turing.

### Description
As an initial step reproduce [SOSSMLJ](https://github.com/cscherrer/SossMLJ.jl) in Turing. The bulk of the project is to implement methods that combine multiple predictive distributions.

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
* Implement functions wrapping the REST API calls that makes possible the use of MLflow.

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
- in conjunction with your mentor, identify best design for introducing better sparse data support to MLJ models (e.g., naive Bayes)
- implement a multi-threading and/or multi-processor parallelism to the current learning networks scheduler
- benchmark and profile common workflows to identify opportunities for further code optimizations
- implement some of these optimizations

### References
- [MLJ Roadmap](https://github.com/alan-turing-institute/MLJ.jl/blob/dev/ROADMAP.md#scalability). See, in particular "Scalability" section.
- [Taking performance more seriously GitHub issue](https://github.com/alan-turing-institute/MLJBase.jl/issues/309)
- [Data front end](https://alan-turing-institute.github.io/MLJ.jl/dev/adding_models_for_general_use/#Implementing-a-data-front-end-1) for MLJ models.

**Mentors.** [Anthony Blaom](https://ablaom.github.io)
