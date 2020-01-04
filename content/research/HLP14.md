---
type: "inproceedings"
title: "Parallel algebraic modeling for stochastic optimization"
authors:
- Joey Huchette
- Miles Lubin
- Cosmin Petra
year: "2014"
pages: "29--35"
booktitle: "HPTCDL'14 Proceedings of the 1st Workshop on High Performance Technical Computing in Dynamic Languages"
publisher: "ACM"
address: "New York"
doi: "10.1109/HPTCDL.2014.6"
packages:
  StructJuMP.jl: https://github.com/StructJuMP/StructJuMP.jl
---
We present scalable algebraic modeling software, StochJuMP, for stochastic optimization as applied to power grid economic dispatch. It enables the user to express the problem in a high-level algebraic format with minimal boilerplate. StochJuMP allows efficient parallel model instantiation across nodes and efficient data localization. Computational results are presented showing that the model construction is efficient, requiring less than one percent of solve time. StochJuMP is configured with the parallel interior-point solver PIPS-IPM but is sufficiently generic to allow straight forward adaptation to other solvers.