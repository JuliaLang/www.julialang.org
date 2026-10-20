# Render the images for the Ecosystem tabs on the landing page (index.html).
#
#   julia --project=tools/ecosystem-images -t auto tools/ecosystem-images/render.jl
#
# Writes _assets/infra/ecosystem-{data,general,ml,sci,parallel}.webp (needs `cwebp`).
# Images are 800×534 and shown at 400px wide, so they stay sharp on 2x screens.

using CairoMakie, AlgebraOfGraphics, DataFrames
using OrdinaryDiffEq
using Lux, Optimisers, Zygote
using Random, Statistics

const OUT = normpath(joinpath(@__DIR__, "..", "..", "_assets", "infra"))
const SIZE = (800, 534)
const JULIA_COLORS = (blue = "#4063D8", green = "#389826", purple = "#9558B2", red = "#CB3C33")

set_theme!(theme_light(); fontsize = 22, size = SIZE, backgroundcolor = :white)

function save_webp(fig, name)
    png = tempname() * ".png"
    save(png, fig; px_per_unit = 1)
    webp = joinpath(OUT, "ecosystem-$name.webp")
    run(`cwebp -quiet -q 80 $png -o $webp`)
    rm(png)
    println(relpath(webp), "  ", round(filesize(webp) / 1024; digits = 1), " KB")
end

# Data Science & Visualization: a faceted AlgebraOfGraphics plot of a DataFrame.
function render_data()
    rng = Xoshiro(1)
    n = 60
    df = DataFrame(group = String[], site = String[], x = Float64[], y = Float64[])
    for (site, slope0) in (("Site A", 0.8), ("Site B", 1.4)),
        (group, offset) in (("low", 0.0), ("mid", 2.0), ("high", 4.0))
        x = 10 .* rand(rng, n)
        y = offset .+ slope0 .* x .+ randn(rng, n)
        append!(df, DataFrame(group = group, site = site, x = x, y = y))
    end
    plt = data(df) * mapping(:x, :y; color = :group => sorter("low", "mid", "high"), col = :site) *
          (visual(Scatter; markersize = 9, alpha = 0.6) + linear())
    fig = Figure()
    grid = draw!(fig[1, 1], plt, scales(Color = (; palette = [JULIA_COLORS.blue, JULIA_COLORS.green, JULIA_COLORS.purple])))
    legend!(fig[2, 1], grid; orientation = :horizontal, titleposition = :left, framevisible = false)
    save_webp(fig, "data")
end

# General Purpose: Julia calling into other languages.
function render_general()
    fig = Figure()
    ax = Axis(fig[1, 1]; aspect = DataAspect())
    hidedecorations!(ax); hidespines!(ax)
    langs = ["C / Fortran", "C++", "Python", "R", "Java", "MATLAB", "Mathematica"]
    colors = [JULIA_COLORS.red, JULIA_COLORS.green, JULIA_COLORS.purple, JULIA_COLORS.blue,
              JULIA_COLORS.red, JULIA_COLORS.green, JULIA_COLORS.purple]
    θ = range(π / 2, π / 2 + 2π; length = length(langs) + 1)[1:end-1]
    R = 3.0
    pts = [Point2f(1.45R * cos(t), R * sin(t)) for t in θ]
    for (p, c) in zip(pts, colors)
        lines!(ax, [Point2f(0, 0), p]; color = (c, 0.5), linewidth = 4)
    end
    scatter!(ax, pts; markersize = 26, color = colors)
    for (p, l, t) in zip(pts, langs, θ)
        align = cos(t) > 0.2 ? (:left, :center) : cos(t) < -0.2 ? (:right, :center) : (:center, sin(t) > 0 ? :bottom : :top)
        off = 0.35 .* (cos(t) > 0.2 ? (1, 0) : cos(t) < -0.2 ? (-1, 0) : (0, sign(sin(t))))
        text!(ax, p + Point2f(off...); text = l, align = align, fontsize = 24)
    end
    scatter!(ax, [Point2f(0, 0)]; markersize = 120, color = :white, strokecolor = JULIA_COLORS.purple, strokewidth = 4)
    text!(ax, Point2f(0, 0); text = "Julia", align = (:center, :center), fontsize = 30, font = :bold, color = :black)
    limits!(ax, -6.5, 6.5, -4.2, 4.2)
    save_webp(fig, "general")
end

# Machine Learning: decision boundary of a small Lux classifier on two moons.
function render_ml()
    rng = Xoshiro(2)
    n = 200
    t = π .* rand(rng, n)
    X = hcat(vcat(cos.(t)', sin.(t)'), vcat(1 .- cos.(t)', 0.5 .- sin.(t)'))
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
              colormap = cgrad([JULIA_COLORS.blue, :white, JULIA_COLORS.red]; alpha = 0.45))
    contour!(ax, xs, ys, prob; levels = [0.5], color = :black, linewidth = 2)
    scatter!(ax, X[1, 1:n], X[2, 1:n]; color = JULIA_COLORS.blue, markersize = 9, strokecolor = :white, strokewidth = 0.8)
    scatter!(ax, X[1, n+1:end], X[2, n+1:end]; color = JULIA_COLORS.red, markersize = 9, strokecolor = :white, strokewidth = 0.8)
    limits!(ax, extrema(xs)..., extrema(ys)...)
    save_webp(fig, "ml")
end

# Scientific Computing: the Lorenz attractor solved with OrdinaryDiffEq.
function render_sci()
    function lorenz!(du, u, p, t)
        σ, ρ, β = p
        du[1] = σ * (u[2] - u[1])
        du[2] = u[1] * (ρ - u[3]) - u[2]
        du[3] = u[1] * u[2] - β * u[3]
    end
    prob = ODEProblem(lorenz!, [1.0, 0.0, 0.0], (0.0, 60.0), (10.0, 28.0, 8 / 3))
    sol = solve(prob, Tsit5(); saveat = 0.005)
    fig = Figure()
    ax = Axis3(fig[1, 1]; azimuth = 0.7π, elevation = 0.12π, aspect = (1, 1, 0.9),
               protrusions = 0, xlabel = "x", ylabel = "y", zlabel = "z",
               xticklabelsvisible = false, yticklabelsvisible = false, zticklabelsvisible = false)
    lines!(ax, sol[1, :], sol[2, :], sol[3, :]; color = sol.t, colormap = :viridis, linewidth = 1.2)
    save_webp(fig, "sci")
end

# Parallel Computing: a Mandelbrot set computed with Threads.@threads.
function render_parallel()
    w, h = SIZE
    xs = range(-2.2, 0.8; length = w)
    ys = range(-1.0, 1.0; length = h)
    escape = Matrix{Float64}(undef, w, h)
    maxiter = 200
    Threads.@threads for i in 1:w
        for j in 1:h
            c = complex(xs[i], ys[j])
            z = zero(c)
            k = 0
            while abs2(z) <= 4 && k < maxiter
                z = z * z + c
                k += 1
            end
            escape[i, j] = k == maxiter ? NaN : k + 1 - log2(log2(abs2(z)) / 2)
        end
    end
    fig = Figure(; figure_padding = 0)
    ax = Axis(fig[1, 1])
    hidedecorations!(ax); hidespines!(ax)
    heatmap!(ax, xs, ys, log.(escape); colormap = :magma, nan_color = :black)
    save_webp(fig, "parallel")
end

render_data()
render_general()
render_ml()
render_sci()
render_parallel()
