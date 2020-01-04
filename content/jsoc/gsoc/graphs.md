---
layout: single
title:  JuliaGraphs – Summer of Code
---

# {{< get_param title >}}

The JuliaGraphs ecosystem offers a set of abstractions and algorithms for various aspects of graph modeling and analysis.
[LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) is the central
package defining the types and essential algorithms.

{% include toc.html %}

**Mentorship Inquiries**: Drop by #graphs on Slack or [file a new issue on Github](https://github.com/JuliaGraphs/LightGraphs.jl/issues/new).

## Parallel graph development

The [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) package provides a fast, robust set of graph analysis tools. This project would implement additions to LightGraphs to support parallel computation for a subset of graph algorithms. Examples of algorithms that would benefit from adaptation to parallelism would include centrality measures and traversals.

**Expected Results**: creation of LightGraphs-based data structures and algorithms that take advantage of large-scale parallel computing environments.

## Planarity algorithms for LightGraphs.jl

At the moment, LightGraphs.jl lacks algorithms that deal with graph planarity and familiar concepts. A candidate should study the literature and implement some algorithms that deal with planarity. Potential things that could be done:
* Implementation of tests for planarity and outer planarity
* Calculating a planar embedding of a graph
* There are some graph problems that have a much faster solution when a graph is planar.

## GraphBLAS Implementation

[GraphBLAS](http://graphblas.org/index.php?title=Graph_BLAS_Forum) is a standard similar to BLAS for dealing with graphs. There also exists a reference implementation called [SuiteSparse:GraphBLAS](http://faculty.cse.tamu.edu/davis/suitesparse.html). It would be interesting to have a bridge from LightGraphs.jl to GraphBLAS, so we can compare the performance. A candidate should do the following:
* Get the GraphBLAS C API working from Julia and connect it to a GraphBLAS implementation.
* Implement the LightGraphs.jl interface using the GraphBLAS primitives.
* Overwrite LightGraphs methods with ones using GraphBLAS.
* Write benchmarks for comparing the GraphBlas and LightGraphs algorithms.

## Improvements for GraphPlots.jl

The [GraphPlots.jl](https://github.com/JuliaPlots/Plots.jl) package could use some improvements:
* The current layout algorithms are fairly standard, there might be some newer improvements in the literature.
* There are layout algorithms for special graphs, such as directed acyclic graphs and trees.
* Some graph algorithms are embarrassingly parallel, we should make use of that.
* Make the interface easier to use; this could also simply mean improving the documentation.

## Julia implementation of the BlossomV algorithm

[LightGraphsMatching.jl](https://github.com/JuliaGraphs/LightGraphsMatching.jl) currently depends on the external software [BlossomV](http://pub.ist.ac.at/~vnk/software.html). In the past we had some problems calling that software from Julia and in addition it has a problematic license. Therefore it would be useful if we had a native Julia implementation of this algorithm.
This is a rather advanced project. In addition to standard graph theory, a candidate should probably have some minor knowledge of linear programming and duality of linear programs.

## Development of a benchmark suite for LightGraphs.jl

LightGraphs.jl could use a set of benchmarks for measuring the performance of our algorithms and for spotting performance regressions in further updates. A candidate should do the following
* Create a set of benchmark algorithms that measure different aspects of LightGraphs.jl and cover different use cases.
* Find different graph classes for performing benchmarks, for example sparse/dense graphs and find some graphs that are a good approximation of the graphs that arise in typical datasets.
* Figure out how we could automatically run regression tests with these benchmarks when someone pushes a new PR to GitHub.
