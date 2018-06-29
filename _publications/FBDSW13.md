---
type: "inproceedings"
title: "Stochastic Collapsed Variational Bayesian Inference for Latent Dirichlet Allocation"
authors:
- Foulds, James
- Boyles, Levi
- DuBois, Christopher
- Smyth, Padhraic
- Welling, Max
year: "2013"
pages: "446--454"
booktitle: "Proceedings of the 19th ACM SIGKDD International Conference on Knowledge Discovery and Data Mining"
series: "KDD '13"
publisher: "ACM"
location: "Chicago, Illinois, USA"
address: "New York, NY, USA"
doi: "10.1145/2487575.2487697"
keywords:
- stochastic learning
-  topic models
-  variational inference
---
There has been an explosion in the amount of digital text information available in recent years, leading to challenges of scale for traditional inference algorithms for topic models. Recent advances in stochastic variational inference algorithms for latent Dirichlet allocation (LDA) have made it feasible to learn topic models on very large-scale corpora, but these methods do not currently take full advantage of the collapsed representation of the model. We propose a stochastic algorithm for collapsed variational Bayesian inference for LDA, which is simpler and more efficient than the state of the art method. In experiments on large-scale text corpora, the algorithm was found to converge faster and often to a better solution than previous methods. Human-subject experiments also demonstrated that the method can learn coherent topics in seconds on small corpora, facilitating the use of topic models in interactive document analysis software.