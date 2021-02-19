# GeoStats.jl - Summer of Code

[GeoStats.jl](https://github.com/JuliaEarth/GeoStats.jl) is an extensible framework for high-performance geostatistics in Julia.
It is a project that aims to redefine the way statistics is done with geospatial data (e.g. data on geographics maps, 3D meshes).

Project mentors: [Júlio Hoffimann](https://github.com/juliohm)

## New geostatistical clustering methods

Statistical clustering cannot be applied straightforwardly to geospatial data. Geospatial constraints require clusters to be
contiguous volumes in the map, something that is not taken into account by traditional methods (e.g. K-Means, Spectral Clustering).

The goal of this project is to implement a geospatial clustering method from the geostatistics literature using the GeoStats.jl API.

**Desired skills:** Statistics, Clustering, Graph Theory

**References:**
@@tight-list
- [A hierarchical clustering method for multivariate geostatistical data](https://www.sciencedirect.com/science/article/abs/pii/S2211675316300367)
- [Unsupervised classification of multivariate geostatistical data: Two algorithms](https://www.sciencedirect.com/science/article/pii/S0098300415001314)
- [A density-based spatial clustering algorithm considering both spatial proximity and attribute similarity](https://www.sciencedirect.com/science/article/pii/S0098300411004419)
@@

## New geostatistical simulation methods

Geostatistical simulation consists of generating multiple alternative realizations of geospatial data according to a given geospatial distribution.
The litetaure on simulation methods is vast, but a few of them are particularly useful.

The goal of this project is to implement geostatistical simulation method from the geostatistics literature using the GeoStats.jl API.

**Desired skills:** Geostatistics, Stochastics, HPC

**References:**
@tight-list
- [Conditional Simulation of Complex Geological Structures Using Multiple-Point Statistics](https://link.springer.com/article/10.1023/A:1014009426274)
- [The Direct Sampling method to perform multiple‐point geostatistical simulations](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2008WR007621)
@@

## Migrate from Plots.jl to Makie.jl recipes

The project currently relies on Plots.jl recipes to visualize geospatial data sets as well as many other objects defined in the framework.
However, very large data sets (e.g. 3D volumes) cannot be visualized easily. The Makie.jl project is a promissing alternative.

The goal of this project is to migrate all plot recipes from Plots.jl to Makie.jl.

**Desired skills:** Visualization, Plotting, Geometry, HPC, GPU

## How to get started?

Get familiar with the framework by reading the [documentation](https://juliaearth.github.io/GeoStats.jl/stable) and [tutorials](https://github.com/JuliaEarth/GeoStatsTutorials).

Please contact the project maintainers in [Gitter](https://gitter.im/JuliaEarth/GeoStats.jl) or [Zulip](https://julialang.zulipchat.com/#narrow/stream/276201-geostats.2Ejl).
