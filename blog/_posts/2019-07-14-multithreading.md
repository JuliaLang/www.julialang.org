---
layout: post
title:  Announcing composable multi-threaded parallelism in Julia
author: Jeff Bezanson, Jameson Nash
---

Software performance depends more and more on exploiting multiple processor cores.
The [free lunch][] from Moore's Law is still over.
Well, we here in the Julia developer community have something of a reputation for
caring about performance, so we've known for years that we would need a good
story for multi-threaded, multi-core execution.
Today we are happy to announce a major new chapter in that story.
We are releasing an entirely new threading interface for Julia programs:
general task parallelism, inspired by parallel programming systems
like [Cilk][] and [Go][].
Task parallelism is now available on the master branch, and a beta version will be
released as part of the upcoming Julia version 1.3.

In this paradigm, any piece of a program can be marked for execution in parallel,
and a "task" will be started to run that code automatically on an available thread.
A dynamic scheduler handles all the decisions and details for you.
Here's an example of parallel code you can now write in Julia:

```
function fib(n::Int)
    if n < 2
        return n
    end
    t = @par fib(n - 2)
    return fib(n - 1) + fetch(t)
end
```

This, of course, is the classic highly-inefficient tree recursive implementation of
the Fibonacci sequence --- but running on any number of processor cores!
The line `t = @par fib(n - 2)` starts a task to compute `fib(n - 2)`, which runs in
parallel with the following line computing `fib(n - 1)`.
`fetch(t)` waits for task `t` to complete and gets its return value.

This model of parallelism has many wonderful properties.
We see it as somewhat analogous to garbage collection: with GC, you
freely allocate objects without worrying about when and how they are freed.
With task parallelism, you freely spawn tasks --- potentially millions of them --- without
worrying about where they run.

The model is portable and free from low-level details.
You don't need to explicitly start and stop threads, and you don't even need to know how
many processors or threads there are (though you can find out if you want).

The model is nestable and composable: you can start parallel tasks that call library
functions that themselves start parallel tasks, and everything works.
Your CPUs will not be over-subscribed with threads.
This property is crucial for a high-level language where a lot of work is done by library
functions.
You need to be free to write whatever code you need --- including parallel code ---
without worrying about how the libraries it calls are implemented.
(*in the future we plan to extend this to C libraries such as BLAS, currently it only applies to Julia code)

This is, in fact, the reason we are excited about this announcement: from this point on,
multi-core parallelism is unleashed over the entire Julia package ecosystem.

## Some history

One of the most surprising aspects of this new feature is just how long it has been in
the works.
From the very beginning --- prior even to the 0.1 release --- Julia has had the `Task`
type providing symmetric coroutines, which we've used for event-based I/O.
So we have always had a unit of *concurrency* (independent streams of execution) in the language, it just wasn't *parallel* (simultaneous)
(simultaneous streams of execution) yet.
We knew we needed parallelism though, so in 2014 (roughly the version 0.3 timeframe) we
set about the long process of making all of our code thread-safe.
Yichao Yu put in some particularly impressive work on the garbage collector and thread-local-storage performance.
handling.
Kiran Pamnany (of Intel) put some basic infrastructure in place for starting and
running multiple threads.

Within about two years, we were ready to release the `@threads` macro in version 0.5,
which provides simple parallel loops.
Even though that wasn't the final design we wanted, it did two important jobs:
it let Julia programmers start taking advantage of multiple cores, and provided
test cases to shake out thread-related bugs in our runtime.
`@threads` had some huge limitations, however.
`@threads` loops could not be nested: all the functions you call from within such a loop
must not themselves use `@threads`.
It was also incompatible with our `Task` and I/O system: you couldn't do any I/O or
switch among `Task`s inside a threaded loop.

So the next logical step was to merge the `Task` and threading systems, and "simply"
(cue laughter) allow `Task`s to run simultaneously on a pool of threads.
We had many early discussions with Arch Robison (then also of Intel) and concluded
that this was the best model for our language.
After version 0.5 (around 2016) Kiran started experimenting with a new parallel
task scheduler [partr][] based on the idea of depth-first scheduling.
He sold all of us on it with some nice animated slides, and it also didn't hurt that
he was willing to do some of the work.
The plan was to first develop partr as a standalone C library so it could be tested
and benchmarked on its own, and then integrate it with the Julia runtime.

After Kiran completed the standalone version of partr, we embarked on a series of
work sessions including Anton Malakhov (also of Intel) to figure out how to do
the integration.
The Julia runtime brings many extra features, such as garbage collection and
event-based I/O, so this was not entirely straightforward.
Somewhat disappointingly, though not unusually for a complex software project,
it took much longer than expected --- nearly two years --- to get the new
system working reliably.
A later section of this post will explain some of the internals and difficulties
involved for the curious.
But first, let's take it for a spin.

## How to use it

To use Julia with multiple threads, set the `JULIA_NUM_THREADS` environment
variable:

```
$ JULIA_NUM_THREADS=4 ./julia
```

The [Juno IDE][] automatically sets the number of threads based on the number of
available processor cores, and also provides a graphical interface for changing
the number of threads, so setting the variable manually is not necessary
in that environment.

The `Threads` submodule of `Base` houses most of the thread-specific functionality,
such as querying the number of threads and the ID of the current thread:

```
julia> Threads.nthreads()
4

julia> Threads.threadid()
1
```

`@threads` loops still work, except now I/O is no problem:

```
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

```
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

    half = @par psort!(v, lo, mid)    # task to sort the lower half; will run
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
`Base` library, with only the tiny addition of the `@par` construct on one
of the recursive calls.
`wait` simply waits for the specified task to finish.
The code works by modifying its input, so we don't need the task's return value.
Indicating that a return value is not needed is the only difference with the
`fetch` call used in the earlier `fib` example.
Note that we explicitly request `MergeSort` when calling Julia's standard `sort!`,
to make sure we're comparing apples to apples --- `sort!` actually uses
quicksort by default for sorting numbers, which tends to be faster for random data.
Let's time the code under `JULIA_NUM_THREADS=2`:

```
julia> a = rand(20000000);

julia> b = copy(a); @time sort!(b, alg = MergeSort);
  2.589243 seconds (11 allocations: 76.294 MiB, 0.17% gc time)

julia> b = copy(a); @time sort!(b, alg = MergeSort);
  2.582697 seconds (11 allocations: 76.294 MiB, 2.25% gc time)

julia> b = copy(a); @time psort!(b);
  1.770902 seconds (3.78 k allocations: 686.935 MiB, 4.25% gc time)

julia> b = copy(a); @time psort!(b);
  1.741141 seconds (3.78 k allocations: 686.935 MiB, 4.16% gc time)
```

While the run times are bit variable, we see a definite speedup from using
two threads.
The laptop we ran this on has four hyperthreads, and it is especially amazing
that the performance of this code continues to scale if we add a third thread:

```
julia> b = copy(a); @time psort!(b);
  1.511860 seconds (3.77 k allocations: 686.935 MiB, 6.45% gc time)
```

Thinking about this two-way decomposition algorithm running on three threads
can make your head hurt a little!
In our view, this helps underscore how "automatic" this interface makes
parallelism feel.

Let's try a different machine with more CPU cores:

```
$ for n in 1 2 4 8 16; do    JULIA_NUM_THREADS=$n ./julia psort.jl; done
  2.958881 seconds (3.58 k allocations: 686.932 MiB, 4.71% gc time)
  1.868720 seconds (3.77 k allocations: 686.935 MiB, 7.03% gc time)
  1.222777 seconds (3.78 k allocations: 686.935 MiB, 9.14% gc time)
  0.958517 seconds (3.79 k allocations: 686.935 MiB, 18.21% gc time)
  0.836891 seconds (3.78 k allocations: 686.935 MiB, 21.10% gc time)
```

Notice that this speedup occurs despite the parallel code allocating
*drastically* more memory than the standard routine.
The allocations come from two sources: `Task` objects, and the `temp`
arrays allocated on each call.
The reference sorting routine re-uses a single temporary buffer among
all recursive calls.
Re-using the temporary array is more difficult with parallelism, but
still possible --- more on that a little later.

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

```
lock(cond::Threads.Condition)
while !ready
    wait(cond)
end
unlock(cond)
```

As in previous versions, the standard lock to use to protect critical sections
is `ReentrantLock`, which is now thread-safe (it was previously only used for
synchronizing tasks).
`Threads.SpinLock` is also available, to be used in rare circumstances where
(1) only threads and not tasks need to be synchronized, and (2) you expect to
hold the lock for a short time.
`Semaphore` and `Event` are also available, completing the standard set of
synchronization primitives.

### Thread-local state

Julia code naturally tends to be purely functional (no side effects or mutation),
or only uses local mutation, so migrating to full thread-safety will hopefully
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
First, we modify the function to accept pre-allocated buffers, using a default
argument value to allocate space automatically when the caller doesn't provide it:

```
function psort!(v, lo::Int=1, hi::Int=length(v), temps = [similar(v,cld(length(v),2)) for i = 1:Threads.nthreads()])
```

The maximum size of temporary array our mergesort needs is half the array, using
ceiling division (`cld`) to handle odd lengths.
We simply need to allocate one array per thread.
Next, we modify the recursive calls to reuse the space:

```
    half = @par psort!(v, lo, mid, temps)
    psort!(v, mid+1, hi, temps)
```

Finally, use the array reserved for the current thread, instead of allocating a new one:

```
    temp = temps[Threads.threadid()]
    copyto!(temp, 1, v, lo, m-lo+1)
```

After these minor modifications, let's check performance on our large
machine:

```
$ for n in 1 2 4 8 16; do    JULIA_NUM_THREADS=$n ./julia psort.jl; done
  2.723312 seconds (3.07 k allocations: 152.852 MiB, 0.14% gc time)
  1.711112 seconds (3.28 k allocations: 229.149 MiB, 0.59% gc time)
  0.971327 seconds (3.28 k allocations: 381.737 MiB, 1.60% gc time)
  0.782790 seconds (3.28 k allocations: 686.913 MiB, 8.63% gc time)
  0.722063 seconds (3.33 k allocations: 1.267 GiB, 21.43% gc time)
```

Definitely faster, but we do seem to have some work to do on the
scalability of the runtime system.

### Seeding the default random number generator

Julia's default global random number generator (`rand()`) is a particularly
challenging case for thread-safety.
We have split it into separate random streams for each thread, allowing
code with `rand()` to be freely parallelized and get independent random
numbers on each thread.

However, seeding (`Random.seed!(n)`) is trickier.
Seeding all of the per-thread streams would require some kind of synchronization
among threads, which would unacceptably slow down random number generation.
It also makes a very limited amount of sense: threading introduces its own
nondeterminism, so you cannot get much predictability by seeding one thread's
state from another.
Therefore we decided to have the `seed!(n)` call affect only the current thread's
state.
That way, multiple independent code sequences that seed and then use random
numbers can at least individually work as expected.
For more elaborate seeding requirements, we recommend allocating and passing
your own RNG objects (e.g. `Rand.MersenneTwister()`).


## Under the hood

As with garbage collection, the simple interface (`@par`) belies great
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
windows), defaulting to 4MiB each (2MiB on 32-bit systems).
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

A thread can switch to running a given task simply (in principle) by switching
its stack pointer to refer to the new task's stack and jumping to the next
instruction.
As soon as a task is done running, we can immediately release its stack back
to the pool, avoiding excessive GC pressure.

We also have an alternate implementation of stack switching (controlled by the
`ALWAYS_COPY_STACKS` variable in `options.h`) that trades time for memory by
copying live stack data when a task switch occurs.
We fall back to this implementation if stacks are consuming too much address
space (some platforms impose a limit, which we exceeded in early testing).
And of course, each implementation has code for multiple platforms and
architectures, often requiring assembly language.
Stack switching is a rich topic that could very well fill a blog post on its own.

### I/O

We use libuv for cross-platform event-based I/O.
It is designed to be able to function within a multithreaded program, but is not
explicitly a multithreaded I/O library and so doesn't support concurrent use from
multiple threads out of the box.
We decided to protect access to libuv structures with a lock, and then allow any thread
(one at a time) to run the event loop.
When another thread needs the event loop thread to wake up, it issues an async signal.
This can happen for multiple reasons, including another thread scheduling new work,
or another thread needing to run garbage collection.

### Task migration

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
In particular, we need to make sure no other thread sees that task and thinks
"oh, there's a task I can run", causing it to scribble on the scheduler's
stack.

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
could only appear in the runtime system outside any Julia frame --- a narrow window,
since of course we are usually executing Julia code.

## Looking forward

While we are excited about this milestone, a lot of work remains.
Here are some of the points we hope to focus on to further develop
our threading capabilities:

* Performance work on task switch and I/O latency.
* Adding parallelism to the standard library. Many common operations like sorting and
  array broadcasting could now use multiple threads internally.
* Consider allowing task migration.
* Improved debugging tools.
* Explore API extensions, e.g. cancel points.
* Provide alternate schedulers.
* Explore integration with the [TAPIR][] parallel IR (some early work [here][]).


## Acknowledgements

We would like to gratefully acknowledge funding support from Intel and relationalAI
that made it possible to develop these new capabilities.

We are also grateful to the several people who patiently tried this functionality
while it was in development and filed bug reports or pull requests, and spurred us
to keep going!


[free lunch]: http://www.gotw.ca/publications/concurrency-ddj.htm
[Cilk]: http://cilk.mit.edu/
[Go]: https://tour.golang.org/concurrency/1
[partr]: https://github.com/kpamnany/partr
[Juno IDE]: https://junolab.org/
[flipping a single bit]: https://github.com/JuliaLang/libuv/commit/26dbe5672c33fc885462c509fe2a9b36f35866fd
[missing exception handling personality]: https://github.com/JuliaLang/julia/pull/32570
[TAPIR]: http://cilk.mit.edu/tapir/
[here]: https://github.com/JuliaLang/julia/pull/31086
