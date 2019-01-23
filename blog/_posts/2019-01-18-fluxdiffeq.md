---
layout: post
title:  DiffEqFlux.jl: A Julia Library for Neural Differential Equations
author: Chris Rackauckas, Mike Innes, Yingbo Ma, Jesse Bettencourt, Lyndon White, Vaibhav Dixit
---

In this blog post we will show you how to easily, efficiently, and
robustly add differential equation solvers to neural networks in Julia.

![Flux ODE Training Animation](https://user-images.githubusercontent.com/1814174/51399500-1f4dd080-1b14-11e9-8c9d-144f93b6eac2.gif)

The [Neural Ordinary Differential Equations](https://arxiv.org/abs/1806.07366)
paper has been a hot topic even before it made a splash as Best Paper of NeurIPS
2018. Among other demonstrations, combining these two disparate fields enabled
the authors to reduce the number of parameters and reduce memory costs in
comparison to ResNet. But this is only the beginning: neural networks and
differential equations were born to be together. This blog post will explain
why, and start to give a sense of what's possible with state-of-the-art tools.

The advantages of the Julia
[DifferentialEquations.jl](https://github.com/JuliaDiffEq/DifferentialEquations.jl) library for numerically solving differential equations have been
[discussed in detail in other posts](http://www.stochasticlifestyle.com/comparison-differential-equation-solver-suites-matlab-r-julia-python-c-fortran/).
Along with its
[extensive benchmarking against classic Fortran methods](https://github.com/JuliaDiffEq/DiffEqBenchmarks.jl),
it includes other modern features such as
[GPU acceleration](http://www.stochasticlifestyle.com/solving-systems-stochastic-pdes-using-gpus-julia/),
[distributed (multi-node) parallelism](http://docs.juliadiffeq.org/latest/features/monte_carlo.html),
and [sophisticated event handling](http://docs.juliadiffeq.org/latest/features/callback_functions.html).
Recently, these native Julia differential equation solvers have successfully been embedded
into the [Flux](https://github.com/FluxML/Flux.jl/) deep learning package, to allow the use of a full suite of
highly tested and optimized DiffEq methods within neural networks. Using the new package
[DiffEqFlux.jl](https://github.com/JuliaDiffEq/DiffEqFlux.jl/),
we will show the reader how to easily add differential equation
layers to neural networks using a range of differential equations models, including stiff ordinary
differential equations, stochastic differential equations, delay differential
equations, and hybrid (discontinuous) differential equations.

This is the first toolbox to combine a fully-featured differential equations
solver library and neural networks seamlessly together. The blog post will also
show why the flexibility of a full differential equation solver suite is
necessary. With the ability to fuse neural networks with ODEs, SDEs, DAEs, DDEs,
stiff equations, and different methods for adjoint sensitivity calculations,
this is a large generalization of the neural ODEs work and will allow
researchers to better explore the problem domain.

(Note: If you are interested in this work and are an undergraduate or graduate
student, we have [Google Summer of Code projects available in this area](https://julialang.org/soc). This
[pays quite well over the summer](https://developers.google.com/open-source/gsoc/help/student-stipends).
Please join the [Julia Slack](https://slackinvite.julialang.org/) and the #jsoc channel to discuss in more detail.)

## What do differential equations have to do with machine learning?

The first question someone not familiar with the field might ask is, why are
differential equations important in this context? The simple answer is that a
differential equation is a way to specify an arbitrary nonlinear transform by
mathematically encoding prior structural assumptions.

Let's unpack that statement a bit. There are generally three ways
to define a nonlinear transformation. The first is to explicitly say what it is.
For example, the sigmoid function is $\sigma(x)=\frac{e^x}{e^x + 1}$. This only works
if you know the exact functional form that relates the input to the output.
However, in many cases, such exact relations are not known *a priori*.
So how do you do nonlinear modeling if you don't know the nonlinearity?

There are two common ways to handle this problem. One method is to use machine
learning. In a typical machine learning problem, you are given some input $x$ and
you want to predict an output $y$. This generation of a prediction $y$ from $x$
is a machine learning model (let's call it $ML$).  During training, we attempt to
adjust the parameters of $ML$ so that it generates accurate predictions.  We
can then use $ML$ for inference (i.e., produce $y$s for novel inputs $x$).
But if you think
about it differently, this is actually just a nonlinear transformation $y=ML(x)$.
The reason $ML$ is interesting is because its form is basic but adapts to the
data itself. For example, a simple neural network (in design matrix form) with
sigmoid activation functions is simply matrix multiplications followed
by application of sigmoid functions. Specifically, $ML(x)=\sigma(W_{3}\cdot\sigma(W_{2}\cdot\sigma(W_{1}\cdot x)))$ is a three-layer deep
neural network, where $W=(W_1,W_2,W_3)$ are learnable parameters.
You then choose $W$ such that $ML(x)=y$ reasonably fits the function you wanted it to fit.
The theory and practice of machine learning confirms that this is a good way to learn nonlinearities.
For example, the Universal Approximation Theorem states that, for
enough layers or enough parameters (i.e. sufficiently large $W_{i}$ matrices), $ML(x)$
can approximate any nonlinear function sufficiently close (subject to common constraints).

So great, this always works! But it has some caveats, the main being
that it has to learn everything about the nonlinear transform directly from the data.
In many cases we do not know the full nonlinear equation, but we may know details about its structure.
For example, the nonlinear function could be the population of rabbits in the forest,
and we might know that their rate of births is dependent on the current population.
Thus instead of starting from nothing, we may want to use this known _a priori_ relation and a set of parameters that defines it.
For the rabbits, let's say that we want to learn

$$\text{rabbits tomorrow} = \text{Model}(\text{rabbits today}).$$

In this case, we have prior knowledge of the rate of births being dependent on
the current population. The way to mathematically state this
structural assumption is via a differential equation. Here, what we are saying
is that the birth rate of the rabbit population at a given time point increases
when we have more rabbits. The simplest way of encoding that is

$$\text{rabbits}'(t) = \alpha\cdot \text{rabbits}(t)$$

where $\alpha$ is some learnable constant. If you know your calculus, the solution
here is exponential growth from the starting point with a growth rate $\alpha$:
$\text{rabbits}(t_\text{start})e^(\alpha t)$. But notice that we didn't need to know the
solution to the differential equation to validate the idea: we encoded the
structure of the model and mathematics itself then outputs what the solution
should be. Because of this, differential equations have been the tool of choice
in most science. For example, physical laws tell you how electrical quantities
emit forces ([Maxwell's Equations](https://en.wikipedia.org/wiki/Maxwell%27s_equations)).
These are essentially equations of how things change and thus
"where things will be" is the solution to a differential equation. But in recent
decades this application has gone much further, with fields like systems biology
learning about cellular interactions by encoding known biological structures and
mathematically enumerating our assumptions or in targeted drug dosage through
PK/PD modelling in systems pharmacology.

So as our machine learning models grow and are hungry for larger and larger
amounts of data, differential equations have become an attractive option for
specifying nonlinearities in a learnable (via the parameters) but constrained
form. They are essentially a way of incorporating prior domain-specific knowledge of the structural relations
between the inputs and outputs. Given this way of looking at the two, both methods
trade off advantages and disadvantages, making them complementary tools for modeling.
It seems like a clear next step in scientific practice to start putting them
together in new and exciting ways!

## What is the Neural Ordinary Differential Equation (ODE)?

The neural ordinary differential equation is one of many ways to put these two
subjects together. The simplest way of explaining it is that, instead of
learning the nonlinear transformation directly, we wish to learn the structures
of the nonlinear transformation. Thus instead of doing $y=ML(x)$, we put the
machine learning model on the derivative, $y'(x) = ML(x)$, and now solve the ODE.
Why would you ever do this? Well, one motivation is that, if you were to do this
and then solve the ODE using the simplest and most error prone method, the
Euler method, what you get is equivalent to a [residual neural network](https://arxiv.org/abs/1512.03385).
The way the Euler method works is based on the fact that $y'(x) = \frac{dy}{dx}$, thus

$$\Delta y = (y_\text{next} - y_\text{prev}) = \Delta x\cdot ML(x) \text{ which implies that } y_{i+1} = y_{i} + \Delta x\cdot ML(x_{i}).$$

This looks similar in structure to a ResNet, one of the most successful image
processing models. The insight of the the Neural ODEs paper was that
increasingly deep and powerful ResNet-like models effectively approximate a kind
of "infinitely deep" model as each layer tends to zero. Rather than adding more
layers, we can just model the differential equation directly and then solve it
using a purpose-built ODE solver. Numerical ODE solvers are a science that goes
all the way back to the first computers, and modern ones can adaptively choose
step sizes $\Delta x$ and use high order approximations to dratically reduce the
number of actual steps required. And as it turns out, this works well in
practice, too.

## How do you solve an ODE?

First, how do you numerically specify and solve an ODE? If you're new to solving
ODEs, you may want to watch our
[video tutorial on solving ODEs in Julia](https://www.youtube.com/watch?v=KPEqYtEd-zY)
and look through the
[ODE tutorial of the DifferentialEquations.jl documentation](http://docs.juliadiffeq.org/latest/tutorials/ode_example.html).
The idea is that you define an `ODEProblem` via a derivative equation `u'=f(u,p,t)`,
and provide an initial condition `u0`, and a timespan `tspan` to solve over, and
specify the parameters `p`.

For example, the
[Lotka-Volerra equations describe the dynamics of the population of rabbits and wolves](https://en.wikipedia.org/wiki/Lotka%E2%80%93Volterra_equations).
They can be written as:

$$
\begin{align}
x^\prime $= \alpha x + \beta x y
y^\prime $= -\gamma y + \gamma x y
$$

and encoded in Julia like:

```julia
using DifferentialEquations
function lotka_volterra(du,u,p,t)
  x, y = u
  α, β, δ, γ = p
  du[1] = dx = α*x - β*x*y
  du[2] = dy = -δ*y + γ*x*y
end
u0 = [1.0,1.0]
tspan = (0.0,10.0)
p = [1.5,1.0,3.0,1.0]
prob = ODEProblem(lotka_volterra,u0,tspan,p)
```

Then to solve the differential equations, you can simply call `solve` on the
`prob`:

```julia
sol = solve(prob)
using Plots
plot(sol)
```

![LV Solution Plot](https://user-images.githubusercontent.com/1814174/51388169-9a07f300-1af6-11e9-8c6c-83c41e81d11c.png)

One last thing to note is that we can make our initial condition (`u0`) and time spans (`tspans`)
to be functions of the parameters (the elements of `p`). For example, we can define the `ODEProblem`:

```julia
u0_f(p,t0) = [p[2],p[4]]
tspan_f(p) = (0.0,10*p[4])
p = [1.5,1.0,3.0,1.0]
prob = ODEProblem(lotka_volterra,u0_f,tspan_f,p)
```

In this form, everything about the problem is determined by the parameter vector (`p`, referred to
as `θ` in associated literature). The utility of this will be seen later.

DifferentialEquations.jl has many powerful options for customising things like
accuracy, tolerances, solver methods, events and more; check out [the
docs](http://docs.juliadiffeq.org/latest/) for more details on how to use it in
more advanced ways.

## Let's Put an ODE Into a Neural Net Framework!

To understand embedding an ODE into a neural network, let's look at what a
neural network layer actually is. A layer is really just a *differentiable
function* which takes in a vector of size `n` and spits out a new vector of size
`m`. That's it! Layers have traditionally been simple functions like matrix
multiply, but in the spirit of [differentiable
programming](https://julialang.org/blog/2018/12/ml-language-compiler) people are
increasingly experimenting with much more complex functions, such as ray tracers and
physics engines.

Turns out that differential equations solvers fit this framework, too: A solve
takes in some vector `p` (which might include parameters like the initial
starting point), and outputs some new vector, the solution. Moreover it's
differentiable, which means we can put it straight into a larger differentiable
program. This larger program can happily include neural networks, and we can keep
using standard optimisation techniques like ADAM to optimise their weights.

DiffEqFlux.jl makes it convenient to do just this; let's take it for a spin.

The most basic differential equation layer is `diffeq_rd`. The way to understand this
function is that it does the following. It takes in parameters for the integrand, `p`,
it puts it in the differential equation defined by `prob`, solves it with
the chosen arguments (solver, tolerance, etc), and then gets a vector out through
some function `reduction`. For example, in our Lotka-Volerra problem, let's say we wanted
to go from `p` to a vector of an evenly-spaced time series for `x(t)`.
In the REPL, we would write:

```julia
p = [1.5,1.0,3.0,1.0]
prob = ODEProblem(lotka_volterra,u0,tspan,p)
sol = solve(prob,Tsit5(),saveat=0.1)
A = sol[1,:] # length 101 vector
```

Let's plot `(t,A)` over the ODE's solution to see what we got:

```julia
plot(sol)
t = 0:0.1:10.0
scatter!(t,A)
```

![Data points plot](https://user-images.githubusercontent.com/1814174/51388173-9c6a4d00-1af6-11e9-9878-3c585d3cfffe.png)

So this is what we wanted: a vector which is the time series of `x(t)` saved at every 0.1 time steps
given that the parameters are `p`. To write this using the layer function, we simply make
our solution handling be in the function `reduction` used above in `diffeq_rd(p,reduction,prob,args...;kwargs...)`.
Thus this code is equivalent to:

```julia
using Flux, DiffEqFlux
reduction(sol) = sol[1,:]
diffeq_rd(p,reduction,prob,Tsit5(),saveat=0.1)
```

As a reminder, this is a function which takes in a parameter vector `p`,
solves the Lotka-Volterra problem `prob` with our chosen ODE solver arguments,
and then gets a vector out via `reduction` which is the time series of `x(t)`.

The nice thing about `diffeq_rd` is that it takes care of the type handling
necessary to make it compatible with the neural network framework (here Flux). To show this,
let's define a neural network with the function as our single layer, and then a loss
function that is the squared distance of the output values from `1`. In Flux, this looks like:

```julia
p = param([2.2, 1.0, 2.0, 0.4]) # Initial Parameter Vector
params = Flux.Params([p])

function predict_rd() # Our 1-layer neural network
  diffeq_rd(p,reduction,prob,Tsit5(),saveat=0.1)
end

loss_rd() = sum(abs2,x-1 for x in predict_rd()) # loss function
```

Now we tell Flux to train the neural network by running a 100 epoch
to minimise our loss function (`loss_rd()`) and thus obtain the optimized parameters:

```julia
data = Iterators.repeated((), 100)
opt = ADAM(0.1)
cb = function () #callback function to observe training
  display(loss_rd())
  # using `remake` to re-create our `prob` with current parameters `p`
  display(plot(solve(remake(prob,p=Flux.data(p)),Tsit5(),saveat=0.1),ylim=(0,6)))
end

# Display the ODE with the initial parameter values.
cb()

Flux.train!(loss_rd, params, data, opt, cb = cb)
```

The result of this is the animation shown at the top.

Flux finds the parameters of the neural network (`p`) which minimize
the cost function, i.e. it trains the neural network: it just so happens that
the forward pass of the neural network includes solving an ODE.
Since our cost function put a penalty whenever the number of
rabbits was far from 1, our neural network found parameters where our population
of rabbits and wolves are both constant 1.

Now that we have solving ODEs as just a layer, we can add it anywhere. For example,
the multilayer perceptron is written in Flux as

```julia
m = Chain(
  Dense(28^2, 32, relu),
  Dense(32, 10),
  softmax)
```

and if we had an appropriate ODE which took a parameter vector of the right size,
we can stick it right in there:

```julia
m = Chain(
  Dense(28^2, 32, relu),
  # this would require an ODE of 32 parameters
  p -> diffeq_rd(p,reduction,prob,Tsit5(),saveat=0.1),
  Dense(32, 10),
  softmax)
```

or we can stick it into a convolutional neural network, where the previous
layers define the initial condition for the ODE:

```julia
m = Chain(
  Conv((2,2), 1=>16, relu),
  x -> maxpool(x, (2,2)),
  Conv((2,2), 16=>8, relu),
  x -> maxpool(x, (2,2)),
  x -> reshape(x, :, size(x, 4)),
  x -> diffeq_rd(p,reduction,prob,Tsit5(),saveat=0.1,u0=x),
  Dense(288, 10), softmax) |> gpu
```

As long as you can write down the forward pass, we can take any parameterised,
differentiable program and optimise it. The world is your oyster.

## Why is a full ODE solver suite necessary for doing this well?

Where we have combined an existing solver suite and deep learning library, the
excellent [torchdiffeq](https://github.com/rtqichen/torchdiffeq) project takes
an alternative approach, instead implementing solver methods directly in
PyTorch, including an adaptive Runge Kutta 4-5 (`dopri5`) and an
Adams-Bashforth-Moulton method (`adams`). However, while their approach is very
effective for certain kinds of models, not having access to a full solver suite
is limiting.

Consider the following example, the [ROBER
ODE](https://www.radford.edu/~thompson/vodef90web/problems/demosnodislin/Single/DemoRobertson/demorobertson.pdf).
The most well-tested (and optimized) implementation of an
Adams-Bashforth-Moulton method is the [CVODE integrator in the C++ package
SUNDIALS](https://computation.llnl.gov/projects/sundials) (a derivative of the
classic LSODE). Let's use DifferentialEquations.jl to call CVODE with its Adams
method and have it solve the ODE for us:

```julia
rober = @ode_def Rober begin
  dy₁ = -k₁*y₁+k₃*y₂*y₃
  dy₂ =  k₁*y₁-k₂*y₂^2-k₃*y₂*y₃
  dy₃ =  k₂*y₂^2
end k₁ k₂ k₃
prob = ODEProblem(rober,[1.0;0.0;0.0],(0.0,1e11),(0.04,3e7,1e4))
solve(prob,CVODE_Adams())
```

(For those familiar with solving ODEs in MATLAB, this is similar to `ode113`)

Both this and the `dopri` method from [Ernst Hairer's Fortran
Suite](https://www.unige.ch/~hairer/software.html) stall and fail to solve the
equation. This happens because the ODE is
[stiff](https://en.wikipedia.org/wiki/Stiff_equation), and thus methods with
"smaller stability regions" will not be able to solve it appropriately (for more
details, I suggest reading Hairer's Solving Ordinary Differential Equations II).
On the other hand `KenCarp4()` to this problem, the equation is solved in a
blink of an eye:

```julia
sol = solve(prob,KenCarp4())
using Plots
plot(sol,xscale=:log10,tspan=(0.1,1e11))
```

![ROBER Plot](https://user-images.githubusercontent.com/1814174/51388944-eb18e680-1af8-11e9-874f-09478759596e.png)

This is just one example of subtlety in integration: Stabilizing explicit
methods via PI-adaptive controllers, step prediction in implicit solvers, etc.
are all intricate details that take a lot of time and testing to become
efficient and robust. Different problems require different methods: [Symplectic
integrators](http://docs.juliadiffeq.org/latest/solvers/dynamical_solve.html#Symplectic-Integrators-1)
are required to [adequately handle physical many problems without
drift](https://scicomp.stackexchange.com/questions/29149/what-does-symplectic-mean-in-reference-to-numerical-integrators-and-does-scip/29154#29154),
and tools like [IMEX
integrators](http://docs.juliadiffeq.org/latest/solvers/split_ode_solve.html#Implicit-Explicit-(IMEX)-ODE-1)
are required to handle ODEs which [come from partial differential
equations](https://www.youtube.com/watch?v=okGybBmihOE). Building a
production-quality solver is thus an enormous undertaking and relatively few
exist.

Rather than building an ML-specific solver suite in parallel to one suitable for
scientific computing, in Julia they are one and the same, meaning you can take
advantage of all of these methods today.

## What kinds of differential equations are there?

Ordinary differential equations are only one kind of differential equation. There
are many additional features you can add to the structure of a differential equation.
For example, the amount of bunnies in the future isn't dependent on the number
of bunnies right now because it takes a non-zero amount of time for a parent
to come to term after a child is incepted. Thus the birth rate of bunnies is
actually due to the amount of bunnies in the past. Using a lag term in a
differential equation's derivative makes this equation known as a delay
differential equation (DDE). Since
[DifferentialEquations.jl handles DDEs](http://docs.juliadiffeq.org/latest/tutorials/dde_example.html)
through the same interface as ODEs, it can be used as a layer in
Flux as well. Here's an example:

```julia
function delay_lotka_volterra(du,u,h,p,t)
  x, y = u
  α, β, δ, γ = p
  du[1] = dx = (α - β*y)*h(p,t-0.1)[1]
  du[2] = dy = (δ*x - γ)*y
end
h(p,t) = ones(eltype(p),2)
prob = DDEProblem(delay_lotka_volterra,[1.0,1.0],h,(0.0,10.0),constant_lags=[0.1])

p = param([2.2, 1.0, 2.0, 0.4])
params = Flux.Params([p])
function predict_rd_dde()
  diffeq_rd(p,reduction,prob,101,MethodOfSteps(Tsit5()),saveat=0.1)
end
loss_rd_dde() = sum(abs2,x-1 for x in predict_rd_dde())
loss_rd_dde()
```

Additionally we can add randomness to our differential equation to simulate
how random events can cause extra births or more deaths than expected. This
kind of equation is known as a stochastic differential equation (SDE).
Since [DifferentialEquations.jl handles SDEs](http://docs.juliadiffeq.org/latest/tutorials/sde_example.html)
(and is currently the only library with adaptive stiff and non-stiff SDE integrators),
these can be handled as a layer in Flux similarly. Here's a neural net layer
with an SDE:

```julia
function lotka_volterra_noise(du,u,p,t)
  du[1] = 0.1u[1]
  du[2] = 0.1u[2]
end
prob = SDEProblem(lotka_volterra,lotka_volterra_noise,[1.0,1.0],(0.0,10.0))

p = param([2.2, 1.0, 2.0, 0.4])
params = Flux.Params([p])
function predict_fd_sde()
  diffeq_fd(p,reduction,101,prob,SOSRI(),saveat=0.1)
end
loss_fd_sde() = sum(abs2,x-1 for x in predict_fd_sde())
loss_fd_sde()
```

And we can train the neural net to watch it in action and find parameters to make
the amount of bunnies close to constant:

```julia
data = Iterators.repeated((), 100)
opt = ADAM(0.1)
cb = function ()
  display(loss_fd_sde())
  display(plot(solve(remake(prob,p=Flux.data(p)),SOSRI(),saveat=0.1),ylim=(0,6)))
end

# Display the ODE with the current parameter values.
cb()

Flux.train!(loss_fd_sde, params, data, opt, cb = cb)
```

![SDE NN Animation](https://user-images.githubusercontent.com/1814174/51399524-2c6abf80-1b14-11e9-96ae-0192f7debd03.gif)

And we can keep going. There are differential equations
[which are piecewise constant](http://docs.juliadiffeq.org/latest/tutorials/discrete_stochastic_example.html)
used in biological simulations, or
[jump diffusion equations from financial models](http://docs.juliadiffeq.org/latest/tutorials/jump_diffusion.html),
and the solvers map right over to the Flux neural network frame work through FluxDiffEq.jl
FluxDiffEq.jl uses only around ~100 lines of code to pull this all off.

## Implementing the Neural ODE layer in Julia

Let's go all the way back for a second and now implement the neural ODE layer
in Julia. Remember that this is simply an ODE where the derivative function
is defined by a neural network itself. To do this, let's first define the
neural net for the derivative. In Flux, we can define a multilayer perceptron
with 1 hidden layer and a `tanh` activation function like:

```julia
dudt = Chain(Dense(2,50,tanh),Dense(50,2))
```

To define a `neural_ode` layer, we then just need to give it a timespan and use
the `neural_ode` helper function:

```julia
tspan = (0.0f0,25.0f0)
x->neural_ode(dudt,x,tspan,Tsit5(),saveat=0.1)
```

As a side note, to run this on the GPU, it is sufficient to make the initial
condition and neural network be on the GPU. This will cause the entire ODE
solver's internal operations to take place on the GPU without extra data
transfers in the integration scheme. This looks like:

```julia
x->neural_ode(gpu(dudt),gpu(x),tspan,BS3(),saveat=0.1)
```

## Understanding the Neural ODE layer behavior by example

Now let's use the neural ODE layer in an example to find out what it means.
First, let's generate a time series of the Lotka-Volterra equation saved at
every 0.1 timesteps:

```julia
function lotka_volterra(du,u,p,t)
  x, y = u
  α, β, δ, γ = p
  du[1] = dx = α*x - β*x*y
  du[2] = dy = -δ*y + γ*x*y
end
u0 = [1.0,1.0]
tspan = (0.0,10.0)
p = [1.5,1.0,3.0,1.0]
prob = ODEProblem(lotka_volterra,u0,tspan,p)
ode_data = Array(solve(prob,Tsit5(),saveat=0.1))
```

Now let's pit a neural ODE against our Lotka-Volterra equation. To do so, we
will define a single layer neural network which just has the same neural ODE
as before:

```julia
dudt = Chain(Dense(2,50,tanh),Dense(50,2))
tspan = (0.0f0,10.0f0)
n_ode = x->neural_ode(dudt,x,tspan,Tsit5(),saveat=0.1)
```

Notice that the `neural_ode` has the same timespan and `saveat` as the solution
that generated the data. This means that given an `x` (and initial value), it
will generate a guess for what it thinks the time series will be where the
dynamics (the structure) is predicted by the internal neural network. Let's see
what time series it gives before we train the network. Since Lotka-Volterra
has two dependent variables, we will simplify the plot by only showing the `x`.
The code for the plot is:

```julia
pred = n_ode(u0) # Get the prediction using the correct initial condition
scatter(0.0:0.1:10.0,ode_data[1,:],label="data")
scatter!(0.0:0.1:10.0,Flux.data(pred[1,:]),label="prediction")  
```

But now let's train our neural network. To do so, define a prediction function like before, and then
define a loss between our prediction and data:

```julia
function predict_n_ode()
  n_ode(u0)
end
loss_n_ode() = sum(abs2,ode_data .- predict_n_ode())
```

And now we train the neural network and watch as it learns how to
predict our time series:

```julia
data = Iterators.repeated((), 100)
opt = ADAM(0.1)
cb = function () #callback function to observe training
  display(loss_n_ode())
  # plot current prediction against data
  cur_pred = Flux.data(predict_n_ode())
  pl = scatter(0.0:0.1:10.0,ode_data[1,:],label="data")
  scatter!(pl,0.0:0.1:10.0,cur_pred[1,:],label="prediction")
  plot(pl)
end

# Display the ODE with the initial parameter values.
cb()

Flux.train!(loss_n_ode, params, data, opt, cb = cb)
```

Notice that what's not being learned is the solution to the ODE.
Instead, what's learned is the tiny ODE system from which the ODE
solution is generated. I.e., the neural network inside the neural_ode
layer has learned this function:

```julia
function lotka_volterra(du,u,p,t)
  x, y = u
  α, β, δ, γ = p
  du[1] = dx = α*x - β*x*y
  du[2] = dy = -δ*y + γ*x*y
end
```

Thus **it learned a compact representation of how the nonlinear function
works**, and it can easily extrapolate to what would happen with
different starting conditions. Not only that, it's a very flexible
method for learning such representations. For example, if your data is
unevenly spaced at time points `t`, just pass in `saveat=t` and the
ODE solver takes care of it.

As you could probably guess by now, DiffEqFlux.jl has all kinds of
extra related goodies like Neural SDEs (`neural_msde`) for you to explore in your
applications.

## The core technical challenge: backpropagation through differential equation solvers

Let's end by explaining the technical issue that needed a solution to make this
all possible. The core to any neural network framework is the ability to
backpropagate derivatives in order to calculate the gradient of the loss function
with respect to the network's parameters. Thus if we stick an ODE solver as a
layer in a neural network, we need to backpropagate through it.

There are multiple ways to do this. The most common is known as (adjoint) sensitivity
analysis. Sensitivity analysis defines a new ODE whose solution gives the
gradients to the cost function w.r.t. the parameters, and solves this secondary
ODE. This is the method discussed in the neural ordinary differential equations
paper, but actually dates back much further, and popular ODE solver frameworks
like [FATODE](http://people.cs.vt.edu/~asandu/Software/FATODE/index.html),
[CASADI](https://web.casadi.org/), and
[CVODES](https://computation.llnl.gov/projects/sundials/cvodes)
have been available with this adjoint method for a long time (CVODES came out
in 2005!) and lastly [DifferentialEquations.jl also provides an extensive sensitivity analysis implementation](http://docs.juliadiffeq.org/latest/analysis/sensitivity.html).

The efficiency problem with adjoint sensitivity analysis methods is that they require
multiple forward solutions of the ODE. As you would expect, this is very costly.
Methods like the checkpointing scheme in CVODES reduce the cost by saving closer
time points to make the forward solutions shorter at the cost of using more
memory. The method in the neural ordinary differential equations paper tries to
eliminate the need for these forward solutions by doing a backwards solution
of the ODE itself along with the adjoints. The issue with this is that this
method implicitly makes the assumption that the ODE integrator is
[reversible](https://www.physics.drexel.edu/~valliere/PHYS305/Diff_Eq_Integrators/time_reversal/).
Sadly, there are no reversible adaptive integrators for first-order ODEs, so
with no ODE solver method is this guaranteed to work. For example, here's a quick
equation where a backwards solution to the ODE using the Adams method from the
paper has >1700% error in its final point, even with solver tolerances of 1e-12:

```julia
using Sundials, DiffEqBase
function lorenz(du,u,p,t)
 du[1] = 10.0*(u[2]-u[1])
 du[2] = u[1]*(28.0-u[3]) - u[2]
 du[3] = u[1]*u[2] - (8/3)*u[3]
end
u0 = [1.0;0.0;0.0]
tspan = (0.0,100.0)
prob = ODEProblem(lorenz,u0,tspan)
sol = solve(prob,CVODE_Adams(),reltol=1e-12,abstol=1e-12)
prob2 = ODEProblem(lorenz,sol[end],(100.0,0.0))
sol = solve(prob,CVODE_Adams(),reltol=1e-12,abstol=1e-12)
@show sol[end]-u0 #[-17.5445, -14.7706, 39.7985]
```

(here we once again use the CVODE C++ solvers from SUNDIALS since they are a close
match to the SciPy integrators used in the neural ODE paper)

This inaccuracy is the reason why the method from the neural ODE paper is not
implemented in software suites, but it once again highlights a detail. Not
all ODEs will have a large error due to this issue. And on ODEs where it's not
a problem, this will be the most efficient way to do adjoint sensitivity
analysis. And this method only applies to ODEs. Not only that, it doesn't even
apply to all ODEs. For example, ODEs with discontinuities ([events](http://docs.juliadiffeq.org/latest/features/callback_functions.html)) are excluded by the assumptions of the derivation.
Thus once again we arrive at the conclusion that one method is not enough.

In DifferentialEquations.jl we have implemented many different methods for
computing the derivatives of differential equations with respect to parameters.
We have a [recent preprint](https://arxiv.org/abs/1812.01892) detailing
some of these results. One of the things we have found is that direct use of
automatic differentiation can be one of the most efficient and flexible methods.
Julia's ForwardDiff.jl, Flux, and ReverseDiff.jl can directly be applied to
perform automatic differentiation on the native Julia differential equation
solvers themselves, and this can increase performance while giving new features.
Our findings show that forward-mode automatic differentiation is fastest when
there are less than 100 parameters in the differential equations, and that for
a large enough number of parameters adjoint sensitivity analysis is the most efficient. Even
then, we have good reason to believe that
[the next generation reverse-mode automatic differentiation via source-to-source AD, Zygote.jl](https://julialang.org/blog/2018/12/ml-language-compiler),
will be more efficient than all of the adjoint sensitivity implementations for
large numbers of parameters.

Altogether, being able to switch between different gradient methods without changing
the rest of your code is crucial for having a scalable, optimized, and
maintainable framework for integrating differential equations and neural networks.
And this is precisely what FluxDiffEq.jl gives the user direct access to. There
are three functions:

- `diffeq_rd` uses Flux's reverse-mode AD through the differential equation
  solver.
- `diffeq_fd` uses ForwardDiff.jl's forward-mode AD through the differential
  equation solver.
- `diffeq_adjoint` uses adjoint sensitivity analysis to "backprop the ODE solver"

With a similar API. Therefore, to switch from a reverse-mode AD layer to a forward-mode
AD layer, one simply has to change a single character. Since Julia-based automatic
differentiation works on Julia code, the native Julia differential equation
solvers will continue to benefit from advances in this field.

## Conclusion

Machine learning and differential equations are destined to come together due to
their complementary ways of describing a nonlinear world. In the Julia ecosystem
we have merged the differential equation and deep learning packages in such a
way that new developments in the two domains can directly be used together.
We are only beginning to understand the possibilities that have opened up with
this software. We hope that future blog posts will detail some of the cool
applications which mix the two disciplines, such as embedding our coming
pharmacometric simulation engine [PuMaS.jl](https://doi.org/10.1007/s10928-018-9606-9)
into the deep learning framework. With access to the full range of solvers for ODEs,
SDEs, DAEs, DDEs, PDEs, discrete stochastic equations, and more, we are
interested to see what kinds of next generation neural networks you build with Julia.
