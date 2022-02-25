#  GUI projects – Summer of Code

## QML and Makie integration

The [QML.jl](https://github.com/barche/QML.jl) package provides Julia bindings for [Qt QML](https://doc.qt.io/qt-5/qtqml-index.html) on Windows, OS X and Linux. In the current state, basic GUI functionality exists, and rough integration with [Makie.jl](https://github.com/JuliaPlots/Makie.jl) is available, allowing overlaying QML GUI elements over Makie visualizations.

### Expected results

1. *Split off the QML code for Makie into a separate package.* This will allow specifying proper package compatibility between QML and Makie, without making Makie a mandatory dependency for QML (currently we use [Requires.jl](https://github.com/JuliaPackaging/Requires.jl) for that)
2. *Improve the integration.* Currently, connections between Makie and QML need to be set up mostly manually. We need to implement some commonly used functionality, such as the registration of clicks in a viewport with proper coordinate conversion and navigation of 3D viewports.

**Recommended Skills**: Familiarity with both Julia and the Qt framework, some basic C++ skills, affinity with 3D graphics and OpenGL.

**Duration: 175h, expected difficulty: medium**

**Mentors**: [Bart Janssens](https://github.com/barche) and [Simon Danish](https://github.com/SimonDanisch)

## Web apps in Makie and JSServe

[Makie.jl](https://github.com/JuliaPlots/Makie.jl) is a visualization ecosystem for the Julia programming language, with a focus on interactivity and performance.
[JSServe.jl](https://github.com/SimonDanisch/JSServe.jl) is the core infrastructure library that makes Makie's web-based backend possible.

At the moment, all the necessary ingredients exist for designing web-based User Interfaces (UI) in Makie, but the process itself is quite low-level and time-consuming. The aim of this project is to streamline that process.

### Expected results

- Implement novel UI components and refine existing ones.
- Introduce data structures suitable for representing complex UIs.
- Add simpler syntaxes for common scenarios, akin to Interact's [`@manipulate`](https://github.com/JuliaGizmos/Interact.jl#manipulate) macro.
- Improve documentation and tutorials.
- Streamline the deployment process.

**Bonus tasks.** If time allows, one of the following directions could be pursued.
1. Making Makie web-based plots more suitable for general web apps (move more computation to the client side, improve interactivity and responsiveness).
2. Generalize the UI infrastructure to native widgets, which are already implemented in Makie but with a different interface.

**Desired skills.** Familiarity with HTML, JavaScript, and CSS, as well as reactive programming. Experience with the Julia visualization and UI ecosystem.

**Duration.** 350h.

**Difficulty.** Medium.

**Mentors.** [Pietro Vertechi](https://github.com/piever) and [Simon Danisch](https://github.com/SimonDanisch).