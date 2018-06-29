---
type: "article"
title: "Fast computation of Gauss quadrature nodes and weights on the whole real line"
authors:
- Alex Townsend
- Thomas Trogdon
- Sheehan Olver
year: "2014"
packages:
  FastGaussQuadrature.jl: https://github.com/ajt60gaibb/FastGaussQuadrature.jl
---
A fast and accurate algorithm for the computation of Gauss-Hermite and generalized Gauss-Hermite quadrature nodes and weights is presented. The algorithm is based on Newton's method with carefully selected initial guesses for the nodes and a fast evaluation scheme for the associated orthogonal polynomial. In the Gauss-Hermite case the initial guesses and evaluation scheme rely on explicit asymptotic formulas. For generalized Gauss-Hermite, the initial guesses are furnished by sampling a certain equilibrium measure and the associated polynomial evaluated via a Riemann-Hilbert reformulation. In both cases the n-point quadrature rule is computed in O(n) operations to an accuracy that is close to machine precision. For sufficiently large n, some of the quadrature weights have a value less than the smallest positive normalized floating-point number in double precision and we exploit this fact to achieve a complexity as low as O(sqrt(n))).