@def rss_pubdate = Date(2021, 8, 18)
@def rss = """ Implementing Deep Equilibrium Models in Julia... """
@def published = "18 August 2021"
@def title = "Composability in Julia: Implement Deep Equilibrium Models via Neural ODEs"
@def authors = """Chris Rackauckas, Mike Innes, Yingbo Ma, Jesse Bettencourt, Lyndon White, Vaibhav Dixit"""  
<!-- authors waiting to be updated -->

<!-- Translations: [Traditional Chinese](/blog/2019/04/fluxdiffeq-zh_tw) -->

In this blog post we will show you how to easily, efficiently, and
robustly use steady state solvers with neural networks in Julia. This
blog assumes certain familiarity with Neural ODE research.

<!-- ![Flux ODE Training Animation](https://user-images.githubusercontent.com/1814174/51399500-1f4dd080-1b14-11e9-8c9d-144f93b6eac2.gif) -->

The combination of differential equations and neural networks has aroused wide-spread interest
since 2017. For more on the history of this field, please see the seminal work
[Neural Ordinary Differential Equations](https://arxiv.org/abs/1806.07366) and our previous
blog post [DiffEqFlux.jl – A Julia Library for Neural Differential Equations](https://julialang.org/blog/2019/01/fluxdiffeq/).
This is a great example of interweaving machine learning with another field of research.
In doing so, not only do we get to reap the benefits of centuries of research in the
differential equations community, we also shift our perspective from the discrete to the
continuous for machine learning, and from the explicit to the black-box for differential
equations.

What follows in recent years is a surge of algorithms expanding the frontiers of applying
Neural ODEs to physical problems, as well as studies exploring the theoretical implications
of this new-born area of research. For the former, one can refer to a flurry of works in the
scientific machine learning (SciML) community, many of which based on the flexible structure
of the Julia programming language. Among the latter direction, Deep Equilibrium Models (DEQ)
stand out as an extension of Neural ODE theory, in particular making the notion of infinite-depth
neural networks explicit in the algorithm. This blog post will be aimed at exploring the
properties of DEQ models.

(Note: If you are interested in this work and are an undergraduate or graduate
student, we have [Google Summer of Code projects available in this area](/soc/ideas-page). This
[pays quite well over the summer](https://developers.google.com/open-source/gsoc/help/student-stipends).
Please join the [Julia Slack](http://julialang.org/slack/) and the #jsoc channel to discuss in more detail.)

\toc


## What is a Neural Ordinary Differential Equation?

To put it simply, Neural ODE uses a neural network to parameterize what ODE we are
solving. This is exactly what I was referring to when I noted that the discovery of Neural ODE
allowed the differential equations community to shift from using explicit definitions to
black-box solvers. Instead of having to specify the exact position-momentum relations of a
pendulum using Hamiltonian equations, one can train a neural network to implicitly represent
the differential equations that describe the system. In the case where we know
exactly the differential equations from physics, we should rarely expect the neural network
to outperform human knowledge. Nevertheless, this method crowns itself as an implicit
modeling technique which can work when we only observe input and output data of the system
without possessing knowledge of what happens inside. Then, one of the biggest pros is to
just fit the terms which you don't know exactly. There are a bunch of differential equations
in fluid dynamics for example, which would almost fall under "we know exactly the
differential equations" after many approximations, and in realistic systems some additional terms might pop up as well.


It is well known in literature that Neural ODE can be seen as a continuous version
of ResNets. This is what I was referring to when I noted that Neural ODE caused
a shift in perspective for the machine learning community from discrete to continuous. We
have always known that powerful techniques such as gradient-based optimization combined with
discrete neural network models gives us the great inference engine that is "standard deep learning".
With the addition of Neural ODE, we can take a look at what happens when we take infinitely
small steps in adjustment (think learning rate $\lim _{\lambda \rightarrow 0}$), effectively resulting in a differential equation.
For our purpose, we will take inspiration from this property of Neural ODE, and
approximate an "infinitely deep" model as each network layer tends to zero in size.


## Deep Equilibrium Models and Infinitely Deep Networks

There is a line of work following [Deep Equilibrium Models](https://arxiv.org/abs/1909.01377)
that explores direct representations of infinitely-deep neural networks. It borrows
much of the ideas from the Neural ODE line of research, and allows neural network structures
to be viewed as repeated applications of layered computations. This is often very accurate,
for example when we apply convolution filters on images---the network can essentially
be viewed as a feature extractor consisting of repetitive blocks of convolutional layers, and one
linear output layer at the very end. Naturally, DEQ models constitute data-efficient solutions
to popular problems in computer vision such as object segmentation in works like [MDEQ](https://arxiv.org/abs/2006.08656).

However, there are caveats to consider when taking the repetition to the limit. 
When there is an infinite number of these repeated blocks, the value being
pushed forward might continually increase until it explodes to infinity. But under
certain conditions, this repetition $x_{n+1} = x_n + f(x_n)$ does not diverge but
rather converges to a stable equilibrium. The central idea behind Deep Equilibrium
Models (DEQs) is to capture the space of convergent dynamical systems using a
neural network representation of the residual `f`.

Let us begin by looking at equations representing repeated compounding of the same layer
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

(Equations credit: [Deep Implicit Layers Tutorial](http://implicit-layers-tutorial.org/introduction/))

The idea of DEQ is, in a sense, insanely simple! We assume there are infinitely many
compositions of this kind of layer and directly solve for the fixed point described by the dynamical system.
I should emphasize again that DEQ models, similar to Neural ODEs, are usually parametrized using
neural networks (`W`). The power of implicitly defining a model lies in the fact that
we can choose whatever solution methods we wish.

Clearly, naively iterating for the fixed point would take an enormous amount of time. However,
classical dynamical systems theory relates this infinite process to a simple mathematical problem.
If we perceive the iterating layer of the network as a dynamical system, DEQ is solving nothing but the
well-known "Steady State Problem", defined as the final converging state of the system as time
goes to infinity. It is apparent that steady state problems are "special cases" of differential equations
---for an update equation $x_{n+1} = x_n + f(x_n)$, "the equation is not changing anymore"
is equivalent to saying $x_{n+1} = x_n$ which reduces the problem to finding the $x$ such that $f(x) = 0$.
This is also known as a rootfinding problem, where the forward and adjoint methods have been well-studied
in the scientific computing literature since at least the 90's. For example, Steven Johnson's 
[Notes on Adjoint Methods for 18.335 from 2006](https://math.mit.edu/~stevenj/18.336/adjoint.pdf) shows a
well-written derivation of an adjoint equation ("backpropagation" equation) for a rootfinding solver. 


## Mixing DEQs and Neural ODEs

From the viewpoint of Julia and the DiffEqFlux.jl library, it is also natural to look at DEQ from
a differential equations perspective. Instead of viewing the
dynamical system as a discrete process $x_{n+1} = x_n + f(x_n)$, we can equivalently view the system as evolving
continuously, i.e. $x' = f(x)$. In this sense, convergence is when the change is zero, or $x'=0$, which again
happens when $f(x)=0$ and is a rootfinding problem. But this view is insightful: a DEQ is a neural ODE where
time goes to infinity. The connection is well justified, once one notices that steady state problems are
"special cases" of differential equations. As we will see in the next section, this observation makes implementing
DEQ models in Julia insanely simple. The model can be summed up as a steady state layer on top of the neural network.

## Let us implement a simple DEQ Model via ODE Solvers
There are many ways that one can solve a rootfinding problem with different characteristics.
One can directly use Newton's method, but this can require a good guess and may not distinguish
between stable and unstable equilibrium. Julia packages like 
[NLsolve.jl](https://github.com/JuliaNLSolvers/NLsolve.jl) provide many feasible solutions, and
Bifurcation tools like [BifurcationKit.jl](https://rveltz.github.io/BifurcationKit.jl/dev/) give a whole host of other methods. But for our demonstration,
we will focus on showcasing the evolving ODE approach. This is similar to the fixed point method of running
$x_{n+1} = x_n + f(x_n)$, but we can instead allow the ODE solver to adaptively change its steps along the
trajectory to better facilitate convergence. We can define "convergence" as a tolerance where for $x' = f(x)$,
we want $x'$ to be sufficiently small (in absolute and relative tolerance). It turns out that a method for
doing this, along with its backpropogation, is already defined in Julia as the 
[steady state problem](https://diffeq.sciml.ai/stable/types/steady_state_types/) which will automatically
detect when the ODE has converged and halt the integration. So let's demonstrate a DEQ via SteadyStateProblem.

The following code block creates a DEQ model. The acute will notice that this code looks
awfully similar to typical Neural ODEs implemented in Julia. By now this should not come
as a surprise, as DEQ models fall under the umbrella of the line of work involving Neural ODEs.
Therefore, the DEQ implementation simply adds an extra steady state layer on top
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

Afterwards, we can test our DEQ model on a simple regression problem $y=2x$. When one runs this,
the model will print out $-10$, which is the expected answer for this regression problem.
Also note that it is clearly not necessary to use GPU in training, and one can easily
move to CPU execution by removing all the "gpu" calls. As a sanity check, our small DEQ
model completes this regression problem perfectly.

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

<!-- DEQ models cannot vary in input and output size, and that is an active field of research -->

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

In this blog post, we have witnessed the flexibility of Julia. Progress in
differential equation and deep learning packages seamlessly integrate, making it
virtually effortless to implement new algorithms like DEQ models.
DEQ models open up ample opportunities for theoretical research when we consider
more advanced rootfinding methods. We also look forward to future work that push
the application of new algorithms to real-world physics problems. We are very
excited to witness the potential of the Julia programming language, and what it
will bring at the crossroads of differential equation and machine learning research.

Note: a citable version of this post is published on [Arxiv](https://arxiv.org/abs/1902.02376).
<!-- Still waiting to be changed -->
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