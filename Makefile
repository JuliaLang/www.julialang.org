JULIAHOME=../julia-release

benchmarks: benchmarks.csv _includes/benchmarks.html
.PHONY: benchmarks

benchmarks.csv:
	cp $(JULIAHOME)/test/perf/micro/benchmarks.csv .

_includes/benchmarks.html:
	cp $(JULIAHOME)/test/perf/micro/benchmarks.html _includes

