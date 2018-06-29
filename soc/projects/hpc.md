---
layout: default
title:  HPC Projects – Summer of Code
---

# {{ page.title }}

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.

{% include toc.html %}

## Parallel graph development

The [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) package provides a fast, robust set of graph analysis tools. This project would implement additions to LightGraphs to support parallel computation for a subset of graph algorithms. Examples of algorithms that would benefit from adaptation to parallelism would include centrality measures and traversals.

**Expected Results**: creation of LightGraphs-based data structures and algorithms that take advantage of large-scale parallel computing environments.

**Mentorship Inquiries**: Drop by [LightGraphs.jl on Gitter](https://gitter.im/JuliaGraphs/LightGraphs.jl).

## Simple persistent distributed storage

This project proposes to implement a very simple persistent storage mechanism for Julia variables so that data can be saved to and loaded from disk with a consistent interface that is agnostic of the underlying storage layer. Data will be tagged with a minimal amount of metadata by default to support type annotations, time-stamped versioning and other user-specifiable tags, not unlike the `git stash` mechanism for storing blobs. The underlying engine for persistent storage should be generic and interoperable with any reasonable choice of binary blob storage mechanism, e.g. MongoDB, ODBC, or HDFS. Of particular interest will be persistent storage for distributed objects such as `DArray`s, and making use of the underlying storage engine's mechanisms for data movement and redundant storage for such data.

## Dynamic distributed execution for data parallel tasks in Julia

Distributed computation frameworks like Hadoop/MapReduce have demonstrated the usefulness of an abstraction layer that takes care of low level concurrency concerns such as atomicity and fine-grained synchronization, thus allowing users to concentrate on task-level decomposition of extremely large problems such as massively distributed text processing. However, the tree-based scatter/gather design of MapReduce limits its usefulness for general purpose data parallelism, and in particular poses significant restrictions on the implementation of iterative algorithms.

This project proposal is to implement a native Julia framework for distributed execution for general purpose data parallelism, using dynamic, runtime-generated general task graphs which are flexible enough to describe multiple classes of parallel algorithms. Students will be expected to weave together native Julia parallelism constructs such as the `ClusterManager` for massively parallel execution, and automate the handling of data dependencies using native Julia `RemoteRefs` as remote data futures and handles. Students will also be encouraged to experiment with novel scheduling algorithms.

## GPUArrays

### Integration with existing GPU libraries

In GPUArrays we don't want to reinvent the wheel and leverage the great power of CU/CL - BLAS ( or even CU/CL - FFT).
Fortunately, Julia's abstract array interface makes it fairly straightforward to integrate these libraries in a natural way, since Julia already has OpenBLAS deeply integrated in the base array abstraction.
We have a basic strategy laid out for the integration and can mentor someone who is willing to write the it!

### JIT compiling GPU Code

GPUArrays heavily relies on just in time compilation of high performance kernels on the arrays.
The foundation for this is already part of GPUArrays in form of a basic map/reduce/broadcast implementation, using a Transpiler and CUDAnative.
What we now need is a lot of tests, improvements to the compiler/transpiler, benchmarks and fine tuning the performance of our kernels.
Someone who is more experienced in writing GPU kernels is also welcome to enrich GPUArrays with the implementation of more advanced kernels, e.g.
tiled iterations, filtering primitives, moving windows, etc.

**Mentors**: Simon Danisch
