---
layout: default
title:  The Julia Project
---

The Julia Project as a whole is about bringing usable, scalable
technical computing to a greater audience: allowing scientists and
researchers to use computation more rapidly and effectively; letting
businesses do harder and more interesting analyses more easily and
cheaply.  Part of that project entails creating a free, open-source
language that is as easy to use as possible, so that researchers who
are not necessarily professional programmers can easily create and
share programs that others will be able to use for free and improve
upon.  However, a large part of the project is also about creating an
ecosystem in which such openness and sharing can take place.

Some project ideas for those participating in GSoC 2012:

1. Integrate the polyhedral optimizations provided by polly
(http://polly.llvm.org) into the julia compiler.

2. Make LLVM's GPU and auto-vectorization capabilities available in julia.

3. Build a social web-based REPL for julia
(http://julialang.org/images/web_repl.png). We imagine social
computing:

   a. Login using a Google/Facebook ID 
   b. Share sessions in real-time with friends and collaborators
   c. Interactive exploration of datasets
   d. Chat with collaborators as you compute

4. Develop the preliminary parallel processing capabilities of julia,
and integrate with services such as EC2, App Engine for on demand
deployment of large compute jobs. 
(http://julialang.org/manual/parallel-computing/)

5. Develop a 2d/3d graphics engine for julia (either web-based or local).

6. Extend julia to include core capabilities for statistical programming along the lines of R (https://github.com/JuliaLang/julia/wiki/Statistical-Programming)

7. Develop a library for the domain of your interest for julia (eg. machine learning, linear and non-linear optimization, signal processing, etc.). In fact, julia needs a large library of mathematical functions that are catalogued here (https://docs.google.com/spreadsheet/ccc?key=0AkrXlkvSbIfhdGJFbTNMRzlqVzRMZXV2Y2ozLUQ4N2c).