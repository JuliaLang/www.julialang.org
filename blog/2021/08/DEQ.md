@def rss_pubdate = Date(2021, 8, 18)
@def rss = """ Composability in Julia: Implement Deep Equilibrium Models via Neural ODEs"""
@def published = "18 August 2021"
@def title = "Composability in Julia: Implement Deep Equilibrium Models via Neural ODEs"
@def authors = """Qiyao Wei, Frank Schäfer, Chris Rackauckas"""  

The [SciML Common Interface](https://scimlbase.sciml.ai/dev/) defines a complete
set of equation solving techniques, from differential equations and optimization
to nonlinear solves and integration (quadrature), in a way that is made to
naturally mix with machine learning. In this sense, there is no difference
between the optimized libraries being used for physical modeling and
the techniques used in machine learning: in the composable ecosystem of Julia,
these are one and the same. The same differential equation solvers that are
being carefully inspected for speed and accuracy by the FDA and Moderna [for clinical trial analysis](https://pumas.ai/)
are what's [mixed with neural networks for neural ODEs](https://julialang.org/blog/2019/01/fluxdiffeq/). 
The same [computer algebra system](https://symbolics.juliasymbolics.org/dev/)
that is [used to accelerate NASA launch simulations by 15,000x](https://www.youtube.com/watch?v=tQpqsmwlfY0)
is the same one that is used in [automatically discovering physical equations](https://datadriven.sciml.ai/dev/).
With a composable package ecosystem, the only thing holding you back is the ability to
figure out new ways to compose the parts.

In this blog post we will show how to easily, efficiently, and
robustly use steady state nonlinear solvers with neural networks in Julia. We will
showcase the relationship between steady states and ODEs, thus making a connection
between the methods for Deep Equilibrium Models (DEQs) and Neural ODEs.
We will then show how [DiffEqFlux.jl](https://diffeqflux.sciml.ai/dev/)
can be used as a package for DEQs, showing how the composability of the
Julia ecosystem naturally lends itself to extensions and generalizations
of methods in machine learning literature. For background on DiffEqFlux and Neural ODEs,
please see the previous blog post [DiffEqFlux.jl – A Julia Library for Neural Differential Equations](https://julialang.org/blog/2019/01/fluxdiffeq/).

(Note: If you are interested in this work and are an undergraduate or graduate
student, we have [Google Summer of Code projects available in this area](/soc/ideas-page). This
[pays quite well over the summer](https://developers.google.com/open-source/gsoc/help/student-stipends).
Please join the [Julia Slack](http://julialang.org/slack/) and the #jsoc channel to discuss in more detail.)

\toc

## Deep Equilibrium Models (DEQs) and Infinitely Deep Networks

Neural network structures can be viewed as repeated applications of layered computations. For 
example, when we apply convolution filters on images the network consists of repetitive blocks 
of convolutional layers, and one linear output layer 
at the very end. It's essentially $f(f(f(...f(x))...))$ where $f$ is the neural network, and we call this
"deep" because of the layers of composition. But what if we make this composition go to infinity?

Now, we cannot practically do infinite computation, so instead we need some sense of what "going
close enough to infinity" really means. Fortunately, we can pull a few ideas from the mathematics
of dynamical systems to make this definition. We can think of this iterative process as a
dynamical system $x_{n+1} = f(x_n)$, where the literature categorizes all of the behaviors that
can happen as $n$ goes to infinity: $x$ can oscillate, it can go to infinity, it can do something
that looks almost random (this is the notorious chaos theory), or importantly, it can "stabilize"
to something known as a steady state or equilibria value. This last behavior happens when
$x_{ss} = f(x_{ss})$, where once it settles in to this pattern it will repeat the pattern ad infinitum, and
thus solving the infinity problem can be equivalent to finding a steady state. An entire literature characterizes
the properties of $f$ which cause values to converge to a single repeating value in this sense,
and we refer you to the book "Nonlinear Dynamics and Chaos" by Strogatz as an accessible introduction
to this topic.

If you take a random $f$, it turns out one of the most likely behaviors is for $f$ to either
converge to such steady states or diverge to infinity. If you think about it as just a scalar
linear system $x_{n+1} = a x_n$, when $a<1$ the value keeps decreasing to zero making the
system head to a steady state, while $a>1$ leads to infinity. Thus if our choice of $a$ is
"tame" enough, we can cause these systems to generally be convergent models. Likewise, if we
used an affine system $x_{n+1} = a x_n + b$, the steady state would be defined as $x_{ss} = ax_{ss} + b$
which we can solve to be $x_{ss} = b/(1-a)$. This is now a parameterized model of an infinite
process where, if $a<1$, then iterating $f(x) = ax+b$ infinitely many times will go to a solution
defined by the parameters.

**What if $f$ is a neural network and the parameters are weights of the neural network?**

That is the intuition that defines the [Deep Equilibrium Models](https://arxiv.org/abs/1909.01377),
where $x_{ss}$ is the prediction from the model. This is why DEQs are referred to as infinitely-deep
networks. Now, if the weights are such that $x_{ss}$ is 
divergent towards infinity, those weights would have a very large cost in their predictions and
thus the weights will naturally be driven away from such solutions. This makes such a structure
$x_{n+1} = NN(x_n)$ naturally inclined to learn convergent steady state behavior.

[Note: this line of thought leaves open some interesting alternatives: what neural networks prevent oscillations
and chaos? Or new loss functions? Etc. We'll leave that for you to figure out.]

## But why are DEQs interesting for machine learning?

Before continuing to some examples, we must bridge from "beautiful math" to why you should care.
Why should a machine learning engineer care about this structure? The answer is simple:
with a DEQ, you never have to wonder if you've chosen enough layers. Your number of layers is effectively
infinity, so it's always enough. Indeed, if $x_{ss}$ is the value that comes out of the DEQ, since it's
approximately the solution to this infinite process $x_{n+1} = NN(x_n)$, by definition one more application
leaves the prediction essentially unchanged: $x_{ss} = NN(x_{ss})$. Therefore you're done hyperparameter
optimizing: a DEQ does not have a number of layers to choose. You of course still have to choose an architecture
for $NN$, but this decreases the space of what could go wrong in your training process.

Another interesting detail is that, surprisingly, backpropogation of a DEQ is cheaper than doing a big number
of iterations! How is this possible? It's actually due to a very old mathematical theorem known as the
[Implicit Function Theorem](https://en.wikipedia.org/wiki/Implicit_function_theorem). Let's take a quick
look at the simplified example we wrote before, where $x_{n+1} = a x_n + b$ and thus $x_{ss} = b/(1-a)$.
Essentially the DEQ is the function that gives the solution to a nonlinear system, i.e. $DEQ(x) = x_{ss}$.
What is the derivative of the DEQ's output with respect to the parameters of $a$ and $b$? It turns out this
derivative is easy to calculate and does not require differentiating through the infinite iteration
proceess $x_{n+1} = a x_n + b$: you can directly differentiate $x_{ss} = b/(1-a)$. The Implicit Function
Theorem says that this generally holds: you can always differentiate the steady state without having to
go back through the iterative process. Why this is important is because "backpropogation" or "adjoints"
are simply the derivative of the output with respect to the parameter weights of the neural network. What this
is saying is that, if you have a deep neural network with $n$ very large layers, you need to backpropogate
through $n$ layers. **But if $n$ is infinite, you only need to backpropogate through 1!** The details
of this have been well-studied in the scientific computing literature since at least the 90's. For example, 
Steven Johnson's [Notes on Adjoint Methods for 18.335 from 2006](https://math.mit.edu/~stevenj/18.336/adjoint.pdf) 
shows a well-written derivation of an adjoint equation ("backpropagation" equation) for a rootfinding solver,
along with a [litany](https://link.springer.com/content/pdf/10.1007%2F3-540-45718-6_20.pdf) of 
[papers](http://www.jcomputers.us/vol5/jcp0503-11.pdf) that [use](https://ieeexplore.ieee.org/document/4724607) this
[result](https://www.computer.org/csdl/proceedings-article/cis/2008/3508a020/12OmNz61djv) in the 90's and 00's
to mix neural networks and nonlinear solving. We note very briefly that solving for a steady state is equivalent
to solving a system of nonlinear algebraic equations $NN(x) - x = 0$, since finding this solution would give
$x_{ss} = NN(x_{ss})$, or the steady state.

But everything in this world is a differential equation, so let's take a turn and twist this into an ODE!

## Mixing DEQs and Neural Ordinary Differential Equations (Neural ODEs)

From the viewpoint of Julia and the DiffEqFlux.jl library, it is also natural to look at DEQs from
a differential equations perspective. Instead of viewing the dynamical system as a discrete process 
$x_{n+1} = f(x_n)$, we can equivalently view the system as evolving
continuously, i.e. $x' = f(x)$. If we think about $dx/dt = f(x)$, by Euler's method we approximate $dx = x_{n+1} - x_n$
and simplify to get $x_{n+1} = x_n + dt f(x_n) = g(x_n)$ which relates us back to our original definition with a
slight change to the function. However, in this ODE sense, convergence is when the change is zero, 
or $x'=0$, which again happens when $f(x)=0$ and is a rootfinding problem. **But this view is insightful: 
a DEQ is a neural ODE where time goes to infinity.** Now, instead of taking 1 step at a time, we can take $dt$
steps at a time towards the steady state. This means an adaptive ODE solver can notice we are converging and take
larger and larger steps to get to that equilibrium a bit quicker. But also, given DiffEqFlux, this observation makes implementing
DEQ models in Julia insanely simple. Let's go for it!

## Let us implement a simple DEQ Model via ODE Solvers with Event Handling

The Julia [DifferentialEquations.jl](https://diffeq.sciml.ai/stable/) library has a problem type known as
[SteadyStateProblem](https://diffeq.sciml.ai/stable/types/steady_state_types/) which automatically solves
until $x'$ is sufficiently small (below tolerance), in which case it will automatically use a
[terminating callback](https://diffeq.sciml.ai/stable/features/callback_functions/#Example-2:-Terminating-an-Integration)
to exit the iteration at the (approximately) found steady state. Because the [SciML Organization's Packages](https://sciml.ai/)
are differentiable, we can stick neural networks inside of this "steady state of ODEs" problem, and that
will generate a training mechanism for this continuous-stepping DEQ procedure. This `SteadyStateProblem`
solution then uses the [Nonlinear Solve Adjoint](https://math.mit.edu/~stevenj/18.336/adjoint.pdf) to calculate
the backpropagation in the efficient manner without requiring backpropagation of the iterations. This thus
gives an efficient implementation of a DEQ without requiring any new tooling or packages, but can also 
outperform the fixed-point iteration approaches by taking multiple steps at a time.

The following code block creates a DEQ model. The acute will notice that this code looks
awfully similar to typical [Neural ODEs implemented in Julia](https://julialang.org/blog/2019/01/fluxdiffeq/).
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
    x = solve(ss, DynamicSS(Tsit5()), u0 = z, abstol = 1f-5, reltol = 1f-5).u
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

Tada, we now have a valid machine-learned model for solving the regression problem where the
predictions are given by steady states of an ODE solver, where the ODE is defined by a neural network!

**The general composability of the Julia ecosystem means that there is no "Github repository for DEQs",
instead this is just the ODE solver mixed with the ML library, the AD package, the GPU package, etc.
and when put together you get a DEQ!**

## Generalizing to other Solution Techniques

There are many ways that one can solve a rootfinding problem with different characteristics.
One can directly use Newton's method, but this can require a good guess and may not distinguish
between stable and unstable equilibrium. Julia packages like 
[NLsolve.jl](https://github.com/JuliaNLSolvers/NLsolve.jl) provide many good algorithms, and
Bifurcation tools like [BifurcationKit.jl](https://rveltz.github.io/BifurcationKit.jl/dev/) give a whole host of other methods. 
Given the importance of solving nonlinear algebraic systems and their differentiability, the SciML organization
has put together a common interface package [NonlinearSolve.jl](https://nonlinearsolve.sciml.ai/dev/) that weaves
together all of the techniques throughout the package ecosystem (bringing together methods from SUNDIALS, MINPACK,
etc.) and generally defines its differentiability. As such, this package gives a "one-stop shop" for weaving both new
implementations and classical FORTRAN implementations with machine learning without having to worry
about the training details.

Let's see this in action!

(Demodemodemo)

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

In this blog post we have demonstrated a new perspective for studying DEQ models. Coupled with the
flexible Julia language structure, we have implemented DEQ models by only changing two lines of code
compared to Neural ODEs! The world is your oyster, and composability of the [SciML ecosystem](https://sciml.ai/)
is there to fascilitate doing machine learning with your wildest creations. Mix and match
things at will. We're excited to see what you come up with.
