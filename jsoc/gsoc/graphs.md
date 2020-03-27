@def mintoclevel = 2

# JuliaGraphs – Summer of Code

Thank you for your interest in supporting JuliaGraphs in the upcoming Summer of Code!

The JuliaGraphs ecosystem offers a set of abstractions and algorithms for various aspects of graph modeling and analysis.
[LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) is the central package defining the types and essential
algorithms.

\toc

**Mentorship Inquiries**: Drop by #graphs on Slack or [file a new issue on Github](https://github.com/JuliaGraphs/LightGraphs.jl/issues/new).

## Prerequisites
Prospective candidates should be familiar with most of the following concepts:
@@tight-list
- graph algorithms
- Julia programming and idiomatic code
- LightGraphs.jl and associated packages
@@

In addition, strong candidates will have a history of open source contributions. Candidates with a history of contributions to Julia and JuliaGraphs in particular will be afforded special consideration.

## Parallel graph development

The [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) package provides a fast, robust set of graph analysis tools. This project would implement additions to LightGraphs to further support parallel computation for a subset of graph algorithms. Examples of algorithms that would benefit from adaptation to parallelism would include centrality measures, decomposition, and traversals. Current work may be found in the `Experimental/Parallel` section of the codebase; prospective candidates are expected to have reviewed the existing code and should be prepared to offer improvements to this code as well as contribution of new code.

**Expected Results**: creation of LightGraphs-based data structures and algorithms that take advantage of large-scale parallel computing environments, using the new Julia threading model and/or existing multi-node computation functionality.


## Development of a benchmark suite for LightGraphs.jl

Contributors to core LightGraphs.jl code must demonstrate that their proposed changes do not impact the (memory/time) performance of existing algorithms. Typically, output from the BenchmarkTools.jl package is included as part of the pull request. An automated benchmarking suite would be preferable; this would allow us to evaluate performance as part of the automatic testing criteria such that performance regressions would result in an automatic failure of the test suite. Prospective candidates should be prepared to address the following aspects of a proposed benchmarking suite:

@@tight-list
* Creation of a set of benchmark algorithms that measure different aspects of LightGraphs.jl and cover different use cases
* Application of the suite to different graph classes for performing benchmarks (for example, graphs of various sizes and densities and graphs that are good approximations those that arise in typical datasets)
* Development of an approach to integrate automated regression tests into the existing GitHub PR process
@@

**Expected Results**: creation of a benchmark suite and automatic regression testing system as described above.

