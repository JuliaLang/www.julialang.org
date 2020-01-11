using DataFrames
using Gadfly

benchmarks = readtable("benchmarks.csv", names=[:language, :benchmark, :time])
cdata = benchmarks[benchmarks[:language].== "c", :]
benchmarks = join(benchmarks, cdata, on=:benchmark)
benchmarks[:time]./= benchmarks[:time_1]
benchmarks[:language] = PooledDataArray(benchmarks[:language])
benchmarks[:benchmark] = PooledDataArray(benchmarks[:benchmark])
benchmarks = benchmarks[benchmarks[:language].!= "c", :]
benchmarks[:language] = setlevels!(benchmarks[:language], Dict{UTF8String,Any}(
  [lang => (lang == "javascript" ? "JavaScript" : ucfirst(lang)) for lang in benchmarks[:language]]))

p = plot(benchmarks,
    x = :language,
    y = :time,
    color = :benchmark,
    Scale.y_log10,
    Guide.ylabel(nothing),
    Guide.xlabel(nothing),
    Theme(
        default_point_size = 1mm,
        guide_title_position = :left,
        colorkey_swatch_shape = :circle,
        minor_label_font = "Georgia",
        major_label_font = "Georgia",
    ),
)

draw(SVG("_includes/benchmarks.svg", 8inch, 8inch/golden), p)

