---
type: "article"
title: "Statistical Deviations from the Theoretical only-SBU Model to Estimate MCU rates in SRAMs"
journal: "IEEE Transactions on Nuclear Science"
authors:
- Francisco J Franco
- Juan Antonio Clemente
- Maud Baylac
- Solenne Rey
- Francesca Villa
- Hortensia Mecha
- Juan A Agapito
- Helmut Puchner
- Guillaume Hubert
- Raoul Velazco
year: "2017"
month: "August"
pages: "2152--2160"
doi: "10.1109/TNS.2017.2726938"
issn: "0018-9499"
packages:
  StatsBase.jl: https://github.com/JuliaStats/StatsBase.jl
---

This paper addresses a well-known problem that occurs when memories are exposed to
radiation: the determination if a bit flip is isolated or if it belongs to a multiple event. As it is
unusual to know the physical layout of the memory, this paper proposes to evaluate the
statistical properties of the sets of corrupted addresses and to compare the results with a
mathematical prediction model where all of the events are single bit upsets. A set of rules
easy to implement in common programming languages can be iteratively applied if
anomalies are observed, thus yielding a classification of errors quite closer to reality (more
than 80% accuracy in our experiments).
