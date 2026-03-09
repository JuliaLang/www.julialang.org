# High Performance and Parallel Computing Projects – Summer of Code

Julia is emerging as a serious tool for technical computing and is ideally suited for the ever-growing needs of big data analytics. This set of proposed projects addresses specific areas for improvement in analytics algorithms and distributed data management.

## Out-of-Core Computing with Dagger.jl for Big Problems

**Difficulty:** Medium (175h)

Sometimes a problem fits in GPU memory - great! Sometimes the problem only fits in CPU memory, but you want to use the GPU - hmm, complicated but doable. What if the problem doesn’t fit in any kind of memory? This is the problem that “out-of-core” computing seeks to solve - how to fit a large dataset into small memory and run important computations on it. In this project, you’ll dive deep into how Dagger.jl handles data management on the CPU and GPU, and implement logic in Dagger’s scheduler to allow it to pace computations to ensure they don’t exceed GPU memory, keeping datasets resident on the CPU when not in use. Going further, you’ll extend this approach to allow loading datasets from disk (files) or the network (S3, etc.) and operating on portions of the dataset on the CPU and GPU. In the end, you’ll enable Dagger to run nearly any algorithm on datasets of any size with ease and with good performance.

**Skills:** Familiarity with CPU-GPU communication, dataset partitioning

**Mentors:** [Julian Samaroo](https://github.com/jpsamaroo), and [Felipe Tomé](https://github.com/fda-tome)

## Numerical Optimization-based Task Scheduler for Dagger.jl

**Difficulty:** Hard (350h)

Task scheduling is a complicated endeavor even when done statically, dynamism takes it to another dimension of complexity - memory pressure, resource utilization, communication density, HBM availability, and processor throughput are just some of variables that need to be taken into account. Knowing that, this project will provide you with the opportunity to tune and implement an MILP (Mixed Integer Linear Program) model that takes Dagger’s scheduler into a different realm of computational efficiency. This model will take measured or simulated metrics into account when scheduling tasks across heterogeneous resources or even a large computing cluster. Additionally, as optimizations become more computationally expensive, you will implement a metaheuristic approach to simplifying the model to maintain reasonable scheduling performance. 

**Skills:** Mathematical optimization, metaheuristics solutions, performance modeling.

**Mentors:** [Julian Samaroo](https://github.com/jpsamaroo), and [Przemysław Szufel](https://szufel.pl/)

## Metrics and Observability for the Dagger.jl Runtime

**Difficulty:** Medium (175h)

There is no possible way of solving a problem if you’re not aware of the cause and nature of it - that is where data collection comes in handy - from roofline models to simple time measurements, data analysis and visualization has been the performance engineer’s best friend from the beginning of the area until now. For this project, you will take stock of Dagger’s current set of collected metrics and identify those which are missing or overly non-specific. You will then devise and implement measurement and collection techniques to implement and refine these metrics, and implement storage and querying infrastructure to make their values observable. Finally, you will implement visualization and reporting tools that use these collected metrics to provide additional insight into Dagger’s performance on various algorithms to aid in performance tuning and scheduler development.

**Skills:** Broad understanding of parallel algorithm tuning, visualization.

**Mentors:** [Felipe Tomé](https://github.com/fda-tome), and [Julian Samaroo](https://github.com/jpsamaroo)

## Optimizing GPU scheduler in Dagger.jl with Multistreams

**Difficulty:** Hard (350h)

This project aims to explore and enhance GPU performance by integrating [Dagger.jl](https://github.com/JuliaParallel/Dagger.jl), Julia’s high-performance parallel computing framework, with GPU multistream capabilities. Dagger.jl enables task-based parallelism, allowing complex computations to be broken down into smaller, manageable tasks that can be efficiently scheduled across computing resources. By incorporating GPU multistreams, students will investigate how multiple streams can be used to overlap data transfers with kernel executions, enabling concurrent operations on the GPU. This overlapping reduces idle times, as data movement and computations occur simultaneously, thus maximizing GPU resource utilization. The project will focus on designing and implementing parallel workflows where independent tasks are executed concurrently, leveraging Dagger’s dynamic task scheduling and GPU’s ability to manage multiple streams effectively. Students will experiment with different workload patterns, measure performance improvements, and analyze the impact of multistream execution on throughput and latency. Through performance benchmarking and optimization, this project will provide hands-on experience in GPU programming, parallel algorithm design, and high-performance computing, equipping students with valuable skills for tackling real-world scientific and data-intensive applications.

There are projects now that host the building blocks: [DaggerGPU.jl](https://github.com/JuliaGPU/DaggerGPU.jl) and [Dagger.jl](https://github.com/JuliaParallel/Dagger.jl) which can serve as jumping off points.

**Skills:** Familiarity with GPU, representing execution models as DAGs, CUDA.jl

**Mentors:** [Julian Samaroo](https://github.com/jpsamaroo), and [Rabab Alomairy](https://github.com/Rabab53)

## Distributed Linear Algebra

**Difficulty:** Hard (350h)

Add distributed linear algebra capabilities to Dagger.jl. This project will involve building abstractions for distributed linear algebra operations, such as matrix multiplication, matrix factorizations, and different data distribution schemes (cyclic, block-cyclic, 2D, 3D). The student will build on top of Dagger.jl to enable distributed linear algebra operations across multiple devices. The final result should demonstrate a linear algebra operation running across multiple devices in parallel via the Dagger.jl APIs.

**Skills:** Familiarity with distributed computing, numerical linear algebra, Dagger.jl

**Mentors:** [Felipe Tomé](https://github.com/fda-tome), and [Rabab Alomairy](https://github.com/Rabab53)

## Dynamic Scheduling for Mixture of Experts using Dagger.jl

**Difficulty:** Hard (350h)

Dynamic scheduling for Mixture of Experts (MoE) in LLM faces significant challenges due to the irregular computation patterns induced by expert routing, leading to load imbalances, underutilization of compute resources, and high communication overhead. Each token in MoE is routed to only a subset of experts, causing varying batch sizes and unbalanced workload distribution across experts. The traditional static scheduling approach does not efficiently handle these dynamic task assignments. By using Dagger.jl, we can implement a more dynamic, task-based scheduling system that assigns tokens to experts based on real-time compute availability, ensuring a more balanced workload. Dagger’s asynchronous scheduling allows for efficient parallel execution by dynamically distributing the tasks across multiple devices or compute units, improving GPU utilization and reducing bottlenecks. Furthermore, optimizations such as load balancing algorithms, soft routing mechanisms, and fine-grained task prioritization could be applied to maximize resource utilization and minimize execution time. Solving these optimization problems will not only enhance performance but also improve scalability, making MoE models more efficient and suitable for large-scale deployments.

**Skills:** Familiarity with GPU, representing execution models as Flux.jl, DAGs, and CUDA.jl

**Mentors:** [Julian Samaroo](https://github.com/jpsamaroo), and [Rabab Alomairy](https://github.com/Rabab53)

## Distributed Training

**Difficulty:** Hard (350h)

Add a distributed training API for Flux models built on top of [Dagger.jl](https://github.com/JuliaParallel/Dagger.jl). More detailed milestones include building Dagger.jl abstractions for [UCX.jl](https://github.com/JuliaParallel/UCX.jl), then building tools to map Flux models into data parallel Dagger DAGs. The final result should demonstrate a Flux model training with multiple devices in parallel via the Dagger.jl APIs. A stretch goal will include mapping operations with a model to a DAG to facilitate model parallelism as well.

There are projects now that host the building blocks: [DaggerFlux.jl](https://github.com/FluxML/DaggerFlux.jl) and [Distributed Data Parallel Training](https://github.com/DhairyaLGandhi/ResNetImageNet.jl) which can serve as jumping off points.

**Skills:** Familiarity with UCX, representing execution models as DAGs, Flux.jl, CUDA.jl and data/model parallelism in machine learning

**Mentors:** [Julian Samaroo](https://github.com/jpsamaroo), and [Dhairya Gandhi](https://github.com/DhairyaLGandhi)

