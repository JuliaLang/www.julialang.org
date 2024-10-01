+++
mintoclevel = 2
maxtoclevel = 3
title = "Julia 1.11 Highlights"
authors = "The Julia contributors"
published = "1 October 2024"
rss_pubdate = Date(2024, 10, 01)
rss = """Highlights of the Julia 1.11 release."""
+++

...


The full list of changes can be found in the [NEWS file](https://github.com/JuliaLang/julia/blob/release-1.11/NEWS.md), but here we'll give a more in-depth overview of some of the release highlights.

\toc

# `Array` now implemented in Julia, new `Memory` type
*Jameson Nash* , *Oscar Smith*


# New `public` keyword
*Lilith Hafner*


# `ScopedValue`
*Valentin Churavy*


# Manifest versioning
*Ian Butterworth*

# Improved tab completion and hinting in the REPL
*Ian Butterworth*, *Shuhei Kadowaki*

Tab completion has become more powerful in 1.11 and gained hinting when there is a singular completion available that can be completed with tab.

(Embed a video like this:)
https://github.com/JuliaLang/julia/assets/1694067/6179d799-63f1-47dc-abe2-ac10abb29bc9


If you prefer to not have hinting enabled, disable it via your `startup.jl` with
```
atreplinit() do repl
    if VERSION >= v"1.11.0-0"
        repl.options.hint_tab_completes = false
    end
end
```


# Sources section in Project.toml in Pkg.jl
*Kristoffer Carlsson*

# Precompile file relocatability
*Florian Atteneder*

Enabling relocation of cache files, together with other improvements coming in v1.11,
paves the way for Pkg.jl to serve cache files in the future.

To automatically enable relocatability follow [Pkg.jl's Best Practices](https://pkgdocs.julialang.org/v1/creating-packages/#Best-Practices), i.e.
do not assume that your package code ends up in a writeable or stable location.
Instead, utilize existing tools like Artifacts.jl, Scratch.jl or Preferences.jl to
make your package self-contained, immutable and relocatable.

Usage of non-relocatable packages continues to work as before.
Attempting to relocate such a package should only occur re-precompilation overhead.

Pitfalls for relocation:
- Usage of `@__DIR__, @__FILE__` 'burns' absolute paths into package images.
  In general, avoid absolute paths or relative paths outside the package's root directory.
- Anything else?


# Stdlib excision
(Ian adding this but probably Valentin?)

Most stdlibs have now been extracted into their own pkgimages, resulting in the core julia sysimage being smaller and core startup time being faster.
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

Excising stdlibs also is a step in the direction of allowing stdlibs to be updated independently of julia version, meaning hotfixes etc. do not need to wait for julia releases.
The following stdlibs are now independently versionable:
- xxx

This means that in the interactive REPL, Pkg now will only load when it is first needed.

# New main entry point
*Keno*

(copy from NEWS.md)
The entry point for Julia has been standardized to `Main.main(args)`. This must be explicitly opted into using the `@main` macro (see the docstring for further details). When opted-in, and `julia` is invoked to run a script or expression (i.e. using `julia script.jl` or `julia -e expr`), `julia` will subsequently run the `Main.main` function automatically. This is intended to unify script and compilation workflows, where code loading may happen in the compiler and execution of `Main.main` may happen in the resulting executable. For interactive use, there is no semantic difference between defining a `main` function and executing the code directly at the end of the script

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

