---
type: "article"
title: "MIToS.jl: mutual information tools for protein sequence analysis in the Julia language"
authors:
- Zea, Diego J.
- Anfossi, Diego
- Nielsen, Morten
- Marino-Buslje, Cristina
year: "2016"
journal: "Bioinformatics"
volume: "33"
number: "4"
pages: "564--565"
doi: "https://doi.org/10.1093/bioinformatics/btw646"
packages:
  MIToS.jl: https://github.com/diegozea/MIToS.jl
---
Motivation: MIToS is an environment for mutual information analysis and a framework for protein multiple sequence alignments (MSAs) and protein structures (PDB) management in Julia language. It integrates sequence and structural information through SIFTS, making Pfam MSAs analysis straightforward. MIToS streamlines the implementation of any measure calculated from residue contingency tables and its optimization and testing in terms of protein contact prediction. As an example, we implemented and tested a BLOSUM62-based pseudo-count strategy in mutual information analysis.

Availability and Implementation: The software is totally implemented in Julia and supported for Linux, OS X and Windows. It’s freely available on GitHub under MIT license: http://mitos.leloir.org.ar.
