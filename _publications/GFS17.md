---
type: "article"
title: "Predicting Protein Dynamics and Allostery Using Multi-Protein Atomic Distance Constraints"
authors:
- Joe G Greener
- Ioannis Filippis
- Michael J E Sternberg
year: "2017"
journal: "Structure"
volume: "25"
pages: "546-558"
packages:
  ProteinEnsembles.jl: https://github.com/jgreener64/ProteinEnsembles.jl
---
The related concepts of protein dynamics, conformational ensembles and allostery are often difficult to study with molecular dynamics (MD) due to the timescales involved. We present ExProSE (Exploration of Protein Structural Ensembles), a distance geometry-based method that generates an ensemble of protein structures from two input structures. ExProSE provides a unified framework for the exploration of protein structure and dynamics in a fast and accessible way. Using a dataset of apo/holo pairs it is shown that existing coarse-grained methods often cannot span large conformational changes. For T4-lysozyme, ExProSE is able to generate ensembles that are more native-like than tCONCOORD and NMSim, and comparable with targeted MD. By adding additional constraints representing potential modulators, ExProSE can predict allosteric sites. ExProSE ranks an allosteric pocket first or second for 27 out of 58 allosteric proteins, which is similar and complementary to existing methods. The ExProSE source code is freely available.
