@def rss_pubdate = Date(2016, 8, 22)
@def rss_description = """ Graft.jl - General purpose graph analytics for Julia | This blog post describes my work on Graft.jl (https://github.com/pranavtbhat/Graft.jl), a general purpose graph analysis package for Julia. For those unfamiliar with graph algorithms, a quick introduction (https://www.cl.cam.ac.uk/teaching/1011/PrincComm/slides/graph_theory_1-11.pdf) might help.... """
@def published = "22 August 2016"
@def title = "Graft.jl - General purpose graph analytics for Julia"
@def authors = """<a href="https://github.com/pranavtbhat">Pranav Thulasiram Bhat</a>"""
@def hascode = true


This blog post describes my work on [Graft.jl](https://github.com/pranavtbhat/Graft.jl), a general purpose graph analysis package for Julia. For those unfamiliar with graph algorithms, a quick [introduction](https://www.cl.cam.ac.uk/teaching/1011/PrincComm/slides/graph_theory_1-11.pdf) might help.

# Proposal

My proposal, titled [ParallelGraphs](https://github.com/pranavtbhat/Gsoc2016/blob/master/Proposal.md), was to develop a parallelized/distributed graph algorithms
library. However, in the first month or so, we decided to work towards a more general framework that supports data analysis on
networks (graphs with attributes defined on vertices and edges).
Our change in direction was mainly motivated by:

- The challenges associated with distributed graph computations. [This](https://www.frankmcsherry.org/graph/scalability/cost/2015/01/15/COST.html)
  blog post was an eye opener.
- Only very large graphs, of the order of terabytes or petabytes, require distributed execution. Most useful graphs can be analyzed on a single compute node.
- Multi-threading is under heavy development, and we decided to wait for the full multi-threaded programming model to be available.
- As we looked at public datasets, we felt that the ability to combine graph theoretic     analyses with real world data was the missing piece in Julia. [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) already provides fast implementations for most graph algorithms, so we decided to target graph data analysis.

The modified proposal could be summarized as the development of a package that supports:

* Vertex and edge metadata : Key value pairs for vertices and edges.
* Vertex labelling : Allow vertices to be referenced, externally, through arbitrary Julia types.
* SQL like queries for edge data and metadata.
* Compatibility with `LightGraphs`

# Graft
`ParallelGraphs` turned out to be a misnomer, since we were moving towards a more general purpose data analysis framework. So we chose the name `Graft`, a kind of abbreviation for Graph Toolkit. The following sections detail `Graft's` features:

## Vertex and Edge Metadata
Graphs are often representations of real world entities, and the relationships between them. Such entities (and their relationships), often have data attached to them.
While it is quite straightforward to store vertex data (a simple table will suffice), storing edges and their data is very tricky. The data should be structured on the
source and target vertices, should support random access and should be vectorized for queries.

At first we tried placing the edge data in a SparseMatrixCSC. This turned out to be a bad idea, because sparse matrices are designed for numeric storage.
A simpler solution is to store edge metadata in a DataFrame, and have a SparseMatrixCSC map edges onto indices for the DataFrame. This strategy needed a lot less
code, and the benchmarks were more promising. Mutations such as the addition or removal of vertices and edges become more complicated however.

## Vertex Labelling
Most graph libraries do not support vertex labelling. It can be very confusing to refer to a vertex by its (often long) integer identifier. It is also
computationally expensive to use non-integer labels in the implementation of the package (any such implementation would involve dictionaries). There is no reason, however,
for the user to have to use integer labels externally. Graft supports two modes of vertex labelling. By default, a vertex is identified by its internal identifier. A user
can assign labels of any arbitrary Julia type to identify vertices, overriding the internal identifiers. This strategy, we feel, makes a reasonable compromise between
user experience and performance.

If vertex labels were used in the internal implementation, the graph data structure would probably look like this:

```
Dict(
   "Alice" => Dict(
      "age" => 34,
      "occupation"  => "Doctor",
      "adjacencies" => Dict("Bob" => Dict("relationship" => "follow")))
   ),
   "Bob" => Dict(
      "age" => 36,
      "occupation"  => "Software Engineer",
      "adjacencies" => Dict("Charlie" => Dict("relationship" => "friend"))
   ),
   "Charlie" => Dict(
      "age" => 30,
      "occupation"  => "Lawyer",
      "adjacencies" => Dict("David" => Dict("relationship" => "follow"))
   ),
   "David" => Dict(
      "age" => 29,
      "occupation" => "Athlete",
      "adjacencies" => Dict("Alice" => Dict("relationship" => "friend"))
   )
)
```

Clearly, using labels internally is a very bad idea. Any sort of data access would set off multiple dictionary look-ups. Instead, if a bidirectional map
could be used to translate labels into vertex identifiers and back, the number of dictionary lookups could be reduced to one. The data would also be better structured for query processing.

```
# Label Map to resolve queries
LabelMap(
   # Forward map : labels to vertex identifiers
   Dict("Alice" => 1, "David" => 4, "Charlie" => 3, "Bob" => 2),

   # Reverse map : vertex identifiers to labels
   String["Alice", "Bob", "Charlie", "David"]
)

# Vertex DataFrame
4×2 DataFrames.DataFrame
│ Row │ age │ occupation          │
├─────┼─────┼─────────────────────┤
│ 1   │ 34  │ "Doctor"            │
│ 2   │ 36  │ "Software Engineer" │
│ 3   │ 30  │ "Lawyer"            │
│ 4   │ 29  │ "Athlete"           │

# SparseMatrixCSC : maps edges onto indices into Edge DataFrame
4×4 sparse matrix with 4 Int64 nonzero entries:
   [4, 1]  =  1
   [1, 2]  =  2
   [2, 3]  =  3
   [3, 4]  =  4

# Edge DataFrame
4×1 DataFrames.DataFrame
│ Row │ relationship │
├─────┼──────────────┤
│ 1   │ "follow"     │
│ 2   │ "friend"     │
│ 3   │ "follow"     │
│ 4   │ "friend"     │
```

## SQL Like Queries
Graft's query notation is borrowed from [Jplyr](https://github.com/davidagold/jplyr.jl). The `@query` macro is used to simplify the query syntax, and
accepts a pipeline of abstractions separated by the pipe operator `|>`. The stages are described through abstractions:

### eachvertex
Accepts an expression, that is run over every vertex. Vertex properties can be expressed using the dot notation. Some reserved properties are `v.id`, `v.label`,
`v.adj`, `v.indegree` and `v.outdegree`.
Examples:

    # Check if the user has overridden the default labels
    julia> @query(g |> eachvertex(v.id == v.label)) |> all

    # Kirchoff's law :P
    julia> @query(g |> eachvertex(v.outdegree - v.indegree)) .== 0


### eachedge
Accepts an expression, that is run over every edge. The symbol `s` is used to denote
the source vertex, and `t` is used to denote the target vertex in the edge. The symbol `e` is used to denote
the edge itself. Edge properties can be expressed through the dot notation. Some reserved properties are `e.source`, `e.target`, `e.mutualcount`, and `e.mutual`.
Examples:

    # Arithmetic expression on edge, source and target properties
    julia> @query g |> eachedge(e.p1 - s.p1 - t.p1)


    # Check if constituent vertices have the same outdegree
    julia> @query g |> eachedge(s.outdegree == t.outdegree)


    # Count the number of "mutual friends" between the source and target vertices in each edge
    julia> @query g |> eachedge(e.mutualcount)


### filter
Accepts vertex or edge expressions and computes subgraphs with a subset of vertices, or a
subset of edges, or both.
Examples:

    # Remove vertices where property p1 equals property p2
    @query g |> filter(v.p1 != v.p2)

    # Remove self loops from the graph
    @query g |> filter(e.source != e.target)


### select
Returns a subgraph with a subset of vertex properties, or a subset of edge properties or both.
Examples:

    # Preserve vertex properties p1, p2 and nothing else
    @query g |> select(v.p1, v.p2)

    # Preserve vertex property p1 and edge property p2
    @query g |> select(v.p1, e.p2)


# Demonstration

The typical workflow we hope to support with `Graft` is:

- Load a graph from memory
- Use the query abstractions to construct new vertex/edge properties or obtain subgraphs.
- Run complex queries on the subgraphs, or export data to `LightGraphs` and run computationally expensive algorithms there.
- Bring the data back into `Graft` as a new property, or use it to modify the graphs structure.

The following examples should demonstrate this workflow:

* [Google+](https://github.com/pranavtbhat/Graft.jl/blob/master/examples/google%2B.ipynb): This demo uses a real, somewhat large, dataset with plenty of text data.
* [Baseball Players](https://github.com/pranavtbhat/Graft.jl/blob/master/examples/baseball.ipynb): Two separate datasets spliced together, a table on baseball players
and a trust network. The resulting data is quite absurd, but does a good job of showing the quantitative queries Graft can run.


# Future Work

- Graph IO : Support more graph file formats.
- Improve the query interface: The current pipelined macro based syntax has a learning curve, and the macro itself does some eval at runtime. We would like to move towards a cleaner composable syntax, that will pass off as regular Julia commands.
- New abstractions, such as Group-by, sort, and table output.
- Database backends : A RDBMS can be used instead of the DataFrames. Or Graft can serve as a wrapper on a GraphDB such as Neo4j.
- Integration with ComputeFramework for out of core processing. Support for parallelized IO, traversals and queries.

More information can be found [here](https://github.com/pranavtbhat/Graft.jl/issues)

# Acknowledgements

This work was carried out as part of the Google Summer of Code program, under the guidance of mentors: [Viral B Shah](https://github.com/viralbshah) and [Shashi Gowda](https://github.com/shashi).
