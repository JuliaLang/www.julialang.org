# DeepChem.jl development projects – Summer of Code

## Towards DeepChem.jl: Combining Machine Learning with Chemical Knowledge

We have been developing the AtomicGraphNets.jl package, which began modestly as a Julia port of [CGCNN](https://github.com/txie-93/cgcnn), but now has plans to expand to a variety of more advanced graph-based methods for state-of-the-art ML performance making predictions on atomic systems. In support of this package, we are also developing ChemistryFeaturization.jl, which contains functions for building and featurizing atomic graphs from a variety of standard input files. ChemistryFeaturization will eventually form the bedrock of a DeepChem.jl umbrella organization to host a Julia-based port of the popular [Deepchem](http://deepchem.io) Python package.

Some of the features we're excited about working on include:

@@tight-list
- smarter hyperparameter optimization for built-in model types, potentially making use of Hyperopt.jl or other existing optimization packages
- building tools to enable sensitivity analysis along values of various input features as well as testing the importance of including those features at all
- implementing [Path-Augmented Graph Transformer](https://arxiv.org/abs/1905.12712) layers
- allowing new types of graph features (e.g. edge features, user-defined features rather than only pulling from databases, etc.) and building network layers that can make use of these features
- building more physically-informed pooling operations
- Improving documentation, example sets, and building tutorials for both of these packages ([see cross-posting at Julia GSoD site](/jsoc/gsod/projects))
@@

**Recommended Skills**: Basic graph theory and linear algebra, some knowledge of chemistry

**Expected Results**: Contributions of new features in the eventual DeepChem.jl ecosystem

**Mentors**: [Rachel Kurchin](https://github.com/rkurchin)