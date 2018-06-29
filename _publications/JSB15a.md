---
type: "article"
title: "Forward stable eigenvalue decomposition of rank-one modifications of diagonal matrices"
authors:
- N. Jakovčević Stor
- I. Slapničar
- J. L. Barlow
year: "2015"
journal: "Linear Algebra and its Applications"
volume: "487"
pages: "301--315"
doi: "10.1016/j.laa.2015.09.025"
packages:
  Arrowhead.jl: https://github.com/ivanslapnicar/Arrowhead.jl
---
We present a new algorithm for solving an eigenvalue problem for a real symmetric matrix which is a rank-one modification of a diagonal matrix. The algorithm computes each eigenvalue and all components of the corresponding eigenvector with high relative accuracy in O(n) operations. The algorithm is based on a shift-and-invert approach. Only a single element of the inverse of the shifted matrix eventually needs to be computed with double the working precision. Each eigenvalue and the corresponding eigenvector can be computed separately, which makes the algorithm adaptable for parallel computing. Our results extend to the complex Hermitian case. The algorithm is similar to the algorithm for solving the eigenvalue problem for real symmetric arrowhead matrices from N. Jakovčević Stor et al. (2015) [16].