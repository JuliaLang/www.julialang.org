# MLJ.jl Projects – Summer of Code

[MLJ](https://github.com/alan-turing-institute/MLJ.jl) is a machine
learning framework for Julia aiming to provide a convenient way to use
and combine a multitude of tools and models available in the Julia
ML/Stats ecosystem.


### List of projects

MLJ is released under the MIT license and sponsored by the Alan Turing Institute.

\toc

## Categorical variable encoding

Extend the categorical variable encoding of MLJ.

**Difficulty.** Moderate. **Duration.** 350 hours

### Description

MLJ provides basic one-hot encoding of categorical variables but no sophisticated encoding
techniques. One-hot encoding is rather limited, in particular when a categorical has a
very large number of classes. Many other techniques exists, and this project aims to make
some of these available to the MLJ user.


**Mentors.** [Anthony Blaom](https://ablaom.github.io/) (best contact: direct message on Julia slack)

### Prerequisites

-   Julia language fluency is essential.

-   Git-workflow familiarity is strongly preferred.

-   Experience with machine learning and data science workflows.

-   Familiarity with MLJ's API a plus.

### Your contribution

In this project you will survey popular existing methods for one-hot encoding categorical
variables. In collaboration with the mentor, you will make a plan for integrating some of
these techniques into MLJ. You will begin work on the plan, initially focusing on simple
methods, providing MLJ interfaces to existing julia packages, or new implementations where
needed. If the project advances well, you will implement more advanced techniques, such as
[entity embedding](https://arxiv.org/abs/1604.06737) via MLJFlux.jl (MLJ's neural network
interface).

### References

- Existing encoding in MLJ:
  [OneHotEncoder](https://alan-turing-institute.github.io/MLJ.jl/dev/models/OneHotEncoder_MLJModels/#OneHotEncoder_MLJModels);
  [ContinuousEncoder](https://alan-turing-institute.github.io/MLJ.jl/dev/models/ContinuousEncoder_MLJModels/#ContinuousEncoder_MLJModels);
  [UnivariateContinuousTimeEncoder](https://alan-turing-institute.github.io/MLJ.jl/dev/models/UnivariateTimeTypeToContinuous_MLJModels/#UnivariateTimeTypeToContinuous_MLJModels)

- StatsModels.jl [encoders](https://juliastats.org/StatsModels.jl/stable/contrasts/)

- MLJ [feature request](https://github.com/JuliaAI/MLJModels.jl/issues/534)

- Guo and Berkhahn [(2016]](https://arxiv.org/abs/1604.06737) "Entity Embeddings of Categorical Variables"

- [MLJFlux.jl](https://github.com/FluxML/MLJFlux.jl)


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

**[mlr3proba](https://mlr3proba.mlr-org.com) is currently the most complete survival
analysis interface, let's get SurvivalAnalysisA.jl to the same standard - but learning from mistakes
along the way.**


**Mentors.** [Sebastian Vollmer](https://sebastian.vollmer.ms), [Anthony Blaom](https://ablaom.github.io/),

### Prerequisites

-   Julia language fluency is essential.

-   Git-workflow familiarity is strongly preferred.

-   Some experience with survival analysis.

-   Familiarity with MLJ's API a plus.

-   A passing familiarity with machine learning goals and workflow is
	preferred.

### Your contribution

You will work towards creating a survival analysis package with a range of metrics,
capable of making distribution predictions for classical and ML models. You will bake in
competing risks in early, as well as prediction transformations, and include both left and
interval censoring.  You will code up basic models (Cox PH and AFT), as well as one ML
model as a proof of concept (probably decision tree is simplest or Coxnet).

Specifically, you will:

-   Familiarize yourself with the training and evaluation machine
	learning models in MLJ.

-  For SurvivalAnalysis.jl, implement the [MLJ model interface](https://alan-turing-institute.github.io/MLJ.jl/dev/adding_models_for_general_use/).

-   Consider Explainability of SurvivalAnalysis through SurvSHAP(t)

-   Develop a proof of concept for newer advanced survival analysis
	models not currently implemented in Julia.

### References

- Mateusz Krzyziński et al., [SurvSHAP(t): Time-Dependent Explanations of Machine Learning Survival Models](https://doi.org/10.1016/j.knosys.2022.110234), Knowledge-Based Systems 262 (February 2023): 110234

- Kvamme, H., Borgan, Ø., & Scheel, I. (2019). [Time-to-event prediction with neural networks and Cox regression](https://arxiv.org/abs/1907.00825). Journal of Machine Learning Research, 20(129), 1--30.

- Lee, C., Zame, W. R., Yoon, J., & van der Schaar, M. (2018). [Deephit: A deep learning approach to survival analysis with	competing risks.](https://ojs.aaai.org/index.php/AAAI/article/view/11842/11701) In Thirty-Second AAAI Conference on Artificial	Intelligence.

- Katzman, J. L., Shaham, U., Cloninger, A., Bates, J., Jiang, T., & Kluger, Y. (2018). [DeepSurv: personalized treatment recommender system using a Cox proportional hazards deep neural network](https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-018-0482-1). BMC Medical Research Methodology, 18(1), 24.

- Gensheimer, M. F., & Narasimhan, B. (2019). A scalable discrete-time survival model for neural networks.](https://peerj.com/articles/6257/) PeerJ, 7, e6257.

- [SurvivalAnalysis.jl](https://github.com/RaphaelS1/SurvivalAnalysis.jl)


## Deeper Bayesian Integration
Bayesian methods and probabilistic supervised learning provide uncertainty quantification. This project aims increasing integration to combine Bayesian and non-Bayesian methods using Turing.

**Difficulty.** Difficult. **Duration.** 350 hours.

### Description
As an initial step reproduce [SOSSMLJ](https://github.com/cscherrer/SossMLJ.jl) in Turing. The bulk of the project is to implement methods that combine multiple predictive distributions.

### Your contributions
- Interface between Turing and MLJ
- Comparisons of ensembling, stacking of predictive distribution
- reproducible benchmarks across various settings.

### References
[Bayesian Stacking](http://www.stat.columbia.edu/~gelman/research/published/stacking_paper_discussion_rejoinder.pdf)
[SKpro](https://github.com/alan-turing-institute/skpro/blob/master/README.md)
### Difficulty: Medium to Hard

**Mentors**: [Hong Ge](https://github.com/yebai) [Sebastian Vollmer](https://sebastian.vollmer.ms)


## Tracking and sharing MLJ workflows using MLflow

Help data scientists using MLJ track and share their machine learning experiments using
[MLflow](https://mlflow.org). The emphasis iin this phase of the project is:

- support *asynchronous* workflows, as appear in parallelized model tuning
- support live logging while training *iterative* models, such as neural networks

**Difficulty.** Moderate. **Duration.** 350 hours.

### Description

MLflow is an open source platform for the machine learning life cycle. It allows the data
scientist to upload experiment metadata and outputs to the platform for reproducing and
sharing purposes. MLJ [already allows](https://github.com/JuliaAI/MLJFlow.jl) users to
report basic model performance evaluation to an MLflow service and this project seeks to
greatly enhance this integration.

### Prerequisites
- Julia language fluency essential
- Understanding of asynchronous programming principles
- Git-workflow familiarity strongly preferred.
- General familiarity with data science workflows

### Your contribution
* You will familiarize yourself with MLJ, MLflow and MLflowClient.jl client APIs.
* You will familiarize yourself with the MLJFlow.jl package providing MLJ <--> MLflow integration
* Implement changes needed to allow correct *asynchronous* logging of model performance evaluations
* Extend logging to (parallelized) model tuning (MLJ's `TunedModel` wrapper)
* Extend logging to controlled training of iterative models (MLJ's `IteratedModel` wrapper)


### References
* [MLflow](https://mlflow.org) website.
* [MLflow REST API](https://mlflow.org/docs/latest/rest-api.html).
* [MLJFlow.jl](https://github.com/JuliaAI/MLJFlow.jl)
* [MLflowClient.jl](https://github.com/JuliaAI/MLFlowClient.jl)
* [MLJIteration.jl](https://github.com/JuliaAI/MLJIteration.jl)
* [Issue on asynchronous reporting](https://github.com/JuliaAI/MLJFlow.jl/issues/26)

**Mentors.** [Anthony Blaom](https://ablaom.github.io/)


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
- benchmark and profile common workflows to identify opportunities for further code optimizations, with a focus on the most popular models
- work to address problems identified
- roll out new data front-end for iterative models, to avoid unnecessary copying of data
- experiment with adding multi-processor parallelism to the current learning networks scheduler
- implement some of these optimizations

### References
- [MLJ Roadmap](https://github.com/alan-turing-institute/MLJ.jl/blob/dev/ROADMAP.md#scalability). See, in particular "Scalability" section.
- [Taking performance more seriously GitHub issue](https://github.com/alan-turing-institute/MLJBase.jl/issues/309)
- [Data front end](https://alan-turing-institute.github.io/MLJ.jl/dev/adding_models_for_general_use/#Implementing-a-data-front-end-1) for MLJ models.

**Mentors.** [Anthony Blaom](https://ablaom.github.io), Okon Samuel.
