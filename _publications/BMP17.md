---
type: "article"
title: "An analytic approximation of the feasible space of metabolic networks"
authors:
- Braunstein, Alfredo
- Muntoni, Anna Paola
- Pagnani, Andrea
year: "2017"
journal: "Nature Communications"
volume: "8"
pages: "14915"
doi: "10.1038/ncomms14915"
packages:
  Metabolic-EP.jl: https://github.com/anna-pa-m/Metabolic-EP
---
Assuming a steady-state condition within a cell, metabolic fluxes satisfy an underdetermined linear system of stoichiometric equations. Characterizing the space of fluxes that satisfy such equations along with given bounds (and possibly additional relevant constraints) is con- sidered of utmost importance for the understanding of cellular metabolism. Extreme values for each individual flux can be computed with linear programming (as flux balance analysis), and their marginal distributions can be approximately computed with Monte Carlo sampling. Here we present an approximate analytic method for the latter task based on expectation propagation equations that does not involve sampling and can achieve much better predic- tions than other existing analytic methods. The method is iterative, and its computation time is dominated by one matrix inversion per iteration. With respect to sampling, we show through extensive simulation that it has some advantages including computation time, and the ability to efficiently fix empirically estimated distributions of fluxes.
