@def title = "This Month in Julia World (January 2026)"
@def authors = "Stefan Krastanov"
@def published = "1 February 2026"
@def rss_pubdate = Date(2026, 2, 1)
@def rss = """Community Newsletter for January 2026"""

A monthly newsletter, mostly on julia internals, digestible for casual observers. A biased, incomplete, editorialized list of what a clique of us found interesting this month, with contributions from the community.

If you want to receive the newsletter as an email, subscribe to the [Community--Newsletter category on Discourse](https://discourse.julialang.org/c/community/news/66).

For recent news on Julia and interesting conversations with community members, check out the [JuliaDispatch](https://juliadispatch.fm/) podcast (on many platforms, including [youtube](https://www.youtube.com/@JuliaDispatch/) and [spotify](https://open.spotify.com/show/6Y1zWtFhjqPLsFQWRvZmws)). Highlights from the newsletter get discussed (with more context) during some episodes.

Current status: Julia release is 1.12.4, Julia LTS is 1.10.10. The feature freeze for 1.13 has passed and we are already at 1.13-beta2. The dev branch is at 1.14-dev

JuliaCon Global 2026:

- The [Call for Proposals](https://juliacon.org/2026/cfp) is out—submit your talks until February 28th!
- Follow JuliaCon on [Bluesky](https://bsky.app/profile/juliacon.org) for news and updates about JuliaCon.

"Internals" Fora and Core Repos (Slack/Zulip/Discourse/Github):

- Max Horn has made more than 30 PRs improving the Markdown stdlib, bringing it closer to CommonMark compliance. Recent changes include support for [strikethrough](https://github.com/JuliaLang/julia/pull/60537), [HTML entities](https://github.com/JuliaLang/julia/pull/60629), [email autolinks](https://github.com/JuliaLang/julia/pull/60570), [non-breaking space preservation](https://github.com/JuliaLang/julia/pull/60759), [HTML blocks](https://github.com/JuliaLang/julia/pull/60632), [Windows line endings](https://github.com/JuliaLang/julia/pull/60708), and [proper list marker handling](https://github.com/JuliaLang/julia/pull/60707) among many others. CommonMark is the widely-adopted specification for Markdown syntax, and these improvements mean Julia's built-in Markdown rendered will be closer to other platforms and editors.

- To address continual regressions in Julia's latency, Gabriel Baraldi has [reviewed the compiler for microoptimization opportunities](https://github.com/JuliaLang/julia/issues/60802) and implemented a series of PRs \[[1](https://github.com/JuliaLang/julia/pull/60831), [2](https://github.com/JuliaLang/julia/pull/60852), [3](https://github.com/JuliaLang/julia/pull/60853), [4](https://github.com/JuliaLang/julia/pull/60795)\] to speed it up. Each PR provides a small latency improvement, but together they contribute to keeping compilation times manageable.

- [A new PR](https://github.com/JuliaLang/julia/pull/60529) introduces a compiler frontend API that does not depend on `Expr` when implementing `include_string()`, `eval()`, and other compiler frontend functions -- rather it uses a more principled well-defined interface that can be defined for `Expr` but also for more advanced code representations with deeper provenance metadata. This paves the way for using JuliaSyntax and JuliaLowering as the default frontend while preserving full expression provenance—important for tooling like Revise and Cthulhu that need to track where code came from. The PR also lays groundwork for syntax versioning, allowing modules to opt into different Julia syntax versions similarly to Rust Editions.

- [A work-in-progress PR](https://github.com/JuliaLang/julia/pull/60879) adds an optimizer pass for instruction sinking. This is a compiler optimization where the compiler reorders code to defer computation into branches where the result is actually needed, avoiding unnecessary work in branches that don't use the result.

- [A PR](https://github.com/JuliaLang/julia/pull/60568) proposes switching to [mimalloc](https://github.com/microsoft/mimalloc) as the primary allocator for GC objects. System allocators can be inefficient, especially on Windows where freeing large amounts of memory can cause near-hangs—one case took 2 minutes to free 8GB of memory. Mimalloc is a general-purpose high-performance allocator from Microsoft that has shown consistent improvements across platforms.

- A [major overhaul of StyledStrings](https://github.com/JuliaLang/julia/pull/60527) is underway, addressing pain points that emerged since the initial design. Changes include value-parameterized annotations for better static compilation, a new `face""` syntax for face interning, face namespacing, and light/dark theming support. StyledStrings enables rich text formatting in Julia's REPL and other text interfaces.

- Invoking a constant `CodeInstance` [is now much more efficient](https://github.com/JuliaLang/julia/pull/60442). While most users won't interact with CodeInstances directly (an internal representation of compiled Julia code), this enables advanced use cases like bypassing dynamic dispatch by explicitly choosing which compiled code to execute for a given function call.

- When building an executable with `--trim` fails because of an unresolved call, [the error is now more readable](https://github.com/JuliaLang/julia/pull/60350). The `--trim` flag enables dead-code elimination during ahead-of-time compilation, producing smaller binaries, but requires all code paths to be statically resolvable.

- [A new PR](https://github.com/JuliaLang/julia/pull/60858) improves cross-references in docstrings by adding "See also" sections and homogenizing their style across Base.

- [A new PR](https://github.com/JuliaLang/julia/pull/60923) adds an API for non-native compilers (like GPUCompiler.jl) to cache their CodeInstances during precompilation. Previously, CodeInstances with non-nothing `owner` fields could be silently dropped during serialization, causing cache misses for GPU-compiled code.

- Julia now supports [LLVM's `-time-trace` feature](https://github.com/JuliaLang/julia/pull/60777), which generates Chrome trace format JSON files visualizing compilation time spent in different LLVM passes. These traces can be viewed in Chrome's tracing UI or Perfetto, providing detailed insights into where JIT compilation time is spent.

- [A new PR](https://github.com/JuliaLang/julia/pull/60794) makes ahead-of-time compilation use more (all available) threads. This helps packages with one large compilation unit, reducing Documenter's compilation time from 16 to 13 seconds in testing. Tuning the number of threads is a difficult problem (if one wants to avoid oversubscription and resource exhaustion on a user's PC). Further work on a jobserver (a standard for resource management in compilers) is planned to manage these issues.

- The [Julia CI Timing Dashboard](https://juliaci.github.io/julia-ci-timing/) provides an interactive visualization of CI test performance over time. Users can filter by platform, job type, and execution state, while the tool automatically identifies job breakages and computes trend analysis. This is a valuable resource for compiler developers and users curious about Julia's CI health. In particular, it is useful for tracking trends in precompilation performance.

- A [discussion on juliac and packages](https://discourse.julialang.org/t/juliac-using-packages/135103) explores the challenges of using common packages (TOML, CSV, DataFrames) with Julia's new ahead-of-time compiler. The core issue is type stability—juliac requires types to be known at compile time, which conflicts with how many data-handling packages construct tables and parse formats at runtime. Type-stable alternatives like TypedTables and StructArrays work better, but the discussion highlights fundamental tradeoffs between dynamic convenience and static compilation.

Ecosystem Fora, Maintenance, and Colab Promises (Slack/Zulip/Discourse/Github):

- **GitHub Dependabot now supports Julia** ([Previously announced, but now with a detailed PSA](https://discourse.julialang.org/t/psa-github-dependabot-now-supports-julia/134997)). This enables automatic dependency updates with several advantages over CompatHelper: CI runs automatically without manual intervention, checked-in manifests are updated (with resolver errors shown in the PR body if updates fail), and Julia 1.12+ workspace support coordinates updates across multiple environments. Integration with GitHub's CVE management is also on the roadmap.

- [BorrowChecker.jl](https://discourse.julialang.org/t/ann-automatic-borrow-checking-at-the-compiler-level-with-borrowchecker-auto/135011) now provides automatic Rust-like borrow checking at the compiler level. The `@auto` macro analyzes Julia's SSA-form IR to detect aliasing violations (mutating a value while another binding references it) and escape violations (storing a mutable value externally then continuing to use it locally). Unlike Rust, mutability is inferred from low-level operations rather than requiring explicit `mut` declarations.

- [Julia-MCP](https://discourse.julialang.org/t/ann-julia-mcp-persistent-julia-sessions-for-ai-assistants/135386) is an MCP (Model Context Protocol) server that maintains persistent Julia sessions for AI assistants like Claude Code and VS Code Copilot. Instead of paying startup and compilation costs on every code execution, variables, functions, and packages persist between executions. The tool automatically manages sessions, isolates projects, and integrates Revise.jl to pick up code changes.

- [GRPCServer.jl](https://discourse.julialang.org/t/ann-grpcserver-jl-a-native-grpc-server-implementation-for-julia/135053) is a native gRPC server implementation for Julia. While client-side gRPC support existed through gRPCClient.jl, this package fills the gap for server-side functionality, supporting all RPC patterns (unary, streaming, bidirectional), TLS/mTLS, reflection, health checks, and an interceptor system for logging and auth.

- [Epicycle.jl](https://discourse.julialang.org/t/ann-epicycle-jl-initial-release-space-mission-design-and-trajectory-optimization/135024) is an integrated application for spacecraft trajectory design, optimization, and analysis. Built as 10 specialized packages that work together or independently, it provides trajectory propagation with event detection, graph-based mission planning modeled after NASA's Copernicus, SPICE ephemeris integration, and 3D visualization with spacecraft CAD models. The initial release features 95% code coverage with astrodynamics algorithms validated against NASA GMAT and Astropy.

- [MakieBake.jl](https://github.com/JuliaAPlavin/MakieBake.jl) "bakes" Makie plots into lightweight interactive HTML files. It pre-renders all parameter combinations as static PNGs, then generates an HTML interface with sliders that swap between images—no Julia, server, or runtime required. This is useful for sharing explorable visualizations with collaborators who don't have Julia installed.

- [Breeze.jl](https://discourse.julialang.org/t/ann-breeze-jl-gpu-based-high-res-atmospheric-modeling-based-on-oceananigans-jl/135347) is a GPU-first, finite volume, pure Julia package for atmospheric modeling built on [Oceananigans.jl](https://github.com/CliMA/Oceananigans.jl). This adds atmospheric simulation capabilities to an ecosystem that has been primarily focused on ocean modeling.

- [Glossaries.jl](https://discourse.julialang.org/t/ann-glossaries-jl/134991) addresses repetition in package documentation by allowing developers to define reusable entries for parameters, keywords, and mathematical terms. These entries can be interpolated into docstrings with consistent formatting, and typo fixes propagate automatically. The Manopt.jl package demonstrates this approach for frequently-used parameters like manifolds and cost functions.

- A [sand simulation game](https://discourse.julialang.org/t/sand-simulation-written-in-julia-wasm-web-game/135391) demonstrates compiling Julia to WebAssembly using StaticCompiler.jl. The browser-based game showcases the feasibility of running Julia in browsers, though it required occasional manual memory access to handle alignment differences between 64-bit Julia and 32-bit WASM.

- A book, [Modern Financial Modeling](https://modernfinancialmodeling.com), focused on bringing programming and Julia to actuaries and other financial professionals is nearing the end of its pre-release phase. Feedback is welcome!

Numerical Math ecosystem:

- [MultiFloats.jl v3.0](https://github.com/dzhang314/MultiFloats.jl) is released with significant improvements to extended-precision floating-point arithmetic (128–256 bits). The new version introduces faster and more accurate algorithms, round-trip-safe string conversion, new GPU-friendly types (`Float32x2`, `Float32x3`, `Float32x4`), and stricter commutativity for multiplication. The library claims to be the fastest in this precision range—30x faster than BigFloat and 2x faster than DoubleFloats.jl.

- [FlexUnits.jl 0.3.0](https://discourse.julialang.org/t/flexunits-jl-0-3-0-support-for-unitful-like-inference/134903) bridges the gap between Unitful.jl (zero overhead when units are known at compile time, but slow for dynamic units) and DynamicQuantities.jl (fast for dynamic units, but no compile-time inference). The new version supports static unit inference, intelligently promoting to dynamic units only when necessary. Benchmarks show great speedups over Unitful for dynamic units while matching its near-zero overhead for compile-time-known units.

- [QILaplace.jl](https://discourse.julialang.org/t/qilaplace-jl-tensor-network-fourier-laplace-transforms-looking-for-packaging-docs-feedback/135335) implements quantum-inspired tensor-network algorithms for computing Discrete Fourier and Laplace-type transforms. Built on ITensors.jl.

- [GraphsTreewidth.jl](https://github.com/AlgebraicJulia/GraphsTreewidth.jl) solves NP-hard graph problems (chromatic number, vertex cover, domination number) using tree decomposition-based dynamic programming. For graphs with low treewidth—a measure of how "tree-like" a graph is—this approach can solve these problems in milliseconds rather than exponential time.

- [JACC.jl](https://github.com/JuliaGPU/JACC.jl) (Julia Accelerated Computing Commons) provides a vendor-neutral abstraction for CPU/GPU computing, similar to Kokkos or SYCL in C++. With portable `parallel_for` and `parallel_reduce` functions, scientists can write code that runs on CUDA, ROCm, Metal, or oneAPI without modification. The project is supported by DOE's Advanced Scientific Computing Research program.


See also: [JuliaHub corporate blog](https://juliahub.com/blog), [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](https://julialang.org/community/#events), [Turing.jl newsletter](https://github.com/TuringLang/Turing.jl/issues/2498)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)

Disclaimer: An LLM was used to convert the initial human-curated list of interesting links into narrative bullet points. The human editor then used these first bullet points drafts to flesh them out into their current state (occasionally with only minimal changes, sometimes with significant rewriting). Please be aware of the [Julia Discourse policy on Generative AI content](https://discourse.julialang.org/t/updates-to-the-site-guidelines-especially-regarding-gen-ai/134315).