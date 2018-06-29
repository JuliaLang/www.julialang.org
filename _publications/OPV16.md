---
type: "article"
title: "Introduction to the equilibrium Green's functions: condensed matter examples with numerical implementations"
authors:
- Mariana M. Odashima
- Beatriz G. Prado
- E. Vernek
year: "2016"
pages: "1--20"
arxiv: 1604.02499
---
The Green's function method has applications in several fields in Physics, from classical differential equations to quantum many-body problems. In the quantum context, Green's functions are correlation functions, from which it is possible to extract information from the system under study, such as the density of states, relaxation times and response functions. Despite its power and versatility, it is known as a laborious and sometimes cumbersome method. Here we introduce the equilibrium Green's functions and the equation-of-motion technique, exemplifying the method in discrete lattices of non-interacting electrons. We start with simple models, such as the two-site molecule, the infinite and semi-infinite one-dimensional chains, and the two-dimensional ladder. Numerical implementations are developed via the recursive Green's function, implemented in Julia, an open-source, efficient and easy-to-learn scientific language. We also present a new variation of the surface recursive Green's function method, which can be of interest when simulating simultaneously the properties of surface and bulk.