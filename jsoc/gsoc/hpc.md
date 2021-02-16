
# High Performance and Parallel Computing Projects – Summer of Code

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.

## Simple persistent distributed storage

This project proposes to implement a very simple persistent storage mechanism for Julia variables so that data can be saved to and loaded from disk with a consistent interface that is agnostic of the underlying storage layer. Data will be tagged with a minimal amount of metadata by default to support type annotations, time-stamped versioning and other user-specifiable tags, not unlike the `git stash` mechanism for storing blobs. The underlying engine for persistent storage should be generic and interoperable with any reasonable choice of binary blob storage mechanism, e.g. MongoDB, ODBC, or HDFS. Of particular interest will be persistent storage for distributed objects such as `DArray`s, and making use of the underlying storage engine's mechanisms for data movement and redundant storage for such data.

## Scheduling algorithms for Distributed algorithms

Dagger.jl is a native Julia framework and scheduler for distributed execution of Julia code and general purpose data parallelism, using dynamic, runtime-generated task graphs which are flexible enough to describe multiple classes of parallel algorithms. This project proposes to implement different scheduling algorithms for Dagger to optimize scheduling of certain classes of distributed algorithms, such as MapReduce and MergeSort, and properly utilizing heterogeneous compute resources. Students will be expected to find published distributed scheduling algorithms and implement them on top of the Dagger framework, benchmarking scheduling performance on a variety of micro-benchmarks and real problems.

Mentors: [Julian Samaroo](https://github.com/jpsamaroo), [Valentin Churavy](https://github.com/vchuravy)

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

Add a distributed training API to Flux, possibly inspired by PyTorch's equivalent. Any distributed training algorithm could be used (ideally the foundations make it easy to experiment with different setups), though the easiest is likely to implement an MXNet-like parameter server. It should demonstrate training a Flux model with data distributed over multiple nodes, with benchmarks.

Mentors: [Valentin Churavy](https://github.com/vchuravy), [Tim Besard](https://github.com/maleadt), [Julian Samaroo](https://github.com/jpsamaroo)

## Sparse GPU and ML support

While Julia supports dense GPU arrays well via [CuArrays](https://github.com/JuliaGPU/CUSPARSE.jl), we lack up-to-date wrappers for sparse operations. This project would involve wrapping CUDA's sparse support, with [CUSPARSE.jl](https://github.com/JuliaGPU/CUSPARSE.jl) as a starting point, adding them to CuArrays.jl, and perhaps demonstrating their use via a sparse machine learning model.

