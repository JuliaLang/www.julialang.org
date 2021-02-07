
# Tabular Data – Summer of Code

## Implement Flashfill in Julia 

**Difficulty**: Medium

*FlashFill* is mechanism for creating data manipulation pipelines using programming by example (PBE). As an example see this [implementation in Microsoft Excel](https://support.microsoft.com/en-us/office/using-flash-fill-in-excel-3f9bcf1e-db93-4890-94a0-1578341f73f7). We want a version of Flashfill that can work against Julia tabular data structures, such as DataFrames and Tables. 

**Resources**:
@@tight-list
* A [presentation](https://www.microsoft.com/en-us/research/wp-content/uploads/2017/04/pldi16-tutorial.pptx) by Sumit Gulwani of Microsoft Research
* A [video](https://youtu.be/X1YXge3C8RI)
* [MSR Prose research group](https://www.microsoft.com/en-us/research/group/prose/)
* [Papers](https://www.microsoft.com/en-us/research/group/prose/#!publications)
@@

**Recommended Skills**: Compiler techniques, DSL generation, Program synthesis

**Expected Output**: A practical flashfill implementation that can be used on any tablular data structure in Julia

**Mentors**: [Avik Sengupta](https://github.com/aviks/)

## Parquet.jl enhancements and JuliaDB

[Apache Parquet](https://parquet.apache.org/) is a binary data format for tabular data. It has features for compression and memory-mapping of datasets on disk. A decent implementation of Parquet in Julia is likely to be highly performant. It will be useful as a standard format for distributing tabular data in a binary format. JuliaDB (submodule [MemPool](https://github.com/JuliaComputing/MemPool.jl/blob/master/src/io.jl)) currently requires a binary format for efficient storage and data transfer, but right now resorts to a custom but fast implementation. Users are asked not to take it seriously because it breaks from release to release. Having a Parquet reader and writer will solve this problem by standardizing the format. Prior work includes [Parquet.jl](https://github.com/JuliaIO/Parquet.jl) which only has a Parquet reader. Having written a basic Parquet reader and writer, you will need to shift your focus to performance-oriented array types in JuliaDB: namely PooledArrays, and StringArrays (from WeakRefStrings.jl), StructArrays, and finally tables. You will also need to make sure that bits-types such as Dates, Rational numbers etc. are efficiently stored and memory-mapped on load. Then you will make Parquet the default format for loading, saving and (possibly) _communicating data between processes_ in JuliaDB. By doing this project you will learn about the performance engineering of a distributed, out-of-core analytical database.

**Mentors:** [Shashi Gowda](https://github.com/shashi), [Tanmay Mohapatra](https://github.com/tanmaykm)

## GPU support in JuliaDB

JuliaDB is a distributed analytical database. It uses Julia’s multi-processing for parallelism at the moment. GPU implementations of some operations may allow relational algebra with low latency. In this project, you will be required to add basic GPU support in JuliaDB.

@@tight-list
- Copy a table to GPU -- this may be as simple as converting every column into a CuArray or GPUArray
- `map`, `reduce` and `filter` operation -- apply simple functions on a large table that is on the GPU
  - Ensure that columnar storage format is made use of in the lower level code generated.
- The `groupby` and `join` operations may involve first implementing an efficient [`sortperm`](https://docs.julialang.org/en/v1/base/sort/#Base.sortperm) that utilize the GPU, or an efficient hash table on the GPU
- `groupby` kernel on GPU
- `join` kernel on GPU (stretch goal)
@@

**Mentors**: [Shashi Gowda](https://shashi.github.io), [Mike Innes](https://mikeinnes.github.io/)

## A columnar query processing and optimization backend for Query.jl

[Query.jl](https://github.com/queryverse/Query.jl) is designed to work
with multiple backends. This project would add a backend for columnar sources
that implements many of the optimizations that the database literature
on column oriented query processing has identified.

**Recommended Skills**: Very strong database design knowledge, familiarity
with the Julia data stack and excellent Julia knowledge.

**Expected Results**: A new backend for [Query.jl](https://github.com/queryverse/Query.jl)
that runs queries against columnar stores in an optimized way.

**Mentors**: [David Anthoff](https://github.com/davidanthoff)

## Tabular file IO

The Queryverse has a large number of file IO packages: [CSVFiles.jl](https://github.com/queryverse/CSVFiles.jl),
[ExcelFiles.jl](https://github.com/queryverse/ExcelFiles.jl), [FeatherFiles.jl](https://github.com/queryverse/FeatherFiles.jl),
[StatFiles.jl](https://github.com/queryverse/StatFiles.jl), [ParquetFiles](https://github.com/queryverse/ParquetFiles.jl)
and [FstFiles.jl](https://github.com/queryverse/FstFiles.jl). This project
will a) do serious performance work across all of the existing packages and
b) add write capabilities  to a number of them.

**Recommended Skills**: Experience with file formats, writing performant
julia code.

**Expected Results**: Write capabilities across the packages listed above,
competitive performance for all the packages listed above.

**Mentors**: [David Anthoff](https://github.com/davidanthoff)

