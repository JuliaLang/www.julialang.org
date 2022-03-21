# Producing the Julia Microbenchmarks plot

# Load the required Julia packages
using Base.MathConstants
using CSV
using DataFrames
using Gadfly
using StatsBase

# Load benchmark data from file
benchmarks = CSV.read("benchmarks.csv", DataFrame; header=["language", "benchmark", "time"])

# Capitalize and decorate language names from datafile
dict = Dict("c"=>"C", "julia"=>"Julia", "lua"=>"LuaJIT", "fortran"=>"Fortran", "java"=>"Java",
    "javascript"=>"JavaScript", "matlab"=>"Matlab", "mathematica"=>"Mathematica",
    "python"=>"Python", "octave"=>"Octave", "r"=>"R", "rust"=>"Rust", "go"=>"Go");
benchmarks[!, :language] = [dict[lang] for lang in benchmarks[!, :language]]

# Normalize benchmark times by C times
ctime = benchmarks[benchmarks[!, :language].== "C", :]
benchmarks = innerjoin(benchmarks, ctime, on=:benchmark, makeunique=true)
select!(benchmarks, Not(:language_1))
rename!(benchmarks, :time_1 =>:ctime)
benchmarks[!, :normtime] = benchmarks[!, :time] ./ benchmarks[!, :ctime];

# Compute the geometric mean for each language
langs = [];
means = [];
priorities = [];
for lang in values(dict)
    data = benchmarks[benchmarks[!, :language].== lang, :]
    gmean = geomean(data[!, :normtime])
    push!(langs, lang)
    push!(means, gmean)
    if (lang == "C")
        push!(priorities, 1)
    elseif (lang == "Julia")
        push!(priorities, 2)
    else
        push!(priorities, 3)
    end
end

# Add the geometric means back into the benchmarks dataframe
langmean = DataFrame(language=langs, geomean = means, priority = priorities)
benchmarks = innerjoin(benchmarks, langmean, on=:language)

# Put C first, Julia second, and sort the rest by geometric mean
sort!(benchmarks, [:priority, :geomean]);
sort!(langmean,   [:priority, :geomean]);

p = plot(benchmarks,
    x = :language,
    y = :normtime,
    color = :benchmark,
    Scale.y_log10,
    Guide.ylabel(nothing),
    Guide.xlabel(nothing),
    Coord.Cartesian(xmin=1,xmax=13.3,ymin=-0.5,ymax=4.2),
    Theme(
        guide_title_position = :left,
        colorkey_swatch_shape = :circle,
        minor_label_font = "Georgia",
        major_label_font = "Georgia"
    ),
)
draw(SVG(8inch,8inch/golden), p)

draw(SVG("benchmarks.svg", 9inch, 9inch/golden), p)

# Show geometric means of microbenchmarks by language
langmean[:,1:2]
