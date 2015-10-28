---
layout: post
title: "JSoC 2015 project: Interactive 3D Graphics in the Browser with Compose3D"
authors: <a href="https://github.com/rohitvarkey">Rohit Varkey Thankachan</a>
---

Over the last three months, I've been working on [Compose3D](https://github.com/rohitvarkey/Compose3D.jl),
which is an extension of the amazing [Compose](https://github.com/dcjones/Compose.jl) package to 3D. My work on
Compose3D began as a project for my Computer Graphics course along with [Pranav T Bhat](https://github.com/pranavtbhat),
and by the end of the course, we had a working prototype for Compose3D with support for contexts and geometries and a
very basic WebGL backend.

It has been my pleasure to have been able to continue this work under the guidance of [Shashi Gowda](https://github.com/shashi)
and [Simon Danisch](https://github.com/SimonDanisch) as a part of the first ever Julia Summer of Code, generously
sponsored by the [Gordon and Betty Moore Foundation](https://www.moore.org/). While I've been able to add quite a lot of
functionality to Compose3D, it isn't totally ready for release yet. Hopefully, in some time it
will be ready. But as a happy side effect, I have been able to abstract out the WebGL rendering functionality provided
by the original prototype (and a lot more!) to a separate package called
[ThreeJS.jl](https://github.com/rohitvarkey/ThreeJS.jl),
which can now be used to render 3D graphics in browsers using Julia, opening up possibilities of displaying such
scenes in [IJulia](https://github.com/JuliaLang/IJulia.jl) notebooks and [Escher](https://github.com/shashi/Escher.jl).

## ThreeJS.jl

ThreeJS is now responsible for all the WebGL rendering done by Compose3D. It can also be used as a standalone package for
other graphics packages to use as a backend.

Initially, my approach to render scenes in Compose3D was to just emit out the corresponding JavaScript code, into the
IJulia notebook, which would then run it! This worked pretty well in IJulia notebooks, but it was soon apparent that
there were several flaws with this approach.

  - It was hard to extend.
  - Did not play well with Escher.
  - Nor did it work with Interact to provide interactivity.

So Shashi suggested implementing a [Polymer](https://www.polymer-project.org/1.0/) wrapper around the excellent
[three.js](http://threejs.org/) library, to create threejs web components. The Polymer team had done some work on
creating threejs components and had a basic implementation of the same ready, which I promptly [forked](https://github.com/rohitvarkey/three-js)
and tweaked to add functionality I needed. It's quite safe to say that I've spent more time writing JavaScript than
Julia during JSoC!

Switching over to using web components suddenly opened up 2 major avenues. Compose3D could now work with Escher and
also provided interactivity. ThreeJS outputs [Patchwork](https://github.com/shashi/Patchwork.jl)
elements, which lets it use Patchwork's clever diffing capabilities, thereby updating only the required DOM elements and
helping performance.

On the other hand, web components introduced issues with IJulia notebooks regarding serving the files required by
ThreeJS. I'm still working on finding a good solution for this problem, but for now, a hack gets ThreeJS working in
IJulia, albiet with some limitations.

### Drawing stuff!

Anyway, now we were all set to draw 3D scenes in browsers! The below code snippet, for example, would draw a red cube
illuminated from a corner. The camera in the scenes drawn by ThreeJS can be rotated, zoomed and panned using your mouse
or trackpad, allowing you to explore the scene.

    import ThreeJS
    ThreeJS.outerdiv() << (ThreeJS.initscene() <<
        [
            ThreeJS.mesh(0.0, 0.0, 0.0) <<
            [
                ThreeJS.box(1.0,1.0,1.0),
                ThreeJS.material(Dict(:kind=>"lambert",:color=>"red"))
            ],
            ThreeJS.pointlight(3.0, 3.0, 3.0),
            ThreeJS.camera(0.0, 0.0, 10.0)
        ])

### Making them interactive

Currently, interactivity is broken in IJulia (a side effect of the switch to Polymer 1.0, and the new sneaky DOM),
so Escher is the way to go if you want to interact with your 3D scene. So an example for this can be the same scene as before,
but after adding a slider and make it such that the size of the cube is controlled by the slider.

    import ThreeJS
    function main(window)
      push!(window.assets, "widgets")
      push!(window.assets, ("ThreeJS", "threejs"))
      side = Input(1.0)
      vbox(
        slider(1.0:5.0) >>> side,
        lift(side) do val
          ThreeJS.outerdiv() << (ThreeJS.initscene() <<
          [
              ThreeJS.mesh(0.0, 0.0, 0.0) <<
              [
                  ThreeJS.box(val, val, val),
                  ThreeJS.material(Dict(:kind=>"lambert",:color=>"red"))
              ],
              ThreeJS.pointlight(3.0, 3.0, 3.0),
              ThreeJS.camera(0.0, 0.0, 10.0)
          ])
        end
      )
    end

### You can also do animations!

Small scale animations can also be created using Escher. Instead of using sliders to update the elements,
we just update it at certain intervals using the `every` function or the `fpswhen` functions. A scene with a
rotating cube can be drawn using just a couple of modifications of the above code.

    import ThreeJS
    function main(window)
      push!(window.assets, "widgets")
      push!(window.assets, ("ThreeJS", "threejs"))
      rx = 0.0
      ry = 0.0
      rz = 0.0
      delta = fpswhen(window.alive, 60) #Update at 60 FPS
      lift(delta) do _
          rx += 0.5
          ry += 0.5
          rz += 0.5
          ThreeJS.outerdiv() << (ThreeJS.initscene() <<
          [
              ThreeJS.mesh(0.0, 0.0, 0.0) <<
              [
                  ThreeJS.box(2.0, 2.0, 2.0, rx = rx, ry = ry, rz = rz),
                  ThreeJS.material(Dict(:kind=>"lambert",:color=>"red"))
              ],
              ThreeJS.pointlight(3.0, 3.0, 3.0),
              ThreeJS.camera(0.0, 0.0, 10.0)
          ])
        end
    end

![Rotating Cube](https://gist.github.com/rohitvarkey/1d65925850198bc284f5/raw/b7dc41f2b3f869c103dcbcb79632f92397767b01/rotating_cube.gif)

### Surf and mesh plots! (Sort of)

ThreeJS has support to render parametric surfaces, which are basically the kind of surfaces drawn by
a typical `surf` plot. It also has support for drawing lines like a typical `mesh` plot. Colormaps can
be applied to these surfaces by passing in an array of colors to be used. Colors to be applied are
calculated and chosen by ThreeJS. These come into effect when put together with materials using the `colorkind`
property of `vertex`. Screenshots of such surfaces drawn by ThreeJS are shown below.

![Parametric surface](https://gist.github.com/rohitvarkey/1d65925850198bc284f5/raw/d1d8e389dd5baf5420cb24c1dfdf784bc61bf217/parametric.png)
![Mesh lines](https://gist.github.com/rohitvarkey/1d65925850198bc284f5/raw/d1d8e389dd5baf5420cb24c1dfdf784bc61bf217/meshlines.png)

## Compose3D

Compose3D provides an abstraction over the rendering library and lets you compose together primitives to
build scenes just like the inspiration for it, the Compose library. This lets you create very interesting
structures, with very less code! Compose3D has similar features to Compose, with users being able to create 3D contexts, and then use relative and absolute measures inside them and compose other primitives together.

My favorite example to showcase Compose3D would be the Sierpinski pyramid example. Here, we split the parent context
into the sections that we want and then just draw the pyramid in them! So the bottom half of the 3D space is split into 4,
and then, a pyramid is arranged on top of them.


    using Compose3D

    function sierpinski(n)
        if n == 0
            compose(Context(0w,0h,0d,1w,1h,1d),pyramid(0w,0h,0d,1w,1h)) #The basic unit
        else
            t = sierpinski(n - 1)
            compose(Context(0w,0h,0d,1w,1h,1d),
            (Context(0w,0h,0d,(1/2)w,(1/2)h,(1/2)d), t),
            (Context(0w,0h,0.5d,(1/2)w,(1/2)h,(1/2)d), t),
            (Context(0.5w,0h,0.5d,(1/2)w,(1/2)h,(1/2)d), t),
            (Context(0.5w,0h,0d,(1/2)w,(1/2)h,(1/2)d), t),
            (Context(0.25w,0.5h,0.25d,(1/2)w,(1/2)h,(1/2)d), t)) #The top one
        end
    end
    compose(Context(-5mm,-5mm,-5mm,10mm,10mm,10mm),sierpinski(3))

And voila! You have a Sierpinski pyramid of level 3 like in the figure below.

![Sierpinski](https://gist.github.com/rohitvarkey/1d65925850198bc284f5/raw/d1d8e389dd5baf5420cb24c1dfdf784bc61bf217/sierpinski.png)
The switch to ThreeJS allows Compose3D all the advantages that comes with ThreeJS. This includes interactivity
and animations!

For example, the same Sierpinski example can be have some interactive elements, say a slider defining the
number of levels of recursion and maybe some controlling the colors of the pyramid. This can be done easily
in Escher just like it was done with ThreeJS. After defining the `sierpinski` function given below, just creating a slider
and hooking it up to the `sierpinski` function will set this up!

    function main(window)
        push!(window.assets, ("ThreeJS", "threejs")) #Push the threejs static assets
        push!(window.assets, "widgets")
        n = Input(0.0)

        vbox(
            slider(0.0:3.0) >>> n, #Set up the slider
            lift(n) do i
                #Draw the composed figure!
                draw(
                    Patchable3D(100,100),
                    compose(
                        Context(-5mm,-5mm,-5mm,10mm,10mm,10mm), sierpinski(i)
                    )
                )
            end
        )
    end

![Interactive Sierpinski](https://gist.github.com/rohitvarkey/1d65925850198bc284f5/raw/78fefb17032a0bd9861e8497133cb6ce3876a4d4/interactive_sierpinski.gif)

An an example for animations, I ported the Escher boids example by Ian Dunning from 2D to 3D and a screencast of the same can be found below.

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/Yul3iBkAVHs" frameborder="0" allowfullscreen></iframe></div>

## Future directions

- Several new primitives have been added in ThreeJS which don't yet have corresponding primitives in Compose3D.
- Add support for text in ThreeJS allowing use of labels in plots.
- Being able to use `surf` and `mesh` that will automatically draw scaled surface plots in browsers and a WebGL based
plotting library around ThreeJS.
- Actually get Compose3D ready for public use!
