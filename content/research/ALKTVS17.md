---
type: "inproceedings"
title: "Parallelizing Julia with a Non-Invasive DSL"
authors:
- Todd A. Anderson
- Hai Liu
- Lindsey Kuper
- Ehsan Totoni
- Jan Vitek
- Tatiana Shpeisman
year: "2017"
volume: "74"
pages: "4:1--4:29"
booktitle: "31st European Conference on Object-Oriented Programming (ECOOP 2017)"
editors:
- Peter Müller
series: "Leibniz International Proceedings in Informatics (LIPIcs)"
publisher: "Schloss Dagstuhl--Leibniz-Zentrum fuer Informatik"
address: "Dagstuhl, Germany"
doi: "10.4230/LIPIcs.ECOOP.2017.4"
packages:
  ParallelAccelerator.jl: https://github.com/IntelLabs/ParallelAccelerator.jl
---
Computational scientists often prototype software using productivity
languages that offer high-level programming abstractions. When higher
performance is needed, they are obliged to rewrite their code in a
lower-level efficiency language. Different solutions have been
proposed to address this trade-off between productivity and
efficiency. One promising approach is to create embedded
domain-specific languages that sacrifice generality for productivity
and performance, but practical experience with DSLs points to some
road blocks preventing widespread adoption. This paper proposes a
non-invasive domain-specific language that makes as few visible
changes to the host programming model as possible. We present ParallelAccelerator, a library and compiler for high-level, high-performance scientific
computing in Julia. ParallelAccelerator's programming model is aligned with existing
Julia programming idioms. Our compiler exposes the implicit
parallelism in high-level array-style programs and compiles them to
fast, parallel native code. Programs can also run in "library-only"
mode, letting users benefit from the full Julia environment and
libraries. Our results show encouraging performance improvements with very few changes to source code required. In particular, few to no additional type annotations are necessary.