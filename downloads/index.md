---
layout: default
title:  Julia Downloads
---

# Download and install Julia on various Operating Systems

Current version: [release **v0.1.2**](http://code.google.com/p/julialang/downloads/list) | [beta **v0.2-pre**](#beta)

<span id="stable"/>
#Release v0.1.2
<table class="downloads"><tbody>
<tr>
    <th> Windows Archive (.zip) </th>
    <td> <a href="http://julialang.googlecode.com/files/julia0.1.2-WINNT-i686%2BGit.zip">32-bit</a> </td>
    <td> 64-bit (Unavailable) </td>
</tr>
<tr>
    <th> Mac OS X Package (.dmg) </th>
<!--<td>32-bit</td>-->
    <td colspan=2> <a href="http://julialang.googlecode.com/files/Julia-0.1.2.dmg">64-bit</a> </td>
</tr>
<tr>
    <th> Source (Git) </th>
    <td colspan=2> <a href="https://github.com/JuliaLang/julia/tree/v0.1.2">git@github.com:JuliaLang/julia -b 'v0.1.2'</a> </td>
</tr>
</tbody></table>

<span id="beta"/>
#Beta v0.2-prerelease
<table class="downloads"><tbody>
<tr>
    <th> Windows Self-Extracting Archive (.exe) </th>
    <td> <a href="http://s3.amazonaws.com/julialang/bin/winnt/x86/0.2/julia-0.2pre-d6f7c7c781-win32.exe">32-bit</a> </td>
    <td> <a href="http://s3.amazonaws.com/julialang/bin/winnt/x64/0.2/julia-0.2pre-d6f7c7c781-win64.exe">64-bit</a> </td>
</tr>
<tr>
    <th> Mac OS X Package (.dmg) </th>
<!--<td> 32-bit </td>-->
    <td colspan=2> <a href="https://s3.amazonaws.com/julialang/bin/osx/x64/0.2/julia-0.2-unstable.dmg">64-bit</a> </td>
</tr>
<tr>
    <th> Linux packages </th>
    <td colspan=2> <a href="https://launchpad.net/~staticfloat/+archive/julianightlies">Ubuntu</a> </td>
</tr>
<tr>
    <th> Source (Git) </th>
    <td colspan=2> <a href="https://github.com/JuliaLang/julia">git@github.com:JuliaLang/julia</a> </td>
</tr>
</tbody></table>

If the provided download files do not work for you, please [file an issue](https://github.com/JuliaLang/julia/issues).

---
# Platform Specific Instructions

## Windows

Julia is available for both 32-bit and 64-bit Windows since XP SP3.

1. Download the Windows julia.exe installer for your platform. 32-bit julia works on both x86 and x86_64. 64-bit julia will only run on 64-bit Windows (x86_64).
2. Run the downloaded program to extract julia
3. Double-click julia.bat in the unpacked folder to start julia

The [Windows README](https://github.com/JuliaLang/julia/blob/master/README.windows.md) contains information on dependencies.

Uninstallation is performed by deleting the extracted directory. If you would also like to remove your preferences files, they can be found in your user directory at `%APPDATA%/julia`; this is typically expanded to `%USERHOME%/Application Data/Roaming/julia`.

## OS X

On Mac, a Julia-version.dmg file is provided, which contains Julia.app. Installation is the same as any other Mac software -- copy the Julia.app to your hard-drive (anywhere) or run from the disk image. OS X Lion (10.7) or later are required to be able to use the precompiled binaries. OS X Snow Leopard (10.6) has also been reported to work, but it may not work in all cases. In such cases, you may need to build from source.

Uninstall Julia by deleting Julia.app and the packages directory in ~/.julia. Multiple Julia.app binaries can co-exist without interfering with each other. If you would also like to remove your preferences files, remove `~/.juliarc.jl`.

## Linux

Instructions will be added here as more linux distributions start including julia. If your Linux distribution is not listed here, you should still be able to run julia by building from source. See the [Julia README](https://github.com/JuliaLang/julia/blob/master/README.md) for more detailed information.

1. [Ubuntu 13.04](http://packages.ubuntu.com/raring/julia): apt-get install julia

Uninstallation is platform dependent. If you did a source build, it can be performed by deleting your julia source folder. If you would also like to remove your preferences files, they are `~/.julia` and `~/.juliarc.jl`.

### Beta installation instructions
A [PPA](https://launchpad.net/~staticfloat/+archive/julianightlies) (Personal Package Archive) is provided for Ubuntu systems to allow for automatic updating to the latest beta version of Julia.  To use this PPA and install julia on Ubuntu 12.04 or later, simply type:

    $ sudo add-apt-repository ppa:staticfloat/julianightlies
    $ sudo add-apt-repository ppa:staticfloat/julia-deps
    $ sudo apt-get update
    $ sudo apt-get install julia

New builds are built every night. If you have already installed julia and you want to upgrade to the latest version, do:

    $ sudo apt-get update
    $ sudo apt-get upgrade

---
# Graphics in Julia

Graphics in Julia are available through external packages. These packages are under heavy development and take different approaches towards graphics and plotting, which suit different use cases.

## Winston

Winston provides 2D plotting capabilities for Julia. Add the Winston package to your Julia installation with the following command on the Julia prompt:

1. `Pkg.add("Winston")`
2. `using Winston`
3. `plot( cumsum(randn(1000)) )` # (plot a random walk)

Winston's interface will be familiar to MATLAB users. See [examples](https://github.com/nolta/Winston.jl/blob/master/doc/examples.md) and documentation on the [Winston](https://github.com/nolta/Winston.jl) homepage.

## Gadfly

Gadfly is an implementation of a [Wickham-Wilkinson](http://www.cs.uic.edu/%7Ewilkinson/TheGrammarOfGraphics/GOG.html) style grammar of graphics in Julia. Add the Gadfly package to your Julia installation with the following command on the Julia prompt:

1. `Pkg.add("Gadfly")`
2. `using Gadfly`
3. `draw(SVG("output.svg", 6inch, 3inch), plot([sin, cos], 0, 25))` #(plot a pair of simple functions over a range)

Gadfly's interface will be familiar to users of R's [ggplot2](http://ggplot2.org) package. See [examples](http://dcjones.github.com/Gadfly.jl/doc/) and documentation on the [Gadfly](https://github.com/dcjones/Gadfly.jl) homepage.

## Gaston

[Gaston](https://github.com/mbaz/Gaston.jl) provides an interface to [gnuplot](http://www.gnuplot.info). Gaston also includes detailed documentation and examples in its [manual](https://bitbucket.org/mbaz/gaston/downloads/gastondoc-0.5.5.pdf). Add the Gaston package to your Julia installation with the following commond on the Julia prompt:

1. `Pkg.add("Gaston")`
2. `using Gaston`
3. `Gaston.set_terminal("aqua")` #(this may be necessary, if the following reports that your terminal type is unknown)
4. `x=-pi:.001:pi; y=x.*sin(10./x); plot(x,y)` #(plot `x*sin(10/x)`)

In order to use Gaston, you will need to [install gnuplot](http://www.gnuplot.info/download.html) and ensure it is accessible

## PyPlot

[PyPlot](https://github.com/stevengj/PyPlot.jl) uses the Julia PyCall package to call Python's matplotlib directly from Julia with little or no overhead (arrays are passed without making a copy). Installation and example usage:

1. `Pkg.add("PyPlot")`
2. `using PyPlot`
3. `x = linspace(0,2*pi,1000); y = sin(3*x + 4*cos(2*x))`
4. `plot(x, y, color="red", linewidth=2.0, linestyle="--")`
