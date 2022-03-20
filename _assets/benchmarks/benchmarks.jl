using Base.MathConstants
using CSV
using DataFrames
using Gadfly
using PooledArrays

benchmarks = CSV.read("benchmarks.csv", DataFrame; header=["language", "benchmark", "time"])
cdata = benchmarks[benchmarks[!, :language].== "c", :]
benchmarks = innerjoin(benchmarks, cdata, on=:benchmark, makeunique=true)
benchmarks[!, :time]./= benchmarks[!, :time_1]
benchmarks[!, :language] = PooledArray(benchmarks[!, :language])
benchmarks[!, :benchmark] = PooledArray(benchmarks[!, :benchmark])
benchmarks[!, :language] = replace(lang -> lang == "javascript" ? "JavaScript" : uppercasefirst(lang),
                                   benchmarks[!, :language])

p = plot(benchmarks,
    x = :language,
    y = :time,
    color = :benchmark,
    Scale.y_log10,
    Guide.ylabel(nothing),
    Guide.xlabel(nothing),
    Theme(
        point_size = 1mm,
        guide_title_position = :left,
        colorkey_swatch_shape = :circle,
        minor_label_font = "Georgia",
        major_label_font = "Georgia",
    ),
)

draw(SVG("benchmarks.svg", 9inch, 9inch/golden), p)
