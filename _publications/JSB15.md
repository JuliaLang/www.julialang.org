---
type: "article"
title: "Accurate eigenvalue decomposition of real symmetric arrowhead matrices and applications"
authors:
- N. Jakovčević Stor
- I. Slapničar
- J. L. Barlow
year: "2015"
journal: "Linear Algebra and its Applications"
volume: "464"
pages: "62--89"
doi: "10.1016/j.laa.2013.10.007"
packages:
  Arrowhead.jl: https://github.com/ivanslapnicar/Arrowhead.jl
---
We present a new algorithm for solving the eigenvalue problem
for an n × n real symmetric arrowhead matrix. The algorithm
computes all eigenvalues and all components of the corresponding
eigenvectors with high relative accuracy in O(n^2) operations under
certain circumstances. The algorithm is based on a shift-and-invert
approach. Only a single element of the inverse of the shifted
matrix eventually needs to be computed with double the working
precision. Each eigenvalue and the corresponding eigenvector can
be computed separately, which makes the algorithm adaptable for
parallel computing. Our results extend to Hermitian arrowhead
matrices, real symmetric diagonal-plus-rank-one matrices and
singular value decomposition of real triangular arrowhead matrices.