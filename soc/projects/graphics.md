---
layout: default
title:  Graphics Projects – Summer of Code
---

{% include toc.html %}

## 2D Graphics Improvements

The [Winston](https://github.com/nolta/Winston.jl) package can be used for plotting 2D graphs and images. The package is already very useful but compared to the full featured Matplotlib python package there are still several things missing. This project can either go into the direction of improving the plotting itself (more graph types, more customization) or could go into the direction of increasing the interactivity of plotting windows (zooming, data picking ...) In the later case a close integration with Gtk.jl would be one way to go.

## Gtk.jl Improvements

The [Gtk.jl](https://github.com/JuliaLang/Gtk.jl) package is shaping up pretty well. Still there are various corners currently unimplemented and besides documentation it is very important to get installation of Gtk completely simple on all three major platforms. Furthermore, there is currently quite some manual tweaking necessary to get Gtk looking good on OSX. These installation issues are very crucial for serious integration of Gtk.jl into the Julia universe.

## QML bindings for Julia

QML is a markup language similar to JavaScript and used by the QT library to create graphical user interfaces. QT Creator (open source IDE) provides a graphical editor to create QML forms. QML forms are cross-platform and can be used on Linux, Mac, Windows, Android, OSX, IPhone etc. It would be great if they could also be used by Julia in an easy way. Implementing these bindings should be not so difficult, because C bindings already exist: [libqmlbind](https://github.com/seanchas116/libqmlbind).

The Ruby bindings could be used as starting point for implementing Julia bindings: [ruby-qml](https://github.com/seanchas116/ruby-qml).

Another possible starting point is [QML.jl](https://github.com/barche/QML.jl), where there is a direct interfacing with C++, eliminating the need for libqmlbind.

A possible mentor can be contacted on the julia-users mailing list.

## Improvements to the Plots.jl ecosystem

[Plots.jl](https://github.com/tbreloff/Plots.jl) has become the preferred graphical interface for many users.  It has the potential to become the standard Julia interface for data visualization, and there are many potential ways that a student could contribute:

- Expanding backend support.  Integration with real-time visualization platforms ([GLVisualize.jl](https://github.com/JuliaGL/GLVisualize.jl)).  Easy latex plotting for scientific research publications ([PGFPlots.jl](https://github.com/sisl/PGFPlots.jl)).
- Adding recipes for statistics, machine learning (see [MLPlots.jl](https://github.com/JuliaML/MLPlots.jl)), or any other fields which you have an interest.
- Documentation and/or tutorials.
- Better integration with Graphs, DataStreams, etc.
- Improved support for the Grammar of Graphics API in Plots.jl via [GGPlots.jl](https://github.com/JuliaPlots/GGPlots.jl).
