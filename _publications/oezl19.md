---
type: "article"
title: "Thermodynamic Property and Fluid Modeling with Modern Programming Language Constructs"
journal: "Modelica'2019 - Proceedings of the 13th International Modelica Conference"
authors:
- Martin Otter
- Hilding Elmqvist
- Dirk Zimmer
- Christopher Laughman
year: "2019"
pages: 
doi: https://doi.org/10.3384/ecp19157589
arxiv:
packages:
  ModiaMedia.jl: https://github.com/ModiaSim/ModiaMedia.jl
---

Modelica is used extensively to model thermo-fluid pipe networks. 
Experience shows that Modelica models in this domain have limitations
due to missing functional expressiveness of the Modelica language.
In this paper, a prototype is described that demonstrates how thermodynamic
property and thermo-fluid pipe component modeling could be considerably
enhanced via modern language constructs available in Julia.
This prototype is based on the Modia modelling and simulation prototype and 
relies on features of the Julia programming language. 
It utilizes some key ideas of Modelica.Media, and part of 
Modelica.Media was semi-automatically translated to Julia.
