@def rss_pubdate = Date(2022, 2, 12)
@def rss = """10x-ing PyTorch: Specializing Scientific Machine Learning with Julia ..."""
@def published = "12 February 2022"
@def title = "10x-ing PyTorch: Specializing Scientific Machine Learning with Julia"
@def authors = """Chris Elrod, Chris Rackauckas"""
@def mintoclevel=2
@def maxtoclevel=3

# 10x-ing PyTorch: Specializing Scientific Machine Learning with Julia

Machine learning is a huge discipline, with applications ranging from natural language processing to solving partial differential equations. It is from this landscape that major frameworks, such as PyTorch, TensorFlow, and [Flux.jl](https://fluxml.ai/), arise to be packages for "all of machine learning". While some of these frameworks have the backings of megacorporations, specifically Facebook and Google, driving their development, the Julia community has relied on the speed and productivity of the Julia programming language itself in order for its open source community to keep up with the pace of development. It is from this aspect which Flux.jl derives its "slimness": while PyTorch and TensorFlow include entire separate languages and compilers (torchscript, XLA, etc.), Flux.jl is just Julia. It is from this that the moniker "you could have built it yourself" is commonly used to describe Flux.jl.

However, in this post we'll take a different look at how the programmability of Julia can help in the machine learning space. Specifically, by targetting the grand space of "all machine learning", the frameworks inevitably make trade-offs that accelerate some aspects of the code at the detriment to others. This comes from the inevitable trade-off between simplicity, generality, and performance. However, the ability to easily construct machine learning libraries thus presents an interesting question: can this development feature be used to easily create alternative frameworks which focus its performance on more non-traditional applications or aspects?

The answer is yes, you can quickly build machine learning frameworks which greatly outperform the giants in specialized cases using the Julia programming language, and we demonstrate this with our new release [SimpleChains.jl](https://github.com/PumasAI/SimpleChains.jl).

#### Note before we start

If you're interested in this topic and want to work on Julia machine learning, note that the [Pumas DeepPumas team is hiring](https://pumas.ai/company/machine-learning-scientist/). Additionally, [internships are available at Julia Computing](https://jobs.juliacomputing.com/jobs/ndvlJz9fHYcr/machine-learning-intern-remote).

## Scientific Machine Learning (SciML) and "Small" Neural Networks

SimpleChains.jl is a library developed by [Julia Computing](https://juliacomputing.com/) and [Pumas-AI](https://pumas.ai/) in collaboration with [Roche](https://www.roche.com/) and the [University of Maryland, Baltimore](https://www.pharmacy.umaryland.edu/centers/ctm/). The purpose of SimpleChains.jl is to be as fast as possible for small neural networks. This is because SimpleChains.jl originated as a solution for the DeepPumas product for [scientific machine learning (SciML)](https://www.stochasticlifestyle.com/the-essential-tools-of-scientific-machine-learning-scientific-ml/) in clinical pharmacology. In this domain, small neural networks are combined with known nonlinear mixed effects models (statistical models with differential equations) to discover previously unknown mechanisms and prognostic factors. For a short introduction to how this is done, check out the following video by Niklas Korsbo:

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/TFB_lt1KMto" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

This [SciML methodology](https://sciml.ai/roadmap/) has been shown across many disciplines, from black hole dynamics to the development of earthquake safe buildings, to be a flexible method capable of discovering/guiding (bio)physical equations. Here's a recent talk which walks through the various use cases of SciML throughout the sciences:

~~~
<iframe width="560" height="315" src="https://www.youtube.com/embed/eSeY4K4bITI?start=668" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

For more details on the software and methods, [check out this manuscript](https://arxiv.org/abs/2001.04385). 

However, the unique aspects of how neural networks are used in these contexts make it rife for specializing of performance. Specifically, in the context of machine learning one normally relies on the following assumption: the neural networks are large enough that the O(n^3) cost of matrix-matrix multiplication (or other kernels like convolutions) domainates the the runtime. This is essentially the guiding principle behind most of the mechanics of a machine learning library:

1. Matrix-matrix multiplication scales cubicly while memory allocations scale linearly, so attempting to mutate vectors with non-allocating operations is not a high priority. Just use `A*x`.
2. Focus on accelearting GPU kernels to be as fast as possible! Since these large matrix-matrix operations will be fastest on GPUs and are the bottleneck, performance benchmarks will essentially just be a measurement of how fast these specific kernels are.
3. When doing reverse-mode automatic differentiation (backpropagation), feel free to copy values to memory. Memory allocations will be hidden by the larger kernel calls. 
4. Also, feel free to write a "tape" for generating backpropagation. The tape does add the cost of essentially building a dictionary during the forward pass, but that will be hidden by the larger kernel calls.

Do these assumptions actually hold in our case? And if they don't, can we focus on these aspects to draw more performance out for our use cases?

## Digging In: Small Neural Network Performance Overheads

It's easy to show that these assumptions breakdown when we start focusing on this smaller neural network use case. For starters, lets look at assumptions (1)(2). It's not hard to show where these two will unravel:

```julia
using LinearAlgebra, BenchmarkTools, CUDA, LoopVectorization

function mygemmturbo!(C, A, B)
    @tturbo for m ∈ axes(A, 1), n ∈ axes(B, 2)
        Cmn = zero(eltype(C))
        for k ∈ axes(A, 2)
            Cmn += A[m, k] * B[k, n]
        end
        C[m, n] = Cmn
    end
end

function alloc_timer(n)
    A = rand(Float32,n,n)
    B = rand(Float32,n,n)
    C = rand(Float32,n,n)
    t1 = @belapsed $A * $B
    t2 = @belapsed (mul!($C,$A,$B))
    t3 = @belapsed (mygemmturbo!($C,$A,$B))
    A,B,C = (cu(A), cu(B), cu(C))
    t4 = @belapsed CUDA.@sync($A * $B)
    t5 = @belapsed CUDA.@sync(mul!($C,$A,$B))
    t1,t2,t3,t4,t5
end
ns = 2 .^ (2:11)
res = [alloc_timer(n) for n in ns]
alloc      = [x[1] for x in res]
noalloc    = [x[2] for x in res]
noalloclv  = [x[3] for x in res]
allocgpu   = [x[4] for x in res]
noallocgpu = [x[5] for x in res]

using Plots
plot(ns, alloc, label="*", xscale=:log10, yscale=:log10, legend=:bottomright,
    title="Which Micro-optimizations matter for BLAS3?",
    yticks=10.0 .^ (-8:0.5:2),
    ylabel="Time (s)", xlabel="N",)
plot!(ns,noalloc,label="mul! (OpenBLAS)")
plot!(ns,noalloclv,label="mygemmturbo!")
plot!(ns,allocgpu,label="* gpu")
plot!(ns,noallocgpu,label="mul! gpu")
savefig("microopts_blas3.png")
```

![](https://user-images.githubusercontent.com/1814174/162625573-0c195a60-dc06-44fb-af04-6c0c389ded02.png)

When we get to larger matrix-matrix operations, such as 100x100 * 100x100, we can effectively write off any overheads due to memory allocations. But we definitely see that there is a potential for some fairly significant performance gains in the lower end! Notice too that these gains are realized by using the pure-Julia LoopVectorization.jl as the standard BLAS tools tend to have extra threading overhead in this region (again, not optimizing as much in this region). 

But, if you've been riding the GPU gospel without looking into the details then this plot may be a shocker! However, GPUs are designed as dumb slow chips with many cores, and thus they are only effective on very parallel operations, such as large matrix-matrix multiplications. It is from this point that assumption (2) is derived for large newtork operations. But again, in the case of small networks such GPU kernels will be outperformed by well-designed CPU kernels due to the lack of parallel opportunities.

Matrix-matrix operations only occur when batching is able to be used (where each column of the B matrix in A*B is a separate batch). In many cases in scientific machine learning, such as [the calculation of vector-Jacobian products in ODE adjoints](https://youtu.be/6hhF6Llv4sI?t=342), this operation is a matrix-vector multiplication. These operations are smaller and only O(n^2), and as you would guess these effects are amplified in this scenario:

```julia
using LinearAlgebra, BenchmarkTools, CUDA, LoopVectorization

function mygemmavx!(C, A, B)
    @tturbo for m ∈ axes(A, 1), n ∈ axes(B, 2)
        Cmn = zero(eltype(C))
        for k ∈ axes(A, 2)
            Cmn += A[m, k] * B[k, n]
        end
        C[m, n] = Cmn
    end
end

function alloc_timer(n)
    A = rand(Float32,n,n)
    B = rand(Float32,n)
    C = rand(Float32,n)
    t1 = @belapsed $A * $B
    t2 = @belapsed (mul!($C,$A,$B))
    t3 = @belapsed (mygemmavx!($C,$A,$B))
    A,B,C = (cu(A), cu(B), cu(C))
    t4 = @belapsed CUDA.@sync($A * $B)
    t5 = @belapsed CUDA.@sync(mul!($C,$A,$B))
    t1,t2,t3,t4,t5
end
ns = 2 .^ (2:11)
res = [alloc_timer(n) for n in ns]
alloc      = [x[1] for x in res]
noalloc    = [x[2] for x in res]
noalloclv  = [x[3] for x in res]
allocgpu   = [x[4] for x in res]
noallocgpu = [x[5] for x in res]

using Plots
plot(ns, alloc, label="* (OpenBLAS)", xscale=:log10, yscale=:log10, legend=:bottomright,
    title="Which Micro-optimizations matter for BLAS2?",
    yticks=10.0 .^ (-8:0.5:2),
    ylabel="Time (s)", xlabel="N",)
plot!(ns,noalloc,label="mul! (OpenBLAS)")
plot!(ns,noalloclv,label="mygemvavx!")
plot!(ns,allocgpu,label="* gpu")
plot!(ns,noallocgpu,label="mul! gpu")
savefig("microopts_blas2.png")
```

![](https://user-images.githubusercontent.com/1814174/162625320-310d633a-34bf-407e-8cc9-ec55ca895d83.png)

And remember, the basic operations of a neural network are `sigma.(W*x .+ b)`, and thus there's also an O(n) element-wise operation. As you would guess, this operation becomes more significant as n gets smaller and is requires even more consideration for memory operations. 

```julia
using LinearAlgebra, BenchmarkTools, CUDA, LoopVectorization

function mybroadcastavx!(C, A, B)
    @tturbo for k ∈ axes(A, 2)
        C[k] += A[k] * B[k]
    end
end

function alloc_timer(n)
    A = rand(Float32,n,n)
    B = rand(Float32,n,n)
    C = rand(Float32,n,n)
    t1 = @belapsed $A .* $B
    t2 = @belapsed ($C .= $A .* $B)
    t3 = @belapsed (mybroadcastavx!($C, $A, $B))
    A,B,C = (cu(A), cu(B), cu(C))
    t4 = @belapsed CUDA.@sync($A .* $B)
    t5 = @belapsed CUDA.@sync($C .= $A .* $B)
    t1,t2,t3,t4,t5
end
ns = 2 .^ (2:11)
res = [alloc_timer(n) for n in ns]
alloc      = [x[1] for x in res]
noalloc    = [x[2] for x in res]
noalloclv  = [x[3] for x in res]
allocgpu   = [x[4] for x in res]
noallocgpu = [x[5] for x in res]

using Plots
plot(ns,alloc,label="=",xscale=:log10,yscale=:log10,legend=:bottomright,
     title="Which Micro-optimizations matter for BLAS1?",
     ylabel = "Time (s)", xlabel = "N",
     yticks = 10.0 .^ (-8:0.5:2),)
plot!(ns,noalloc,label=".=")
plot!(ns, noalloc, label="mybroadcastavx!")
plot!(ns,allocgpu,label="= gpu")
plot!(ns,noallocgpu,label=".= gpu")
savefig("microopts_blas1.png")
```

![](https://user-images.githubusercontent.com/1814174/162625049-b26fd0fd-271a-4c73-a44d-f40b36b18136.png)

This already highly motivates a project focused on the performance for this case, but assumptions (3) and (4) point us to additionally look at the implementation of the backpropagation. The [trade-off between different machine learning libraries' approaches to automatic differentiation has already been discussed at length](https://www.stochasticlifestyle.com/engineering-trade-offs-in-automatic-differentiation-from-tensorflow-and-pytorch-to-jax-and-julia/), but what the general discussions can miss is the extra opportunities afforded when really specializing on a domain. Take for example the use-case inside of neural ordinary differential equations (neural ODEs) and ODE adjoints. As mentioned above, in this use case the backwards pass is applied immediately after the forward pass. Thus while [a handwritten adjoint to a neural network layer](https://github.com/SciML/DiffEqFlux.jl/blob/v1.8.1/src/fast_layers.jl#L38-L56) can look like:

```julia
ZygoteRules.@adjoint function (f::FastDense)(x,p)
  W = ...
  b = ...
  r = W*x .+ b
  y = f.σ.(r)
  function FastDense_adjoint(v)
    σbar = ForwardDiff.derivative.(f.σ,r)
    zbar = v .* σbar
    Wbar = zbar * x'
    bbar = zbar
    xbar = W' * zbar
    nothing,xbar,vcat(vec(Wbar),bbar)
  end
  y,FastDense_adjoint
end
```

for `sigma.(W*x .+ b)` to calculate `J'v`, you can greatly optimize this if you know that the backwards pass will immediately preceed the forward pass. Specifically, there's no need to generate closures to store values since there no indeterminate future where the gradient might be needed, instead you can immediately proceed to calculate it. And, if you're only applying it to a vector of known size `v`, then this operation can be done without allocating by mutating a cache vector. Lastly, if we know we're only going to use the derivative w.r.t. `x` (`xbar`), then we can eliminate many calculations. Look at the simplified version:

```julia
r = W*x .+ b
y = σ.(r)
σbar = derivative.(σ,r)
zbar = v .* σbar
Wbar = zbar * x'
bbar = zbar
xbar = W' * zbar   
```

and now cached:

```julia
mul!(cache,W,x)
cache .= σ.(cache .+ b)
cache .= derivative.(σ,cache)
cache .= v .* cache
mul!(xbar,W',cache)
```

or in other words, we can write this as a mutating operation with a single cache vector: `vjp!(xbar,W,b,σ,v,cache)`. All of the overheads of any automatic differentiation or mutations? Gone.

Of course, building this up for anything other than the simplest case takes a much larger effort. In comes SimpleChains.jl.

## SimpleChains.jl: An Optimized Machine Learning Library for SciML Use Cases

[SimpleChains.jl](https://github.com/PumasAI/SimpleChains.jl) is the solution to this problem. SimpleChains.jl is a small machine learning framework optimized for quickly fitting small models on the CPU. Early development favored a design that would:

1. Allow us to achieve good performance, ideally approaching the CPU's potential peak FLOPs.
2. Focus on small size meant we could largely forgo large kernel optimizations (such as cache tiling) in the early stages of development.
3. Have an API where vectors of parameters (and their gradients) are first class, rather than having parameters live with the layers, to make it easier to work with various optimizers or solvers that expect contiguous vectors (such as BFGS).
4. Be written in "pure Julia" for ease of development and optimization; while making heavy use of [LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl/), SimpleChains.jl does not rely on any BLAS or NN libraries. It is a long term aim to extend this loop-compiler approach to optimization to also producing pullbacks automatically, without requiring them to be handwritten. However, the compiler-focused approach is already levered for ease of implementation: while we still have to hand-write gradients, we do not need to hand-optimize them.

## SimpleChains.jl in Action: 10x-ing PyTorch in Small Examples

Let's test MNIST with LeNet5. Note that this example will be a very conservative estimate of speed because, as a more traditional machine learning use case, batching can be used to make use of matrix-matrix multiplications instead of the even smaller matrix-vector kernels. That said, even in this case we'll be able to see a substantial performance benefit because of the semi-small network sizes.

The following is the Julia code using SimpleChains.jl for the training:

```julia
using SimpleChains, MLDatasets

lenet = SimpleChain(
  (static(28), static(28), static(1)),
  SimpleChains.Conv(SimpleChains.relu, (5, 5), 6),
  SimpleChains.MaxPool(2, 2),
  SimpleChains.Conv(SimpleChains.relu, (5, 5), 16),
  SimpleChains.MaxPool(2, 2),
  Flatten(3),
  TurboDense(SimpleChains.relu, 120),
  TurboDense(SimpleChains.relu, 84),
  TurboDense(identity, 10),
)

# 3d and 0-indexed
xtrain3, ytrain0 = MLDatasets.MNIST.traindata(Float32);
xtest3, ytest0 = MLDatasets.MNIST.testdata(Float32);

xtrain4 = reshape(xtrain3, 28, 28, 1, :);
xtest4 = reshape(xtest3, 28, 28, 1, :);

ytrain1 = UInt32.(ytrain0 .+ 1);
ytest1 = UInt32.(ytest0 .+ 1);

lenetloss = SimpleChains.add_loss(lenet, LogitCrossEntropyLoss(ytrain1));

# initialize parameters
@time p = SimpleChains.init_params(lenet);

# initialize a gradient buffer matrix; number of columns places an upper bound
# on the number of threads used.
G = similar(p, length(p), min(Threads.nthreads(), (Sys.CPU_THREADS ÷ ((Sys.ARCH === :x86_64) + 1))));

# train
@time SimpleChains.train_batched!(G, p, lenetloss, xtrain4, SimpleChains.ADAM(3e-4), 10);

# assess training and test loss
SimpleChains.error_mean_and_loss(lenetloss, xtrain4, p)
SimpleChains.error_mean_and_loss(lenetloss, xtest4, ytest1, p)


# reinitialize to randomize parameters
# SimpleChains.init_params!(lenet, p);

# train without additional memor allocations
@time SimpleChains.train_batched!(G, p, lenetloss, xtrain4, SimpleChains.ADAM(3e-4), 10);

# assess training and test loss
SimpleChains.error_mean_and_loss(lenetloss, xtrain4, p)
SimpleChains.error_mean_and_loss(lenetloss, xtest4, ytest1, p)
```

#### PyTorch

Before we show the results, let's look at the competition. Here's two runs of 10 epochs using PyTorch following [this script](https://github.com/chriselrod/LeNetTorch) on a V100 GPU using a batch size of 2048 produces:

```
Took: 17.33
Accuracy: 0.9492
Took: 17.22
Accuracy: 0.9751
```
PyTorch using an AMD EPYC 7513 32-Core Processor:
```
Took: 14.86
Accuracy: 0.9626
Took: 15.09
Accuracy: 0.9783
```
PyTorch using an Intel i9 10980XE 18-Core Processor:
```
Took: 11.24
Accuracy: 0.9759
Took: 10.78
Accuracy: 0.9841
```

#### Flux.jl

The standard machine learning library in Julia, [Flux.jl](https://github.com/FluxML/Flux.jl) was benchmarked using [this script]() with an A100 GPU. How fast was that?

```julia
julia> @time train!(model, train_loader)
 74.678251 seconds (195.36 M allocations: 12.035 GiB, 4.28% gc time, 77.57% compilation time)

julia> eval_loss_accuracy(train_loader, model, device),
       eval_loss_accuracy(test_loader, model, device)
((loss = 0.1579f0, acc = 95.3583), (loss = 0.1495f0, acc = 95.54))

julia> @time train!(model, train_loader)
  1.676934 seconds (1.04 M allocations: 1.840 GiB, 5.64% gc time, 0.63% compilation time)

julia> eval_loss_accuracy(train_loader, model, device),
       eval_loss_accuracy(test_loader, model, device)
((loss = 0.0819f0, acc = 97.4967), (loss = 0.076f0, acc = 97.6))
```
Flux on a V100 GPU:

```julia
julia> @time train!(model, train_loader)
 75.266441 seconds (195.52 M allocations: 12.046 GiB, 4.02% gc time, 74.83% compilation time)

julia> eval_loss_accuracy(train_loader, model, device),
       eval_loss_accuracy(test_loader, model, device)
((loss = 0.1441f0, acc = 95.7883), (loss = 0.1325f0, acc = 96.04))

julia> @time train!(model, train_loader)
  2.309766 seconds (1.06 M allocations: 1.841 GiB, 2.87% gc time)

julia> eval_loss_accuracy(train_loader, model, device),
       eval_loss_accuracy(test_loader, model, device)
((loss = 0.0798f0, acc = 97.5867), (loss = 0.0745f0, acc = 97.53))
```

Flux on an AMD EPYC 7513 32-Core Processor:

```julia
julia> @time train!(model, train_loader)
106.340589 seconds (67.05 M allocations: 67.053 GiB, 4.18% gc time, 29.39% compilation time)

julia> eval_loss_accuracy(train_loader, model, device),
       eval_loss_accuracy(test_loader, model, device)
((loss = 0.211f0, acc = 93.79), (loss = 0.1954f0, acc = 94.28))

julia> @time train!(model, train_loader)
 73.762709 seconds (279.68 k allocations: 62.861 GiB, 4.15% gc time)

julia> eval_loss_accuracy(train_loader, model, device),
       eval_loss_accuracy(test_loader, model, device)
((loss = 0.1067f0, acc = 96.8083), (loss = 0.0978f0, acc = 97.0))
```

Flux on an Intel i9 10980XE 18-Core Processor:

```julia
julia> @time train!(model, train_loader)
 70.517619 seconds (98.27 M allocations: 67.833 GiB, 3.94% gc time, 39.30% compilation time)

julia> eval_loss_accuracy(train_loader, model, device),
       eval_loss_accuracy(test_loader, model, device)
((loss = 0.1306f0, acc = 96.14), (loss = 0.1144f0, acc = 96.57))

julia> @time train!(model, train_loader)
 44.241192 seconds (369.06 k allocations: 62.864 GiB, 2.55% gc time)

julia> eval_loss_accuracy(train_loader, model, device),
       eval_loss_accuracy(test_loader, model, device)
((loss = 0.072f0, acc = 97.7883), (loss = 0.0642f0, acc = 97.99))
```

#### How long did SimpleChains.jl take?

SimpleChains on an AMD EPYC 7513 32-Core Processor:

```julia
julia> @time SimpleChains.train_batched!(G, p, lenetloss, xtrain4, SimpleChains.ADAM(3e-4), 10);
 34.410432 seconds (55.84 M allocations: 5.920 GiB, 3.79% gc time, 85.95% compilation time)

julia> SimpleChains.error_mean_and_loss(lenetloss, xtrain4, p)
(0.972, 0.093898475f0)

julia> SimpleChains.error_mean_and_loss(lenetloss, xtest4, ytest1, p)
(0.9744, 0.08624289f0)

julia> @time SimpleChains.train_batched!(G, p, lenetloss, xtrain4, SimpleChains.ADAM(3e-4), 10);
  3.083624 seconds

julia> SimpleChains.error_mean_and_loss(lenetloss, xtrain4, p)
(0.9835666666666667, 0.056287352f0)

julia> SimpleChains.error_mean_and_loss(lenetloss, xtest4, ytest1, p)
(0.9831, 0.053463124f0)
```

SimpleChains on an Intel i9 10980XE 18-Core Processor:

```julia
julia> @time SimpleChains.train_batched!(G, p, lenetloss, xtrain4, SimpleChains.ADAM(3e-4), 10);
 34.915917 seconds (83.99 M allocations: 5.431 GiB, 3.91% gc time, 95.22% compilation time)

julia> SimpleChains.error_mean_and_loss(lenetloss, xtrain4, p)
(0.972, 0.09354472f0)

julia> SimpleChains.error_mean_and_loss(lenetloss, xtest4, ytest1, p)
(0.975, 0.084895514f0)

julia> @time SimpleChains.train_batched!(G, p, lenetloss, xtrain4, SimpleChains.ADAM(3e-4), 10);
  1.324148 seconds

julia> SimpleChains.error_mean_and_loss(lenetloss, xtrain4, p)
(0.9836833333333334, 0.054299146f0)

julia> SimpleChains.error_mean_and_loss(lenetloss, xtest4, ytest1, p)
(0.9829, 0.053510584f0)
```

SimpleChains on an Intel i7 1165G7 4-Core Processor (thin and light laptop CPU):

```julia
julia> @time SimpleChains.train_batched!(G, p, lenetloss, xtrain4, SimpleChains.ADAM(3e-4), 10);
 42.664702 seconds (103.71 M allocations: 5.236 GiB, 2.85% gc time, 77.60% compilation time)

julia> SimpleChains.error_mean_and_loss(lenetloss, xtrain4, p)
(0.9863166666666666, 0.044742946f0)

julia> SimpleChains.error_mean_and_loss(lenetloss, xtest4, ytest1, p)
(0.9841, 0.048268355f0)

julia> @time SimpleChains.train_batched!(G, p, lenetloss, xtrain4, SimpleChains.ADAM(3e-4), 10);
  6.320631 seconds

julia> SimpleChains.error_mean_and_loss(lenetloss, xtrain4, p)
(0.99485, 0.017716348f0)

julia> SimpleChains.error_mean_and_loss(lenetloss, xtest4, ytest1, p)
(0.9888, 0.035394628f0)
```

Note that smaller batch sizes improve accuracy per epoch, and batch sizes were set to be proportional to the number of threads.

## Benchmark Summary

Latency before the first epoch begins training is problematic, but SimpleChains.jl is fast once compiled.
Post-compilation, the 10980XE was around 70% faster than Flux with the A100 GPU.
The 1165G7, a laptop CPU featuring AVX512, was competive, handily trouncing any of the competing machine learning libraries when 
they were run on CPU, and even beat PyTorch on a V100. Again, we stress that this test case followed the more typical machine learning
uses and thus was able to use batching to even make GPUs viable: for many use cases of SimpleChains.jl this is not the case and thus
the difference is even larger.

However, it seems likely that the PyTorch script was not well optimized for GPUs, but we are less familiar with PyTorch and would welcome
PRs improving it. That said, the script is taken from a real-world user out in the wild, and thus this should demonstrate what one would expect
see from a user that is not digging into internals and hyper-optimizing. Nothing out of the ordinary was done with the Julia scripts: these were
all "by the book" implementations. Though of course, the SimpleChains.jl's simplest code is specifically optimized for this "by the book" use case.

## Conclusion

There are many things that can make a library achieve high-performance, and nothing is as essential as knowing how it will be used. While the big machine learning frameworks have done extremely well focusing on the top-notch performance for 99.9% of their users, one can still completely outclass them when focusing on some of the 0.1% of applications which fall outside of what they have been targeting. This is the advantage of composability and flexibility: a language that allows you to easily build a machine learning framework is also a language which allows you to build alternative frameworks which are optimized for alternative people. SimpleChains.jl will not be useful to everybody, but it will be extremely useful to those who need it.