#
# Smaller errorbar plot of benchmark results with min, median and max of multiples vs C
#

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

langs=unique(benchmarks[:language]).data
#order = UTF8String["Julia", "Go", "Fortran", "Java", "Lua", "JavaScript", "Python", "R", "Matlab", "Mathematica", "Octave"]
#idxs = findat(langs, order)

medians,maxes,mins = map(g->by(benchmarks, [:language], f->g(f[:time]))[:x1].data, [median, maximum, minimum])

perm = sortperm(medians)

langs,medians, maxes, mins = map(x->x[perm], (langs, medians, maxes, mins))

p = plot(x = langs, y = medians, ymin = mins, ymax = maxes, Geom.point, Geom.errorbar,

Guide.xticks(orientation=:vertical),
Guide.xlabel(nothing),
Guide.ylabel("time multiple vs C", orientation=:vertical),
    Theme(
        default_point_size = 1mm,
        guide_title_position = :left,
        colorkey_swatch_shape = :circle
    ),
    Scale.y_log10)

draw(SVG("benchmark-preview.svg", 3.5inch, 3inch), p)
