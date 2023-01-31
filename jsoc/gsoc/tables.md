
# Tabular Data – Summer of Code

## Implement Flashfill in Julia 

**Difficulty**: Medium

**Duration**: 350 hours

*FlashFill* is mechanism for creating data manipulation pipelines using programming by example (PBE). As an example see this [implementation in Microsoft Excel](https://support.microsoft.com/en-us/office/using-flash-fill-in-excel-3f9bcf1e-db93-4890-94a0-1578341f73f7). We want a version of Flashfill that can work against Julia tabular data structures, such as DataFrames and Tables.jl. 

**Resources**:
@@tight-list
* A [presentation](https://www.microsoft.com/en-us/research/wp-content/uploads/2017/04/pldi16-tutorial.pptx) by Sumit Gulwani of Microsoft Research
* A [video](https://youtu.be/X1YXge3C8RI)
* [MSR Prose research group](https://www.microsoft.com/en-us/research/group/prose/)
* [Papers](https://www.microsoft.com/en-us/research/group/prose/#!publications)
@@

**Recommended Skills**: Compiler techniques, DSL generation, Program synthesis

**Expected Output**: A practical flashfill implementation that can be used on any tabular data structure in Julia

**Mentors**: [Avik Sengupta](https://github.com/aviks/)

## Parquet.jl enhancements

**Difficulty**: Medium

**Duration**: 175 hours 

[Apache Parquet](https://parquet.apache.org/) is a binary data format for tabular data. It has features for compression and memory-mapping of datasets on disk. A decent implementation of Parquet in Julia is likely to be highly performant. It will be useful as a standard format for distributing tabular data in a binary format. There exists a Parquet.jl package that has a Parquet reader and a writer. It currently conforms to the Julia Tabular file IO interface at a very basic level. It needs more work to add support for critical elements that would make Parquet.jl usable for fast large scale parallel data processing. Each of these goals can be targetted as a single, short duration (175 hrs) project. 
@@tight-list
* Lazy loading and support for out-of-core processing, with Arrow.jl and Tables.jl integration. Improved usability and performance of Parquet reader and writer for large files.
* Reading from and writing data on to cloud data stores, including support for partitioned data.
* Support for missing data types and encodings making the Julia implementation fully featured.
@@

**Resources:**
@@tight-list
* The [Parquet](https://parquet.apache.org/documentation/latest/) file format (also are many articles and talks on the Parquet storage format on the internet)
* [A tour of the data ecosystem in Julia](https://quinnj.home.blog/2019/07/21/a-tour-of-the-data-ecosystem-in-julia/)
* [Tables.jl](https://github.com/JuliaData/Tables.jl)
* [Arrow.jl](https://github.com/JuliaData/Arrow.jl)
@@

**Recommended skills:** Good knowledge of Julia language, Julia data stack and writing performant Julia code.

**Expected Results:** Depends on the specific projects we would agree on.

**Mentors:** [Tanmay Mohapatra](https://github.com/tanmaykm)

## DataFrames.jl join enhancements

**Difficulty**: Hard

**Duration**: 175 hours 

[DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) is one of the more popular implementations of tabular data type for Julia. One of the features it supports is data frame joining. However, more work is needed to improve this functionality. The specific targets for this project are (a final list of targets included in the scope of the project can be decided later).
@@tight-list
* improve performance and memory consumption of joins (related issues:
  [#3255](https://github.com/JuliaData/DataFrames.jl/issues/3255),
  [#3270](https://github.com/JuliaData/DataFrames.jl/issues/3270),
  [#2974](https://github.com/JuliaData/DataFrames.jl/issues/2974),
  [#2688](https://github.com/JuliaData/DataFrames.jl/issues/2688),
  [#2660](https://github.com/JuliaData/DataFrames.jl/issues/2660));
* implement `asofjoin` or similar "nearest matching" join (related issue: [#2738](https://github.com/JuliaData/DataFrames.jl/issues/2738));
* implement join merging one table into the other, i.e. updating existing columns (related issue: [#2243](https://github.com/JuliaData/DataFrames.jl/issues/2243));
* improve column naming in joins (related issue: [#2472](https://github.com/JuliaData/DataFrames.jl/issues/2472)).
@@

**Resources:**
@@tight-list
* Issues linked in the description
* [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl)
* [Tables.jl](https://github.com/JuliaData/Tables.jl)
* [DataAPI.jl](https://github.com/JuliaData/DataAPI.jl)
@@

**Recommended skills:** Good knowledge of Julia language, Julia data stack and writing performant multi-threaded Julia code. Experience with benchmarking code. Knowledge of join algorithms (as e.g. used in databases like [DuckDB](https://duckdb.org/) or other tabular data manipulation ecosystems e.g. [Polars](https://www.pola.rs/) or [data.table](https://github.com/Rdatatable/data.table)).

**Expected Results:** Depends on the specific projects we would agree on.

**Mentors:** [Bogumił Kamiński](https://github.com/bkamins)
