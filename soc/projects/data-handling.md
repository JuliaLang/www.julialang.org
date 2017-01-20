# Theme: Data Handling

## Standardized dataset packaging

Scientific and technical computing often makes use of publicly available datasets. Obtaining this data often involves digging through horrifically designed government websites. Julia has a robust package manager, so storing a dataset on Github and making it available through the package manager can be a convenient means of distribution (see [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl)). At the same time, many datasets are too large to store reasonably in a git repository.

This project proposal is to develop a new Julia package that will implement a standard means to write data packages to make large external datasets accessible by downloading to a local machine. When a data package is installed, it will automatically download the dataset it wraps, validate it, e.g. with stored checksums, and make that data available as a `DataFrame` or other Julia structure. In addition to a standard structure, the `Pkg.generate` function should be extended to generate data packages.

## Simple persistent distributed storage

This project proposes to implement a very simple persistent storage mechanism for Julia variables so that data can be saved to and loaded from disk with a consistent interface that is agnostic of the underlying storage layer. Data will be tagged with a minimal amount of metadata by default to support type annotations, time-stamped versioning and other user-specifiable tags, not unlike the `git stash` mechanism for storing blobs. The underlying engine for persistent storage should be generic and interoperable with any reasonable choice of binary blob storage mechanism, e.g. MongoDB, ODBC, or HDFS. Of particular interest will be persistent storage for distributed objects such as `DArray`s, and making use of the underlying storage engine's mechanisms for data movement and redundant storage for such data.

## Dynamic distributed execution for data parallel tasks in Julia

Distributed computation frameworks like Hadoop/MapReduce have demonstrated the usefulness of an abstraction layer that takes care of low level concurrency concerns such as atomicity and fine-grained synchronization, thus allowing users to concentrate on task-level decomposition of extremely large problems such as massively distributed text processing. However, the tree-based scatter/gather design of MapReduce limits its usefulness for general purpose data parallelism, and in particular poses significant restrictions on the implementation of iterative algorithms.

This project proposal is to implement a native Julia framework for distributed execution for general purpose data parallelism, using dynamic, runtime-generated general task graphs which are flexible enough to describe multiple classes of parallel algorithms. Students will be expected to weave together native Julia parallelism constructs such as the `ClusterManager` for massively parallel execution, and automate the handling of data dependencies using native Julia `RemoteRefs` as remote data futures and handles. Students will also be encouraged to experiment with novel scheduling algorithms.
