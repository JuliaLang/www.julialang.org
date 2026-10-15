its1 = Iterators.filter(x->!(occursin("started", x) || occursin("failed", x)), eachline("vanilla-raw.txt"))
its2 = Iterators.filter(x->!(occursin("started", x) || occursin("failed", x)), eachline("rr-raw.txt"))

function timings(its)
    map(its) do e
        parts = split(e, '|')
        strip(split(parts[1],'(')[1]), parse(Float64, parts[2])
    end
end

vanilla = timings(its1)
rr = timings(its2)

using DataFrames, StatsBase, Statistics, Gadfly
df1 = rename(DataFrame(vanilla), 1=>:name, 2=>:time_vanilla)
df2 = rename(DataFrame(rr), 1=>:name, 2=>:time_rr)
df = join(df1, df2, on=:name)
df[:overhead] = map(df[:time_vanilla], df[:time_rr]) do v, r
    r == 0. && return 0.
    100 * (r/v - 1)
end
df = sort(df, cols=:overhead, rev=true)
part = Iterators.partition(1:size(df, 1), 60)

overhead_mean = mean(df[:overhead])
function plot_for_range(range)
    Gadfly.plot(df[range,:],
        yintercept=[0., overhead_mean], Geom.hline(color=["black", "black"]),
        Guide.xlabel(last(range) == size(df, 1) ? "Test name" : nothing), Guide.ylabel("Overhead (%)"),
        x=:name, y=:overhead, Geom.bar, Scale.y_continuous(minvalue=-100., maxvalue=700.),
        Theme(default_color="orange"))
end

vstack((plot_for_range(range) for range in part)...)
draw(SVG("overhead.svg", 20cm ,40cm), vstack((plot_for_range(range) for range in part)...))
