---
layout: default
title:  Julia Community
---

# Download and install Julia on various Operating Systems

Download location: [http://code.google.com/p/julialang/downloads/list](http://code.google.com/p/julialang/downloads/list).

If the provided download files do not work for you, please [file an issue](https://github.com/JuliaLang/julia/issues). You may also consider [building from source](https://github.com/JuliaLang/julia).

## Windows

Currently, Julia is available only for 32-bit Windows.

1. Download the Windows zip file (Make sure you get the version with Git included).
2. Unzip the downloaded file.
3. Double-click julia.bat in the unzipped folder to start julia.

## OS X

On Mac, a Julia-version.dmg file is provided, which contains Julia.app. Installation is the same as any other Mac software. You need OS X Lion (10.7) or later to use the precompiled binaries. Julia works with OS X Snow Leopard (10.6), but needs to be built from source.

## Linux

Instructions will be added here as more linux distributions start including julia. If your Linux distribution is not listed here, you should still be able to run julia by building from source.

1. [Ubuntu 13.04](http://packages.ubuntu.com/raring/julia): apt-get install julia

# Add graphics capabilities to Julia

Graphics in Julia are available through external packages. These packages are under heavy development and take different approaches towards graphics and plotting.

## Gaston

[Gaston](https://github.com/mbaz/Gaston.jl) provides an interface to [gnuplot](http://www.gnuplot.info). Gaston also includes detailed documentation and examples in its [manual](https://bitbucket.org/mbaz/gaston/downloads/gastondoc-0.5.5.pdf). Add the Gaston package to your Julia installation with the following commond on the Julia prompt:

1. `Pkg.add("Gaston")`
2. `using Gaston`

In order to use Gaston, [install gnuplot](http://www.gnuplot.info/download.html). Gnuplot is widely used, and binaries are available for all platforms.

## Winston

Winston provides 2D plotting capabilities for Julia. Add the Winston package to your Julia installation with the following command on the Julia prompt:

1. `Pkg.add("Winston")`
2. `using Winston`

Winston's interface will be familiar to MATLAB users. See [examples](https://github.com/nolta/Winston.jl/blob/master/doc/examples.md) and documentation on the [Winston](https://github.com/nolta/Winston.jl) homepage.

## Gadfly

Gadfly is an implementation of a [Wickham-Wilkinson](http://www.cs.uic.edu/%7Ewilkinson/TheGrammarOfGraphics/GOG.html) style grammar of graphics in Julia. Add the Gadfly package to your Julia installation with the following command on the Julia prompt:

1. `Pkg.add("Gadfly")`
2. `using Gadfly`

Gadfly's interface will be familiar to users of R's [ggplot2](http://ggplot2.org) package. See [examples](http://dcjones.github.com/Gadfly.jl/doc/) and documentation on the [Gadfly](https://github.com/dcjones/Gadfly.jl) homepage.
