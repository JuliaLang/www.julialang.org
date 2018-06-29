---
type: "article"
title: "Fast and Accurate Multivariate Gaussian Modeling of Protein Families: Predicting Residue Contacts and Protein-Interaction Partners"
authors:
- Baldassi, Carlo
- Zamparo, Marco
- Feinauer, Christoph
- Procaccini, Andrea
- Zecchina, Riccardo
- Weigt, Martin
- Pagnani, Andrea
year: "2014"
month: "3/2014"
journal: "PLoS ONE"
volume: "9"
pages: "e92721"
doi: "10.1371/journal.pone.0092721.s001"
keywords:
- biocomp
packages:
  GaussDCA.jl: https://github.com/carlobaldassi/GaussDCA.jl
---
In the course of evolution, proteins show a remarkable conservation of their three-dimensional structure and their biological function, leading to strong evolutionary constraints on the sequence variability between homologous proteins. Our method aims at extracting such constraints from rapidly accumulating sequence data, and thereby at inferring protein structure and function from sequence information alone. Recently, global statistical inference methods (e.g. direct-coupling analysis, sparse inverse covariance estimation) have achieved a breakthrough towards this aim, and their predictions have been successfully implemented into tertiary and quaternary protein structure prediction methods. However, due to the discrete nature of the underlying variable (amino-acids), exact inference requires exponential time in the protein length, and efficient approximations are needed for practical applicability. Here we propose a very efficient multivariate Gaussian modeling approach as a variant of direct-coupling analysis: the discrete amino-acid variables are replaced by continuous Gaussian random variables. The resulting statistical inference problem is efficiently and exactly solvable. We show that the quality of inference is comparable or superior to the one achieved by mean-field approximations to inference with discrete variables, as done by direct-coupling analysis. This is true for (i) the prediction of residue-residue contacts in proteins, and (ii) the identification of protein-protein interaction partner in bacterial signal transduction. An implementation of our multivariate Gaussian approach is available at the website <a href="http://areeweb.polito.it/ricerca/cmp/node/521">http://areeweb.polito.it/ricerca/cmp/code</a>.