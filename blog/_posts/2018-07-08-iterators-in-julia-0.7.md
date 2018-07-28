---
layout: post
title: "Writing Iterators in Julia 0.7"
author: <a href="https://github.com/iamed2">Eric Davies</a>
---

This post originally appeared on the [Invenia blog](https://invenia.github.io/blog/2018/07/06/iteratorsinjulia07/).

With the upcoming 0.7 release, Julia has simplified its iteration interface. The [0.7-beta](http://julialang.org/downloads) release is available for download.
This was a [huge undertaking](https://github.com/JuliaLang/julia/pull/25261) which mostly fell to the prolific [Keno Fischer](https://github.com/Keno), who wrote an entirely new optimizer for the language to accomplish it!
As the most active maintainer of the [IterTools](https://github.com/JuliaCollections/IterTools.jl) package, I decided to spend a week rewriting its iterators for the new interface.
I'd like to share that experience with you to introduce the new interface and assist in transitioning to Julia 0.7.

## Iteration in Julia 0.6

Previously, Julia's iteration interface consisted of three methods: `start`, `next`, and `done`.
A good way to demonstrate how these work together is to show the transformation from a `for` loop to the equivalent `while` loop using those functions. I've taken this from the [Julia Interfaces documentation](https://docs.julialang.org/en/release-0.6/manual/interfaces/#man-interface-iteration-1), written by [Matt Bauman](https://github.com/mbauman) and others.

A simple `for` loop like this:

```julia
for element in iterable
    # body
end
```

was equivalent to this `while` loop:

```julia
state = start(iterable)
while !done(iterable, state)
    (element, state) = next(iterable, state)
    # body
end
```

A simple example is a range iterator which yields every nth element up to some number of elements:

```julia
julia> struct EveryNth
           n::Int
           start::Int
           length::Int
       end

julia> Base.start(iter::EveryNth) = (iter.start, 0)

julia> function Base.next(iter::EveryNth, state)
           element, count = state
           return (element, (element + iter.n, count + 1))
       end

julia> function Base.done(iter::EveryNth, state)
           _, count = state
           return count >= iter.length
       end

julia> Base.length(iter::EveryNth) = iter.length

julia> Base.eltype(iter::EveryNth) = Int
```

Then we can iterate:

```julia
julia> for element in EveryNth(2, 0, 10)
           println(element)
       end
0
2
4
6
8
10
12
14
16
18
```

Which is equivalent to:

```julia
julia> let iterable = EveryNth(2, 0, 10), state = start(iterable)
           while !done(iterable, state)
               (element, state) = next(iterable, state)
               println(element)
           end
       end
0
2
4
6
8
10
12
14
16
18
```

Notice that our `EveryNth` struct is immutable and we never mutate the state information.

As an aside, the `length` and `eltype` method definitions are not necessary.
Instead, we could use the `IteratorSize` and `IteratorEltype` traits to say that we don't implement those functions and Julia's Base functions will not try to call them when iterating.
[`collect`](https://docs.julialang.org/en/latest/base/collections/#Base.collect-Tuple{Any}) is notable for specializing on both of these traits to provide optimizations for different kinds of iterators.

## Iteration in Julia 0.7

In Julia 0.7, the iteration interface is now just one function: `iterate`.
The `while` loop above would now be written as:

```julia
iter_result = iterate(iterable)
while iter_result !== nothing
    (element, state) = iter_result
    # body
    iter_result = iterate(iterable, state)
end
```

The `iterate` function has two methods.
The first is called once, to begin iteration (like the old `start`) and _also_ perform the first iteration step.
The second is called repeatedly to iterate, like `next` in Julia 0.6.

The `EveryNth` example now looks like this:

```julia
julia> struct EveryNth
           n::Int
           start::Int
           length::Int
       end

julia> function Base.iterate(iter::EveryNth, state=(iter.start, 0))
           element, count = state

           if count >= iter.length
               return nothing
           end

           return (element, (element + iter.n, count + 1))
       end

julia> Base.length(iter::EveryNth) = iter.length

julia> Base.eltype(iter::EveryNth) = Int
```

In our `iterate` function we define a default value for `state` which is used when `iterate` is called with one argument. [^defaults]

This is already less code than the old interface required, but we can reduce it further using another new [feature](https://github.com/JuliaLang/julia/pull/23337) of Julia 0.7.

```julia
function Base.iterate(it::EveryNth, (el, i)=(it.start, 0))
	return i >= it.length ? nothing : (el, (el + it.n, i + 1))
end
```

I personally prefer verbosity when it increases readability, but some people prefer shorter code, and that's easier than ever to achieve.

### A Note on Compatibility

To assist with transitioning between versions, Julia 0.7 includes fallback definitions of `iterate` which call `start`, `next`, and `done`.
If you want code to work on both 0.6 and 0.7, I recommend keeping your iterators defined in those terms, as there isn't a good way to use the `iterate` interface on Julia 0.6.
Julia 1.0 will remove those fallback definitions and all usage of the old iteration interface.

## Common Strategies

The above example was constructed to be as straightforward as possible, but not all iteration is that easy to express.
Luckily, the new interface was designed to assist with situations which were previously difficult or inefficient, and in some cases (like the `EveryNth` example) reduces the amount of code necessary.
While [updating](https://github.com/JuliaCollections/IterTools.jl/pull/35) [IterTools.jl](https://github.com/JuliaCollections/IterTools.jl), I came across a few patterns which repeatedly proved useful.

### Wrapping Another Iterable

In many cases, the iterable we want to create is a transformation applied to a caller-supplied iterable.
Many of the useful patterns apply specifically to this situation.

#### Early Return

When wrapping an iterable, we usually want to terminate when the wrapped iterable terminates, i.e., return `nothing` when the wrapped call to `iterate` returns `nothing`.
If the call to `iterate` doesn't return `nothing`, we want to apply some operations before returning.
This pattern was common and simple enough to justify a macro which in IterTools I've called `@ifsomething`[^macroname]:

```julia
macro ifsomething(ex)
    quote
        result = $(esc(ex))
        result === nothing && return nothing
        result
    end
end
```

Putting this code in a multiline macro allows us to simplify code which would usually require multiple lines.
This code:

```julia
iter = iterate(wrapped, wrapped_state)

if iter === nothing
    return nothing
end

val, wrapped_state = iter

# continue processing
```

becomes this:

```julia
val, wrapped_state = @ifsomething iterate(wrapped, wrapped_state)
```

Conveniently (since it would otherwise error), the value returned from `iterate` will only be unpacked if it's not `nothing`.

#### Slurping and Splatting

The iteration interface requires two methods of `iterate`, but it's handy to use default arguments[^defaults] to only write out one function.
However, sometimes there is no clear initial value for `state`, e.g., if it requires you to start iterating over the wrapped iterable.
In this case it's helpful to use "slurping" and "splatting"[^slurpsplat] to refer to either zero or one function argument—the presence or absence of the `state` argument.

A simple example is the `TakeNth` iterator from [IterTools.jl](https://juliacollections.github.io/IterTools.jl/latest/#takenth(xs,-n)-1).
Its implementation of the `iterate` function looks like this:

```julia
function iterate(it::TakeNth, state...)
    xs_iter = nothing

    for i = 1:it.interval
        xs_iter = @ifsomething iterate(it.xs, state...)
        state = Base.tail(xs_iter)
    end

    return xs_iter
end
```

When you first call `iterate(::TakeNth)`, `state` starts out as an empty tuple.
Splatting this empty tuple into `iterate` produces the call `iterate(it.xs)`.
In all further calls, the actual state returned from iterating over the wrapped iterable will be wrapped in a 1-tuple, and unwrapped in each call.

One of the other tools we use here is the unexported function `Base.tail(::Tuple)`.
This function performs the equivalent of slurping on tuples, or `xs_iter[2:end]`.
No matter the size of the input tuple, it will always return at least an empty tuple.
This is especially useful in the next, slightly more complicated example.

For `TakeNth`, we were only passing around the wrapped iterable's state, but sometimes we need to carry some state of our own as well.
For the `TakeStrict` iterator from [IterTools.jl](https://juliacollections.github.io/IterTools.jl/latest/#takestrict(xs,-n)-1) we want to iterate over exactly `n` elements from the wrapped iterable, so we need to carry a counter as well.

```julia
function iterate(it::TakeStrict, state=(it.n,))
    n, xs_state = first(state), Base.tail(state)
    n <= 0 && return nothing
    xs_iter = iterate(it.xs, xs_state...)

    if xs_iter === nothing
        throw(ArgumentError("In takestrict(xs, n), xs had fewer than n items to take."))
    end

    v, xs_state = xs_iter
    return v, (n - 1, xs_state)
end
```

Here we use `Base.tail` to slurp the rest of the input after our counter, so `xs_state` is either an empty tuple (on the initial `iterate` call) or a 1-tuple containing the state for the wrapped iterable.

#### Look-ahead Iterators

Occasionally we may want to write an iterable that requires advancing the wrapped iterable before returning a value, such as some kind of generic Fibonnaci iterator, or the simplest example, a "peekable" iterator that can look ahead to the next value.
This exists in [IterTools.jl](https://juliacollections.github.io/IterTools.jl/latest/#peekiter(xs)-1) as `PeekIter`.

```julia
function iterate(pit::PeekIter, state=iterate(pit.it))
    val, it_state = @ifsomething state
    return (val, iterate(pit.it, it_state))
end
```

In this case, the work needed for the initial `iterate` call is just a superset of the regular `iterate` call, so it's very simple to implement.
In general, the code for look-ahead iterators is just as easy to write in Julia 0.7, but usually more compact.

### Piecewise Development Approach

Having to write many new `iterate` methods led me to discover some helpful strategies for writing `iterate` methods when unsure of the best approach.
The most helpful thing I did was to write the two-argument method for `iterate` first, then write the one-argument method, then try to simplify them into a single method.
Remember that the one-argument method is a combination of the `start` and `next` methods from the old iteration interface.
I also realized that it was sometimes easier to apply patterns like the ones above in order to translate from the old to the new iteration interface without attempting to understand the initial version completely.

Let's look at one of the more complicated iterators in [IterTools.jl](https://juliacollections.github.io/IterTools.jl/latest/#partition(xs,-n,-[step])-1): `Partition`.
Something that immediately jumps out about the [original](https://github.com/JuliaCollections/IterTools.jl/commit/66d1951c2634d06ab629fcf35ea227ddbe9a2342?diff=split#diff-bd068feabf42c1d394ba76bc98a4d738L407) is this pattern:

```julia
if done(it.xs, s)
    break
end
(x, s) = next(it.xs, s)
```

If there are more items, this advances the wrapped iterable, otherwise it breaks out of the surrounding loop.
In the new interface this requires just one call instead of two:

```julia
iter = iterate(it.xs, s)
iter === nothing && break
(x, s) = iter
```

Then this pattern can be applied by rote wherever it appears.
Applying this and writing two `iterate` methods results in this[^respell]:

```julia
function iterate(it::Partition{I, N}, state) where {I, N}
    (xs_state, result) = state
    # this @ifsomething call handles the 0.6 situation
    # where `done` is always called before `next`
    result[end], xs_state = @ifsomething iterate(it.xs, xs_state)

    p = similar(result)
    overlap = max(0, N - it.step)
    p[1:overlap] .= result[it.step .+ (1:overlap)]

    # when step > n, skip over some elements
    for i in 1:max(0, it.step - N)
        xs_iter = iterate(it.xs, xs_state)
        xs_iter === nothing && break
        _, xs_state = xs_iter
    end

    for i in (overlap + 1):(N - 1)
        xs_iter = iterate(it.xs, xs_state)
        xs_iter === nothing && break

        p[i], xs_state = xs_iter
    end

    return (tuple(result...), (xs_state, p))
end

function iterate(it::Partition{I, N}) where {I, N}
    result = Vector{eltype(I)}(undef, N)

    result[1], xs_state = @ifsomething iterate(it.xs)

    for i in 2:(N - 1)
        result[i], xs_state = @ifsomething iterate(it.xs, xs_state)
    end

    return iterate(it, (xs_state, result))
end
```

This works for almost every case, except when `N == 1`!
In that case, we do need to start with `iterate(it.xs)`, but we have to return the first item before calling `iterate` again, so we have to skip the first iteration in the two-argument method.
It would be nice to have the methods be this simple chain, but it looks like we need to combine them.

Previously, we've been able to come up with a sensible default state (or a tuple we can splat) for the combined method.
We can't[^cantorwont] do that here, as we need to have conditional behaviour for both cases.
Luckily, we can add `nothing` as a sentinel and Julia will compile the check away.
Making this change results in the version which appears in IterTool 1.0:

```julia
function iterate(it::Partition{I, N}, state=nothing) where {I, N}
    if state === nothing
        result = Vector{eltype(I)}(undef, N)

        result[1], xs_state = @ifsomething iterate(it.xs)

        for i in 2:N
            result[i], xs_state = @ifsomething iterate(it.xs, xs_state)
        end
    else
        (xs_state, result) = state
        result[end], xs_state = @ifsomething iterate(it.xs, xs_state)
    end

    p = similar(result)
    overlap = max(0, N - it.step)
    p[1:overlap] .= result[it.step .+ (1:overlap)]

    # when step > n, skip over some elements
    for i in 1:max(0, it.step - N)
        xs_iter = iterate(it.xs, xs_state)
        xs_iter === nothing && break
        _, xs_state = xs_iter
    end

    for i in (overlap + 1):(N - 1)
        xs_iter = iterate(it.xs, xs_state)
        xs_iter === nothing && break

        p[i], xs_state = xs_iter
    end

    return (tuple(result...)::eltype(Partition{I, N}), (xs_state, p))
end
```

## Conclusion

These are the techniques that helped me in my work, but I'd like to hear about more!
I'm also curious which patterns improve or harm performance and why.
IterTools will definitely accept pull requests, and I'm interested in feedback on [Slack](https://julialang.slack.com/) and [Discourse](https://discourse.julialang.org/).


[^defaults]: In Julia, this actually defines two methods of `iterate`, as described in the [Julia docs](https://docs.julialang.org/en/latest/manual/methods/#Note-on-Optional-and-keyword-Arguments-1).
[^macroname]: This name is definitely up for debate!
[^slurpsplat]: Slurping refers to  how using `args...` in a function definition "slurps" up the trailing arguments, and splatting is the inverse operation. The [Julia docs](https://docs.julialang.org/en/latest/manual/functions/#Varargs-Functions-1) say more on this.
[^respell]: All other changes here are renaming or respelling something that appears in the original, for clarity's sake.
[^cantorwont]: We _could_, but we'd need to do something different depending on the length of the tuple, which would add another conditional check in addition to the splatting.

