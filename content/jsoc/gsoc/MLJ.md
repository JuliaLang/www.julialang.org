---
layout: single
title:  MLJ Projects – Summer of Code
---

# {{< get_param title >}}

[MLJ](https://github.com/alan-turing-institute/MLJ.jl) is a machine learning framework for Julia aiming to provide a convenient way to use and combine a multitude of tools and models available in the Julia ML/Stats ecosystem. MLJ is released under the MIT licensed and sponsored by the Alan Turing Institute.

Project mentors are [Anthony](https://github.com/ablaom), [Sebastian Vollmer](https://www.turing.ac.uk/people/programme-directors/sebastian-vollmer), 
## FairML
granting parole to accepting credit applications decision support tools guide human decision making with the aim to improve outcomes. In the latter often without any human in the loop. It is important that these decisions are fair. But what does fair mean? Does it mean we simply don't feed protective features such as age, gender and ethnicity? No theses are correlated with location, shoe size etc. Also, what does fair mean does it mean proportionally we want the same false-positive-rate or false-negative rate. But which one? Do we want the proportion that predicted-to-recommit a crime and don't be equalised or the ones that predicted-to-not-recommit a crime and do be equalised across groups? 
The first step is auditing the bias - there should be no performance metrics without assessing the bias. The second part is to look at the trade-off between fairness and performance. Letting no one out of jail is fair when comparing different subpopulations but not morally fair.
This project looks at 
1.	auditing
2.	pre and postprocessing of existing algorithms to improve fairness 
3.	the novel methodology that explores the multiobjective tradeoff between performance and fairness such as to incorporate fairness in training loss.

References:
High-level overview: https://towardsdatascience.com/a-tu	torial-on-fairness-in-machine-learning-3ff8ba1040cb

Starting point:
https://arxiv.org/abs/1811.05577
https://github.com/dssg/aequitas 
https://arxiv.org/abs/2001.09233 

## Bring MLJ to Kaggle! 
Project idea: Bring MLJ to Kaggle! See if MLJ and your data science skills are up to the challenge of matching the Kaggle tutorial results of other ML frameworks using Julia. Many Kaggle competitions rely on comparing and combining the predictions of numerous models, and with over 120 models and a maturing selection of meta-modelling tools, MLJ is poised to enter the fray. Help us lure more data scientists to Julia, and help us identity MLJ shortcomings, by developing end-to-end applications of MLJ tools and models to Kaggle tutorials.

## Parallel computing and MLJ Test
Project idea: Parallel computing and MLJ Test, benchmark and experiment with MLJ's parallelization features. MLJ offers Distributed processing and multithreading for: individual model training, model performance evaluation (eg, by cross-validation), when creating homogenous model ensembles, and when optimising model hyper parameters (model tuning). Tuning->(ensembling)->evaluating->fitting are operations that are typically composed leading to multiple levels of parallelisation. There is considerable scope for testing and experimentation with parallelisation at the different levels. There is also scope for suggesting and implementing improvements.


## Hyperparameter tuning of iterative algorithms
Desired skills: Julia, Gaussian Process
The best performing machine learning pipelines compare and combine multiple atomic models and tune their hyperparameters. One hyperparameter in particular is the number of steps to train a model, as this directly scales the learning cost. For instance, a hyperparameter-tuning-algorithm might decide whether to pause training and start a new model or resume the training of a previously-considered model.
]
This can be missleading In the early stages of training, Model B looks more promising than 
Model A even though the latter ultimately performs better. Therefore,
we must be careful not to prematurely terminate training for Model A.

This project aims at comparing existing methodologies with a few new ideas. 

References:
https://arxiv.org/pdf/1603.06560
https://arxiv.org/abs/1406.3896
https://openreview.net/forum?id=SknC0bW0-





