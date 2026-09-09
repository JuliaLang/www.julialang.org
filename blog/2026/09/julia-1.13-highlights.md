+++
mintoclevel = 2
maxtoclevel = 3
title = "Julia 1.13 Highlights"
authors = "The Julia contributors"
published = "1 September 2026"
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

## Latency (TTFX) Improvements

*Ian Butterworth*, *many others*

Julia 1.13 precompiles packages roughly 30% faster than 1.12, and roughly 10-20% faster than 1.10 (LTS) depending on the machine.

Time To First X (TTFX), the time from starting Julia to getting a first result, is made up of three main costs: precompiling packages, loading them, and running the code. With the help of the community-submitted workflows at [Julia-TTFX-Snippets](https://github.com/tecosaur/Julia-TTFX-Snippets), we have started measuring these costs more systematically on real-world examples and optimizing Julia against them.

The chart below shows the geometric mean across all 39 currently submitted workflows, on two machines. Precompilation is the fastest of 2 runs; load and execution times are the fastest of 3 runs.

~~~
<style>
.ttfx { margin: 1.5em 0; position: relative; font-family: system-ui, -apple-system, "Segoe UI", sans-serif; }
.ttfx svg { width: 100%; height: auto; display: block; }
.ttfx-wrap { overflow: hidden; }
.ttfx-wrap.ttfx-animate { transition: height 0.4s ease; }
.ttfx-controls { display: flex; flex-wrap: wrap; align-items: center; gap: 0.5em 1.5em; margin-bottom: 0.25em; font-size: 0.85em; }
.ttfx-tabs { display: inline-flex; border: 1px solid #c3c2b7; border-radius: 6px; overflow: hidden; }
.ttfx-tabs button { background: none; border: 0; border-right: 1px solid #c3c2b7; padding: 0.35em 0.9em; color: #52514e; cursor: pointer; font: inherit; }
.ttfx-tabs button:last-child { border-right: 0; }
.ttfx-tabs button.ttfx-on { background: #2a78d6; color: #fff; }
.ttfx-toggle { color: #52514e; cursor: pointer; user-select: none; }
.ttfx-tip { position: absolute; pointer-events: none; background: #fff; color: #0b0b0b; border: 1px solid #c3c2b7; border-radius: 4px; padding: 0.35em 0.6em; font-size: 0.8em; line-height: 1.4; white-space: nowrap; box-shadow: 0 2px 8px rgba(0,0,0,0.12); z-index: 2; }
.ttfx-head { margin: 0.75em 0 0.5em; }
.ttfx-title { font-size: 1.1em; font-weight: 600; line-height: 1.3; }
.ttfx-sub { font-size: 0.85em; color: #52514e; margin-top: 0.2em; }
.ttfx-legend { font-size: 0.85em; color: #52514e; margin-top: 0.5em; display: flex; flex-wrap: wrap; gap: 0.3em 1.5em; }
.ttfx-swatch { display: inline-block; width: 0.7em; height: 0.7em; border-radius: 50%; margin-right: 0.4em; vertical-align: -0.02em; }
.ttfx-swatch-macos { background: #2a78d6; } .ttfx-swatch-linux { background: #eb6834; }
.ttfx-tick { font-size: 11px; }
.ttfx-axis-label { font-size: 13px; }
.ttfx-delta { font-size: 11px; }
.ttfx-narrow .ttfx-tick { font-size: 13px; }
.ttfx-narrow .ttfx-axis-label { font-size: 15px; }
.ttfx-narrow .ttfx-delta { font-size: 12.5px; }
.center-table table { margin-left: auto; margin-right: auto; }
/* Alternate a faint tint behind every other major section so their extent is visible. */
/* Full-bleed: pull the band out to the viewport edges and pad the content back into the column. */
.hl-section { padding: 0.25rem calc(50vw - 50%) 1rem; margin: 1.5rem calc(50% - 50vw) 0; }
.hl-section:nth-of-type(odd) { padding-top: 0.75rem; padding-bottom: 1.5rem; }
.hl-section > .franklin-toc { margin-top: 0.5rem; }
body { overflow-x: hidden; }
.hl-section:nth-of-type(odd) { background: rgba(74, 120, 214, 0.06); }
[data-theme="dark"] .hl-section:nth-of-type(odd) { background: rgba(255, 255, 255, 0.035); }
.blog-title ~ .container.main .hl-section > h2:first-child { margin-top: 0.75rem; }
.ttfx-ink { fill: #0b0b0b; } .ttfx-ink2 { fill: #52514e; } .ttfx-muted { fill: #898781; }
.ttfx-grid { stroke: #e1e0d9; } .ttfx-axis { stroke: #c3c2b7; }
.ttfx-ring { stroke: #fff; stroke-width: 2; }
.ttfx-line-macos { stroke: #2a78d6; } .ttfx-fill-macos { fill: #2a78d6; }
.ttfx-line-linux { stroke: #eb6834; } .ttfx-fill-linux { fill: #eb6834; }
.ttfx-task { opacity: 0.25; }
.ttfx-xlabel { cursor: help; }
.ttfx-task.ttfx-hl { opacity: 1; stroke-width: 2.5; }
.ttfx-task-hit { stroke: transparent; stroke-width: 12; pointer-events: stroke; }
.ttfx-good { fill: #006300; color: #006300; } .ttfx-bad { fill: #b3261e; color: #b3261e; }
[data-theme="dark"] .ttfx-tabs, [data-theme="dark"] .ttfx-tabs button { border-color: #555; }
[data-theme="dark"] .ttfx-tabs button, [data-theme="dark"] .ttfx-toggle { color: #bbb; }
[data-theme="dark"] .ttfx-tabs button.ttfx-on { background: #3987e5; color: #fff; }
[data-theme="dark"] .ttfx-tip { background: #2a2a3e; color: #e0e0e0; border-color: #555; }
[data-theme="dark"] .ttfx-ink { fill: #fff; } [data-theme="dark"] .ttfx-ink2 { fill: #c3c2b7; }
[data-theme="dark"] .ttfx-sub, [data-theme="dark"] .ttfx-legend { color: #bbb; }
[data-theme="dark"] .ttfx-swatch-macos { background: #3987e5; } [data-theme="dark"] .ttfx-swatch-linux { background: #d95926; }
[data-theme="dark"] .ttfx-grid { stroke: #33334a; } [data-theme="dark"] .ttfx-axis { stroke: #555; }
[data-theme="dark"] .ttfx-ring { stroke: #1a1a2e; }
[data-theme="dark"] .ttfx-line-macos { stroke: #3987e5; } [data-theme="dark"] .ttfx-fill-macos { fill: #3987e5; }
[data-theme="dark"] .ttfx-line-linux { stroke: #d95926; } [data-theme="dark"] .ttfx-fill-linux { fill: #d95926; }
[data-theme="dark"] .ttfx-good { fill: #0ca30c; color: #0ca30c; } [data-theme="dark"] .ttfx-bad { fill: #e66767; color: #e66767; }
</style>
<div id="ttfx-plot" class="ttfx"></div>
<script src="/assets/blog/2026-1.13-highlights/ttfx-data.js"></script>
<script src="/assets/blog/2026-1.13-highlights/ttfx-plot.js"></script>
~~~

This monitoring is now also part of Julia's own development process: new TTFX CI jobs run on relevant pull requests and on every commit to `master`, and the results are tracked at [perf.julialang.org/ttfx](https://perf.julialang.org/ttfx). That tracking went live on September 7, 2026; measurements before then were ad hoc.


## REPL improvements


### Syntax highlighting
*Timothy*, *Kristoffer Carlsson*

The Julia REPL now has syntax highlighting (without having to load an external package like OhMyREPL.jl):

~~~
<p style="text-align: center"><img src="/assets/blog/2026-1.13-highlights/repl_highlight.png" alt="REPL syntax highlighting" width="479"></p>
~~~

By default, the color scheme is quite conservative but it is easy to customize (see the documentation for the REPL). As an example,
here is the same code but using the Monokai color scheme:

~~~
<p style="text-align: center"><img src="/assets/blog/2026-1.13-highlights/repl_highlight_monokai.png" alt="REPL syntax highlighting with the Monokai color scheme" width="487"></p>
~~~


### New fzf-style history search

The history search (entered by default via Ctrl-R) has been redesigned and now works similarly to the command-line fuzzy finder `fzf`:

~~~
<p style="text-align: center"><img src="/assets/blog/2026-1.13-highlights/fzf.png" alt="REPL history search" width="568"></p>
~~~

~~~
<p style="text-align: center"><img src="/assets/blog/2026-1.13-highlights/fzf_LA.png" alt="REPL history search for LinearAlgebra" width="566"></p>
~~~

Among other things, the new history search has support for:

- Fuzzy searching in the history.
- Showing what REPL mode was used for the command.
- Selecting multiple search results to put into the prompt buffer.
- Syntax highlighting of the code, matching the REPL itself.

Enter the history search and type `?` to see the full help.

### Bracketed paste on Windows

[Bracketed paste](https://en.wikipedia.org/wiki/Bracketed-paste) allows an application running in a terminal to know when text is being pasted (as opposed to just being typed). This can allow for more efficient and correct processing of the text being pasted.
This functionality has been enabled on Linux and macOS for a long time but is now also finally available on Windows. As a concrete example, the videos below show the behavior of pasting a ~500-line function into the Julia REPL before and after enabling bracketed paste on Windows.

Before:
~~~
<video controls muted playsinline style="max-width: 100%">
  <source src="/assets/blog/2026-1.13-highlights/windows-paste-before.mp4" type="video/mp4">
</video>
~~~

After:
~~~
<video controls muted playsinline style="max-width: 100%">
  <source src="/assets/blog/2026-1.13-highlights/windows-paste-after.mp4" type="video/mp4">
</video>
~~~

## `@__FUNCTION__`
*Miles Cranmer, Jeff Bezanson*

Like the existing `@__MODULE__` or `@__FILE__` macros, the new `@__FUNCTION__` macro references the innermost containing function even if that function is anonymous. This should work in all kinds of functions, and is stable, unlike the internal variable `#self#`.

```julia-repl
julia> fact = n -> n <= 1 ? 1 : n * @__FUNCTION__()(n - 1);

julia> fact(5)
120
```

## Hashing changes
*Andy Dienes*, *Jameson Nash*

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

Every Julia session starts with a large number of objects that were loaded from the system image, and every package that gets loaded brings its own package image with even more of them: method tables, type information, compiled code, constants and so on. These objects are never freed, and they are rarely mutated, yet until now a full garbage collection would walk through all of them to mark them as reachable, just like any other object on the heap. For a session with a handful of large packages loaded, this could easily be the dominant cost of a full collection.

In Julia 1.13, objects in the sysimage and in package images are loaded as permanently marked and the mark phase never enters them. The few mutations that do happen to image objects (for example, when a method is added to an existing function) are tracked separately so that any new objects they point to are still kept alive. The effect is that the cost of a full collection now scales with the size of the heap that your program actually created, not with the amount of code that has been loaded.

The easiest way to see the difference is to time a full collection in a fresh session:

```julia-repl
# 1.12
julia> @time GC.gc()
  0.035493 seconds (99.90% gc time)

# 1.13
julia> @time GC.gc()
  0.000528 seconds (99.08% gc time)
```

The table below shows the time for a full collection (`GC.gc(true)`) on an Apple M4 Pro, first in a bare session and then after loading some packages of increasing size. Incremental (young generation) collections are not affected by this change and are equally fast on both versions.

@@center-table
|                    | 1.12   | 1.13  |
|--------------------|--------|-------|
| Bare session       | 35 ms  | 2 ms  |
| `using Revise`     | 50 ms  | 11 ms |
| `using Cthulhu`    | 59 ms  | 18 ms |
| `using PythonCall` | 90 ms  | 30 ms |
| `using GLMakie`    | 187 ms | 68 ms |
@@

Since full collections are triggered more often for programs with a large live heap, this also shows up as reduced overall GC time in real workloads. The following example inserts random vectors into a `Dict` that is kept alive across iterations, so that a large fraction of the allocated objects get promoted to the old generation:

```julia
function work(n)
    d = Dict{Int,Vector{Float64}}()
    for i in 1:n
        d[i % 50_000] = rand(64)
    end
    return length(d)
end

# 1.12
julia> @time work(5_000_000)
  1.699095 seconds (10.00 M allocations: 2.688 GiB, 79.80% gc time)

# 1.13
julia> @time work(5_000_000)
  0.566276 seconds (10.00 M allocations: 2.688 GiB, 44.32% gc time)
```

For more details, see [the pull request](https://github.com/JuliaLang/julia/pull/61474).

## Scheduler and interrupt fixes
*Kiran Pamnany*, *Jameson Nash*, *Ian Butterworth*

Idle threads now park in a dedicated scheduler task instead of holding on to the last task they ran, so finished tasks can be garbage collected promptly ([#57544](https://github.com/JuliaLang/julia/pull/57544)). It lands alongside fixes that make interrupts reliable again ([#62665](https://github.com/JuliaLang/julia/pull/62665)):

- Ctrl-C reaches user code again, including scripts blocked in `sleep` or IO, and `Distributed.interrupt` works.
- The REPL survives repeated and badly timed Ctrl-C presses.
- `@spawn` wakes one idle thread in the task's threadpool instead of every thread ([#61826](https://github.com/JuliaLang/julia/pull/61826)). Spawn-heavy code speeds up anywhere from not at all on macOS, to 1.1-1.6x on a 16-core Linux machine, to 10-300x on Windows and heavily oversubscribed machines, where waking every thread had been the dominant cost.
- Several lost-task and deadlock races were fixed.

And Julia 1.14 will go further, with a proper task cancellation mechanism in development.

## Introspection with type annotations

The code introspection macros (`@which`, `@code_typed`, `@code_warntype`, etc.) now accept
call expressions where arguments are given as types instead of values, using the same
`::T` syntax as in method definitions and stacktraces. Values and types can be freely mixed,
and keyword arguments are supported:

```julia-repl
julia> @which push!(::Vector{Int}, 1)
push!(a::Vector{T}, item) where T
     @ Base array.jl:1339

julia> @which sort!(::Vector{Int}; by = ::Function)
kwcall(::NamedTuple, ::typeof(sort!), v::AbstractVector{T}) where T
     @ Base.Sort sort.jl:1734
```

This means a frame can be copied straight out of a stacktrace and pasted into `@which`
to find the method that was called:

```julia-repl
julia> @which Base.Order.lt(o::Base.Order.Lt{typeof(isless)}, a::Int64, b::Int64)
lt(o::Base.Order.Lt, a, b)
     @ Base.Order ordering.jl:121
```

Broadcasting expressions are also supported in `@code_lowered`, `@code_typed`
and `@code_warntype`:

```julia-repl
julia> @code_warntype (::Vector{Int}) .+ 1.0
```

## CI debugging tracing
*Ian Butterworth*

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

It can also be enabled via the "debug logging" option on CI platforms. GitHub Actions shown here:

![GitHub Actions re-run dialog with "Enable debug logging" checked](/assets/blog/2026-1.13-highlights/enable-debug-logging.png)

## JuliaC/trim
*Cody Tapscott*, *many others*

The juliac.jl script in contrib has been supplanted by [JuliaC.jl](https://github.com/JuliaLang/Juliac.jl) and was removed from contrib.

More code can now be trimmed like finalizers, `cfunction` and `mapreduce`.

Several bugs were fixed related to the trimming process itself improving it's reliability.


## Pkg
*Kristoffer Carlsson*

Pkg has gotten quite a bit of attention for 1.13. Here we list some of the more notable changes and improvements.

### `pkg> add` now tries to add the same version as already-loaded packages

v1 Julia has always allowed changing the active project during a session, and supports stacked environments (most commonly the default environment) which introduces a rough edge that can lead to repeated precompilation of packages. For instance: a version of a package is loaded from the default environment during startup.jl, then the user adds a new package to the active project that pulls in a new version of that dependency. To respect the manifest and compat entries etc., Pkg precompiles the active project dependency graph meaning re-precompilation would happen when the package is loaded.

In 1.13 Pkg now prefers the already-loaded version of any already-loaded packages when resolving `pkg> add`, if the environment's compatibility constraints allow it, so nothing needs to be precompiled again. As usual, `pkg> status` will flag that a newer version is available.

### Change in default compression algorithm from gzip to zstd

For downloads from a package server (registries, packages and artifacts), Pkg will now by default ask for a zstd-compressed archive instead of a gzipped one. For the type of files Pkg typically downloads, zstd compression tends to have both a better compression ratio and significantly better decompression performance. As an example, downloading the packages and artifacts for the packages Plots, Makie and ModelingToolkit results in the following data:


@@center-table
|                            | gzip      | zstd      |
|----------------------------|-----------|-----------|
| Total downloads            | 405       | 405       |
| Total download size        | 307.99 MB | 239.31 MB |
| Total decompression time   | 8.77 s    | 5.50 s    |
| Average decompression time | 21.98 ms  | 13.77 ms  |
@@


### Performance improvements

Some micro-optimizations have been made to the resolver and the registry processing, leading to generally better performance of Pkg operations.
Some of these improvements have already been backported to 1.12, so to get a proper performance comparison we compare against 1.12.1, which did not get any of these backports.

To assess the impact on resolver speed, we do the following benchmark: we add Plots to an empty environment, remove it, and then benchmark the time it takes to add Plots again. This ensures that all the files for Plots are already downloaded. In addition, auto-precompilation is turned off and the registry cache is cleared so that it has to be re-read from scratch.
This means that the time spent adding Plots to this environment is mostly registry processing and resolving:

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

### Registries for packages tracked in the manifest

Previously, to instantiate a manifest you needed to manually make sure that the registries required by that manifest were available. Now, the registry for each package is stored in the manifest and automatically downloaded upon manifest instantiation (or other package operations).

### Recursively collect sources

Pkg now recursively collects `[sources]` entries from packages fetched by URL, allowing private dependency chains to resolve without requiring all dependencies of a private package to be in a registry.


### `Pkg.test` no longer defaults to enabling strict bounds checking

Previously, `Pkg.test` always launched the test process with `--check-bounds=yes`, which forces bounds checking even inside `@inbounds` blocks. Since precompile cache files are specific to the bounds-checking mode, this meant that the package being tested and all of its dependencies typically had to be recompiled before the tests could even start, and those cache files were then useless for normal development. `Pkg.test` now leaves the bounds-checking mode alone, so the test process inherits it from the parent Julia session and can reuse the precompile files generated during development. To get the old behavior, either start Julia with `--check-bounds=yes` before running `Pkg.test`, or pass the flag explicitly with `Pkg.test(; julia_args=["--check-bounds=yes"])`.

## Juliaup GUI
*Ian Butterworth*

[Juliaup](https://github.com/JuliaLang/juliaup), the Julia version manager, now has a graphical interface alongside its command line. It ships with juliaup 1.22 and later on every platform juliaup supports, so after a `juliaup self update` it can be opened with:

```
juliaup gui
```

The **Installed** tab shows each installed channel as a tile or a list row. From there a channel can be launched, launched with a custom project, arguments and environment variables, set as the default, or removed, and there are one-click actions to update everything and to garbage collect versions no channel uses any more.

~~~
<p style="text-align: center"><img src="/assets/blog/2026-1.13-highlights/juliaup-gui-installed.png" alt="The Juliaup GUI's Installed tab, showing installed Julia channels as tiles" width="900" style="max-width: 100%"></p>
~~~

The **Available** tab lists everything in the channel database, including `release`, `lts`, `rc`, `nightly` and `pr{number}` channels for testing pull requests, with an install button for each. It can also link an existing Julia binary to a custom channel name. The **Configuration** tab exposes juliaup's settings, such as the version database update interval and automatic self-updates.

~~~
<p style="text-align: center"><img src="/assets/blog/2026-1.13-highlights/juliaup-gui-available.png" alt="The Juliaup GUI's Available tab, listing channels that can be installed" width="900" style="max-width: 100%"></p>
~~~

## Acknowledgement

<!-- TODO: confirm funding acknowledgement is still applicable for this release. -->

The preparation of this release was partially funded by NASA under award 80NSSC22K1740. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Aeronautics and Space Administration.

~~~
<script>
// Group each h2 with the content that follows it, so the sections can be tinted.
(function () {
  var main = document.querySelector(".container.main");
  if (!main) return;
  var sec = null;
  Array.prototype.slice.call(main.childNodes).forEach(function (n) {
    // The table of contents is the first band; each h2 then starts a new one.
    if (n.nodeType === 1 && (n.tagName === "H2" || n.classList.contains("franklin-toc"))) {
      sec = document.createElement("section");
      sec.className = "hl-section";
      main.insertBefore(sec, n);
    }
    if (sec) sec.appendChild(n);
  });
})();
</script>
~~~
