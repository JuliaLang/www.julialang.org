---
layout: post
title:  "GSoC 2017: Implementing iterative solvers for numerical linear algebra"
author: Harmen Stoppels, Andreas Noack
---

<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS_HTML"></script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
tex2jax: {
inlineMath: [ ['$','$'], ["\\(","\\)"] ],
displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
processEscapes: true,
processEnvironments: true
},
// Center justify equations in code and markdown cells. Elsewhere
// we use CSS to left justify single line equations in code cells.
displayAlign: 'center',
"HTML-CSS": {
styles: {'.MathJax_Display': {"margin": 0}},
linebreaks: { automatic: true }
}
});
</script>

The central part of my GSoC project is about implementing the Jacobi-Davidson method natively in Julia, available in [JacobiDavidson.jl](https://github.com/haampie/JacobiDavidson.jl). This method computes a few approximate solutions of the eigenvalue problem $Ax = \lambda Bx$ for large and sparse matrices $A$ and $B$. As it uses iterative solvers internally, much time has gone into improving [IterativeSolvers.jl](https://github.com/JuliaMath/IterativeSolvers.jl) in general. Lastly, as iterative solvers are typically used with preconditioners, I have implemented the incomplete LU factorization for sparse matrices as well in [ILU.jl](https://github.com/haampie/ILU.jl).

## JacobiDavidson.jl
The [Jacobi-Davidson implementation](https://github.com/haampie/JacobiDavidson.jl) is ready for use and can be applied to solving the (generalized) eigenvalue problem for non-Hermitian matrices. It's similar to the `eigs` method already available in Julia: it gives you a couple eigenvalues near a specified target in the complex plane.

At this point no official release has been tagged yet, as there is still some work to be done: hopefully the functions for the generalized and ordinary eigenvalue problem can largely be merged as they are very similar. Also, some optimizations for Hermitian problems should yet be implemented; lastly the methods do not yet support generic vectors and numbers.

## IterativeSolvers.jl
We have been preparing a new release of [IterativeSolvers.jl](https://github.com/JuliaMath/IterativeSolvers.jl) that improves speed and memory usage of solvers like GMRES, CG, Chebyshev iteration, stationary methods and the Power Method. Also two new methods MINRES and BiCGStab(l) are available, together with efficient implementations of stationary methods for Julia's `SparseMatrixCSC` matrix type.

Additionally the package has been upgraded to Julia 0.6 and the documentation has been restructured and improved.

## ILU.jl
Iterative methods for linear systems $Ax = b$ such as BiCGStab(l) might not converge quickly on any given matrix $A$. Typically convergence is best if the matrix $A$ is just a perturbation of the identity matrix. If that's not the case, preconditioners might help: rather than solving $Ax = b$ you could try and solve $(PA)x = Pb$ where $P$ is a preconditioner such that $PA$ is closer to the identity matrix.

A perfect preconditioner would compute the full LU decomposition of $A$, but that's too much computational work and would require way to much of memory. A well-known trick is to compute the LU factorization only approximately, by dropping small terms during the process. This is called incomplete LU or ILU.

As ILU for the `SparseMatrixCSC` type was not yet available in Julia, I've implemented it based on the article "Crout versions of ILU for general sparse matrices" by Na Li, Yousef Saad and Edmond Chow.

The package [ILU.jl](https://github.com/haampie/ILU.jl) is completely ready for use and is well tested.

## Examples
Below you can find a few examples on how to use the packages I've been working on.

### Jacobi-Davidson
Let's take a look at a toy example of the generalized eigenvalue problem $Ax = \lambda Bx$ where $A$ and $B$ are diagonal matrices of size $n \times n$ with $A_{kk} = \sqrt{k}$ and $B_{kk} = 1 / \sqrt{k}$. The eigenvalues are just the integers $1, \cdots, n$. Our goal is to find a few eigenvalues right in the interior of the spectrum near $n / 2$.

We implement the action of the matrices $A$ and $B$ matrix-free, using LinearMaps.jl:

```julia
using LinearMaps

function myA!(y, x)
  for i = 1 : length(x)
    @inbounds y[i] = sqrt(i) * x[i]
  end
end

function myB!(y, x)
  for i = 1 : length(x)
    @inbounds y[i] = x[i] / sqrt(i)
  end
end

n = 100_000
A = LinearMap{Complex128}(myA!, n; ismutating = true)
B = LinearMap{Complex128}(myB!, n; ismutating = true)
```

The order of the matrices is `100_000`. It turns out that if we target eigenvalues in the interior of the spectrum, iterative solvers used internally in Jacobi-Davidson might have trouble solving very indefinite systems.

In that case we should use a preconditioner for $(A - \tau B)$, where $\tau$ is the target. We will just use the exact inverse, which is a diagonal matrix $P$ with entries $P_{kk} = \sqrt{k} / (k - \tau)$. It can be implemented matrix-free and in-place:

```julia
import Base.LinAlg.A_ldiv_B!

struct SuperPreconditioner{numT <: Number}
    target::numT
end

function A_ldiv_B!(p::SuperPreconditioner, x)
    for i = 1 : length(x)
        @inbounds x[i] *= sqrt(i) / (i - p.target)
    end
end
```

Now we call Jacobi-Davidson with the `Near` target and pass the preconditioner. We use GMRES as the iterative solver, but we could have used BiCGStabl(l) as well.

```julia
using JacobiDavidson

τ = 50_000.1 + 0im
target = Near(τ)
P = SuperPreconditioner(τ)

schur, residuals = jdqz(A, B, 
    gmres_solver(n, iterations = 10),
    preconditioner = P,
    target = target,
    pairs = 5,
    ɛ = 1e-9,
    min_dimension = 5,
    max_dimension = 10,
    max_iter = 200,
    verbose = true
)
```

It converges to the eigenvalues 49999, 50000, 50001, 50002 and 50004:

```julia
50004.00000000014 + 3.5749921718300463e-12im
49999.999999986496 - 7.348301591250897e-12im
50001.00000000359 - 1.9761169705101647e-11im
49998.99999999998 - 1.0866253642291695e-10im
50002.00000000171 - 2.3559720511618024e-11im
```

It does not yet detect 50003, but that might happen when `pairs` is increased a bit. As a result of our preconditioner, Jacobi-Davidson converges very quickly:

![Residual norm](/images/blog/2017-08-23-native-julia-implementations-of-iterative-solvers-for-numerical-linear-algebra/resnorm.svg)

It's not easy to construct a preconditioner this good for any given problem, but usually people tend to know what works well in specific classes of problems. If no specific preconditioner is availabe, you can always try a general one such as ILU. The next section illustrates that.

### ILU example
As an example of how ILU can be used we generate a non-symmetric, banded matrix having a structure that typically arises in finite differences schemes of three-dimensional problems:

```julia
n = 64
N = n^3
A = spdiagm((fill(-1.0, n - 1), fill(3.0, n), fill(-2.0, n - 1)), (-1, 0, 1))
Id = speye(n)
A = kron(A, Id) + kron(Id, A)
A = kron(A, Id) + kron(Id, A)
x = ones(N)
b = A * x
```

The matrix $A$ has size $64^3 \times 64^3$. We want to solve the problem $Ax = b$ using for instance BiCGStab(2), but it turns out that convergence can get slow when the size of the problem grows. A quick benchmark shows it takes about 2.0 seconds to solve the problem to a reasonable tolerance: 

```julia
> using BenchmarkTools, IterativeSolvers
> my_x = @btime bicgstabl($A, $b, 2, max_mv_products = 2000);
2.051 s
> norm(b - A * my_x) / norm(b)
1.6967043606691152e-9
```

Now let's construct the ILU factorization:

```julia
> using ILU
> LU = crout_ilu(A, τ = 0.1)
> nnz(LU) / nnz(A)
2.1180353639352374
```

Using the above drop tolerance $\tau$, our ILU factorization stores only about twice as many entries as the original matrix, which is reasonable. Let's see what happens when we benchmark the solver again, now with ILU as a preconditioner:

```julia
> my_x = @btime bicgstabl($A, $b, 2, Pl = $LU, max_mv_products = 2000);
692.187 ms
> norm(b - A * my_x) / norm(b)
2.133397068536056e-9
```

It solves the problem 66% faster to the same tolerance. There is of course a caveat, as constructing the preconditioner itself takes time as well:

```julia
> LU = @btime crout_ilu($A, τ = 0.1);
611.019 ms
```

So all in all the problem is solved about 36% faster. However, if we have multiple right-hand sides for the same matrix, we can construct the preconditioner only once and use it multiple times. Even when the matrix changes slightly you could reuse the ILU factorization. The latter is exactly what happens in Jacobi-Davidson.

## Acknowledgements

I would really want to thank my GSoC mentor Andreas Noack for the many discussions we had in chat and video calls. Also I would like to thank the Julia community in general for giving me a warm welcome, both online and at JuliaCon 2017.