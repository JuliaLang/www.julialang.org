@def rss_pubdate = Date(2017, 1, 21)
@def rss_description = """ More Dots: Syntactic Loop Fusion in Julia | After a lengthy design process (https://github.com/JuliaLang/julia/issues/8450) and preliminary foundations in Julia 0.5 (/blog/2016-10-11-julia-0.5-highlights#vectorized_function_calls), Julia 0.6 includes new facilities for writing code in the "vectorized"... """
@def published = "21 January 2017"
@def title = "More Dots: Syntactic Loop Fusion in Julia"
@def authors = """ <a href="https://math.mit.edu/~stevenj">Steven G. Johnson</a>"""
@def hascode = true


After a [lengthy design process](https://github.com/JuliaLang/julia/issues/8450) and [preliminary foundations in Julia 0.5](/blog/2016/10/julia-0.5-highlights/#vectorized_function_calls), Julia 0.6 includes new facilities for writing code in the "vectorized"
style (familiar from Matlab, Numpy, R, etcetera) while avoiding the
overhead that this style of programming usually imposes: multiple
vectorized operations can now be "fused" into a single loop, without
allocating any extraneous temporary arrays.

This is best illustrated with an example (in which we get
*order-of-magnitude* savings in memory and time, as demonstrated below).  Suppose we have
a function `f(x) = 3x^2 + 5x + 2` that evaluates a polynomial,
and we want to evaluate `f(2x^2 + 6x^3 - sqrt(x))` for a whole array `X`,
storing the result in-place in `X`.  You can now do:

```julia
X .= f.(2 .* X.^2 .+ 6 .* X.^3 .- sqrt.(X))
```

or, [equivalently](https://github.com/JuliaLang/julia/pull/20321):

```julia
@. X = f(2X^2 + 6X^3 - sqrt(X))
```

and the whole computation will be *fused* into a single loop, operating in-place,
with performance comparable to the hand-written
"devectorized" loop:

```julia
for i in eachindex(X)
    x = X[i]
    X[i] = f(2x^2 + 6x^3 - sqrt(x))
end
```

(Of course, like all Julia code, to get good performance both of these snippets should be executed inside some function, not in global scope.)   To see the details of a variety of performance experiments with this example code, follow along in the attached IJulia/Jupyter [notebook]: we find that the
`X .= ...` code has performance within 10% of the hand-devectorized loop (which itself is within 5% of the
speed of C code),
except for very small arrays where there is a modest overhead (e.g. 50% overhead for a length-1 array `X`).

In this blog post, we delve into some of the details of this new development, in order to answer questions that often arise when this feature is presented:

@@tight-list
1. What is the overhead of traditional "vectorized" code?  Isn't vectorized code supposed to be fast already?
2. Why are all these dots necessary?  Couldn't Julia just optimize "ordinary" vector code?
3. Is this something unique to Julia, or can other languages do the same thing?
@@

The short answers are:

<!-- These numbered paragraphs must be soft-wrapped, without CRs  -->

@@tight-list
1. [Ordinary vectorized code is fast, but not as fast as a hand-written loop](https://www.johnmyleswhite.com/notebook/2013/12/22/the-relationship-between-vectorized-and-devectorized-code/) (assuming loops are efficiently compiled, as in Julia) because each vectorized operation generates a new temporary array and executes a separate loop, leading to a lot of overhead when multiple vectorized operations are combined.
2. The dots allow Julia to recognize the "vectorized" nature of the operations at a *syntactic* level (before e.g. the type of `x` is known), and hence the loop fusion is a *syntactic guarantee*, not a compiler optimization that may or may not occur for carefully written code.  They also allow the *caller* to "vectorize" *any* function, rather than relying on the function author.  (The `@.` macro lets you add dots to every operation in an expression, improving readability for expressions with lots of dots.)
3. Other languages have implemented loop fusion for vectorized operations, but typically for only a small set of types and operations/functions that are known to the compiler or vectorization library.  Julia's ability to do it generically, even for *user-defined* array types and functions/operators, is unusual and relies in part on the syntax choices above and on its ability to efficiently compile higher-order functions.
@@

Finally, we'll review why, since these dots actually correspond to
`broadcast` operations, they can **combine arrays and scalars, or combine containers
of different shapes and kinds**, and we'll compare `broadcast` and `map`.  Moreover, Julia 0.6 expanded and
clarified the notion of a "scalar" for `broadcast`, so that it is **not limited to numerical operations**: you can use `broadcast` and fusing "dot calls" for many other
tasks (e.g. string processing).

## Isn't vectorized code already fast?

To explore this question (also discussed
[in this blog post](https://www.johnmyleswhite.com/notebook/2013/12/22/the-relationship-between-vectorized-and-devectorized-code/)), let's begin by rewriting the code above in a more traditional vectorized style, without
so many dots, such as you might use in Julia 0.4 or in other languages
(most famously Matlab, Python/Numpy, or R).

```julia
X = f(2 * X.^2 + 6 * X.^3 - sqrt(X))
```

Of course, this assumes that the functions `sqrt` and `f` are "vectorized,"
i.e. that they accept vector arguments `X` and compute the
function elementwise.  This is true of `sqrt` in Julia 0.4, but it
means that we have to rewrite our function `f` from above in a vectorized style, as
e.g. `f(x) = 3x.^2 + 5x + 2` (changing `f` to use the elementwise operator `.^` because
`vector^scalar` is not defined).   (If we were using Julia 0.4 and cared a lot about efficiency,
we might have instead used the `@vectorize_1arg f Number` macro to generate
more specialized elementwise code.)

### Which functions are vectorized?

As an aside, this example illustrates an annoyance with the vectorized style:
you have to *decide in advance* whether a given function `f(x)`
will also be applied elementwise to arrays, and either
write it specially or define a corresponding elementwise method.

(Our function `f` accepts any `x` type, and in Matlab or R there is no distinction between
a scalar and a 1-element array.  However, even if a function *accepts* an array argument `x`,
that doesn't mean it will *work* elementwise
for an array unless you write the function with that in mind.)

For library functions like `sqrt`, this means that the library authors
have to guess at which functions should have vectorized methods, and users
have to guess at what vaguely defined subset of library functions work
for vectors.

One possible solution is to vectorize *every function automatically*.   The
language [Chapel](https://en.wikipedia.org/wiki/Chapel_%28programming_language%29)
does this: every function `f(x...)` implicitly
defines a function `f(x::Array...)` that evaluates `map(f, x...)`
[(Chamberlain et al, 2011)](http://pgas11.rice.edu/papers/ChamberlainEtAl-Chapel-Iterators-PGAS11.pdf).
This could be implemented in Julia as well via
function-call overloading [(Bezanson, 2015: chapter 4)](https://github.com/JeffBezanson/phdthesis/blob/master/main.pdf),
but we chose to go in a different direction.

Instead, starting in Julia 0.5, *any* function `f(x)` can be applied elementwise
to an array `X` with the ["dot call" syntax `f.(X)`](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized-1).
Thus, the *caller* decides which functions to vectorize.  In Julia 0.6,
"traditionally" vectorized library functions like `sqrt(X)` are [deprecated](https://github.com/JuliaLang/julia/pull/17302) in
favor of `sqrt.(X)`, and dot operators
like `x .+ y` are [now equivalent](https://github.com/JuliaLang/julia/pull/17623) to
dot calls `(+).(x,y)`.   Unlike Chapel's implicit vectorization, Julia's
`f.(x...)` syntax corresponds to `broadcast(f, x...)` rather than `map`,
allowing you to *combine arrays and scalars or arrays of different shapes/dimensions.*  (`broadcast` and `map` are compared at the end of this post; each
has its own unique capabilities.)
From the standpoint of the programmer, this adds a certain amount of
clarity because it indicates explicitly when an elementwise operation
is occurring.  From the standpoint of the compiler, dot-call syntax
enables the *syntactic loop fusion* optimization described in more detail
below, which we think is an overwhelming advantage of this style.

### Why vectorized code is fast

In many dynamically typed languages popular for interactive technical computing
(Matlab, Python, R, etc.), vectorization is seen as a key (often *the* key)
performance optimization.   It allows your code to take advantage of highly
optimized (perhaps even parallelized) library routines for basic operations like
`scalar*array` or `sqrt(array)`. Those functions, in turn, are usually
implemented in a low-level language like C or Fortran.   Writing your own
"devectorized" loops, in contrast, is too slow, unless you are willing to drop
down to a low-level language yourself, because the semantics of those dynamic
languages make it hard to compile them to efficient code in general.

Thanks to Julia's design, a properly written devectorized loop in Julia
has performance within a few percent of C or Fortran, so there is no *necessity*
of vectorizing; this is explicitly demonstrated for the devectorized
loop above in the accompanying [notebook]. However, vectorization may still be *convenient* for some problems.
And vectorized operations like `scalar*array` or `sqrt(array)` are still fast in Julia
(calling optimized library routines, albeit ones written in Julia itself).

Furthermore, if your problem involves a function that does not have a pre-written,
highly optimized, vectorized library routine in Julia, and that does not
decompose easily into existing vectorized building blocks like `scalar*array`, then
you can write your own building block without dropping down to a low-level language.
(If all the performance-critical code you will ever need already existed in the
form of optimized library routines, programming would be a lot easier!)

### Why vectorized code is not as fast as it could be

There is a tension between two general principles in computing: on
the one hand, *re-using* highly optimized code is good for
performance; on the other other hand, optimized code that is *specialized*
for your problem can usually beat general-purpose functions.
This is illustrated nicely by the traditional vectorized version of our code above:

```julia
f(x) = 3x.^2 + 5x + 2
X = f(2 * X.^2 + 6 * X.^3 - sqrt(X))
```

Each of the operations like `X.^2`  and `5*X` *individually*
calls highly optimized functions, but their *combination*
leaves a lot of performance on the table when `X` is an array.   To see that,
you have to realize that this code is equivalent to:

```
tmp1 = X.^2
tmp2 = 2*tmp1
tmp3 = X.^3
tmp4 = 6 * tmp3
tmp5 = tmp2 + tmp4
tmp6 = sqrt(X)
tmp7 = tmp5 - tmp6
X = f(tmp7)
```

That is, each of these vectorized operations allocates a separate
temporary array, and is a separate library call with its own inner
loop.  Both of these properties are bad for performance.

First, eight arrays are allocated (`tmp1` through `tmp7`, plus another
for the result of `f(tmp7)`, and another four are allocated
internally by `f(tmp7)` for the same reasons, for *12 arrays in all*.
The resulting `X = ...` expression does *not* update `X` in-place, but
rather makes the variable `X` "point" to a new array returned by `f(tmp7)`,
discarding the old array `X`.   All of these extra arrays are eventually
deallocated by Julia's garbage collector, but in the meantime it wastes
a lot of memory (an order of magnitude!)

By itself, allocating/freeing memory can take a significant amount of time
compared to our other computations. This is especially true if `X` is very small
so that the allocation overhead matters (in our benchmark [notebook], we pay
a 10× cost for a 6-element array and a 6× cost for a 36-element array), or  if
`X` is very large so that the memory churn matters (see below for numbers).
Furthermore, you pay a *different* performance price from the fact that you have
12 loops (12 passes over memory) compared to one, in part because of the loss of
[memory locality](https://en.wikipedia.org/wiki/Locality_of_reference).

In particular, reading or writing data in main computer memory (RAM) is much slower than performing scalar arithmetic operations like `+` and `*`, so computer hardware stores recently used data in a [cache](https://en.wikipedia.org/wiki/Cache_%28computing%29): a small amount
of much faster memory.  Furthermore, there is a hierarchy of smaller,
faster caches, culminating in the [register memory](https://en.wikipedia.org/wiki/Processor_register)
of the CPU itself.   This means that, for good performance, you should
load each datum `x = X[i]` *once* (so that it goes into cache, or into a register for small enough types), and
then perform several operations like `f(2x^2 + 6x^3 - sqrt(x))` on `x`
while you still have fast access to it, before loading the next datum;
this is called "temporal locality."   The traditional vectorized code
discards this potential locality: each `X[i]` is loaded once for a
single small operation like `2*X[i]`, writing the result out to a temporary
array before immediately reading the next `X[i]`.

In typical performance benchmarks (see [notebook]), therefore, the traditional
vectorized code `X = f(2 * X.^2 + 6 * X.^3 - sqrt(X))` turns out to be **about
10× slower** than the devectorized or fused-vectorized versions of the same code
at the beginning of this article for `X = zeros(10^6)`.   Even if we
pre-allocate all of the temporary arrays (completely eliminating the allocation
cost),  our benchmarks show that performing a separate loop for each operation
still is about 4–5× slower for a million-element `X`. This is not unique to
Julia!  **Vectorized code is suboptimal in any language** unless the
language's compiler can automatically fuse all of these loops (even ones that
appear inside function calls), which rarely happens for the reasons described
below.

## Why does Julia need dots to fuse the loops?

You might look at an expression like `2 * X.^2 + 6 * X.^3 - sqrt(X)` and
think that it is "obvious" that it could be combined into a single loop
over `X`.  Why can't Julia's compiler be smart enough to recognize this?

The thing that you need to realize is that, in Julia, there is nothing
particularly special about `+` or `sqrt` — they are arbitrary functions
and could do *anything*.   `X + Y` could send an email or open
a plotting window, for all the compiler knows.   To figure out that it
could fuse e.g. `2*X + Y` into a single loop, allocating a single
array for the result, the compiler would need to:

1. Deduce the types of `X` and `Y` and figure out what `*` and `+` functions to call.  (Julia already does this, at least when [type inference](https://en.wikipedia.org/wiki/Type_inference) succeeds.)

2. Look inside of those functions, realize that they are elementwise loops over `X` and `Y`, and realize that they are [pure](https://en.wikipedia.org/wiki/Pure_function) (e.g. `2*X` has no side-effects like modifying `Y`).

3. Analyze expressions like `X[i]` (which are calls to a function `getindex(X, i)` that is "just another function" to the compiler), to detect that they are memory reads/writes and determine what *data dependencies* they imply (e.g. to figure out that `2*X` allocates a temporary array that can be eliminated).

The second and third steps pose an *enormous challenge*: looking at an arbitrary
function and "understanding" it at this level turns out to be a very hard
problem for a computer.  If fusion is viewed as a compiler *optimization*, then the
compiler is only free to fuse if it can *prove* that fusion *won't change the
results*, which requires the detection of purity and other data-dependency
analyses.

In contrast, when the Julia compiler sees an expression like `2 .* X .+ Y`,
it knows just from the *syntax* (the "spelling") that these are elementwise
operations, and Julia *guarantees* that the code will *always* fuse into a single
loop, freeing it from the need to prove purity.  This is what we
term **syntactic loop fusion**, described in more detail below.

### A halfway solution: Loop fusion for a few operations/types

One approach that may occur to you, and which has been implemented in a
variety of languages (e.g. [Kennedy & McKinley, 1993](https://dl.acm.org/citation.cfm?id=665526);
[Lewis et al., 1998](https://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.46.6627);
[Chakravarty & Keller, 2001](https://dl.acm.org/citation.cfm?id=507661);
[Manjikian & Abdelrahman, 2002](http://ieeexplore.ieee.org.libproxy.mit.edu/document/577265/);
[Sarkar, 2010](https://ieeexplore.ieee.org/document/5389392/);
[Prasad et al., 2011](https://dl.acm.org/citation.cfm?id=1993517);
[Wu et al., 2012](https://dl.acm.org/citation.cfm?id=2457490)), is to only
perform loop fusion for *a few "built-in" types and operations* that the
compiler can be designed to recognize.   The same idea has also been
implemented as libraries (e.g. template libraries in C++:
[Veldhuizen, 1995](https://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.43.248)) or
[domain-specific
languages (DSLs)](https://en.wikipedia.org/wiki/Domain-specific_language)
as extensions of existing languages; in Python, for example, loop fusion for a small
set of vector operations and array/scalar types can be found in the
[Theano](http://deeplearning.net/software/theano/introduction.html),
[PyOP2](https://op2.github.io/PyOP2/), and [Numba](https://github.com/numba/numba/pull/1110)
software. Likewise, in Julia we could
potentially build the compiler to recognize that it can fuse
`*`, `+`, `.^`, and similar operations for the built-in `Array` type,
(and perhaps only for a few scalar types).
This has, in fact, already been implemented in Julia as a macro-based DSL (you add `@vec` or `@acc`
decorators to a vectorized expression) in the [Devectorize](https://github.com/lindahua/Devectorize.jl)
and [ParallelAccelerator](https://github.com/IntelLabs/ParallelAccelerator.jl)
packages.

However, even though Julia will certainly implement additional compiler
optimizations as time passes, one of the key principles of Julia's design
is to "build in" as little as possible into the core language, implementing
as much as possible of Julia *in Julia* itself [(Bezanson, 2015)](https://github.com/JeffBezanson/phdthesis/blob/master/main.pdf).
Put another way, the same *optimizations should be just as available to user-defined
types and functions* as to the "built-in" functions of Julia's standard library
(`Base`).  You should be able to define your own array types
(e.g. via the [StaticArrays](https://github.com/JuliaArrays/StaticArrays.jl)
package or [PETSc arrays](https://github.com/JuliaParallel/PETSc.jl))
and functions (such as our `f` above), and have them be capable of fusing vectorized operations.

Moreover, a difficulty with fancy compiler optimizations is that, as a
programmer, you are often unsure whether they will occur.  You have to learn to
avoid coding styles that accidentally prevent the compiler from recognizing
the fusion opportunity (e.g. because you called a "non-built-in" function), you
need to learn to use additional compiler-diagnostic tools to identify which
optimizations are taking place, and you need to continually check these
diagnostics as new versions of the compiler and language are released.  With
vectorized code, losing a fusion optimization may mean wasting an order of
magnitude in memory and time, so you have to worry much more than you would for
a typical compiler micro-optimization.

### Syntactic loop fusion in Julia

In contrast, Julia's approach is quite simple and general: the caller
indicates, by adding dots, which function calls and operators are
intended to be applied elementwise (specifically, as `broadcast` calls).
The compiler notices these dots at *parse time* (or technically
at "lowering" time, but in any case long before it knows
the types of the variables etc.), and transforms them into calls to
`broadcast`.  Moreover, it guarantees that *nested* "dot calls" will
*always* be fused into a single broadcast call, i.e. a single loop.

Put another way, `f.(g.(x .+ 1))` is treated by Julia as merely
[syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar) for
`broadcast(x -> f(g(x + 1)), x)`.   An assignment `y .= f.(g.(x .+ 1))`
is treated as sugar for the in-place operation
`broadcast!(x -> f(g(x + 1)), y, x)`.   The compiler need not prove
that this produces the same result as a corresponding non-fused operation,
because the fusion is a mandatory transformation defined as part
of the language, rather than an optional optimization.

Arbitrary user-defined functions `f(x)` work with this mechanism,
as do arbitrary user-defined collection types for `x`, as long as you
define `broadcast` methods for your collection.  (The default
`broadcast` already works for any subtype of `AbstractArray`.)

Moreover, dotted operators are now available for not just
the familiar ASCII operators like `.+`, but for *any*
character that Julia parses as a binary operator.  This includes
a wide array of Unicode symbols like `⊗`, `∪`, and `⨳`, most
of which are undefined by default.   So, for example, if you
define `⊗(x,y) = kron(x,y)` for the [Kronecker product](https://en.wikipedia.org/wiki/Kronecker_product),
you can immediately do `[A, B] .⊗ [C, D]` to compute the
"elementwise" operation `[A ⊗ C, B ⊗ D]`, because `x .⊗ y`
is sugar for `broadcast(⊗, x, y)`.

Note that "side-by-side" binary operations are actually equivalent
to nested calls, and hence they fuse for dotted operations.   For
example `3 .* x .+ y` is equivalent to `(+).((*).(3, x), y)`, and
hence it fuses into `broadcast((x,y) -> 3*x+y, x, y)`.   Note
also that the fusion stops only when a "non-dot" call is encountered,
e.g. `sqrt.(abs.(sort!(x.^2)))` fuses the `sqrt` and `abs` operations
into a single loop, but `x.^2` occurs in a separate loop (producing
a temporary array) because of the intervening non-dot function call
`sort!(...)`.

### Other partway solutions

For the sake of completeness, we should mention
some other possibilities that would partly
address the problems of vectorization.  For example, functions could
be specially [annotated to declare that they are pure](https://github.com/JuliaLang/julia/issues/414),
one could specially annotate container types with
array-like semantics, etcetera, to help the compiler recognize the
possibility of fusion.   But this imposes a lot of requirements
on library authors, and once again it requires them to identify
in advance which functions are likely to be applied to vectors
(and hence be worth the additional analysis and annotation effort).

Another approach that has been suggested is to define updating operators
like `x += y` to be equivalent to calls to a special function,
like `x = plusequals!(x, y)`, that can be defined as an in-place operation, rather
than `x += y` being a synonym for `x = x + y` as in Julia today.
([NumPy does this](https://docs.python.org/3.3/reference/datamodel.html#object.__iadd__).)
By itself, this can be used to [avoid temporary arrays in some simple cases](http://blog.svenbrauch.de/2016/04/13/processing-scientific-data-in-python-and-numpy-but-doing-it-fast/) by breaking them into a sequence of in-place updates, but
it doesn't handle more complex expressions, is limited to a few
operations like `+`, and doesn't address the cache inefficiency of
multiple loops.   (In Julia 0.6, you can do `x .+= y` and it is
equivalent to `x .= x .+ y`, which does a single fused loop in-place,
but this syntax now extends to arbitrary combinations of arbitrary functions.)

## Should other languages implement syntactic loop fusion?

Obviously, Julia's approach of syntactic loop fusion relies partly on the
fact that, as a young language, we are still relatively free to
redefine core syntactic elements like `f.(x)` and `x .+ y`.  But
suppose you were willing to add this or similar syntax to an
existing language, like Python or Go, or create a DSL add-on on top of those
languages as discussed above; would you then be able to
implement the same fusing semantics efficiently?

There is a catch: `2 .* x .+ x .^ 2` is sugar for
`broadcast(x -> 2*x + x^2, x)` in Julia, but for this to be
fast we need the [higher-order function](https://en.wikipedia.org/wiki/Higher-order_function)
`broadcast` to be very fast as well.  First, this
requires that arbitrary user-defined scalar (non-vectorized!) functions like
`x -> 2*x + x^2` be compiled to fast code, which is often a challenge
in high-level dynamic languages.   Second, it ideally requires that
higher-order functions like `broadcast` be able to [inline](https://en.wikipedia.org/wiki/Inline_expansion)
the function argument `x -> 2*x + x^2`, and this facility is even
less common.  (It wasn't available in Julia until version 0.5.)

Also, the ability of `broadcast` to combine arrays and scalars or
arrays of different shapes (see below) turns out to be subtle to
implement efficiently without losing generality. The current
implementation relies on a metaprogramming feature that Julia provides
called [generated functions](https://docs.julialang.org/en/v1/manual/metaprogramming/#Generated-functions-1)
in order to get compile-time specialization on the number and types of
the arguments.  An alternative solution to the inlining and
specialization issues would be to build the `broadcast` function into
the compiler, but then you might lose the ability of `broadcast` to be
overloadable for user-defined containers, nor could users write their
own higher-order functions with similar functionality.

### The importance of higher-order inlining

In particular, consider
a naive implementation of `broadcast` (only for one-argument functions):

```julia
function naivebroadcast(f, x)
    y = similar(x)
    for i in eachindex(x)
        y[i] = f(x[i])
    end
    return y
end
```

In Julia, as in other languages, `f` must be some kind of [function
pointer](https://en.wikipedia.org/wiki/Function_pointer) or [function
object](https://en.wikipedia.org/wiki/Function_object). Normally, a call
`f(x[i])` to a function object `f` must figure out where the actual [machine
code](https://en.wikipedia.org/wiki/Machine_code) for the function is (in Julia,
this involves dispatching on the type of `x[i]`; in object-oriented languages,
it might involve dispatching on the type of `f`), push the argument `x[i]`
etcetera to `f` via a register and/or a [call stack](https://en.wikipedia.org/wiki/Call_stack),
jump to the machine instructions to execute them, jump back to
the caller `naivebroadcast`, and extract the return value.
That is, calling a function argument `f` involves some overhead beyond
the cost of the computations inside `f`.

If `f(x)` is expensive enough, then the overhead of the function call may be negligible,
but for a cheap function like `f(x) = 2*x + x^2` the overhead can be very
significant: with Julia 0.4, the overhead is roughly a factor of two compared
to a hand-written loop that evaluates `z = x[i]; y[i] = 2*z + z^2`.     Since lots
of vectorized code in practice evaluates relatively cheap functions like this,
it would be a big problem for a generic vectorization method based on `broadcast`.  (The function call also inhibits [SIMD optimization](https://software.intel.com/en-us/articles/vectorization-in-julia)
by the compiler, which prevents computations in `f(x)` from
being applied simultaneously to several `x[i]`
elements.)

However, [in Julia 0.5, every function has its own type](/blog/2016/10/julia-0.5-highlights/#functions).  And, in Julia,
whenever you call a function like `naivebroadcast(f, x)`, a *specialized version*
of `naivebroadcast` is compiled for `typeof(f)` and `typeof(x)`.   Since
the compiled code is specific to `typeof(f)`, i.e. to the specific function
being passed, the Julia compiler is free to [inline](https://en.wikipedia.org/wiki/Inline_expansion) `f(x)` into the generated code
if it wants to, and all of the function-call overhead can disappear.

Julia is neither the first nor the only language that can inline
higher-order functions; e.g. it is reportedly [possible in Haskell](https://stackoverflow.com/questions/25566517/can-haskell-inline-functions-passed-as-an-argument) and in
the [Kotlin](https://kotlinlang.org/docs/reference/inline-functions.html) language.
Nevertheless, it seems to be a rare feature, especially in [imperative languages](https://en.wikipedia.org/wiki/Imperative_programming). Fast
higher-order functions are a key ingredient of Julia that allows
a function like `broadcast` to be written in Julia itself (and
hence be extensible to user-defined containers), rather than having
to be built in to the compiler (and probably limited to "built-in" container types).

## Not just elementwise math: The power of broadcast

Dot calls correspond to the `broadcast` function in Julia.  Broadcasting
is a powerful concept (also found, for example, in [NumPy](https://docs.scipy.org/doc/numpy/user/basics.broadcasting.html) and
[Matlab](https://www.mathworks.com/help/matlab/ref/bsxfun.html)) in which
the concept of "elementwise" operations is extended to encompass combining
arrays of different shapes or arrays and scalars.   Moreover, this is
not limited to arrays of numbers, and starting in Julia 0.6 a
"scalar" in a `broadcast` context can be an object of an arbitrary type.

### Combining containers of different shapes

You may have noticed that the examples above included expressions like
`6 .* X.^3` that combine an array (`X`) with scalars (`6` and `3`).
Conceptually, in `X.^3` the scalar `3` is "expanded" (or "broadcasted")
to match the size of `X`, as if it became an array `[3,3,3,...]`,
before performing `^` elementwise.  In practice of course, no array
of `3`s is ever explicitly constructed.

More generally, if you combine two arrays of different dimensions or shapes,
any "singleton" (length 1) or missing dimension of one array is "broadcasted"
across that dimension of the other array.   For example, `A .+ [1,2,3]`
adds `[1,2,3]` to *each column* of a 3×*n* matrix `A`.   Another typical
example is to combine a row vector (or a 1×*n* array) and a column vector to make a matrix
(2d array):

```julia
julia> [1 2 3] .+ [10,20,30]
3×3 Array{Int64,2}:
 11  12  13
 21  22  23
 31  32  33
```

(If `x` is a row vector, and `y` is a column vector, then `A = x .+ y` makes
a matrix with `A[i,j] = x[j] + y[i]`.)

Although other languages have also implemented similar `broadcast` semantics,
Julia is unusual in being able to support such operations for *arbitrary* user-defined
functions and types with *performance comparable to hand-written C* loops, even though
its `broadcast` function is written *entirely in Julia* with no special support
from the compiler.   This not only requires efficient compilation and
higher-order inlining as mentioned above, but also the ability
to [efficiently iterate over arrays of arbitrary dimensionalities](/blog/2016/02/iteration/) determined
at compile-time for each caller.

### Not just numbers

Although the examples above were all for numeric computations, in fact
neither the `broadcast` function nor the dot-call fusion syntax is limited
to numeric data.  For example:

```julia
julia> s = ["The QUICK Brown", "fox     jumped", "over the LAZY dog."];

julia> s .= replace.(lowercase.(s), r"\s+", "-")
3-element Array{String,1}:
 "the-quick-brown"
 "fox-jumped"
 "over-the-lazy-dog."
```

Here, we take an array `s` of strings, we convert each string to
lower case, and then we replace any sequence of whitespace (the [regular expression](https://docs.julialang.org/en/v1/manual/strings/#Regular-Expressions)
`r"\s+"`) with a hyphen `"-"`.  Since these two dot calls are nested,
they are fused into a single loop over `s` and are written in-place in `s`
thanks to the `s .= ...` (temporary *strings* are allocated in this process,
but not temporary *arrays* of strings).   Furthermore, notice that the
arguments `r"\s+"` and `"-"` are treated as "scalars" and are "broadcasted"
to every element of `s`.

The general rule (starting in Julia 0.6) is that, in `broadcast`, arguments of *any type* are
*treated as scalars by default*.  The main exceptions are arrays (subtypes of
`AbstractArray`) and tuples, which are treated as containers and are iterated
over.  (If you define your own container type that is not a subtype of
`AbstractArray`, you can tell `broadcast` to treat it as a container to
be iterated over by overloading `Base.Broadcast.containertype` and a
couple of other functions.)

### Not just containers

Since the dot-call syntax corresponds to `broadcast`, and `broadcast` is just an
ordinary Julia function to which you can add your own methods (as opposed to
some kind of privileged compiler built-in), many possibilities open up.  Not
only can you extend fusing dot calls to your own data structures (e.g.
[DistributedArrays](https://github.com/JuliaParallel/DistributedArrays.jl)
extends `broadcast` to work for arrays
[distributed](https://en.wikipedia.org/wiki/Distributed_memory) across multiple
computers), but you can apply the same syntax to data types that are *hardly
"containers" at all*.

For example, the [ApproxFun](https://github.com/JuliaApproximation/ApproxFun.jl)
package defines an object called a `Fun` that represents a numerical
approximation of a user-defined function (essentially, a `Fun` is a fancy
polynomial fit). By defining [`broadcast` methods for
`Fun`](https://github.com/JuliaApproximation/ApproxFun.jl/issues/356), you can
now take an `f::Fun` and do, for example, `exp.(f.^2 .+ f.^3)` and it will
translate to `broadcast(y -> exp(y^2 + y^3), f)`.  This `broadcast` call, in
turn, will evaluate `exp(y^2 + y^3)` for `y = f(x)` at cleverly selected `x`
points, construct a polynomial fit, and return a new `Fun` object representing
the fit. (Conceptually, this replaces *elementwise* operations on containers
with *pointwise* operations on functions.) In contrast, ApproxFun also allows
you to compute the same result using `exp(f^2 + f^3)`, but in this case it will go
through the fitting process *four times* (constructing four `Fun` objects), once
for each operation like `f^2`, and is more than an order of magnitude slower
due to this lack of fusion.

### broadcast vs. map

Finally, it is instructive to compare `broadcast` with `map`, since `map` *also*
applies a function elementwise to one or more arrays.   (The dot-call
syntax invokes `broadcast`, not `map`.) The basic differences are:

* `broadcast` handles only *containers with "shapes"* M×N×⋯ (i.e., a `size` and dimensionality), whereas `map`
  handles "shapeless" containers like `Set` or iterators of
  unknown length like `eachline(file)`.

* `map` requires all arguments to have the *same length* (and
  hence cannot combine arrays and scalars) and (for array containers) the same shape, whereas `broadcast` does
  not (it can "expand" smaller containers to match larger ones).

* `map` treats all arguments as *containers by default*, and in particular
  expects its arguments to [act as iterators](https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-iteration-1).
  In contrast, `broadcast` treats its arguments as *scalars by default* (i.e., as 0-dimensional arrays
  of one element), except for a few types like `AbstractArray` and `Tuple`
  that are explicitly declared to be broadcast containers.

Sometimes, of course, their behavior coincides, e.g. `map(sqrt, [1,2,3])` and
`sqrt.([1,2,3])` give the same result.  But, in general, neither `map`
nor `broadcast` generalizes the other — each has things they can do that
the other cannot.

[notebook]: /assets/blog/moredots/More-Dots.ipynb
