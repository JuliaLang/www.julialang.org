# Pluto.jl projects

## Pluto as a VS Code notebook

VS Code is an extensible editor, and one of its most recent features is a notebook GUI, with a corresponding [Notebook API](https://code.visualstudio.com/api/extension-guides/notebook), allowing extension developers to write their own _notebook backend_. We want to combine two popular Julia IDEs: VS Code and Pluto.jl, and use it to provide a mature editing and debugging experience combined with Pluto's reactivity.

**Expected Results:** Reactive notebook built on top of VSCode's notebook API.

**Recommended skills:** JavaScript/TypeScript, some Julia experience

**Mentors:** [Sebastian Pfitzner](https://github.com/pfitzseb) (core maintainer of julia-vscode), [Fons van der Plas](https://github.com/fonsp) (core maintainer of Pluto.jl) and friends

## Macro support

[Macros](https://docs.julialang.org/en/v1/manual/metaprogramming/#man-macros) are a core feature of Julia, and many important packages (Flux, JuMP, DiffEq, …) use them in creative ways. Pluto's reactivity is based on _syntax analysis_ to find the assigned and referenced variables of each cell. This powers not just reactive evaluation, but also Pluto's global scope management, and `@bind` interactivity. (See the [JuliaCon presentation](https://www.youtube.com/watch?v=IAF8DjrQSSk) for more info.)

Macros can assign to a variable without Pluto detecting it as such. For example, `@variables x y` from [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) _assigns_ to variables `x` and `y`, while Pluto thinks that `x` and `y` were referenced. Your project is to **add macro support to Pluto**. Julia has the built-in ability to 'expand' macros on demand, but integrating this into Pluto's reactive runtime remains a significant algorithm design problem. More info in [Pluto.jl#196](https://github.com/fonsp/Pluto.jl/issues/196).

**Expected Results:** First objective: process macros from packages, second (more difficult) objective: support macros defined inside the notebook itself.

**Recommended skills:** Julia, you will learn about metaprogramming, algorithm design and distributed computing

**Mentors:** [Fons van der Plas](https://github.com/fonsp) and fellow Pluto.jl maintainers

## Tools for education

Pluto's primary use case is education, and we recently started using Pluto notebooks as an 'interactive textbook': https://computationalthinking.mit.edu/ . If you are interested in design and interactive visualization, there are lots of cool JS projects in this area. Examples include:
- Linking video content to dynamic content, better integration between exercise and lecture material.
- Experiment with playing back the edits to a notebook session, like a video, but on a scrollable page. ([link](https://www.notion.so/malyvsen/Replay-notebook-computations-8bcd4787842e40a199806ebe1c368acb)).
- Syntax analysis to automatically review 'code style'
- Improved live check and autograding tools
- And so on! Take a look at our [project board](https://www.notion.so/malyvsen/Pluto-jl-a9982e79b7bb4c658e6216c15a9d4cab) and get in touch if you have further ideas: fons@plutojl.org

**Expected Results:** _One_ of the items above! When finished, your work will be used in future editions of the Computational Thinking course and more!

**Recommended skills:** JavaScript, CSS, you can learn Julia as part of the project.

**Mentors:** [Fons van der Plas](https://github.com/fonsp), [Connor Burns](https://github.com/ctrekker) and fellow Pluto.jl maintainers, with feedback from [Alan Edelman](https://math.mit.edu/directory/profile.php?pid=63)
