#  GUI projects – Summer of Code

## QML and Makie integration

The [QML.jl](https://github.com/barche/QML.jl) package provides Julia bindings for [Qt QML](https://doc.qt.io/qt-5/qtqml-index.html) on Windows, OS X and Linux. In the current state, basic GUI functionality exists, and rough integration with [Makie.jl](https://github.com/JuliaPlots/Makie.jl) is available, allowing overlaying QML GUI elements over Makie visualizations.

### Expected results

1. *Split off the QML code for Makie into a separate package.* This will allow specifying proper package compatibility between QML and Makie, without making Makie a mandatory dependency for QML (currently we use [Requires.jl](https://github.com/JuliaPackaging/Requires.jl) for that)
2. *Improve the integration.* Currently, connections between Makie and QML need to be set up mostly manually. We need to implement some commonly used functionality, such as the registration of clicks in a viewport with proper coordinate conversion and navigation of 3D viewports.

**Recommended Skills**: Familiarity with both Julia and the Qt framework, some basic C++ skills, affinity with 3D graphics and OpenGL.

**Duration: 175h, expected difficulty: medium**

**Mentors**: [Bart Janssens](https://github.com/barche) and [Simon Danish](https://github.com/SimonDanisch)
