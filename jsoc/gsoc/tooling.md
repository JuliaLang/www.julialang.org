

# Tooling Projects – Summer of Code

## VS Code extension

We are generally looking for folks that want to help with the [Julia VS Code extension](https://www.julia-vscode.org/).
We have a long list of open issues, and some of them amount to significant projects.

**Required Skills**: TypeScript, julia, web development.

**Expected Results**: Depends on the specific projects we would agree on.

**Mentors**: [David Anthoff](https://github.com/davidanthoff)

## Package installation UI

The VSCode extension for Julia could provide a simple way to browse available packages and view what's installed on a users system. To start with, this project could simply provide a GUI that reads in package data from a `Project.toml`/`Manifest.toml` and show some UI elements to add/remove/manage those packages.

This could also be extended by having metadata about the package, such as a readme, github stars, activity and so on (somewhat similar to the VSCode-native extension explorer).

**Expected Results**: A UI in VSCode for package operations.

**Recommended Skills**: Familiarity with TypeScript and Julia development.

**Mentors**: [Sebastian Pfitzner](https://github.com/pfitzseb)


# Graphical user interfaces

## Interactive UI libraries and tooling

[WebIO.jl](https://github.com/JuliaGizmos/WebIO.jl) is an exciting new library that enables two-way interaction between julia and web technologies (html/css/js). We are looking for project proposals in, possibly a combination of the following areas:

@@tight-list
- Tools for building dashboards, and easily deploying them to the web, ala R's Shiny, and Plotly's dash
- Wrapping js libraries such as D3, interact.js, Plotly's dash?
- Reliability/Testing - (tools to) enable browser based automated tests for WebIO, InteractNext, and other projects built on WebIO
@@

We're open to your project ideas. Join us on the [#gizmos slack channel](https://julialang.slack.com/messages/gizmos/) to discuss or ping `@shashi` or `@JobJob` in a [discourse post](https://discourse.julialang.org/).

**Required Skills**: Experience with JavaScript front-end development, some familiarity with Julia

**Mentors**: [Shashi Gowda](https://github.com/shashi), [Joel Mason](https://github.com/JobJob)

## GUI library integration

[QML.jl](https://github.com/barche/QML.jl) provides an interface to connect a [QML](https://doc.qt.io/qt-5.10/qmlapplications.html) GUI to a Julia backend. Some ideas for improvement here are:

@@tight-list
* Use [Observables.jl](https://github.com/JuliaGizmos/Observables.jl) to provide a more "Julian" way to pass data between the GUI and Julia. Work on this has already started on the [observables branch](https://github.com/barche/QML.jl/tree/observables) in QML.jl. Discussion: https://github.com/barche/QML.jl/issues/43
* Support [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) directly for creating an editable TableView. Inspiration: https://discourse.julialang.org/t/visual-workflow-tool-for-julia-lets-build-one/9384/4
* Make one [Plots.jl](https://github.com/JuliaPlots/Plots.jl) GUI to rule them all. Inspiration: https://discourse.julialang.org/t/best-plot-package/7458 and https://discourse.julialang.org/t/where-is-actual-development-in-plotting/6224
* Build QmlReactive (but using Observables maybe). Inspiration: https://github.com/JuliaGizmos/GtkReactive.jl
@@

**Required Skills**: Some familiarity with Julia, prior QML experience would also help.

**Mentors**: [Bart Janssens](https://github.com/barche), [Shashi Gowda](https://github.com/shashi) for the Observables part
