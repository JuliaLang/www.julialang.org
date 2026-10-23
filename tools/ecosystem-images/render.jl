# Render the plot images for the Ecosystem carousel on the landing page (index.html),
# each in a light and a dark version (the page swaps them with the theme).
#
#   julia --project=tools/ecosystem-images tools/ecosystem-images/render.jl
#
# Writes _assets/infra/ecosystem/{sciml,optimization,viz,ml}.webp and the
# matching *-dark.webp (needs `cwebp`). Images are 760×640 and shown at about
# 380×320, so they stay sharp on 2x screens.

using CairoMakie
using OrdinaryDiffEq
using Lux, Optimisers, Zygote
using JuMP, HiGHS
using Random, Statistics

const OUT = normpath(joinpath(@__DIR__, "..", "..", "_assets", "infra", "ecosystem"))
const SIZE = (760, 640)
const JULIA = (blue = "#4063D8", green = "#389826", purple = "#9558B2", red = "#CB3C33")

# Backgrounds match the image box in _css/app.css (.eco-img, light and dark).
const THEMES = (
    (suffix = "", base = theme_light(), bg = "#ffffff", fg = "#333333", grid = "#e0e0e0", lightmode = true),
    (suffix = "-dark", base = theme_dark(), bg = "#232338", fg = "#d6d6e0", grid = "#3a3a52", lightmode = false),
)

function apply_theme(t)
    axis = (backgroundcolor = t.bg, xgridcolor = t.grid, ygridcolor = t.grid,
            xtickcolor = t.fg, ytickcolor = t.fg, xticklabelcolor = t.fg, yticklabelcolor = t.fg,
            xlabelcolor = t.fg, ylabelcolor = t.fg, titlecolor = t.fg,
            leftspinecolor = t.grid, rightspinecolor = t.grid, topspinecolor = t.grid, bottomspinecolor = t.grid)
    axis3 = (backgroundcolor = t.bg, xgridcolor = t.grid, ygridcolor = t.grid, zgridcolor = t.grid,
             xlabelcolor = t.fg, ylabelcolor = t.fg, zlabelcolor = t.fg,
             xspinecolor_1 = t.grid, yspinecolor_1 = t.grid, zspinecolor_1 = t.grid,
             xspinecolor_2 = t.grid, yspinecolor_2 = t.grid, zspinecolor_2 = t.grid,
             xspinecolor_3 = t.grid, yspinecolor_3 = t.grid, zspinecolor_3 = t.grid)
    set_theme!(merge(t.base, Theme(; fontsize = 20, size = SIZE, backgroundcolor = t.bg, textcolor = t.fg,
                                   Axis = axis, Axis3 = axis3, Legend = (backgroundcolor = t.bg, framecolor = t.grid))))
end

function save_webp(fig, name)
    png = tempname() * ".png"
    save(png, fig; px_per_unit = 1)
    webp = joinpath(OUT, "$name.webp")
    run(`cwebp -quiet -q 85 $png -o $webp`)
    rm(png)
    println(relpath(webp), "  ", round(filesize(webp) / 1024; digits = 1), " KB")
end

# Scientific machine learning: the Lorenz attractor, solved with OrdinaryDiffEq.
function render_sciml(t)
    function lorenz!(du, u, p, t)
        σ, ρ, β = p
        du[1] = σ * (u[2] - u[1])
        du[2] = u[1] * (ρ - u[3]) - u[2]
        du[3] = u[1] * u[2] - β * u[3]
    end
    prob = ODEProblem(lorenz!, [1.0, 0.0, 0.0], (0.0, 60.0), (10.0, 28.0, 8 / 3))
    sol = solve(prob, Tsit5(); saveat = 0.005)
    fig = Figure()
    ax = Axis3(fig[1, 1]; azimuth = 0.7π, elevation = 0.12π, aspect = (1, 1, 0.9), protrusions = 0,
               xlabel = "x", ylabel = "y", zlabel = "z",
               xticklabelsvisible = false, yticklabelsvisible = false, zticklabelsvisible = false)
    lines!(ax, sol[1, :], sol[2, :], sol[3, :]; color = sol.t, colormap = t.lightmode ? :viridis : :plasma, linewidth = 1.3)
    save_webp(fig, "sciml$(t.suffix)")
end

# Optimization: a small linear program solved with JuMP and HiGHS, showing the
# feasible region, the objective's level lines and the optimum.
function render_optimization(t)
    # maximise 3x + 2y  s.t.  x + y ≤ 4,  x + 3y ≤ 6,  3x + y ≤ 9,  x, y ≥ 0
    A = [1.0 1.0; 1.0 3.0; 3.0 1.0]
    b = [4.0, 6.0, 9.0]
    c = [3.0, 2.0]
    model = Model(HiGHS.Optimizer)
    set_silent(model)
    @variable(model, x[1:2] >= 0)
    @constraint(model, A * x .<= b)
    @objective(model, Max, c' * x)
    optimize!(model)
    xopt = value.(x)
    zopt = objective_value(model)

    # Vertices of the feasible polygon, from pairwise intersections of the constraints
    lines_ = vcat([(A[i, :], b[i]) for i in 1:3], [([1.0, 0.0], 0.0), ([0.0, 1.0], 0.0)])
    verts = Point2f[]
    for i in 1:length(lines_), j in i+1:length(lines_)
        M = hcat(lines_[i][1], lines_[j][1])'
        abs(LinearAlgebra_det(M)) < 1e-9 && continue
        p = M \ [lines_[i][2], lines_[j][2]]
        all(A * p .<= b .+ 1e-9) && all(p .>= -1e-9) && push!(verts, Point2f(p...))
    end
    centre = sum(verts) / length(verts)
    sort!(verts; by = v -> atan(v[2] - centre[2], v[1] - centre[1]))

    fig = Figure()
    ax = Axis(fig[1, 1]; xlabel = "x", ylabel = "y", limits = (-0.2, 4.4, -0.2, 3.4), aspect = DataAspect())
    poly!(ax, verts; color = (JULIA.blue, 0.22), strokecolor = JULIA.blue, strokewidth = 2.5)
    for z in (3.0, 6.0, 9.0)
        xs = [0.0, 4.4]
        lines!(ax, xs, (z .- c[1] .* xs) ./ c[2]; color = (JULIA.purple, 0.55), linestyle = :dash, linewidth = 1.5)
    end
    xs = [0.0, 4.4]
    lines!(ax, xs, (zopt .- c[1] .* xs) ./ c[2]; color = JULIA.purple, linewidth = 2.5)
    scatter!(ax, [Point2f(xopt...)]; color = JULIA.red, markersize = 22, strokecolor = t.bg, strokewidth = 2)
    text!(ax, Point2f(xopt...) + Point2f(0.12, 0.1); text = "optimum", color = JULIA.red, fontsize = 22, font = :bold)
    text!(ax, Point2f(0.9, 0.9); text = "feasible\nregion", color = JULIA.blue, fontsize = 20, align = (:center, :center))
    save_webp(fig, "optimization$(t.suffix)")
end
LinearAlgebra_det(M) = M[1, 1] * M[2, 2] - M[1, 2] * M[2, 1]

# Visualization: a Makie surface plot.
function render_viz(t)
    xs = range(0, 10; length = 120)
    ys = range(0, 15; length = 120)
    zs = [cos(x) * sin(y) for x in xs, y in ys]
    fig = Figure()
    ax = Axis3(fig[1, 1]; xlabel = "x", ylabel = "y", zlabel = "z", azimuth = 1.3π, elevation = 0.2π,
               protrusions = 10)
    surface!(ax, xs, ys, zs; colormap = :viridis)
    save_webp(fig, "viz$(t.suffix)")
end

# Machine learning: decision boundary of a small Lux classifier on two moons.
function render_ml(t)
    rng = Xoshiro(2)
    n = 200
    θ = π .* rand(rng, n)
    X = hcat(vcat(cos.(θ)', sin.(θ)'), vcat(1 .- cos.(θ)', 0.5 .- sin.(θ)'))
    X .+= 0.12 .* randn(rng, size(X))
    y = reshape(vcat(zeros(n), ones(n)), 1, :)
    Xf, yf = Float32.(X), Float32.(y)

    model = Chain(Dense(2 => 16, tanh), Dense(16 => 16, tanh), Dense(16 => 1))
    ps, st = Lux.setup(rng, model)
    logitbce(z, y) = mean(@. max(z, 0) - z * y + log1p(exp(-abs(z))))
    loss(p) = logitbce(first(model(Xf, p, st)), yf)
    opt = Optimisers.setup(Adam(0.02f0), ps)
    for _ in 1:600
        g, = Zygote.gradient(loss, ps)
        opt, ps = Optimisers.update!(opt, ps, g)
    end

    xs = range(-1.6, 2.6; length = 200)
    ys = range(-1.1, 1.6; length = 150)
    grid = Float32.(hcat(([x, y] for x in xs, y in ys)...))
    prob = reshape(1 ./ (1 .+ exp.(-first(model(grid, ps, st)))), length(xs), length(ys))

    fig = Figure(; figure_padding = 0)
    ax = Axis(fig[1, 1])
    hidedecorations!(ax); hidespines!(ax)
    contourf!(ax, xs, ys, prob; levels = 0:0.1:1,
              colormap = cgrad([JULIA.blue, t.bg, JULIA.red]; alpha = t.lightmode ? 0.45 : 0.6))
    contour!(ax, xs, ys, prob; levels = [0.5], color = t.fg, linewidth = 2)
    scatter!(ax, X[1, 1:n], X[2, 1:n]; color = JULIA.blue, markersize = 9, strokecolor = t.bg, strokewidth = 0.8)
    scatter!(ax, X[1, n+1:end], X[2, n+1:end]; color = JULIA.red, markersize = 9, strokecolor = t.bg, strokewidth = 0.8)
    limits!(ax, extrema(xs)..., extrema(ys)...)
    save_webp(fig, "ml$(t.suffix)")
end

for t in THEMES
    apply_theme(t)
    render_sciml(t)
    render_optimization(t)
    render_viz(t)
    render_ml(t)
end
