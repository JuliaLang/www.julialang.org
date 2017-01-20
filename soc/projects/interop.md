# Theme: Improvements to Julia interactivity and interoperability with other applications

## Enhanced clipboard

Julia's functions for getting and setting the clipboard are currently limited to text; it would be useful to extend them to allow the transfer of other data (for example, spreadsheet data or images).

**Expected Results:** Extensible `clipboard()` and `clipboard(x)` functions to get and set the richest possible representation of the system clipboard data, as well as methods for specific types.

**Knowledge Prerequisites:** Interfacing with C from Julia, clipboard APIs for different platforms.

## Calling Julia from Python

Julia could be a great replacement for C in Python projects, where it can be used to speed up bottlenecks without sacrificing ease of use. However, while the basic functionality for calling Julia exists in [IJulia](https://github.com/JuliaLang/IJulia.jl) and [pyjulia](https://github.com/jakebolewski/pyjulia), it needs to be separated out and mantained as a real Python package.

**Expected Results:** An easy-to-use Python package which allows Julia functions to be imported and called, with transparent conversion of data.

**Knowledge Prerequisites:** Python (especially C interop).
