---
layout: single
title:  Tabular Data – Summer of Code
---

# {{< get_param title >}}

## Parquet.jl enhancements and JuliaDB

[Apache Parquet](https://parquet.apache.org/) is a binary data format for tabular data. It has features for compression and memory-mapping of datasets on disk. A decent implementation of Parquet in Julia is likely to be highly performant. It will be useful as a standard format for distributing tabular data in a binary format. JuliaDB (submodule [MemPool](https://github.com/JuliaComputing/MemPool.jl/blob/master/src/io.jl)) currently requires a binary format for efficient storage and data transfer, but right now resorts to a custom but fast implementation. Users are asked not to take it seriously because it breaks from release to release. Having a Parquet reader and writer will solve this problem by standardizing the format. Prior work includes [Parquet.jl](https://github.com/JuliaIO/Parquet.jl) which only has a Parquet reader. Having written a basic Parquet reader and writer, you will need to shift your focus to performance-oriented array types in JuliaDB: namely PooledArrays, and StringArrays (from WeakRefStrings.jl), StructArrays, and finally tables. You will also need to make sure that bits-types such as Dates, Rational numbers etc. are efficiently stored and memory-mapped on load. Then you will make Parquet the default format for loading, saving and (possibly) _communicating data between processes_ in JuliaDB. By doing this project you will learn about the performance engineering a distributed, out-of-core analytical database.

**Mentors:** [Shashi Gowda](https://github.com/shashi), [Tanmay Mohapatra](https://github.com/tanmaykm)

## GPU support in JuliaDB

JuliaDB is a distributed analytical database. It uses Julia’s multi-processing for parallelism at the moment. GPU implementations of some operations may allow relational algebra with low latency. In this project, you will be required to add basic GPU support in JuliaDB.

- Copy a table to GPU -- this may be as simple as converting every column into a CuArray or GPUArray
- `map`, `reduce` and `filter` operation -- apply simple functions on a large table that is on the GPU
  - Ensure that columnar storage format is made use of in the lower level code generated.
- The `groupby` and `join` operations may involve first implementing an efficient [`sortperm`](https://docs.julialang.org/en/v1/base/sort/#Base.sortperm) that utilize the GPU, or an efficient hash table on the GPU
- `groupby` kernel on GPU
- `join` kernel on GPU (stretch goal)

**Mentors**: [Shashi Gowda](https://shashi.github.io), [Mike Innes](http://mikeinnes.github.io/)

## A SQL backend for Query.jl

[Query.jl](https://github.com/davidanthoff/Query.jl) is designed to work
with multiple backends. This project would add a SQL backend, so that queries
that are formulated with the query commands in [Query.jl](https://github.com/davidanthoff/Query.jl)
get translated into an equivalent SQL query that can be run within a
SQL database engine. Both LINQ and dplyr support a similar feature set,
and this project would enable the same scenario for julia. There is also
a small academic literature on this topic that we need to understand and
incorporate.

**Recommended Skills**: Very strong database and SQL skills, previous
experience with compilers (this project is essentially a compiler that
translates a query AST into SQL) and a strong familiarity with the julia
data stack.

**Expected Results**: A new version of [Query.jl](https://github.com/davidanthoff/Query.jl)
that runs queries as SQL in a database.

**Mentors**: [David Anthoff](https://github.com/davidanthoff)

## Tabular file IO

The Queryverse has a large number of file IO packages: [CSVFiles.jl](https://github.com/davidanthoff/CSVFiles.jl),
[ExcelFiles.jl](https://github.com/davidanthoff/ExcelFiles.jl), [FeatherFiles.jl](https://github.com/davidanthoff/FeatherFiles.jl),
[StatFiles.jl](https://github.com/davidanthoff/StatFiles.jl), [ParquetFiles](https://github.com/davidanthoff/ParquetFiles.jl)
and [FstFiles.jl](https://github.com/davidanthoff/FstFiles.jl). This project
will a) do serious performance work across all of the existing packages and
b) add write capabilities  to a number of them.

**Recommended Skills**: Experience with file formats, writing performant
julia code.

**Expected Results**: Write capabilities across the packages listed above,
competitive performance for all the packages listed above.

**Mentors**: [David Anthoff](https://github.com/davidanthoff)
