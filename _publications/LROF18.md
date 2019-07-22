---
type: "inproceedings"
title: "An automatic deployment support for processing remote sensing data in the Cloud"
authors:
- André Lage-Freitas
- Raphael P. Ribeiro
- Naelson D. C. Oliveira
- Alejandro C. Frery
year: "2018"
pages: "2054-2057"
booktitle: "2018 IEEE International Geoscience and Remote Sensing Symposium (IGARSS)"
publisher: "IEEE"
doi: "10.1109/IGARSS.2018.8518964"
packages:
  Infra.jl: https://github.com/gsd-ufal/Infra.jl
---
Master/Worker distributed programming model enables huge remote sensing data processing by assigning tasks to Workers in which data is stored. Cloud computing features include the deployment of Workers by using virtualized technologies such as virtual machines and containers. These features allow programmers to configure, create, and start virtual resources for instance. In order to develop remote sensing applications by taking advantage of high-level programming languages (e.g., R, Matlab, and Julia), users have to manually address Cloud resource deployment.
This paper presents the design, implementation, and evaluation of the Infra.jl research prototype. Infra.jl takes advantage of Julia Master/Worker programming sim- plicity for providing automatic deployment of Julia Workers in the Cloud. The assessment of Infra.jl automatic deployment is only ~2.8 seconds in two different Azure Cloud data centers.
