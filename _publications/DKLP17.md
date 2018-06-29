---
type: "article"
title: "Recompression of Hadamard Products of Tensors in Tucker Format"
authors:
- Kressner, Daniel
- Periša, Lana
year: "2017"
journal: "SIAM J. Sci. Comput."
volume: "39"
issue: "5"
pages: "A1879--A1902"
link: "http://sma.epfl.ch/~anchpcommon/publications/ttensors_pp.pdf"
packages:
  TensorToolbox.jl: https://github.com/lanaperisa/TensorToolbox.jl
---
The Hadamard product features prominently in tensor-based algorithms in scientific 
computing and data analysis. Due to its tendency to significantly increase ranks, 
the Hadamard product can represent a major computational obstacle in algorithms based 
on low-rank tensor representations. It is therefore of interest to develop recompression 
techniques that mitigate the effects of this rank increase. In this work, we investigate 
such techniques for the case of the Tucker format, which is well suited for tensors of 
low order and small to moderate multilinear ranks. Fast algorithms are attained by 
combining iterative methods, such as the Lanczos method and randomized algorithms, 
with fast matrix-vector products that exploit the structure of Hadamard products. 
The resulting complexity reduction is particularly relevant for tensors featuring large 
mode sizes $I$ and small to moderate multilinear ranks $R$. To implement our algorithms, 
we have created a new Julia library for tensors in Tucker format.


