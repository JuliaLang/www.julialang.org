---
layout: post
title:  Distributed Numerical Optimization
authors:
    - <a href="http://www.mit.edu/~mlubin/">Miles Lubin</a>
---
<script src='https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML'>
</script>

This post walks through the parallel computing functionality of Julia
to implement an asynchronous parallel version of the classical
*cutting-plane* algorithm for convex (nonsmooth) optimization,
demonstrating the complete workflow including running on both Amazon
EC2 and a large multicore server. I will quickly review the
cutting-plane algorithm and will be focusing primarily on parallel
computation patterns, so don't worry if you're not familiar with the
optimization side of things.

### Cutting-plane algorithm

The cutting-plane algorithm is a method for solving the optimization problem

$$\min_{x \in \mathbb R^d} \sum_{i=1}^n f_i(x)$$

where the functions \\( f_i \\) are convex but not necessarily differentiable.
The absolute value function \\( |x| \\) and the 1-norm \\( ||x|| _ 1 \\) are
typical examples. Important applications also arise from <a
href="http://en.wikipedia.org/wiki/Lagrangian_relaxation">Lagrangian
relaxation</a>. The idea of the algorithm is to approximate the functions \\(
f_i \\) with piecewise linear models \\( m_i \\) which are built up from
information obtained by evaluating \\( f_i \\) at different points. We
iteratively minimize over the models to generate candidate solution points.

We can state the algorithm as

1. Choose starting point \\( x \\).
2. For \\(i = 1,\ldots,n\\), evaluate \\(
f_i(x) \\) and update corresponding model \\( m_i \\).
3. Let the next
candidate \\( x \\) be the minimizer of \\( \sum_{i=1}&#94;n m_i(x) \\).
4. If not converged, goto step 2.

If it is costly to evaluate \\( f_i(x) \\), then the algorithm is naturally
parallelizable at step 2. The minimization in step 3 can be computed by solving
a linear optimization problem, which is usually very fast. (Let me point out
here that Julia has interfaces to linear programming and other
optimization solvers under <a href="http://juliaopt.org/">JuliaOpt</a>.)

Abstracting the math, we can write the algorithm using the following Julia code.

    # functions initialize, isconverged, solvesubproblem, and process implemented elsewhere
    state, subproblems = initialize()
    while !isconverged(state)
        results = map(solvesubproblem,subproblems)
        state, subproblems = process(state, results)
    end

The function ``solvesubproblem`` corresponds to evaluating \\( f_i(x) \\) for a
given \\( i \\) and \\( x \\) (the elements of ``subproblems`` could be tuples
``(i,x)``). The function ``process`` corresponds to minimizing the model in step
3, and it produces a new state and a new set of subproblems to solve.

Note that the algorithm looks much like a map-reduce that would be easy to
parallelize using many existing frameworks. Indeed, in Julia we can simply
replace ``map`` with ``pmap`` (parallel map). Let's consider a twist that makes
the parallelism not so straightforward.

### Asynchronous variant

Variability in the time taken by the ``solvesubproblem`` function can lead to
load imbalance and limit parallel efficiency as workers sit idle waiting for new
tasks. Such variability arises naturally if ``solvesubproblem`` itself requires
solving a optimization problem, or if the workers and network are shared, as is
often the case with cloud computing.

We can consider a new variant of the cutting-plane algorithm to address this
issue. The key point is

- When proportion \\(0 < \alpha \le 1 \\) of subproblems for a given candidate
  have been solved, generate a new candidate and corresponding set of
  subproblems by using whatever information is presently available.

In other words, we generate new tasks to feed to workers without needing to wait
for all current tasks to complete, making the algorithm asynchronous. The
algorithm remains convergent, although the total number of iterations may
increase. For more details, see this <a
href="http://dx.doi.org/10.1023/A:1021858008222">paper</a> by Jeff Linderoth and
Stephen Wright.

By introducing asynchronicity we can no longer use a nice black-box ``pmap``
function and have to dig deeper into the parallel implementation. Fortunately,
this is easy to do in Julia.

### Parallel implementation in Julia


Julia implements distributed-memory parallelism based on one-sided message
passing, where process push work onto others (via ``remotecall``) and the
results are retrieved (via ``fetch``) by the process which requires them. Macros
such as ``@spawn`` and ``@parallel`` provide pretty syntax around this low-level
functionality.  This model of parallelism is very different from the typical
SIMD style of MPI. Both approaches are useful in different contexts, and I
expect an MPI wrapper for Julia will appear in the future (see also <a
href="https://github.com/lcw/julia-mpi">here</a>).

Reading the <a
href="http://docs.julialang.org/en/release-0.1/manual/parallel-computing/">manual</a>
on parallel computing is highly recommended, and I won't try to reproduce it in
this post. Instead, we'll dig into and extend one of the examples it presents.

The implementation of ``pmap`` in Julia is

    function pmap(f, lst)
        np = nprocs()  # determine the number of processors available
        n = length(lst)
        results = cell(n)
        i = 1
        # function to produce the next work item from the queue.
        # in this case it's just an index.
        next_idx() = (idx=i; i+=1; idx)
        @sync begin
            for p=1:np
                if p != myid() || np == 1
                    @spawnlocal begin
                        while true
                            idx = next_idx()
                            if idx > n
                                break
                            end
                            results[idx] = remotecall_fetch(p, f, lst[idx])
                        end
                    end
                end
            end
        end
        results
    end

On first sight, this code is not particularly intuitive. The ``@spawnlocal``
macro creates a *<a
href="http://docs.julialang.org/en/latest/manual/control-flow/#man-tasks">task</a>*
on the *master process* (e.g. process 1). Each task feeds work to a
corresponding worker; the call ``remotecall_fetch(p, f, lst[idx])`` function
calls ``f`` on process ``p`` and returns the result when finished. Tasks are
uninterruptable and only surrender control at specific points such as
``remotecall_fetch``. Tasks cannot directly modify variables from the enclosing
scope, but the same effect can be achieved by using the ``next_idx`` function to
access and mutate ``i``. *The task idiom functions in place of using a loop to
poll for results from each worker process.*

Implementing our asynchronous algorithm is not much more than a modification of
the above code:

    # given constants n and 0 < alpha <= 1
    # functions initialize and solvesubproblem defined elsewhere
    np = nprocs()
    state, subproblems = initialize()
    converged = false
    isconverged() = converged
    function updatemodel(mysubproblem, result)
        # store result
        ...
        # decide whether to generate new subproblems
        state.numback[mysubproblem.parent] += 1
        if state.numback[mysubproblem.parent] >= alpha*n && !state.didtrigger[mysubproblem.parent]
            state.didtrigger[mysubproblem.parent] = true
            # generate newsubproblems by solving linear optimization problem
            ...
            if ... # convergence test
                converged = true
            else
                append!(subproblems, newsubproblems)
                push!(state.didtrigger, false)
                push!(state.numback, 0)
                # ensure that for s in newsubproblems, s.parent == length(state.numback)
            end
        end
    end

    @sync begin
        for p=1:np
            if p != myid() || np == 1
                @spawnlocal begin
                    while !isconverged()
                        if length(subproblems) == 0
                            # no more subproblems but haven't converged yet
                            yield()
                            continue
                        end
                        mysubproblem = shift!(subproblems) # pop subproblem from queue
                        result = remotecall_fetch(p, solvesubproblem, mysubproblem)
                        updatemodel(mysubproblem, result)
                    end
                end
            end
        end
    end

where ``state`` is an instance of a type defined as

    type State
        didtrigger::Vector{Bool}
        numback::Vector{Int}
        ...
    end

There is little difference in the structure of the code inside the ``@sync``
blocks, and the asynchronous logic is encapsulated in the local ``updatemodel``
function which conditionally generates new subproblems. A strength of Julia is
that functions like ``pmap`` are implemented in Julia itself, so that it is
particularly straightforward to make modifications like this.

### Running it

Now for the fun part. The complete cutting-plane algorithm (along with
additional variants) is implemented in <a
href="https://github.com/mlubin/JuliaBenders">JuliaBenders</a>. The code is
specialized for <a
href="http://en.wikipedia.org/wiki/Stochastic_programming">stochastic
programming</a> where the cutting-plane algorithm is known as the <a
href="http://www.springerreference.com/docs/html/chapterdbid/72429.html">L-shaped
method</a> or Benders decomposition and is used to decompose the solution of
large linear optimization problems. Here, ``solvesubproblem`` entails solving a
relatively small linear optimization problem. Test instances are taken from the
previously mentioned <a
href="http://dx.doi.org/10.1023/A:1021858008222">paper</a>.

We'll first run on a large multicore server. The
``runals.jl`` (asynchronous L-shaped) file contains the algorithm we'll use. Its
usage is

	julia runals.jl [data source] [num subproblems] [async param] [block size]

where ``[num subproblems]`` is the \\(n\\) as above and ``[async param]`` is
the proportion \\(\alpha\\). By setting \\(\alpha = 1\\) we obtain the
synchronous algorithm. For the asynchronous version we will take \\(\alpha =
0.6\\). The ``[block size]`` parameter controls how many subproblems are sent to
a worker at once (in the previous code, this value was always 1). We will use
4000 subproblems in our experiments.

To run multiple Julia processes on a shared-memory machine, we pass the ``-p N``
option to the ``julia`` executable, which will start up ``N`` system processes.
To execute the asynchronous version with 10 workers, we run

    julia -p 12 runals.jl Data/storm 4000 0.6 30

Note that we start 12 processes. These are the 10 workers, the master (which
distributes tasks), and another process to perform the master's computations (an
additional refinement which was not described above). Results from various runs
are presented in the table below.

<table style="text-align:right;margin-left:auto;margin-right:auto" cellspacing="5">
<tr style="text-align:center">
	<td> </td>
	<td colspan="2" style="border-bottom-style:solid;border-bottom-width:2px">Synchronous</td>
	<td colspan="2" style="border-bottom-style:solid;border-bottom-width:2px">Asynchronous</td>
</tr>
<tr style="text-align:center">
	<td style="border-bottom-style:solid;border-bottom-width:2px">No. Workers</td>
	<td style="border-bottom-style:solid;border-bottom-width:2px">Speed</td>
	<td style="border-bottom-style:solid;border-bottom-width:2px">Efficiency
	<td style="border-bottom-style:solid;border-bottom-width:2px">Speed</td>
	<td style="border-bottom-style:solid;border-bottom-width:2px">Efficiency
</td></td></tr>
<tr>
	<td style="text-align:center">10</td>
	<td>154</td>
	<td>Baseline</td>
	<td>166</td>
	<td>Baseline</td>
</tr>
<tr>
	<td style="text-align:center">20</td>
	<td>309</td>
	<td>100.3%</td>
	<td>348</td>
	<td>105%</td>
</tr>
<tr>
	<td style="text-align:center">40</td>
	<td>517</td>
	<td>84%</td>
	<td>654</td>
	<td>98%</td>
</tr>
<tr>
	<td style="text-align:center">60</td>
	<td>674</td>
	<td>73%</td>
	<td>918</td>
	<td>92%</td>
</tr>
</table>

<p class="caption" style="text-align:center"><b>Table:</b>
Results on a shared-memory 8x Xeon E7-8850 server. Workers correspond to
individual cores. Speed is the rate of subproblems solved per second. Efficiency
is calculated as the percent of ideal parallel speedup obtained. The superlinear
scaling observed with 20 workers is likely a system artifact.
</p>

There are a few more hoops to jump through in order to run on EC2. First we must
build a system image (AMI) with Julia installed. Julia connects to workers over
ssh, so I found it useful to put my EC2 ssh key on the AMI and also set
``StrictHostKeyChecking no`` in ``/etc/ssh/ssh_config`` to disable the
authenticity prompt when connecting to new workers. Someone will likely correct
me on if this is the right approach.

Assuming we have an AMI in place, we can fire up the instances. I used an
m3.xlarge instance for the master and m1.medium instances for the workers.
(Note: you can save a lot of money by using the spot market.)

To add remote workers on startup, Julia accepts a file with a list of host names
through the ``--machinefile`` option. We can generate this easily enough by
using the EC2 API Tools (Ubuntu package ``ec2-api-tools``) with the command

    ec2-describe-instances | grep running | awk '{ print $5; }' > mfile

On the master instance we can then run

    julia --machinefile mfile runatr.jl Data/storm 4000 0.6 30

Results from various runs are presented in the table below.

<table style="text-align:right;margin-left:auto;margin-right:auto" cellspacing="5">
<tr style="text-align:center">
	<td> </td>
	<td colspan="2" style="border-bottom-style:solid;border-bottom-width:2px">Synchronous</td>
	<td colspan="2" style="border-bottom-style:solid;border-bottom-width:2px">Asynchronous</td>
</tr>
<tr style="text-align:center">
	<td style="border-bottom-style:solid;border-bottom-width:2px">No. Workers</td>
	<td style="border-bottom-style:solid;border-bottom-width:2px">Speed</td>
	<td style="border-bottom-style:solid;border-bottom-width:2px">Efficiency
	<td style="border-bottom-style:solid;border-bottom-width:2px">Speed</td>
	<td style="border-bottom-style:solid;border-bottom-width:2px">Efficiency
</td></td></tr>
<tr>
	<td style="text-align:center">10</td>
	<td>149</td>
	<td>Baseline</td>
	<td>151</td>
	<td>Baseline</td>
</tr>
<tr>
	<td style="text-align:center">20</td>
	<td>289</td>
	<td>97%</td>
	<td>301</td>
	<td>99.7%</td>
</tr>
<tr>
	<td style="text-align:center">40</td>
	<td>532</td>
	<td>89%</td>
	<td>602</td>
	<td>99.5%</td>
</tr>
</table>

<p class="caption" style="text-align:center"><b>Table:</b>
Results on Amazon EC2. Workers correspond to individual m1.medium instances. The
master process is run on an m3.xlarge instance.
</p>

On both architectures the asynchronous version solves subproblems at a higher
rate and has significantly better parallel efficiency. Scaling is better on EC2
than on the shared-memory server likely because the subproblem calculation is
memory bound, and so performance is better on the distributed-memory
architecture. Anyway, with Julia we can easily experiment on both.

### Further reading

A more detailed <a
href="https://github.com/JuliaLang/julia-tutorial/blob/master/NumericalOptimization/tutorial.pdf?raw=true">tutorial</a>
was prepared for the Julia <a href="https://github.com/JuliaLang/julia-tutorial">IAP session</a> at MIT in January 2013.

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Distributed Numerical Optimization</span> by <span xmlns:cc="http://creativecommons.org/ns#" property="cc:attributionName">Miles Lubin</span> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
