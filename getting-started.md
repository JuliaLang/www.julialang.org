@def title = "Getting started: pick a few packages"
@def description = "The Julia packages people reach for first, grouped by kind of work: exploring data, modelling and solving, making code fast, building and shipping, and working through an AI agent."
@def hascode = true

# Pick a few packages

The General registry holds over 12,000 packages. To begin, a handful is often enough.
Below are the ones people actually use most, grouped by the kind of work you might do.

No Julia yet? [Install it](/install/) first; it takes a minute.
New to the language? Read [what Julia is](/learning/getting-started/), or start with
[the manual](https://docs.julialang.org/en/v1/manual/getting-started/).

## Adding packages

1. Press `]` at the `julia>` prompt. It turns blue: you're in package mode.
2. Type an `add` line, such as `add CSV DataFrames`. For a project, run `activate .` first so its packages stay with it.
3. Press Backspace to leave, then `using` them.

Or skip package mode: type `using CSV` at the `julia>` prompt, and if CSV isn't installed yet, the REPL asks whether to install it.

## Every session: the toolbelt

Whatever you end up doing, these make every session better.

- [Revise.jl](https://timholy.github.io/Revise.jl/stable/): edit your code, keep your session. Changes apply without a restart.
- [DocBrowser.jl](https://github.com/IanButterworth/DocBrowser.jl): every manual and docstring, browsable without leaving the REPL. Press Enter at an empty `help?>` prompt.
- [BenchmarkTools.jl](https://juliaci.github.io/BenchmarkTools.jl/stable/): `@btime` gives timings you can trust.
- [Infiltrator.jl](https://github.com/JuliaDebug/Infiltrator.jl): put `@infiltrate` in a function to stop there and inspect it.

Install the ones you want into your default environment:

```julia-repl
pkg> add Revise DocBrowser
```

Then load them each time Julia starts, by saving this as `~/.julia/config/startup.jl`
(on Windows, `%USERPROFILE%\.julia\config\startup.jl`):

```julia
if isinteractive()
    using Revise
    using DocBrowser
end
```

Revise goes first, so it can track everything loaded after it.

And somewhere to type:

- [VS Code](https://www.julia-vscode.org) with the Julia extension: editor, REPL, plots, debugger and profiler in one window.
- [Pluto.jl](https://plutojl.org): reactive notebooks. Change a cell and everything that depends on it reruns. Add PlutoUI.jl for sliders and buttons.
- [IJulia.jl](https://julialang.github.io/IJulia.jl/stable/): Julia in Jupyter notebooks, and in Quarto reports.

## Then pick what you'd like to do

Each section lists one or two packages per step. Where there's a choice, it says "or", and you only need one.

### Explore data

You have data and questions: read it, reshape it, plot it, fit it.

- **Read:** [CSV.jl](https://csv.juliadata.org/stable/) and [DataFrames.jl](https://dataframes.juliadata.org/stable/) load files into tables, then filter, join and group them. `add CSV DataFrames`
- **Plot:** [Plots.jl](https://docs.juliaplots.org/stable/) has one quick syntax for line, scatter, histogram and heatmap plots. Or [CairoMakie.jl](https://docs.makie.org/stable/) for publication figures. `add Plots`
- **Fit:** [Distributions.jl](https://juliastats.org/Distributions.jl/stable/) samples, fits and evaluates nearly every probability distribution. `add Distributions`

```julia
using CSV, DataFrames, Plots, Distributions, Statistics

CSV.write("data.csv", DataFrame(x = randn(1000), group = rand(["a", "b"], 1000)))
df = CSV.read("data.csv", DataFrame)

combine(groupby(df, :group), :x => mean)

d = fit(Normal, df.x)
histogram(df.x; normalize = true, label = "data")
plot!(x -> pdf(d, x); label = "fit", linewidth = 3)
```

Next steps:
wrangling with [DataFramesMeta.jl](https://juliadata.org/DataFramesMeta.jl/stable/) and [Chain.jl](https://github.com/jkrumbiegel/Chain.jl);
files with [XLSX.jl](https://github.com/JuliaData/XLSX.jl), [Arrow.jl](https://github.com/apache/arrow-julia), [JLD2.jl](https://github.com/JuliaIO/JLD2.jl), [SQLite.jl](https://github.com/JuliaDatabases/SQLite.jl) and [DuckDB.jl](https://duckdb.org/docs/stable/clients/tertiary_clients/julia);
statistics with [StatsBase.jl](https://juliastats.org/StatsBase.jl/stable/), [GLM.jl](https://juliastats.org/GLM.jl/stable/), [HypothesisTests.jl](https://github.com/JuliaStats/HypothesisTests.jl), [MixedModels.jl](https://github.com/JuliaStats/MixedModels.jl) and [Turing.jl](https://turinglang.org);
machine learning with [MLJ.jl](https://juliaai.github.io/MLJ.jl/stable/);
more plotting with [AlgebraOfGraphics.jl](https://aog.makie.org/stable/), [GLMakie.jl](https://docs.makie.org/stable/explanations/backends/glmakie) and [UnicodePlots.jl](https://github.com/JuliaPlots/UnicodePlots.jl).

### Model and solve

You can write down the maths. A solver does the rest.

- **Simulate:** [OrdinaryDiffEq.jl](https://docs.sciml.ai/DiffEqDocs/stable/) has fast, adaptive solvers for ordinary differential equations, from simple to very stiff. `add OrdinaryDiffEq`
- **Optimize:** [JuMP.jl](https://jump.dev/JuMP.jl/stable/) with the [HiGHS](https://github.com/jump-dev/HiGHS.jl) solver, for constrained problems written as they look on paper. Or [Optim.jl](https://julianlsolvers.github.io/Optim.jl/stable/) to minimize a plain function. `add JuMP HiGHS`
- **Differentiate:** [ForwardDiff.jl](https://juliadiff.org/ForwardDiff.jl/stable/) gives exact derivatives of ordinary Julia code. `add ForwardDiff`
- **Learn:** [Flux.jl](https://fluxml.ai/Flux.jl/stable/) builds neural networks that are plain Julia all the way down. `add Flux`

```julia
using OrdinaryDiffEq

decay(u, p, t) = -p * u
sol = solve(ODEProblem(decay, 1.0, (0.0, 5.0), 0.8))
sol(2.5)   # ≈ exp(-2) = 0.135
```

Next steps:
more equations with [SciML](https://sciml.ai) (SDEs, DAEs, delays), [ModelingToolkit.jl](https://docs.sciml.ai/ModelingToolkit/stable/), [Symbolics.jl](https://docs.sciml.ai/Symbolics/stable/), [NonlinearSolve.jl](https://docs.sciml.ai/NonlinearSolve/stable/) and [Roots.jl](https://github.com/JuliaMath/Roots.jl);
numerics with [Interpolations.jl](https://github.com/JuliaMath/Interpolations.jl), [QuadGK.jl](https://github.com/JuliaMath/QuadGK.jl), [FFTW.jl](https://github.com/JuliaMath/FFTW.jl), [DSP.jl](https://github.com/JuliaDSP/DSP.jl), [Graphs.jl](https://juliagraphs.org/Graphs.jl/stable/) and [Images.jl](https://juliaimages.org);
units and error bars with [Unitful.jl](https://github.com/JuliaPhysics/Unitful.jl) and [Measurements.jl](https://juliaphysics.github.io/Measurements.jl/stable/);
nonlinear optimization with [Ipopt.jl](https://github.com/jump-dev/Ipopt.jl);
more machine learning with [Lux.jl](https://lux.csail.mit.edu) and [Enzyme.jl](https://enzyme.mit.edu/julia/) (gradients of fast, mutating code).

### Make it fast

It works. Now measure it, find the slow part, fix it, and use every core.

- **Measure:** [BenchmarkTools.jl](https://juliaci.github.io/BenchmarkTools.jl/stable/), from the toolbelt. `add BenchmarkTools`
- **Find:** the built-in [profiler](https://docs.julialang.org/en/v1/manual/profile/) (`@profview` in VS Code), and the manual's [performance tips](https://docs.julialang.org/en/v1/manual/performance-tips/).
- **Fix:** [StaticArrays.jl](https://juliaarrays.github.io/StaticArrays.jl/stable/) gives small fixed-size arrays with no allocation. `add StaticArrays`
- **Threads:** [OhMyThreads.jl](https://juliafolds2.github.io/OhMyThreads.jl/stable/) has multithreaded `map`, `reduce` and loops. Start Julia with `-t auto`. `add OhMyThreads`
- **GPU:** pick the one for your hardware: [CUDA.jl](https://cuda.juliagpu.org/stable/) (NVIDIA), [Metal.jl](https://metal.juliagpu.org/stable/) (Apple) or [AMDGPU.jl](https://amdgpu.juliagpu.org/stable/).

```julia
# start Julia with: julia -t auto
using BenchmarkTools, OhMyThreads

@btime sum(x -> sin(x)^2, 1:10^7)
@btime tmapreduce(x -> sin(x)^2, +, 1:10^7)
```

Next steps:
dig into slow code with [JET.jl](https://aviatesk.github.io/JET.jl/stable/) (`@report_opt`) and [Cthulhu.jl](https://github.com/JuliaDebug/Cthulhu.jl);
write one kernel for any GPU with [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl);
cut load times with [PrecompileTools.jl](https://julialang.github.io/PrecompileTools.jl/stable/).

### Build and ship

The unit of work is a repo: a package, a command-line tool or a web service.

- **Package:** [PkgTemplates.jl](https://juliaci.github.io/PkgTemplates.jl/stable/) sets up a package with CI. Write tests with the [Test](https://docs.julialang.org/en/v1/stdlib/Test/) stdlib, docs with [Documenter.jl](https://documenter.juliadocs.org/stable/), and catch common mistakes with [Aqua.jl](https://juliatesting.github.io/Aqua.jl/stable/). `add PkgTemplates Documenter Aqua`
- **Ship:** [JuliaC.jl](https://github.com/JuliaLang/JuliaC.jl) compiles a program into a native executable. [Pkg apps](https://pkgdocs.julialang.org/v1/apps/) let people install your package as a command-line tool. `app add JuliaC`
- **Serve:** [HTTP.jl](https://juliaweb.github.io/HTTP.jl/stable/) and [JSON.jl](https://github.com/JuliaIO/JSON.jl) for clients and servers; [Oxygen.jl](https://refactorful.github.io/Oxygen.jl/stable/) for routes in a few lines. `add HTTP JSON Oxygen`

```julia
using PkgTemplates

t = Template(; user = "your-github-name",
               plugins = [GitHubActions(), Documenter{GitHubActions}()])
t("MyPackage")
```

Next steps:
formatting with [JuliaFormatter.jl](https://juliaeditorsupport.github.io/JuliaFormatter.jl/stable/) or [Runic.jl](https://github.com/fredrikekre/Runic.jl);
testing with [TestEnv.jl](https://github.com/JuliaTesting/TestEnv.jl) and [TestItemRunner.jl](https://github.com/julia-testitems/TestItemRunner.jl);
command-line tools with [ArgParse.jl](https://carlobaldassi.github.io/ArgParse.jl/stable/), [ProgressMeter.jl](https://github.com/timholy/ProgressMeter.jl) and [PackageCompiler.jl](https://julialang.github.io/PackageCompiler.jl/stable/);
web apps with [Genie.jl](https://genieframework.com) and [Bonito.jl](https://github.com/SimonDanisch/Bonito.jl).

### Work through an agent

You describe, an AI agent types. Give it a Julia that answers in milliseconds.

- **Run:** [JuliaDaemon.jl](https://github.com/KristofferC/JuliaDaemon.jl) keeps one warm session per project, with Revise loaded. The agent runs `jld eval` instead of starting Julia on every call, and you can `jld connect` to the same session. `app add JuliaDaemon`
- **Check:** [JET.jl](https://aviatesk.github.io/JET.jl/stable/) finds errors without running the code, [Runic.jl](https://github.com/fredrikekre/Runic.jl) formats it one fixed way, and [TestItemRunner.jl](https://github.com/julia-testitems/TestItemRunner.jl) runs one test at a time. `add JET Runic TestItemRunner`

```bash
# teach your agent to use jld
jld install

# the first call starts a session
cd MyPkg
jld eval 'using MyPkg; MyPkg.foo()'

# later calls are warm, edits live
jld run test/runtests.jl
```

Next steps:
review imports with [ExplicitImports.jl](https://juliatesting.github.io/ExplicitImports.jl/stable/);
or use [julia-mcp](https://github.com/aplavin/julia-mcp) for persistent sessions over MCP (a Python server, not a Julia package).

### Coming from Python, R or MATLAB?

[PythonCall.jl](https://juliapy.github.io/PythonCall.jl/stable/) calls any Python library (with [CondaPkg.jl](https://github.com/JuliaPy/CondaPkg.jl) for its dependencies), [RCall.jl](https://juliainterop.github.io/RCall.jl/stable/) does the same for R, and the manual lists the [noteworthy differences](https://docs.julialang.org/en/v1/manual/noteworthy-differences/). `add PythonCall CondaPkg`

### Didn't find yours?

There are over 12,000 more. Some places to look:

- [JuliaHub](https://platform.juliahub.com/ui/Packages): search every registered package and its docs.
- [Package comparisons](https://juliapackagecomparisons.github.io): help choosing between similar packages.
- [Discourse](https://discourse.julialang.org/c/first-steps/8): the "First steps" category is friendly and quick.
- [Chat](/community/otherchannels/): Zulip, Slack, Discord and more, if you'd rather talk in real time.
- [JuliaCon talks](https://www.youtube.com/@TheJuliaLanguage): years of package demos and workshops, free on YouTube.

## Then mix them

Julia packages work together even when their authors never planned it.
That's [multiple dispatch](https://www.youtube.com/watch?v=kc9HwsxE1OY) at work, and it's why a few packages go a long way.

Write a function once:

```julia
# Newton's method, for plain numbers
function mysqrt(x)
    t = x
    for _ in 1:10
        t = (t + x / t) / 2
    end
    return t
end
```

and every package can use it:

```julia-repl
julia> using Measurements, ForwardDiff

julia> mysqrt(2.0 ± 0.1)     # error bars, propagated
1.414 ± 0.035

julia> mysqrt(big"2.0")      # as many digits as you like
1.414213562373095048801688724209698078569671875376948073176679737990732478462119

julia> ForwardDiff.derivative(mysqrt, 2.0)   # an exact derivative
0.35355339059327373
```

Measurements.jl and ForwardDiff.jl know nothing about `mysqrt`, and `mysqrt` knows nothing about them.
With CUDA.jl, `mysqrt.(CUDA.rand(10^6))` runs it on a GPU too.
