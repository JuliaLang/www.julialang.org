# Javis Projects – Summer of Code

> [Javis: **J**ulia **A**nimations and **Vis**ualizations](https://github.com/JuliaAnimators/Javis.jl)

Are you ready to create the next amazing visualization?
With Javis you can!
[Javis.jl](https://github.com/JuliaAnimators/Javis.jl) is a general purpose Julia library to easily construct informative, performant, and winsome animated graphics.
It uses a object-action relationship for users to make such visuals.

Javis has found application in diverse areas such as [teaching, art and more](https://juliaanimators.github.io/Javis.jl/dev/examples/).
To learn more about Javis and what it is capable of, check out our [2021 JuliaCon talk](https://www.youtube.com/watch?v=ckvsc6ukdOc)!
It builds on top of the drawing framework [Luxor.jl](https://github.com/JuliaGraphics/Luxor.jl) by adding functions to simplify the creation of objects and their actions.

Below you can find a list of potential projects that can be tackled during Google Summer of Code.
If interested in exploring any of these projects, please reach out to any of the following mentors:

- **[Jacob Zelko](http://jacobzelko.com/)** - [email](mailto:jacobszelko@gmail.com), [Slack](https://julialang.org/slack/) (username: TheCedarPrince), or [Zulip](https://julialang.zulipchat.com/) (username: TheCedarPrince)

- **[Ole Kröger](https://opensourc.es/about/)** - [Slack](https://julialang.org/slack/) (username: Wikunia), or [Zulip](https://julialang.zulipchat.com/) (username: Wikunia)

- **[Giovanni Puccetti](https://gpucce.github.io)** - [Zulip](https://julialang.zulipchat.com/) (username: Giovanni)

- **[Arsh Sharma](https://sov-trotter.github.io/blog/)** - [Zulip](https://julialang.zulipchat.com/) (username: Arsh Sharma)

Thanks for your interest! :tada:

## Improve Javis Performance

**Mentors:** Ole Kröger, Arsh Sharma

**Recommended Skills:** Familiarity with profiling, caching approaches, and performance testing

**Difficulty:** Medium

As Javis's interface is largely stabilized and Javis is finding use in different applications, it is now time to deal with one of Javis's greatest pain points: slowness and high memory usage for large animations.
While creating an animation in Javis, there is much room for performance improvements such as in the area of creating Objects and Actions, managing the data structures for Objects and Actions, rendering an animation, and handling different media formats (such as gif and mp4).
For this specific project, a student will work with Ole and Arsh to create a profiling scheme for Javis to identify performance bottlenecks and measure allocations, determine caching and memory flexible modes of rendering animations with tools such as [FFMPEG.jl](https://github.com/JuliaIO/FFMPEG.jl), and finish implementing live streaming of animations.
The goal for this project will not be to fully fix all identified performance issues but rather to identify and catalogue them for further development by Javis maintainers and contributors.

## Building Novel Animation Abilities for Javis

**Mentors:** Jacob Zelko, Giovanni Puccetti

**Recommended Skills:** General understanding of Luxor and the underlying structure of Javis

**Difficulty:** Medium

Javis's interface has matured to a great point - but we believe Javis can do even more!
Although Javis can do complex transformations such as morphing one polygon to another, Javis is capable of more than that.
In this project, a student will work with Jacob and Giovanni to create new animation abilities for Javis to handle different coordinate systems, developing new types of shorthand expressions for object creation known as JObjects, further developing morphing, building out the flexibility of layers, and more.
A student is encouraged to come to this project with new ideas for what animations Javis can do and to reach out to Jacob and Giovanni to begin discussions early.
