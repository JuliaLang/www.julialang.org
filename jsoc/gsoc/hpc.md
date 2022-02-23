
# High Performance and Parallel Computing Projects – Summer of Code

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.


**Difficulty:** Medium

## Scheduling algorithms for Distributed algorithms

Dagger.jl is a native Julia framework and scheduler for distributed execution of Julia code and general purpose data parallelism, using dynamic, runtime-generated task graphs which are flexible enough to describe multiple classes of parallel algorithms. This project proposes to implement different scheduling algorithms for Dagger to optimize scheduling of certain classes of distributed algorithms, such as MapReduce and MergeSort, and properly utilizing heterogeneous compute resources. Contributors will be expected to find published distributed scheduling algorithms and implement them on top of the Dagger framework, benchmarking scheduling performance on a variety of micro-benchmarks and real problems.

Mentors: [Julian Samaroo](https://github.com/jpsamaroo), [Valentin Churavy](https://github.com/vchuravy)

## Distributed Training

**Difficulty:** Hard (350h)

Add a distributed training API for Flux models built on top of [Dagger.jl](https://github.com/JuliaParallel/Dagger.jl). More detailed milestones include building Dagger.jl abstractions for [UCX.jl](https://github.com/JuliaParallel/UCX.jl), then building tools to map Flux models into data parallel Dagger DAGs. The final result should demonstrate a Flux model training with multiple devices in parallel via the Dagger.jl APIs. A stretch goal will include mapping operations with a model to a DAG to facilitate model parallelism as well.

There are projects now that host the building blocks: [DaggerFlux.jl](https://github.com/FluxML/DaggerFlux.jl) and [Distributed Data Parallel Training](https://github.com/DhairyaLGandhi/ResNetImageNet.jl) which can serve as jumping off points.

**Skills:** Familiarity with UCX, representing execution models as DAGs, Flux.jl, CUDA.jl and data/model parallelism in machine learning

**Mentors:** [Julian Samaroo](https://github.com/jpsamaroo), and [Dhairya Gandhi](https://github.com/DhairyaLGandhi)
