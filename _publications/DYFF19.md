---
type: "inproceedings"
title: "Distributed MCMC Inference in Dirichlet Process Mixture Models Using Julia"
authors:
- Or Dinari
- Angel Yu
- Oren Freifeld
- John W. Fisher III
year: "2019"
pages: "518--525"
booktitle: "International Symposium on Cluster, Cloud and Grid Computing (CCGRID) Workshop on High Performance Machine Learning Workshop"
doi: "10.1109/CCGRID.2019.00066"
packages:
  DPMMSubClusters.jl: https://github.com/dinarior/DPMMSubClusters.jl
---
Due to the increasing availability of large data
sets, the need for general-purpose massively-parallel analysis
tools become ever greater. In unsupervised learning, Bayesian
nonparametric mixture models, exemplified by the DirichletProcess Mixture Model (DPMM), provide a principled Bayesian
approach to adapt model complexity to the data. Despite their
potential, however, DPMMs have yet to become a popular tool.
This is partly due to the lack of friendly software tools that
can handle large datasets efficiently. Here we show how, using
Julia, one can achieve efficient and easily-modifiable implementation of distributed inference in DPMMs. Particularly, we show
how a recent parallel MCMC inference algorithm – originally
implemented in C++ for a single multi-core machine – can be
distributed efficiently across multiple multi-core machines using
a distributed-memory model. This leads to speedups, alleviates
memory and storage limitations, and lets us learn DPMMs from
significantly larger datasets and of higher dimensionality. It
also turned out that even on a single machine the proposed
Julia implementation handles higher dimensions more gracefully
(at least for Gaussians) than the original C++ implementation.
Finally, we use the proposed implementation to learn a model of
image patches and apply the learned model for image denoising.
While we speculate that a highly-optimized distributed implementation in, say, C++ could have been faster than the proposed
implementation in Julia, from our perspective as machinelearning researchers (as opposed to HPC researchers), the latter
also offers a practical and monetary value due to the ease of
development and abstraction level. Our code is publicly available
at https://github.com/dinarior/dpmm subclusters.jl
