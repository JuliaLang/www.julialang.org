+++
mintoclevel = 2
maxtoclevel = 3
title = "Julia 1.14 Highlights"
authors = "The Julia contributors"
published = "17 October 2026"
rss_pubdate = Date(2026, 10, 17)
rss = """Highlights of the Julia 1.14 release."""
+++

Julia version 1.14 has been released. We want to thank all the contributors to this release and all the testers who helped find regressions and issues in the pre-releases. Without you, this release would not have been possible.

The full list of changes can be found in the [NEWS file](https://github.com/JuliaLang/julia/blob/release-1.14/NEWS.md), but here we'll give a more in-depth overview of some of the release highlights.

\toc

## Latency improvements

### Latency numbers

**Note: the numbers in the chart below are placeholders, not real measurements.**

The chart below shows the time per task for precompiling the packages, loading them, and the first call in a fresh process with an empty (*cold*) and populated (*warm*) native code cache, as a geometric mean over the tasks of the [TTFX suite](https://github.com/tecosaur/Julia-TTFX-Snippets) that work on all versions. The numbers were measured with [this script](/assets/blog/2026-1.14-highlights/ttfx_latency.jl). *1.14+opt* is the [optimized build](#build_variants) of 1.14. Use the buttons to pick a platform.

~~~
<figure class="jllat" aria-label="Latency of Julia 1.10, 1.13 and 1.14 on the TTFX suite">
<style>
.jllat{--s1:#2a78d6;--tx:#0b0b0b;--tx2:#52514e;--bd:#d6d5d0;--sel:#f0efec;margin:1.5em 0;font-size:0.9rem;position:relative}
[data-theme="dark"] .jllat{--s1:#3987e5;--tx:#f0efec;--tx2:#c3c2b7;--bd:#555;--sel:#2a2a3e}
.jllat .ctl{margin-bottom:12px}
.jllat .grp{display:flex;flex-wrap:wrap;gap:6px}
.jllat .ctl button{font:inherit;font-size:0.85rem;color:var(--tx2);background:transparent;border:1px solid var(--bd);border-radius:999px;padding:3px 10px;cursor:pointer;display:inline-flex;align-items:center;gap:6px}
.jllat .ctl button[aria-pressed="true"]{color:var(--tx);background:var(--sel);border-color:var(--tx2)}
.jllat .panels{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,300px),1fr));gap:4px 28px}
.jllat h4{font-size:0.95rem;font-weight:600;margin:14px 0 6px;color:var(--tx)}
.jllat .row{display:grid;grid-template-columns:4.2em 1fr;align-items:center;gap:8px;margin:6px 0}
.jllat .v{color:var(--tx2);font-variant-numeric:tabular-nums;text-align:left;white-space:nowrap}
.jllat .track{display:flex;align-items:center;gap:8px;min-width:0}
.jllat .bar{display:block;height:20px;border-radius:0 4px 4px 0;transition:width .3s}
.jllat .tot{color:var(--tx);font-variant-numeric:tabular-nums;white-space:nowrap}
.jllat .tot small{color:var(--tx2);font-size:0.8rem;margin-left:4px}
.jllat figcaption{color:var(--tx2);font-size:0.85rem;margin-top:10px}
</style>
<div class="ctl"><div class="grp os" role="group" aria-label="Platform"></div></div>
<div class="panels"></div>
<figcaption></figcaption>
<script src="/assets/blog/2026-1.14-highlights/ttfx-latency-linux-x86_64.js"></script>
<script src="/assets/blog/2026-1.14-highlights/ttfx-latency-macos-aarch64.js"></script>
<script src="/assets/blog/2026-1.14-highlights/ttfx-latency-windows-x86_64.js"></script>
<script>
(function(){
var f=document.currentScript.parentNode;
var D=window.TTFX_LATENCY||{};
var M=["Precompile","Load","First call, cold cache","First call, warm cache"];
var os=Object.keys(D)[0],P=f.querySelector(".panels"),cap=f.querySelector("figcaption");
function btn(g,k,html,set){var b=document.createElement("button");b.type="button";b.innerHTML=html;b.dataset.k=k;b.onclick=function(){set(k);draw()};f.querySelector(g).appendChild(b)}
Object.keys(D).forEach(function(o){btn(".os",o,o,function(k){os=k})});
function fmt(x){return x>=10?x.toFixed(1)+" s":x.toFixed(2)+" s"}
function draw(){
  f.querySelectorAll(".os button").forEach(function(b){b.setAttribute("aria-pressed",b.dataset.k==os)});
  // Rows: [label, values]; optimized builds get their own "+opt" row.
  var R=[];
  for(var v in D[os].std){R.push([v,D[os].std[v]]);if(D[os].opt[v])R.push([v+"+opt",D[os].opt[v]])}
  var h="";
  M.forEach(function(m,i){
    // Scale each metric over all platforms and builds so switching does not rescale.
    var max=0;for(var o in D)["std","opt"].forEach(function(b){for(var v in D[o][b])max=Math.max(max,D[o][b][v][i])});
    var base=D[os].std["1.13"][i];
    h+="<div><h4>"+m+"</h4>";
    R.forEach(function(r){var val=r[1][i];
      var rel=r[0].indexOf("1.14")!=0?"":"<small>"+(val>=base?"+":"\u2212")+Math.abs(Math.round(100*(val/base-1)))+"% vs 1.13</small>";
      h+='<div class="row"><span class="v">'+r[0]+'</span><div class="track"><b class="bar" style="width:calc((100% - 8.5em) * '+(val/max).toFixed(4)+');background:var(--s1)"></b><span class="tot">'+fmt(val)+rel+'</span></div></div>'});
    h+="</div>"});
  P.innerHTML=h;
  cap.innerHTML="Geometric mean over the "+D[os].tasks+" TTFX tasks that work on all versions, on "+os+" ("+D[os].cpu+"), for Julia 1.10.12, 1.13.2 and 1.14.0-alpha1.";
}
draw();
})();
</script>
</figure>
~~~

### Native code cache
*Sam Schweigel*

Package images let precompiled code be reused across sessions, but anything not covered by precompilation (methods specialized on your own types, code in your scripts, combinations of packages that no package precompiles) is compiled by the JIT, and until now, compiled again in every new session. Restarting Julia and running the same script meant paying the same compilation cost every time. For most workflows it matters at least as much as the first run, since the same code is run over and over in new sessions.

Julia 1.14 adds a persistent cache for JIT-compiled native code ([#61527](https://github.com/JuliaLang/julia/pull/61527)). When the JIT compiles some code, the resulting object code is stored in an on-disk database in the depot (`~/.julia/cache/v1.14/`), keyed on a hash of the LLVM module and everything else that affects code generation. In a later session, compiling the same code loads the object code from the cache instead of running the LLVM optimizer and code generator. Type inference still runs, so a cache hit is not free, but LLVM is typically the larger part of compilation. The cache is shared between all environments and processes using the same depot, holds 512 MiB by default (`JULIA_OBJCACHE_CAPACITY`), and evicts the least recently used entries when it fills up. It can be disabled with `JULIA_OBJCACHE=0`.

To see the effect, we ran the tasks from [Julia-TTFX-Snippets](https://github.com/tecosaur/Julia-TTFX-Snippets), the suite that Julia's CI uses to track latency, on Julia 1.14 (Apple M4 Pro). Each task loads some packages (*load*) and then runs a small workload (*first call*), in a fresh process after the packages are precompiled. Below, the first call is measured with the cache disabled, on the first run with an empty cache, and on the second run with the cache populated by the first:

@@center-table
| Task | Load | First call, no cache | First call, 1st run | First call, 2nd run |
| --- | ---: | ---: | ---: | ---: |
| Ferrite: heat equation | 0.61 s | 6.89 s | 7.27 s | 2.29 s |
| Flux: model gradient | 1.10 s | 4.43 s | 4.22 s | 1.42 s |
| Mendeleev: element properties | 0.09 s | 1.32 s | 1.37 s | 0.59 s |
| Optimization: Rosenbrock with BFGS | 0.54 s | 1.26 s | 1.34 s | 0.53 s |
| Attractors: multistability | 1.96 s | 1.05 s | 1.07 s | 0.37 s |
| HiddenMarkovModels: Baum-Welch | 0.43 s | 1.04 s | 1.07 s | 0.47 s |
| Optim: Rosenbrock with BFGS | 0.23 s | 0.71 s | 0.75 s | 0.26 s |
| Krylov: conjugate gradient | 0.16 s | 0.59 s | 0.60 s | 0.16 s |
| CairoMakie: plot a sine wave | 3.24 s | 0.45 s | 0.45 s | 0.15 s |
| ComponentArrays: basic manipulations | 0.11 s | 0.41 s | 0.40 s | 0.13 s |
| LoopVectorization: dot product | 0.12 s | 0.35 s | 0.35 s | 0.07 s |
@@

Over the 25 tasks whose first call takes at least 0.1 s, the first call on the second run takes on average (geometric mean) 35% of the time it takes without the cache, while populating the cache on the first run costs about 3%. Load times are unchanged, since package loading mostly does not go through the JIT. After running the whole suite of 38 tasks, the cache takes up 25 MiB.


## New syntax features

### Labeled blocks and `break` with a value
*Keno Fischer*

`@label` can now create blocks that can be exited early with `break name [value]`, and `continue name` continues a labeled loop ([#60481](https://github.com/JuliaLang/julia/pull/60481)).
Breaking out of nested loops no longer needs a flag variable or a helper function:

```julia
function find_index(A, target)
    @label search for i in axes(A, 1), j in axes(A, 2)
        A[i, j] == target && break search (i, j)
    end  # evaluates to `nothing` if we never break
end

function first_row_without_negatives(A)
    @label rows for i in axes(A, 1)
        for j in axes(A, 2)
            A[i, j] < 0 && continue rows  # skip to the next row
        end
        return i
    end
    return nothing
end
```

A labeled `begin` block works like an expression that can return early:

```julia
port = @label check begin
    n = tryparse(Int, s)
    n === nothing && break check 8080
    1 <= n <= 65535 || break check 8080
    n
end
```

### `typegroup` for mutually recursive types
*Keno Fischer*

`typegroup` blocks allow defining structs whose field types reference each other ([#60569](https://github.com/JuliaLang/julia/pull/60569)).
Previously, a struct could only refer to types that were already defined, so mutually recursive types had to be
broken up with an abstract supertype or a type parameter. Now they can be written directly:

```julia
typegroup
    struct Person
        name::String
        employer::Union{Company, Nothing}
    end
    struct Company
        name::String
        employees::Vector{Person}
    end
end
```

```julia-repl
julia> c = Company("Acme", Person[]);

julia> push!(c.employees, Person("Alice", c));

julia> fieldtype(Person, :employer)
Union{Nothing, Company}

julia> c.employees[1].employer.name
"Acme"
```

Only `struct` and `mutable struct` definitions are allowed inside a `typegroup`. All the types are defined together at the end of the block.

### Explicitly wrapping arithmetic operators
*Keno Fischer*

The new `+%`, `-%` and `*%` operators mark integer arithmetic that is intended to wrap on overflow ([#50790](https://github.com/JuliaLang/julia/pull/50790)).
By default they behave exactly like `+`, `-` and `*`, so the point is to document intent, for example in hash functions:

```julia
function fnv1a(data)
    h = 0xcbf29ce484222325
    for b in codeunits(data)
        h = (h ⊻ b) *% 0x00000100000001b3  # overflow is expected here
    end
    return h
end
```

```julia-repl
julia> typemax(Int) +% 1
-9223372036854775808

julia> 0x00 -% 0x01
0xff
```

This means overflow checking can catch the overflows that were not intended while leaving the deliberate ones alone.
The experimental `Base.Experimental.@make_all_arithmetic_checked` macro makes the plain operators check for overflow
(it redefines them globally, so it is intended for testing and debugging):

```julia-repl
julia> Base.Experimental.@make_all_arithmetic_checked

julia> typemax(Int) + 1
ERROR: OverflowError: 9223372036854775807 + 1 overflowed for type Int64

julia> typemax(Int) +% 1
-9223372036854775808
```

## Inference refines field types
*Shuhei Kadowaki*

After a check like `if !isnothing(x.field)`, inference now knows the type of `x.field` inside the branch (for immutable structs and `const` fields), so the field no longer has to be copied to a local variable first ([#47574](https://github.com/JuliaLang/julia/pull/47574)).

```julia
struct Config
    timeout::Union{Int, Nothing}
end

timeout_or_default(c::Config) = !isnothing(c.timeout) ? c.timeout : 30
```

```julia-repl
# Julia 1.13
julia> Base.infer_return_type(timeout_or_default, (Config,))
Union{Nothing, Int64}

# Julia 1.14
julia> Base.infer_return_type(timeout_or_default, (Config,))
Int64
```

The same applies after a call that can only succeed for a certain type. If `only_int(::Int)` is the only matching method,
then after `only_int(c.timeout)` inference knows that `c.timeout` is an `Int`.
For non-`const` fields of mutable structs, the field could change between the check and the use,
so copying the field to a local variable first is still the way to go there.

## Precompilation improvements
*Ian Butterworth*

- Precompile workers and their LLVM threads now share one thread budget, which keeps cores busy without oversubscribing the machine ([#61958](https://github.com/JuliaLang/julia/pull/61958)).
- Packages whose dependencies failed to precompile are skipped instead of being attempted ([#63122](https://github.com/JuliaLang/julia/pull/63122)).
- Precompilation can run in a background task, with keyboard controls to cancel, detach or show progress details ([#60943](https://github.com/JuliaLang/julia/pull/60943)).
- When loading triggers precompilation, Julia now says why, and how to avoid it.

## Faster code coverage
*Tim Besard*

Coverage now records only whether a line ran by default, which lowers the runtime overhead. Instrumented package images can be reused across processes, and `--code-coverage=@path` restricts tracking to a directory tree ([#62724](https://github.com/JuliaLang/julia/pull/62724), [#62514](https://github.com/JuliaLang/julia/pull/62514)).

As an example, here is a 2D stencil kernel, a simple summation loop, and a script that loads DataFrames.jl and runs a `groupby`, each run with and without `--code-coverage=user` (Apple M4 Pro):

| | 1.13 | 1.13, coverage | 1.14 | 1.14, coverage |
| --- | ---: | ---: | ---: | ---: |
| Stencil kernel | 0.08 ms | 0.71 ms | 0.08 ms | 0.10 ms |
| Summation loop | 0.48 ms | 1.56 ms | 0.49 ms | 0.47 ms |
| DataFrames script (total process time) | 0.8 s | 2.4 s | 0.7 s | 0.6 s |

In 1.13 every coverage run recompiles the package code it calls. In 1.14 the first coverage run builds instrumented package images (about a minute for DataFrames and its dependencies) and later runs reuse them.

## Multi-threading
*Ian Butterworth*, *Jameson Nash*

- `Threads.@threads` works on array comprehensions like `@threads [f(i) for i in 1:n]` ([#59019](https://github.com/JuliaLang/julia/pull/59019)).
- The return type of `fetch(Threads.@spawn f(x))` is now inferred ([#59221](https://github.com/JuliaLang/julia/pull/59221)).
- `Threads.Atomic` supports `@atomic a[] += 1`, and plain `a[] = v` is deprecated ([#62382](https://github.com/JuliaLang/julia/pull/62382)).

## Better stack traces
*Shuhei Kadowaki*, *Ian Butterworth*

Inlined frames now show full method signatures ([#53925](https://github.com/JuliaLang/julia/pull/53925)):

```julia
@inline inner(x, y) = x[y]
outer(v) = inner(v, 10)
outer([1, 2, 3])
```

```
# Julia 1.13
 [2] checkbounds
   @ ./essentials.jl:389 [inlined]
 [3] getindex
   @ ./essentials.jl:974 [inlined]
 [4] inner
   @ ./script.jl:1 [inlined]

# Julia 1.14
 [2] checkbounds(A::Vector{Int64}, I::Int64)
   @ Base essentials.jl:391 [inlined]
 [3] getindex(A::Vector{Int64}, i::Int64)
   @ Base essentials.jl:1065 [inlined]
 [4] inner(x::Vector{Int64}, y::Int64)
   @ Main script.jl:1 [inlined]
```

Errors raised during package loading no longer show the internals of the code loading machinery ([#52988](https://github.com/JuliaLang/julia/pull/52988)).

## New library features

- `StringView` (ported from StringViews.jl) wraps a byte vector as a UTF-8 string ([#60526](https://github.com/JuliaLang/julia/pull/60526)).
- `readdir(path, DirEntry)` and the lazy `eachentry(dir)` return entries together with their file type ([#55358](https://github.com/JuliaLang/julia/pull/55358), [#62164](https://github.com/JuliaLang/julia/pull/62164)).
- `tap(f)` and `unsplat(f)` function helpers ([#61340](https://github.com/JuliaLang/julia/pull/61340), [#62714](https://github.com/JuliaLang/julia/pull/62714)).
- Dates: nanosecond-precision `Dates.Timestamp` and the `n` format code for fractional seconds ([#62994](https://github.com/JuliaLang/julia/pull/62994)).
- TOML: comments can be preserved when parsing and printing a file ([#62672](https://github.com/JuliaLang/julia/pull/62672)).
- Test: `@test` accepts a `context` keyword that is shown on failure ([#60501](https://github.com/JuliaLang/julia/pull/60501)).
- InteractiveUtils: `@methods f(args...)` lists all methods applicable to a call ([#62311](https://github.com/JuliaLang/julia/pull/62311)).
- Markdown: behavior is much closer to CommonMark, including raw HTML and strikethrough.

## REPL
- Tab completion of `Module.<TAB>` lists public names first ([#63601](https://github.com/JuliaLang/julia/pull/63601)).
- `using A, B, C` precompiles all packages in one parallel session.
- The REPL emits OSC 133 "semantic prompt" markers ([#63112](https://github.com/JuliaLang/julia/pull/63112)). These invisible
  escape sequences tell the terminal where each prompt, input and output begins, the same way shells like zsh and fish do.
  In terminals that support them (e.g. VS Code, iTerm2, kitty, WezTerm, Ghostty and Windows Terminal), you can jump
  between previous prompts in a long REPL session instead of scrolling, select or copy the output of a single command,
  and in VS Code, copy a command together with its output. Terminals without support ignore the markers, and they can be
  turned off with `repl.options.semantic_prompts = false` in an `atreplinit` hook in `startup.jl`.
- `-P` is a shorthand for `--project` ([#59867](https://github.com/JuliaLang/julia/pull/59867)).

## JuliaLowering
*Em Chu*, *Claire Foster*

THE DEFAULT MIGHT CHANGE

JuliaLowering, the new lowering pass written in Julia, now ships compiled into Julia. The old flisp lowering is still the default; JuliaLowering can be enabled with `JULIA_USE_FLISP_LOWERING=false` ([#63614](https://github.com/JuliaLang/julia/pull/63614)).

## JuliaC/trim
*Gabriel Baraldi*, *Cody Tapscott*

Julia now installs a static `libjulia-internal.a`, so JuliaC.jl can link a trimmed program into a single executable ([#63618](https://github.com/JuliaLang/julia/pull/63618)). `Libdl.LazyLibraryCallback` makes lazy library callbacks work under `--trim`.

## Build

### LLVM 23
*Tim Besard*

Julia has been upgraded to LLVM 23 ([#63626](https://github.com/JuliaLang/julia/pull/63626)).
Besides the usual improvements to code generation, LLVM 23 is also faster at compiling code itself, which directly
reduces latency in Julia. On the TTFX benchmark suite, precompilation got about 4% faster and the first call into
freshly loaded packages about 3.5% faster (geometric mean over 38 workloads).

Julia is not the only one seeing this. The Rust compiler also saw an
[unexpectedly large improvement from LLVM 23](https://yoyo-code.com/2026-is-exciting-year-for-rust-compiler-and-me/#llvm-is-getting-faster).
Thanks to the LLVM developers who have spent so much effort on making LLVM itself faster over the past releases!

### Build variants
*TODO: authors*

Besides the standard binaries, Julia 1.14 is released in two variants that previously only existed as nightlies or had to be built from source:

@@center-table
| Variant | What is different | Platforms | juliaup channel |
| --- | --- | --- | --- |
| Optimized (`+opt`) | Built with PGO and ThinLTO, plus BOLT on Linux | Linux (x86-64, i686, aarch64), macOS (x86-64, Apple silicon), Windows (x86-64) | `1.14+opt`, `release+opt` |
| Assertions (`+assert`) | Assertions enabled in the runtime and in LLVM | Linux (x86-64) | `1.14+assert`, `release+assert` |
@@

The **optimized build** is built with `make -C contrib/optimized` ([#63179](https://github.com/JuliaLang/julia/pull/63179)), which builds Julia and LLVM in two stages. The first stage is instrumented and is used to build the system image and the stdlib package images, which records a profile of where the compiler spends its time. The second stage is built with profile-guided optimization (PGO) using that profile and with ThinLTO. Since LLVM is built from source in both stages, libLLVM gets PGO and LTO too, which matters for latency since a large part of compilation time is spent in LLVM. On Linux x86-64 and aarch64, `libLLVM`, `libjulia-internal` and `libjulia-codegen` are then additionally optimized with [BOLT](https://github.com/llvm/llvm-project/tree/main/bolt), which reorders the machine code based on a profile from the same workload ([#62725](https://github.com/JuliaLang/julia/pull/62725), [#63162](https://github.com/JuliaLang/julia/pull/63162), [#63214](https://github.com/JuliaLang/julia/pull/63214), [#63312](https://github.com/JuliaLang/julia/pull/63312)). The optimized build makes compilation faster across the board. The *1.14+opt* rows in the [latency chart](#latency_improvements) above show how much.

The **assertion build** has the C/C++ assertions in Julia's runtime and LLVM's assertions enabled, and verifies the LLVM IR after Julia's own LLVM passes. It is slower than the standard build, but when Julia crashes or miscompiles something it often turns the problem into a failed assertion close to the actual bug. If you hit a segfault or an internal error, checking whether it reproduces on the assertion build and including the result in the bug report is very helpful.

The easiest way to install a variant is with [juliaup](https://github.com/JuliaLang/juliaup), where it installs next to the standard build:

```
juliaup add 1.14+opt
julia +1.14+opt
```

The binaries can also be downloaded directly, e.g. `https://julialang-s3.julialang.org/bin/linuxopt/x86_64/1.14/julia-1.14.0-linuxopt-x86_64.tar.gz` (`macosopt` and `windowsopt` for the other platforms). TODO: link from the downloads page. The macOS app and the Windows installer of a variant are named e.g. `Julia-1.14-opt`, so they also install next to the standard build. The REPL banner and `versioninfo()` show which variant is running, e.g. `Version 1.14.0+opt` ([#64024](https://github.com/JuliaLang/julia/pull/64024)).

Optimized and assertion builds are also available as nightlies (`juliaup add nightly+opt`).

TODO: check that the #64024 and #64005 (cross-compiled opt builds, for RISC-V) backports have landed on release-1.14.

### RISC-V builds
*Tim Besard*

Julia 1.14 comes with prebuilt binaries for 64-bit RISC-V Linux (`rv64gc`), for both releases and nightlies. TODO: download link. The binaries are cross-compiled on x86-64 machines, with the parts of the build that run Julia (system image, package images and docs) running under QEMU.

1.14 also fixes a range of RISC-V issues ([#62951](https://github.com/JuliaLang/julia/pull/62951), [#62995](https://github.com/JuliaLang/julia/pull/62995)): `ccall` now passes and returns structs correctly according to the native ABI, hardware `fma` is detected and used, and `@code_native` highlights RISC-V assembly and shows branch targets as labels.

Since CI has no RISC-V hardware, the builds are not tested and RISC-V remains a [Tier 3](/downloads/support/) platform. Bug reports from people running Julia on RISC-V are very welcome.

### Smaller Julia installation and package images
*Kristoffer Carlsson*

A Julia installation takes up considerably less disk space in 1.14, as do the package images of the packages you install. Most of the savings come from shrinking debug info while keeping Julia stack traces unchanged:

- The C/C++ runtime is built with line tables only ([#63641](https://github.com/JuliaLang/julia/pull/63641)). Together with the compression below, `libjulia-codegen` shrinks from 84 MiB in 1.13 to 6 MiB on Linux, and from 122 MiB to 15 MiB on Windows.
- Code in the system image and in package images gets only line tables as well ([#63937](https://github.com/JuliaLang/julia/pull/63937)). Julia already rebuilds inlined frames in stack traces from its own debug info, so the inlining information in DWARF was mostly unused. On Linux, the debug info in the system image goes from 73 MiB to 20 MiB. As a bonus, the first stack trace in a session is printed about twice as fast and uses about 40 MiB less memory. External tools like `gdb` and `perf` no longer see inlined frames in precompiled code.
- Julia emits DWARF 5, which has more compact debug info than DWARF 4 ([#63639](https://github.com/JuliaLang/julia/pull/63639)).
- On Linux and FreeBSD, debug sections of package images, Julia's own libraries and bundled libraries are compressed ([#63642](https://github.com/JuliaLang/julia/pull/63642), [#63640](https://github.com/JuliaLang/julia/pull/63640), [#63687](https://github.com/JuliaLang/julia/pull/63687), [#63810](https://github.com/JuliaLang/julia/pull/63810)). Combined with the line tables above, the debug info in the bundled stdlib package images drops from 54 MiB to 5 MiB.
- The stdlib package images compiled with `--check-bounds=yes` are no longer bundled. Since `Pkg.test` no longer forces bounds checking (as of 1.13), these are rarely needed, and they are now distributed as a separate archive ([#60054](https://github.com/JuliaLang/julia/pull/60054)).

The chart below shows the size of an unpacked Julia installation, split by component. Use the buttons to look at the download size or at a single component, and hover over a bar for its size. The installation is about a third smaller than 1.13 on all three platforms and close to the size of 1.10 again.

~~~
<figure class="jlsize" aria-label="Size of Julia 1.10, 1.13 and 1.14 by component">
<style>
.jlsize{--s1:#2a78d6;--s2:#eb6834;--s3:#1baf7a;--s4:#eda100;--s5:#e87ba4;--s0:#8a8984;--tx:#0b0b0b;--tx2:#52514e;--bd:#d6d5d0;--sel:#f0efec;--tip:#fff;margin:1.5em 0;font-size:0.9rem;position:relative}
[data-theme="dark"] .jlsize{--s1:#3987e5;--s2:#d95926;--s3:#199e70;--s4:#c98500;--s5:#d55181;--s0:#8a8984;--tx:#f0efec;--tx2:#c3c2b7;--bd:#555;--sel:#2a2a3e;--tip:#2a2a3e}
.jlsize .ctl{display:flex;flex-wrap:wrap;gap:6px;margin-bottom:12px}
.jlsize .ctl button{font:inherit;font-size:0.85rem;color:var(--tx2);background:transparent;border:1px solid var(--bd);border-radius:999px;padding:3px 10px;cursor:pointer;display:inline-flex;align-items:center;gap:6px}
.jlsize .ctl button[aria-pressed="true"]{color:var(--tx);background:var(--sel);border-color:var(--tx2)}
.jlsize .ctl i,.jlsize .lg i{width:10px;height:10px;border-radius:2px;display:inline-block}
.jlsize .lg{display:flex;flex-wrap:wrap;gap:4px 16px;margin-bottom:8px;color:var(--tx2);min-height:1.4em}
.jlsize .lg span{display:inline-flex;align-items:center;gap:6px}
.jlsize h4{font-size:0.95rem;font-weight:600;margin:14px 0 6px;color:var(--tx)}
.jlsize .row{display:grid;grid-template-columns:3.2em 1fr;align-items:center;gap:8px;margin:5px 0}
.jlsize .v{color:var(--tx2);font-variant-numeric:tabular-nums;text-align:right}
.jlsize .track{display:flex;align-items:center;gap:8px;min-width:0}
.jlsize .bar{display:flex;gap:2px;height:20px;transition:width .3s}
.jlsize .bar b{display:block;height:100%;min-width:2px}
.jlsize .bar b:first-child{border-top-left-radius:4px;border-bottom-left-radius:4px}
.jlsize .bar b:last-child{border-top-right-radius:4px;border-bottom-right-radius:4px}
.jlsize .bar b:hover{opacity:0.8}
.jlsize .tot{color:var(--tx);font-variant-numeric:tabular-nums;white-space:nowrap}
.jlsize .tot small{color:var(--tx2);font-size:0.8rem;margin-left:4px}
.jlsize .tt{position:absolute;pointer-events:none;background:var(--tip);color:var(--tx);border:1px solid var(--bd);border-radius:6px;padding:6px 8px;font-size:0.8rem;box-shadow:0 2px 8px rgba(0,0,0,.15);display:none;white-space:nowrap;z-index:5}
.jlsize figcaption{color:var(--tx2);font-size:0.85rem;margin-top:10px}
</style>
<div class="ctl" role="group" aria-label="Metric"></div>
<div class="lg"></div>
<div class="panels"></div>
<div class="tt"></div>
<figcaption></figcaption>
<script>
(function(){
var f=document.currentScript.parentNode;
var D={"Linux (x86-64)":{"1.10":{"sys":253.0,"pkg":50.3,"rt":76.9,"libs":169.9,"other":50.7,"total":601.0,"dl":167.2},"1.13":{"sys":272.9,"pkg":374.3,"rt":98.9,"libs":219.3,"other":60.1,"total":1025.4,"dl":287.9},"1.14":{"sys":241.5,"pkg":145.0,"rt":19.3,"libs":205.7,"other":71.1,"total":682.6,"dl":217.9}},"macOS (Apple silicon)":{"1.10":{"sys":219.6,"pkg":49.8,"rt":46.1,"libs":91.6,"other":58.8,"total":465.9,"dl":124.0},"1.13":{"sys":230.4,"pkg":308.6,"rt":52.0,"libs":110.1,"other":63.9,"total":765.0,"dl":213.1},"1.14":{"sys":200.7,"pkg":128.6,"rt":20.3,"libs":105.6,"other":69.9,"total":525.2,"dl":162.7}},"Windows (x86-64)":{"1.10":{"sys":251.8,"pkg":52.5,"rt":119.5,"libs":243.8,"other":51.7,"total":719.4,"dl":180.4},"1.13":{"sys":261.8,"pkg":366.8,"rt":139.3,"libs":264.8,"other":59.7,"total":1092.4,"dl":288.6},"1.14":{"sys":231.1,"pkg":156.3,"rt":31.1,"libs":242.0,"other":71.0,"total":731.4,"dl":213.4}}};
var C=[["sys","System image","--s1"],["pkg","Stdlib package images","--s2"],["rt","libjulia","--s3"],["libs","LLVM and other libraries","--s4"],["other","Sources, docs, other","--s5"]];
var M=[["total","Installed size",null,"Size on disk of the unpacked official binaries, split by component."],["dl","Download",null,"Size of the <code>.tar.gz</code> archive."]].concat(C.slice(0,3).map(function(c){return [c[0],c[1],c[2],"Size on disk of this component in the unpacked official binaries."]}));
var cur="total",ctl=f.querySelector(".ctl"),lg=f.querySelector(".lg"),P=f.querySelector(".panels"),tt=f.querySelector(".tt"),cap=f.querySelector("figcaption");
function sw(v){return '<i style="background:var('+v+')"></i>'}
M.forEach(function(m){var b=document.createElement("button");b.type="button";b.innerHTML=(m[2]?sw(m[2]):"")+m[1];b.onclick=function(){cur=m[0];draw()};b.dataset.k=m[0];ctl.appendChild(b)});
function draw(){
  var m=M.filter(function(x){return x[0]==cur})[0],max=0;
  ctl.querySelectorAll("button").forEach(function(b){b.setAttribute("aria-pressed",b.dataset.k==cur)});
  lg.style.display=cur=="total"?"":"none";lg.innerHTML=cur=="total"?C.map(function(c){return "<span>"+sw(c[2])+c[1]+"</span>"}).join(""):"";
  for(var o in D)for(var v in D[o])max=Math.max(max,D[o][v][cur]);
  var h="";
  for(var o in D){h+="<h4>"+o+"</h4>";var base=D[o]["1.13"][cur];
    for(var v in D[o]){var d=D[o][v],val=d[cur],segs;
      if(cur=="total")segs=C.map(function(c){return '<b style="flex:'+d[c[0]]+' 0 0;background:var('+c[2]+')" data-t="'+c[1]+': '+Math.round(d[c[0]])+' MiB"></b>'}).join("");
      else segs='<b style="flex:1 0 0;background:var('+(m[2]||"--s0")+')" data-t="'+m[1]+': '+val.toFixed(1)+' MiB"></b>';
      var rel=v!="1.14"?"":"<small>"+(val>=base?"+":"\u2212")+Math.abs(Math.round(100*(val/base-1)))+"% vs 1.13</small>";
      h+='<div class="row"><span class="v">'+v+'</span><div class="track"><div class="bar" style="width:calc((100% - 9.5em) * '+(val/max).toFixed(4)+')">'+segs+'</div><span class="tot">'+Math.round(val)+' MiB'+rel+'</span></div></div>'}}
  P.innerHTML=h;
  cap.innerHTML=m[3]+" Julia 1.10.12, 1.13.2 and 1.14.0-alpha1, in MiB.";
}
f.addEventListener("mousemove",function(e){var b=e.target.closest(".bar b");if(!b){tt.style.display="none";return}var r=f.getBoundingClientRect();tt.textContent=b.dataset.t;tt.style.display="block";var x=e.clientX-r.left+12;if(x+tt.offsetWidth>r.width)x=e.clientX-r.left-tt.offsetWidth-12;tt.style.left=x+"px";tt.style.top=(e.clientY-r.top-34)+"px"});
f.addEventListener("mouseleave",function(){tt.style.display="none"});
draw();
})();
</script>
</figure>
~~~

The savings also apply to the package images of packages you install. For example, on Linux an environment with DataFrames, CSV, Plots, OrdinaryDiffEq and JuMP (329 package images) takes up 659 MiB of precompile cache, compared with 859 MiB on 1.13. The debug info in those package images drops from 106 MiB to 8 MiB.

## Pkg
*Kristoffer Carlsson*, *Ian Butterworth*, *Stefan Karpinski*, *others*

### Faster first Pkg operation

Previously, the first time a session used the registry, Pkg had to decompress the whole registry tarball and walk its ~75k entries with Tar, creating a string for every file in it, even though only a few packages were needed. The registry is now cached on disk in a binary format with a per-package index, and memory-mapped so that a session only reads the packages it uses. This makes the first Pkg operation in a session noticeably faster ([Pkg#4797](https://github.com/JuliaLang/Pkg.jl/pull/4797)). For example, the first `Pkg.status()` in a fresh session for a project with a single dependency, on Julia 1.13:

```julia-repl
julia> using Pkg

julia> @time Pkg.status()
Status `~/ex/Project.toml`
  [7876af07] Example v0.5.5
  0.150727 seconds (1.27 M allocations: 93.000 MiB, 32.88% gc time, 8.05% compilation time)
```

and on Julia 1.14:

```julia-repl
julia> using Pkg

julia> @time Pkg.status()
Status `~/ex/Project.toml`
  [7876af07] Example v0.5.5
  0.045183 seconds (223.04 k allocations: 13.359 MiB, 39.54% gc time, 5.67% compilation time)
```

### SAT-based resolver

Pkg now uses the SAT-based resolver from [Resolver.jl](https://github.com/JuliaLang/Resolver.jl). It is typically faster, and when resolution fails it explains each conflict and suggests changes that would fix it ([Pkg#4738](https://github.com/JuliaLang/Pkg.jl/pull/4738)).

As an example, here is the error from asking for two incompatible versions with `pkg> add DataFrames@1.7 PrettyTables@1`. With the old resolver:

```
Unsatisfiable requirements detected for package DataFrames [a93c6f00]:
 DataFrames [a93c6f00] log:
 ├─possible versions are: 0.11.7 - 1.8.2 or uninstalled
 ├─restricted to versions * by project [c0971505], leaving only versions: 0.11.7 - 1.8.2
 │ └─project [c0971505] log:
 │   ├─possible versions are: 0.0.0 or uninstalled
 │   └─project [c0971505] is fixed to version 0.0.0
 ├─restricted to versions 1.7 by an explicit requirement, leaving only versions: 1.7.0 - 1.7.1
 └─restricted by compatibility requirements with PrettyTables [08abe8d2] to versions: [0.11.7 - 0.21.8, 1.0.0 - 1.3.6] or uninstalled — no versions left
   └─PrettyTables [08abe8d2] log:
     ├─possible versions are: 0.1.0 - 3.5.0 or uninstalled
     ├─restricted to versions * by project [c0971505], leaving only versions: 0.1.0 - 3.5.0
     │ └─project [c0971505] log: see above
     └─restricted to versions 1 by an explicit requirement, leaving only versions: 1.0.0 - 1.3.1
```

With the new resolver:

```
Unsatisfiable requirements detected — 1 conflict:

Conflict 1: DataFrames
  • your compat restricts DataFrames to 1.7.0–1.7.1
  • DataFrames 1.7.0–1.7.1 requires PrettyTables 2.1.0–2.4.0
  • your compat restricts PrettyTables to 1.0.0–1.3.1
  Fix it by any one of:
    1. relax your compat on DataFrames
       → allows: DataFrames 1.3.6, PrettyTables 1.3.1
    2. relax your compat on PrettyTables
       → allows: DataFrames 1.7.1, PrettyTables 2.4.0
    3. drop dependency DataFrames
       → allows: PrettyTables 1.3.1
  Note: dropping dependency PrettyTables does not help.
```

The new resolver is also faster. The table below shows the time for the resolve step of `Pkg.add` against the General registry (warm process, best of 3). The resulting manifests are identical in all cases.

@@center-table
| Packages added                                       | Old resolver | New resolver |
|------------------------------------------------------|--------------|--------------|
| JSON                                                 | 0.37 s       | 0.01 s       |
| Plots                                                | 0.35 s       | 0.06 s       |
| Makie                                                | 0.34 s       | 0.10 s       |
| DifferentialEquations                                | 0.42 s       | 0.31 s       |
| Symbolics                                            | 1.36 s       | 0.13 s       |
| DataFrames + CSV                                     | 0.34 s       | 0.02 s       |
| Plots + DiffEq + Makie + Symbolics + DataFrames + Flux | 2.13 s     | 0.33 s       |
@@

The old resolver can still be selected with `JULIA_PKG_RESOLVER=maxsum`.

### `[compat-overrides]`

A new project file section replaces all compat constraints on a package, for example to try a new version that a dependency does not allow yet ([Pkg#4841](https://github.com/JuliaLang/Pkg.jl/pull/4841)).

### `pkg> add --from`

Adds the direct dependencies of another environment, e.g. to populate `@v1.14` from `@v1.13` ([Pkg#4777](https://github.com/JuliaLang/Pkg.jl/pull/4777)).

### Lazy add/update

`Pkg.add`, `Pkg.update` and `Pkg.resolve` accept `lazy=true` to update the project and manifest without installing anything.

### `Pkg.why` prints a tree

`Pkg.why` now prints a dependency tree instead of listing every path, which could run to thousands of lines ([Pkg#4839](https://github.com/JuliaLang/Pkg.jl/pull/4839)).
Here is why PrecompileTools ends up in an environment with CSV and DataFrames:

```
(whyenv) pkg> why PrecompileTools
  PrecompileTools
  ├─← CSV
  ├─← DataFrames
  ├─← Parsers
  │   └─← CSV
  ├─← PrettyTables
  │   └─← DataFrames
  └─← StringManipulation
      └─← PrettyTables (*)
```

Each package's dependents are listed only once, and later occurrences are marked with `(*)`, which keeps the
output small even when there are many paths. With `--forward` the same information is printed starting from the
project's direct dependencies instead:

```
(whyenv) pkg> why --forward PrecompileTools
  CSV
  ├─→ Parsers
  │   └─→ PrecompileTools
  └─→ PrecompileTools
  DataFrames
  ├─→ PrecompileTools
  └─→ PrettyTables
      ├─→ PrecompileTools
      └─→ StringManipulation
          └─→ PrecompileTools
```

### Environment IDs in manifests

Manifests now record an `environment_id`, which Julia uses in precompile cache file names so that environments at the same path (e.g. in containers sharing a depot) no longer overwrite each other's caches ([Pkg#4824](https://github.com/JuliaLang/Pkg.jl/pull/4824)).

### Other changes

- `Pkg.instantiate(; update_on_mismatch=true)` falls back to updating when the manifest is stale ([Pkg#4678](https://github.com/JuliaLang/Pkg.jl/pull/4678)).
- `Pkg.activate` warns when loaded packages differ from those in the new environment ([Pkg#4679](https://github.com/JuliaLang/Pkg.jl/pull/4679)).
- Artifact selection hooks can load their package's dependencies ([Pkg#4747](https://github.com/JuliaLang/Pkg.jl/pull/4747)).

## Bugs found by formalizing Base in Lean
*Miles Cranmer*

During the 1.14 release cycle, Miles Cranmer [modelled parts of Base in Lean 4](https://discourse.julialang.org/t/formalizing-julia-in-lean-and-finding-400-bugs-in-base/140243) with the help of AI agents. Each Julia function gets a Lean definition that follows the source line by line, including integer wraparound and which exceptions get thrown. Properties taken from docstrings and the manual are then stated as theorems for the agents to prove. When a proof fails, the counterexample usually points to a bug, which only counts once a plain Julia script reproduces it. The models, the properties and all bugs found are in the [julia-in-lean](https://github.com/MilesCranmer/julia-in-lean) repository.

So far this has found around 400 bugs. Many of them are edge cases at `typemin`, empty collections or unsigned types. For example, `reverse` negates the step of a range, and negating `typemin(Int8)` wraps back to itself:

```julia-repl
julia> r = Int8(0):typemin(Int8):typemin(Int8)
0:-128:-128

julia> length(r), length(reverse(r))
(2, 0)
```

The ones that seemed worth a maintainer's time were filtered by hand, checked for duplicates and filed as [issues by @MilesCranmerBot](https://github.com/JuliaLang/julia/issues?q=author%3AMilesCranmerBot). Fixes for many of them, also from @MilesCranmerBot, were [merged](https://github.com/JuliaLang/julia/pulls?q=is%3Apr+author%3AMilesCranmerBot+is%3Amerged), most of them marked for backport to 1.14. They cover things like `deleteat!`, `partialsort`, `LinearIndices`, `maximum` with `dims` on all-`missing` arrays, `circshift!` on an empty `BitVector`, BigFloat parsing, and the TOML parser. The approach also found a [miscompilation](https://github.com/JuliaLang/julia/issues/64183) that was introduced during 1.14 development, where inference reused an `isa` check from an earlier loop iteration.

We are excited about combining formal methods with AI to find bugs, and we hope this effort continues and catches more severe bugs in the future.
