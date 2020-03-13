@def rss_pubdate = Date(2019, 2, 3)
@def rss = """ GSoC 2018 - Parallel Implementations of Graph Analysis Algorithms | This blog briefly summarises my GSoC 2018 project (Parallel Graph Development (https://summerofcode.withgoogle.com/archive/2018/projects/5193483178475520/)) and the results achieved. For a detailed description, please refer to my GSoC blog (https://sohamtamba.github.io/GSoC).... """
@def published = "3 February 2019"
@def title = "GSoC 2018 - Parallel Implementations of Graph Analysis Algorithms"
@def authors = """<a href="https://github.com/SohamTamba">Soham Tamba</a>"""  

This blog briefly summarises my GSoC 2018 project ([Parallel Graph Development](https://summerofcode.withgoogle.com/archive/2018/projects/5193483178475520/)) and the results achieved. For a detailed description, please refer to my [GSoC blog](https://sohamtamba.github.io/GSoC).

The project is spread over the [LightGraphs](https://github.com/JuliaGraphs/LightGraphs.jl) codebase. It involved:

1. Producing parallel implementations of crucial graph algorithms.
2. Improving sequential implementation of crucial graph algorithms in LightGraphs.
3. Implementing heuristics to obtain good solutions to crucial NP-Hard graph problems.

The benchmarks were conducted on a 64-bit linux machine using 4 cores.


~~~
<style>
table{
    border-collapse: collapse;
    border-spacing: 0;
    border:2px solid #ff0000;
}
th{
    border:2px solid #000000;
}
td{
    border:1px solid #000000;
}
</style>
~~~

### Benchmark Graph Datasets

No. | Graph | Vertices | Edges
:---: | :---------: | :------------: | :-----------------:
1 | Twitter Social Circles | 81,306 | 1,342,310
2 | Astro-Physics Collaboration | 17,903 | 197,031
3 | Facebook Social Circles | 4,039 | 88,234

The graphs were obtained from the [SNAPDatasets](https://github.com/JuliaGraphs/SNAPDatasets.jl) repository.


### Speed-up on parallelization with 4 cores

Algorithm | Twitter | Astro-Physics | Facebook
---------: | :------------: | :-----------------: | :-------:
Breadth-First Search | 1.92 | 2.59 | 1.54
PageRank | 1.77 | 1.54 | 1.65
Bellman Ford SSSP | - | - | 1.88
Floyd Warshall APSP | - | - | 1.27
Johnson APSP | - | -  |2.10
Randomized Heuristic | 1.88 | 1.70 | 1.66
Betweenness Centrality | - | - | 1.96
Closeness Centrality | - | - | 2.17
Stress Centrality | - | - | 1.66

### Speed-up on sequential optimization

Algorithm | Twitter | Astro-Physics | Facebook
---------: | :------------: | :-----------------: | :-------:
PageRank | 3.05 | 3.37 | 3.17
Dijkstra SSSP | 2.80 | 2.10 | 1.68
Prim MST | 7.65 | 4.25 | 4.05
Kruskal MST | 7.70 | 3.37 | 2.80

### Absolute runtime (in ms) of Bread-First Search

Algorithm | Twitter | Astro-Physics | Facebook
---------: | :------------: | :-----------------: | :-------:
Parallel | 7.07 | 1.20 | 0.26
Sequential | 13.63 | 3.11 | 0.41


## Get the code

This section lists the functionality implemented and a link to the corresponding branch in my [cloned LightGraphs repository](https://github.com/SohamTamba/LightGraphs.jl).

### Completed and merged

The following branches have been merged into LightGraphs master:

- [Parallel Breadth-First Search](https://github.com/SohamTamba/LightGraphs.jl/tree/Parallel_GDistances)
- [Kruskal MST](https://github.com/SohamTamba/LightGraphs.jl/tree/kruskal_sort_IDS)
- [Sequential/Parallel Johnson APSP](https://github.com/SohamTamba/LightGraphs.jl/tree/Soham/John_Shortest_Path)
- [Parallel Floyd Warshall APSP](https://github.com/SohamTamba/LightGraphs.jl/tree/Parallel_Floyd_Warshall)
- [Parallel Bellman Ford SSSP](https://github.com/SohamTamba/LightGraphs.jl/tree/Parallel_Bellman_Ford)
- [Parallel PageRank](https://github.com/SohamTamba/LightGraphs.jl/tree/Parallel_Page_Rank)
- [PageRank](https://github.com/SohamTamba/LightGraphs.jl/tree/Seq_PageRank)
- [Load-balanced Partitioning](https://github.com/SohamTamba/LightGraphs.jl/tree/Parallel_Page_Rank)
- [Prim MST](https://github.com/SohamTamba/LightGraphs.jl/tree/Prim_PQ)
- [Dijkstra SSSP I](https://github.com/SohamTamba/LightGraphs.jl/tree/Dijkstra_Performance_Docs)
- [Dijkstra SSSP II](https://github.com/SohamTamba/LightGraphs.jl/tree/Dijkstra_Allocations)
- [Greedy Heuristics](https://github.com/SohamTamba/LightGraphs.jl/tree/All_Greedy)
    1. Minimum Vertex Cover
    2. Minimum Dominating Set
    3. Maximum Independent Set
    4. Vertex Connectivity

- [Parallel Random Heuristics](https://github.com/SohamTamba/LightGraphs.jl/tree/genrate_reduce)
- [Karger Minimum Cut](https://github.com/SohamTamba/LightGraphs.jl/tree/Karger_min_cut)
- [Multi-threaded Centrality Measures](https://github.com/SohamTamba/LightGraphs.jl/tree/Threaded_Centrality)
    1. Betweeness Centrality
    2. Closeness Centrality
    3. Stress Centrality

###  Completed but not applicable

The following branches have not been merged into LightGraphs master as the functionality is not suitable to LightGraphs:

- [Minimum Steiner Tree](https://github.com/SohamTamba/LightGraphs.jl/tree/GSoC/SteinerTree)
- [Metric Travelling Salesman](https://github.com/SohamTamba/LightGraphs.jl/tree/GSoC/TravellingSalesman)

###  Requires Improvement

The following branches have not been merged into LightGraphs as the parallel implementations are slower than the sequential implementation:

- [Parallel Kruskal MST](https://github.com/SohamTamba/LightGraphs.jl/tree/Parallel_Kruskal)
- [Parallel Prim MST](https://github.com/SohamTamba/LightGraphs.jl/tree/BatchPriorityQueue_Parallel_Dijkstra_Prim)
- [Parallel Dijkstra SSSP](https://github.com/SohamTamba/LightGraphs.jl/tree/BatchPriorityQueue_Parallel_Dijkstra_Prim)

# Acknowledgements

I would like to thank my mentor, [Divyansh Srivastava](https://github.com/somil55) and LightGraphs co-owner, [Seth Bromberger](https://github.com/sbromberger) for reviewing my code and providing valuable advice during the summer. I would also like to thank [The Julia Project](/project/) and [NUMFocus](https://numfocus.org) for sponsoring my attendance to [JuliaCon 2018](https://juliacon.org/2018/).
