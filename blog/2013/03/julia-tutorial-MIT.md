@def rss_pubdate = Date(2013, 3, 30)
@def rss_description = """ Videos from the Julia tutorial at MIT | We held a two day Julia tutorial at MIT in January 2013, which included 10 sessions. [MIT Open Courseware](https://ocw.mit.edu/) and MIT-X (https://www.mitx.org/) graciously provided support for recording of these lectures, so that the wider Julia community can benefit from these sessions.... """
@def published = "30 March 2013"
@def title = "Videos from the Julia tutorial at MIT"
@def authors = """<a href="https://github.com/ViralBShah/">Viral B. Shah</a>"""


We held a two day Julia tutorial at MIT in January 2013, which included 10 sessions. [MIT Open Courseware](https://ocw.mit.edu/) and [MIT-X](https://www.mitx.org/) graciously provided support for recording of these lectures, so that the wider Julia community can benefit from these sessions.

## Julia Lightning Round ([slides](/assets/blog/IAP_2013_Lightning.pdf))

This session is a rapid introduction to julia, using a number of lightning rounds. It uses a number of short examples to demonstrate syntax and features, and gives a quick feel for the language.

~~~<iframe width="560" height="315" src="https://www.youtube.com/embed/37L1OMk_3FU" frameborder="0" allowfullscreen></iframe>~~~

## Rationale behind Julia and the Vision ([slides](https://github.com/JuliaLang/julia-tutorial/raw/master/Vision/vision.pdf))

The rationale and vision behind julia, and its design principles are discussed in this session.

~~~<iframe width="560" height="315" src="https://www.youtube.com/embed/02U9AJMEWx0" frameborder="0" allowfullscreen></iframe>~~~

## Data Analysis with DataFrames ([slides](https://github.com/JuliaLang/julia-tutorial/raw/master/DataFrames/slides.pdf))

[DataFrames](https://github.com/HarlanH/DataFrames.jl) is one of the most widely used Julia packages. This session is an introduction to data analysis with Julia using DataFrames.

~~~<iframe width="560" height="315" src="https://www.youtube.com/embed/XRClA5YLiIc" frameborder="0" allowfullscreen></iframe>~~~

## Statistical Models in Julia ([slides](https://github.com/JuliaLang/julia-tutorial/raw/master/Stats/slides.pdf))

This session demonstrates Julia's statistics capabilities, which are provided by [Distributions](https://github.com/JuliaStats/Distributions.jl) and [GLM](https://github.com/JuliaStats/GLM.jl).

~~~<iframe width="560" height="315" src="https://www.youtube.com/embed/v9Io-p_iymI" frameborder="0" allowfullscreen></iframe>~~~

## Fast Fourier Transforms

Julia provides a built-in interface to the [FFTW](http://www.fftw.org/) library. This session demonstrates the Julia's signal processing capabilities, such as FFTs and DCTs. Also see the [Hadamard](https://github.com/stevengj/Hadamard.jl) package.

~~~<iframe width="560" height="315" src="https://www.youtube.com/embed/1iBLaHGL1AM" frameborder="0" allowfullscreen></iframe>~~~

## Optimization ([slides](https://github.com/JuliaLang/julia-tutorial/raw/master/NumericalOptimization/presentation.pdf))

This session focuses largely on using Julia for solving linear programming problems. The algebraic modeling language discussed was later released as [JuMP](https://github.com/IainNZ/JuMP.jl). Benchmarks are shown evaluating the performance of Julia for implementing low-level optimization code. Optimization software in Julia has been grouped under the [JuliaOpt](http://juliaopt.org/) project.

~~~<iframe width="560" height="315" src="https://www.youtube.com/embed/O1icUP6sajU" frameborder="0" allowfullscreen></iframe>~~~

## Metaprogramming and Macros

Julia is homoiconic: it represents its own code as a data structure of the language itself. Since code is represented by objects that can be created and manipulated from within the language, it is possible for a program to transform and generate its own code. [Metaprogramming](https://docs.julialang.org/en/v1/manual/metaprogramming/#) is described in detail in the Julia manual.

~~~<iframe width="560" height="315" src="https://www.youtube.com/embed/EpNeNCGmyZE" frameborder="0" allowfullscreen></iframe>~~~

## Parallel and Distributed Computing ([Lab](https://github.com/JuliaLang/julia-tutorial/raw/master/NumericalOptimization/tutorial.pdf), [Solution](https://github.com/JuliaLang/julia-tutorial/blob/master/NumericalOptimization/Tutorial.jl))

[Parallel and distributed computing](https://docs.julialang.org/en/v1/manual/parallel-computing/#Parallel-Computing-1) have been an integral part of Julia's capabilities from an early stage. This session describes existing basic capabilities, which can be used as building blocks for higher level parallel libraries.

~~~<iframe width="560" height="315" src="https://www.youtube.com/embed/JoRn4ryMclc" frameborder="0" allowfullscreen></iframe>~~~

## Networking

Julia provides asynchronous networking I/O using the [libuv](https://github.com/joyent/libuv) library. Libuv is a portable networking library created as part of the [Node.js](https://www.nodejs.org/) project.

~~~<iframe width="560" height="315" src="https://www.youtube.com/embed/qYjHYTn7r2w" frameborder="0" allowfullscreen></iframe>~~~

## Grid of Resistors ([Lab](https://github.com/JuliaLang/julia-tutorial/blob/master/GridOfResistors/GridOfResistors.md), [Solution](https://github.com/JuliaLang/julia-tutorial/tree/master/GridOfResistors))

The Grid of Resistors is a classic numerical problem to compute the voltages and the effective resistance of a 2n+1 by 2n+2 grid of 1 ohm resistors if a battery is connected to the two center points. As part of this lab, the problem is solved in Julia in a number of different ways such as a vectorized implementation, a devectorized implementation, and using comprehensions, in order to study the performance characteristics of various methods.

~~~<iframe width="560" height="315" src="https://www.youtube.com/embed/OFWYPqwVtHU" frameborder="0" allowfullscreen></iframe>~~~
