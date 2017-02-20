---
layout: default
title:  Graphics Projects – Summer of Code
---

{% include toc.html %}

## 2D Graphics Improvements

The [Winston](https://github.com/nolta/Winston.jl) package can be used for plotting 2D graphs and images. The package is already very useful but compared to the full featured Matplotlib python package there are still several things missing. This project can either go into the direction of improving the plotting itself (more graph types, more customization) or could go into the direction of increasing the interactivity of plotting windows (zooming, data picking ...) In the later case a close integration with Gtk.jl would be one way to go.

## Gtk.jl Improvements

The [Gtk.jl](https://github.com/JuliaLang/Gtk.jl) package is shaping up pretty well. Still there are various corners currently unimplemented and besides documentation it is very important to get installation of Gtk completely simple on all three major platforms. Furthermore, there is currently quite some manual tweaking necessary to get Gtk looking good on OSX. These installation issues are very crucial for serious integration of Gtk.jl into the Julia universe.

## QML.jl Improvements

The [QML.jl](https://github.com/barche/QML.jl) package provides Julia bindings for [Qt QML](http://doc.qt.io/qt-5/qtqml-index.html) on Windows, OS X and Linux. In the current state, basic functionality is available, but there is room for improvement regarding integration with [GLVisualize](https://github.com/JuliaGL/GLVisualize.jl) and plotting packages such as [GR](https://github.com/jheinen/GR.jl) (see also [issue 23](https://github.com/barche/QML.jl/issues/23)) or [Plots](https://github.com/JuliaPlots/Plots.jl). Another area of work is supporting more elaborate data models.

## Improvements to the Plots.jl ecosystem

[Plots.jl](https://github.com/tbreloff/Plots.jl) has become the preferred graphical interface for many users.  It has the potential to become the standard Julia interface for data visualization, and there are many potential ways that a student could contribute:

- Expanding backend support.  Integration with real-time visualization platforms ([GLVisualize.jl](https://github.com/JuliaGL/GLVisualize.jl)).  Easy latex plotting for scientific research publications ([PGFPlots.jl](https://github.com/sisl/PGFPlots.jl)).
- Adding recipes for statistics, machine learning (see [MLPlots.jl](https://github.com/JuliaML/MLPlots.jl)), or any other fields which you have an interest.
- Documentation and/or tutorials.
- Better integration with Graphs, DataStreams, etc.
- Improved support for the Grammar of Graphics API in Plots.jl via [GGPlots.jl](https://github.com/JuliaPlots/GGPlots.jl).
