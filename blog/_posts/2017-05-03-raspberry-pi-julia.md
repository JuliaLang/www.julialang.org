---
layout: post
title: Julia available in Raspbian on the Raspberry Pi
author: Viral B. Shah, Avik Sengupta, Simon Byrne
---

Recently, Julia was accepted into the [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) distribution for the [Raspberry Pi](https://raspberrypi.org). If you are running the latest Raspbian, all you need to do is `apt-get install julia`. Most of the common packages can be installed with Pkg, and [Jupyter](http://jupyter.org) can be installed using the usual [IJulia.jl](https://github.com/JuliaLang/IJulia.jl) instructions.

While Julia works on all the Pi variants, we recommend using the Pi 3.

The scripts to create the julia package for Raspbian are in the [julia-raspbian](https://github.com/JuliaBerry/julia-raspbian) repo in the [JuliaBerry](https://github.com/JuliaBerry) organization on GitHub.

We invite all our readers to submit blog posts here showing example Jupyter notebooks, JuliaBerry packages for the Raspberry Pi hardware, or other ARM Julia fun and games.
