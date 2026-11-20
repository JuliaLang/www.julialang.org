@def title = "Getting started: pick a starter kit"
@def description = "The Julia packages people reach for first, grouped by how you work: exploring data, modelling and solving, making code fast, building and shipping, and working through an AI agent."
@def hascode = true

~~~
<link rel="stylesheet" href="/css/getting-started.css">

<div class="gs">

<!-- Hero -->
<header class="gs-hero">
  <div class="gs-hero-text">
    <p class="gs-kicker"><span class="gs-dots" aria-hidden="true"><i></i><i></i><i></i></span> Getting started</p>
    <h1>Pick a starter kit</h1>
    <p class="gs-lede">The General registry holds over 12,000 packages. To begin, you need a handful.
    Below are the ones people actually use most, grouped by how you'll work rather than by field.</p>
    <p class="gs-prereq">No Julia yet? <a href="/install/">Install it</a> first; it takes a minute.
    New to the language? Read <a href="/learning/getting-started/">what Julia is</a>, or start with
    <a href="https://docs.julialang.org/en/v1/manual/getting-started/">the manual</a>.</p>
  </div>
  <div class="gs-term gs-hero-term" aria-hidden="true">
    <div class="gs-term-bar"><i></i><i></i><i></i></div>
    <pre class="gs-term-body"><span class="gs-p-julia">julia&gt;</span> <span class="gs-dim">]</span>
<span class="gs-p-pkg">(@v{{stable_release_short}}) pkg&gt;</span> <span id="gs-typer">add CSV DataFrames</span><span class="gs-caret"></span></pre>
  </div>
</header>

<!-- How a kit works -->
<ol class="gs-steps">
  <li><span class="gs-step-n">1</span><div><strong>Press <kbd>]</kbd></strong> at the <code>julia&gt;</code> prompt. It turns blue: you're in package mode.</div></li>
  <li><span class="gs-step-n">2</span><div><strong>Paste an <code>add</code> line.</strong> For a project, run <code>activate .</code> first so its packages stay with it.</div></li>
  <li><span class="gs-step-n">3</span><div><strong>Press <kbd>Backspace</kbd></strong> to leave, then <code>using</code> them.</div></li>
</ol>
<p class="gs-shortcut">Or skip package mode: type <code>using CSV</code> at the <code>julia&gt;</code> prompt, and if CSV isn't installed yet, the REPL asks whether to install it.</p>

<!-- Toolbelt -->
<section class="gs-section" id="toolbelt">
  <h2 class="gs-h2">Every session: the toolbelt</h2>
  <p class="gs-sub">Whatever you end up doing, these make every session better. Choose the ones you want,
  and we'll write your <code>startup.jl</code> so they load each time you start Julia.</p>

  <div class="gs-belt">
    <div class="gs-tools" role="group" aria-label="Toolbelt packages">

      <label class="gs-tool gs-tool-wide" style="--kit: var(--gs-purple)">
        <input type="checkbox" value="DocBrowser" checked>
        <span class="gs-tool-top"><a href="https://github.com/IanButterworth/DocBrowser.jl">DocBrowser.jl</a><span class="gs-badge">New</span><span class="gs-check" aria-hidden="true"></span></span>
        <span class="gs-tool-desc">Every manual and docstring, browsable without leaving the REPL. Press <kbd>Enter</kbd> at an empty <code>help?&gt;</code> prompt.</span>
        <span class="gs-mini-browser" aria-hidden="true">
          <span class="gs-mb-pane"><b>Contents</b>Julia<br>&nbsp;Manual<br>&nbsp;<u>Base</u><br>Packages<br>&nbsp;DataFrames<br>&nbsp;Makie<br>Main</span>
          <span class="gs-mb-pane"><b>Names</b><em>●</em> filter<br><em>●</em> findall<br><u><em>●</em> first</u><br><em>●</em> foldl<br><em>○</em> fieldtypes<br><em>·</em> _fl</span>
          <span class="gs-mb-pane gs-mb-doc"><b>Documentation</b><strong>first(coll)</strong><br>Get the first element of an iterable collection.<br><br><span class="gs-dim">julia&gt; first(2:2:10)<br>2</span></span>
        </span>
      </label>

      <label class="gs-tool" style="--kit: var(--gs-green)">
        <input type="checkbox" value="Revise" checked>
        <span class="gs-tool-top"><a href="https://timholy.github.io/Revise.jl/stable/">Revise.jl</a><span class="gs-check" aria-hidden="true"></span></span>
        <span class="gs-tool-desc">Edit your code, keep your session. Changes apply without a restart.</span>
      </label>

      <label class="gs-tool" style="--kit: var(--gs-blue)">
        <input type="checkbox" value="BenchmarkTools">
        <span class="gs-tool-top"><a href="https://juliaci.github.io/BenchmarkTools.jl/stable/">BenchmarkTools.jl</a><span class="gs-check" aria-hidden="true"></span></span>
        <span class="gs-tool-desc"><code>@btime</code> gives timings you can trust.</span>
      </label>

      <label class="gs-tool" style="--kit: var(--gs-red)">
        <input type="checkbox" value="Infiltrator">
        <span class="gs-tool-top"><a href="https://github.com/JuliaDebug/Infiltrator.jl">Infiltrator.jl</a><span class="gs-check" aria-hidden="true"></span></span>
        <span class="gs-tool-desc">Put <code>@infiltrate</code> in a function to stop there and inspect it.</span>
      </label>

    </div>

    <div class="gs-belt-out">
      <p class="gs-out-label">1. Install them into your default environment</p>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> <span id="gs-belt-add">add DocBrowser Revise</span></code><button type="button" class="gs-copy" data-copy-from="gs-belt-add">Copy</button></div>
      <p class="gs-out-label">2. Save this as <code>~/.julia/config/startup.jl</code></p>
<div id="gs-startup">
<pre><code class="language-julia">if isinteractive()
    using Revise
    using DocBrowser
end</code></pre>
</div>
      <p class="gs-out-note">On Windows the file lives at <code>%USERPROFILE%\.julia\config\startup.jl</code>. Revise always goes first, so it can track everything loaded after it.</p>
    </div>
  </div>

  <div class="gs-where">
    <p class="gs-where-label">And somewhere to type:</p>
    <a class="gs-where-link" href="https://www.julia-vscode.org"><strong>VS Code</strong><span>The Julia extension: editor, REPL, plots, debugger and profiler in one window.</span></a>
    <a class="gs-where-link" href="https://plutojl.org"><strong>Pluto.jl</strong><span>Reactive notebooks: change a cell and everything that depends on it reruns. Add PlutoUI.jl for sliders and buttons.</span></a>
    <a class="gs-where-link" href="https://julialang.github.io/IJulia.jl/stable/"><strong>IJulia.jl</strong><span>Julia in Jupyter notebooks, and in Quarto reports.</span></a>
  </div>
</section>

<!-- Kits -->
<section class="gs-section" id="kits">
  <h2 class="gs-h2">Then pick how you'll work</h2>
  <p class="gs-sub">Each kit starts with one or two packages per step. Where there's a choice, it says "or", and you only need one.</p>

  <div class="gs-kits">

    <article class="gs-kit" id="kit-data" style="--kit: var(--gs-green)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🧮</span>
        <div><h3>Explore data</h3><p class="gs-when">You have data and questions: read it, reshape it, plot it, fit it.</p></div></div>
      <ul class="gs-rows">
        <li><span class="gs-verb">Read</span><div><a href="https://csv.juliadata.org/stable/">CSV.jl</a> and <a href="https://dataframes.juliadata.org/stable/">DataFrames.jl</a>: load files into tables, then filter, join and group them.</div><button type="button" class="gs-pill" data-copy="add CSV DataFrames">add CSV DataFrames</button></li>
        <li><span class="gs-verb">Plot</span><div><a href="https://docs.juliaplots.org/stable/">Plots.jl</a>: one quick syntax for line, scatter, histogram and heatmap plots. Or <a href="https://docs.makie.org/stable/">CairoMakie.jl</a> for publication figures.</div><button type="button" class="gs-pill" data-copy="add Plots">add Plots</button></li>
        <li><span class="gs-verb">Fit</span><div><a href="https://juliastats.org/Distributions.jl/stable/">Distributions.jl</a>: sample, fit and evaluate nearly every probability distribution.</div><button type="button" class="gs-pill" data-copy="add Distributions">add Distributions</button></li>
      </ul>
      <dl class="gs-next">
        <dt>Wrangle</dt><dd><a href="https://juliadata.org/DataFramesMeta.jl/stable/">DataFramesMeta.jl</a> · <a href="https://github.com/jkrumbiegel/Chain.jl">Chain.jl</a></dd>
        <dt>Files</dt><dd><a href="https://github.com/JuliaData/XLSX.jl">XLSX.jl</a> · <a href="https://github.com/apache/arrow-julia">Arrow.jl</a> · <a href="https://github.com/JuliaIO/JLD2.jl">JLD2.jl</a> · <a href="https://github.com/JuliaDatabases/SQLite.jl">SQLite.jl</a> · <a href="https://duckdb.org/docs/stable/clients/tertiary_clients/julia">DuckDB.jl</a></dd>
        <dt>Stats</dt><dd><a href="https://juliastats.org/StatsBase.jl/stable/">StatsBase.jl</a> · <a href="https://juliastats.org/GLM.jl/stable/">GLM.jl</a> · <a href="https://github.com/JuliaStats/HypothesisTests.jl">HypothesisTests.jl</a> · <a href="https://github.com/JuliaStats/MixedModels.jl">MixedModels.jl</a> · <a href="https://turinglang.org">Turing.jl</a></dd>
        <dt>Models</dt><dd><a href="https://juliaai.github.io/MLJ.jl/stable/">MLJ.jl</a> (trees, boosting, clustering, tuning)</dd>
        <dt>Plots</dt><dd><a href="https://aog.makie.org/stable/">AlgebraOfGraphics.jl</a> · <a href="https://docs.makie.org/stable/explanations/backends/glmakie">GLMakie.jl</a> · <a href="https://github.com/JuliaPlots/UnicodePlots.jl">UnicodePlots.jl</a></dd>
      </dl>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using CSV, DataFrames, Plots, Distributions, Statistics

CSV.write("data.csv", DataFrame(x = randn(1000), group = rand(["a", "b"], 1000)))
df = CSV.read("data.csv", DataFrame)

combine(groupby(df, :group), :x => mean)

d = fit(Normal, df.x)
histogram(df.x; normalize = true, label = "data")
plot!(x -> pdf(d, x); label = "fit", linewidth = 3)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-model" style="--kit: var(--gs-blue)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🌀</span>
        <div><h3>Model and solve</h3><p class="gs-when">You can write down the maths. A solver does the rest.</p></div></div>
      <ul class="gs-rows">
        <li><span class="gs-verb">Simulate</span><div><a href="https://docs.sciml.ai/DiffEqDocs/stable/">OrdinaryDiffEq.jl</a>: fast, adaptive solvers for ordinary differential equations, from simple to very stiff.</div><button type="button" class="gs-pill" data-copy="add OrdinaryDiffEq">add OrdinaryDiffEq</button></li>
        <li><span class="gs-verb">Optimize</span><div><a href="https://jump.dev/JuMP.jl/stable/">JuMP.jl</a> with the <a href="https://github.com/jump-dev/HiGHS.jl">HiGHS</a> solver, for constrained problems written as they look on paper. Or <a href="https://julianlsolvers.github.io/Optim.jl/stable/">Optim.jl</a> to minimize a plain function.</div><button type="button" class="gs-pill" data-copy="add JuMP HiGHS">add JuMP HiGHS</button></li>
        <li><span class="gs-verb">Differentiate</span><div><a href="https://juliadiff.org/ForwardDiff.jl/stable/">ForwardDiff.jl</a>: exact derivatives of ordinary Julia code.</div><button type="button" class="gs-pill" data-copy="add ForwardDiff">add ForwardDiff</button></li>
        <li><span class="gs-verb">Learn</span><div><a href="https://fluxml.ai/Flux.jl/stable/">Flux.jl</a>: neural networks that are plain Julia all the way down.</div><button type="button" class="gs-pill" data-copy="add Flux">add Flux</button></li>
      </ul>
      <dl class="gs-next">
        <dt>Equations</dt><dd><a href="https://sciml.ai">SciML</a> (SDEs, DAEs, delays) · <a href="https://docs.sciml.ai/ModelingToolkit/stable/">ModelingToolkit.jl</a> · <a href="https://docs.sciml.ai/Symbolics/stable/">Symbolics.jl</a> · <a href="https://docs.sciml.ai/NonlinearSolve/stable/">NonlinearSolve.jl</a> · <a href="https://github.com/JuliaMath/Roots.jl">Roots.jl</a></dd>
        <dt>Numerics</dt><dd><a href="https://github.com/JuliaMath/Interpolations.jl">Interpolations.jl</a> · <a href="https://github.com/JuliaMath/QuadGK.jl">QuadGK.jl</a> · <a href="https://github.com/JuliaMath/FFTW.jl">FFTW.jl</a> · <a href="https://github.com/JuliaDSP/DSP.jl">DSP.jl</a> · <a href="https://juliagraphs.org/Graphs.jl/stable/">Graphs.jl</a> · <a href="https://juliaimages.org">Images.jl</a></dd>
        <dt>Units</dt><dd><a href="https://github.com/JuliaPhysics/Unitful.jl">Unitful.jl</a> · <a href="https://juliaphysics.github.io/Measurements.jl/stable/">Measurements.jl</a> (error bars)</dd>
        <dt>Solvers</dt><dd><a href="https://github.com/jump-dev/Ipopt.jl">Ipopt.jl</a> (nonlinear)</dd>
        <dt>Learning</dt><dd><a href="https://lux.csail.mit.edu">Lux.jl</a> · <a href="https://enzyme.mit.edu/julia/">Enzyme.jl</a> (gradients of fast, mutating code)</dd>
      </dl>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using OrdinaryDiffEq

decay(u, p, t) = -p * u
sol = solve(ODEProblem(decay, 1.0, (0.0, 5.0), 0.8))
sol(2.5)   # ≈ exp(-2) = 0.135</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-fast" style="--kit: var(--gs-red)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🚀</span>
        <div><h3>Make it fast</h3><p class="gs-when">It works. Now measure it, find the slow part, fix it, and use every core.</p></div></div>
      <ul class="gs-rows">
        <li><span class="gs-verb">Measure</span><div><a href="https://juliaci.github.io/BenchmarkTools.jl/stable/">BenchmarkTools.jl</a>, from the toolbelt.</div><button type="button" class="gs-pill" data-copy="add BenchmarkTools">add BenchmarkTools</button></li>
        <li><span class="gs-verb">Find</span><div>The built-in <a href="https://docs.julialang.org/en/v1/manual/profile/">profiler</a> (<code>@profview</code> in VS Code), and the manual's <a href="https://docs.julialang.org/en/v1/manual/performance-tips/">performance tips</a>.</div></li>
        <li><span class="gs-verb">Fix</span><div><a href="https://juliaarrays.github.io/StaticArrays.jl/stable/">StaticArrays.jl</a>: small fixed-size arrays with no allocation.</div><button type="button" class="gs-pill" data-copy="add StaticArrays">add StaticArrays</button></li>
        <li><span class="gs-verb">Threads</span><div><a href="https://juliafolds2.github.io/OhMyThreads.jl/stable/">OhMyThreads.jl</a>: multithreaded <code>map</code>, <code>reduce</code> and loops. Start Julia with <code>-t auto</code>.</div><button type="button" class="gs-pill" data-copy="add OhMyThreads">add OhMyThreads</button></li>
        <li><span class="gs-verb">GPU</span><div>Pick the one for your hardware: <a href="https://cuda.juliagpu.org/stable/">CUDA.jl</a> (NVIDIA), <a href="https://metal.juliagpu.org/stable/">Metal.jl</a> (Apple) or <a href="https://amdgpu.juliagpu.org/stable/">AMDGPU.jl</a>.</div></li>
      </ul>
      <dl class="gs-next">
        <dt>Dig in</dt><dd><a href="https://aviatesk.github.io/JET.jl/stable/">JET.jl</a> (<code>@report_opt</code>) · <a href="https://github.com/JuliaDebug/Cthulhu.jl">Cthulhu.jl</a></dd>
        <dt>Portable</dt><dd><a href="https://github.com/JuliaGPU/KernelAbstractions.jl">KernelAbstractions.jl</a> (one kernel, any GPU)</dd>
        <dt>Startup</dt><dd><a href="https://julialang.github.io/PrecompileTools.jl/stable/">PrecompileTools.jl</a></dd>
      </dl>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia"># start Julia with: julia -t auto
using BenchmarkTools, OhMyThreads

@btime sum(x -> sin(x)^2, 1:10^7)
@btime tmapreduce(x -> sin(x)^2, +, 1:10^7)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-build" style="--kit: var(--gs-purple)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">📦</span>
        <div><h3>Build and ship</h3><p class="gs-when">The unit of work is a repo: a package, a command-line tool or a web service.</p></div></div>
      <ul class="gs-rows">
        <li><span class="gs-verb">Package</span><div><a href="https://juliaci.github.io/PkgTemplates.jl/stable/">PkgTemplates.jl</a> sets up a package with CI. Write tests with the <a href="https://docs.julialang.org/en/v1/stdlib/Test/">Test</a> stdlib, docs with <a href="https://documenter.juliadocs.org/stable/">Documenter.jl</a>, and catch common mistakes with <a href="https://juliatesting.github.io/Aqua.jl/stable/">Aqua.jl</a>.</div><button type="button" class="gs-pill" data-copy="add PkgTemplates Documenter Aqua">add PkgTemplates Documenter Aqua</button></li>
        <li><span class="gs-verb">Ship</span><div><a href="https://github.com/JuliaLang/JuliaC.jl">JuliaC.jl</a> compiles a program into a native executable. <a href="https://pkgdocs.julialang.org/v1/apps/">Pkg apps</a> let people install your package as a command-line tool.</div><button type="button" class="gs-pill" data-copy="app add JuliaC">app add JuliaC</button></li>
        <li><span class="gs-verb">Serve</span><div><a href="https://juliaweb.github.io/HTTP.jl/stable/">HTTP.jl</a> and <a href="https://github.com/JuliaIO/JSON.jl">JSON.jl</a> for clients and servers; <a href="https://refactorful.github.io/Oxygen.jl/stable/">Oxygen.jl</a> for routes in a few lines.</div><button type="button" class="gs-pill" data-copy="add HTTP JSON Oxygen">add HTTP JSON Oxygen</button></li>
      </ul>
      <dl class="gs-next">
        <dt>Style</dt><dd><a href="https://juliaeditorsupport.github.io/JuliaFormatter.jl/stable/">JuliaFormatter.jl</a> · <a href="https://github.com/fredrikekre/Runic.jl">Runic.jl</a></dd>
        <dt>Tests</dt><dd><a href="https://github.com/JuliaTesting/TestEnv.jl">TestEnv.jl</a> · <a href="https://github.com/julia-testitems/TestItemRunner.jl">TestItemRunner.jl</a></dd>
        <dt>Tools</dt><dd><a href="https://carlobaldassi.github.io/ArgParse.jl/stable/">ArgParse.jl</a> · <a href="https://github.com/timholy/ProgressMeter.jl">ProgressMeter.jl</a> · <a href="https://julialang.github.io/PackageCompiler.jl/stable/">PackageCompiler.jl</a></dd>
        <dt>Web apps</dt><dd><a href="https://genieframework.com">Genie.jl</a> · <a href="https://github.com/SimonDanisch/Bonito.jl">Bonito.jl</a></dd>
      </dl>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using PkgTemplates

t = Template(; user = "your-github-name",
               plugins = [GitHubActions(), Documenter{GitHubActions}()])
t("MyPackage")</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-agents" style="--kit: var(--gs-green)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🤖</span>
        <div><h3>Work through an agent</h3><p class="gs-when">You describe, an AI agent types. Give it a Julia that answers in milliseconds.</p></div></div>
      <ul class="gs-rows">
        <li><span class="gs-verb">Run</span><div><a href="https://github.com/KristofferC/JuliaDaemon.jl">JuliaDaemon.jl</a>: one warm session per project, with Revise loaded. The agent runs <code>jld eval</code> instead of starting Julia on every call, and you can <code>jld connect</code> to the same session.</div><button type="button" class="gs-pill" data-copy="app add JuliaDaemon">app add JuliaDaemon</button></li>
        <li><span class="gs-verb">Check</span><div><a href="https://aviatesk.github.io/JET.jl/stable/">JET.jl</a> finds errors without running the code, <a href="https://github.com/fredrikekre/Runic.jl">Runic.jl</a> formats it one fixed way, and <a href="https://github.com/julia-testitems/TestItemRunner.jl">TestItemRunner.jl</a> runs one test at a time.</div><button type="button" class="gs-pill" data-copy="add JET Runic TestItemRunner">add JET Runic TestItemRunner</button></li>
      </ul>
      <dl class="gs-next">
        <dt>Review</dt><dd><a href="https://juliatesting.github.io/ExplicitImports.jl/stable/">ExplicitImports.jl</a> (reports implicit and stale imports)</dd>
        <dt>MCP</dt><dd><a href="https://github.com/aplavin/julia-mcp">julia-mcp</a> (persistent sessions over MCP; a Python server, not a Julia package)</dd>
      </dl>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-bash"># teach your agent to use jld
jld install

# the first call starts a session
cd MyPkg
jld eval 'using MyPkg; MyPkg.foo()'

# later calls are warm, edits live
jld run test/runtests.jl</code></pre>
      </details>
    </article>

    <aside class="gs-kit gs-kit-more" id="kit-more" style="--kit: var(--gs-blue)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🧭</span>
        <div><h3>Didn't find yours?</h3><p class="gs-when">There are over 12,000 more. Some places to look:</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://platform.juliahub.com/ui/Packages">JuliaHub</a> Search every registered package and its docs.</li>
        <li><a href="https://juliapackagecomparisons.github.io">Package comparisons</a> Help choosing between similar packages.</li>
        <li><a href="https://discourse.julialang.org/c/first-steps/8">Ask on Discourse</a> The "First steps" category is friendly and quick.</li>
        <li><a href="/community/otherchannels/">Or chat</a> Zulip, Slack, Discord and more, if you'd rather talk in real time.</li>
        <li><a href="https://www.youtube.com/@TheJuliaLanguage">JuliaCon talks</a> Years of package demos and workshops, free on YouTube.</li>
      </ul>
    </aside>

  </div>

  <div class="gs-from">
    <strong>Coming from Python, R or MATLAB?</strong>
    <span><a href="https://juliapy.github.io/PythonCall.jl/stable/">PythonCall.jl</a> calls any Python library (with <a href="https://github.com/JuliaPy/CondaPkg.jl">CondaPkg.jl</a> for its dependencies), <a href="https://juliainterop.github.io/RCall.jl/stable/">RCall.jl</a> does the same for R, and the manual lists the <a href="https://docs.julialang.org/en/v1/manual/noteworthy-differences/">noteworthy differences</a>.</span>
    <button type="button" class="gs-pill" data-copy="add PythonCall CondaPkg">add PythonCall CondaPkg</button>
  </div>
</section>

<!-- Composability -->
<section class="gs-section" id="mix">
  <h2 class="gs-h2">Then mix them</h2>
  <p class="gs-sub">Julia packages work together even when their authors never planned it.
  That's <a href="https://www.youtube.com/watch?v=kc9HwsxE1OY">multiple dispatch</a> at work, and it's why a small kit goes a long way.</p>

  <div class="gs-mix">
    <div class="gs-mix-card">
      <h3>Write a function once&hellip;</h3>
<pre><code class="language-julia"># Newton's method, for plain numbers
function mysqrt(x)
    t = x
    for _ in 1:10
        t = (t + x / t) / 2
    end
    return t
end</code></pre>
    </div>
    <div class="gs-mix-card">
      <h3>&hellip;and every package can use it</h3>
<pre><code class="language-julia-repl">julia> using Measurements, ForwardDiff

julia> mysqrt(2.0 ± 0.1)     # error bars, propagated
1.414 ± 0.035

julia> mysqrt(big"2.0")      # as many digits as you like
1.414213562373095048801688724209698078569671875376948073176679737990732478462119

julia> ForwardDiff.derivative(mysqrt, 2.0)   # an exact derivative
0.35355339059327373</code></pre>
      <p class="gs-mix-note">Measurements.jl and ForwardDiff.jl know nothing about <code>mysqrt</code>, and <code>mysqrt</code> knows nothing about them. With CUDA.jl, <code>mysqrt.(CUDA.rand(10^6))</code> runs it on a GPU too.</p>
    </div>
  </div>
</section>

</div>

<script src="/libs/getting-started.js"></script>
~~~
