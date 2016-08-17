---
layout: post
title: Announcing support for complex-domain linear programs in Convex.jl
author: Ayush Pandey
---

I am pleased to announce the support for complex-domain linear programs (LPs) in Convex.jl. As one of the *Google Summer of Code* students under *The Julia Language*, I had proposed to implement the support for complex semidefinite programming. In the first phase of project, I started by tackling the problem of complex-domain LPs where in first subphase, I had announced the support for complex coefficients during [JuliaCon'16](https://www.youtube.com/watch?v=fHG4uEOlMbY) and now I take this opportunity to announce the support for complex variables in LPs.

Complex-domain LPs consist of a real linear objective function, real linear inequality constraints, and real and complex linear equality constraints.

In order to enable complex-domain LPs, we came up with these ideas:

1. We redefined the **conic_form!** of every affine atom to accept complex arguments.
2. Every complex variable z was internally represented as `z = z1 + i*z2`, where z1 and z2 are real.
3. We introduced two new affine atoms **real** and **imag** which return the real and the imaginary parts of the complex variable respectively.
4. transpose and ctranspose perform differently on complex variables so a new atom **CTransposeAtom** was created.
5. A complex-equality constraint *RHS = LHS* can be decomposed into two corresponding real equalities constraint *real(RHS) = real(LHS)* and *imag(RHS) = imag(LHS)*

After above changes were made to the codebase, we wrote two use cases to demonstrate the usability and the correctness of our idea which I am presenting below:

    # Importing Packages
    Pkg.clone("https://github.com/Ayush-iitkgp/Convex.jl/tree/gsoc2")
    using Convex
 
    # Complex LP with real variable
    n = 10 # variable dimension (parameter)
    m = 5 # number of constraints (parameter)
    xo = rand(n)
    A = randn(m,n) + im*randn(m,n)
    b = A * xo 
    # Declare a real variable
    x = Variable(n)
    p1 = minimize(sum(x), A*x == b, x>=0) 
    # Notice A*x==b is complex equality constraint 
    solve!(p1)
    x1 = x.value
    
    # Let's now solve by decomposing complex equality constraint into the corresponding real and imaginary part.
    p2 = minimize(sum(x), real(A)*x == real(b), imag(A)*x==imag(b), x>=0)
    solve!(p2)
    x2 = x.value
    x1==x2 # should return true
    

    # Let's now consider an example using a complex variable
    # Complex LP with complex variable
    n = 10 # variable dimension (parameter)
    m = 5 # number of constraints (parameter)
    xo = rand(n)+im*rand(n)
    A = randn(m,n) + im*randn(m,n)
    b = A * xo
    
    # Declare a complex variable
    x = ComplexVariable(n)
    p1 = minimize(real(sum(x)), A*x == b, real(x)>=0, imag(x)>=0)
    solve!(p1)
    x1 = x.value
    
    xr = Variable(n)
    xi = Variable(n)
    p2 = minimize(sum(xr), real(A)*xr-imag(A)*xi == real(b), imag(A)*xr+real(A)*xi == imag(b), xr>=0, xi>=0)
    solve!(p2)
    x1== xr.value + im*xi.value # should return true

List of all the affine atoms are as follows:

1. addition, substraction, multiplication, division
2. indexing and slicing
3. k-th diagonal of a matrix
4. construct diagonal matrix
5. transpose and ctranspose
6. stacking
7. sum
8. trace
9. conv
10. real and imag

Now, I am working towards implementing complex-domain second order conic programming. Meanwhile, I invite the Julia community to play around with the complex-domain LPs. The link to the development branch is [here](https://github.com/Ayush-iitkgp/Convex.jl/tree/gsoc2).

Looking forward to your suggestions!

Special thanks to my mentors Madeleine Udell and Dvijotham Krishnamurthy!