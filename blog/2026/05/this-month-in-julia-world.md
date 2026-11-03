@def title = "This Month in Julia World (March and April 2026)"
@def authors = "Stefan Krastanov"
@def published = "3 May 2026"
@def rss_pubdate = Date(2026, 5, 3)
@def rss = """Community Newsletter for March and April 2026"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

Celebrating the end of this newsletter's 3rd year!

_A monthly newsletter, mostly on Julia internals: a biased, incomplete, editorialized list, with contributions from the community. [Subscribe by email on Discourse](https://discourse.julialang.org/c/community/news/66)._

Current status: Julia release is 1.12.6, Julia LTS is 1.10.11. The 1.13.0-rc1 is available for testing. The dev branch is at 1.14-dev.

\toc

## Core repos

- Work on deployable and AOT-compiled Julia programs continued on several fronts. A [new PR](https://github.com/JuliaLang/julia/pull/61649) changes split system and package images so that the serialized Julia heap lives in the `.ji` file rather than inside the dynamic library. That reduces peak memory use while building large images, avoids some platform limits for huge dynamic libraries, and makes PackageCompiler-style workflows more robust. In the same broad direction, a pair of PRs make `Serialization.serialize` and typed `deserialize(s, ::Type{T})` more compatible with trimming, so juliac-compiled binaries can keep more serialization code paths statically visible to the compiler [[1](https://github.com/JuliaLang/julia/pull/61601), [2](https://github.com/JuliaLang/julia/pull/61636)].

- The Julia runtime contains many objects loaded from system images and package images that are effectively permanent. A [work-in-progress PR](https://github.com/JuliaLang/julia/pull/61474) experiments with marking those objects as permanently old so the garbage collector can skip most of that graph during full collections. The important idea is "pretenuring": if an object is known to live for the lifetime of the process, repeatedly rediscovering that fact during GC is wasted pause time. The PR keeps a remembered set for the rare case where these image objects are mutated, so new references from old image data are still seen by the collector.

- Cody Tapscott continued the effort to remove C++/LLVM from `libjulia-internal`, porting the inference engine interface, GC allocation profiler, heap snapshot support, coverage support, and `runtime_ccall.cpp` to C [[1](https://github.com/JuliaLang/julia/pull/61400), [2](https://github.com/JuliaLang/julia/pull/61401), [3](https://github.com/JuliaLang/julia/pull/61403), [4](https://github.com/JuliaLang/julia/pull/61487)]. The compiler will still depend on LLVM/C++, but shrinking the runtime's C++ surface matters for smaller embedded deployments and for JuliaC-generated binaries.

- Several PRs are tightening assumptions in Julia's type system and subtype implementation [[1](https://github.com/JuliaLang/julia/pull/61634), [2](https://github.com/JuliaLang/julia/pull/61645), [3](https://github.com/JuliaLang/julia/pull/61367), [4](https://github.com/JuliaLang/julia/pull/61603), [5](https://github.com/JuliaLang/julia/pull/61326)]. Type variables are the placeholders that appear in parametric types such as `Vector{T} where T`; the tricky part is that operations like type intersection may rename or restructure those placeholders. Relying on object identity for them can therefore be unsound. These PRs move more of that reasoning into the subtype algorithm itself, avoid problematic `getfield` access on `UnionAll` types, and fix crashy edge cases involving non-canonical or free type variables.

- Related type-representation experiments are also active. One [PR](https://github.com/JuliaLang/julia/pull/61306) explores using the new `typegroup` mechanism for ordinary struct definitions, which would put the machinery used for mutually recursive types on a more regular path. Another [draft PR](https://github.com/JuliaLang/julia/pull/61262) explores an `ImmediateOrRef{T}` representation, sometimes called tagged pointers, where a machine word can hold either a small immediate value or a reference to a heap object. That style of representation is common in language runtimes because it can avoid allocations for small values, but it has subtle interactions with the GC and Julia's object model.

- A [PR](https://github.com/JuliaLang/julia/pull/61463) improves "re-bootstrap" support for Base by making it easier to include Base into a fresh bare module. This is mainly useful for smoke-testing JuliaLowering on Base itself. It also makes some type piracy over `Core` types explicit, which is the kind of cleanup that helps as Julia moves more bootstrap work from flisp/C into Julia.

- Since [around Julia 1.8](https://github.com/JuliaLang/julia/pull/43852), Julia has had an advanced system of compiler effect tracking: inference can reason about whether a call is pure, throws, terminates, touches task state, and so on. A [new PR](https://github.com/JuliaLang/julia/pull/61394) passes some of that information through to LLVM as function attributes, giving LLVM's optimizer more facts to work with before GC lowering. A related [new function](https://github.com/JuliaLang/julia/pull/61438), `Base.blackbox(::Any)`, returns its input while hiding information from the optimizer. That is useful for benchmarking because it can prevent optimizations such as constant folding or loop-invariant-code motion from accidentally removing the work being measured, similar to [Rust's `black_box`](https://doc.rust-lang.org/stable/core/hint/fn.black_box.html).

- Package precompilation can now be detached into a background task, thanks to paired Julia and Pkg PRs [[1](https://github.com/JuliaLang/julia/pull/60943), [2](https://github.com/JuliaLang/Pkg.jl/pull/4602)]. Long precompilation has historically made the REPL feel blocked even when the user only wants to keep working. The new design lets precompilation continue in the background, with controls for canceling, detaching, reattaching, and inspecting worker status.

- Stefan Karpinski has authored PRs to improve command literals written with backticks in Julia [[1](https://github.com/JuliaLang/julia/pull/61540), [2](https://github.com/JuliaLang/julia/pull/61559)]. Backtick commands now support shell-style pipes and redirections, so commands such as ``cat foo.txt | wc -l > lines.txt`` can be expressed directly as Julia `Cmd` objects. A follow-up PR adds brace expansion, making command construction more ergonomic without handing everything off to a shell.

- Tab completion in the REPL is being moved off the main interaction path. A [merged PR](https://github.com/JuliaLang/julia/pull/61409) made manual completions asynchronous so a slow completion query would show a progress marker instead of freezing typing. That first implementation [had to be reverted](https://github.com/JuliaLang/julia/pull/61512), but the goal remains important: editor-like responsiveness in the REPL requires slow background work to be interruptible or ignorable.

- `Threads.@threads` on filtered comprehensions got much faster through [thread-local buffers](https://github.com/JuliaLang/julia/pull/61346). Filtered comprehensions like `[f(x) for x in xs if p(x)]` are harder to parallelize than fixed-size maps because each thread does not know ahead of time how many elements it will keep. Local buffers let each thread collect results without contending on a shared vector, then combine them at the end.

- A [proposed `flatten`](https://github.com/JuliaLang/julia/pull/61384) function would provide an eager, explicit way to turn a vector of vectors into one vector. This is the operation many users currently spell as `vcat(xs...)`, which is convenient but can be surprisingly slow or inference-unfriendly because splatting a large runtime collection is not the same as concatenating a statically known list of arguments.

- Julia developers used to maintain roughly 5000 lines of CPU feature tables by hand. A [new PR](https://github.com/JuliaLang/julia/pull/61292) replaces that table with a generated dependency based on LLVM's CPU information. In the same low-level maintenance area, hash-table optimizations inspired by LLVM's `DenseMap` improve Julia runtime hash tables used by the compiler, GC tooling, and other internals [[1](https://github.com/JuliaLang/julia/pull/61406), [2](https://github.com/JuliaLang/julia/pull/61446)].

- Diagnostics and developer debugging got several polish improvements. Subtype declaration errors are becoming more actionable, so `struct Foo <: AbstractArray end` can point at unbound type parameters instead of saying only that the supertype is invalid [[1](https://github.com/JuliaLang/julia/pull/61635)]. Stack traces now show richer method-signature information for inlined frames [[2](https://github.com/JuliaLang/julia/pull/53925)]. `Base.summarysize` no longer crashes on opaque foreign objects [[3](https://github.com/JuliaLang/julia/pull/61517)], and GC debug-build tools are getting dedicated developer documentation [[4](https://github.com/JuliaLang/julia/pull/61637)].

- A few smaller user-facing improvements landed or are under review. Homogeneous tuple membership tests now infer `Bool` rather than `Union{Bool, Missing}` when the tuple element type cannot include `missing`, which reduces false positives in compiler-powered tools such as JETLS [[1](https://github.com/JuliaLang/julia/pull/61526)]. Help-mode stdlib hints are being cached so name suggestions can be faster [[2](https://github.com/JuliaLang/julia/pull/61248)]. The `--project` command-line option now has a short `-P` spelling [[3](https://github.com/JuliaLang/julia/pull/59867)].

- [A new PR](https://github.com/JuliaLang/julia/pull/60478) adds `Test.detect_closure_boxes` for detecting closure boxes in loaded code; it will be available in Julia 1.14+. A `Core.Box` is introduced when a captured variable must be heap-allocated so closures can share and mutate it, but that box often blocks type inference and can hurt performance. Having a test utility for detecting new boxes gives Base and package authors a way to prevent accidental regressions in closure-heavy code.

## Language discussions

- A [Discourse discussion](https://discourse.julialang.org/t/recommended-idiom-for-collecting-narrowest-type/136604) about collecting into the "narrowest" element type turned into a useful explanation of `typejoin` versus promotion. If you have `Any[1.0f0, 2.0]`, the "best" result might be `AbstractFloat`, `Float64`, or `Union{Float32, Float64}` depending on whether you care about preserving values, getting concrete storage, or representing the exact observed types. The explicit tools are `mapreduce(typeof, typejoin, xs)` and `mapreduce(typeof, promote_type, xs)`, while comprehensions and `collect` follow their own documented inference and collection behavior.

- Another [discussion](https://discourse.julialang.org/t/limitations-of-generated-functions-versus-macros-or-functions/136910) revisited generated functions, macros, world age, and compile-time computation. Generated functions can compute code from argument types, but Julia does not promise exactly when or how often the generator body runs. The thread points toward ordinary functions plus carefully used effect annotations such as `Base.@assume_effects :foldable` when the goal is to help the compiler evaluate pure work early. The caution is that effect annotations are promises to the compiler; using them on code that is not actually foldable can introduce very hard-to-debug miscompilations.

## In search of contributors

- [Agents.jl](https://juliadynamics.github.io/Agents.jl/stable/) is a mature and well-established library for agent-based modelling. It is currently [searching for maintainers](https://discourse.julialang.org/t/agents-jl-v6-releases-announcement-post/111678/13?u=datseris).

## GPU and parallel computing

- The Dagger.jl maintainers have started releasing regular [blog posts](https://daggerjl.ai/blog/) on using Dagger.jl, including posts on [Dagger basics](https://daggerjl.ai/blog/dagger-basics-guide-260213), [parallel seam carving](https://daggerjl.ai/blog/parallel-seam-carving-260206), and [stencil operations](https://daggerjl.ai/blog/stencils-for-fun-and-profit-260323). Dagger is Julia's task-graph execution system for parallel and distributed work.

- Several GPU-related announcements this issue are best read as different layers of the same stack. Raye Kimmerer offered a helpful Slack summary of how to think about these layers:

  - The base layer is made of vendor-specific packages such as CUDA.jl, AMDGPU.jl, Metal.jl, oneAPI.jl, and related backends.
    - They expose low-level kernel programming interfaces. The programming model is usually SIMT-style GPU programming and broadly resembles vendor kernel languages, but the details are not portable enough to write one backend-specific kernel and expect it to run everywhere.
    - They also provide backend-specific `GPUArray` types. Those arrays implement much of Julia's vectorized `AbstractArray` interface, so broadcasting and `mapreduce` are often the right way to write simple array code. Direct scalar indexing is usually not the performance model to aim for at this layer.

  - The `GPUArray` style is broadly portable across GPU vendors, but backend-specific kernel code is not. For code intended to run for all Julia GPU users, one usually wants a higher-level layer.

  - KernelAbstractions.jl is a portable kernel language over the backend kernel interfaces. It is still fairly low-level, but a KernelAbstractions kernel can be a good "lowest common denominator" implementation, with backend-specific kernels reserved for cases where performance or vendor features justify them.

  - AcceleratedKernels.jl sits one level higher: it is a parallel algorithms library built on KernelAbstractions and backend GPU arrays, covering operations such as reductions, sorting, and parallel loops. These algorithms are heavily tuned and can approach vendor library performance.

  - JACC.jl is in the same portability space as KernelAbstractions, but exposes a loop-oriented interface more like the DOE Kokkos model rather than explicit SIMT kernel programming.

  - Reactant.jl has a much wider scope: it aims to compile larger Julia programs through XLA and MLIR, supporting array-style code, KernelAbstractions-style kernels, LinearAlgebra calls, annotated control flow, GPUs, TPUs, and distributed execution.

  - A practical rule of thumb: use the backend GPU array interface for broadcasting and `mapreduce`; reach for AcceleratedKernels for high-level tuned algorithms; use KernelAbstractions or JACC when you need custom portable kernels; and consider Reactant when you want to accelerate a larger Julia program as a whole.

- [JACC.jl v1.0](https://discourse.julialang.org/t/ann-jacc-jl-v1-0-now-available-for-100-portable-cpu-gpu-code/136231) is now available for portable CPU/GPU programming across CUDA, AMDGPU, Metal, oneAPI, and threaded CPU backends. Its interface emphasizes `parallel_for`, `parallel_reduce`, and single-source Julia code rather than vendor annotations, which makes it attractive for scientific codes that want accelerator portability without teaching every contributor CUDA-style kernel programming.

- [KernelForge.jl](https://discourse.julialang.org/t/kernelforge-jl-high-performance-portable-gpu-primitives-for-arbitrary-types-and-operators/135780) provides high-performance GPU primitives such as `mapreduce`, scan, matrix-vector operations, search, and vectorized copy. Its pitch is not just speed, but generality: arbitrary `isbitstype` structs, custom operators, and non-contiguous views are first-class use cases, rather than everything being specialized around dense `Float32` arrays.

- [RayMakie](https://discourse.julialang.org/t/ann-raymakie-the-new-pbrt-based-rendering-backend/135734) is a new Makie rendering backend that ports the pbrt-v4 physically based ray tracer to pure Julia. It uses the GPU stack to support effects such as volumetric clouds, depth of field, and gravitational lensing, and also includes an experimental GPU rasterizer via KernelAbstractions. The striking part is ecosystem maturity: a full ray tracer in Julia can now get into the performance range of established rendering tools while staying in the Julia graphics stack.

- [OptimalControl.jl v2.0](https://discourse.julialang.org/t/ann-optimalcontrol-jl-v2-0-0/136599) adds a broader solver matrix and streamlined GPU solving through `solve(ocp, :gpu)`. Optimal control is the problem of choosing inputs to a dynamical system so that it satisfies constraints while optimizing an objective, and it shows up in robotics, aerospace, energy systems, and parameter-estimation problems. The release supports direct and indirect methods, multiple nonlinear optimization solvers, and control-free problems where the unknowns are parameters rather than time-varying controls.

- [BatchSolve.jl](https://discourse.julialang.org/t/batchsolve-jl-vectorized-batched-ad-compatible-root-finders-and-minimizers-also-vectorized-finite-differences/136797) targets batched root finding, minimization, and finite differences for vectorized CPU/GPU workloads. The common pattern is "solve the same small problem for many parameter values"; doing that as one vectorized batch can map well to GPUs and BLAS-style batched linear algebra. Its `AutoBatch` AD type is designed to plug into DifferentiationInterface.jl, making the package relevant both to numerical solvers and autodiff-heavy workflows.

## Ecosystem

- [ReferenceRevision](https://discourse.julialang.org/t/ann-referencerevision/136691) can check out another revision of your package into a temporary directory, run it in a subprocess, and let the current session exchange variables with that subprocess. That is useful for regression hunting: instead of stashing changes or serializing intermediate values by hand, you can compare a working tree against `HEAD` or an older release while staying in one Julia workflow.

- [ProfilePerfetto.jl](https://discourse.julialang.org/t/ann-profileperfetto-jl-easy-profiling-with-interactive-viewer/136920) sends Julia profile data to the browser-based Perfetto trace viewer. It includes automatic sampling-rate calibration, which lowers the barrier for users who know their code is slow but do not yet have intuition for profiling parameters.

- [WasmTarget.jl and Therapy.jl](https://discourse.julialang.org/t/ann-experimental-wasmtarget-jl-therapy-jl-julia-to-webassembly-compiler-with-a-full-stack-signals-framework-built-on-it/136901): WasmTarget reads fully inferred Julia IR and emits WebAssembly GC bytecode, while Therapy builds a full-stack signals framework on top.

- [AppBundler v1.0](https://discourse.julialang.org/t/ann-appbundler-v1-0-native-installers-for-julia-applications/136438) packages Julia applications as native installers: Snap on Linux, MSIX on Windows, and DMG on macOS.

- [Mongoose.jl v0.3](https://discourse.julialang.org/t/ann-mongoose-jl-v0-3-x-aot-compilable-http-server/136852) is an AOT-compilable HTTP server with new websocket, middleware, and static-file-serving support. Julia web servers have traditionally assumed a normal JIT session; an AOT-friendly server is useful for small deployable services where startup, packaging, or locked-down production environments matter.

- [OptParse.jl](https://discourse.julialang.org/t/ann-optparse-jl-a-composable-type-stable-cli-parser/136580) is a new command-line parser built around type stability, composable parser pieces, and a "parse, don't validate" approach. CLI parsing is often the first layer of an application, so making it friendly to static compilation helps Julia command-line tools become smaller and easier to ship.

- [DependencyAtlas.jl](https://discourse.julialang.org/t/ann-dependencyatlas-jl-explore-julia-codebases-as-dependency-graphs/136317) turns Julia codebases into explorable dependency graphs using source structure, StaticLint-style semantic information, and JET/compiler-time evidence.

- Revise 3.14 disabled automatic struct revision by default. Since Revise 3.13, revision of structs and other constants has been possible on Julia 1.12+, but because structs do not have a backedge system like method instances do, revising structs requires traversing the type tree, which [can take minutes](https://github.com/timholy/Revise.jl/issues/988). Even after initial optimization [[1](https://github.com/JuliaLang/julia/pull/61156), [2](https://github.com/timholy/Revise.jl/pull/1013)], this was deemed a poor enough user experience that [struct revision was disabled by default](https://github.com/timholy/Revise.jl/pull/1008). It can be re-enabled using Preferences.jl while work continues on making it fast enough to turn back on by default.

- A Julia fork of [Release Please](https://discourse.julialang.org/t/ann-easier-release-automation-with-release-please-ci-tool/136452) automates version bumps, changelog PRs, GitHub releases, and JuliaRegistrator triggers using Conventional Commits.

- [XLSX.jl v0.11.0](https://discourse.julialang.org/t/ann-xlsx-jl-v0-11-0-now-released-bringing-significant-new-functionality/136345) brings major new spreadsheet-writing features, and ownership has moved to JuliaData. The release adds extensive formatting support, conditional formatting, merged cells, defined names, rich text via `AnnotatedString`s, and arbitrary Excel formulas.

- [UseAll.jl](https://discourse.julialang.org/t/ann-useall-jl-temporarily-demodularize-julia-code/136432) provides `@useall`, a REPL-oriented helper that temporarily brings a module's exported and internal names into the current namespace. It is explicitly a development convenience, useful when repeatedly poking at package internals alongside Revise rather than typing long qualified names.

- [QRStudio.jl](https://discourse.julialang.org/t/ann-qrstudio-jl-cross-platform-julia-desktop-application-for-barcode-and-qr-code-processing/136537) is a cross-platform desktop app for detecting, inspecting, and generating QR codes and barcodes. It is also an example of a Julia application built with QML/Qt and distributed through Julia's app tooling, which makes it interesting beyond the barcode domain.

- An open-access book, [Modern Financial Modeling](https://modernfinancialmodeling.com), focused on bringing programming and Julia to actuaries and other financial professionals is now released. The content is freely available online or as a PDF, with a printed copy also available for purchase.

## Numerical math and science

- [Giac.jl](https://discourse.julialang.org/t/ann-giac-jl-julia-interface-to-the-giac-computer-algebra-system/136681) provides a Julia interface to the Giac computer algebra system, with access to more than 2200 symbolic commands through a CxxWrap/JLL-based installation. Giac is a mature C++ CAS used by GeoGebra, HP Prime calculators, and SageMath, so this gives Julia users another symbolic engine alongside native Symbolics.jl and Python-backed SymPy.jl.

- A new sampled-signal stack was announced around [SamplesCore, SoundIO, and WavNative](https://discourse.julialang.org/t/ann-a-new-ecosystem-for-sampled-signals-samplescore-soundio-and-wavnative/136515). The goal is to bring the kind of typed, literate data model familiar from Images.jl to one-dimensional signals: samples become first-class values, audio I/O uses libsoundio, and WAV handling stays native Julia. This is useful for audio, instrumentation, and communication systems where low-latency I/O and precise sample formats both matter.

- Two image-analysis packages target different parts of scientific imaging. [BayeredImages.jl](https://discourse.julialang.org/t/ann-bayeredimages-jl-working-with-raw-color-images-in-julia/136660) represents raw color-filter-array images before demosaicing, which is the stage where tasks such as hot-pixel removal should often happen. [ImageTally.jl](https://discourse.julialang.org/t/ann-announcing-imagetally-jl-interactive-image-counting-and-landmark-placement-for-scientific-images/136705) provides an interactive workflow for counting objects and placing landmarks in scientific images, motivated by biological image analysis and morphometrics.

- Julia's geospatial and public-data tooling picked up several focused packages. [OpenSourceRoutingMachine.jl](https://discourse.julialang.org/t/ann-opensourceroutingmachine-jl-julia-wrapper-for-osrm-road-routing/136900) wraps OSRM for routing, map matching, distance tables, nearest-road lookup, and road-network tiles from OpenStreetMap data. [AtlanticCloud.jl](https://discourse.julialang.org/t/atlanticcloud-jl-typed-julia-access-to-the-atlantic-cloud-geospatial-data-infrastructure/136655) offers typed access to Atlantic Cloud meteorological and geospatial datasets, starting with station observations from Portugal and Brazil. [GeoNamesAPI.jl](https://discourse.julialang.org/t/ann-geonamesapi-jl/136559) wraps the GeoNames web service, and [USDAQuickStats.jl 1.0.0](https://discourse.julialang.org/t/ann-usdaquickstats-jl-1-0-0/136662) provides a stable API for USDA NASS agricultural statistics.

- [Montre.jl](https://discourse.julialang.org/t/ann-montre-jl-bindings-for-a-new-corpus-query-engine-for-nlp/136611) provides Julia bindings to a Rust corpus query engine for NLP and corpus linguistics. It indexes CoNLL-U data, the annotation format used by Universal Dependencies and many NLP tools, and supports concordance-style queries over token, sentence, and document structure.

- A quartet of identifier packages, [PackedParselets.jl, FastIdentifiers.jl, AcademicIdentifiers.jl, and BioIdentifiers.jl](https://discourse.julialang.org/t/ann-a-quartet-of-identifier-related-parsing-packages-packedparselets-jl-fastidentifiers-jl-academicidentifiers-jl-bioidentifiers-jl/136574), tackles structured identifier parsing and printing. This sounds niche until you have joined large biological or academic datasets by strings such as ORCIDs, DOIs, Ensembl IDs, or ontology terms; typed identifiers can make comparisons faster and malformed data easier to detect.

- [UniformStreamlines.jl](https://discourse.julialang.org/t/ann-uniformstreamlines-jl-evenly-spaced-streamlines-in-julia/136784) generates evenly spaced streamlines for 2D, 3D, and N-dimensional vector fields using the Jobard-Lefer algorithm. Streamlines are the curves that follow a vector field, such as fluid flow or an electromagnetic field, and even spacing makes plots much easier to read than seeding lines by hand.

- [UpSetPlot.jl](https://discourse.julialang.org/t/ann-upsetplot-jl/136848) implements UpSet plots for visualizing intersections among many sets. These are often more scalable than Venn diagrams once there are more than three sets, which is why they are common in life-sciences data analysis.

- [MeijerG.jl](https://discourse.julialang.org/t/ann-meijerg-jl-a-julia-package-for-calculating-meijer-g-functions/136577) provides numerical evaluation of the Meijer G-function, a very general special function that can represent many other special functions as cases.

- [LAlatex.jl v1.0.0](https://discourse.julialang.org/t/ann-lalatex-jl-v1-0-0-latex-rendering-for-linear-algebra-and-symbolic-math/136908) renders linear algebra objects and symbolic expressions as LaTeX for notebooks, teaching materials, and documentation.

- [NeuralEstimators.jl](https://discourse.julialang.org/t/ann-neuralestimators-jl-efficient-simulation-based-inference-sbi-using-neural-networks/136917) provides neural-network-based simulation-based inference. These methods learn posterior distributions, likelihood ratios, or posterior summaries from simulated data, which is valuable when a model is easy to simulate but its likelihood is unavailable or too expensive to evaluate. The amortized part is important: after training, inference over many observed datasets can be much faster than repeatedly running MCMC.

- [Stan.jl v10.8.4](https://discourse.julialang.org/t/stan-jl-v10-8-4-released/136904) updates the StanJulia ecosystem to CmdStan 2.37 and coordinates releases across StanBase, StanSample, StanOptimize, StanPathfinder, StanVariational, DiffEqBayesStan, and related packages.

See also: [JuliaHub corporate blog](https://juliahub.com/blog), [French community newsletter](https://pnavaro.github.io/NouvellesJulia/), [community calendar](/community/#events), [Turing.jl newsletter](https://github.com/TuringLang/Turing.jl/issues/2498)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)

Editor note: An LLM was used to convert the initial human-curated list of interesting links into narrative bullet points. I (the human editor) then used these first bullet point drafts to flesh them out into their current state, occasionally with significant rewriting, occasionally verbatim reusing them. Please be aware of the [Julia Discourse policy on Generative AI content](https://discourse.julialang.org/t/updates-to-the-site-guidelines-especially-regarding-gen-ai/134315).
