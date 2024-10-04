+++
mintoclevel = 2
maxtoclevel = 3
title = "Julia 1.11 Highlights"
authors = "The Julia contributors"
published = "4 October 2024"
rss_pubdate = Date(2024, 10, 04)
rss = """Highlights of the Julia 1.11 release."""
+++

...


After two alphas, two betas, and four release candidates, Julia version 1.11 has finally(!!!) been released. We want to thank all the contributors to this release and all the testers who helped find regressions and issues in the pre-releases. Without you, this release would not have been possible.

The full list of changes can be found in the [NEWS file](https://github.com/JuliaLang/julia/blob/release-1.11/NEWS.md), but here we'll give a more in-depth overview of some of the release highlights.

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


# Manifest versioning
*Ian Butterworth*

`Manifest.toml` files can now be renamed in the format `Manifest-v{major}.{minor}.toml`
to be preferentially picked up by the given julia version. i.e. in the same folder,
a `Manifest-v1.11.toml` would be used by v1.11 and `Manifest.toml` by every other julia
version. This makes managing environments for multiple julia versions at the same time easier.

# Improved tab completion and hinting in the REPL
*Ian Butterworth*, *Shuhei Kadowaki*

Tab completion has become more powerful in 1.11 and gained inline hinting when there is a singular completion available that can be completed with tab.

![](/assets/blog/2024-1.11-highlights/inline_complete.png)

If you prefer not to have hinting enabled, disable it via your `startup.jl` with
```
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
MyUnregisterdPackage = {url = "https://github.com/JuliaLang/MyUnregisteredPacakge.jl"}
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
- Anything else?


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

Excising standard libaries also intrododuces the opportunity in the future to update standard libraries
independently of Julia. Consequently since this release standard libraries will have their own version
numbers. Our goal is to make the development of standard libaries faster and lower the barrier of entry for contributions.

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
*Keno*

The entry point for Julia has been standardized to `Main.main(args)`. This must be explicitly opted into using the `@main` macro (see the docstring for further details). When opted-in, and `julia` is invoked to run a script or expression (i.e. using `julia script.jl` or `julia -e expr`), `julia` will subsequently run the `Main.main` function automatically. This is intended to unify script and compilation workflows, where code loading may happen in the compiler and execution of `Main.main` may happen in the resulting executable. For interactive use, there is no semantic difference between defining a `main` function and executing the code directly at the end of the script.

# The `@time` macro now reports lock conflicts
*Ian*

(too niche?)

```
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

