+++
mintoclevel = 2
maxtoclevel = 3
title = "Julia 1.12 Highlights"
authors = "The Julia contributors"
published = "10 October 2025"
rss_pubdate = Date(2025, 10, 10)
rss = """Highlights of the Julia 1.12 release."""
+++

Julia version 1.12 has finally been released. We want to thank all the contributors to this release and all the testers who helped find regressions and issues in the pre-releases. Without you, this release would not have been possible.

The full list of changes can be found in the [NEWS file](https://github.com/JuliaLang/julia/blob/release-1.12/NEWS.md), but here we'll give a more in-depth overview of some of the release highlights.


\toc

## New `--trim` feature
*Jeff Bezanson*, *Cody Tapscott*, *Gabriel Baraldi*

`julia` now has a new experimental`--trim` feature, when compiling a system image with this mode julia will trim statically unreachable code leading to significantly better compile times and binary sizes. To use it you also need to pass the `--experimental` flag when building the system image. 

In order to use it, any code that is reachable from the entrypoints must not have any dynamic dispatches otherwise the trimming will be unsafe and it will error during compilation.

The expected way of using it is via the `JuliaC.jl` package, which provides a CLI and a programmatic API. 

For example a simple package with an `@main` function:
```julia
module AppProject

function @main(ARGS)
    println(Core.stdout, "Hello World!")
    return 0
end

end
```

```bash
juliac --output-exe app_test_exe --bundle build --trim=safe --experimental ./AppProject
```

```bash
./build/bin/app_test_exe
Hello World!

ls -lh build/bin/app_test_exe
-rwxr-xr-x@ 1 gabrielbaraldi  staff   1.1M Oct  6 17:22 ./build/bin/app_test_exe*
```

## Redefinition of constants (structs)
*Keno Fischer*, *Tim Holy*

Bindings now participate in the "world age" mechanism previously used for methods. This has the effect that constants and structs can be properly redefined. As an example:

```julia
# Define a struct and a method on that struct:
julia> struct Foo
          a::Int
       end

julia> g(f::Foo) = f.a^2
g (generic function with 1 method)

julia> g(Foo(2))
4

# Redefine the struct (julia pre-1.12 would error here)
julia> struct Foo
          a::Int
          b::Int
       end

# Note that functions need to be redefined to work on the new `Foo`
julia> g(Foo(1,2))
ERROR: MethodError: no method matching g(::Foo)
The function `g` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  g(::@world(Foo, 39296:39300)) # <- This is syntax for accessing the binding in an older "world"
   @ Main REPL[2]:1

julia> g(f::Foo) = f.a^2 + f.b^2
g (generic function with 2 methods)

julia> g(Foo(2,3))
13
```

There is also work in progress in Revise.jl to automatically redefine functions on replaced bindings.
This should significantly reduce the number of times you have to restart Julia while iterating on some piece of code.

## New tracing flags and macros for inspecting what Julia compiles
*Ian Butterworth*, *Nathan Daly*

`--trace-compile-timing` is a new command-line flag that augments `--trace-compile` by printing how long each compiled method took (in milliseconds) before the corresponding `precompile(...)` line. This makes it easier to spot costly compilations.

In addition, two macros for ad-hoc tracing without restarting Julia have been added:

* `@trace_compile expr` runs `expr` with `--trace-compile=stderr --trace-compile-timing` enabled, emitting timed `precompile(...)` entries only for that call.
* `@trace_dispatch expr` runs `expr` with `--trace-dispatch=stderr` enabled, reporting methods that are dynamically dispatched.

**Examples**

```julia
julia> @trace_compile @eval rand(2,2) * rand(2,2)
#=   79.9 ms =# precompile(Tuple{typeof(Base.rand), Int64, Int64})
#=    4.4 ms =# precompile(Tuple{typeof(Base.:(*)), Array{Float64, 2}, Array{Float64, 2}})
2×2 Matrix{Float64}:
 0.302276  0.14341
 0.738941  0.396414

julia> f(x) = x

julia> @trace_dispatch map(f, Any[1,2,3])
precompile(Tuple{Type{Array{Int64, 1}}, UndefInitializer, Tuple{Int64}})
precompile(Tuple{typeof(Base.collect_to_with_first!), Array{Int64, 1}, Int64, Base.Generator{Array{Any, 1}, typeof(Main.f)}, Int64})
3-element Vector{Int64}:
 1
 2
 3

```

## New multi-threading features

### One interactive thread by default
*Gabriel Baraldi*, *Ian Butterworth*

Julia now starts with one interactive thread by default (in addition to the default thread). This means that by default Julia runs with the threading configuration of 1 default thread, 1 interactive thread.

The interactive thread pool is where the REPL and other interactive operations run. By separating these from the default thread pool (where `@spawn` and `@threads` schedule work when no threadpool is specified), the REPL can perform operations like autocomplete queries in parallel with user code execution, leading to a more responsive interactive experience.

**Key behaviors:**

* **Default**: Julia starts with `-t1,1` (1 default + 1 interactive thread)
* **Explicit `-t1`**: If you explicitly request 1 thread with `-t1`, Julia will give you exactly that—no additional interactive thread will be added (resulting in `-t1,0`)
* **Multiple threads**: `-t2` or `-tauto` will give you the requested default threads plus 1 interactive thread
* **Manual control**: You can always specify both pools explicitly, e.g., `-t4,2` for 4 default and 2 interactive threads

This change improves the out-of-the-box experience while maintaining backwards compatibility for users who explicitly request single-threaded execution.

### Threads settings respect CPU affinity
*Mosè Giordano*

Julia now respects CPU affinity settings, such as those set via `cpuset`/`taskset`/`cgroups`, etc.
The same also applies to the default number of BLAS threads, which now follows the same logic.
This can also be observed when running Julia inside Docker.
Currently, you have

```console
$ docker run --cpus=4 --rm -ti julia:1.11 julia --threads=auto -e '@show Threads.nthreads(); using LinearAlgebra; @show BLAS.get_num_threads()'
Threads.nthreads() = 22
BLAS.get_num_threads() = 11
```

When starting Julia with `--threads=auto`, [`Threads.nthreads()`](https://docs.julialang.org/en/v1/base/multi-threading/#Base.Threads.nthreads) is equal to the total number of CPUs on the system instead of the only 4 CPUs reserved by Docker.
Likewise, the number of BLAS threads, which can be obtained with [`BLAS.get_num_threads()`](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.BLAS.get_num_threads) and on x86-64 systems is by default half the number of available cores, is 11 instead of 2.
With Julia v1.12 this is fixed, and the number of both Julia and BLAS threads will respect the number of CPUs reserved by Docker:

```console
% docker run --cpus=4 --rm -ti julia:1.12 julia --threads=auto -e '@show Threads.nthreads(); using LinearAlgebra; @show BLAS.get_num_threads()'
Threads.nthreads() = 4
BLAS.get_num_threads() = 2
```

The new behavior is also important to avoid oversubscription out-of-the-box when running Julia on HPC systems where schedulers set CPU affinity when using shared resources.

### `OncePerX`
*Jameson Nash*

Certain initialization patterns need to run only once, depending on scope: per process, per thread, or per task. To make this easier and safer, Julia now provides three built-in types:

* `OncePerProcess{T}`: runs an initializer exactly once per process, returning the same value for all future calls.
* `OncePerThread{T}`: runs an initializer once for each thread ID. Subsequent calls on the same thread return the same value.
* `OncePerTask{T}`: runs an initializer once per task, reusing the same value within that task.

These replace common hand-rolled solutions such as using `__init__`, `nthreads()`, or `task_local_storage()` directly.

A simple example of `OncePerProcess`:

```julia
julia> const global_state = Base.OncePerProcess{Vector{UInt32}}() do
           println("Making lazy global value...done.")
           return [Libc.rand()]
       end;

julia> a = global_state();
Making lazy global value...done.

julia> a === global_state()
true
```

**Use cases:**

* `OncePerProcess`: caches, global constants, or initialization that should happen once per Julia process (even across precompilation).
* `OncePerThread`: per-thread state needed for interoperability with C libraries or specialized threading models.
* `OncePerTask`: lightweight task-local state without manually managing `task_local_storage`.

These types provide a safer, composable way to express “initialize once” semantics in concurrent Julia code.


## Building Julia and LLVM using the Binary Optimization and Layout Tool (BOLT).
*Zentrik*


[BOLT](https://github.com/llvm/llvm-project/tree/main/bolt) is a post-link optimizer from LLVM that improves runtime performance by reordering functions and basic blocks, splitting hot and cold code, and folding identical functions. Julia now supports building BOLT-optimized versions of **libLLVM**, **libjulia-internal**, and **libjulia-codegen**.

These optimizations reduce compilation and execution time in common workloads. For example, the all-inference benchmarks improve by about **10%**, an LLVM-heavy workload shows a similar **~10%** gain, and building `corecompiler.ji` improves by **13–16%** with BOLT. When combined with PGO and LTO, total improvements of up to **~23%** have been observed.

To build a BOLT-optimized Julia, run the following commands from `contrib/bolt/`:

```bash
make stage1
make copy_originals
make bolt_instrument
make finish_stage1
make merge_data
make bolt
```

The optimized binaries will be available in the `optimized.build` directory. An analogous workflow exists in `contrib/pgo-lto-bolt/` for combining BOLT with PGO+LTO.

BOLT currently works only on Linux **x86\_64** and **aarch64**, and the resulting `.so` files must not be stripped. Some `readelf` warnings may appear during testing but are considered harmless.



## The `@atomic` macro family now supports reference assignment syntax
*Marek Kaluba*

The `@atomic` macro family now supports **indexing** (e.g. `m[i]`, `m[i,j]`) in addition to field access. This makes it possible to perform atomic fetch, set, modify, swap, compare-and-swap, and set-once directly on array-like references. The macros expand to new APIs: `getindex_atomic`, `setindex_atomic!`, `modifyindex_atomic!`, `swapindex_atomic!`, `replaceindex_atomic!`, and `setindexonce_atomic!`. Vararg and `CartesianIndex` indexing are supported.

For example:

```julia
mem = AtomicMemory{Int}(undef, 2)

@atomic mem[1] = 2                 # atomic set
x = @atomic mem[1]                 # atomic fetch
@atomic :monotonic mem[1] += 1     # atomic modify with order
old = @atomicswap mem[1] = 4       # atomic swap (returns old)
res = @atomicreplace mem[1] 4 => 10  # (old=4, success=true)
ok  = @atomiconce mem[2] = 7         # set once (Bool)
```


## New option --task-metrics=yes to enable the collection of per-task timing information

Two new per-task metrics can be enabled by starting Julia with `--task-metrics=yes` or by calling `Base.Experimental.task_metrics(true)`. Enabling or disabling task metrics with `Base.Experimental.task_metrics` only affects new tasks, not existing ones. The metrics are:

- `Base.Experimental.task_running_time_ns(t::Task)`: the time for which `t` was actually running. This is currently inclusive of GC time, compilation time, and any spin time.
- `Base.Experimental.task_wall_time_ns(t::Task)`: the time from the scheduler becoming aware of `t` until `t` is complete.


## New Pkg features
*Kristoffer Carlsson*

### Workspace

A workspace is a set of project files that all share the same manifest.
Each project in a workspace can include its own dependencies, compatibility information, and even function as a full package.

When the package manager resolves dependencies, it considers the requirements and compatibility of all the projects in the workspace. The compatible versions identified during this process are recorded in a single manifest file.

A workspace is defined in the base project by giving a list of the projects in it:

```toml
[workspace]
projects = ["test", "docs", "benchmarks", "PrivatePackage"]
```

This structure is particularly beneficial for developers using a monorepo approach, where a large number of unregistered packages may be involved. It is also useful for adding documentation or benchmarks to a package by including additional dependencies beyond those of the package itself. Test-specific dependencies are now recommended to be specified using the workspace approach (a project file in the `test` directory that is part of the workspace defined by the package project file).

Workspaces can also be nested: a project that itself defines a workspace can also be part of another workspace. In this case, the workspaces are “merged,” with a single manifest being stored alongside the “root project” (the project that is not included in another workspace).

### Apps

An app is a Julia package that can be run directly from the terminal, similar to a standalone program.
Each app provides an entry point via `@main` and can define its own default Julia flags and executable name.

When an app is installed, it gets put into `.julia/bin` and by adding that to your `PATH` it allows you to launch it by name together with any arguments or options.

A Julia app is defined in the `Project.toml` file using an `[apps]` section:

```toml
[apps]
reverse = {} # empty dictionary is for additional metadata
```

with a corresponding entry point in the package module:

```julia
# src/MyReverseApp.jl
module MyReverseApp

function (@main)(ARGS)
    for arg in ARGS
        print(stdout, reverse(arg), " ")
    end
end

end # module
```

After installation, the app can be run directly in the terminal:

```sh
$ reverse some input string
emos tupni gnirts
```

This makes apps useful for building CLI tools or packaging Julia functionality as user-facing executables. Multiple apps can be defined per package by using submodules, and each app can specify default Julia flags (e.g. `--threads=4`) for performance or debugging.

See the full documentation for more information: https://pkgdocs.julialang.org/dev/apps/

### Status highlights when dependencies have different loaded versions

`Pkg.status()` now highlights when a dependency's loaded version differs from what the current environment would load. This helps identify situations where you may be running code against an outdated or mismatched version of a package—particularly useful when switching between environments or after modifying dependencies.

When a package is already loaded from a different version or path than what the current environment specifies, Pkg will display a yellow `[loaded: vX.Y.Z]` indicator next to the package name:

![Pkg.status showing loaded version highlight](/assets/blog/2025-1.12-highlights/pkg-status-loaded-version.png)

This visual cue makes it easier to spot when you need to restart Julia to pick up the correct package versions, reducing debugging time and confusion in iterative development workflows.

## Generated LLVM IR now uses pointer types instead of passing pointers as integers
*Tim Besard*

`Ptr{T}` now lowers to **actual LLVM pointer types** in generated IR (i.e. `ptr` with opaque pointers, or `i8*`), instead of integers like `i64`. This simplifies low-level interop: `llvmcall` no longer needs `ptrtoint`/`inttoptr` shims, and many intrinsics can be called via `ccall` using `Ptr` directly.

**What changes for you**

* **Inline LLVM (`llvmcall`)**: update IR to use `ptr`/`i8*` for pointer arguments/returns, and remove redundant `ptrtoint`/`inttoptr` casts. Old IR that treats pointers as integers is still accepted but emits a **deprecation warning**.
* **Pointer arithmetic**: `add_ptr` / `sub_ptr` now operate on real pointers:
  `add_ptr(::Ptr{T}, ::UInt)` and `sub_ptr(::Ptr{T}, ::UInt)` (lowered to GEP).
* **`ccall` convenience**: passing/returning `Ptr{T}` maps to LLVM pointer types directly, enabling more intrinsic calls without custom `llvmcall` glue.

**Example (before → after)**

```
; BEFORE (deprecated): integer pointer
define i64 @f(i64 %p) {
  %q = inttoptr i64 %p to i8*
  ; ...
  %r = ptrtoint i8* %q to i64
  ret i64 %r
}

; AFTER: real pointer
define ptr @f(ptr %p) {
  ; ...
  ret ptr %p
}
```

This change also unlocks minor optimization opportunities in generated code since pointers no longer bounce through integer casts.

## Reproducing RNG state in testsets
*Mosè Giordano*

Many developers may have experience with occasional failures when running tests of their packages which were observed only on remote machines, and wished to be able to reproduce the same run, for debugging purposes.
The GitHub Actions workflow [`julia-actions/julia-runtest`](https://github.com/julia-actions/julia-runtest) recently started printing to the log the full options used to invoke the Julia process which runs the tests, which lets developers use the same compiler options (e.g. bounds checking, code coverage, deprecation warnings, etc.) as the CI runs.
However there are occasional failures which don't depend on compiler options, but may depend on the state of the global random number generator (RNG), if for example the input data of the tests is generated with functions like [`rand`](https://docs.julialang.org/en/v1/stdlib/Random/#Base.rand) and [`randn`](https://docs.julialang.org/en/v1/stdlib/Random/#Base.randn), without passing an explicit RNG object, instead relying on the global one.
The [`Test.@testset`](https://docs.julialang.org/en/v1/stdlib/Test/#Test.@testset) macro has had for a long time the feature of automatically controlling the global RNG, but until now its state was never displayed.
Starting from Julia v1.12, a failure inside a `@testset` causes the RNG of the outermost test set to be printed to screen, which then you can also set in a new test set to exactly reproduce the same run.

As an example, consider the following test which would fail with a 0.1% probability:
```julia-repl
julia> using Test

julia> @testset begin
           @test rand() > 0.001
       end;
test set: Test Failed at REPL[2]:2
  Expression: rand() > 0.001
   Evaluated: 0.00036328334842516963 > 0.001

Stacktrace:
 [1] top-level scope
   @ REPL[2]:2
 [2] macro expansion
   @ ~/.julia/juliaup/julia-1.12.0.x64.linux.gnu/share/julia/stdlib/v1.12/Test/src/Test.jl:1776 [inlined]
 [3] macro expansion
   @ REPL[2]:2 [inlined]
 [4] macro expansion
   @ ~/.julia/juliaup/julia-1.12.0.x64.linux.gnu/share/julia/stdlib/v1.12/Test/src/Test.jl:680 [inlined]
Test Summary: | Fail  Total  Time
test set      |    1      1  1.5s
RNG of the outermost testset: Random.Xoshiro(0xd02e9404e1026b37, 0xca5ae9c15acf6752, 0x976a327d42433534, 0xb5b1305af1734f3a, 0x1c2aa037d6e7d5c7)
ERROR: Some tests did not pass: 0 passed, 1 failed, 0 errored, 0 broken.
```
Normally, it'd require several attempts to reproduce a similar failure, but now the RNG is printed to screen and you can reproduce the run in a new session by setting the `rng` option of `@testset` to the value printed in the failed test:
```julia-repl
julia> using Test, Random

julia> @testset rng=Random.Xoshiro(0xd02e9404e1026b37, 0xca5ae9c15acf6752, 0x976a327d42433534, 0xb5b1305af1734f3a, 0x1c2aa037d6e7d5c7) begin
           @test rand() > 0.001
       end;
test set: Test Failed at REPL[2]:2
  Expression: rand() > 0.001
   Evaluated: 0.00036328334842516963 > 0.001

Stacktrace:
 [1] top-level scope
   @ REPL[2]:2
 [2] macro expansion
   @ ~/.julia/juliaup/julia-1.12.0.x64.linux.gnu/share/julia/stdlib/v1.12/Test/src/Test.jl:1776 [inlined]
 [3] macro expansion
   @ REPL[2]:2 [inlined]
 [4] macro expansion
   @ ~/.julia/juliaup/julia-1.12.0.x64.linux.gnu/share/julia/stdlib/v1.12/Test/src/Test.jl:680 [inlined]
Test Summary: | Fail  Total  Time
test set      |    1      1  1.4s
RNG of the outermost testset: Xoshiro(0xd02e9404e1026b37, 0xca5ae9c15acf6752, 0x976a327d42433534, 0xb5b1305af1734f3a, 0x1c2aa037d6e7d5c7)
ERROR: Some tests did not pass: 0 passed, 1 failed, 0 errored, 0 broken.
```

While there are still many other classes of intermittent failures that aren't captured by the global RNG, being able to reproduce its state inside failing test sets should help debugging more issues during package development.

## Acknowledgement

The preparation of this release was partially funded by NASA under award 80NSSC22K1740. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Aeronautics and Space Administration.
