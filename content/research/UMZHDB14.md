---
type: "inproceedings"
title: "Convex Optimization in Julia"
authors:
- Madeleine Udell
- Karanveer Mohan
- David Zeng
- Jenny Hong
- Steven Diamond
- Stephen Boyd
year: "2014"
pages: 18--28
booktitle: "HPTCDL'14 Proceedings of the 1st Workshop on High Performance Technical Computing in Dynamic Languages"
publisher: "ACM"
address: "New York"
doi: "10.1109/HPTCDL.2014.5"
arxiv: 1410.4821
packages:
  Convex.jl: https://github.com/JuliaOpt/Convex.jl
---
This paper describes Convex, a convex optimization modeling framework in Julia. Convex translates problems from a user-friendly functional language into an abstract syntax tree describing the problem. This concise representation of the global structure of the problem allows Convex to infer whether the problem complies with the rules of disciplined convex programming (DCP), and to pass the problem to a suitable solver. These operations are carried out in Julia using multiple dispatch, which dramatically reduces the time required to verify DCP compliance and to parse a problem into conic form. Convex then automatically chooses an appropriate backend solver to solve the conic form problem.