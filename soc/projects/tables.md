---
layout: insidepage
title:  Tabular Data – Summer of Code
---

# {{ page.title }}

## Parquet.jl enhancements

Efficient storage of tabular data is an important component of the data analysis story in the ecosystem. Julia has many options here -- JLD, JuliaDB’s built-in serialization, CSV.write. These either suffer from lack of performance or lack of standardization. Parquet is a format for efficient storage of tabular data used in the Hadoop world. It has compression techniques which reduce disk usage as well as speed up reads. A well-rounded Parquet implementation in Julia will solve the current issues with storage formats and let Julia interoperate with software from the Hadoop world.

Parquet.jl currently contains a reader for Parquet files. This project involves implementing the writer for Parquet files, as well as some enhancements to the reading functionality.

**Deliverables:**

_Reader enhancements:_

Read a file as a NamedTuple of vectors (using NamedTuples.jl on Julia 0.6). This is on similar lines, but different from the current cursor-based reader. Probably as an implementation of `AbstractBuilder` that returns NamedTuple of column vectors, combined with a new iterator/cursor that returns a bunch of records instead of individual records.

_Writer support:_

- Write a table (in the form of a NamedTuple of vectors) to disk.
  Note: we will use NamedTuple of vectors as a minimal table which can be converted back into DataFrames or IndexedTables
- Implement the compression features provided in the Parquet spec-
Optionally auto detect compression scheme based on the data.

**Mentors**: [Tanmay Mohapatra](https://github.com/tanmaykm)

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
