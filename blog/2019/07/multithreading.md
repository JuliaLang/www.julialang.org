@def rss_pubdate = Date(2019, 7, 23)
@def rss = """ Announcing composable multi-threaded parallelism in Julia | Software performance depends more and more on exploiting multiple processor cores.... """
@def published = "23 July 2019"
@def title = "Announcing composable multi-threaded parallelism in Julia"
@def authors = "Jeff Bezanson (Julia Computing), Jameson Nash (Julia Computing), Kiran Pamnany (Intel)"  
@def hascode = true
@def mintoclevel = 2

Software performance depends more and more on exploiting multiple processor cores.
The [free lunch][] from Moore's Law is still over.
Well, we here in the Julia developer community have something of a reputation for caring about performance.
In pursuit of it, we have already built a lot of functionality for multi-process, distributed and GPUs, but we've known for years that we would also need a good story for composable multi-threading.
Today we are happy to announce a major new chapter in that story.
We are releasing a preview of an entirely new threading interface for Julia programs: general task parallelism, inspired by parallel programming systems
like [Cilk][], [Intel Threading Building Blocks][] (TBB) and [Go][].
Task parallelism is now available in the v1.3.0-alpha release, an early preview
of Julia version 1.3.0 likely to be released in a couple months.
You can find binaries with this feature on the [downloads page][], or build
the [master branch][] from source.

In this paradigm, any piece of a program can be marked for execution in parallel, and a "task" will be started to run that code automatically on an available thread.
A dynamic scheduler handles all the decisions and details for you.
Here's an example of parallel code you can now write in Julia:

```julia
import Base.Threads.@spawn

function fib(n::Int)
    if n < 2
        return n
    end
    t = @spawn fib(n - 2)
    return fib(n - 1) + fetch(t)
end
```

This, of course, is the classic highly-inefficient tree recursive implementation of the Fibonacci sequence — but running on any number of processor cores!
The line `t = @spawn fib(n - 2)` starts a task to compute `fib(n - 2)`, which runs in parallel with the following line computing `fib(n - 1)`.
`fetch(t)` waits for task `t` to complete and gets its return value.

This model of parallelism has many wonderful properties.
We see it as somewhat analogous to garbage collection: with GC, you freely allocate objects without worrying about when and how they are freed.
With task parallelism, you freely spawn tasks — potentially millions of them — without worrying about where they run.

The model is portable and free from low-level details.
You don't need to explicitly start and stop threads, and you don't even need to know how many processors or threads there are (though you can find out if you want).

The model is nestable and composable: you can start parallel tasks that call library functions that themselves start parallel tasks, and everything works.
Your CPUs will not be over-subscribed with threads.
This property is crucial for a high-level language where a lot of work is done by library functions.
You need to be free to write whatever code you need — including parallel code —
without worrying about how the libraries it calls are implemented (currently only for Julia code, but in the future we plan to extend this to native libraries such as BLAS).

This is, in fact, the main reason we are excited about this announcement: from this point on, the capability of adding multi-core parallelism is unleashed over the entire Julia package ecosystem.

\toc

## Some history

One of the most surprising aspects of this new feature is just how long it has been in the works.
From the very beginning — prior even to the 0.1 release — Julia has had the `Task` type providing symmetric coroutines, which we've used for event-based I/O.
So we have always had a unit of *concurrency* (independent streams of execution) in the language, it just wasn't *parallel* (simultaneous streams of execution) yet.
We knew we needed thread-based parallelism though, so in 2014 (roughly the version 0.3 timeframe) we set about the long process of making our code thread-safe.
Yichao Yu put in some particularly impressive work on the garbage collector and thread-local-storage performance.
One of the authors (Kiran) designed some basic infrastructure for scheduling multiple threads and managing atomic datastructures.

In version 0.5 about two years later, we released the `@threads for` macro with "experimental" status which could handle simple parallel loops running on all cores.
Even though that wasn't the final design we wanted, it did two important jobs:
it let Julia programmers start taking advantage of multiple cores, and provided
test cases to shake out thread-related bugs in our runtime.
That initial `@threads` had some huge limitations, however: `@threads` loops could not be nested: if the functions they called used `@threads` recursively, those inner loops would only occupy the CPU that called them.
It was also incompatible with our `Task` and I/O system: you couldn't do any I/O or switch among `Task`s inside a threaded loop.

So the next logical step was to merge the `Task` and threading systems, and "simply" (cue laughter) allow `Task`s to run simultaneously on a pool of threads.
We had many early discussions with Arch Robison (then of Intel) and concluded
that this was the best model for our language.
After version 0.5 (around 2016), Kiran started experimenting with a new parallel
task scheduler [partr][] based on the idea of depth-first scheduling.
He sold all of us on it with some nice animated slides, and it also didn't hurt that he was willing to do some of the work.
The plan was to first develop partr as a standalone C library so it could be tested and benchmarked on its own and then integrate it with the Julia runtime.

After Kiran completed the standalone version of partr, a few of us (the authors of this post, as well as Keno Fischer and Intel's Anton Malakhov) embarked on a series of face-to-face work sessions to figure out how to do the integration.
The Julia runtime brings many extra features, such as garbage collection and
event-based I/O, so this was not entirely straightforward.
Somewhat disappointingly, though not unusually for a complex software project,
it took much longer than expected — nearly two years — to get the new
system working reliably.
A later section of this post will explain some of the internals and difficulties
involved for the curious.
But first, let's take it for a spin.

## How to use it

To use Julia with multiple threads, set the `JULIA_NUM_THREADS` environment
variable:

```bash
$ JULIA_NUM_THREADS=4 ./julia
```

The [Juno IDE][] automatically sets the number of threads based on the number of
available processor cores, and also provides a graphical interface for changing
the number of threads, so setting the variable manually is not necessary
in that environment.

The `Threads` submodule of `Base` houses most of the thread-specific functionality, such as querying the number of threads and the ID of the current thread:

```julia-repl
julia> Threads.nthreads()
4

julia> Threads.threadid()
1
```

Existing `@threads for` uses will still work, and now I/O is fully supported:

```julia-repl
julia> Threads.@threads for i = 1:10
           println("i = $i on thread $(Threads.threadid())")
       end
i = 1 on thread 1
i = 7 on thread 3
i = 2 on thread 1
i = 8 on thread 3
i = 3 on thread 1
i = 9 on thread 4
i = 10 on thread 4
i = 4 on thread 2
i = 5 on thread 2
i = 6 on thread 2
```

Without further ado, let's try some nested parallelism.
A perennial favorite example is mergesort, which divides its input in half
and recursively sorts each half.
The halves can be sorted independently, yielding a natural opportunity
for parallelism.
Here is that code:

```julia
import Base.Threads.@spawn

# sort the elements of `v` in place, from indices `lo` to `hi` inclusive
function psort!(v, lo::Int=1, hi::Int=length(v))
    if lo >= hi                       # 1 or 0 elements; nothing to do
        return v
    end
    if hi - lo < 100000               # below some cutoff, run in serial
        sort!(view(v, lo:hi), alg = MergeSort)
        return v
    end

    mid = (lo+hi)>>>1                 # find the midpoint

    half = @spawn psort!(v, lo, mid)  # task to sort the lower half; will run
    psort!(v, mid+1, hi)              # in parallel with the current call sorting
                                      # the upper half
    wait(half)                        # wait for the lower half to finish

    temp = v[lo:mid]                  # workspace for merging

    i, k, j = 1, lo, mid+1            # merge the two sorted sub-arrays
    @inbounds while k < j <= hi
        if v[j] < temp[i]
            v[k] = v[j]
            j += 1
        else
            v[k] = temp[i]
            i += 1
        end
        k += 1
    end
    @inbounds while k < j
        v[k] = temp[i]
        k += 1
        i += 1
    end

    return v
end
```

This is just a standard mergesort implementation, similar to the one in Julia's
`Base` library, with only the tiny addition of the `@spawn` construct on one
of the recursive calls.
Julia's `Distributed` standard library has also exported a `@spawn` macro for
quite a while, but we plan to discontinue it in favor of the new threaded
meaning (though it will still be available in 1.x versions, for backwards
compatibility).
This way of expressing parallelism is much more useful in shared memory,
and "spawn" is a pretty standard term in task parallel APIs (used in Cilk
as well as [TBB][], for example).

`wait` simply waits for the specified task to finish.
The code works by modifying its input, so we don't need the task's return value.
Indicating that a return value is not needed is the only difference with the
`fetch` call used in the earlier `fib` example.
Note that we explicitly request `MergeSort` when calling Julia's standard `sort!`, to make sure we're comparing apples to apples — `sort!` actually uses
quicksort by default for sorting numbers, which tends to be faster for random data.
Let's time the code under `JULIA_NUM_THREADS=2`:

```julia-repl
julia> a = rand(20000000);

julia> b = copy(a); @time sort!(b, alg = MergeSort);   # single-threaded
  2.589243 seconds (11 allocations: 76.294 MiB, 0.17% gc time)

julia> b = copy(a); @time sort!(b, alg = MergeSort);
  2.582697 seconds (11 allocations: 76.294 MiB, 2.25% gc time)

julia> b = copy(a); @time psort!(b);    # two threads
  1.770902 seconds (3.78 k allocations: 686.935 MiB, 4.25% gc time)

julia> b = copy(a); @time psort!(b);
  1.741141 seconds (3.78 k allocations: 686.935 MiB, 4.16% gc time)
```

While the run times are bit variable, we see a definite speedup from using
two threads.
The laptop we ran this on has four hyperthreads, and it is especially amazing
that performance continues to improve if we add a third thread:

```julia-repl
julia> b = copy(a); @time psort!(b);
  1.511860 seconds (3.77 k allocations: 686.935 MiB, 6.45% gc time)
```

Thinking about this two-way decomposition algorithm running on three threads
can make your head hurt a little!
In our view, this helps underscore how "automatic" this interface makes
parallelism feel.

Let's try a different machine with slightly lower single thread performance,
but more CPU cores:

```bash
$ for n in 1 2 4 8 16; do    JULIA_NUM_THREADS=$n ./julia psort.jl; done
  2.949212 seconds (3.58 k allocations: 686.932 MiB, 4.70% gc time)
  1.861985 seconds (3.77 k allocations: 686.935 MiB, 9.32% gc time)
  1.112285 seconds (3.78 k allocations: 686.935 MiB, 4.45% gc time)
  0.787816 seconds (3.80 k allocations: 686.935 MiB, 2.08% gc time)
  0.655762 seconds (3.79 k allocations: 686.935 MiB, 4.62% gc time)
```

The `psort.jl` script simply defines the `psort!` function, calls it once
to avoid measuring compilation overhead, and then runs the same commands
we used above.

Notice that this speedup occurs despite the parallel code allocating
*drastically* more memory than the standard routine.
The allocations come from two sources: `Task` objects, and the `temp`
arrays allocated on each call.
The reference sorting routine re-uses a single temporary buffer among
all recursive calls.
Re-using the temporary array is more difficult with parallelism, but
still possible — more on that a little later.

## How to move to a parallel world

During the 1.3 series the new thread runtime is considered to be in beta testing.
An "official" version will appear in a later release, to give us time to settle
on an API we can commit to for the long term.
Here's what you need to know if you want to upgrade your code over this period.

### Task scheduling and synchronization

To aid compatibility, code will continue to run within a single thread by default.
When tasks are launched using existing primitives (`schedule`, `@async`), they
will run only within the thread that launches them.
Similarly, a `Condition` object (used to signal tasks when events occur) can only
be used by the thread that created it.
Attempts to wait for or notify conditions from other threads will raise errors.
Separate thread-safe condition variables have been added, and are available as
`Threads.Condition`.
This needs to be a separate type because thread-safe use of condition variables
requires acquiring a lock.
In Julia, the lock is bundled with the condition, so `lock` can simply be called
on the condition itself:

```julia
lock(cond::Threads.Condition)
try
    while !ready
        wait(cond)
    end
finally
    unlock(cond)
end
```

As in previous versions, the standard lock to use to protect critical sections
is `ReentrantLock`, which is now thread-safe (it was previously only used for
synchronizing tasks).
There are some other types of locks (`Threads.SpinLock` and `Threads.Mutex`) defined
mostly for internal purposes.
These are used in rare circumstances where (1) only threads and not tasks will be
synchronized, and (2) you know the the lock will only be held for a short time.

The `Threads` module also provides `Semaphore` and `Event` types, which have their
standard definitions.

### Thread-local state

!!! warning
    As of Julia 1.8 this pattern is no longer recommended. Please read this [follow up blogpost](/2023/07/PSA-dont-use-threadid)
    for more details and how to migrate away from this pattern.

Julia code naturally tends to be purely functional (no side effects or mutation),
or to use only local mutation, so migrating to full thread-safety will hopefully
be easy in many cases.
But if your code uses shared state and you'd like to make it thread-safe, there
is some work to do.
So far we have used two kinds of approaches to this in Julia's standard library:
synchronization (locks), and thread- or task-local state.
Locks work well for shared resources not accessed frequently, or for resources
that cannot be duplicated for each thread.

But for high-performance code we recommend thread-local state.
Our `psort!` routine above can be improved in this way.
Here is a recipe.
First, we modify the function signature to accept pre-allocated buffers, using a default
argument value to allocate space automatically when the caller doesn't provide it:

```julia
function psort!(v, lo::Int=1, hi::Int=length(v), temps=[similar(v, 0) for i = 1:Threads.nthreads()])
```

We simply need to allocate one initially-empty array per thread.
Next, we modify the recursive calls to reuse the space:

```julia
    half = @spawn psort!(v, lo, mid, temps)
    psort!(v, mid+1, hi, temps)
```

Finally, use the array reserved for the current thread, instead of allocating a new one,
and resize it as needed:

```julia
    temp = temps[Threads.threadid()]
    length(temp) < mid-lo+1 && resize!(temp, mid-lo+1)
    copyto!(temp, 1, v, lo, mid-lo+1)
```

After these minor modifications, let's check performance on our large
machine:

```bash
$ for n in 1 2 4 8 16; do    JULIA_NUM_THREADS=$n ./julia psort.jl; done
  2.813555 seconds (3.08 k allocations: 153.448 MiB, 1.44% gc time)
  1.731088 seconds (3.28 k allocations: 192.195 MiB, 0.37% gc time)
  1.028344 seconds (3.30 k allocations: 221.997 MiB, 0.37% gc time)
  0.750888 seconds (3.31 k allocations: 267.298 MiB, 0.54% gc time)
  0.620054 seconds (3.38 k allocations: 298.295 MiB, 0.77% gc time)
```

### Random number generation

The approach we've taken with Julia's default global random number generator (`rand()` and friends)
is to make it thread-specific.
On first use, each thread will create an independent instance of the default RNG type
(currently `MersenneTwister`) seeded from system entropy.
All operations that affect the random number state (`rand`, `randn`, `seed!`, etc.) will then operate
on only the current thread's RNG state.
This way, multiple independent code sequences that seed and then use random numbers will individually
work as expected.

If you need all threads to use a known initial seed, you will need to set it up explicitly.
For that kind of more precise control, or better performance, we recommend allocating and passing your
own RNG objects (e.g. `Random.MersenneTwister()`).

## Under the hood

As with garbage collection, the simple interface (`@spawn`) belies great
complexity underneath.
Here we will try to summarize some of the main difficulties and design
decisions we faced.

### Allocating and switching task stacks

Each `Task` requires its own execution stack, distinct from the usual process or
thread stacks provided by Unix operating systems.
Windows has fibers, which correspond closely to tasks, and several library
implementations of similar abstractions exist for Unix-family systems.

There are many possible approaches to this, with different tradeoffs.
As we often do, we tried to pick a method that would maximize throughput
and reliability.
We have a shared pool of stacks allocated by `mmap` (`VirtualAlloc` on
Windows), defaulting to 4MiB each (2MiB on 32-bit systems).
This can use quite a bit of virtual memory, so don't be alarmed if `top`
shows your shiny new multi-threaded Julia code using 100GiB of address
space.
The vast majority of this space will not consume real resources, and is only
there in case a task needs to execute a deep call chain (which will hopefully
not persist for long).
These are larger stacks than task systems in lower-level languages would
probably provide, but we feel it makes good use of the CPU and OS kernel's
highly refined memory management capabilities, while greatly reducing the
possibility of stack overflow.

The default stack size is a build-time option, set in `src/options.h`.
The `Task` constructor also has an undocumented second argument allowing
you to specify a stack size per-task.
Using it is not recommended, since it is hard to predict how much stack
space will be needed, for instance by the compiler or called libraries.

A thread can switch to running a given task just by adjusting its registers to
appear to "return from" the previous switch away from that task.
We allocate a new stack out of a local pool just before we start running it.
As soon as a task is done running, we can immediately release its stack back
to the pool, avoiding excessive GC pressure.

We also have an alternate implementation of stack switching (controlled by the
`ALWAYS_COPY_STACKS` variable in `options.h`) that trades time for memory by
copying live stack data when a task switch occurs.
This may not be compatible with foreign code that uses `cfunction`,
so it is not the default.

We fall back to this implementation if stacks are consuming too much address
space (some platforms—notably Linux and 32-bit machines—impose a fairly low limit).
And of course, each implementation has code for multiple platforms and
architectures, sometimes optimized further with inline assembly.
Stack switching is a rich topic that could very well fill a blog post on its own.

### I/O

We use libuv for cross-platform event-based I/O.
It is designed to be able to function within a multithreaded program, but is not
explicitly a multithreaded I/O library and so doesn't support concurrent use from
multiple threads out of the box.
For now, we protect access to libuv structures with a single global lock, and then allow any thread
(one at a time) to run the event loop.
When another thread needs the event loop thread to wake up, it issues an async signal.
This can happen for multiple reasons, including another thread scheduling new work,
another thread starting to run garbage collection, or another thread that wants to take
the IO lock to do IO.

### Task migration across system threads

In general, a task might start running on one thread, block for a while, and then
restart on another.
This changes fundamental assumptions about when thread-local values can change.
Internally, Julia code uses thread-local variables *constantly*, for example
every time you allocate memory.
We have yet to begin all the changes needed to support migration, so for now
a task must always run on the thread it started running on (though, of course,
it can start running on any thread).
To support this, we have a concept of "sticky" tasks that must run on a given
thread, and per-thread queues for running tasks associated with each thread.

### Sleeping idle threads

When there aren't enough tasks to keep all threads busy, some need to sleep to avoid
using 100% of all CPUs all the time.
This is a tricky synchronization problem, since some threads might be scheduling new work
while other threads are deciding to sleep.

### Where does the scheduler run?

When a task blocks, we need to call the scheduler to pick another task to run.
What stack does that code use to run?
It's possible to have a dedicated scheduler task, but we felt there would be
less overhead if we allowed the scheduler code to run in the context of the
recently-blocked task.
That works fine, but it means a task can exist in a strange intermediate state
where it is considered not to be running, and yet is in fact running the
scheduler.
One implication of that is that we might pull a task out of the scheduler queue just
to realize that we don't need to switch away at all.

### Classic bugs

While trying to get this new functionality working, we encountered several
maddeningly difficult bugs.
The clear favorite was a mysterious hang on Windows that was fixed
by literally [flipping a single bit][].

Another good one was a [missing exception handling personality][].
In hindsight that could have been straightforward, but was confounded by two
factors: first, the failure mode caused the kernel to stop our process in a way
that we were not able to intercept in a debugger, and second, the failure was
triggered by a seemingly-unrelated change.
All Julia stack frames have an exception handling personality set, so the problem
could only appear in the runtime system outside any Julia frame — a narrow window,
since of course we are usually executing Julia code.

## Looking forward

While we are excited about this milestone, a lot of work remains.
This alpha release introduces the `@spawn` construct, but is not intended to finalize
its design.
Here are some of the points we hope to focus on to further develop
our threading capabilities:

* Performance work on task switch and I/O latency.
* Adding parallelism to the standard library. Many common operations like sorting and
  array broadcasting could now use multiple threads internally.
* Consider allowing task migration.
* Provide more atomic operations at the Julia level.
* Using multiple threads in the compiler.
* More performant parallel loops and reductions, with more scheduling options.
* Allow adding more threads at run time.
* Improved debugging tools.
* Explore API extensions, e.g. cancel points.
* Standard library of thread-safe data structures.
* Provide alternate schedulers.
* Explore integration with the [TAPIR][] parallel IR (some early work [here][]).


## Acknowledgements

We would like to gratefully acknowledge funding support from [Intel][] and [relationalAI][]
that made it possible to develop these new capabilities.

We are also grateful to the several people who patiently tried this functionality
while it was in development and filed bug reports or pull requests, and spurred us
to keep going.
If you encounter any issues using threads in Julia, please let us know on [GitHub][] or
our [Discourse][] forum!


[free lunch]: http://www.gotw.ca/publications/concurrency-ddj.htm
[Cilk]: http://supertech.csail.mit.edu/cilk/
[Intel Threading Building Blocks]: https://software.intel.com/en-us/intel-tbb/
[Go]: https://tour.golang.org/concurrency/1
[partr]: https://github.com/kpamnany/partr
[Juno IDE]: https://junolab.org/
[flipping a single bit]: https://github.com/JuliaLang/libuv/commit/26dbe5672c33fc885462c509fe2a9b36f35866fd
[missing exception handling personality]: https://github.com/JuliaLang/julia/pull/32570
[TAPIR]: http://supertech.csail.mit.edu/cilk/tapir/
[here]: https://github.com/JuliaLang/julia/pull/31086
[TBB]: https://software.intel.com/en-us/node/506304
[Intel]: https://www.intel.com/
[relationalAI]: https://relational.ai/
[GitHub]: https://github.com/JuliaLang/julia/issues
[Discourse]: https://discourse.julialang.org/
[downloads page]: /downloads/
[master branch]: https://github.com/JuliaLang/julia
