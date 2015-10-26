---
layout: post
title: "JSoC 2015 project: Interactive Visualizations in Julia with GLVisualize.jl"
author: <a href="https://github.com/SimonDanisch">Simon Danisch</a>
---

GLVisualize is an interactive visualization library that supports 2D and 3D rendering as well as building of basic GUIs. It's written entirely in Julia and OpenGL.
I'm really glad that I could continue working on this project with the support of Julia Summer of Code.

During **JSoC**, my main focus was on advancing [GLVisualize](https://github.com/JuliaGL/GLVisualize.jl), but also improving the surrounding infrastructure like [GeometryTypes](https://github.com/JuliaGeometry/GeometryTypes.jl), [FileIO](https://github.com/JuliaIO/FileIO.jl), [ImageMagick](https://github.com/JuliaIO/ImageMagick.jl), [MeshIO](https://github.com/JuliaIO/MeshIO.jl) and [FixedSizeArrays](https://github.com/SimonDanisch/FixedSizeArrays.jl).
All recorded gifs in this blog post suffer from lossy compression. You can click on most of them to see the code that produced them.

One of the most interesting parts of **GLVisualize** is, that it's combining GUIs and visualizations, instead of relying on a 3rd party library like **QT** for GUIs.
This has many advantages and disadvantages.
The main advantage is, that interactive visualization share a lot of infrastructure with GUI libraries.
By combining these two, new features are possible, e.g. text editing of labels in 3D space, or making elements of a visualization work like a button. These features should end up being pretty snappy, since **GLVisualize** was created with [high performance](http://randomfantasies.com/2015/05/glvisualize-benchmark/) in mind.

Obviously, the biggest downside is, that it is really hard to reach the maturity and feature completeness from e.g. **QT**.

So to really get the best of both worlds a lot of work is needed.

## Current status of GLVisualize, and what I've been doing during **JSoC**

A surprisingly large amount of time went into improving **FileIO** together with [Tim Holy](https://github.com/timholy).
The selling point of **FileIO** is, that one can just load a file into **FileIO** and it will recognize the format and load the respective IO library.
This makes it a lot easier to start working with files in Julia, since no prior knowledge about formats and loading files in Julia is needed.
This is perfect for a visualization library, since most visualization start from data, that comes in some format, which might even be unknown initially.

Since all files are loaded with the same function, it becomes much easier to implement functionality like drag and drop of any file supported by FileIO.
To give you an example, the implementation of the drag and drop feature in **GLVisualize** only needs a [few lines of code](https://gist.github.com/SimonDanisch/e0a8a2cbc3106ce6c123#file-dragndrop-jl) thanks to FileIO:

[![drag and drop](https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/dragndrop2.gif?raw=true)](
https://gist.github.com/SimonDanisch/e0a8a2cbc3106ce6c123#file-dragndrop-jl
)

Another feature I've been working on is better 2D support.
I've implemented different anti-aliased marker, text rendering and line types.
Apart from the image markers, they all use the [distance field technique](http://www.valvesoftware.com/publications/2007/SIGGRAPH2007_AlphaTestedMagnification.pdf), to achieve view independent anti-aliasing.
Here are a few examples:

![lines](https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/lines.png?raw=true)
[![markers](https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/markers.gif?raw=true)](
https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/marker.jl
)

In the last example all the markers move together.
This is actually one of the core feature of **GLVisualize**. The markers share the same memory for the positions on the GPU without any overhead. Each marker then just has a different offset to that shared position.
This is easily achieved in **GLVisualize**, since all visualization methods are defined on the GPU objects.
This also works for GPU objects which come from some simulation calculated on the GPU.

During **JSoC**, I also implemented sliders and line editing widgets for GLVisualize.
One can use them to add interactivity to parameters of a visualization:

[![line_edit](https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/volume_color.gif?raw=true)](
https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/color_volume.jl
)
[![arbitrary_surf](https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/arbitrary_surf.gif?raw=true)](
https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/arbitrary_surf.jl
)

I have also worked with [David P. Sanders](https://github.com/dpsanders) to visualize his [billiard model](https://github.com/dpsanders/BilliardModels.jl), which demonstrates the particle system and a new camera type.

[![billiard](https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/billiard.gif?raw=true)](
https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/billard.jl
)
The particle system can use any mesh primitive. To make it easy to load and create meshes, [Steve Kelly](https://github.com/sjkelly) and I rewrote the [Meshes](https://github.com/JuliaGeometry/Meshes.jl) package to include more features and have a better separation of mesh IO and manipulation. The IO is now in **MeshIO**, which supports the **FileIO** interface. The mesh types are in **GeometryTypes** and meshing algorithms are in different packages in the [JuliaGeometry](https://github.com/JuliaGeometry) org.

In this example one can see, that there are also some GUI widgets to interact with the camera.
The small rectangles in the corner are for switching between orthographic and perspective projection. The cube can be used to center the camera on a particular side.
These kind of widgets are easy to implement in **GLVisualize**, as it is build for GUIs and interactivity from the beginning.
Better camera controls are a big usability win, and I will put more time into improving these even further.

I recorded one last demo to give you some more ideas of what **GLVisualize** is currently capable of:

![interactivity](https://github.com/SimonDanisch/Blog/blob/master/10-22-15-jsoc/interactivity.gif?raw=true)

The demo shows different kind of animations, 3D text editing and pop ups that are all relatively easy to include in any visualization created with **GLVisualize**.

All of this looks promising, but there is still a lot of work needed!
First of all, there is still no tagged version of **GLVisualize** that will just install via Julia's package manager.
This is because [Reactive.jl](https://github.com/JuliaLang/Reactive.jl) and [Images.jl](https://github.com/timholy/Images.jl) are currently not tagged on a version that works with **GLVisualize**.

On the other side, the API is not that thought out yet.
It is planned to use more ideas from [Escher.jl](https://github.com/shashi/Escher.jl) and [Compose.jl](https://github.com/dcjones/Compose.jl) to improve the API.
The goal is to fully support the Compose interface at some point.
Like that, **GLVisualize** can be used as a backend for [Gadfly](https://github.com/dcjones/Gadfly.jl). This will make **Gadfly** much fitter for large, animated data sets.
In the next weeks, I will need to work on tutorials, documentations and handling edge cases better.

Big thanks go to the Julia team and everyone involved to make this possible!
