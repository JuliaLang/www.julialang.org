---
layout: post
title:  Asynchronous Parallel Optimization
authors:
    - <a href="http://www.mit.edu/~mlubin/">Miles Lubin</a>
---
<script type="text/javascript"
  src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

I've been invited to write this guest post in what will become a series of posts from users in the growing Julia community. We will be walking through using the parallel computing functionality of Julia to implement an asynchronous parallel version of the classical *cutting-plane* algorithm for convex (nonsmooth) optimization, demonstrating the complete workflow including running on both Amazon EC2 and a large multicore server. I will quickly review the cutting-plane algorithm and will be focusing primarily on parallel computation patterns, so don't worry if you're not familiar with the optimization side of things.

### Cutting-plane algorithm

The cutting-plane algorithm is a method for solving the optimization problem

<span>$$\text{minimize} _ \{x \in \mathbb{R}&#94;n} \sum_{i=1}&#94;n f_i(x) $$</span>

where the functions \\( f_i \\) are convex but not necessarily differentiable. The absolute value function \\( |x| \\) and the 1-norm \\( ||x|| _ 1 \\) are typical examples. Important applications also arise from <a href="http://en.wikipedia.org/wiki/Lagrangian_relaxation">Lagrangian relaxation</a>. The idea of the algorithm is to approximate the functions \\( f_i \\) with piecewise linear models \\( m_i \\) which are built up from information obtained by evaluating \\( f_i \\) at different points. We iteratively minimize over the models to generate candidate solution points.

We can state the algorithm as

1. Choose starting point \\( x \\).
2. For \\(i = 1,\ldots,n\\), evaluate \\( f_i(x) \\) and update corresponding model \\( m_i \\).
3. Let the next candidate \\( x \\) be the minimizer of \\( \sum_{i=1}&#94;n m_i(x) \\).
4. If not converged, goto step 2.

If it is costly to evaluate \\( f_i(x) \\), then the algorithm is naturally parallelizable at step 2. The minimization in step 3 can be computed by solving a linear optimization problem, which is usually very fast. (Let me point out here that Julia has interfaces to the linear programming solvers <a href="https://github.com/mlubin/Clp.jl">Clp</a>, <a href="https://github.com/lindahua/Gurobi.jl">Gurobi</a>, and <a href="https://github.com/carlobaldassi/GLPK.jl">GLPK</a>.)

Abstracting the math, we can write the algorithm using the following Julia code. 

    # functions initialize, isconverged, solvesubproblem, and process implemented elsewhere
    state, subproblems = initialize()
    while !isconverged(state)
        results = map(solvesubproblem,subproblems)
        state, subproblems = process(state, results)
    end

The function ``solvesubproblem`` corresponds to evaluating \\( f_i(x) \\) for a given \\( i \\) and \\( x \\) (the elements of ``subproblems`` could be tuples ``(i,x)``). The function ``process`` corresponds to minimizing the model in step 3, and it produces a new state and a new set of subproblems to solve. 

Note that the the algorithm looks much like a map-reduce that would be easy to parallelize using many existing frameworks. Indeed, in Julia we can simply replace ``map`` with ``pmap`` (parallel map). Let's consider a twist that makes the parallelism not so straightforward. 

### Asynchronous variant

Variability in the time taken by the ``solvesubproblem`` function can lead to load imbalance and limit parallel efficiency as workers sit idle waiting for new tasks. Such variability arises naturally if ``solvesubproblem`` itself requires solving a optimization problem, or if the workers and network are shared, as is often the case with cloud computing. 

We can consider a new variant of the cutting-plane algorithm to address this issue. The key point is

- When proportion \\(0 < \alpha \le 1 \\) of subproblems for a given candidate have been solved, generate a new candidate and corresponding set of subproblems by using whatever information is presently available.

In other words, we generate new tasks to feed to workers without needing to wait for all current tasks to complete, making the algorithm asynchronous. The algorithm remains convergent, although the total number of iterations may increase. For more details, see this <a href="http://dx.doi.org/10.1023/A:1021858008222">paper</a> by Jeff Linderoth and Stephen Wright.

By introducing asynchronicity we can no longer use a nice black-box ``pmap`` function and have to dig deeper into the parallel implementation. Fortunately, this is easy to do in Julia. 

### Parallel implementation in Julia


Julia implements distributed-memory parallelism based on one-sided message passing, where process push work onto others (via ``remote_call``) and the results are retrieved (via ``fetch``) by the process which requires them. Macros such as ``@spawn`` and ``@parallel`` provide pretty syntax around this low-level functionality.  This model of parallelism is very different from the typical SIMD style of MPI. Both approaches are useful in different contexts, and I expect an MPI wrapper for Julia will appear in the future (see also <a href="https://github.com/lcw/julia-mpi">here</a>).

Reading the <a href="http://docs.julialang.org/en/release-0.1/manual/parallel-computing/">manual</a> on parallel computing is highly recommended, and I won't try to reproduce it in this post. Instead, we'll dig into and extend one of the examples it presents. 

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
                            results[idx] = remote_call_fetch(p, f, lst[idx])
                        end
                    end
                end
            end
        end
        results
    end

On first sight, this code is not particularly intuitive. The ``@spawnlocal`` macro creates a *<a href="http://docs.julialang.org/en/latest/manual/control-flow/#man-tasks">task</a>* on the *master process* (e.g. process 1). Each task feeds work to a corresponding worker; the call ``remote_call_fetch(p, f, lst[idx])`` function calls ``f`` on process ``p`` and returns the result when finished. Tasks are uninterruptable and only surrender control at specific points such as ``remote_call_fetch``. Tasks cannot directly modify variables from the enclosing scope, but the same effect can be achieved by using the ``next_idx`` function to access and mutate ``i``. *The task idiom functions in place of using a loop to poll for results from each worker process.*

Implementing our asynchronous algorithm is not much more than a modification of the above code:
    
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
                        result = remote_call_fetch(p, solvesubproblem, mysubproblem)
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

There is little difference in the structure of the code inside the ``@sync`` blocks, and the asynchronous logic is encapsulated in the local ``updatemodel`` function which conditionally generates new subproblems. A strength of Julia is that functions like ``pmap`` are implemented in Julia itself, so that it is particularly easy to make modifications like this.

### Running it

