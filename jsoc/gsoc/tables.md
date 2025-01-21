
# Tabular Data – Summer of Code

## Parquet.jl enhancements

**Difficulty**: Medium

**Duration**: 175 hours

[Apache Parquet](https://parquet.apache.org/) is a binary data format for tabular data. It has features for compression and memory-mapping of datasets on disk. A decent implementation of Parquet in Julia is likely to be highly performant. It will be useful as a standard format for distributing tabular data in a binary format. There exists a Parquet.jl package that has a Parquet reader and a writer. It currently conforms to the Julia Tabular file IO interface at a very basic level. It needs more work to add support for critical elements that would make Parquet.jl usable for fast large scale parallel data processing. Each of these goals can be targeted as a single, short duration (175 hrs) project.
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
