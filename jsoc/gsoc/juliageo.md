# JuliaGeo: Geospatial processing in Julia

The [JuliaGeo](https://github.com/JuliaGeo) collaboration 

### Spherical visualizations of geographic data with (Geo)Makie.jl

Mentors: [Anshul Singhvi (JuliaHub)](anshul.singhvi@juliahub.com), Milan Klöwer (Oxford)

Observations and simulations of the Earth produce vast amounts of data, complicating analysis. 
Efficient data analysis often includes visualization, either in early stages to inspect features 
in the data but also to produce publication-ready graphs and animations. 
Given the (approximately) spherical shape of Earth, visualization software ideally supports data 
and operations thereof in spherical coordinates. Some data may come in the form of point measurements 
or polygons and gridded data is represented through large sets of polygons (so-called grids) covering 
the sphere. 
Many different grids are used for various reasons and purposes: regular and unstructured, based on triangles, 
quadrilaterals or hexagons, some are equal-area others have two north poles, to give some examples. 
In Julia, the JuliaGeo organisation together with MakieOrg and GeoMakie cover already a lot of this functionality. 
But more needs to be done to allow for seamless visualisations of geographic data on the sphere.

Quite a bit of foundational work needs to be done for spherical visualizations to be seamless.  
Students will work on the GeoMakie.jl spherical axis, using the principles of spherical and Cartesian geometry 
to create a smooth, interactive globe viewer.  Work may include:
- Spherical horizon culling for map tiles in 3D space, a la Google Maps
- Switching from a three-dimensional globe to a two-dimensional projection (again, a la Google Maps or Mapbox)
- Implementing a Cartopy-style projection interface in Julia, including known projection boundary polygons
- Implementing a nice coordinate / geometry transformation composition interface to facilitate this, also like what Mapbox does.

Reach out to the mentors to learn more!

### Implementing new algorithms in GeometryOps.jl

[GeometryOps.jl](https://github.com/JuliaGeo/GeometryOps.jl) is a new framework for geometry processing on the plane and the sphere.
There are many algorithms that remain to be implemented (e.g. [concave hull], [line merging], [polygon validation]), and you could also 
propose an algorithm that you want to implement or improve!

Some other areas of interest are:
- Wrapping Google's `s2geometry` library in Julia, either by building a C API to s2geometry or s2geography, or by building a 
WrapIt.jl or CxxWrap.jl wrapper for s2. 
- Improving the operation interface for GeometryOps and creating a declarative (a la CoordinateTransformations.jl, 
  e.g. `(Segmentize(Spherical(), max_distance = 1000) * ConcaveHull(threshold) * Area())(geom)`, which can pre-allocate 
  and apply the required preparations at once, instead of piecemeal.
- Any other projects an interested student might want to pick up!
