+++
mintoclevel = 2
maxtoclevel = 3
title = "Julia 1.13 Highlights"
authors = "The Julia contributors"
published = "TODO Month 2026"
rss_pubdate = Date(2026, 9, 1)
rss = """Highlights of the Julia 1.13 release."""
+++

<!-- TODO: set `published` and `rss_pubdate` to the actual release date (and move the file to the matching blog/YYYY/MM/ directory) before merging. -->

Julia version 1.13 has been released. We want to thank all the contributors to this release and all the testers who helped find regressions and issues in the pre-releases. Without you, this release would not have been possible.

The full list of changes can be found in the [NEWS file](https://github.com/JuliaLang/julia/blob/release-1.13/NEWS.md), but here we'll give a more in-depth overview of some of the release highlights.

\toc

<!--
Section template (copy for each highlight):

## <Feature name>
*Author One*, *Author Two*

<1–3 paragraphs: what it is, why it matters, how to use it.>

```julia-repl
julia> # short, self-contained example
```

<Optional caveats / links to docs and PRs.>
-->

## REPL improvements
*TODO authors*

<!-- The REPL got a lot of user-visible love this release; probably the headline section.
     Consider a screenshot/GIF for highlighting and history search. -->

### Syntax highlighting as you type

<!-- NEWS: no PR number listed. Link to the REPL docs section on customization. -->

TODO


### New fzf-style history search

<!-- NEWS: rewritten as an interactive modal dialogue. -->

TODO

### Bracketed paste on Windows

<!-- NEWS: #59825. Large pastes are much faster. -->

TODO

### Smaller REPL niceties

<!-- NEWS: `AbstractChar` display shows LaTeX input info (#58181);
     repeated frames / cycles in stack traces are bracketed (#55841);
     `\^q` for U+107A5 (#59544); `\hookunderrightarrow` operator (#57143); Unicode 17 (#59534). -->

TODO

## `@__FUNCTION__`
*TODO authors*

<!-- NEWS: #58940. Refers to the innermost enclosing function; useful for recursion in anonymous functions / closures. -->

TODO

```julia-repl
julia> fact = n -> n <= 1 ? 1 : n * @__FUNCTION__()(n - 1);

julia> fact(5)
120
```

## Hashing changes

*Andy Dienes, Jameson Nash*

The hash function has been replaced. The byte-hashing algorithm is now [RapidhashNano](https://github.com/Nicoshev/rapidhash). This hash is used by default for `AbstractString` and many numeric types like `BigInt`, `Rational`, and large `Real` or `Integer` values. It is also much easier now for custom types to opt in to the generic implementations without having to first convert to a supported type (like `String`). This change offers several advantages compared to the pre-existing implementation based on MurmurHash3. It has significantly better performance, is a streaming hash so it no longer requires the `length` of the input up front, and has moved from C to pure Julia for better readability and maintainability.

To demonstrate the performance improvement on long strings:
```
using BenchmarkTools, Downloads

io = IOBuffer()
Downloads.download("https://www.gutenberg.org/cache/epub/1080/pg1080.txt", io)
s = String(take!(io));

# 1.12
@btime hash($s)
  8.555 μs (0 allocations: 0 bytes)
0x5fbd2717019846ea

# 1.13
@btime hash($s)
  1.742 μs (0 allocations: 0 bytes)
0x718308e795047519
```

And a demonstration of opting in to a faster fallback:
```
struct MyString <: AbstractString
    s::String
end
m = MyString(s);

# 1.12
Base.iterate(m::MyString) = iterate(m.s)
Base.iterate(m::MyString, i::Integer) = iterate(m.s, i)
@btime hash($m)
  204.583 μs (21 allocations: 107.02 KiB)
0x5fbd2717019846ea

# 1.13
Base.codeunit(m::MyString) = codeunit(m.s)
Base.codeunits(m::MyString) = codeunits(m.s)
@btime hash($m)
  1.750 μs (0 allocations: 0 bytes)
0x718308e795047519
```

The hash for small fixed-width data has also changed. The finalizer is now a single-round XMX construction with some carefully tuned constants, and the mixing step now properly avalanches when composing hash calls; previously the mixing step always simplified to a linear function at every composition depth. This change to the mixing step does introduce a data dependency (and thus potentially lower performance) when sequentially hashing elements together in a tight loop, e.g. `foldr(hash, collection)`, but the algorithm for hashing `AbstractArray` has been partially unrolled at small to medium sizes, maintaining several hash accumulators in parallel, and will be much faster at most lengths.

Some important reminders: `hash` remains **noncryptographic**. Also, the default seed has changed. Custom `hash` methods should **always** accept the seed as an argument like `hash(x::MyType, h::UInt)` and **never** provide a default value like `hash(x::MyType, h::UInt=0)`, since the correct seed is determined by the caller.



## Faster GC by not sweeping the sysimage
*Cody Tapscott*

<!-- PR: https://github.com/JuliaLang/julia/pull/61474 (landed in 1.13-rc2, so not in NEWS.md).
     Objects in the sysimage / pkgimages are never freed and rarely mutated, so they are now loaded as
     permanently marked (`GC_OLD_MARKED`); the mark phase never enters the image subgraph. Mutations to image
     objects are tracked in a dedicated `image_remset` that roots any new referents.
     Full-collection pause times drop dramatically (e.g. ~37 ms -> ~1.4 ms for a bare sysimage, ~40 ms -> ~3-4 ms
     after loading packages in the PR's benchmarks); quick/partial collections are essentially unchanged.
     Consider reusing the table from the PR description. -->

TODO

```julia-repl
julia> # example: time a full collection before/after, e.g. @time GC.gc(true)
```

## Scheduler and interrupt fixes
*TODO authors*

<!-- TODO: collect the relevant PRs (scheduler robustness, ^C / InterruptException delivery, deadlock fixes).
     Frame this as groundwork for the proper task cancellation (cancellation tokens) coming in 1.14. -->

TODO

## Introspection with type annotations
*TODO authors*

<!-- NEWS: #57909, #58222. `@code_typed f(1, ::Float64, 3)`, `@which sum(::Vector{T}; init = ::T) where {T<:Real}`.
     Compatible with signatures copied from stacktraces. Also better broadcasting support in `@code_lowered`/`@code_typed` (#58349). -->

TODO

```julia-repl
julia> @which sum(::Vector{Float64})
```


## CI debugging tracing
*TODO authors*

The new `--trace-eval` argument shows top-level eval progress, to help see how a test suite or script is advancing, e.g. to identify hangs. For instance:
```
% julia --trace-eval script.jl
eval: #= /Users/me/.julia/config/startup.jl:1 =#
eval: #= /Users/me/.julia/config/startup.jl:2 =#
eval: #= /Users/me/.julia/config/startup.jl:3 =#
eval: #= script.jl:1 =#
eval: #= script.jl:2 =#
Hello world
```
It can also be enabled via the "debug logging" option on CI platforms (GitHub Actions shown here):
![Screenshot 2026-03-26 at 2.04.40 PM](https://hackmd.io/_uploads/S1OUBxXj-x.png)


## Pkg

Pkg has gotten quite a bit of attention for 1.13. Here we list some of the more notable changes and improvements.

### Change in default compression algorithm from gzip to zstd

For downloads from a package server (registries, packages and artifacts), Pkg will now by default ask for a zstd-compressed archive instead of a gzipped one. For the type of files Pkg typically downloads, zstd compression tends to have both a better compression ratio and significantly better decompression performance. As an example, downloading the packages and artifacts for the packages Plots, Makie and ModelingToolkit results in the following data:


|                  | gzip            | zstd           |
|------------------------|-----------------|----------------|
| Total downloads        | 405             | 405            |
| Total download size       | 307.99 MB       | 239.31 MB      |
| Total decompression time | 8.77 s        | 5.50 s         |
| Average decompression time | 21.98 ms    | 13.77 ms       |


### Performance improvements

Some general micro-optimizations have been made to the resolver and the registry processing, leading to generally better performance of Pkg operations.
Some of these improvements have already been backported to 1.12, so to get a proper performance comparison we compare against 1.12.1, which did not get any of these backports.

To assess the impact on resolver speed, we do the following benchmark: we add Plots to an empty environment, remove it, and then benchmark the time it takes to add Plots again. This ensures that all the files for Plots are already downloaded. In addition, auto-precompilation is turned off and the registry cache is cleared so that it has to be re-read from scratch.
This isolates the time-consuming parts of adding Plots to this environment to mostly the registry processing and the resolver:

```julia
julia> ENV["JULIA_PKG_PRECOMPILE_AUTO"] = 0

# 1.12.1
julia> empty!(Pkg.Registry.REGISTRY_CACHE); @time Pkg.add("Plots"; io=devnull)
  1.257017 seconds (8.83 M allocations: 681.328 MiB, 16.31% gc time)
# 1.13.0
julia> empty!(Pkg.Registry.REGISTRY_CACHE); @time Pkg.add("Plots"; io=devnull)
  0.745170 seconds (4.43 M allocations: 304.580 MiB, 26.90% gc time)
```

In addition, Pkg will now clone repos with more efficient settings, avoiding downloading unnecessary data:

```julia
# 1.12.1
julia> @time Pkg.add(name="Plots"; rev="master")
     Cloning git-repo `https://github.com/JuliaPlots/Plots.jl.git`
...
 10.953074 seconds (4.51 M allocations: 330.819 MiB, 1.68% gc time)

# 1.13.0
julia> @time Pkg.add(name="Plots"; rev="master")
     Cloning git-repo `https://github.com/JuliaPlots/Plots.jl.git`
...
  2.980337 seconds (2.87 M allocations: 189.202 MiB, 3.87% gc time)

```

### Registries for packages tracked in manifest

Previously, to instantiate a manifest you needed to manually make sure that the registries required by that manifest were available. Now, the registry for each package is stored in the manifest and automatically downloaded upon manifest instantiation (or other package operations).

### Recursively collect sources

Pkg now recursively collects `[sources]` entries from packages fetched by URL, allowing private dependency chains to resolve without requiring all dependencies of a private package to be in a registry.


### No longer default to bounds checking on testing

TODO

## Juliaup GUI
*TODO authors*

<!-- TODO: describe the new graphical interface for juliaup: what it can do (install/update/switch channels?),
     which platforms, how to launch it, and link to the juliaup release / README. Consider a screenshot. -->

TODO

## Acknowledgement

<!-- TODO: confirm funding acknowledgement is still applicable for this release. -->

The preparation of this release was partially funded by NASA under award 80NSSC22K1740. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Aeronautics and Space Administration.
