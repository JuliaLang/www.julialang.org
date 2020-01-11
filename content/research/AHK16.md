---
type: "incollection"
title: "Symbolic Manipulation of Flows of Nonlinear
Evolution Equations, with Application in the
Analysis of Split-Step Time Integrators"
authors:
- Auzinger, Winfried
- Hofstätter, Harald
- Koch, Othmar
year: "2016"
volume: "9890"
pages: "30--42"
booktitle: "Computer Algebra in Scientific Computing: 18th International Workshop, CASC 2016, Bucharest, Romania, September 19-23, 2016, Proceedings"
editors:
- Gerdt, P. Vladimir
- Koepf, Wolfram
- Seiler, M. Werner
- Vorozhtsov, V. Evgenii
series: "Lecture Notes in Computer Science"
publisher: "Springer International Publishing"
doi: "10.1007/978-3-319-45641-6_4"
arxiv: 1605.00453
packages:
  Flows.jl: https://github.com/HaraldHofstaetter/Flows.jl
---
We describe a package realized in the Julia programming
language which performs symbolic manipulations applied to nonlinear
evolution equations, their flows, and commutators of such objects. This
tool was employed to perform contrived computations arising in the analysis
of the local error of operator splitting methods. It enabled the proof
of the convergence of the basic method and of the asymptotical correctness
of a defect-based error estimator. The performance of our package
is illustrated on several examples.
