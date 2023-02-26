# MLJ.jl Projects – Summer of Code

[MLJ](https://github.com/alan-turing-institute/MLJ.jl) is a machine
learning framework for Julia aiming to provide a convenient way to use
and combine a multitude of tools and models available in the Julia
ML/Stats ecosystem.


### List of projects

MLJ is released under the MIT license and sponsored by the Alan Turing Institute.

\toc

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

**Mentors.** [Deyan Dyankov](https://github.com/deyandyankov) (to be confirmed),
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

The Julia package [ClassImbalance.jl](https://github.com/bcbi/ClassImbalance.jl)
provides some native Julia class imbalance algorithms. For wider
adoption it is proposed that:

- ClassImbalance.jl be made more data-generic by supporting the   [MLUtils.jl](https://github.com/JuliaML/MLUtils.jl) `getobs` interface (original documentation [here](https://mldatapatternjl.readthedocs.io/en/latest/documentation/container.html) which now (mostly) includes tabular data implementing the 
  [Tables.jl](https://github.com/JuliaData/Tables.jl)) API. Currently
  there is only support for an old version of DataFrames.jl. 
  
- ClassImbalance.jl implements one or more general transformer API's, such
  the ones provided by
  [TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl),
  [MLJ](https://alan-turing-institute.github.io/MLJ.jl/dev/adding_models_for_general_use/),
  and
  [FeatureTransforms.jl](https://github.com/invenia/FeatureTransforms.jl)
  (a longer term goal is for MLJ to support the TableTransforms.jl API)
  
- Other Julia-native class imbalance algorithms be added

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

- [TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl) Github
	repository.

- [Tables.jl](https://github.com/JuliaData/Tables.jl)

- [Specification of the MLJ model API](https://alan-turing-institute.github.io/MLJ.jl/dev/adding_models_for_general_use/). 

- [FeatureTransforms.jl](https://github.com/invenia/FeatureTransforms.jl)

- [The `getobs` data container interface](https://mldatapatternjl.readthedocs.io/en/latest/documentation/container.html)
