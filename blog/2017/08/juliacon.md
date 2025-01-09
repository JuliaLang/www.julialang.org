@def rss_pubdate = Date(2017, 8, 15)
@def rss_description = """ JuliaCon 2017 on the West Coast | ! (/assets/blog/2017-08-15-juliacon/juliacon.jpg)... """
@def published = "15 August 2017"
@def title = "JuliaCon 2017 on the West Coast"
@def authors = "Ranjan Anantharaman"


![](/assets/blog/2017-08-15-juliacon/juliacon.jpg)

It’s [a year later](/blog/2016/09/juliacon2016)
and I’m back: this time to the West Coast for the next edition of
JuliaCon. The [latest
edition](https://www.youtube.com/playlist?list=PLP8iPy9hna6QpP6vqZs408etJVECPKIev)
promised more talks, workshops, and wider community attendance.  As
usual, the conference began with a day dedicated to workshops.

The
first workshop was on the
[DifferentialEquations](https://github.com/SciML/) ecosystem,
championed by [Chris
Rackauckas,](https://www.youtube.com/watch?v=7NDkpWoNiQ4) who spoke
about his vision to make the ecosystem the scientist’s one stop shop
for simulations. It certainly looked to be shaping up into a robust
ecosystem. Incidentally, Chris also has an army of GSoC students
working on improvements to many different little pieces. The next
workshop I attended was the one on
[`Optim.jl`](https://github.com/JuliaNLSolvers/Optim.jl). Statistical
learning problems are often minimization problems where the objective
function to minimize is your error function. The Optim ecosystem
provides a rich variety of techniques to solve this problem, with a
rich selection of options and callbacks for the user to understand why
his problem hasn’t converged.

The last workshop was on [machine
learning](https://github.com/ninjin/juliacon2017_dl_workshop) in
Julia. It started explaining concepts in machine learning from the
ground up and then coding them up in pure Julia.  Then we went into
neural networks and deep learning before writing a recurrent network
in pure Julia.

The day in retrospect turned out to be quite heavy, but I had to ran
back home to start preparing for my talks.

The first day’s keynote presented by [Fernando
Perez,](https://www.youtube.com/watch?v=DUdE3M2nlDE) a research
scientist at Lawrence Berkeley National Labs (LBNL), was on using
online software and tools such as Binder that can render Jupyter
notebooks, and how this would help researchers share their plots and
results in the form of a
notebook. [Stefan’s](https://www.youtube.com/watch?v=-yUiLCGegJs)
[Pkg3](https://github.com/StefanKarpinski/Pkg3.jl) talk laid out the
problems with the old package manager and then articulated how Pkg3
would solve some of those problems.  At this point, I decided to go
brush up for my joint talk with my colleague [Simon
Byrne](https://www.youtube.com/watch?v=FKBSVb9405w) on Miletus, a
Julia package used to model financial contracts and then to value them
using a suite of algorithms. In the afternoon, my colleague
[Jameson](https://www.youtube.com/watch?v=7KGZ_9D_DbI) attempted to
break down the inner workings of the Julia compiler and some future
directions he might want to take it, after which [Tim
Besard](https://www.youtube.com/watch?v=525t9-nsn5Y) spoke about his
work on [native GPU
code-generation](https://github.com/JuliaGPU/CUDAnative.jl), where he
intercepts LLVM IR to generate PTX code that runs directly on the GPU.

It was nice watching my colleague [Mike
Innes](https://www.youtube.com/watch?v=vWaHDS--s-g) talk about
[Flux](https://github.com/MikeInnes/Flux.jl), which is a new Julia
package for machine learning that aims to treats models as functions
with tunable parameters. Through use of macros and functional
programming paradigms, Flux’s ease of use would allow developers to
design complex neural network architectures, and step through each
layer like anyone would a normal Julia function. While Flux is meant
to act as a specification library, a package like
[`KNet.jl`](https://github.com/denizyuret/Knet.jl) aims to act like a
proper computational backend. [Deniz
Yuret](https://www.youtube.com/watch?v=uMs2192YAxg) explained how
`Knet.jl` uses dynamic computational graphs and uses [automatic
differentiation](https://github.com/denizyuret/AutoGrad.jl) to get the
gradients of any Julia function. The package uses several high level
language features which the author claims is missing from other
frameworks that work with static computational graphs.

The second day started with [Mykel
Kochenderfer’s](https://www.youtube.com/watch?v=rj-WhTL_VXE) work with
the FAA and Lincoln Labs on collision avoidance systems. He went into
detail about the complex decision processes that he has to work with
under uncertainty. This followed by Jeff’s review of the type system
overhaul. This, for me, was one of the best presentations at the
conference, for how Jeff broke down fairly complex ideas into a simple
ones for general consumption. I also got a chance to listen for the
first time to a talk on [probabilistic
programming](https://github.com/yebai/Turing.jl), which was delivered
by [Kai Xu](https://www.youtube.com/watch?v=h227k438CeQ).  The next
talk was about [multidimensional signal
processing](https://github.com/arsenal9971/Shearlab.jl), especially
focussing on the Shear Transform. I was delighted to know that the
author, [Hector Andrade
Loarca](https://www.youtube.com/watch?v=8iYUbWfR_lI), uses
[`ArrayFire.jl`](https://github.com/JuliaGPU/ArrayFire.jl) for
his research, and that it helps him greatly.

The Celeste keynote was the highlight of the day, with my colleague
[Keno](https://www.youtube.com/watch?v=uecdcADM3hY) getting into the
details of the computation. He spoke about how he had to make several
improvements to the Julia compiler so as to make memory access
patterns more uniform and hence more efficient, and how they even used
Julia packages almost as is for the project. Not only was it
remarkable that they crossed 1 Petaflop (which is probably the first
for a high productivity language), they managed to do so without
writing hand tuned Ninja code.  This, for me, was the biggest
achievement. After the keynote, I had to run off to prepare for my
second talk at the conference:
[`Circuitscape`](https://github.com/ranjanan/CircuitScape.jl), a
landscape modelling tool that was used to calculate least resistance
paths across large swathes of land. I [went into
detail](https://www.youtube.com/watch?v=S731cjT5nIw) about my vision
for the package and how I will take it there, and hopefully earned a
couple of collaborators.

At the end of the day, there was a poster session with GSoC students
presenting their work over posters. They were all great. It was in
particular nice to see an old intern of ours, Divyansh, do some great
work on
[`LightGraphs.jl`](https://github.com/JuliaGraphs/LightGraphs.jl),
where he parallelizes betweenness centrality and Dijsktra's algorithms
with weighted graphs. Kenta Sato, who is a core contributor to
[`Bio.jl`](https://github.com/BioJulia/Bio.jl), was back as a GSoC
student and was trying to get some parallelism into `Bio.jl` using
[`Dagger.jl`](https://github.com/JuliaParallel/Dagger.jl).

The last day of the conference started [Kathy
Yelick](https://www.youtube.com/watch?v=rj-WhTL_VXE) from UC Berkeley
talking about how the High Performance Computing (HPC) and Big Data
worlds are sort of merging, and how researchers need to find ways to
tackle larger amounts of scientific data. Then it was time for a
lighter session with
[Jiahao](https://www.youtube.com/watch?v=C2RO34b_oPM) talking about
“how to take vector transposes seriously”. He went into the history of
the famous issue
[#4774](https://github.com/JuliaLang/julia/issues/4774), much of which
involved heated discussion on the different notions of the word
“vector”. The afternoon started out with
[Stefan](https://www.youtube.com/watch?v=qHpaztMu_Uw) speaking briefly
about the roadmap for Julia 1.0, assuring the community that 1.0 was
still on despite the latest master being called 0.7-DEV.  This was
followed up by a very interesting session on why Julia is a great
language for mathematical programming by Madeleine Udell, and focused
on the package [`Convex.jl`](https://github.com/JuliaOpt/Convex.jl),
which infers and formulates convex optimization problems. Convex and
[JuMP](https://github.com/JuliaOpt/JuMP.jl) are the two jewels on the
crest of a robust optimization
[ecosystem](https://github.com/JuliaOpt) in Julia.

The conference ended with [Jeff
Bezanson](https://www.youtube.com/watch?v=i9mfWKzEXcg) presenting a
short talk on JuliaDB, the in-memory database that was part of the
JuliaFin product from JuliaHub, and was recently open
sourced. It supports both relational and SQL-like queries and uses
[`Dagger.jl`](https://github.com/JuliaParallel/Dagger.jl) under the
hood.  After Jeff finished, the question and answer session seemed to
stretch for longer than the talk itself, indicating an unwillingness
amongst the participants for the conference to end.

While it was certainly a hectic few days with meetings upon meetings
with collaborators and plenty of information, I found that I could
look back on the week with a sense of satisfaction. Looking back, I
was pleasantly surprised as to how much the community had grown over
the years: the breadth of topics, the size of the attendance, and most
importantly, the warmth. I've a feeling this community will only get
bigger, and every JuliaCon is proof of just that.
