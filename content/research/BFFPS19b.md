---

title: "Reachability analysis of linear hybrid systems via block decomposition"
journal: 
authors:
- Sergiy Bogomolov
- Marcelo Forets
- Goran Frehse
- Kostiantyn Potomkin
- Christian Schilling
year: "2019"
pages:
doi: 
arxiv: 1905.02458
packages:
  LazySets.jl: https://github.com/JuliaReach/LazySets.jl
  Reachability.jl: https://github.com/JuliaReach/Reachability.jl
---

Reachability analysis aims at identifying states reachable by a system within a given time horizon.
This task is known to be computationally hard for hybrid systems.
One of the main challenges is the handling of discrete transitions, including computation of intersections with invariants
and guards. In this paper, we address this problem by proposing a state-space decomposition approach
for linear hybrid systems. This approach allows us to perform most operations in low-dimensional state space,
which can lead to significant performance improvements. 
