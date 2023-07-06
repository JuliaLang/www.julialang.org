+++
mintoclevel = 2
maxtoclevel = 3
title = "PSA: Thread-local state is no longer recommended"
authors = "Mason Protter, Valentin Churavy, Ian Butterworth, ..."
published = "30 June 2023"
rss_pubdate = Date(2023, 06, 30)
rss = """PSA: Thread-local state is no longer recommended; Common misconceptions about threadid() and nthreads()"""
+++


*Common misconceptions about threadid() and nthreads()*

\toc



## The buggy pattern

Partially due to the evolving history of our parallel and concurrent interfaces[^historynote], some Julia programmers have been writing *incorrect* parallel code that contains the possibility of race conditions which can give wrong results. This pattern has even been erroneously recommended in [previous official julia blogposts](https://github.com/JuliaLang/www.julialang.org/blob/main/blog/2019/07/multithreading.md#thread-local-state). It is important for the stability and correctness of the ecosystem that these usages are identified and fixed.

The general template that this incorrect code follows is something like the following:

```julia
using Base.Threads: nthreads, @threads, threadid

states = [some_initial_value for _ in 1:nthreads()]
@threads for x in some_data
    tid = threadid()                       
    old_val = states[tid]
    new_val = some_operator(old_val, f(x))
    states[tid] = new_val
end
do_something(states)
```

The above code is **incorrect** because the tasks spawned by `@threads` are  allowed to yield to other tasks during their execution[^yielding]. This means that between reading `old_val` and storing `new_val` in the storage, the task could be paused and a new task running on the same thread with the same `threadid()` could concurrently write to `states[tid]`, causing a race condition and thus work being lost.

This is not actually a problem with multithreading specifically, but really a concurrency problem, and it can be demonstrated even with a single thread. For example:

```
$ julia --threads=1
```

```julia
julia> f(i) = (sleep(0.001); i);

julia> let state = [0], N=100
           @sync for i ∈ 1:N
               Threads.@spawn begin
                   tid = Threads.threadid()  # Each task gets `tid = 1`.
                   old_var = state[tid]      # Each task reads the current value, which for 
                                             # all is 0 (!) because...
                   new_var = old_var + f(i)  # ...the `sleep` in `f` causes all tasks to pause 
                                             # *simultaneously* here (all loop iterations start, 
                                             # but do not yet finish).
                   state[tid] = new_var      # After being released from the `sleep`, each task 
                                             # sets `state[1]` to `i`.
               end
           end
           sum(state), sum(1:N)
       end
(100, 5050)
```

In the above snippet, we purposefully over-subscribed the CPU with `100` separate tasks in order to make the bug more likely to manifest, but the problem **can** arise even without spawning very many tasks.

Any usage of `threadid()` in package or user code should be seen as a warning sign that the code is relying on implementation details, and is open to concurrency bugs.

## Fixing buggy code which uses this pattern

### Quickfix: Replace `@threads` with `@threads :static`

The simplest (though not recommended longterm) quickfix if you happen to use `@threads` is to replace usages of `@threads for ...` with `@threads :static for ...`. The reason for this is that the `:static` scheduler for `@threads` does not allow the asynchronous task migration and yielding that causes the bug in the first place.

However, this is not a good long term solution because
1) It's relying on guard rails to prevent otherwise incorrect code to be correct
2) `@threads :static` is not cooperative or composable, that means that if code inside your `@threads :static` loop also does multithreading, your code could be reduced to worse than single-threaded speeds, or even deadlock.

### Better fix: Work directly with tasks

If you want a recipe that can replace the above buggy one with something that can be written using only the `Base.Threads` module, we recommend moving away from `@threads`, and instead working directly with `@spawn` to create and manage tasks. The reason is that `@threads` does not have any builtin mechanisms for managing and merging the results of work from different threads, whereas tasks can manage and return their own state in a safe way.

Tasks creating and returning their own state is inherently safer than the spawner of parallel tasks setting up state for spawned tasks to read from and write to.

Code which replaces the incorrect code pattern shown above can look like this:

```julia
using Base.Threads: nthreads, @threads, @spawn
using Base.Iterators: partition

tasks_per_thread = 2 # customize this as needed. More tasks have more overhead, but better load balancing

chunk_size = max(1, length(some_data) ÷ (tasks_per_thread * nthreads()))
data_chunks = partition(some_data, chunk_size) # partition your data into chunks that individual tasks will deal with
# See also ChunkSplitters.jl and SplittablesBase.jl for partitioning data

tasks = map(data_chunks) do chunk
    # Each chunk of your data gets its own spawned task that does its own local, sequential work
    # and then returns the result
    @spawn begin
        state = some_initial_value
        for x in chunk
            state = some_operator(state, f(x))
        end
        return state
    end
end
states = fetch.(tasks) # get all the values returned by the individual tasks.
# fetch is type unstable, so you may optionally want to assert a specific return type.

do_something(states)
```

This is a fully general replacement for the old, buggy pattern. However, for many applications this should be simplified down to a parallel version of `mapreduce`:

```julia
using Threads: nthreads, @spawn
function tmapreduce(f, op, itr; chunks_per_thread::Int = 2, kwargs...)
    chunk_size = max(1, length(itr) ÷ chunks_per_thread)
    tasks = map(Iterators.partition(itr, chunk_size)) do chunk
        @spawn mapreduce(f, op, chunk; kwargs...)
    end
    mapreduce(fetch, op, tasks; kwargs...)
end
```

In `tmapreduce(f, op, itr)`, the function `f` is applied to each element of `itr`, and then an *associative*[^assoc] two-argument function `op`.

The above `tmapreduce` can hopefully be added to base Julia at some point in the near future. In the meantime however it's somewhat simple to write your own as above.

### Another option: Use a package which handles this correctly

We encourage people to check out various multithreading libraries like [Transducers.jl](https://github.com/JuliaFolds2/Transducers.jl) (or various frontends like [ThreadsX.jl](https://github.com/tkf/ThreadsX.jl), [FLoops.jl](https://github.com/JuliaFolds/FLoops.jl), and [Folds.jl](https://github.com/JuliaFolds/Folds.jl)),  and [MultiThreadedCaches.jl](https://github.com/JuliaConcurrent/MultiThreadedCaches.jl).

#### Transducers.jl ecosystem
Transducers.jl is fundamentally about expressing the traversing of data in a structured and principled way, often with the benefit that it makes parallel computing easier to reason about.

The above `tmapreduce(f, op, itr)` could be expressed as

```julia
using Transducers
itr |> Map(f) |> foldxt(op; init=some_initial_value)
```

or

```julia
using Transducers
foldxt(op, Map(f), itr; init=some_initial_value)
```

The various frontends listed provide different APIs for Transducers.jl which some people may find easier to use. E.g.

```julia
using ThreadsX
ThreasdX.mapreduce(f, op, itr; init=some_initial_value)
```

or

```julia
using FLoops
@floop for x in itr
    @reduce out = op(some_initial_value, f(x))
end
out
```

#### MultiThreadedCaches.jl

MultiThreadedCaches.jl on the other hand attempts to make the `states[threadid()]`-like pattern safer by using lock mechanisms to stop data races. We think this is not an ideal way to proceed, but it may make transitioning to safer code easier and require fewer rewrites, such as in cases where a package must manage state which may be concurrently written to by a user, and the package cannot control how the user structures their code.

~~~
<style>
.fndef {
    width: 100%;
    margin-bottom: 0;
    border: none;
}
.fndef-backref {
    width: 2em;
}
.long-footnote {
    width: 100%;
    background-color: var(--light);
    padding: 0.75rem;
}
</style>
~~~

[^historynote]: ~~~<h4>~~~Concurrency & Parallelism~~~</h4>~~~
@@long-footnote
   In Julia, tasks are the primitive mechanism to express concurrency. Concurrency is the ability to execute more than one program or task simultaneously.

   Tasks will be mapped onto any number of "worker-threads" that will lead them to be executed in parallel. This is often called `M:N` threading or green threads. Even if Julia is started with only one worker-thread, the programmer can express concurrent operations.

   In early versions of Julia, the `@async` macro was used to schedule concurrent tasks which were executed asynchronously on a single thread. Later, the `@threads` macro was developed for CPU-parallelism and allowed users to easily execute chunks of a loop in parallel, but at the time this was disjoint from the notions of tasks in the language. This lead to various composability problems and motivated language changes.

   The concurrency model in Julia has been evolving over minor versions. Julia v1.3 introduced the parallel scheduler for tasks and `Threads.@spawn`; v1.5 introduced `@threads :static` with the intention to change the default scheduling in future releases. Julia v1.7 enabled task migration, and Julia v1.8 changed the default for `@threads` to the dynamic scheduler.

   When the parallel scheduler was introduced, we decided that there was too much code in the wild using `@async` and expecting specific semantics, so `Threads.@spawn` was made available to access the new semantics. `@async` has various problems and we discourage its use for new code.

    ~~~<h4>~~~
   Uses of `threadid`/`nthreads`/`maxthreadid`
   ~~~</h4>~~~

   Over time, several features have been added that make relying on `threadid`, `nthreads` and even `maxthreadid` perilous:

   1. Task migration: A task can observe multiple `threadid`s during its execution.
   2. Interactive priority: `nthreads()` will report the number of non-interactive worker-threads, thus undercounting the number of active threads.
   3. Thread adoption (v1.9): Foreign threads can now be adopted (and later be removed) at any time during the execution of the program.
   4. GC threads: The runtime can use additional threads to accelerate work like executing the Garbage Collector.

   Any code that relies on a specific `threadid` staying constant, or on a constant number of threads during execution, is bound to be incorrect. As a rule of thumb, programmers should at most be querying the number of threads to motivate heuristics like how to distribute parallel work, but programs should generally **not** be written to depend on implementation details of threads for correctness. Rather, programmers should reason about *tasks*, i.e. pieces of work that may execute concurrently with other code, independently of the number of *threads* that are used for executing them.
@@

\\

[^yielding]: ~~~<h4>~~~Don't try to reason about yielding~~~</h4>~~~
@@long-footnote
   Many existing uses of thread local state happen to be relatively robust and give correct answers only because the functions they are calling during execution do not yield. One may then think "well, I can just avoid this problem by making sure my code doesn't yield", but we think this is a bad and unsustainable idea, because whether or not a function call will yield is not stable, obvious, or easily inspectable.

   For instance, if a function `f` is updated to include a background `@debug` statement or other forms of non-user-visible IO, it may change from being non-yielding to yielding. If during a call to `f`, the compiler encounters a dynamic dispatch where new code must be JIT compiled, a yield-point may be encountered, and any number of other internal changes could happen to code which can cause it to yielding.

   Furthermore, future versions of julia may eventually move away from a [cooperative task model](https://en.wikipedia.org/wiki/Cooperative_multitasking) to a [preemptive task model](https://en.wikipedia.org/wiki/Preemption_(computing)), in which case yield points would not be the only way that race conditions like this could be encountered.
@@

\\

[^assoc]: ~~~<h4>~~~Associativity~~~</h4>~~~
@@long-footnote
   [Associativity](https://en.wikipedia.org/wiki/Associative_property) is an important property for parallel reducing functions, because it means that `op(a, op(b, c)) == op(op(a, b), c)`, and hence the result does not depend on the order in which the reduction is performed.

   Note that associativity is not the same as commutivity, which is the property that `op(a, b) == op(b, a)`. This is *not* required for parallel reducing functions.
@@
