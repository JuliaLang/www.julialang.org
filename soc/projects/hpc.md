---
layout: default
title:  HPC Projects – Summer of Code
---

# {{ page.title }}

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.

{% include toc.html %}

## Fixed-size arrays with SIMD support

Julia uses OpenBLAS for matrix algebra, but OpenBLAS is better suited for large matrices. For operations with small matrices and vectors, one can often obtain substantial speedups by implementing everything in Julia. At least two candidate implementations [already](https://github.com/twadleigh/ImmutableArrays.jl) [exist](https://github.com/JuliaLang/julia/issues/5857), with the first more thoroughly developed but the second (currently just a sketch) having some features that are attractive for inclusion in `Base`.

The project would be to flesh out operations with fixed-size arrays, and get them interoperating seamlessly with other types. It would be desirable implement operations for certain sizes using Julia's up-and-coming [SIMD support](https://github.com/JuliaLang/julia/pull/5355).

## Parallel graph development

The [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) package provides a fast, robust set of graph analysis tools. This project would implement additions to LightGraphs to support parallel computation for a subset of graph algorithms. Examples of algorithms that would benefit from adaptation to parallelism would include centrality measures and traversals.

**Expected Results**: creation of LightGraphs-based data structures and algorithms that take advantage of large-scale parallel computing environments.

**Mentorship Inquiries**: Drop by [LightGraphs.jl on Gitter](https://gitter.im/JuliaGraphs/LightGraphs.jl).

## Ensure that Julia runs smoothly on current large HPC systems

Julia employs several techniques that are novel in the field of high performance computing, such as just-in-time compiling, or first-class support of an interactive environment, or dynamically adding/removing worker processes. This clashes with the traditional ahead-of-time compiled programes running in batch mode. However, the advantages of Julia's approach are clear. This project explores how "typical" Julia programs can be run efficiently on current large scale systems such as, e.g. [Blue Waters](https://bluewaters.ncsa.illinois.edu) or [Cori](http://www.nersc.gov/users/computational-systems/cori/).

**Expected Results**: Run a large, parallel Julia application on a high-end HPC system

**Knowledge Prerequisites**: High-performance computing, MPI

## Simple persistent distributed storage

This project proposes to implement a very simple persistent storage mechanism for Julia variables so that data can be saved to and loaded from disk with a consistent interface that is agnostic of the underlying storage layer. Data will be tagged with a minimal amount of metadata by default to support type annotations, time-stamped versioning and other user-specifiable tags, not unlike the `git stash` mechanism for storing blobs. The underlying engine for persistent storage should be generic and interoperable with any reasonable choice of binary blob storage mechanism, e.g. MongoDB, ODBC, or HDFS. Of particular interest will be persistent storage for distributed objects such as `DArray`s, and making use of the underlying storage engine's mechanisms for data movement and redundant storage for such data.

## Dynamic distributed execution for data parallel tasks in Julia

Distributed computation frameworks like Hadoop/MapReduce have demonstrated the usefulness of an abstraction layer that takes care of low level concurrency concerns such as atomicity and fine-grained synchronization, thus allowing users to concentrate on task-level decomposition of extremely large problems such as massively distributed text processing. However, the tree-based scatter/gather design of MapReduce limits its usefulness for general purpose data parallelism, and in particular poses significant restrictions on the implementation of iterative algorithms.

This project proposal is to implement a native Julia framework for distributed execution for general purpose data parallelism, using dynamic, runtime-generated general task graphs which are flexible enough to describe multiple classes of parallel algorithms. Students will be expected to weave together native Julia parallelism constructs such as the `ClusterManager` for massively parallel execution, and automate the handling of data dependencies using native Julia `RemoteRefs` as remote data futures and handles. Students will also be encouraged to experiment with novel scheduling algorithms.
