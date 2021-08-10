@def rss_pubdate = Date(2021, 1, 18)
@def rss = """ Implementing Deep Equilibrium Models in Julia... """
@def published = "18 January 2021"
@def title = "Implementing Deep Equilibrium Models in Julia"
@def authors = """Chris Rackauckas, Mike Innes, Yingbo Ma, Jesse Bettencourt, Lyndon White, Vaibhav Dixit"""  

<!-- Translations: [Traditional Chinese](/blog/2019/04/fluxdiffeq-zh_tw) -->

In this blog post we will show you how to easily, efficiently, and
robustly use steady state solvers with neural networks in Julia.

<!-- ![Flux ODE Training Animation](https://user-images.githubusercontent.com/1814174/51399500-1f4dd080-1b14-11e9-8c9d-144f93b6eac2.gif) -->

The combination of differential equations and neural networks has aroused wide-spread interest
since 2017. For more on the history of this field, please see the seminal work
[Neural Ordinary Differential Equations](https://arxiv.org/abs/1806.07366) and our previous
blog post [DiffEqFlux.jl – A Julia Library for Neural Differential Equations](https://julialang.org/blog/2019/01/fluxdiffeq/).
In my opinion, this is one of the best, if not
the most successful, method that interweaves machine learning with another field of research.
In doing so, not only do we get to reap the benefits of centuries of research in the
differential equations community, we also shift our perspective from the discrete to the
continuous for machine learning, and from the explicit to the black-box for differential
equations.

What follows in recent years is a surge of algorithms expanding the frontiers of applying
NeuralODEs to physical problems, as well as studies exploring the theoretical implications
of this new-born area of research. For the former, one can refer to a flurry of works in the
scientific machine learning (SciML) community, many of which based on the flexible structure
of the Julia programming language. Among the latter direction, Deep Equilibrium Models (DEQ)
stand out as an extension of NeuralODE theory, in particular making the notion of infinite-depth
neural networks explicit in the algorithm.

(Note: If you are interested in this work and are an undergraduate or graduate
student, we have [Google Summer of Code projects available in this area](/soc/ideas-page). This
[pays quite well over the summer](https://developers.google.com/open-source/gsoc/help/student-stipends).
Please join the [Julia Slack](http://julialang.org/slack/) and the #jsoc channel to discuss in more detail.)

\toc


## What is a Neural Ordinary Differential Equation?

To put it simply, NeuralODE uses a neural network to parameterize what ODE we are
solving. This is exactly what I was referring to when I noted that the discovery of NeuralODE
allowed the differential equations community to shift from using explicit definitions to
black-box solvers. Instead of having to specify the exact position-momentum relations of a
pendulum using Hamiltonian equations, one can train a neural network to implicitly represent
implicitly the differential equations that describe the system. In the case where we know
exactly the differential equations from physics, we should rarely expect the neural network
to outperform human knowledge. Nevertheless, this method crowns itself as an implicit
modelling technique which can work when we only observe input and output data of the system
without possessing knowledge of what happens inside.


It is well known in literature that NeuralODE can be seen as a continuous version
of ResNets. This is exactly what I was referring to when I noted that NeuralODE caused
a shift in perspective for the machine learning community from discrete to continuous. We
have always known that powerful techniques such as gradient-based optimization combined with
discrete models gives us the great inference engine that is "standard deep learning".
With the addition of NeuralODE, we can take a look at what happens when we take infinitely
small steps in adjustment, effectively resulting in a differential equation. It is precisely
this property of NeuralODE that allows it to approximate an "infinitely deep" model
as each network layer tends to zero in size.


As it turns out, there is a line of work following [Deep Equilibrium Models](https://arxiv.org/abs/1909.01377)
that explores the notion of infinitely-deep neural networks in an explicit manner. It borrows
much of the ideas from the NeuralODE line of research, and allows neural network structures
to be viewed as repeated applications of layered computations. This is often very accurate,
for example when we apply convolution filters on images---the network can essentially
be viewed as a convolutional feature extractor consisting of repetitive blocks, and one
linear output layer at the very end. When there is an infinite number of these repeated
blocks, the network might explode off to infinity. If it doesn't, however, it reaches an
equilibrium points and converges, hence the name.

## DEQ Models and Infinitely Deep Networks

Let us begin by looking at an instantiation of the equations for DEQ models.
$$
\begin{array}{l}
z:=0\\
\text { Repeat until convergence: }\\
z:=\tanh (W z+x)
\end{array}
$$

Which eventually brings us to
$$
z^{\star}=\tanh \left(W z^{\star}+x\right)
$$

The idea of DEQ is, in a sense, insanely simple! We assume there are infinitely many
compositions of identical layers (equivalently an infinitely deep network), and
directly solve for the fixed point described by this equation. Clearly, naively iterating
for the fixed point would take an enormous amount of time. Thanks to the Implicit Function
Theorem, DEQ shows that it is possible to train an infinitely-deep neural network using the
gradient optimization toolbox. For more reference, please see
[Deep Implicit Layers](http://implicit-layers-tutorial.org)

From the viewpoint of Julia and the DiffEqFlux.jl library, it is also natural to look at DEQ from
a differential equations perspective. Thanks to NeuralODE, the machine learning community is now able
to put on the glasses of differential equations, and see through a new perspective.
If we perceive the iterating layer of the network as an ODE, DEQ is solving nothing but the
well-known "Steady State Problem", defined as the final converging state of the ODE as time
goes to infinity. This line of work is well-studied in the scientific machine learning
literature, see for example [Notes on Adjoint Methods for 18.335](https://math.mit.edu/~stevenj/18.336/adjoint.pdf)

$$
f(u) - u = du = 0
$$

Reaching a fixed point of the iterative layer application is much like solving for the final
value in a converging sequence. To put it simply, we set the current value equal to the next,
and obtain a solution for this recursion problem. As we show above, if we use `u` to represent
the current layer and `f(u)` to represent the next layer, we can sloppily denote the fixed point
equation as `f(u)-u=0`. Crucially, this can also be converted into a steady state problem
by defining an ODE layer `f(u)-u=du` and solving
that ODE in its steady state. This gives us equality among all three components.

## Let us implement a simple DEQ Model

The following code block creates a DEQ model. The acute will notice that this code looks
awfully similar to typical NeuralODEs implemented in Julia. The connection is well
justified, once one notices that steady state problems are "special cases" of differential
equations. Therefore, the DEQ implementation simply adds an extra steady state layer on top
of the ODE function, and as long as we use the correct sensitivity corresponding to
steady state problems, we are covered.
 
```julia
using Flux
using DiffEqSensitivity
using SteadyStateDiffEq
using DiffEqFlux
using OrdinaryDiffEq
using CUDA
CUDA.allowscalar(false)

ann = Chain(Dense(1, 2), Dense(2, 1)) |> gpu
p,re = Flux.destructure(ann)
tspan = (0.0f0, 1.0f0)

function solve_ss(x)
    xg = gpu(x)
    z = re(p)(xg) |> gpu
    function dudt_(u, _p, t)
        # Solving the equation f(u) - u = du = 0
        re(_p)(u+xg) - u
    end
    ss = SteadyStateProblem(ODEProblem(dudt_, gpu(z), tspan, p))
    x = solve(ss, DynamicSS(Tsit5()), u0 = z, abstol = 1e-5, reltol = 1e-5).u
end
```

Afterwards, we can test our DEQ model on a simple regression problem. When one runs this,
the model will print out "-10", which is the expected answer for this regression problem.
Also note that it is clearly not necessary to use GPU in training, and one can easily
move to CPU execution by removing all the "gpu" calls. As a sanity check, our small DEQ
model does possess mild learning capabilities.

```julia
# Let's run a DEQ model on linear regression for y = 2x
X = [1;2;3;4;5;6;7;8;9;10]
Y = [2;4;6;8;10;12;14;16;18;20]
data = Flux.Data.DataLoader(gpu.(collect.((X, Y))), batchsize=1,shuffle=true)
opt = ADAM(0.05)

function loss(x, y)
  ŷ = solve_ss(x)
  sum(abs2,y .- ŷ)
end

epochs = 100
for i in 1:epochs
    Flux.train!(loss, Flux.params(p), data, opt)
    println(solve_ss([-5])) # Print model prediction
end
```

## We can also convert well-known architectures into DEQ Models

```julia
using Flux
using Flux.Data:DataLoader
using Flux.Optimise: Optimiser
using Flux: onehotbatch, onecold
using Flux.Losses:logitcrossentropy
using ProgressMeter:@showprogress
import MLDatasets
using CUDA
using DiffEqSensitivity
using SteadyStateDiffEq
using DiffEqFlux
using OrdinaryDiffEq
CUDA.allowscalar(false)


function Net() 



    down = Chain(
        x -> reshape(x, (784, 8)) |> f32,
        Dense(784, 200, tanh) |> f32,
        Dense(200, 20, tanh) |> f32,
    ) |> f32
    deq = Chain(
        Dense(20, 10, tanh) |> f32,
        Dense(10, 10, tanh) |> f32,
        Dense(10, 20, tanh) |> f32,
    ) |> f32
    p, re = Flux.destructure(deq)
    fc = Chain(
        Dense(20, 15, tanh) |> f32,
        Dense(15, 10, tanh) |> f32,
    ) |> f32

    tspan = (0.0f0, 1.0f0)
    function solve_ss(x)

        z = re(p)(x)
        function dudt_(u, _p, t)
        # Solving the equation f(u) - u = du = 0
            re(_p)(u + x) - u
        end
        ss = SteadyStateProblem(ODEProblem(dudt_, z, tspan, p))
        x = solve(ss, DynamicSS(Tsit5()), u0=z, abstol=Float32(1e-2), reltol=Float32(1e-2), tspan=1.0f0).u
    end
  # Build our over-all model topology
    m = Chain(
        down,               # (28,28,1,BS) -> (6,6,64,BS)
        solve_ss,           # (6,6,64,BS) -> (6,6,64,BS)
        fc,                 # (6,6,64,BS) -> (10, BS)
    )

    return m
end

function get_data(args)
    xtrain, ytrain = MLDatasets.MNIST.traindata(Float32)
    xtest, ytest = MLDatasets.MNIST.testdata(Float32)

    xtrain = reshape(xtrain, 28, 28, 1, :)
    xtest = reshape(xtest, 28, 28, 1, :)

    ytrain, ytest = onehotbatch(ytrain, 0:9), onehotbatch(ytest, 0:9)

    train_loader = DataLoader((xtrain, ytrain), batchsize=args.batchsize, shuffle=true)
    test_loader = DataLoader((xtest, ytest),  batchsize=args.batchsize)
    
    return train_loader, test_loader
end

loss(ŷ, y) = logitcrossentropy(ŷ, y)

function eval_loss_accuracy(loader, model, device)
    l = 0f0
    acc = 0
    ntot = 0
    for (x, y) in loader
        x, y = x |> device, y |> device
        ŷ = model(x)
        l += loss(ŷ, y) * size(x)[end]        
        acc += sum(onecold(ŷ |> cpu) .== onecold(y |> cpu))
        ntot += size(x)[end]
    end
    return (loss = l / ntot |> round4, acc = acc / ntot * 100 |> round4)
end

# utility functions
round4(x) = round(x, digits=4)

# arguments for the `train` function 
Base.@kwdef mutable struct Args
    η = 3e-4             # learning rate
    λ = 0                # L2 regularizer param, implemented as weight decay
    batchsize = 8      # batch size
    epochs = 10          # number of epochs
    seed = 0             # set seed > 0 for reproducibility
    use_cuda = false      # if true use cuda (if available)
    infotime = 1 	     # report every `infotime` epochs
    checktime = 5        # Save the model every `checktime` epochs. Set to 0 for no checkpoints.
    tblogger = true      # log training with tensorboard
    savepath = "runs/"    # results path
end

function train(; kws...)
    args = Args(; kws...)
    args.seed > 0 && Random.seed!(args.seed)
    use_cuda = args.use_cuda && CUDA.functional()
    
    if use_cuda
        device = gpu
        @info "Training on GPU"
    else
        device = cpu
        @info "Training on CPU"
    end

    ## DATA
    train_loader, test_loader = get_data(args)
    @info "Dataset MNIST: $(train_loader.nobs) train and $(test_loader.nobs) test examples"

    ## MODEL AND OPTIMIZER
    model = Net() |> device  
    
    ps = Flux.params(model)
    opt = ADAM(args.η)
    
    ## TRAINING
    @info "Start Training"
    for epoch in 1:args.epochs
        @showprogress for (x, y) in train_loader
            x, y = x |> device, y |> device
            gs = Flux.gradient(ps) do
                ŷ = model(x)
                loss(ŷ, y)
            end

            Flux.Optimise.update!(opt, ps, gs)
        end
    end
end

train()
```



## Conclusion

Machine learning and differential equations are destined to come together due to
their complementary ways of describing a nonlinear world. In the Julia ecosystem
we have merged the differential equation and deep learning packages in such a
way that new independent developments in the two domains can directly be used together.
We are only beginning to understand the possibilities that have opened up with
this software. We hope that future blog posts will detail some of the cool
applications which mix the two disciplines, such as embedding our coming
pharmacometric simulation engine [PuMaS.jl](https://doi.org/10.1007/s10928-018-9606-9)
into the deep learning framework. With access to the full range of solvers for ODEs,
SDEs, DAEs, DDEs, PDEs, discrete stochastic equations, and more, we are
interested to see what kinds of next generation neural networks you will build with Julia.

Note: a citable version of this post is published on [Arxiv](https://arxiv.org/abs/1902.02376).

```
@article{DBLP:journals/corr/abs-1902-02376,
  author    = {Christopher Rackauckas and
               Mike Innes and
               Yingbo Ma and
               Jesse Bettencourt and
               Lyndon White and
               Vaibhav Dixit},
  title     = {DiffEqFlux.jl - {A} Julia Library for Neural Differential Equations},
  journal   = {CoRR},
  volume    = {abs/1902.02376},
  year      = {2019},
  url       = {https://arxiv.org/abs/1902.02376},
  archivePrefix = {arXiv},
  eprint    = {1902.02376},
  timestamp = {Tue, 21 May 2019 18:03:36 +0200},
  biburl    = {https://dblp.org/rec/bib/journals/corr/abs-1902-02376},
  bibsource = {dblp computer science bibliography, https://dblp.org}
}
```


<!---
https://github.com/SciML/DiffEqFlux.jl/issues/567
using Flux
using DiffEqSensitivity
using SteadyStateDiffEq
using DiffEqFlux
using OrdinaryDiffEq
using CUDA
CUDA.allowscalar(false)

# FastChain with initial_params should also work
# But it's more stable to use Chain and destructure
# ann = FastChain(
#   FastDense(1, 2, relu),
#   FastDense(2, 1, tanh))
# p1 = initial_params(ann)

ann = Chain(Dense(1, 2), Dense(2, 1)) |> gpu
p,re = Flux.destructure(ann)
tspan = (0.0f0, 1.0f0)

function solve_ss(x)
    xg = gpu(x)
    z = re(p)(xg) |> gpu
    #z = re(p)(x)
    function dudt_(u, _p, t)
        # Solving the equation f(u) - u = du = 0
        # Key question: Is there any difference between
        # re(_p)(x) and re(_p)(u+x)?
        re(_p)(u+xg) - u
        #re(_p)(u+x) - u
    end
    ss = SteadyStateProblem(ODEProblem(dudt_, gpu(z), tspan, p))
    #ss = SteadyStateProblem(ODEProblem(dudt_, z, tspan, p))
    x = solve(ss, DynamicSS(Tsit5()), u0 = z, abstol = 1e-5, reltol = 1e-5).u

    #=
    ss = NonlinearProblem(dudt_, gpu(z), p)
    x = solve(ss, NewtonRaphson(), u0 = z).u
    =#
end

# Let's run a DEQ model on linear regression for y = 2x
X = [1;2;3;4;5;6;7;8;9;10]
Y = [2;4;6;8;10;12;14;16;18;20]
data = Flux.Data.DataLoader(gpu.(collect.((X, Y))), batchsize=1,shuffle=true)
#data = Flux.Data.DataLoader(collect.((X, Y)), batchsize=1,shuffle=true)
opt = ADAM(0.05)

function loss(x, y)
  ŷ = solve_ss(x)
  sum(abs2,y .- ŷ)
end

epochs = 100
for i in 1:epochs
    Flux.train!(loss, Flux.params(p), data, opt)
    println(solve_ss([-5])) # Print model prediction
end
--->
