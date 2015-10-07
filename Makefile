JULIAHOME=../julia-release

benchmarks: benchmarks.csv _includes/benchmarks.html _includes/benchmarks.svg
.PHONY: benchmarks

benchmarks.csv:
	cp $(JULIAHOME)/test/perf/micro/benchmarks.csv .

_includes/benchmarks.html:
	cp $(JULIAHOME)/test/perf/micro/benchmarks.html _includes

_includes/benchmarks.svg:
	julia benchmarks.jl

clean:
	rm benchmarks.csv _includes/benchmarks.html _includes/benchmarks.svg
