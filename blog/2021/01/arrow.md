@def title = "Apache Arrow Support in Julia"
@def authors = "Jacob Quinn"
@def published = "26 January 2021"
@def rss_pubdate = Date(2021, 1, 26)
@def rss = """Apache Arrow Support in Julia"""

We're excited to announce official support for the Julia language in the [Apache Arrow]() project. Since the [1.0 release](https://arrow.apache.org/blog/2020/07/24/1.0.0-release/) of the arrow format last July (2020), there have been calls for support in Julia. While Julia supported the original [feather v1](https://github.com/JuliaData/Feather.jl) format very early on, support for the "upgraded" arrow format was delayed as the format matured.

[Initial support was merged](https://github.com/apache/arrow/pull/8547) into the Apache Arrow master branch last November, and iteration on the package API and bugfixes have continued at a fast pace since then. While most language implementations all live in the [apache/arrow monorepo](https://github.com/apache/arrow), initial work on the Julia package was done in the [JuliaData/Arrow.jl repo](https://github.com/JuliaData/Arrow.jl). The code is still being actively developed in the Arrow.jl repository, with snapshots merged "upstream" for major releases. Users can choose to install the official Apache Arrow Julia code, or follow the latest releases of the same codebase in the Arrow.jl repository.

The arrow format is a modern-day accumulation of a number of format innovations from the last 30 years. It stores actual data in binary representation, which allows avoiding costly serialization/deserializtaion computing when transfering data between processes or to disk and back. It stores important metadata about the data using the [google flatbuffers format](https://google.github.io/flatbuffers/), including column names, types, and other important metadata.

The Julia implementation of the arrow format is done in pure Julia. It provides Julia `AbstractVector` objects for referencing data that conforms to the Arrow standard.  This allows users to seamlessly interface Arrow formatted data with a great deal of existing Julia code. It also implements the [Tables.jl interface](https://tables.juliadata.org/stable/) for the `Arrow.Stream` and `Arrow.Table` objects, which allows seamless integration with a [growing number](https://github.com/JuliaData/Tables.jl/blob/master/INTEGRATIONS.md) of integrations, including: [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl), [JSONTables.jl](https://github.com/JuliaData/JSONTables.jl), [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl), [SQLite.jl](https://github.com/JuliaDatabases/SQLite.jl), [MySQL.jl](https://github.com/JuliaDatabases/MySQL.jl), [JDBC.jl](https://github.com/JuliaDatabases/JDBC.jl), [ODBC.jl](https://github.com/JuliaDatabases/ODBC.jl), [XLSX.jl](https://github.com/felipenoris/XLSX.jl), and many more.

The Julia implementation is also impressive in the amount of format coverage it already supports, including:

  * All primitive data types (including Decimal256)
  * All nested data types
  * Dictionary encodings, nested dictionaries, and messages
  * Extension types
  * Streaming, file, record batch, and replacement and isdelta dictionary messages

It currently doesn't include support for:
  * Tensors or sparse tensors
  * Flight RPC
  * C data interface

It also supports multithreaded reading/writing by default, memory compression/decompression, and strong support for partitioning data into record batches. For the latter, Arrow.jl supports the `Tables.partitions` interface when writing, which means it takes any data partitions of the input data and will write each partition as a separate record batch in the arrow format.

We're excited to see further progress of using arrow-formatted in Julia; as it stands, we belive the Julia implementation to be one of the easiest, yet powerful and flexible implementations for the arrow format. Being able to work interactively with arrow datasets to explore, integrate easily with so many other formats, and process the data as-is is a powerful tool for anyone working with data.

Checkout the [package documentation](https://arrow.juliadata.org/stable/) or [format documentation](https://arrow.apache.org/docs/index.html) if you're interested in learning more; and as always, feel free to swing by the [#data Slack channel](https://julialang.slack.com/messages/data/) with questions or to chat, or [start a new topic](https://discourse.julialang.org/c/domain/data/16) in the Data discourse domain. Happy arrowing!
