---
layout: post
title: StructuredQueries.jl - A generic data manipulation framework
author: <a href="https://github.com/davidagold">David Gold</a>
---

This post describes my work conducted this summer at the [Julia Lab](http://julia.mit.edu/) to develop [StructuredQueries.jl](https://github.com/davidagold/StructuredQueries.jl/), a generic data manipulation framework for [Julia](http://julialang.org/).

Our initial vision for this work was much inspired by Hadley Wickham's [dplyr](https://github.com/hadley/dplyr) R package, which provides data manipulation verbs that are generic over in-memory R tabular data structures and SQL databases, and [DataFramesMeta](https://github.com/JuliaStats/DataFramesMeta.jl) (begun by [Tom Short](https://github.com/tshort)), which provides metaprogramming facilities for working with Julia `DataFrame`s.

While a generic querying interface is a worthwhile end in itself (and has been discussed [elsewhere](https://groups.google.com/d/topic/julia-dev/jL2FSL4EneE/discussion)), it may also be useful for solving problems specific to in-memory Julia tabular data structures. We will discuss how a query interface suggests solutions to two important problems facing the development of tabular data structures in Julia: the *column-indexing* and *nullable semantics* problems. So, the present post will describe both the progress of my work and also discuss a wider scope of issues concerning support for tabular data structures in Julia. I will provide some context for these issues; the reader should feel free to skip over any uninteresting details.

---

Recall that the primary shortcoming of [DataArrays.jl](https://travis-ci.org/JuliaStats/DataArrays.jl) is that it does not allow for type-inferable indexing. That is, the means by which missing values are represented in `DataArray`s -- i.e. with a token `NA::NAtype` object -- entails that the most specific return type inferable from `Base.getindex(df::DataArray{T}, i)` is `Union{T, NAtype}`. This means that until Julia's compiler can better handle small `Union` types, code that naively indexes into a `DataArray` will perform unnecessarily poorly.

[NullableArrays.jl](https://github.com/JuliaStats/NullableArrays.jl) [remedied](http://julialang.org/blog/2015/10/nullablearrays) this shortcoming by representing both missing and present values of type `T` as objects of type `Nullable{T}`. However, this solution has limitations in other respects. First, use of `NullableArray`s does nothing to support type inference in column-indexing of `DataFrame`s. That is, the return type of `Base.getindex(df::DataFrame, field::Symbol)` is not straightforwardly inferable, even if `DataFrame`s are built over `NullableArray`s. Call this first problem the *column-indexing problem*. Second, NullableArrays introduces certain difficulties centered around the `Nullable` type. Call this second problem the *nullable semantics problem*.

The column-indexing problem is [well-documented](http://www.johnmyleswhite.com/notebook/2015/11/28/why-julias-dataframes-are-still-slow/). To see the difficulty, consider the following function

```julia
function f(df::DataFrame)
    A = df[:A]
    x = zero(eltype(A))
    for i in eachindex(A)
        x += A[i]
    end
    return x
end
```

where `df[:A]` retrieves the column named `:A` from `df`. A user might reasonably expect the above to be idiomatic Julia: the work is written in a `for` loop that is wrapped inside a function. However, this code will not be (ahead-of-time) compiled to efficient machine instructions because the type of the object that `df[:A]` returns cannot be inferred during static analysis. This is because there is nothing the `DataFrame` type can do to communicate the `eltype`s of its columns to the compiler.

The nullable semantics problem is described throughout a dispersed series of GitHub issues (the interested reader can start [here](https://github.com/JuliaStats/NullableArrays.jl/issues/95) and [here](https://github.com/JuliaStats/NullableArrays.jl/pull/85)) (and [at least one](https://groups.google.com/d/topic/julia-dev/WD7-vQeweJE/discussion) mailing list post). To my knowledge, a self-contained treatment has not been given (I don't necessarily claim to be giving one now). The problem has two parts, which I'll call the "easy question" and the "hard question", respectively:

1. What should the semantics of `f(x::Nullable{T})` be given a definition of `f(x::T)`?

2. How should we implement these semantics in a sufficiently general and user-friendly way?

In most cases, the answer to the easy question is clear: `f(x::Nullable{T})` should return an empty `Nullable{U}` if `x` is null and `Nullable(f(x.value))` if `x` is not null. There is a question of how to choose the type parameter `U`, but a solution involving Julia's type inference facilities seems to be about right. (The discussion of [0.5-style comprehensions](https://github.com/JuliaLang/julia/pull/16622) and [one](https://github.com/JuliaLang/julia/issues/7258) or [two](https://github.com/JuliaLang/julia/pull/11034) discussions about the return type of `map` over an empty array, were all influential on this matter.) We will refer to these semantics as the *standard lifting semantics*. It is worth noting that there is at least one considerable alternative to standard lifting semantics, at least in the realm of binary operators on `Nullable{Bool}` arguments: [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic). But whether to use three-valued logic or standard lifting semantics is usually clear from the context of the program and the intention of the programmer.

On the other hand, the hard question is still unresolved. There are a number of possible solutions, and it's difficult to know how to weigh their costs and benefits.

We'll return to the column-indexing problem and the hard question of nullable semantics after we've described the present query interface. Before we dive in, I want to emphasize that this blog post is a status update, not a release notice (though StructuredQueries is registered so that you can play with it if you like). StructuredQueries (SQ) is a work in progress, and it will likely remain that way for some time. I hope to convince the reader that SQ nonetheless represents an interesting and worthwhile direction for the development of tabular data facilities in Julia.


## The query framework

The StructuredQueries package provides a framework for representing the *structure* of a query without assuming any specific corresponding *semantics*. By the structure of a query, we mean the series of particular manipulation verbs invoked and the respective arguments passed to these verbs. By the semantics of a query, we mean the actual behavior of executing a query with a particular structure against a particular data source. A query semantics thus depends both on the structure of the query and on the type of the data source against which the query is executed. We will refer to the implementation of a particular query semantics as a *collection machinery*.

Decoupling the representation of a query's structure from the collection machinery helps to make the present query framework

* generic -- the framework should be able to support multiple backends.
* modular -- the framework should encourage modularity of collection machinery.
* extensible -- the framework should be easily extensible to represent (relatively) arbitrary manipulations.

These desiderata are interrelated. For instance, modularity of collection machinery allows the latter to be re-used in support for different data backends, thereby supporting generality as well.

In this section we'll describe how SQ represents query structures. In the following sections we'll see how SQ's query representation framework suggests solutions to the column-indexing and nullable semantics problems described above.

To express a query in SQ, one uses the `@query` macro:

```julia
@query qry
```

where `qry` is Julia code that follows a certain structure that we will describe below. `qry` is parsed according to what we'll call a *query context*. By a *context* we mean a general semantics for Julia code that may differ from the semantics of the standard Julia environment. That is to say: though `qry` must be valid Julia syntax, the code is not run as it would were it executed outside of the `@query` macro. Rather, code such as `qry` that occurs inside of a query context is subject to a number of transformations before it is run. `@query` uses these transformations to produce a graphical representation of the structure of `qry`. An `@query qry` invocation returns a `Query` object, which wraps the query graph produced as a result of processing `qry`.

We said above that SQ represents queries in terms of their structure but does not itself guarantee any particular semantics. This allows packages to implement their own semantics for a given query structure. To demonstrate this design, I've put together (i) an [abstract tabular data type](https://github.com/davidagold/AbstractTables.jl), `AbstractTable`; (ii) an [interface](https://github.com/davidagold/AbstractTables.jl#column-indexable-interface) to support a collection machinery against what I call *column-indexable* types `T <: AbstractTable`; and (iii) a [concrete tabular data type](https://github.com/davidagold/TablesDemo.jl), `Table <: AbstractTable` that satisfies the column-indexable interface and therefore inherits a collection machinery to support SQ queries.

This following behavior mimics that which one would expect from querying against a `DataFrame`. The main reason for putting together a demonstration using `Table`s and not `DataFrame`s has to do with ease of experimentation. I can more easily modify the `AbstractTable`/`Table` types and interfaces more easily than I can the `DataFrame` type and interface. Indeed, this project has become just as much about designing an in-memory Julia tabular data type that is most compatible with a Julia query framework as it is about designing a query framework compatible with an in-memory Julia tabular data type. Fortunately, the implementation of backend support for `Table`s will be straightforward to port to support for `DataFrame`s once we decide where such support should live.

Let's dive into the query interface by considering examples using the iris data set. (Though the package TablesDemo.jl is intended solely as a demonstration, it is registered so that readers can easily install it with `Pkg.add("TablesDemo.jl")` and follow along.)

```julia
julia> iris = Table(CSV.Source(joinpath(Pkg.dir("Tables"), "csv/iris.csv")))
Tables.Table
│ Row │ sepal_length │ sepal_width │ petal_length │ petal_width │ species  │
├─────┼──────────────┼─────────────┼──────────────┼─────────────┼──────────┤
│ 1   │ 5.1          │ 3.5         │ 1.4          │ 0.2         │ "setosa" │
│ 2   │ 4.9          │ 3.0         │ 1.4          │ 0.2         │ "setosa" │
│ 3   │ 4.7          │ 3.2         │ 1.3          │ 0.2         │ "setosa" │
│ 4   │ 4.6          │ 3.1         │ 1.5          │ 0.2         │ "setosa" │
│ 5   │ 5.0          │ 3.6         │ 1.4          │ 0.2         │ "setosa" │
│ 6   │ 5.4          │ 3.9         │ 1.7          │ 0.4         │ "setosa" │
│ 7   │ 4.6          │ 3.4         │ 1.4          │ 0.3         │ "setosa" │
│ 8   │ 5.0          │ 3.4         │ 1.5          │ 0.2         │ "setosa" │
│ 9   │ 4.4          │ 2.9         │ 1.4          │ 0.2         │ "setosa" │
│ 10  │ 4.9          │ 3.1         │ 1.5          │ 0.1         │ "setosa" │
⋮
with 140 more rows.
```

We can then use `@query` to express a query against this data set -- say, filtering rows according to a condition on `sepal_length`:

```julia
julia> q = @query filter(iris, sepal_length > 5.0)
Query with Tables.Table source
```

This produces a `Query{S}` object, where `S` is the type of the data source

```julia
julia> typeof(q)
StructuredQueries.Query{Tables.Table}
```

The structure of the query passed to `@query` consists of a *manipulation verb* (e.g. `filter`) that in turn takes a *data source* (e.g. `iris`) for its first argument and any number of *query arguments* (e.g. `sepal_length > 5.0`) for its latter arguments. These are the three different "parts" of a query: (1) data sources (or just "sources"), (2) manipulation verbs (or just "verbs"), and (3) query arguments.

Each part of a query induces its own context in which code is evaluated. The most significant aspect of such contexts is name resolution. That is to say, names resolve differently depending on which part of a query they appear in and in what capacity they appear:

1. In a data source specification context -- e.g., as the first argument to a verb such as `filter` above -- names are evaluated in the enclosing scope of the `@query` invocation. Thus, `iris` in the query used to define `q` above refers precisely to the `Table` object to which the name is bound in the top level of `Main`.

2. Names of manipulation verbs are not resolved to objects but rather merely signal how to construct the graphical representation of the query. (Indeed, in what follows there is no such function `filter` that is ever invoked in the execution of a query involving a `filter` clause.)

3. Names of functions called within a query argument context, such as `>` in `sepal_length > 5.0` are evaluated in the enclosing scope of the `@query` invocation.

4. Names that appear as arguments to function calls within a query argument context, such as `sepal_length` in `sepal_length > 5.0` are not resolved to objects but are rather parsed as "attributes" of the data source (in this case, `iris`). When the data source is a tabular data structure, such attributes are taken to be column names, but such behavior is just a feature of a particular query semantics (see below in the section "Roadmap and open questions".) The attributes that are passed as arguments to a given function call in a query argument are stored as data in the graphical query representation.

One can pipe arguments to verbs inside an `@query` context. For instance, the `Query` above is equivalent to that produced by

```julia
@query iris |> filter(sepal_length > 5.0)
```

In this case, the first argument (`sepal_length > 5.0`) to the verb `filter` is not a data source specification (`iris`), which is instead the first argument to `|>`, but is rather a query argument (`sepal_length > 5.0`).

`Query` objects represent the structure of a query composed of the three building blocks above. To see how, lets take a look at the internals of a `Query`:

```julia
julia> fieldnames(q)
2-element Array{Symbol,1}:
 :source
 :graph
```

The first field, `:source`, just contains the data source specified in the query -- in this case, the `Table` object that was bound to the name `iris` when the query was specified. The second field, `:graph` contains a(n admittedly not very interesting) graphical representation of the query structure:

```julia
julia> q.graph
FilterNode
  arguments:
      1)  sepal_length > 5.0
  inputs:
      1)  DataNode
            source:  unset source
```

The `filter` verb from the original `qry` expression passed to `@query` is represented in the graph by a `FilterNode` object and that the data source is represented by a `DataNode` object. Both `FilterNode` and `DataNode` are leaf subtypes of the abstract `QueryNode` type. The `FilterNode` is connected to the `DataNode` via the `:input` field of the former. In general, these connections constitute directed acyclic graphs. We may refer to such graphs as `QueryNode` graphs or query graphs.

SQ currently recognizes the following verbs out of the box -- that is, it properly incorporates them into a `QueryNode` graph:

* `select`
* `filter`
* `groupby`
* `summarize`
* `orderby`
* `innerjoin` (or just `join`)
* `leftjoin`
* `outerjoin`
* `crossjoin`

One uses `collect(q::Query)` to materialize `q` as a concrete set results set -- hence the term "collection machinery". Note that the set of verbs that receive support from the column-indexable interface -- that is, the verbs that may be `collect`ed against a column-indexable data source -- currently only includes the first four: `select`, `filter`, `groupby`, and `summarize`. This is what such support currently looks like:

```julia
julia> q = @query iris |>
           filter(sepal_length > 5.0) |>
           groupby(species, log(petal_length) > .5) |>
           summarize(avg = mean(digamma(petal_width)))
Query with Tables.Table source

julia> q.graph
SummarizeNode
  arguments:
      1)  avg=mean(digamma(petal_width))
  inputs:
      1)  GroupbyNode
            arguments:
                1)  species
                2)  log(petal_length) > 0.5
            inputs:
                1)  FilterNode
                      arguments:
                          1)  sepal_length > 5.0
                      inputs:
                          1)  DataNode
                                source:  unset source


julia> collect(q)
Grouped Tables.Table
Groupings by:
    species
    log(petal_length) > 0.5 (with alias :pred_1)

Source: Tables.Table
│ Row │ species      │ pred_1 │ avg       │
├─────┼──────────────┼────────┼───────────┤
│ 1   │ "virginica"  │ true   │ 0.428644  │
│ 2   │ "setosa"     │ true   │ -3.17557  │
│ 3   │ "versicolor" │ true   │ -0.136551 │
│ 4   │ "setosa"     │ false  │ -4.7391   │
```

We hope to include support for the other verbs in the near future.

Again we emphasize that this collection machinery is provided by the AbstractTables package, not StructuredQueries. As we see above, the latter provides a framework for representing a query structure, whereas packages such as AbstractTables (i) decide what it means to execute a query with a particular structure against a particular backend, and (ii) provide the implementation of the behavior in (i).

We provide a convenience macro, `@collect(qry)`, which is equivalent to `collect(@query(qry))`, for when one wishes to query and collect in the same command:

```julia
julia> @collect iris |>
           filter(erf(petal_length) / petal_length > log(sepal_width) / 1.5) |>
           summarize(sum = sum(ifelse(rand() > .5, sin(petal_width), 0.0)))
Tables.Table
│ Row │ sum       │
├─────┼───────────┤
│ 1   │ 0.0998334 │
```

Again, note the patterns of name resolution: names of functions (e.g. `erf`) invoked within the context of a query argument are evaluated within the enclosing scope of the `@query` invocation, whereas names in the arguments of such functions (e.g. `petal_length`) are taken to be attributes of the data source (i.e., `iris`).

### Dummy sources

We saw above how there are three parts to a query structure: verbs, sources and query arguments. A `Query` object represents the verbs and query arguments together in the `QueryNode` graph and wraps the data source separately. This suggests that one ought to be able to generate query graphs using `@query` even if one does not specify a particular data source. One can do precisely this by using *dummy sources*, which are essentially placeholders that can be "filled in" with particular data sources later, when one calls `collect`. To indicate a source as a dummy source, simply prepend it with a `:`. For instance:

```julia
julia> q = @query select(:src, twice_sepal_length = 2 * sepal_length)
Query with dummy source src

julia> collect(q, src = iris)
Tables.Table
│ Row │ twice_sepal_length │
├─────┼────────────────────┤
│ 1   │ 10.2               │
│ 2   │ 9.8                │
│ 3   │ 9.4                │
│ 4   │ 9.2                │
│ 5   │ 10.0               │
│ 6   │ 10.8               │
│ 7   │ 9.2                │
│ 8   │ 10.0               │
│ 9   │ 8.8                │
│ 10  │ 9.8                │
⋮
with 140 more rows.
```

Whatever the name of the dummy source (minus the `:`) was in the query must be the key in the kwarg passed to `collect`. Otherwise, the method will fail:

```julia
julia> collect(q, tbl = iris)
ERROR: ArgumentError: Undefined source: tbl. Check spelling in query.
 in #collect#5(::Array{Any,1}, ::Function, ::StructuredQueries.Query{Symbol}) at /Users/David/.julia/v0.6/StructuredQueries/src/query/collect.jl:23
 in (::Base.#kw##collect)(::Array{Any,1}, ::Base.#collect, ::StructuredQueries.Query{Symbol}) at ./<missing>:0
```

## The two problems

Now that we've seen what the SQ query framework itself consists of, we can discuss how such a framework may help to solve the column-indexing and nullable semantics problems.

### Type-inferability

Recall that the column-indexing problem consists in the inability of type inference to detect the return type of

```julia
function f(df::DataFrame)
    A = df[:A]
    x = zero(eltype(A))
    for i in eachindex(A)
        x += A[i]
    end
    return x
end
```

What *would* make `f` above amenable to type inference is to pass `A = df[:A]` above to an inner function that executes the loop, for instance

```julia
f_inner(A)
    x = zero(eltype(A))
    for i in 1:length(A)
        x += A[i]
    end
    return x
end
```

As long as `f_inner` does not get inlined, type inference will run "at" the point at which the body of `f` calls `f_inner` and will have access to the `eltype` of `df[:A]`, since the latter is passed as an argument to `f_inner`.

This strategy of introducing a function barrier also works when one requires multiple columns. For instance, suppose I wanted to generate a new column `C` where `C[i] = g(A[i], B[i])`. The following solution is type-inferable since the type parameters of the zipped iterator `zip(A, B)` reflects the `eltype`s of `A` and `B`:

```julia
function f(g, df)
    A, B = df[:A], df[:B]
    C = similar(A)
    f_inner!(C, g, zip(A, B))
    return DataFrame(C = C)
end

function f_inner!(C, g, itr) # bang because mutates C
    for (a, b) in itr
        C[i] = g(a, b)
    end
    return C
end
```

In other words: If one intends to iterate over the rows of some subset of columns of a `DataFrame`, then at some point there must be a function barrier through which is passed an argument whose signature reflects the `eltype`s of the relevant columns.

The manipulation described above could be expressed for a column-indexable table (e.g. a `Table` object) as

```julia
@query select(tbl, C = A * B)
```

The [collection machinery](https://github.com/davidagold/AbstractTables.jl/tree/master/src/column_indexable/query) that supports this query against, say, a `Table` source essentially [follows](https://github.com/davidagold/AbstractTables.jl/blob/master/src/column_indexable/query/select.jl) the above pattern of `f` and `f_inner`. That is, an outer function passes a "scalar kernel" (here, `row -> row[1] * row[2]`) that reflects the structure of `A * B` and a "row iterator" (here `zip(tbl[:A], tbl[:B])`) to an inner function that computes the value of the scalar kernel applied to the "rows" returned by iterating over the row iterator. (Note that the argument to the scalar kernel is assumed to be a `Tuple` whose individual elements assume the positions of named attributes (such as `A` and `B`) in the body of the "value expression" (here `A * B`) from which the scalar kernel is generated).

The scalar kernel and the information about which column to extract from `tbl` and `zip` together are all stored in the `QueryNode` graph produced by `@query`. Much of the work in producing such a graph consists in extracting such information from the `qry` expression (here `select(tbl, C = A * B)`) and processing it to produce (i) a lambda that captures the form of the transformation (`A * B`), (ii) a `Symbol` that names the resultant column (`C`) and a `Vector{Symbol}` that lists the relevant argument column names (`[:A, :B]`) in the order they are encountered during the production of the lambda.

Note that these data (a scalar kernel and result and argument fields) are not necessary to generate SQL code from a raw query argument, say the `Expr` object `:( C = A * B )`. Thus, one might argue that it is somewhat wasteful to compute such data and store it in the `QueryNode` graph when one might be able to compute the data at run-time dispatch of `collect` on a `Query{S}` where `S` is a type that satisfies the column-indexable interface. This is a good point, but there are two considerations to account. The first is that computing the scalar kernel and extracting the result and argument fields from the query argument is probably not prohibitively expensive. The second is that generating the scalar kernel at run-time (i) involves use of `eval`, which is to be avoided, and (ii) may involve a lot of work to re-incorporate the module information of names appearing in expression to be `eval`'d into a scalar kernel. For now, it is easiest to generate scalar kernels at macroexpand-time and let them come along for the ride in the `QueryNode` graph even if the latter is to be collected against a data source (e.g. a SQL connection) that doesn't need such data.

The use of metaprogramming to circumvent type-inferability is not a new strategy. Indeed, it is the basis for the [DataFramesMeta](https://github.com/JuliaStats/DataFramesMeta.jl) manipulation framework. The interested reader is referred [here](https://github.com/JuliaStats/DataFrames.jl/issues/523#issuecomment-33908369) and [here](https://github.com/JuliaStats/DataFramesMeta.jl/issues/1) for more on the history and motivation for these endeavors.

### The hard question of nullable semantics

Recall the hard question of nullable semantics involves implementing a given lifting semantics -- that is, a given behavior for `f(x::Nullable{T})` given a defined method `f(x::T)`-- in a "general" way.

One solution -- perhaps the most obvious, and which I have [previously endorsed](https://github.com/JuliaStats/NullableArrays.jl/commit/e3d68ab2502e3e8c2e9e6b7c299f9078b9154e3e#diff-04c6e90faac2675aa89e2176d2eec7d8R140) -- involves defining the method `f(x::Nullable{T})` as something like

```julia
function f(x::Nullable{T})
    if isnull(x)
        return Nullable{U}()
    else
        return Nullable(f(x.value))
    end
end
```

with natural analogues for methods with n-ary arguments. This process is a bit cumbersome, but it would not be difficult to automate with a macro with which one could annotate the original definition `f(x::T)`. Call this approach the "method extension lifting" approach.

The method extension lifting approach is very flexible. However, it does face some difficulties. One must somehow decide which functions should be lifted in this manner, and it's not clear how this line (between lifted and non-lifted functions) ought to be drawn. And if one cannot edit the definition of a function then a macro is of no use; one must manually introduce the lifted variant.

There is a further problem. If one wants to support lifting over arguments with "mixed" signatures -- i.e. signatures in which some argument types are `Nullable` and some are not -- then one has either to extend the promotion machinery or to define methods for mixed signatures, e.g. `+{T}(x, y::Nullable{T})`. That may end up being a lot of methods. Even if their definition can be automated with metaprogramming, the compilation costs associated with method proliferation may be considerable (but I haven't tested this).

Finally, there is the problem described in [NullableArrays.jl#148](https://github.com/JuliaStats/NullableArrays.jl/issues/148#issuecomment-249335994). I won't repeat the entire argument here. The summary of this problem is: if one is going to rely on a minimal set of lifted operators to support generic lifting of user-defined functions, those user-defined functions essentially have to give up much of multiple dispatch.

The difficulties associated with method extension lifting are not insurmountable, but the solution -- namely, keeping a repository of lifted methods -- requires an undetermined amount of maintenance and coordination.

Another way to implement standard lifting semantics is by means of a higher-order function -- that is, on Julia 0.5 where higher-order functions are performant. Such a function -- call it `lift` -- might look like the following:

```julia
function lift(f, x)
    if hasvalue(x)
        return Nullable(f(x))
    else
        U = Core.Inference.return_type(f, (typeof(x),))
        return Nullable{U}()
    end
end
```

This definition can naturally be extended to methods with more than one argument. The primary advantage of this approach over method extension lifting is its generality: one needs only to define one (two, three) higher-order `lift` method to support lifting of all functions of one (two, *n*) argument(s), as opposed to having to define a lifted version for each such function. Note that as long as `hasvalue` has some generic fallback method for non-`Nullable` arguments, such `lift` functions cover both standard and mixed-signature lifting. (Ideally one would ensure that the code is optimized for when types are non-`Nullable`; in particular, one would ensure that the dead branch is removed -- cf. [julia#18484](https://github.com/JuliaLang/julia/pull/18484).) Call this approach the "higher-order lifting" approach.

So, with the higher-order lifting approach we might better avoid method proliferation and generality worries, which is nice. However, now we require users to invoke `lift` everywhere. In particular, to lift `f(g(x))` over a `Nullable` argument `x`, one needs to write `lift(f, lift(g, x))`. The least we could do in this case is provide an `@lift` macro that, say, traverses the AST of `f(g(x))` and replaces each function call `f(...)` by an invocation of `lift(f, ...)`. That might be reasonable, but it's still an artifact of implementation details of support for missing values, and ideally it would not be exposed to users.

Recall that the present query framework extracts the "value expression" of a query argument (for instance, `B * C` in the query argument `C = A * B`) and generates a lambda that mimics the former's structure (in this case, `row -> row[1] * row[2]`). A proposed modification (see [AbstractTables#2](https://github.com/davidagold/_AbstractTables.jl/issues/2)) to this process is to modify the AST of the value expression (`A * B`) by appropriately inserting calls to `lift`, e.g.

```julia
row -> lift(*, row[1], row[2])
```

While there is a [simpler way](https://github.com/davidagold/AbstractTables.jl/blob/2a7771ce865b961fa0e454508ce8b7aa6a85e1fd/src/column_indexable/query/select.jl#L43-L48) to achieve standard lifting semantics, this approach (which is currently employed by the column-indexing collection machinery) does not easily support non-standard lifting semantics such as three-valued logic.

The higher-order lifting approach is not without its own drawbacks. Most notably, non-standard lifting semantics, such as three-valued logic, are more difficult to implement and are subject to restrictions that do not apply to the method extension lifting approach. The details of this difficulty is the proper subject of another blog post. The summary of the problem is: higher-order lifting (via code transformation, such as within `@query`) can only give non-standard lifting semantics to methods called explicitly within the expression passed to `@query`. That is,

```julia
@query filter(tbl, A | B)
```

can be given, say, three-valued logic semantics via higher-order lifting, but

```julia
f(x, y) = x | y
@query filter(tbl, f(A, B))
```
cannot.

Which approach to solving the hard question of `Nullable` semantics is better? It really is not clear. Right now, the Julia statistics community is trying out both solutions. I am hopeful time and experimentation will yield new insights.

## SQL backends

Above we have seen (i) how the implementation of a generic querying interface suggested a solution to the column-indexing and the `Nullable` semantics problems and (ii) how these latter solutions may be implemented in a manner generic over so-called column-indexable in-memory Julia tabular data structures. But we haven't said anything about how the interface is generic over tables other than in-memory Julia objects. In particular, we desire that the above framework be applicable to SQL database connections as well.

[Yeesian Ng](https://github.com/yeesian), who provided invaluable feedback and ideas during the development of SQ, also began to develop such an extension in a package called [SQLQuery](https://github.com/yeesian/SQLQuery.jl/pull/2). We are working to further integrate it with StructuredQueries in  [SQLQuery.jl#2](https://github.com/yeesian/SQLQuery.jl/pull/2), and we encourage the reader to stay tuned for updates concerning this endeavor.


## Roadmap and open questions

There is a general roadmap available at  [structuredQueries.jl#19](https://github.com/davidagold/StructuredQueries.jl/issues/19). I'll briefly describe some of what I believe are the most pressing/interesting open questions.

Interpolation syntax and implementation are both significant open questions. Suppose I wish to refer to a name in the enclosing scope of an `@query` invocation. A straightforward syntax would be to prepend the interpolated variable with `$`, as in

```julia
c = .5
q = @query filter(tbl, A > $c)
```

How should this be implemented? For full generality, we would like to be able to "capture" `c` from the enclosing scope and store it `q`. One way to do so is to include `c` in the closure of a lambda `() -> c` that we store in `q`. However, there is the question of how to deal with [problems of type-inferability](https://github.com/davidagold/StructuredQueries.jl/issues/22#issuecomment-244995697). Solving this problem may either require or strongly suggest some sort of "parametrized queries" API by which one can designate a name inside of a query argument context a *parameter* that can then be bound after the `@query` invocation, e.g. specified as kwargs to `collect` or to a function like `bind!(q::Query[; kwargs...])`.

We are also still deciding what the general syntax within a query context should look like. A big part of this decision concerns how aliasing and related functionality ought to work. See [StructuredQueries.jl#21](https://github.com/davidagold/StructuredQueries.jl/issues/21) for more details. This issue is similar to that of interpolation syntax insofar as both involve name resolution within different query contexts (e.g. in a data source specification context vs. a query argument context).

Finally, extensibility of not only `collect` but also of the graph generation facilities is an important issue, of which we hope to say more in a later post.

## Related work

As mentioned above, [DataFramesMeta](https://github.com/JuliaStats/DataFramesMeta.jl) is a pioneering approach to enhancing tabular data support in Julia via metaprogramming. Another exciting (and slightly more mature than the presently discussed package) endeavor in the realm of generic data manipulation facilities support is [Query.jl](https://github.com/davidanthoff/Query.jl) by [David Anthoff](https://github.com/davidanthoff). Query.jl and SQ are very similar in their objectives, though different in important respects. A comparison of these packages is the proper topic of a separate blog post.

## Conclusion

The foregoing post has described a work in progress. Not just the StructuredQueries package, but also the Julia statistical ecosystem. Though it will likely take a while for this ecosystem to mature, the general trend I've observed over the past two years is encouraging. It's also worth noting that much of what is described above would have been difficult to conceive without developments of the Julia language. In particular, performant higher-order functions and type-inferable map have both allowed us to explore solutions that were previously made difficult by the amount of metaprogramming required to ensure type-inferability. It will be interesting to see what we can come up with given the improvements to Julia in 0.6 and beyond.

I'm very grateful to John Myles White for his guidance on this project, to Yeesian Ng at MIT for his collaboration, to Viral Shah and Alan Edelman for arranging this opportunity, and to many others at Julia Central and elsewhere for their help and insight.
