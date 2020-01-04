---
type: article
title: Stochastic Simulation by Image Quilting of Process-based Geological Models
authors:
- Hoffimann, Júlio
- Scheidt, Céline
- Barfod, Adrian
- Caers, Jef
journal: Computers & Geosciences
publisher: Elsevier BV
volume: 106
pages: 18--32
issn: 0098-3004
doi: 10.1016/j.cageo.2017.05.012
year: 2017
month: May
packages:
  ImageQuilting.jl: https://github.com/juliohm/ImageQuilting.jl
---
Process-based modeling offers a way to represent realistic geological heterogeneity in subsurface models.
The main limitation lies in conditioning such models to data. Multiple-point geostatistics can use these
process-based models as training images and address the data conditioning problem. In this work, we further
develop image quilting as a method for 3D stochastic simulation capable of mimicking the realism of
process-based geological models with minimal modeling effort (i.e. parameter tuning) and at the same time
condition them to a variety of data. In particular, we develop a new probabilistic data aggregation method
for image quilting that bypasses traditional ad-hoc weighting of auxiliary variables. In addition, we propose
a novel criterion for template design in image quilting that generalizes the entropy plot for continuous
training images. The criterion is based on the new concept of voxel reuse--a stochastic and quilting-aware
function of the training image. We compare our proposed method with other established simulation methods on
a set of process-based training images of varying complexity, including a real-case example of stochastic
simulation of the buried-valley groundwater system in Denmark.
