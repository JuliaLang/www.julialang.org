---
type: "article"
title: "Julia: A Fresh Approach to Numerical Computing"
authors:
- Jeff Bezanson
- Alan Edelman
- Stefan Karpinski
- Viral B. Shah
year: "2017"
journal: "SIAM Review"
volume: "59"
number: "1"
pages: 65--98
doi: "10.1137/141000671"
link: "http://julialang.org/publications/julia-fresh-approach-BEKS.pdf"
---
Bridging cultures that have often been distant, Julia combines expertise from the diverse fields of computer science and computational science to create a new approach to numerical computing. Julia is designed to be easy and fast and questions notions generally held to be “laws of nature" by practitioners of numerical computing: (1) High-level dynamic programs have to be slow; (2) One must prototype in one language and then rewrite in another language for speed or deployment; (3) There are parts of a system appropriate for the programmer, and other parts that are best left untouched as they have been built by the experts. We introduce the Julia programming language and its design---a dance between specialization and abstraction. Specialization allows for custom treatment. Multiple dispatch, a technique from computer science, picks the right algorithm for the right circumstance. Abstraction, which is what good computation is really about, recognizes what remains the same after differences are stripped away. Abstractions in mathematics are captured as code through another technique from computer science, generic programming. Julia shows that one can achieve machine performance without sacrificing human convenience.