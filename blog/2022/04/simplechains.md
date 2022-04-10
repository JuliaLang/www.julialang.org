@def rss_pubdate = Date(2022, 2, 14)
@def rss = """10 years ago today, we published 'Why we Created Julia' ..."""
@def published = "14 February 2022"
@def title = "Why We Use Julia, 10 Years Later"
@def authors = """The Julia Community"""
@def mintoclevel=2
@def maxtoclevel=3


#### Announcing: SimpleChains.jl

We're happy to announce the open sourcing of SimpleChains.jl, a library developed by Julia Computing and PumasAI in collaboration with Roche and the University of Maryland, Baltimore.

SimpleChains.jl origin is as a part of the DeepPumas product, where it was optimized for quickly fitting small models on the CPU. Early development favored a design that would:
1. Allow us to achieve good performance, ideally approaching the CPU's potential peak FLOPs.
2. Focus on small size meant we could largely forgo cache tiling in early development.
3. Have an API where vectors of parameters (and their gradients) are first class, rather than having parameters live with the layers, to make it easier to work with various optimizers or solvers that expect contiguous vectors.
4. Be written in "pure Julia" for ease of development and optimization; while making heavy use of [LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl/), SimpleChains.jl does not rely on any BLAS or NN libraries. It is a long term aim to extend this loop-compiler approach to optimization to also producing pullbacks automatically, without requiring them to be handwritten. However, the compiler-focused approach is already levered for ease of implementation: while we still have to hand-write gradients, we do not need to hand-optimize them.


#### Example and Benchmark

Using MNIST and LeNet5:
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

Two runs of 10 epochs using PyTorch following [this script](https://github.com/chriselrod/LeNetTorch) on a V100 GPU using a batch size of 2048 produces:
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

<!-- FIXME: update link once open  -->
Flux on an A100 GPU, using [this script]():
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

Latency before the first epoch begins training is problematic, but SimpleChains.jl is fast once compiled.
Post-compilation, the 10980XE was around 70% faster than Flux with the A100 GPU.
The 1165G7, a laptop CPU featuring AVX512, was competive, handily trouncing any of the competing machine learning libraries when 
they were run on CPU, and even beat PyTorch on a V100.

However, it seems likely that the PyTorch script was not well optimized for GPUs, but I am unfamiliar with PyTorch and would welcome
PRs improving it. The dataset is small enough to live in GPU memory, but it seems to be transferred from the CPU on each epoch.



