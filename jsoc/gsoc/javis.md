# Javis Projects – Summer of Code

> Javis: **J**ulia **A**nimations and **VIS**ualizations

[`Javis.jl`](https://github.com/Wikunia/Javis.jl/) is a general purpose Julia library to easily construct informative, performant, and winsome animated graphics.
`Javis` provides a powerful grammar for users to make animated visuals.
Users of `Javis` have made animations to explain concepts in a variety of fields such as mathematical concepts like [Fourier transformation](https://opensourc.es/blog/javis-v0.3/) to [brain imaging of EEGs](https://github.com/TheCedarPrince/NeuriViz).
It builds on top of the Julia drawing framework [Luxor](https://github.com/JuliaGraphics/Luxor.jl) by adding functions to simplify the creation of objects and their actions.

The Summer of Code Javis projects aims at simplifying the creation of animations to explain difficult concepts and communicate to broad audiences how Julia is a strong tool for graphics creation.

Below you can find a list of potential projects that can be tackled during Google Summer of Code.
If interested in exploring any of these projects, please reach out to:

- **[Jacob Zelko](http://jacobzelko.com/)** - [email](mailto:jacobszelko@gmail.com), [Slack](https://julialang.org/slack/) (username: TheCedarPrince), or [Zulip](https://julialang.zulipchat.com/) (username: TheCedarPrince)

- **[Ole Kröger](https://opensourc.es/about/)** - [Slack](https://julialang.org/slack/) (username: Wikunia), or [Zulip](https://julialang.zulipchat.com/) (username: Wikunia)

Thanks for your interest! :tada:

## General Improvement to User Experience

**Mentors**: Ole Kröger, Jacob Zelko

**Recommended skills**: General understanding of Luxor and the underlying structure of Javis.

**Difficulty:** Medium

**Description**: This project is split across several tasks that are manageable enough to be worked on by a single student in the Google Summer of Code period.
These small tasks come together to create an easier and understandable syntax for Javis-based animated graphic creation.
The following list are the smaller tasks one could work on:

- One of the bigger missing features is the lack of combining several objects into a layer. [Issue #75](https://github.com/Wikunia/Javis.jl/issues/75)

- To improve the user experience it will be helpful to ease object positioning based on other objects. [Issue #130](https://github.com/Wikunia/Javis.jl/issues/130)

- For visual appeal, morphing shapes into one another shall be improved as it's currently an undocumented and unfinished feature. [Issue #286](https://github.com/Wikunia/Javis.jl/issues/286)

- To bring Javis and Julia closer to the broader audience we are interested in the ability of live streaming animations to platforms like Twitch. [Issue #91](https://github.com/Wikunia/Javis.jl/issues/91)

## Graph and networks

**Mentors**: Ole Kröger, Jacob Zelko

**Recommended skills**: Knowledge about graph theory and LightGraphs.jl

**Difficulty:** Hard

**Description**: Javis could be a powerful platform to easily animate problems and their solutions in a variety of different fields.
Currently, Javis lacks the ability to visualize graphs.
The goal for this project would be to add graph support to Javis by supporting interoperability with [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl).
The animation of flows and shortest path is something that's extremely valuable for teaching as well as in practical analysis of graph networks.
To learn more about the current thoughts surrounding this problem, check this [issue](https://github.com/Wikunia/Javis.jl/issues/41) for more information. 

## Linear algebra

**Mentors**: Ole Kröger, Jacob Zelko

**Recommended skills**: Basic to intermediate knowledge about linear algebra.

**Difficulty:** Easy 

**Description**: Linear algebra is of invaluable importance all across different fields of mathematics and engineering.
Enabling the easy creation of visualizations regarding rotations, matrices and other concepts is helpful in educating students about this amazing branch mathematics.
Here are a few issues related to tasks that could be worked on to bring about this capability:

- Vectors are foundational to linear algebra, help Javis visualize them! [Issue #31](https://github.com/Wikunia/Javis.jl/issues/31)

- Drawing backgrounds such as grids can assist in easy viewing of complicated mathematical operations such as rotations. [Issue #38](https://github.com/Wikunia/Javis.jl/issues/31)
