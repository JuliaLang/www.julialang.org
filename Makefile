JULIAHOME=../julia-release

run:
	@echo "$(shell tput bold)Launching dockerized site at http://localhost:4000$(shell tput sgr0)"
	docker run --rm -v $(shell pwd):/srv/jekyll -v julialang_gems:/usr/lib/ruby/gems -it -p 4000:4000 jekyll/jekyll:pages jekyll serve --incremental

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

