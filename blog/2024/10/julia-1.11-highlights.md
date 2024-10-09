+++
mintoclevel = 2
maxtoclevel = 3
title = "Julia 1.11 Highlights"
authors = "The Julia contributors"
published = "8 October 2024"
rss_pubdate = Date(2024, 10, 08)
rss = """Highlights of the Julia 1.11 release."""
+++

After two alphas, two betas, and four release candidates, Julia version 1.11 has finally(!!!) been released. We want to thank all the contributors to this release and all the testers who helped find regressions and issues in the pre-releases. Without you, this release would not have been possible.

The full list of changes can be found in the [NEWS file](https://github.com/JuliaLang/julia/blob/release-1.11/NEWS.md), but here we'll give a more in-depth overview of some of the release highlights.

@@announcement
**1.10 becomes LTS** A quick note about 1.10 first. With the release of 1.11, 1.10 becomes the LTS version,
which was previously 1.6. Consider using the new `lts` version specifier with
[juliaup](https://julialang.org/downloads) and the
[julia-actions/setup-julia](https://github.com/julia-actions/setup-julia#examples) github action.
@@

\toc

# `Array` now implemented in Julia, new `Memory` type
*Jameson Nash* , *Oscar Smith*

Prior to Julia 1.11, `Array` was a special object in Julia. Operations like resizing and creation had to be done completely in C, which created overhead and made some of the code much harder to write and difficult for the compiler to optimize. `Array` also had some features that were unnecessary for some uses (e.g. resizing and multiple dimensions) which imposed a small cost. To fix this, in https://github.com/JuliaLang/julia/pull/51319, we added a new, lower level `Memory` type, which allowed re-implementing all of `Array` in Julia code on top of it. This moved much of the complexity around resizing and copying an array into pure Julia code. And it allowed a few important data types, that don’t need all of `Array`’s features (such as `Dict`), to avoid a small amount of overhead. This has led to some great performance improvements. For example, `push!` on Array is now roughly ~2x faster, and several types in Base now use slightly less memory.

This new feature was presented at JuliaCon and can be seen [here](https://www.youtube.com/watch?v=L6BFQ1d8xNs).


# New `public` keyword
*Lilith Hafner*

In previous Julia versions, there was no "programmatic way" of knowing if an unexported name was considered part of the public API or not.
Instead, the guideline was basically that if it was not in the manual then it was not public which was a bit underwhelming.
To remedy that, there is now a `public` keyword in Julia that can be used to indicate that an unexported name is part of the public API.
Whether a name is public or not can now be checked with the (public) method `Base.ispublic(m::Module, name::Symbol)`, and this is for example used by
the help system in the REPL to indicate if a documented name is non-public:

```
help?> GC.in_finalizer
  │ Warning
  │
  │  The following bindings may be internal; they may change or be removed in future versions:
  │
  │    •  Base.GC.in_finalizer

  GC.in_finalizer()::Bool

  Returns true if the current task is running a finalizer, returns false otherwise. Will also return false within a finalizer which was inlined by the compiler's eager finalization optimization, or if finalize is called on the finalizer
  directly.
```

This new feature was presented at JuliaCon and can be seen [here](https://www.youtube.com/watch?v=2o8MhoN-3NE)


# Manifest versioning
*Ian Butterworth*

`Manifest.toml` files can now be renamed in the format `Manifest-v{major}.{minor}.toml`
to be preferentially picked up by the given julia version. i.e. in the same folder,
a `Manifest-v1.11.toml` would be used by v1.11 and `Manifest.toml` by every other julia
version. This makes managing environments for multiple julia versions at the same time easier.
To create such a manifest it is recommended rename an already generated manifest, rather than start
with an empty file.

# Improved tab completion and hinting in the REPL
*Ian Butterworth*, *Shuhei Kadowaki*

Tab completion has become more powerful in 1.11 and gained inline hinting when there is a singular completion available that can be completed with tab.

![](/assets/blog/2024-1.11-highlights/inline_complete.png)

If you prefer not to have hinting enabled, disable it via your `startup.jl` with
```julia
atreplinit() do repl
    if VERSION >= v"1.11.0-0"
        repl.options.hint_tab_completes = false
    end
end
```


# Sources section in Project.toml in Pkg.jl
*Kristoffer Carlsson*

Previously to be able to instantiate an environment that used unregistered dependencies it was required that the manifest file was available since that
file gave the information of e.g. what URL the unregistered dependencies are available. Now this information can be specified in the Project file,
for example:

```toml
[sources]
MyUnregisteredPackage = {url = "https://github.com/JuliaLang/MyUnregisteredPackage.jl"}
```

This feature was also shown at JuliaCon and can be seen [here](https://youtu.be/7n27lF_SrxY?t=19).

# Precompile file relocatability
*Florian Atteneder*

Enabling relocation of cache files, together with other improvements coming in v1.11,
will help Pkg.jl to serve cache files in the future.

To automatically enable relocatability follow [Pkg.jl's Best Practices](https://pkgdocs.julialang.org/v1/creating-packages/#Best-Practices), i.e.
do not assume that your package code ends up in a writeable or stable location.
Instead, utilize existing tools like Artifacts.jl, Scratch.jl or Preferences.jl to
make your package self-contained, immutable, and relocatable.

The usage of non-relocatable packages continues to work as before.
Attempting to relocate such a package should only occur re-precompilation overhead.

Pitfalls for relocation:
- Usage of `@__DIR__, @__FILE__` 'burns' absolute paths into package images.
 In general, avoid absolute paths or relative paths outside the package's root directory.


# Stdlib excision
*Valentin Churavy*, *Kristoffer Carlsson*

After the introduction of package-images for native caching in Julia 1.10, we started the process
of moving standard libraries out of the system-image. This produces a smaller Julia system-image
and startup for small scripts being faster.

```
% hyperfine 'julia +1.10 --startup-file=no -e "1+1"'
Benchmark 1: julia +1.10 --startup-file=no -e "1+1"
  Time (mean ± σ):     113.2 ms ±   2.8 ms    [User: 108.9 ms, System: 25.9 ms]
  Range (min … max):   109.2 ms … 117.9 ms    25 runs
```

```
% hyperfine 'julia +1.11 --startup-file=no -e "1+1"'
Benchmark 1: julia +1.11 --startup-file=no -e "1+1"
  Time (mean ± σ):      91.9 ms ±   3.0 ms    [User: 72.5 ms, System: 19.1 ms]
  Range (min … max):    88.7 ms … 100.8 ms    29 runs
```

Excising standard libraries also introduces the opportunity in the future to update standard libraries
independently of Julia. Consequently since this release standard libraries will have their own version
numbers. Our goal is to make the development of standard libraries faster and lower the barrier of entry for contributions.

# ScopedValues

ScopedValues are a new runtime supported datatype that provides an alternative to globals for configuration
parameters.

The example below uses ScopedValues to implement permission checking in a web application.
When a request is initially processed the permission level needs to be checked only once and
all subsequent processing of the request will *dynamically* inherit the state of the ScopedValue.
Dynamically means that the state of ScopedValues is propagated to child functions and child tasks.

```julia
using Base.ScopedValues

const LEVEL = ScopedValue(:GUEST)

function serve(request, response)
    level = isAdmin(request) ? :ADMIN : :GUEST
    with(LEVEL => level) do
        Threads.@spawn handle(request, response)
    end
end

function open(connection::Database)
    level = LEVEL[]
    if level !== :ADMIN
        error("Access disallowed")
    end
    # ... open connection
end

function handle(request, response)
    # ...
    open(Database(#=...=#))
    # ...
end
```

# New main entry point
*Keno Fischer*

The entry point for Julia has been standardized to `Main.main(args)`. This must be explicitly opted into using the `@main` macro (see the docstring for further details). When opted-in, and `julia` is invoked to run a script or expression (i.e. using `julia script.jl` or `julia -e expr`), `julia` will subsequently run the `Main.main` function automatically. This is intended to unify script and compilation workflows, where code loading may happen in the compiler and execution of `Main.main` may happen in the resulting executable. For interactive use, there is no semantic difference between defining a `main` function and executing the code directly at the end of the script.

# The `@time` macro now reports lock conflicts
*Ian Butterworth*

The `@time` macro will now report any lock contention within the call being timed, as a number of lock conflicts.
A lock conflict is where a task attempted to lock a `ReentrantLock` that is already locked, and may indicate design
issues that could be impeding concurrent performance.

In this example the number of conflicts is clearly expected, but locks could be buried deep in library code, making
them hard to catch otherwise.

```julia
julia> Threads.nthreads()
6

julia> function foo()
          l = ReentrantLock()
          Threads.@threads for i in 1:Threads.nthreads()
              lock(l) do
                  sleep(1)
              end
          end
      end
foo (generic function with 1 method)

julia> @time foo()
  6.069761 seconds (28.14 k allocations: 1.410 MiB, 5 lock conflicts, 1.34% compilation time)
```

# Inference enhancements

_Keno Fischer_, _Shuhei Kadowaki_

In v1.11, several new features have been added to inference.

#### Exception type inference

The first feature we’d like to introduce is exception type inference.
The Julia compiler is now able to infer the types of exception objects, significantly
improving type stability in `catch` blocks. For example, in the following `demo_exc_inf`
method, you can see that the type of the `err` object is inferred as
`::Union{Float64, DomainError}` instead of `::Any` (as was in v1.10):
```julia
julia> function demo_exc_inf(x::Float64)
           local v
           try
               v = x > 0 ? sin(x) : throw(x)
           catch err # the type of `err` can be inferred >v1.11
               if err isa DomainError
                   v = zero(x)
               else
                   v = err
               end
           end
           return v
       end
demo_exc_inf (generic function with 1 method)

julia> only(code_typed(demo_exc_inf, (Float64,); optimize=false))
CodeInfo(
1 ──       Core.NewvarNode(:(v))::Any
2 ── %2  = enter #8
3 ── %3  = (x > 0)::Bool
└───       goto #5 if not %3
4 ──       (@_5 = Main.sin(x))::Float64
└───       goto #6
5 ──       (@_5 = Main.throw(x))::Union{}
6 ┄─ %8  = @_5::Float64
│          (v = %8)::Float64
└───       $(Expr(:leave, :(%2)))
7 ──       goto #12
8 ┄─       (err = $(Expr(:the_exception)))::Union{Float64, DomainError}
│    %13 = err::Union{Float64, DomainError}
│    %14 = (%13 isa Main.DomainError)::Bool
└───       goto #10 if not %14
9 ──       (v = Main.zero(x))::Core.Const(0.0)
└───       goto #11
10 ─ %18 = err::Float64
└───       (v = %18)::Float64
11 ┄       $(Expr(:pop_exception, :(%2)))::Core.Const(nothing)
12 ┄ %21 = v::Float64
└───       return %21
) => Float64
```

You can check the summarized result of type inference for exception objects that a
particular method call may raise using `Base.infer_exception_type`.
```julia
julia> Base.infer_exception_type(sin, (Float64,))
DomainError
```

However note that the accuracy of exception type inference is not yet very high.
It generally works well only when the `try` block contains basic functions.
In particular, it often fails to provide accurate results for `try` blocks that might call
functions involving external calls, such as `ccall`.

#### Escape analysis

The next feature we’d like to introduce is Julia-level escape analysis
([`Core.Compiler.EscapeAnalysis`](https://docs.julialang.org/en/v1/devdocs/EscapeAnalysis/)).
While `Core.Compiler.EscapeAnalysis` was implemented back in v1.8, it was not enabled in the
actual compilation pipeline due to issues with its precision and latency.

As a first step towards leveraging `EscapeAnalysis` for various optimizations, in v1.11, it
is now selectively enabled in the actual compilation pipeline with the goal of improving the
precision of effects analysis for methods involving non-escaping mutable allocations.

Currently, the precision of `EscapeAnalysis` is not very high, and it struggles to perform
well for functions with complex memory operations. As a result, it has not yet been used for
other purposes. However, we plan to continue improving it and apply it to various
optimizations such as more aggressive constant propagation, better SROA
(Scalar Replacements of Aggregates), `finalizer` optimization, and stack allocation.
