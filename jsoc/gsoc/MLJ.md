# MLJ.jl Projects – Summer of Code

[MLJ](https://github.com/alan-turing-institute/MLJ.jl) is a machine
learning framework for Julia aiming to provide a convenient way to use
and combine a multitude of tools and models available in the Julia
ML/Stats ecosystem.


### List of projects

MLJ is released under the MIT license and sponsored by the Alan Turing Institute.

- Machine Learning in Predictive Survival Analysis
- Feature transformations
- Time series forecasting at scale - speed up via Julia
- Interpretable Machine Learning in Julia
- Model visualization in MLJ
- Deeper Bayesian Integration
- Tracking and sharing MLJ workflows using MLFlow
- Speed demons only need apply
- Correcting for class imbalance in classification problems


## Machine Learning in Predictive Survival Analysis

Implement survival analysis models for use in the MLJ machine learning
platform.

**Difficulty.** Moderate - hard. **Duration.** 350 hours

### Description

Survival/time-to-event analysis is an important field of Statistics
concerned with understanding the distribution of events over time.
Survival analysis presents a unique challenge as we are also interested
in events that do not take place, which we refer to as 'censoring'.
Survival analysis methods are important in many real-world settings,
such as health care (disease prognosis), finance and economics (risk of
default), commercial ventures (customer churn), engineering (component
lifetime), and many more. This project aims to implement models for
performing survivor analysis with the MLJ machine learning framework.

**Mentors.** [Sebastian Vollmer](https://sebastian.vollmer.ms), [Anthony Blaom](https://ablaom.github.io/),

### Prerequisites

-   Julia language fluency is essential.

-   Git-workflow familiarity is strongly preferred.

-   Some experience with survival analysis.

-   Familiarity with MLJ's API a plus.

-   A passing familiarity with machine learning goals and workflow is
	preferred.

### Your contribution

Specifically, you will:

-   Familiarize yourself with the training and evaluation machine
	learning models in MLJ.

-   Survey existing survival models in Julia.

-   Integrate some existing classical survival models into MLJ.

-   Develop a proof of concept for newer advanced survival analysis
	models not currently implemented in Julia.

### References

-   [Kvamme, H., Borgan, Ø., & Scheel, I. (2019). Time-to-event
	prediction with neural networks and Cox regression. Journal of
	Machine Learning Research, 20(129),
	1--30.](https://arxiv.org/abs/1907.00825)

-   [Lee, C., Zame, W. R., Yoon, J., & van der Schaar, M. (2018).
	Deephit: A deep learning approach to survival analysis with
	competing risks. In Thirty-Second AAAI Conference on Artificial
	Intelligence.](https://ojs.aaai.org/index.php/AAAI/article/view/11842/11701)

-   [Katzman, J. L., Shaham, U., Cloninger, A., Bates, J., Jiang, T., &
	Kluger, Y. (2018). DeepSurv: personalized treatment recommender
	system using a Cox proportional hazards deep neural network. BMC
	Medical Research Methodology, 18(1),
	24.](https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-018-0482-1)
	<https://doi.org/10.1186/s12874-018-0482-1>

-   [Gensheimer, M. F., & Narasimhan, B. (2019). A scalable
	discrete-time survival model for neural networks. PeerJ, 7,
	e6257.](https://peerj.com/articles/6257/)

-   [Survival.jl
	Documentation](https://juliastats.org/Survival.jl/latest/)


## Feature transformations

Enhancing MLJ data-preprocessing capabilities by integrating
[TableTransforms](https://github.com/JuliaML/TableTransforms.jl) into
MLJ.

**Difficulty.** Easy. **Duration.** 350 hours

### Description

TableTransforms.jl is a Julia package heavily inspired by
FeatureTranforms.jl which aims to provide feature engineering
transforms which are vital in the Statistics and Machine Learning
domain. This project would implement the necessary methods to
integrate TableTransforms with MLJ, making them available for
incorporation into sophisticated ML workflows.

**Mentors.** [Anthony Blaom](https://ablaom.github.io/).

### Prerequisites

-   Julia language fluency is essential.

-   Git-workflow familiarity is strongly preferred.

-   A passing familiarity with machine learning goals and workflow
	preferred

### Your contribution

-   Implement the MLJ model interface for transformers in TableTransforms.jl.

-   Integrate TableTransforms pipelines with MLJ.

### References

-   [TableTransforms](https://github.com/JuliaML/TableTransforms.jl) Github
	repository.

-   [MLJModels](https://github.com/JuliaAI/MLJModels.jl) Github
	repository with existing MLJ transformers.

-   [Specification of the MLJ model API](https://alan-turing-institute.github.io/MLJ.jl/dev/adding_models_for_general_use/).


## Time series forecasting at scale - speed up via Julia

Time series are ubiquitous - stocks, sensor reading, vital signs. This projects aims at adding time series forecasting to MLJ and perform benchmark comparisons to [sktime](https://github.com/alan-turing-institute/sktime), [tslearn](https://github.com/rtavenar/tslearn), [tsml](https://github.com/uea-machine-learning/tsml/)).

**Difficulty.** Moderate - hard. **Duration.** 350 hours.

### Prerequisites
- Julia language fluency essential.
- Git-workflow essential
- Some prior contact with time series forecasting
- HPC in julia is a desirable

### Your contribution
MLJ is so far focused on tabular data and time series classification. This project is to add support for time series data in a modular, composable way.

Time series are everywhere in real-world applications and there has been an increase in interest in time series frameworks recently (see e.g. [sktime](https://github.com/alan-turing-institute/sktime), [tslearn](https://github.com/rtavenar/tslearn), [tsml](https://github.com/uea-machine-learning/tsml/)).

But there are still very few principled time-series libraries out there, so you would be working on something that could be very useful for a large number of people. To find out more, check out this [paper](http://learningsys.org/neurips19/assets/papers/sktime_ml_systems_neurips2019.pdf) on sktime.

**Mentors**: [Sebastian Vollmer](https://sebastian.vollmer.ms), [Markus Löning](https://github.com/mloning) (sktime developer).

### References
* [sktime](https://github.com/alan-turing-institute/sktime)
* [tslearn](https://github.com/rtavenar/tslearn)
* [tsml](https://github.com/uea-machine-learning/tsml/)
* [sktime paper](http://learningsys.org/neurips19/assets/papers/sktime_ml_systems_neurips2019.pdf)


## Interpretable Machine Learning in Julia

Interpreting and explaining black box interpretation crucial to establish trust and improve performance

**Difficulty.** Easy - moderate. **Duration.** 350 hours.

### Description
It is important to have mechanisms in place to interpret the results of machine learning models. Identify the relevant factors of a decision or scoring of a model.

This project will implement methods for model and feature interpretability.

**Mentors.** [Diego Arenas](https://github.com/darenasc), [Sebastian Vollmer](https://sebastian.vollmer.ms).

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
- Implement visualizations of explanations
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

**Difficulty**. Easy.  **Duration.** 350 hours.

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

**Mentors**: [Sebastian Vollmer](https://sebastian.vollmer.ms), [Diego Arenas](https://github.com/darenasc).


## Deeper Bayesian Integration
Bayesian methods and probabilistic supervised learning provide uncertainty quantification. This project aims increasing integration to combine Bayesian and non-Bayesian methods using Turing.

**Difficulty.** Difficult. **Duration.** 350 hours.

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

**Mentors**: [Hong Ge](https://github.com/yebai) [Sebastian Vollmer](https://sebastian.vollmer.ms)


## Tracking and sharing MLJ workflows using MLFlow

Help data scientists using MLJ track and share their machine learning
experiments using [MLFlow](https://mlflow.org).

**Difficulty.** Moderate. **Duration.** 350 hours.

### Description

MLFlow is an open source platform for the machine learning life
cycle. It allows the data scientist to upload experiment metadata and
outputs to the platform for reproducing and sharing purposes. This
project aims to integrate the MLJ machine learning platform with
MLFlow.

### Prerequisites
- Julia language fluency essential.
- Git-workflow familiarity strongly preferred.
- General familiarity with data science workflows

### Your contribution
* You will familiarize yourself with MLJ, MLFlow and MLFlowClient.jl client APIs.
* Implement functionality to upload to MLFlow machine learning
  model hyper-parameters, performance evaluations, and
  artifacts encapsulating the trained model. 
* Implement functionality allowing for the live tracking of learning
  for iterative models, such as neural networks, by hooking in to
  [MLJIteration.jl](https://github.com/JuliaAI/MLJIteration.jl).

### References
* [MLFlow](https://mlflow.org) website.
* [MLFlow REST API](https://mlflow.org/docs/latest/rest-api.html).
* [MLFlowClient.jl](https://github.com/JuliaAI/MLFlowClient.jl)
* [MLJIteration.jl](https://github.com/JuliaAI/MLJIteration.jl)

**Mentors.** [Deyan Dyankov](https://github.com/deyandyankov),
[Anthony Blaom](https://ablaom.github.io/), [Diego
Arenas](https://github.com/darenasc).


## Speed demons only need apply

Diagnose and exploit opportunities for speeding up common MLJ
workflows.

**Difficulty.** Moderate.  **Duration.** 350 hours.

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


## Correcting for class imbalance in classification problems

Improve and extend Julia's offering of algorithms for correcting class
imbalance, with a view to integration into MLJ and elsewhere.

**Difficulty.** Easy - moderate. **Duration.** 350 hours

### Description

Many classification algorithms do not perform well when there is a
class imbalance in the target variable (for example, many more
positives than negatives). There are number of well-known data
preprocessing algorithms, such as oversampling, for compensating for
class imbalance. See for instance the python package
[imbalance-learn](https://imbalanced-learn.org/stable/).

The Julia package
[ClassImbalance.jl](https://github.com/bcbi/ClassImbalance.jl)
provides some native Julia class imbalance algorithms. For wider
adoption it is proposed that:

- ClassImbalance.jl be made more data-generic, for example made to
  support arbitrary tables (objects implementing
  [Tables.jl](https://github.com/JuliaData/Tables.jl)). Currently
  there is only support for an old version of DataFrames.jl. 
  
- ClassImbalance.jl implements a general transformer interface, such
  the ones provided by
  [TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl),
  [MLJ](https://alan-turing-institute.github.io/MLJ.jl/dev/adding_models_for_general_use/)
  or
  [FeatureTransforms.jl](https://github.com/invenia/FeatureTransforms.jl)
  (MLJ may ultimately support the TableTransforms.jl API - see the
  separate "Feature Transforms" project)
  
- ClassImbalance.jl also support data containers implementing the
  `getobs` interface in
  [LearnBase.jl](https://mldatapatternjl.readthedocs.io/en/latest/documentation/container.html)
  (but note [this](https://github.com/JuliaML/LearnBase.jl/issues/49)
  code re-organization project and [this issue](https://github.com/JuliaML/MLUtils.jl/issues/61)).

- Other Julia-native algorithms be added

**Mentor.** [Anthony Blaom](https://ablaom.github.io/).


### Prerequisites

- Julia language fluency is essential.

- An understanding of the class imbalance phenomena essential. A
  detailed understanding of at least one class imbalance algorithm
  essential.

- Git-workflow familiarity is strongly preferred.

- A familiarity with machine learning goals and workflow preferred
	

### Your contribution

- Familiarize yourself with the existing ClassImbalance package,
  including known issues

- Familiarize yourself with the Tables.jl interface

- Assess the merits of different transformer API choices and choose
  one in consultation with your mentor
  
- Implement the proposed improvements in parallel with testing and
  documentation additions to the package. Testing and documentation
  must be up-to-date before new algorithms are added. 
  

### References

- [ClassImbalance.jl](https://github.com/bcbi/ClassImbalance.jl) 

- [TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl) Github
	repository.

- [Tables.jl](https://github.com/JuliaData/Tables.jl)

- [Specification of the MLJ model API](https://alan-turing-institute.github.io/MLJ.jl/dev/adding_models_for_general_use/). 

- [FeatureTransforms.jl](https://github.com/invenia/FeatureTransforms.jl)

- [The `getobs` data container interface](https://mldatapatternjl.readthedocs.io/en/latest/documentation/container.html)
