---
layout: insidepage
title:  HPC Projects – Summer of Code
---

# {{ page.title }}

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.

{% include toc.html %}

## Simple persistent distributed storage

This project proposes to implement a very simple persistent storage mechanism for Julia variables so that data can be saved to and loaded from disk with a consistent interface that is agnostic of the underlying storage layer. Data will be tagged with a minimal amount of metadata by default to support type annotations, time-stamped versioning and other user-specifiable tags, not unlike the `git stash` mechanism for storing blobs. The underlying engine for persistent storage should be generic and interoperable with any reasonable choice of binary blob storage mechanism, e.g. MongoDB, ODBC, or HDFS. Of particular interest will be persistent storage for distributed objects such as `DArray`s, and making use of the underlying storage engine's mechanisms for data movement and redundant storage for such data.

## Dynamic distributed execution for data parallel tasks in Julia

Distributed computation frameworks like Hadoop/MapReduce have demonstrated the usefulness of an abstraction layer that takes care of low level concurrency concerns such as atomicity and fine-grained synchronization, thus allowing users to concentrate on task-level decomposition of extremely large problems such as massively distributed text processing. However, the tree-based scatter/gather design of MapReduce limits its usefulness for general purpose data parallelism, and in particular poses significant restrictions on the implementation of iterative algorithms.

This project proposal is to implement a native Julia framework for distributed execution for general purpose data parallelism, using dynamic, runtime-generated general task graphs which are flexible enough to describe multiple classes of parallel algorithms. Students will be expected to weave together native Julia parallelism constructs such as the `ClusterManager` for massively parallel execution, and automate the handling of data dependencies using native Julia `RemoteRefs` as remote data futures and handles. Students will also be encouraged to experiment with novel scheduling algorithms.


### MAGMA binding

[MAGMA](https://developer.nvidia.com/magma) is a collection of next generation linear algebra (LA) GPU accelerated libraries designed and implemented by the team that developed LAPACK and ScaLAPACK. Julia has already have the functionality to create such binding by simply calling its C API via `ccall`. By binding this to the JuliaGPU ecosystem, a lot applications could benefit it from it. What we need will
just be a few bindings in Julia like what's lying in [CuArrays.jl](https://github.com/JuliaGPU/CuArrays.jl), use [BinaryProvider.jl](https://github.com/JuliaPackaging/BinaryProvider.jl) to provide downloads, and some unit tests on JuliaGPU's CI.

**Mentors** [Roger-luo](https://github.com/Roger-luo), [Viral B. Shah](https://github.com/ViralBShah)
