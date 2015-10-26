---
layout: post
title: "JSoC 2015 project: Automatic Differentiation in Julia with ForwardDiff.jl"
author: Jarrett Revels
---

<script type="text/javascript"
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

This summer, I've had the good fortune to be able to participate in the first ever **Julia Summer of Code (JSoC)**, generously sponsored by the Gordon and Betty Moore Foundation. My JSoC project was to explore the use of Julia for automatic differentiation (AD), a topic with a wide array of applications in the field of optimization.

Under the mentorship of Miles Lubin and Theodore Papamarkou, I completed a major overhaul of **[ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl)**, a Julia package for calculating derivatives, gradients, Jacobians, Hessians, and higher-order derivatives of native Julia functions (or any callable Julia type, really).

By the end of this post, you'll hopefully know a little bit about how ForwardDiff.jl works, why it's useful, and why Julia is uniquely well-suited for AD compared to other languages.

# What is Automatic Differentiation?

In broad terms, [automatic differentiation](https://en.wikipedia.org/wiki/Automatic_differentiation) describes a class of algorithms for automatically taking exact derivatives of user-provided functions. In addition to producing more accurate results, AD methods are also often faster than other common differentiation methods (such as [finite differencing](https://en.wikipedia.org/wiki/Numerical_differentiation)).

The two main flavors of AD are called *forward mode* and *reverse mode*. As you might've guessed, this post only discusses forward mode, which is the kind of AD implemented by ForwardDiff.jl.

# Seeing ForwardDiff.jl In Action

Before we get down to the nitty-gritty details, it might be helpful to see a simple example that illustrates various methods from ForwardDiff.jl's API.

The snippet below is a somewhat contrived example, but works well enough as an introduction to the package. First, we define a target function we'd like to differentiate, then use ForwardDiff.jl to calculate some derivatives of the function at a given input:

    julia> using ForwardDiff

    julia> f(x::Vector) = sum(sin, x) + prod(tan, x) * sum(sqrt, x);

    julia> x = rand(5)
    5-element Array{Float64,1}:
     0.986403
     0.140913
     0.294963
     0.837125
     0.650451

    julia> g = ForwardDiff.gradient(f); # g = ∇f

    julia> g(x)
    5-element Array{Float64,1}:
     1.01358
     2.50014
     1.72574
     1.10139
     1.2445

    julia> j = ForwardDiff.jacobian(g); # j = J(∇f)

    julia> j(x)
    5x5 Array{Float64,2}:
     0.585111  3.48083  1.7706    0.994057  1.03257
     3.48083   1.06079  5.79299   3.25245   3.37871
     1.7706    5.79299  0.423981  1.65416   1.71818
     0.994057  3.25245  1.65416   0.251396  0.964566
     1.03257   3.37871  1.71818   0.964566  0.140689

    julia> ForwardDiff.hessian(f, x) # H(f)(x) == J(∇f)(x), as expected
    5x5 Array{Float64,2}:
     0.585111  3.48083  1.7706    0.994057  1.03257
     3.48083   1.06079  5.79299   3.25245   3.37871
     1.7706    5.79299  0.423981  1.65416   1.71818
     0.994057  3.25245  1.65416   0.251396  0.964566
     1.03257   3.37871  1.71818   0.964566  0.140689


Tada!

Okay, that's not *too* exciting - I could've just done the same thing with Calculus.jl. Why would I ever want to use ForwardDiff.jl?

The simple answer is that ForwardDiff.jl's AD-based methods are, in many cases, much more performant than the finite differencing methods implemented in other packages.

# How ForwardDiff.jl Works - An Overview

The key technique leveraged by ForwardDiff.jl is the implementation of several different `ForwardDiffNumber` types, each of which allocate storage space for both normal values and derivative values. Elementary numerical functions on a `ForwardDiffNumber` are then overloaded to evaluate both the original function and the function's derivative, returning the results in the form of a new `ForwardDiffNumber`.

Thus, we can pass these number types into a general function $$f$$ (which is assumed to be composed of the overloaded elementary functions), and the derivative information is naturally propagated at each step of the calculation by way of the chain rule. The final result of the evaluation (usually a `ForwardDiffNumber` or an array of them) then contains both $$f(x)$$ and $$f'(x)$$, where $$x$$ was the original point of evaluation.

# Simple Forward Mode AD in Julia

The easiest way to write actual Julia code demonstrating this technique is to implement a simple [dual number](https://en.wikipedia.org/wiki/Dual_number) type. Note that there is already [a Julia package](https://github.com/JuliaDiff/DualNumbers.jl) dedicated to such an implementation, but we're going to roll our own here for pedagogical purposes.

Here's how we'll define our `DualNumber` type:

    immutable DualNumber{T} <: Number
        value::T
        deriv::T
    end

    value(d::DualNumber) = d.value
    deriv(d::DualNumber) = d.deriv

Next, we can start defining functions on `DualNumber`. Here are a few examples to give you a feel for the process:

    function Base.sqrt(d::DualNumber)
        new_value = sqrt(value(d))
        new_deriv = 0.5 / new_value
        return DualNumber(new_value, new_deriv*deriv(d))
    end

    function Base.sin(d::DualNumber)
        new_value = sin(value(d))
        new_deriv = cos(value(d))
        return DualNumber(new_value, new_deriv*deriv(d))
    end

    function Base.(:+)(a::DualNumber, b::DualNumber)
        new_value = value(a) + value(b)
        new_deriv = deriv(a) + deriv(b)
        return DualNumber(new_value, new_deriv)
    end

    function Base.(:*)(a::DualNumber, b::DualNumber)
        val_a, val_b = value(a), value(b)
        new_value = val_a * val_b
        new_deriv = val_b * deriv(a) + val_a * deriv(b)
        return DualNumber(new_value, new_deriv)
    end

We can now evaluate the derivative of *any scalar function composed of the above elementary functions*. To do so, we simply pass an instance of our `DualNumber` type into the function, and extract the derivative from the result. For example:

    julia> f(x) = sqrt(sin(x * x)) + x
    f (generic function with 1 method)

    julia> f(1.0)
    1.8414709848078965

    julia> d = f(DualNumber(1.0, 1.0))
    DualNumber{Float64}(1.8414709848078965,1.5403023058681398)

    julia> deriv1 = deriv(d)
    1.589002649374538

    julia> using Calculus; deriv2 = Calculus.derivative(f, 1.0)
    1.5890026493377403

    julia> deriv1 - deriv2
    3.679767601738604e-11

Notice that our dual number result comes *close* to the result obtained from Calculus.jl, but is actually slightly different. That slight difference is due to the approximation error inherent to the finite differencing method employed by Calculus.jl.

In reality, the number types that ForwardDiff.jl provides are quite a bit more complicated than `DualNumber`. Instead of simple dual numbers, the various `ForwardDiffNumber` types behave like *ensembles* of dual numbers and [hyper-dual numbers](https://adl.stanford.edu/hyperdual/Fike_AIAA-2011-886.pdf) (the higher-order analog of dual numbers). This ensemble-based approach allows for simultaneous calculation of multiple higher-order partial derivatives in a single evaluation of the target function. For an in-depth examination of ForwardDiff.jl's number type implementation, see [this section of the developer documentation](http://www.juliadiff.org/ForwardDiff.jl/types.html).

# Performance Comparison: The Ackley Function

The best way to illustrate the performance gains that can be achieved using ForwardDiff.jl is to do some benchmarking. Let's compare the time to calculate the gradient of a function using ForwardDiff.jl, Calculus.jl, and a Python-based AD tool, AlgoPy.

The function we'll be using in our test is the [Ackley function](http://www.sfu.ca/~ssurjano/ackley.html), which is mathematically defined as

$$f(\vec{x}) = -a \exp\left( -b \sqrt{\frac{1}{k} \sum_{i=1}^k x^{2}_{i}} \right) - \exp\left(\frac{1}{k} \sum_{i=1}^k \cos(cx_{i})\right) + a + \exp(1)$$

Here's the definition of the function in Julia:

    function ackley(x)
        a, b, c = 20.0, -0.2, 2.0*π
        len_recip = inv(length(x))
        sum_sqrs = zero(eltype(x))
        sum_cos = sum_sqrs
        for i in x
            sum_cos += cos(c*i)
            sum_sqrs += i^2
        end
        return (-a * exp(b * sqrt(len_recip*sum_sqrs)) -
                exp(len_recip*sum_cos) + a + e)
    end

...and here's the corresponding Python definition:

    def ackley(x):
        a, b, c = 20.0, -0.2, 2.0*numpy.pi
        len_recip = 1.0/len(x)
        sum_sqrs, sum_cos = 0.0, 0.0
        for i in x:
            sum_cos += algopy.cos(c*i)
            sum_sqrs += i*i
        return (-a * algopy.exp(b*algopy.sqrt(len_recip*sum_sqrs)) -
                algopy.exp(len_recip*sum_cos) + a + numpy.e)

# Performance Comparison: The Results

The benchmarks were performed with input vectors of length 16, 1600, and 16000, taking the best time out of 5 trials for each test. I ran them on a late 2013 MacBook Pro (OSX 10.9.5, 2.6 GHz Intel Core i5, 8 GB 1600 MHz DDR3) with the following versions of the relevant libraries: Julia v0.4.1-pre+15, Python v2.7.9, ForwardDiff.jl v0.1.2, Calculus.jl v0.1.13, and AlgoPy v0.5.1.

Let's start by looking at the evaluation times of `ackley(x)` in both Python and Julia:

| length(x)&emsp; | Python time (s)&emsp; | Julia time (s)&emsp; | Speed-Up vs. Python&emsp;  |
|-----------|-----------------|----------------|----------------------|
| 16        | 0.00011         | 2.3e-6         | 47.83x               |
| 1600      | 0.00477         | 4.0269e-5      | 118.45x              |
| 16000     | 0.04747         | 0.00037        | 128.30x              |

As you can see, there's already a significant performance difference between the languages. We'll have to keep that in mind when comparing our Julia differentiation tools with AlgoPy, in order to avoid confusing the languages' performance characteristics with those of the libraries (though there is obviously a solid coupling between the two concepts).

The below table shows the evaluation times of `∇ackley(x)` using various libraries (the `chunk_size` column denotes a configuration option passed to the `ForwardDiff.gradient` method, see the [chunk-mode docs](http://www.juliadiff.org/ForwardDiff.jl/chunk_vec_modes.html) for details.):

| length(x)&emsp; | AlgoPy time (s)&emsp; | Calculus.jl time (s)&emsp; | ForwardDiff time (s)&emsp; | chunk_size&emsp; |
|-----------|-----------------|----------------------|----------------------|--------------|
| 16        | 0.00212         | 2.2e-5               |  3.5891e-5           | 16           |
| 1600      | 0.53439         | 0.10259              |  0.01304             | 10           |
| 16000     | 101.55801       | 11.18762             |  1.35411             | 10           |

From the above tables, we can calculate the speed-up ratio of ForwardDiff.jl over the other libraries:

| length(x)&emsp; | Speed-Up vs. AlgoPy&emsp; | Speed-Up vs. Calculus.jl&emsp; |
|-----------|---------------------|--------------------------|
| 16        | 59.07x              | 0.61x                    |
| 1600      | 40.98x              | 7.86x                    |
| 16000     | 74.99x              | 8.26x                    |

As you can see, Python + AlgoPy falls pretty short of the speeds achieved by Julia + ForwardDiff.jl, or even Julia + Calculus.jl. While Calculus.jl is actually almost twice as fast as ForwardDiff.jl for the lowest input dimension vector, it is ~8 times slower than ForwardDiff.jl for the higher input dimension vectors.

Another metric that might be useful to look at is the "slowdown ratio" between the gradient evaluation time and the function evaluation time, defined as:

$$\text{slowdown ratio} = \frac{\text{gradient time}}{\text{function time}}$$

Here are the results (lower is better):

| length(x)&emsp; | AlgoPy ratio&emsp; | Calculus.jl ratio&emsp; | ForwardDiff.jl ratio&emsp; |
|-----------|--------------|-------------------|----------------------|
| 16        | 19.27        | 9.56              | 15.60                |
| 1600      | 112.03       | 2547.61           | 323.82               |
| 16000     | 2139.41      | 30236.81          | 3659.77              |

Both AlgoPy and ForwardDiff.jl beat out Calculus.jl for evaluation at higher input dimensions, which isn't too surprising. AlgoPy beating ForwardDiff.jl, though, might catch you off guard - ForwardDiff.jl had the fastest absolute runtimes, after all! One explanation for this outcome is that AlgoPy falls back to vectorized Numpy methods when calculating the gradient, while the `ackley` function itself uses your usual, slow Python scalar arithmetic. Julia's scalar arithmetic performance is *much* faster than Python's, so ForwardDiff.jl doesn't have as much "room for improvement" as AlgoPy does.

# Julia's AD Advantage

At the beginning of this post, I promised I would give the reader an answer to the question: "Why is Julia uniquely well-suited for AD compared to other languages?"

There are several good answers, but the chief reason for Julia’s superiority is its efficient implementation of *multiple dispatch*.

Unlike many other languages, Julia’s type-based operator overloading is fast and natural, as it's one of the central design tenets of the language. Since Julia is JIT-compiled, the bytecode representation of a Julia function can be tied directly to the types with which the function is called. This allows the compiler to optimize every Julia method for the specific input type at runtime.

This ability is phenomenally useful for implementing forward mode AD, which relies almost entirely on operator overloading in order to work. In most other scientific computing languages, operator overloading is either very slow (e.g. MATLAB), fraught with weird edge cases (e.g. Python), arduous to implement generally (e.g. C++) or some combination of all three. In addition, very few languages allow operator overloading to naturally extend to native, black-box, user-written code. Julia's multiple dispatch is the secret weapon leveraged by ForwardDiff.jl to overcome these hurdles.

# Future Directions

The new version of ForwardDiff.jl has just been released, but development of the package is still ongoing! Here's a list of things I'd like to see ForwardDiff.jl support in the future:

- More elementary function definitions on `ForwardDiffNumber` types
- More optimized versions of existing elementary function definitions on `ForwardDiffNumber` types
- Methods for evaluating Jacobian-matrix products (highly useful in conjunction with reverse mode AD).
- Parallel/shared-memory/distributed-memory versions of current API methods for handling problems with huge input/output dimensions
- A more robust benchmarking suite for catching performance regressions

If you have any ideas on how to make ForwardDiff.jl more useful, feel free to open a pull request or issue in [the package's GitHub repository](https://github.com/JuliaDiff/ForwardDiff.jl).
