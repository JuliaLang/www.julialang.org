# GSOC projects

# 2021 Ideas

# Titles & possible mentors 

* [Particle swarm optimization of machine learning models](#Particle-swarm-optimization-of-machine-learning-models)
* [Fairness - Inprocessing and other mitigations](#Fairness---Inprocessing-and-other-mitigations)
* [Counterfactual analysis in Fairness.jl and MLJ](#Counterfactual-analysis-in-Fairness.jl-and-MLJ)
* [Time series forecasting at scale - speed up via Julia](#Time-series-forecasting-at-scale---speed-up-via-Julia)
* [Interpretable Machine Learning in Julia](#Interpretable-Machine-Learning-in-Julia)
* [Model visualization in MLJ](#Model-visualization-in-MLJ)
* [MLJ and MLFlow integration](#MLJ-and-MLFlow-integration)

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
- A passing familiarity with machine learning goals and
workflow preferred
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


## Fairness - Inprocessing and other mitigations

[Fairness.jl](https://github.com/ashryaagr/Fairness.jl) provides via MLJ and otherwise to possibility to audit and mitigate bias. To this end some preprocessing and postprocessing methods are implemented. You shouldn't cut corners about fairness - thus more mitigation techniques need to be provided. In processing is a big class of mitigation strategies currently missing.

*Difficulty* Moderate likely Hard.

### Description
From hiring decisions to granting loans, every crucial decision involves ML decision support tools. The data used to train these decision support tools can be biased against a specific race or gender or ethnic group. Suppose people of race A had been historically unprivileged due to oppression and thus were unable to repay loans. So, my dataset would naturally be biased and the ML model would tend to learn “People of race A should be denied loan; It is less likely for them to repay loan”. But should one’s race, ethnicity, gender negatively affect such crucial decisions like granting loan? Is this fair? Upon reading this, you would definitely question “why not remove the race, gender, ethnicity attributes from dataset”. You will find the answer to this in references mentioned, but to get intuition, ask yourself “Can name, city or country be an indicator for one’s religion/race/gender?”.

To mitigate the bias (enhance fairness), we can either alter the biased dataset, make changes to ML model (or training process) or alter predictions. The first and third approach treat the ML model as black-box and have a fundamental limit to enhance fairness as shown in [our work](https://arxiv.org/abs/2011.02407). These two approaches have been implemented and studied in the Fairness.jl project. In this project, we aim to implement as well as develop algorithms (in-processing algorithms) that alter the training process or alter ML model.

This project looks at:

1. Using [Flux.jl](https://github.com/FluxML/Flux.jl) or [MLJFlux.jl](https://github.com/alan-turing-institute/MLJFlux.jl), develop In-processing algorithms
2. Study research papers proposing in-processing algorithms and implement them
3. Implement fairness algorithms and metrics for individual fairness (refer [https://arxiv.org/abs/2006.11439](https://arxiv.org/abs/2006.11439) )

### Prerequisites
- Julia language fluency essential. 
- Git-workflow familiarity strongly preferred. 
- Desirable: Experience with flux and autodiff

### References:

1. High-level overview: [https://towardsdatascience.com/a-tutorial-on-fairness-in-machine-learning-3ff8ba1040cb](https://julialang.org/jsoc/gsoc/MLJ/)
2. [https://nextjournal.com/ashryaagr/fairness](https://nextjournal.com/ashryaagr/fairness) 
3. IBM’s AIF360 resources: [https://aif360.mybluemix.net/](https://aif360.mybluemix.net/) 
4. AIF360 Inprocessing algorithms: Available [here](https://aif360.readthedocs.io/en/latest/modules/algorithms.html#module-aif360.algorithms.inprocessing).
5. [https://dssg.github.io/fairness_tutorial/](https://dssg.github.io/fairness_tutorial/) 


## Counterfactual analysis in Fairness.jl and MLJ

This project looks at adding counterfactual and "what-if" reasoning to Fairness.jl and MLJ.jl.

*Difficulty* Moderate likely Hard.

### Prerequisites

- Julia language fluency essential. 
- Git-workflow familiarity strongly preferred. 
- Some prior contact with graphical models or causal inference
- Desirable: Experience in Causal Inference

### Description

Granting parole to accepting credit applications decision support tools guide human decision making with the aim to improve outcomes.
In the latter often without any human in the loop. It is important that these decisions are fair.
But what does fair mean?
Basic auditing and bias reduction e.g. for false-positive-rate or false-negative rate are available in Fairness.jl. 
A causal model for the features allows to consider Causal fairness for predictive models, see [Equality of Opportunity in Classification: A Causal Approach](https://causalai.net/r37.pdf). 


Many predictions drive interventions thus an important point to consider is outcome:
Is it resulting in equitable outcomes for different groups recieved a treatment? This question can only be addressed using causal inference.

### Your contribution

- Implementing counterfactual methods to understand causal effects. These methods will be used to better understand causality on studied events.
- Strengthen links between julias causal inference packages and MLJ e.g. using MLJ base models for causal inference e.g. in [Omega.jl](https://github.com/zenna/Omega.jl)
- Benchmark the existing fainress-causal methods across different use cases


### References:
- [Repository of Causal-Fairness links](https://github.com/yongkaiwu/Causal-Fairness) 
- [Causal fairness for predictive models](https://causalai.net/r37.pdf)
- [High-level overview: Fair Multiple Decision Making Through Soft Interventions](https://papers.nips.cc/paper/2020/file/d0921d442ee91b896ad95059d13df618-Paper.pdf)
- [Fairness in Decision-Making — The Causal Explanation Formula](https://www.aaai.org/ocs/index.php/AAAI/AAAI18/paper/view/16949/15911)
- [CausalML tool from Uber](https://causalml.readthedocs.io/en/latest/methodology.html#t-learner)
- [end-to-end causal](https://www2.slideshare.net/AmitSharma315/dowhy-an-endtoend-library-for-causal-inference)

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

## MLJ and MLFlow integration
Integrate MLJ with [MLFlow](https://mlflow.org). 

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