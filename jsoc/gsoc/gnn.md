# Graph Neural Networks - Summer of Code

Graph Neural Networks (GNN) are deep learning models well adapated to data that takes the form of graphs with feature vectors associated to nodes and edges.
GNNs are a growing area of research and find many applications in complex networks analysis, relational reasoning, combinatorial optimization, molecule generation, and many other fields. 

[GraphNeuralNetworks.jl](https://github.com/CarloLucibello/GraphNeuralNetworks.jl) is a pure Julia package for GNNs equipped with many features. It implements common graph convolutional layers, with CUDA support and graph batching for fast parallel operations. There are a number of ways by which the package could be improved.

### Adding graph convolutional layers 

While we implement a good variety of graph convolutional layers, there is still a vast zoology to be implemented yet. Preprocessing tools, pooling operators, and other gnn-related functionalities can be considered as well.

**Duration**: 175h.

**Expected difficulty**: easy to medium.  

**Expected outcome**: Enrich the package with a variety of new layers and operators.

### Adding models and examples

As part of the documentation and for bootstrapping new projects, we want to add fully worked out examples and applications of graph neural networks. We can start
with entry-level tutorials and progressively introduce to the read more advanced
functionalities. 

**Duration**: 175h.  

**Expected difficulty**: medium.  

**Expected outcome**: A few pedagogical and more advanced examples of graph neural networks applications.

### Adding graph datasets

Provide julia friendly wrappers for common graph datasets in [`MLDatasets.jl`](https://github.com/JuliaML/MLDatasets.jl). Create convenient interfaces
for the julia ML and data ecosystem. 

**Duration**: 175h.  

**Expected difficulty**: easy.  

**Expected outcome**: A large collection of graph datasets easily available to the julia ecosystem.

### Supporting heterogeneous graphs

In some complex networks, the relations expressed by edges can be of different types. We need to implement an heteroeneous graph type and define convolutional layers supporting it.

**Duration**: 350h.  

**Expected difficulty**: hard.  

**Expected outcome**: The implementation of a new graph
type for etherogeneuous networks and corresponding graph convolutional layers.

### Training on very large graphs  

Graph containing several milions of nodes are too large for gpu memory. Mini-batch training si performed on subgraphs, as in the GraphSAGE algorithm.

**Duration**: 175h.  

**Expected difficulty**: hard.  

**Expected outcome**: The necessary algorithmic components to scale GNN training to very large graphs.


### Supporting temporal graph neural networks

We aim at implementing temporal graph convolutions for time-varying graph and/or node features. The design of an efficient dynamical graph type is a crucial 
part of this project.

**Duration**: 350h. 

**Expected difficulty**: hard.

**Expected outcome**: A new dynamical graph type and 
corresponding convolutional layers.

### Improving perfomance using sparse linear algebra 

Many graph convolutional layers can be expressed as non-materializing algebraic operations involving the adjacency matrix instead of the slower and more memory consuming gather/scatter mechanism. We aim at extending as far as possible and in a gpu-friendly way these *fused* implementation.

**Duration**: 175h.

**Expected difficulty**: hard.

**Expected outcome**: A noticeable perfomance increase
for many graph convolutional operations.

## Recommended skills

Familiarity with graph neural networks and Flux.jl.

## Mentors 
[Carlo Lucibello](https://github.com/CarloLucibello) (author of [GraphNeuralNetworks.jl](https://github.com/CarloLucibello/GraphNeuralNetworks.jl)). For linear algebra, co-mentoring by [Will Kimmerer](https://github.com/Wimmerer) (lead developer of [SuiteSparseGraphBLAS.jl](https://github.com/JuliaSparse/SuiteSparseGraphBLAS.jl)).
Feel free to contact us on the [Julia Slack Workspace](https://julialang.slack.com/) or by opening an issue in the GitHub repo.
