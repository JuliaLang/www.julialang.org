---
type: "inproceedings"
title: "Nemo/Hecke: Computer Algebra and Number Theory Packages for the Julia Programming Language"
authors:
- Fieker, Claus
- Hart, William
- Hofmann, Tommy
- Johansson, Fredrik
year: "2017"
pages: "157--164"
booktitle: "Proceedings of the 2017 ACM on International Symposium on Symbolic and Algebraic Computation"
series: "ISSAC '17"
publisher: "ACM"
address: "New York, NY, USA"
doi: "10.1145/3087604.3087611"
packages:
  AbstractAlgebra.jl: https://github.com/Nemocas/AbstractAlgebra.jl
  Nemo.jl: https://github.com/Nemocas/Nemo.jl
  Hecke.jl: https://github.com/thofma/Hecke.jl
---
We introduce two new packages, Nemo and Hecke, written in the Julia programming
language for computer algebra and number theory. We demonstrate that high
performance generic algorithms can be implemented in Julia, without the need to
resort to a low-level C implementation. For specialised algorithms, we use
Julia's efficient native C interface to wrap existing C/C++ libraries such as
Flint, Arb, Antic and Singular. We give examples of how to use Hecke and Nemo
and discuss some algorithms that we have implemented to provide high
performance basic arithmetic.
