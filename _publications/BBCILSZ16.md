---
type: "article"
title: "Unreasonable effectiveness of learning neural networks: From accessible states and robust ensembles to basic algorithmic schemes"
shorttitle: "Unreasonable effectiveness of learning neural networks"
authors:
- Baldassi, Carlo
- Borgs, Christian
- Chayes, Jennifer T.
- Ingrosso, Alessandro
- Lucibello, Carlo
- Saglietti, Luca
- Zecchina, Riccardo
year: "2016"
month: "nov"
journal: "Proceedings of the National Academy of Sciences"
volume: "113"
number: "48"
pages: "E7655--E7662"
doi: "10.1073/pnas.1608103113"
packages:
  BinaryCommitteeMachineRSGD.jl: https://github.com/carlobaldassi/BinaryCommitteeMachineRSGD.jl
  BinaryCommitteeMachineFBP.jl: https://github.com/carlobaldassi/BinaryCommitteeMachineFBP.jl
  
---
In artificial neural networks, learning from data is a computationally demanding task in which a large number of connection weights are iteratively tuned through stochastic-gradient-based heuristic processes over a cost function. It is not well understood how learning occurs in these systems, in particular how they avoid getting trapped in configurations with poor computational performance. Here, we study the difficult case of networks with discrete weights, where the optimization landscape is very rough even for simple architectures, and provide theoretical and numerical evidence of the existence of rare—but extremely dense and accessible—regions of configurations in the network weight space. We define a measure, the robust ensemble (RE), which suppresses trapping by isolated configurations and amplifies the role of these dense regions. We analytically compute the RE in some exactly solvable models and also provide a general algorithmic scheme that is straightforward to implement: define a cost function given by a sum of a finite number of replicas of the original cost function, with a constraint centering the replicas around a driving assignment. To illustrate this, we derive several powerful algorithms, ranging from Markov Chains to message passing to gradient descent processes, where the algorithms target the robust dense states, resulting in substantial improvements in performance. The weak dependence on the number of precision bits of the weights leads us to conjecture that very similar reasoning applies to more conventional neural networks. Analogous algorithmic schemes can also be applied to other optimization problems.