# Pluto.jl projects

## Pluto as a VS Code notebook

VS Code is an extensible editor, and one of its most recent features is a notebook GUI, with a corresponding [Notebook API](https://code.visualstudio.com/api/extension-guides/notebook), allowing extension developers to write their own _notebook backend_. We want to combine two popular Julia IDEs: VS Code and Pluto.jl, and use it to provide a mature editing and debugging experience combined with Pluto's reactivity.

**Expected Results:** Reactive notebook built on top of VSCode's notebook API.

**Recommended skills:** JavaScript/TypeScript, some Julia experience

**Mentors:** [Sebastian Pfitzner](https://github.com/pfitzseb) (core maintainer of julia-vscode), [Panagiotis Georgakopoulos](https://github.com/pankgeorg) and [Fons van der Plas](https://github.com/fonsp) (core maintainers of Pluto.jl) and friends

_Also see the other [VS Code projects](https://julialang.org/jsoc/gsoc/vscode/)!_

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
