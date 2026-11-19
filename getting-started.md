@def title = "Getting started: pick a starter kit"
@def description = "The Julia packages people reach for first, grouped by what you want to do: data, plots, notebooks, simulation, machine learning, speed, web apps and more."
@def hascode = true

~~~
<link rel="stylesheet" href="/css/getting-started.css">

<div class="gs">

<!-- Hero -->
<header class="gs-hero">
  <div class="gs-hero-text">
    <p class="gs-kicker"><span class="gs-dots" aria-hidden="true"><i></i><i></i><i></i></span> Getting started</p>
    <h1>Pick a starter kit</h1>
    <p class="gs-lede">The General registry holds over 12,000 packages. To begin, you need about five.
    Below are the ones people reach for first, grouped by what you're here to do.
    Every kit is one line to install.</p>
    <p class="gs-prereq">No Julia yet? <a href="/install/">Install it</a> first; it takes a minute.
    New to the language? Read <a href="/learning/getting-started/">what Julia is</a>, or start with
    <a href="https://docs.julialang.org/en/v1/manual/getting-started/">the manual</a>.</p>
  </div>
  <div class="gs-term gs-hero-term" aria-hidden="true">
    <div class="gs-term-bar"><i></i><i></i><i></i></div>
    <pre class="gs-term-body"><span class="gs-p-julia">julia&gt;</span> <span class="gs-dim">]</span>
<span class="gs-p-pkg">(@v{{stable_release_short}}) pkg&gt;</span> <span id="gs-typer">add CSV DataFrames DataFramesMeta</span><span class="gs-caret"></span></pre>
  </div>
</header>

<!-- How a kit works -->
<ol class="gs-steps">
  <li><span class="gs-step-n">1</span><div><strong>Press <kbd>]</kbd></strong> at the <code>julia&gt;</code> prompt. It turns blue: you're in package mode.</div></li>
  <li><span class="gs-step-n">2</span><div><strong>Paste a kit's <code>add</code> line.</strong> Julia fetches the packages and precompiles them.</div></li>
  <li><span class="gs-step-n">3</span><div><strong>Press <kbd>Backspace</kbd></strong> to leave, then <code>using</code> them. If you forget step 2, <code>using</code> offers to install for you.</div></li>
</ol>

<!-- Toolbelt -->
<section class="gs-section" id="toolbelt">
  <h2 class="gs-h2">Pack these first: the toolbelt</h2>
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
        <span class="gs-tool-top"><a href="https://github.com/timholy/Revise.jl">Revise.jl</a><span class="gs-check" aria-hidden="true"></span></span>
        <span class="gs-tool-desc">Edit your code, keep your session. Changes to files and packages apply instantly, with no restart.</span>
      </label>

      <label class="gs-tool" style="--kit: var(--gs-red)">
        <input type="checkbox" value="OhMyREPL" checked>
        <span class="gs-tool-top"><a href="https://github.com/KristofferC/OhMyREPL.jl">OhMyREPL.jl</a><span class="gs-check" aria-hidden="true"></span></span>
        <span class="gs-tool-desc">Syntax highlighting and bracket matching as you type at the prompt.</span>
      </label>

      <label class="gs-tool" style="--kit: var(--gs-blue)">
        <input type="checkbox" value="BenchmarkTools">
        <span class="gs-tool-top"><a href="https://github.com/JuliaCI/BenchmarkTools.jl">BenchmarkTools.jl</a><span class="gs-check" aria-hidden="true"></span></span>
        <span class="gs-tool-desc"><code>@btime</code> and <code>@benchmark</code>: trustworthy timings, so you know what's fast.</span>
      </label>

      <label class="gs-tool" style="--kit: var(--gs-purple)">
        <input type="checkbox" value="Infiltrator">
        <span class="gs-tool-top"><a href="https://github.com/JuliaDebug/Infiltrator.jl">Infiltrator.jl</a><span class="gs-check" aria-hidden="true"></span></span>
        <span class="gs-tool-desc">Drop <code>@infiltrate</code> into any function to pause there and poke at its variables.</span>
      </label>

    </div>

    <div class="gs-belt-out">
      <p class="gs-out-label">1. Install them into your default environment</p>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> <span id="gs-belt-add">add DocBrowser Revise OhMyREPL</span></code><button type="button" class="gs-copy" data-copy-from="gs-belt-add">Copy</button></div>
      <p class="gs-out-label">2. Save this as <code>~/.julia/config/startup.jl</code></p>
<div id="gs-startup">
<pre><code class="language-julia">if isinteractive()
    using Revise
    using DocBrowser
    using OhMyREPL
end</code></pre>
</div>
      <p class="gs-out-note">On Windows the file lives at <code>%USERPROFILE%\.julia\config\startup.jl</code>. Revise always goes first, so it can track everything loaded after it.</p>
    </div>
  </div>
</section>

<!-- Kits -->
<section class="gs-section" id="kits">
  <h2 class="gs-h2">What are you here to do?</h2>
  <p class="gs-sub">Pick the one that sounds most like you, or browse everything. Each kit lists the packages to start with, and a few to try next.</p>

  <div class="gs-chips" role="group" aria-label="Filter kits">
    <button type="button" class="gs-chip" data-filter="all" aria-pressed="true">Show me everything</button>
    <button type="button" class="gs-chip" data-filter="student" aria-pressed="false">I'm learning</button>
    <button type="button" class="gs-chip" data-filter="science" aria-pressed="false">I do science &amp; engineering</button>
    <button type="button" class="gs-chip" data-filter="analyst" aria-pressed="false">I analyze data</button>
    <button type="button" class="gs-chip" data-filter="ml" aria-pressed="false">I train models</button>
    <button type="button" class="gs-chip" data-filter="dev" aria-pressed="false">I build software</button>
    <button type="button" class="gs-chip" data-filter="agent" aria-pressed="false">I just program through AI agents</button>
    <button type="button" class="gs-chip" data-filter="curious" aria-pressed="false">I'm just curious</button>
  </div>

  <div class="gs-kits">

    <article class="gs-kit" id="kit-data" data-tags="analyst science student" style="--kit: var(--gs-green)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🧮</span>
        <div><h3>Wrangle data</h3><p class="gs-when">You have a CSV and some questions.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/JuliaData/CSV.jl">CSV.jl</a> Fast, forgiving reader and writer for delimited files.</li>
        <li><a href="https://github.com/JuliaData/DataFrames.jl">DataFrames.jl</a> Tables you can filter, join, group and reshape.</li>
        <li><a href="https://github.com/JuliaData/DataFramesMeta.jl">DataFramesMeta.jl</a> Readable pipelines with <code>@chain</code>, <code>@subset</code> and <code>@combine</code>.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add CSV DataFrames DataFramesMeta</code><button type="button" class="gs-copy" data-copy="add CSV DataFrames DataFramesMeta">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/TidierOrg/TidierData.jl">TidierData.jl</a> (for dplyr fans) · <a href="https://github.com/JuliaData/XLSX.jl">XLSX.jl</a> · <a href="https://github.com/apache/arrow-julia">Arrow.jl</a> · <a href="https://duckdb.org/docs/stable/clients/julia">DuckDB.jl</a> · <a href="https://github.com/JuliaIO/JSON.jl">JSON.jl</a></p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using CSV, DataFrames, DataFramesMeta, Statistics

df = CSV.read("penguins.csv", DataFrame)

@chain df begin
    dropmissing(:body_mass_g)
    groupby(:species)
    @combine(:mean_mass = mean(:body_mass_g))
end</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-plots" data-tags="analyst science student ml curious" style="--kit: var(--gs-red)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">📈</span>
        <div><h3>Make a picture</h3><p class="gs-when">Numbers are fine, but you want to see them.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/MakieOrg/Makie.jl">CairoMakie.jl</a> Publication-quality 2D and 3D plots, from the Makie family.</li>
        <li><a href="https://github.com/MakieOrg/AlgebraOfGraphics.jl">AlgebraOfGraphics.jl</a> Grammar-of-graphics plotting straight from a table.</li>
        <li><a href="https://github.com/JuliaPlots/Plots.jl">Plots.jl</a> The other big family: one quick syntax, many backends.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add CairoMakie AlgebraOfGraphics Plots</code><button type="button" class="gs-copy" data-copy="add CairoMakie AlgebraOfGraphics Plots">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://docs.makie.org/stable/explanations/backends/glmakie">GLMakie.jl</a> (interactive windows) · <a href="https://docs.makie.org/stable/explanations/backends/wglmakie">WGLMakie.jl</a> (in the browser) · <a href="https://github.com/JuliaPlots/UnicodePlots.jl">UnicodePlots.jl</a> (in the terminal!)</p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using CairoMakie

x = range(0, 4π, length = 200)
fig, ax, _ = lines(x, sin.(x); label = "sin")
lines!(ax, x, cos.(x); label = "cos")
axislegend(ax)
save("waves.png", fig)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-notebooks" data-tags="student science analyst curious" style="--kit: var(--gs-purple)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">📓</span>
        <div><h3>Think in notebooks</h3><p class="gs-when">You want code, prose and plots on one page.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/JuliaPluto/Pluto.jl">Pluto.jl</a> Reactive notebooks: change one cell and everything that depends on it updates.</li>
        <li><a href="https://github.com/JuliaPluto/PlutoUI.jl">PlutoUI.jl</a> Sliders, buttons and pickers wired straight into your variables.</li>
        <li><a href="https://github.com/JuliaLang/IJulia.jl">IJulia.jl</a> The Julia kernel for Jupyter and JupyterLab.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add Pluto PlutoUI IJulia</code><button type="button" class="gs-copy" data-copy="add Pluto PlutoUI IJulia">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://quarto.org/docs/computations/julia.html">Quarto</a> (reports and slides) · <a href="https://github.com/fredrikekre/Literate.jl">Literate.jl</a> (scripts that become docs)</p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using Pluto
Pluto.run()   # opens a notebook in your browser

# then, in a cell:
using PlutoUI
@bind n Slider(1:100)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-simulate" data-tags="science" style="--kit: var(--gs-blue)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🌀</span>
        <div><h3>Simulate the world</h3><p class="gs-when">Differential equations, physical models, things that change over time.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/SciML/DifferentialEquations.jl">DifferentialEquations.jl</a> Hundreds of solvers for ODEs, SDEs, DAEs and more.</li>
        <li><a href="https://github.com/SciML/ModelingToolkit.jl">ModelingToolkit.jl</a> Write models symbolically; it simplifies and generates fast code.</li>
        <li><a href="https://github.com/JuliaPhysics/Unitful.jl">Unitful.jl</a> Physical units that check your dimensions and cost nothing at run time.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add DifferentialEquations ModelingToolkit Unitful</code><button type="button" class="gs-copy" data-copy="add DifferentialEquations ModelingToolkit Unitful">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/JuliaPhysics/Measurements.jl">Measurements.jl</a> (error propagation) · <a href="https://github.com/JuliaDynamics/Agents.jl">Agents.jl</a> (agent-based models) · <a href="https://sciml.ai">all of SciML</a></p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using DifferentialEquations, Plots

decay(u, p, t) = -p * u
prob = ODEProblem(decay, 1.0, (0.0, 5.0), 0.8)
sol = solve(prob)
plot(sol)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-optimize" data-tags="science analyst" style="--kit: var(--gs-green)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🎯</span>
        <div><h3>Find the best answer</h3><p class="gs-when">Schedules, portfolios, fits, designs: anything with a "minimize" in it.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/jump-dev/JuMP.jl">JuMP.jl</a> Write optimization models the way they look on paper.</li>
        <li><a href="https://github.com/jump-dev/HiGHS.jl">HiGHS.jl</a> A fast open-source solver for linear and mixed-integer problems.</li>
        <li><a href="https://github.com/JuliaNLSolvers/Optim.jl">Optim.jl</a> Minimize any Julia function, with or without gradients.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add JuMP HiGHS Optim</code><button type="button" class="gs-copy" data-copy="add JuMP HiGHS Optim">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/jump-dev/Ipopt.jl">Ipopt.jl</a> (nonlinear) · <a href="https://github.com/SciML/Optimization.jl">Optimization.jl</a> · <a href="https://github.com/JuliaMath/Roots.jl">Roots.jl</a></p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using JuMP, HiGHS

model = Model(HiGHS.Optimizer)
@variable(model, x >= 0)
@variable(model, 0 <= y <= 3)
@objective(model, Max, 12x + 20y)
@constraint(model, 6x + 8y <= 100)
@constraint(model, 7x + 12y <= 120)
optimize!(model)
value(x), value(y)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-ml" data-tags="ml analyst" style="--kit: var(--gs-purple)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🧠</span>
        <div><h3>Teach a machine</h3><p class="gs-when">Neural networks, classic models, and gradients of anything.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/FluxML/Flux.jl">Flux.jl</a> Deep learning that is plain Julia all the way down.</li>
        <li><a href="https://github.com/JuliaAI/MLJ.jl">MLJ.jl</a> One interface to 200+ models: trees, boosting, clustering, tuning.</li>
        <li><a href="https://github.com/EnzymeAD/Enzyme.jl">Enzyme.jl</a> Automatic differentiation at the compiler level.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add Flux MLJ Enzyme</code><button type="button" class="gs-copy" data-copy="add Flux MLJ Enzyme">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/LuxDL/Lux.jl">Lux.jl</a> (explicit-parameter networks) · <a href="https://github.com/JuliaDiff/ForwardDiff.jl">ForwardDiff.jl</a> · <a href="https://github.com/JuliaML/MLDatasets.jl">MLDatasets.jl</a></p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using Flux

model = Chain(Dense(4 => 16, relu), Dense(16 => 3), softmax)
opt = Flux.setup(Adam(), model)
loss(m, x, y) = Flux.crossentropy(m(x), y)

# x: 4×N features, y: 3×N one-hot labels
Flux.train!(loss, model, [(x, y)], opt)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-stats" data-tags="analyst science student" style="--kit: var(--gs-red)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🎲</span>
        <div><h3>Do the statistics</h3><p class="gs-when">Distributions, regressions, tests, and Bayesian models.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/JuliaStats/Distributions.jl">Distributions.jl</a> Sample, fit and evaluate nearly every probability distribution.</li>
        <li><a href="https://github.com/JuliaStats/GLM.jl">GLM.jl</a> Linear and generalized linear models with R-style <code>@formula</code>s.</li>
        <li><a href="https://github.com/TuringLang/Turing.jl">Turing.jl</a> Probabilistic programming: write the model, get the posterior.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add Distributions GLM Turing</code><button type="button" class="gs-copy" data-copy="add Distributions GLM Turing">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/JuliaStats/StatsBase.jl">StatsBase.jl</a> · <a href="https://github.com/JuliaStats/HypothesisTests.jl">HypothesisTests.jl</a> · <a href="https://github.com/JuliaStats/MixedModels.jl">MixedModels.jl</a></p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using Turing

@model function coin(flips)
    p ~ Beta(1, 1)
    for i in eachindex(flips)
        flips[i] ~ Bernoulli(p)
    end
end

chain = sample(coin([1, 0, 1, 1, 1, 0, 1]), NUTS(), 1000)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-speed" data-tags="science ml dev" style="--kit: var(--gs-blue)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🚀</span>
        <div><h3>Go faster</h3><p class="gs-when">Your code works. Now you want all the cores, or a GPU.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/JuliaFolds2/OhMyThreads.jl">OhMyThreads.jl</a> Multithreaded <code>map</code>, <code>reduce</code> and loops without the footguns.</li>
        <li><a href="https://github.com/JuliaArrays/StaticArrays.jl">StaticArrays.jl</a> Small fixed-size arrays that live on the stack.</li>
        <li><a href="https://github.com/JuliaGPU/CUDA.jl">CUDA.jl</a> Run arrays and your own kernels on NVIDIA GPUs.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add OhMyThreads StaticArrays CUDA</code><button type="button" class="gs-copy" data-copy="add OhMyThreads StaticArrays CUDA">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/JuliaGPU/AMDGPU.jl">AMDGPU.jl</a> · <a href="https://github.com/JuliaGPU/Metal.jl">Metal.jl</a> · <a href="https://github.com/JuliaGPU/KernelAbstractions.jl">KernelAbstractions.jl</a> · <a href="https://github.com/aviatesk/JET.jl">JET.jl</a> · <a href="https://github.com/JuliaDebug/Cthulhu.jl">Cthulhu.jl</a></p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia"># start Julia with: julia -t auto
using OhMyThreads, BenchmarkTools

@btime sum(x -> sin(x)^2, 1:10^7)
@btime tmapreduce(x -> sin(x)^2, +, 1:10^7)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-interop" data-tags="analyst ml dev" style="--kit: var(--gs-green)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🤝</span>
        <div><h3>Bring your old friends</h3><p class="gs-when">You have Python, R or C++ code you're not ready to leave behind.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/JuliaPy/PythonCall.jl">PythonCall.jl</a> Call any Python library from Julia, and Julia from Python.</li>
        <li><a href="https://github.com/JuliaInterop/RCall.jl">RCall.jl</a> Use R and its packages, with an R prompt inside the REPL.</li>
        <li><a href="https://github.com/JuliaInterop/CxxWrap.jl">CxxWrap.jl</a> Wrap C++ libraries. (C and Fortran need nothing: just <code>@ccall</code>.)</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add PythonCall RCall CxxWrap</code><button type="button" class="gs-copy" data-copy="add PythonCall RCall CxxWrap">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/JuliaPy/CondaPkg.jl">CondaPkg.jl</a> (Python dependencies) · <a href="https://github.com/JuliaInterop/MATLAB.jl">MATLAB.jl</a> · <a href="https://docs.julialang.org/en/v1/manual/noteworthy-differences/">Noteworthy differences</a></p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using PythonCall, CondaPkg
CondaPkg.add("numpy")

np = pyimport("numpy")
np.linspace(0, 1, 5)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-web" data-tags="dev" style="--kit: var(--gs-red)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🌐</span>
        <div><h3>Build for the web</h3><p class="gs-when">APIs, dashboards, and talking to other services.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/JuliaWeb/HTTP.jl">HTTP.jl</a> HTTP clients and servers, plus WebSockets.</li>
        <li><a href="https://github.com/JuliaIO/JSON.jl">JSON.jl</a> Read and write JSON, straight into your own types.</li>
        <li><a href="https://github.com/Refactorful/Oxygen.jl">Oxygen.jl</a> A small web framework: routes in a few lines.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add HTTP JSON Oxygen</code><button type="button" class="gs-copy" data-copy="add HTTP JSON Oxygen">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/GenieFramework/Genie.jl">Genie.jl</a> (full-stack apps) · <a href="https://github.com/SimonDanisch/Bonito.jl">Bonito.jl</a> (interactive dashboards)</p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using Oxygen

@get "/hello/{name}" function (req, name)
    "Hello, $name!"
end

serve(port = 8080)   # visit localhost:8080/hello/julia</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-images" data-tags="science ml curious" style="--kit: var(--gs-purple)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🔭</span>
        <div><h3>Look at pixels and signals</h3><p class="gs-when">Photos, microscopy, audio, sensor data.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/JuliaImages/Images.jl">Images.jl</a> Filter, segment, resize and measure images as plain arrays.</li>
        <li><a href="https://github.com/JuliaIO/FileIO.jl">FileIO.jl</a> One <code>load</code> and <code>save</code> for images, audio, meshes and more.</li>
        <li><a href="https://github.com/JuliaMath/FFTW.jl">FFTW.jl</a> Fast Fourier transforms, from the library everyone uses.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add Images FileIO FFTW</code><button type="button" class="gs-copy" data-copy="add Images FileIO FFTW">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/JuliaDSP/DSP.jl">DSP.jl</a> (filters, spectrograms) · <a href="https://github.com/JuliaGraphics/Colors.jl">Colors.jl</a></p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using Images, FileIO

img = load("cat.png")
small = imresize(Gray.(img); ratio = 0.5)
save("cat-gray.png", small)</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-agents" data-tags="agent dev" style="--kit: var(--gs-purple)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🤖</span>
        <div><h3>Code with an agent</h3><p class="gs-when">You describe, an AI agent types. Give it a Julia that answers in milliseconds.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/KristofferC/JuliaDaemon.jl">JuliaDaemon.jl</a> One warm, Revise-enabled session per project. Your agent runs <code>jld eval</code> instead of paying startup on every <code>julia -e</code>, and you can <code>jld connect</code> to the same session.</li>
        <li><a href="https://github.com/aviatesk/JET.jl">JET.jl</a> Finds type errors and typos without running the code, so mistakes surface before the agent says "done".</li>
        <li><a href="https://github.com/JuliaTesting/ExplicitImports.jl">ExplicitImports.jl</a> Makes every name's origin explicit, which keeps agent-written code easy to review.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> app add https://github.com/KristofferC/JuliaDaemon.jl</code><button type="button" class="gs-copy" data-copy="app add https://github.com/KristofferC/JuliaDaemon.jl">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/aplavin/julia-mcp">julia-mcp</a> (persistent sessions over MCP) · <a href="https://github.com/fredrikekre/Runic.jl">Runic.jl</a> (one formatting style, no options) · <a href="https://github.com/julia-testitems/TestItemRunner.jl">TestItemRunner.jl</a> (run one test at a time)</p>
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

    <article class="gs-kit" id="kit-package" data-tags="dev agent" style="--kit: var(--gs-blue)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">📦</span>
        <div><h3>Write a package</h3><p class="gs-when">Your scripts deserve tests, docs and a version number.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/JuliaCI/PkgTemplates.jl">PkgTemplates.jl</a> A new package with CI, docs and tests in one call.</li>
        <li><a href="https://github.com/JuliaDocs/Documenter.jl">Documenter.jl</a> Docs sites from your docstrings and Markdown.</li>
        <li><a href="https://github.com/JuliaTesting/Aqua.jl">Aqua.jl</a> Automatic checks for the mistakes package authors make.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add PkgTemplates Documenter Aqua</code><button type="button" class="gs-copy" data-copy="add PkgTemplates Documenter Aqua">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/aviatesk/JET.jl">JET.jl</a> (find bugs before running) · <a href="https://github.com/fredrikekre/Runic.jl">Runic.jl</a> (formatter) · <a href="https://github.com/JuliaLang/PrecompileTools.jl">PrecompileTools.jl</a></p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using PkgTemplates

t = Template(; user = "your-github-name",
               plugins = [GitHubActions(), Documenter{GitHubActions}()])
t("MyPackage")</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-ship" data-tags="dev agent" style="--kit: var(--gs-green)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🛳️</span>
        <div><h3>Ship it</h3><p class="gs-when">Other people need to run your code without installing Julia.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/JuliaLang/JuliaC.jl">JuliaC.jl</a> Compile a program into a small native executable or library.</li>
        <li><a href="https://pkgdocs.julialang.org/v1/apps/">Pkg apps</a> Install command-line tools written in Julia, with <code>app add</code>.</li>
        <li><a href="https://github.com/JuliaLang/PackageCompiler.jl">PackageCompiler.jl</a> Custom system images and relocatable apps.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> app add JuliaC</code><button type="button" class="gs-copy" data-copy="app add JuliaC">Copy</button></div>
      <p class="gs-also"><span>Note:</span> JuliaC installs as an app, so <code>juliac</code> lands in <code>~/.julia/bin</code>. Add that to your <code>PATH</code>.</p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia"># hello.jl
function (@main)(args)
    println(Core.stdout, "Hello from a native binary!")
    return 0
end

# then, in your shell:
#   juliac --output-exe hello --bundle build --trim=safe --experimental hello.jl</code></pre>
      </details>
    </article>

    <article class="gs-kit" id="kit-fun" data-tags="curious student" style="--kit: var(--gs-red)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🎨</span>
        <div><h3>Just play</h3><p class="gs-when">No deadline. Draw something, decorate your terminal, make a game.</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://github.com/JuliaGraphics/Luxor.jl">Luxor.jl</a> Friendly 2D vector drawing: posters, diagrams, generative art.</li>
        <li><a href="https://github.com/FedeClaudi/Term.jl">Term.jl</a> Colourful panels, trees and tracebacks in the terminal.</li>
        <li><a href="https://github.com/timholy/ProgressMeter.jl">ProgressMeter.jl</a> Put <code>@showprogress</code> on a loop and watch it go.</li>
      </ul>
      <div class="gs-add"><code><span class="gs-p-pkg">pkg&gt;</span> add Luxor Term ProgressMeter</code><button type="button" class="gs-copy" data-copy="add Luxor Term ProgressMeter">Copy</button></div>
      <p class="gs-also"><span>Next:</span> <a href="https://github.com/aviks/GameZero.jl">GameZero.jl</a> (2D games) · <a href="https://github.com/JuliaPlots/UnicodePlots.jl">UnicodePlots.jl</a> · <a href="https://github.com/JuliaGraphics/Colors.jl">Colors.jl</a></p>
      <details class="gs-taste"><summary>Taste it</summary>
<pre><code class="language-julia">using Luxor

@draw begin
    julialogo(centered = true)
end 400 300</code></pre>
      </details>
    </article>

    <aside class="gs-kit gs-kit-more" id="kit-more" data-tags="all" style="--kit: var(--gs-blue)">
      <div class="gs-kit-head"><span class="gs-kit-icon" aria-hidden="true">🧭</span>
        <div><h3>Didn't find yours?</h3><p class="gs-when">There are over 12,000 more. Some places to look:</p></div></div>
      <ul class="gs-pkgs">
        <li><a href="https://juliahub.com/ui/Packages">JuliaHub</a> Search every registered package and its docs.</li>
        <li><a href="https://juliapackagecomparisons.github.io">Package comparisons</a> Help choosing between similar packages.</li>
        <li><a href="https://discourse.julialang.org/c/new-to-julia/14">Ask on Discourse</a> The "New to Julia" category is friendly and quick.</li>
      </ul>
    </aside>
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
