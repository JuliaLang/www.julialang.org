# JuliaStats Projects – Summer of Code

[JuliaManifolds](https://github.com/JuliaManifolds) is an organization dedicated to providing packages relying on geometric methods for optimization and statistics in Julia.

## Multivariate data analysis

Implement multivariate data analysis methods based on matrix manifolds in Julia.

**Difficulty.** Moderate. **Duration.** 350 hours

### Description

Multivariate data analysis encompasses methods such as Principal Component Analysis, Factor Analysis, Linear Discriminant Analysis or Independent Component Analysis. Such methods have many variants designed for robustness, promoting coefficient sparsity or handling special characteristics of input data. These variants are often formulated as optimization problems on Stiefel, Grassmann, oblique or flag manifolds. The goal of the project is to provide a package conforming to a standard statistics APIs such as [StatsAPI.jl](https://github.com/JuliaStats/StatsAPI.jl) that implements selected variants of multivariate data analysis methods relying on advanced manifold optimization algorithms from [Manopt.jl](https://github.com/JuliaManifolds/Manopt.jl) and [Optim.jl](https://github.com/JuliaNLSolvers/Optim.jl).

**Mentors.** [Mateusz Baran](https://github.com/mateuszbaran), [Ronny Bergmann](https://github.com/kellertuer)

### Prerequisites

-   Must be fluent in at least one language for statistical computing, and 
    willing to learn Julia before the start of projects.
-   Basic familiarity with multivariate data analysis (PCA, LDA, ICA).
-   Basic knowledge of numerical optimization methods.

### Your contribution

Participants will:

-   Learn about past approaches and packages for multivariate data analysis, such as [MultivariateStats.jl](https://github.com/JuliaStats/MultivariateStats.jl).
-   Create a new, modern library for handling multivariate data analysis.
-   Analyze performance of different optimization methods in selected data analysis tasks.

### References

-   [Multivariate Data Analysis on Matrix Manifolds](https://link.springer.com/book/10.1007/978-3-030-76974-1)
