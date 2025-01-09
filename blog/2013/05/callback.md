@def rss_pubdate = Date(2013, 5, 10)
@def rss_description = """ Passing Julia Callback Functions to C | One of the great strengths of Julia is that it is so easy to call C... """
@def published = "10 May 2013"
@def title = "Passing Julia Callback Functions to C"
@def authors = """<a href="https://math.mit.edu/~stevenj">Steven G. Johnson</a>"""
@def hascode = true


One of the great strengths of Julia is that it is so easy to [call C
code](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/#) natively, with no special "glue" routines or overhead to marshal
arguments and convert return values.  For example, if you want to call
[GNU GSL](https://www.gnu.org/software/gsl/) to compute a special function
like a [Debye integral](https://www.gnu.org/software/gsl/doc/html/specfunc.html#c.gsl_sf_debye_1), it is as easy as:

```
debye_1(x) = ccall((:gsl_sf_debye_1,:libgsl), Cdouble, (Cdouble,), x)
```

at which point you can compute `debye_1(2)`, `debye_1(3.7)`, and so
on.  (Even easier would be to use Jiahao Chen's
[GSL package](https://github.com/jiahao/GSL.jl) for Julia, which has
already created such wrappers for you.)  This makes a vast array of
existing C libraries accessible to you in Julia (along with Fortran
libraries and other languages with C-accessible calling conventions).

In fact, you can even go the other way around, passing Julia routines
to C, so that C code is calling Julia code in the form of *callback*
functions.   For example, a C library for numerical integration might
expect you to pass the integrand as a *function* argument, which the
library will then call to evaluate the integrand as many times as
needed to estimate the integral.  Callback functions are also natural
for optimization, root-finding, and many other numerical tasks, as well
as in many non-numerical problems.  The purpose of this blog post is to
illustrate the techniques for passing Julia functions as callbacks to
C routines, which is straightforward and efficient but requires some
lower-level understanding of how functions and other values are passed as
arguments.

The code in this post requires Julia 0.2 (or a recent `git` facsimile
thereof); the key features needed for callback functions (especially
`unsafe_pointer_to_objref`) are not available in Julia 0.1.

## Sorting with `qsort`

Perhaps the most well-known example of a callback parameter is
provided by the
[qsort](https://pubs.opengroup.org/onlinepubs/009695399/functions/qsort.html)
function, part of the ANSI C standard library and declared in C as:

```julia
void qsort(void *base, size_t nmemb, size_t size,
           int(*compare)(const void *a, const void *b));
```

The `base` argument is a pointer to an array of length `nmemb`, with
elements of `size` bytes each.  `compare` is a callback function which
takes pointers to two elements `a` and `b` and returns an integer
less/greater than zero if `a` should appear before/after `b` (or zero
if any order is permitted).  Now, suppose that we have a 1d array `A`
of values in Julia that we want to sort using the `qsort` function
(rather than Julia's built-in `sort` function).  Before we worry about
calling `qsort` and passing arguments, we need to write a comparison
function that works for some arbitrary type `T`, e.g.

```julia
function mycompare{T}(a_::Ptr{T}, b_::Ptr{T})
    a = unsafe_load(a_)
    b = unsafe_load(b_)
    return a < b ? cint(-1) : a > b ? cint(+1) : cint(0)
end
cint(n) = convert(Cint, n)
```

Notice that we use the built-in function `unsafe_load` to fetch the
values pointed to by the arguments `a_` and `b_` (which is "unsafe"
because it will crash if these are not valid pointers, but `qsort`
will always pass valid pointers).  Also, we have to be a little
careful about return values: `qsort` expects a function returning a C
`int`, so we must be sure to return `Cint` (the corresponding type in
Julia) via a call to `convert`.

Now, how do we pass this to C?  A function pointer in C is essentially
just a pointer to the memory location of the machine code implementing
that function, whereas a function value `mycompare` (of type
`Function`) in Julia is quite different.  Thanks to Julia's [JIT
compilation](https://en.wikipedia.org/wiki/Just-in-time_compilation)
approach,a Julia function may not even be *compiled* until the first
time it is called, and in general the *same* Julia function may be
compiled into *multiple* machine-code instantiations, which are
specialized for arguments of different types (e.g. different `T` in
this case).  So, you can imagine that `mycompare` must internally
point to a rather complicated data structure (a `jl_function_t` in
`julia.h`, if you are interested), which holds information about the
argument types, the compiled versions (if any), and so on.  In
general, it must store a
[closure](https://en.wikipedia.org/wiki/Closure_%28computer_science%29)
with information about the environment in which the function was
defined; we will talk more about this below.  In any case, it is a
very different object than a simple pointer to machine code for one
set of argument types.  Fortunately, we can get the latter simply by
calling a [built-in Julia function](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/#Closure-cfunctions-1) called `cfunction`:

```julia
const mycompare_c = cfunction(mycompare, Cint, (Ptr{Cdouble}, Ptr{Cdouble}))
```

Here, we pass `cfunction` three arguments: the function `mycompare`,
the return type `Cint`, and a tuple of the argument types, in this case to
sort an array of `Cdouble` (`Float64`) elements.  Julia compiles a version of
`mycompare` specialized for these argument types (if it has not done
so already), and returns a `Ptr{Void}` holding the address of the
machine code, *exactly* what we need to pass to `qsort`.  We are
now ready to call `qsort` on some sample data:

```julia
A = [1.3, -2.7, 4.4, 3.1]
ccall(:qsort, Void, (Ptr{Cdouble}, Csize_t, Csize_t, Ptr{Void}),
      A, length(A), sizeof(eltype(A)), mycompare_c)
```

After this executes, `A` is changed to the sorted array `[ -2.7, 1.3,
3.1, 4.4]`.  Note that Julia knows how to convert an array
`A::Vector{Cdouble}` into a `Ptr{Cdouble}`, how to compute the `sizeof`
a type in bytes (identical to C's `sizeof` operator), and so on.  For fun,
try inserting a `println("mycompare($a,$b)")` line into mycompare, which
will allow you to see the comparisons that `qsort` is performing (and to verify
that it is really calling the Julia function that you passed to it).

## The problem with closures

We aren't done yet, however.  If you start passing callback functions to
C routines, it won't be long before you discover that `cfunction` doesn't
always work.  For example, suppose we tried to declare our comparison
function inline, via:

```julia
mycomp = cfunction((a_,b_) -> unsafe_load(a_) < unsafe_load(b_) ?
                              cint(-1) : cint(+1),
                   Cint, (Ptr{Cdouble}, Ptr{Cdouble}))
```

Julia barfs on this, printing `ERROR: function is not yet c-callable`.  In
general, `cfunction` only works for "top-level" functions: named
functions defined in the top-level (global or module) scope, but *not*
anonymous (`args -> value`) functions and not functions defined within
other functions ("nested" functions).  The reason for this stems from
one important concept in computer science: a
[closure](https://en.wikipedia.org/wiki/Closure_%28computer_science%29).

To understand the need for closures, and the difficulty they pose for
callback functions, suppose that we wanted to provide a nicer interface
for qsort, one which permitted the user to simply pass a `lessthan` function
returning `true` or `false` while hiding all of the low-level business with
pointers, `Cint`, and so on.  We might *like* to do something of the form:

```julia
function qsort!{T}(A::Vector{T}, lessthan::Function)
    function mycompare(a_::Ptr{T}, b_::Ptr{T})
        a = unsafe_load(a_)
        b = unsafe_load(b_)
        return lessthan(a, b) ? cint(-1) : cint(+1)
    end
    mycompare_c = cfunction(mycompare, Cint, (Ptr{T}, Ptr{T}))
    ccall(:qsort, Void, (Ptr{T}, Csize_t, Csize_t, Ptr{Void}),
          A, length(A), sizeof(T), mycompare_c)
    A
end
```

Then we could simply call `qsort!([1.3, -2.7, 4.4, 3.1], <)` to sort
in ascending order using the built-in `<` comparison, or any other
comparison function we wanted.  Unfortunately `cfunction` will again
barf when you try to call `qsort!`, and it is no longer so difficult
to understand why.  Notice that the nested `mycompare` function is no
longer self-contained: it uses the variable `lessthan` from the
surrounding scope.  This is a common pattern for nested functions and
anonymous functions: often, they are parameterized by local variables
in the environment where the function is defined.  Technically, the
ability to have this kind of dependency is provided by [lexical
scoping](https://en.wikipedia.org/wiki/Scope_%28computer_science%29) in
a programming language like Julia, and is typical of any language in
which functions are
"[first-class](https://en.wikipedia.org/wiki/First-class_function)"
objects.  In order to support lexical scoping, a Julia `Function`
object needs to internally carry around a pointer to the variables in
the enclosing environment, and this encapsulation is called a
*closure*.

In contrast, a C function pointer is *not* a closure.  It doesn't
enclose a pointer to the environment in which the function was
defined, or anything else for that matter; it is just the address of a
stream of instructions.  This makes it hard, in C, to write functions
to transform other functions ([higher-order
functions](https://en.wikipedia.org/wiki/Higher-order_function)) or to
parameterize functions by local variables.  This apparently leaves us
with two options, neither of which is especially attractive:

* We could store `lessthan` in a global variable, and reference that
  from a top-level `mycompare` function.  (This is the traditional solution
  for C programmers calling `qsort` with parameterized comparison functions.)
  The problem with this strategy is that it is not [re-entrant](https://en.wikipedia.org/wiki/Reentrancy_%28computing%29): it prevents us from calling `qsort!`
  recursively (e.g. if the comparison function itself needs to do a sort, for
  some complicated datastructure), or from calling `qsort!` from multiple
  threads (when a future Julia version supports shared-memory parallelism).
  Still, this is better than nothing.

* Every time `qsort!` is called, Julia could JIT-compile a new version
  of `mycompare`, which hard-codes the reference to the `lessthan`
  argument passed on that call.  This is technically possible and has
  been implemented in some languages (e.g. reportedly [GNU
  Guile](https://www.gnu.org/software/guile/manual/html_node/Dynamic-FFI.html)
  and [Lua](https://luajit.org/ext_ffi_semantics.html)
  do something like this).  However, this strategy
  comes at a price: it requires that callbacks be recompiled every time
  a parameter in them changes, which is not true of the global-variable
  strategy.  Anyway, it is not implemented yet in Julia.

Fortunately, there is often a *third* option, because C programmers
long ago recognized these limitations of function pointers, and
devised a workaround: most modern C callback interfaces allow
arbitrary data to be passed through to the callback via a
"pass-through" (or "thunk") pointer parameter.  As explained in the
next section, we can exploit this technique in Julia to pass a "true"
closure as a callback.

## Passing closures via pass-through pointers

The `qsort` interface is nowadays considered rather antiquated.  Years
ago, it was supplemented on BSD-Unix systems, and eventually in GNU
libc, by a function called `qsort_r` that solves the problem of passing
parameters to the callback in a re-entrant way.  This is how the BSD (e.g. MacOS)
`qsort_r` function [is defined](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/qsort_r.3.html):

```julia
void qsort_r(void *base, size_t nmemb, size_t size, void *thunk,
             int (*compare)(void *thunk, const void *a, const void *b));
```

Compared to `qsort`, there is an extra `thunk` parameter, and this is
*passed through* to the `compare` function as its first argument.  In this
way, you can pass a pointer to *arbitrary* data through to your callback,
and we can exploit this to pass a closure through for an arbitrary Julia
callback.

All we need is a way to convert a Julia `Function` into an opaque
`Ptr{Void}` so that we can pass it through to our callback, and then a
way to convert the opaque pointer back into a `Function`.  The former
is automatic if we simply declare the `ccall` argument as type `Any`
(which passes the argument as an opaque Julia object pointer), and the
latter is accomplished by the built-in function
`unsafe_pointer_to_objref`.  (Technically, we could use type
`Function` or an explicit call to `pointer_from_objref` instead of
`Any`.)  Using these, we can now define a working high-level `qsort!`
function that takes an arbitrary `lessthan` comparison-function
argument:

```julia
function qsort!_compare{T}(lessthan_::Ptr{Void}, a_::Ptr{T}, b_::Ptr{T})
    a = unsafe_load(a_)
    b = unsafe_load(b_)
    lessthan = unsafe_pointer_to_objref(lessthan_)::Function
    return lessthan(a, b) ? cint(-1) : cint(+1)
end

function qsort!{T}(A::Vector{T}, lessthan::Function=<)
    compare_c = cfunction(qsort!_compare, Cint, (Ptr{Void}, Ptr{T}, Ptr{T}))
    ccall(:qsort_r, Void, (Ptr{T}, Csize_t, Csize_t, Any, Ptr{Void}),
          A, length(A), sizeof(T), lessthan, compare_c)
    return A
end
```

`qsort!_compare` is a top-level function, so `cfunction` has no
problem with it, and it will only be compiled once per type `T` to be
sorted (rather than once per call to `qsort!` or per `lessthan`
function).  We use the explicit `::Function` assertion to tell
the compiler that we will only pass `Function` pointers in
`lessthan_`. Note that we gave the `lessthan` argument a default value
of `<` (default arguments being a [recent
feature](https://github.com/JuliaLang/julia/issues/1817) added to
Julia).

We can now do `qsort!([1.3, -2.7, 4.4, 3.1])` and it will
return the array sorted in ascending order, or `qsort!([1.3, -2.7,
4.4, 3.1], >)` to sort in descending order.

#### Warning: `qsort_r` is not portable

The example above has one major problem that has nothing to do with
Julia: the `qsort_r` function is not portable.  The above example
won't work on Windows, since the Windows C library doesn't define
`qsort_r` (instead, it has a function called
[qsort_s](https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/qsort-s?view=vs-2019),
which of course uses an argument order incompatible with *both* the
BSD and GNU `qsort_r` functions).  Worse, it will crash on GNU/Linux
systems, which *do* provide `qsort_r` but with an
[incompatible](https://www.memoryhole.net/kyle/2009/11/qsort_r.html)
[calling
convention](https://www.cygwin.com/ml/libc-alpha/2008-12/msg00008.html). And
as a result it is difficult to use `qsort_r` in a way that does not
crash either on GNU/Linux or BSD (e.g. MacOS) systems.  This is how
glibc's `qsort_r` is defined:

```julia
void qsort_r(void *base, size_t nmemb, size_t size,
             int (*compare)(const void *a, const void *b, void *thunk),
              void *thunk);
```

Note that the position of the `thunk` argument is moved, both in `qsort_r` itself and
in the comparison function.   So, the corresponding `qsort!` Julia code on
GNU/Linux systems should be:

```julia
function qsort!_compare{T}(a_::Ptr{T}, b_::Ptr{T}, lessthan_::Ptr{Void})
    a = unsafe_load(a_)
    b = unsafe_load(b_)
    lessthan = unsafe_pointer_to_objref(lessthan_)::Function
    return lessthan(a, b) ? cint(-1) : cint(+1)
end

function qsort!{T}(A::Vector{T}, lessthan::Function=<)
    compare_c = cfunction(qsort!_compare, Cint, (Ptr{T}, Ptr{T}, Ptr{Void}))
    ccall(:qsort_r, Void, (Ptr{T}, Csize_t, Csize_t, Ptr{Void}, Any),
          A, length(A), sizeof(T), compare_c, lessthan)
    return A
end
```

If you really needed to call `qsort_r` from Julia, you could use the
above definitions if `OS_NAME == :Linux` and the BSD definitions
otherwise, with a third version using `qsort_s` on Windows, but
fortunately there is not much need as Julia comes with its own
perfectly adequate `sort` and `sort!` routines.

## Passing closures in data structures

As another example that is oriented more towards numerical
computations, we'll examine how we might call the numerical integration
routines in the [GNU Scientific Library
(GSL)](https://www.gnu.org/software/gsl/).  There is already a [GSL
package](https://github.com/jiahao/GSL.jl) that handles the wrapper
work below for you, but it is instructive to look at how this is
implemented because GSL simulates closures in a slightly different
way, with data structures.

Like most modern C libraries accepting callbacks, GSL uses a `void*` pass-through
parameter to allow arbitrary data to be passed through to the callback routine,
and we can use that to support arbitrary closures in Julia.   Unlike `qsort_r`,
however, GSL wraps both the C function pointer and the pass-through pointer in
a data structure called `gsl_function`:

```
struct {
    double (*function)(double x, void *params);
    void *params;
} gsl_function;
```

Using the techniques above, we can easily declare a `GSL_Function` type in Julia
that mirrors this C type, and with a constructor `GSL_Function(f::Function)` that
creates a wrapper around an arbitrary Julia function `f`:

```julia
function gsl_function_wrap(x::Cdouble, params::Ptr{Void})
    f = unsafe_pointer_to_objref(params)::Function
    convert(Cdouble, f(x))::Cdouble
end
const gsl_function_wrap_c = cfunction(gsl_function_wrap,
                                      Cdouble, (Cdouble, Ptr{Void}))

type GSL_Function
    func::Ptr{Void}
    params::Any
    GSL_Function(f::Function) = new(gsl_function_wrap_c, f)
end
```

One subtlety with the above code is that we need to explicitly
`convert` the return value of `f` to a `Cdouble` (in case the caller's
code returns some other numeric type for some `x`, such as an `Int`).
Moreover, we need to explicitly assert (`::Cdouble`) that the result
of the `convert` was a `Cdouble`.  As with the `qsort` example, this
is because `cfunction` only works if Julia can guarantee that
`gsl_function_wrap` returns the specified `Cdouble` type, and
Julia cannot infer the return type of `convert` since it does not
know the return type of `f(x)`.

Given the above definitions, it is a simple matter to pass this to the
[GSL
adaptive-integration](https://www.gnu.org/software/gsl/manual/html_node/QAG-adaptive-integration.html)
routines in a wrapper function `gsl_integration_qag`:

```julia
function gsl_integration_qag(f::Function, a::Real, b::Real, epsrel::Real=1e-12,
                             maxintervals::Integer=10^7)
    s = ccall((:gsl_integration_workspace_alloc,:libgsl), Ptr{Void}, (Csize_t,),
              maxintervals)
    result = Array(Cdouble,1)
    abserr = Array(Cdouble,1)
    ccall((:gsl_integration_qag,:libgsl), Cint,
          (Ptr{GSL_Function}, Cdouble,Cdouble, Cdouble, Csize_t, Cint, Ptr{Void},
           Ptr{Cdouble}, Ptr{Cdouble}),
          &GSL_Function(f), a, b, epsrel, maxintervals, 1, s, result, abserr)
    ccall((:gsl_integration_workspace_free,:libgsl), Void, (Ptr{Void},), s)
    return (result[1], abserr[1])
end
```

Note that `&GSL_Function(f)` passes a pointer to a `GSL_Function`
"struct" containing a pointer to `gsl_function_wrap_c` and `f`, corresponding
to the `gsl_function*` argument in C.  The return value is a tuple of the estimated
integral and an estimated error.

For example, `gsl_integration_qag(cos, 0, 1)` returns
`(0.8414709848078965,9.34220461887732e-15)`, which computes the
correct integral `sin(1)` to machine precision.

## Taking out the trash (or not)

In the above examples, we pass an opaque pointer (object reference) to a
Julia `Function` into C.  Whenever one passes pointers to Julia data into C
code, one has to ensure that the Julia data is not garbage-collected until
the C code is done with it, and functions are no exception to this rule.
An anonymous function that is no longer referred to by any Julia variable
may be garbage collected, at which point any C pointers to it become invalid.

This sounds scary, but in practice you don't need to worry about it very often,
because Julia guarantees that `ccall` arguments won't be garbage-collected until
the `ccall` exits.  So, in all of the above examples, we are safe: the `Function`
only needs to live as long as the `ccall`.

The only danger arises when you pass a function pointer to C and the C code
*saves the pointer* in some data structure which it will use in a *later* `ccall`.
In that case, you are responsible for ensuring that the `Function` variable lives
(is referred to by some Julia variable) as long as the C code might need it.

For example, in the GSL [one-dimensional minimization
interface](https://www.gnu.org/software/gsl/manual/html_node/One-dimensional-Minimization.html),
you don't simply pass your objective function to a minimization
routine and wait until it is minimized.  Instead, you call a GSL
routine to create a "minimizer object", store your function pointer in this
object, call routines to iterate the minimization, and then deallocate the
minimizer when you are done.  The Julia function must not be garbage-collected
until this process is complete.  The easiest way to ensure this is to create
a Julia wrapper type around the minimizer object that stores an *explicit*
reference to the Julia function, like this:

```julia
type GSL_Minimizer
    m::Ptr{Void} # the gsl_min_fminimizer pointer
    f::Any  # explicit reference to objective, to prevent garbage-collection
    function GSL_Minimizer(t)
       m = ccall((:gsl_min_fminimizer_alloc,:libgsl), Ptr{Void}, (Ptr{Void},), t)
       p = new(m, nothing)
       finalizer(p, p -> ccall((:gsl_min_fminimizer_free,:libgsl),
                               Void, (Ptr{Void},), p.m))
       p
    end
end
```

This wraps around a `gsl_min_fminimizer` object of type `t`, with a
placeholder `f` to store a reference to the objective function (once
it is set below), including a `finalizer` to deallocate the GSL object
when the `GSL_Minimizer` is garbage-collected.  The parameter `t` is
used to specify the minimization algorithm, which could default to
Brent's algorithm via:

```julia
const gsl_brent = unsafe_load(cglobal((:gsl_min_fminimizer_brent,:libgsl), Ptr{Void}))
GSL_Minimizer() = GSL_Minimizer(gsl_brent)
```

(The call to `cglobal` yields a pointer to the
`gsl_min_fminimizer_brent` global variable in GSL, which we then
dereference to get the *actual* pointer via `unsafe_load`.)

Then, when we set the function to minimize (the "objective"), we store
an extra reference to it in the `GSL_Minimizer` to prevent
garbage-collection for the lifetime of the `GSL_Minimizer`, again
using the `GSL_Function` type defined above to wrap the callback:

```julia
function gsl_minimizer_set!(m::GSL_Minimizer, f, x0, xmin, xmax)
    ccall((:gsl_min_fminimizer_set,:libgsl), Cint,
          (Ptr{Void}, Ptr{GSL_Function}, Cdouble, Cdouble, Cdouble),
          m.m, &GSL_Function(f), x0, xmin, xmax)
    m.f = f
    m
end
```

There are then various GSL routines to iterate the minimizer and to check the
current `x`, objective value, or bounds on the minimum, which are convenient to wrap:

```julia
gsl_minimizer_iterate!(m::GSL_Minimizer) =
    ccall((:gsl_min_fminimizer_iterate,:libgsl), Cint, (Ptr{Void},), m.m)

gsl_minimizer_x(m::GSL_Minimizer) =
    ccall((:gsl_min_fminimizer_x_minimum,:libgsl), Cdouble, (Ptr{Void},), m.m)

gsl_minimizer_f(m::GSL_Minimizer) =
    ccall((:gsl_min_fminimizer_f_minimum,:libgsl), Cdouble, (Ptr{Void},), m.m)

gsl_minimizer_xmin(m::GSL_Minimizer) =
    ccall((:gsl_min_fminimizer_x_lower,:libgsl), Cdouble, (Ptr{Void},), m.m)
gsl_minimizer_xmax(m::GSL_Minimizer) =
    ccall((:gsl_min_fminimizer_x_upper,:libgsl), Cdouble, (Ptr{Void},), m.m)
```

Putting all of these together, we can minimize a simple function `sin(x)` in
the interval [-3,1], with a starting guess -1, via:

```julia
m = GSL_Minimizer()
gsl_minimizer_set!(m, sin, -1, -3, 1)
while gsl_minimizer_xmax(m) - gsl_minimizer_xmin(m) > 1e-6
    println("iterating at x = $(gsl_minimizer_x(m))")
    gsl_minimizer_iterate!(m)
end
println("found minimum $(gsl_minimizer_f(m)) at x = $(gsl_minimizer_x(m))")
```

After a few iterations, it prints `found minimum -1.0 at x =
-1.5707963269964016`, which is the correct minimum (&minus;&pi;/2) to
about 10 digits.

At this point, I will shamelessly plug my own [NLopt
package](https://github.com/stevengj/NLopt.jl) for Julia, which wraps
around my free/open-source [NLopt](https://nlopt.readthedocs.io/en/latest/) library
to provide many more optimization algorithms than GSL, with perhaps a nicer
interface.   However, the techniques used to pass callback functions to
NLopt are actually quite similar to those used for GSL.

An even more complicated version of these techniques can be found in
the [PyCall package](https://github.com/stevengj/PyCall.jl) to call
Python from Julia.  In order to pass a Julia function to Python, we
again use `cfunction` on a wrapper function that handles the type
conversions and so on, and pass the actual Julia closure through via a
pass-through pointer.  But in that case, the pass-through pointer
consists of a Python object that has been created with a new type that
allows it to wrap a Julia object, and garbage-collection is deferred
by storing the Julia object in a global dictionary of saved objects
(removing it via the Python destructor of the new type).  That is all
somewhat tricky stuff and beyond the scope of this blog post; I only
mention it to illustrate the fact that it is possible to implement
quite complex inter-language calling behaviors purely in Julia by
building on the above techniques.
