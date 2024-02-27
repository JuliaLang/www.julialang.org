# Graph Neural Networks - Summer of Code

Graph Neural Networks (GNN) are deep learning models well adapted to data that takes the form of graphs with feature vectors associated to nodes and edges.
GNNs are a growing area of research and find many applications in complex networks analysis, relational reasoning, combinatorial optimization, molecule generation, and many other fields. 

[GraphNeuralNetworks.jl](https://github.com/CarloLucibello/GraphNeuralNetworks.jl) is a pure Julia package for GNNs equipped with many features. It implements common graph convolutional layers, with CUDA support and graph batching for fast parallel operations. There are a number of ways by which the package could be improved.


### Training on very large graphs  

Graph containing several millions of nodes are too large for gpu memory. Mini-batch training is performed on subgraphs, as in the GraphSAGE algorithm.

**Duration**: 350h.  

**Expected difficulty**: hard.  

**Expected outcome**: The necessary algorithmic components to scale GNN training to very large graphs.


### Adding graph convolutional layers 

While we implement a good variety of graph convolutional layers, there is still a vast zoology to be implemented yet. Preprocessing tools, pooling operators, and other GNN-related functionalities can be considered as well.

**Duration**: 175h.

**Expected difficulty**: easy to medium.  

**Expected outcome**: Enrich the package with a variety of new layers and operators.

### Adding models and examples

As part of the documentation and for bootstrapping new projects, we want to add fully worked out examples and applications of graph neural networks. We can start
with entry-level tutorials and progressively introduce the reader to more advanced features. 

**Duration**: 175h.  

**Expected difficulty**: medium.  

**Expected outcome**: A few pedagogical and more advanced examples of graph neural networks applications.

### Adding graph datasets

Provide Julia friendly wrappers for common graph datasets in [`MLDatasets.jl`](https://github.com/JuliaML/MLDatasets.jl). Create convenient interfaces
for the Julia ML and data ecosystem. 

**Duration**: 175h.  

**Expected difficulty**: easy.  

**Expected outcome**: A large collection of graph datasets easily available to the Julia ecosystem.

### Implement layers for heterogeneous graphs

In some complex networks, the relations expressed by edges can be of different types. We currently support this
with the `GNNHeteroGraph` type but none of the current graph convolutional layers support heterogeneous graphs 
as inputs. With this project we will implement a few layers for heterographs.

**Duration**: 175h.  

**Expected difficulty**: medium.  

**Expected outcome**: The implementation of a new graph
type for heterogeneous networks and corresponding graph convolutional layers.


### Improving performance using sparse linear algebra 

Many graph convolutional layers can be expressed as non-materializing algebraic operations involving the adjacency matrix instead of the slower and more memory consuming gather/scatter mechanism. We aim at extending as far as possible and in a gpu-friendly way these *fused* implementation.

**Duration**: 350h.

**Expected difficulty**: hard.

**Expected outcome**: A noticeable performance increase
for many graph convolutional operations.


### Support for AMGDPU and Apple Silicon

We currently support scatter/gather operation only on CPU and CUDA hardware. We aim at extending this to AMDGPU and Apple Silicon
leveraging KernelAbstractions.jl, AMDGPU.jl and Metal.jl.

**Duration**: 175h.

**Expected difficulty**: medium.

**Expected outcome**: Graph convolution speedup for AMD GPU and Apple hardware, performance roughly on par with CUDA.

### Implement layers for Temporal Graphs
A temporal graph is a graph whose topology changes over time. We currently support this with the [TemporalSnapshotsGNNGraph](https://github.com/CarloLucibello/GraphNeuralNetworks.jl/blob/master/src/GNNGraphs/temporalsnapshotsgnngraph.jl) type, but none of the current graph convolution and pooling layers support temporal graphs as input. Currently, there are a few convolutional layers that take as input the special case of static graphs with temporal features. In this project, we will implement new layers that take temporal graphs as input, and we will create tutorials demonstrating how to use them.

**Duration**: 350h.
**Expected difficulty**: medium.
**Expected outcome**: Implementation of new convolutional layers for temporal graphs and example tutorials.


## Recommended skills

Familiarity with graph neural networks and Flux.jl.

## Mentors 
[Carlo Lucibello](https://github.com/CarloLucibello) (author of [GraphNeuralNetworks.jl](https://github.com/CarloLucibello/GraphNeuralNetworks.jl)).
Feel free to contact us on the [Julia Slack Workspace](https://Julialang.slack.com/) or by opening an issue in the GitHub repo.
