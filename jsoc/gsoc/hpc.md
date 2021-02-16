
# High Performance and Parallel Computing Projects – Summer of Code

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.

## Simple persistent distributed storage

This project proposes to implement a very simple persistent storage mechanism for Julia variables so that data can be saved to and loaded from disk with a consistent interface that is agnostic of the underlying storage layer. Data will be tagged with a minimal amount of metadata by default to support type annotations, time-stamped versioning and other user-specifiable tags, not unlike the `git stash` mechanism for storing blobs. The underlying engine for persistent storage should be generic and interoperable with any reasonable choice of binary blob storage mechanism, e.g. MongoDB, ODBC, or HDFS. Of particular interest will be persistent storage for distributed objects such as `DArray`s, and making use of the underlying storage engine's mechanisms for data movement and redundant storage for such data.

## Dynamic distributed execution for data parallel tasks in Julia

Distributed computation frameworks like Hadoop/MapReduce have demonstrated the usefulness of an abstraction layer that takes care of low level concurrency concerns such as atomicity and fine-grained synchronization, thus allowing users to concentrate on task-level decomposition of extremely large problems such as massively distributed text processing. However, the tree-based scatter/gather design of MapReduce limits its usefulness for general purpose data parallelism, and in particular poses significant restrictions on the implementation of iterative algorithms.

This project proposal is to implement a native Julia framework for distributed execution for general purpose data parallelism, using dynamic, runtime-generated general task graphs which are flexible enough to describe multiple classes of parallel algorithms. Students will be expected to weave together native Julia parallelism constructs such as the `ClusterManager` for massively parallel execution, and automate the handling of data dependencies using native Julia `RemoteRefs` as remote data futures and handles. Students will also be encouraged to experiment with novel scheduling algorithms.

## Model Zoo on TPU

Julia has experimental support for executing code on TPUs (https://github.com/JuliaTPU/XLA.jl) TPUs enable training cutting edge machine learning models written using Flux. However, TPUs are not able to execute arbitrary code and thus often require individual attention to fix new patterns in XLA.jl or other packages. Additionally, the performance characteristics of the TPU hardware are quite unlike that of CPU or even GPU and models may thus require TPU-specific adjustments to achieve peak performance. Lastly, the speed of TPUs presents significant challenges to data input pipelines even at single-TPU levels of performance. Having a wide set of models available that are tuned for TPU will aid in finding common abstractions for models independent of hardware.

Mentors: [Keno Fischer](https://github.com/Keno)

## Scientific Integration Benchmarks

A benchmark suite would help us to keep Julia's performance for ML models in shape, as well as revealing opportunities for improvement. Like the model-zoo project, this would involve contributing standard models that exercise common ML use cases (images, text etc) and profiling them. The project could extend to include improving performance where possible, or creating a "benchmarking CI" like Julia's own [nanosoldier](https://github.com/JuliaCI/Nanosoldier.jl).

Mentors: [Dhairya Gandhi](https://github.com/dhairyagandhi96/), [Elliot Saba](https://github.com/staticfloat).

## Multi-GPU training

Implement and demonstrate multi-GPU parallelism. One route is to expose communication primitives from NVIDIA's [NCCL](https://developer.nvidia.com/nccl) library and use these to build tooling for model parallelism and distributed training. The project should demonstrate parallel training of a Flux model with benchmarks.

Mentors: [Valentin Churavy](https://github.com/vchuravy), [Tim Besard](https://github.com/maleadt)

## Distributed Training

**Difficulty:** Hard

Add a distributed training API for Flux models built on top of [Dagger.jl](https://github.com/JuliaParallel/Dagger.jl). More detailed milestones include building Dagger.jl abstractions for [UCX.jl](https://github.com/JuliaParallel/UCX.jl), then building tools to map Flux models into data parallel Dagger DAGs. The final result should demonstrate a Flux model training with multiple devices in parallel via the Dagger.jl APIs. A stretch goal will include mapping operations with a model to a DAG to facilitate model parallelism as well.

**Skills:** Familiarity with UCX, representing execution models as DAGs, Flux.jl, and data/model parallelism in machine learning

**Mentors:** [Kyle Daruwalla](https://github.com/darsnack) and [Julian Samaroo](https://github.com/jpsamaroo)

Mentors: [Valentin Churavy](https://github.com/vchuravy), [Tim Besard](https://github.com/maleadt), [Julian Samaroo](https://github.com/jpsamaroo)

## Sparse GPU and ML support

While Julia supports dense GPU arrays well via [CuArrays](https://github.com/JuliaGPU/CUSPARSE.jl), we lack up-to-date wrappers for sparse operations. This project would involve wrapping CUDA's sparse support, with [CUSPARSE.jl](https://github.com/JuliaGPU/CUSPARSE.jl) as a starting point, adding them to CuArrays.jl, and perhaps demonstrating their use via a sparse machine learning model.

