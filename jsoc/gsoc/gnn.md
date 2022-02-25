# Graph Neural Networks - Summer of Code

Graph neural networks (GNN) are deep learning models well adapated to data  given in the form of graphs and feature vectors associated to nodes and edges.
GNNs are a growing are of research and find many applications in complex networks analysis, relational reasoning, combinatorial optimization, molecule generation, and many other fields. 
[GraphNeuralNetworks.jl](https://github.com/CarloLucibello/GraphNeuralNetworks.jl) is a pure Julia package for GNNs equipped with features such as implementations of common graph convolutional layers, CUDA support and graph batching for fast parallel operations. There are a number of ways by which the package could be improved:

- **Adding graph convolutional layers (duration: 175h, expected difficulty: easy to medium):** While we implement a good variety of graph convolutional layers, there is still a vast zoology to be implemented yet.

- **Adding models and examples (duration: 175h, expected difficulty: medium):** As part of the documentation and for bootstrapping new projects, we want to add fully worked out examples and applications of graph neural networks.

- **Adding graph datasets (duration: 175h, expected difficulty: easy):** Provide julia friendly wrappers for common graph datasets in [`MLDatasets.jl`](https://github.com/JuliaML/MLDatasets.jl).

- **Supporting heterogeneous graphs (duration: 175h, expected difficulty: hard):** In some complex networks, the relations expressed by edges can be of different types. We need to implement an heteroeneous graph type and implement convolutional layers supporting them. 

- **Training on very large graphs (duration: 175h, expected difficulty: medium to hard):** Graph containing several milions of nodes are too large for gpu memory. Mini-batch training si performed on subgraphs, as in the GraphSAGE algorithm.

- **Supporting temporal graph neural networks (duration: 350h, expected difficulty: hard):** We aim at implementing temporal graph convolutions for time-varying graph and/or node features.

- **Improving perfomance using sparse linear algebra (duration: 175h, expected difficulty: medium to hard):**  Many graph convolutional layers can be expressed as non-materializing algebraic operations involving the adjacency matrix instead of the slower and more memory consuming gather/scatter mechanism. We aim at extending as far as possible and in a gpu-friendly way these *fused* implementation.

**Recommended skills:** Familiarity with graph neural networks and Flux.jl.

**Expected results:** New features added to the package along with tests and relevant documentation.

**Mentors:** [Carlo Lucibello](https://github.com/CarloLucibello) (author of [GraphNeuralNetworks.jl](https://github.com/CarloLucibello/GraphNeuralNetworks.jl)). For linear algebra, co-mentoring by [Will Kimmerer](https://github.com/Wimmerer) (lead developer of [SuiteSparseGraphBLAS.jl](https://github.com/JuliaSparse/SuiteSparseGraphBLAS.jl)).

**Contact:** Feel free to contact us on the [Julia Slack Workspace](https://julialang.slack.com/) or by opening an issue in the GitHub repo.
