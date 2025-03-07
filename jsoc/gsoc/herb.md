# Herb.jl Projects

![Herb Logo](https://raw.githubusercontent.com/Herb-AI/Herb.jl/refs/heads/documentation/docs/src/assets/herb.png)

Wouldn’t it be great if Julia would program itself?
Tell it what you want, Julia magic happens, and you get your program directly.
We introduce Herb.jl, a library written in Julia that gets us a step
closer to our big goal.
[Herb.jl](https://herb-ai.github.io/) is a library for program synthesis: The task of automatically generating programs from a given specification.
Here, “a program” could be anything, from an actual Python program over moves in chess to the synthesis of biochemical molecules.
There are numerous works on program synthesis, all speaking a different language in code and terminology.
We want to make developing, comparing, and applying ideas in program synthesis easier.

Herb’s main goal is, therefore, two-fold.
First, we aim to provide a toolbox for 1. developing new program synthesizers or 2. easily re-implementing existing ones.
Second, we aim to unify many different flavors of program synthesis under a joint framework, making program synthesizers easy to use on new problems.

If you have any questions or ideas, please [contact Tilman](mailto:t.r.hinnerichs@tudelft.nl).

## Project 1: Optimizations
**Difficulty:** Medium

**Estimated Duration:** 350 hours

**Project Overview:**
`Herb.jl` has an outstanding performance in enumerating programs.
Every generated program also needs to be evaluated, making evaluation the main bottleneck in finding a suitable program.
We want to improve this aspect by leveraging various well-engineered projects from the Julia community.

First, we have so far lessened the burden of evaluation by developing custom interpreters.
This is time-consuming and error-prone, so we would like to avoid it.
The core challenge here is that the explore programs don't have a fixed structure and are constructed during synthesis; therefore, they cannot be compiled ahead of time.
The Julia package `DynamicExpressions.jl` is developed to overcome this exact problem, allowing for "ridiculously fast symbolic expressions".
We would like to integrate `DynamicExpressions.jl` into our ecosystem and get a faster evaluation of Julia programs *for free*.


Second, Herb is limited to Julia so far.
Our goal is, however, to make Herb a *language agnostic* program synthesis library.
We would like to extend Herb with connections to other interpreters for common languages like Python, Java, Prolog, et cetera.
This would make it possible for Herb users to use any programming language that fits their needs.

Third, another crucial aspect of every program synthesis engine is the construction of candidate programs.
State-of-the-art program synthesis tools, like CVC5, have invested significant time into optimizing the program construction step, resulting in significantly improved performance.
We want to map these ideas into Herb.

**Minimum goal:**
Connect `DynamicExpressions.jl` to `Herb.jl`.
This involves implementing the expression interface from `DynamicExpressions.jl` for `Herb.jl`’s expression tree formulation.

**Extended goal:**
Add support for at least one non-Julia program interpreter or add tricks from CVC5 to Herb.

**Recommended skills:**
- basic knowledge of data structures
- interest in program optimization
- the eagerness to learn to write and optimize code

**Mentors:** Reuben Gardos-Reid, Tilman Hinnerichs and Sebastijan Dumancic

**Some literature:**
- The Program Synthesis book (by Gulwani et al., [link](https://www.microsoft.com/en-us/research/wp-content/uploads/2017/10/program_synthesis_now.pdf)
- CVC4SY paper: [link](https://link.springer.com/chapter/10.1007/978-3-030-25543-5_5)
- `DynamicExpression.jl`: [link](https://ai.damtp.cam.ac.uk/dynamicexpressions/dev/)
- Our website: [link](https://herb-ai.github.io/)

## Project 2: HerbLearn Integration
**Difficulty:** Medium

**Estimated Duration:** 350h

**Problem description:**
Neurally-guided program synthesizers form a popular class of synthesizers, which learn a heuristic to guide program generation.
Following Herb's paradigm to unify the field, we want to reach the same goal for this sub-field.
Specifically, learning guiding policies comprise the same building blocks of 1. program sampling, 2. program-data-encoding, 3. policy learning with respect to a loss function, and 4. deploying that strategy.

In this project, we want to implement these building blocks to allow researchers to reuse the modules directly.
To guide this project, we implemented a template structure to follow and extend.

**Minimum goal:**
Implement a naive but modular strategy for all four steps.
To allow for easy integration of with existing models, we aim to implement the machine learning part using Flux.jl.

**Extended goal:**
The extended goal is to deepen one or more of these modules that fit the student's interests.
The literature provides numerous ideas on how to make all four steps smarter individually.
Concretely, this could include
- smarter program-sampling,
- different program encoding strategies from the literature,
- implementing and applying different loss functions, and
- incorporating this with different search procedures.

**Recommended skills:**
 - Basic knowledge of machine learning principles (neural networks, model training, ...)
 - Preferably prior experiences with Flux.jl

**Mentors:** Tilman Hinnerichs, Reuben Gardos-Reid and Sebastijan Dumancic

**Some literature:**
- The Program Synthesis book (by Gulwani et al., [link](https://www.microsoft.com/en-us/research/wp-content/uploads/2017/10/program_synthesis_now.pdf)
- Our website: [https://herb-ai.github.io/](https://herb-ai.github.io/)
- BUSTLE: Bottom-up Program Synthesis through learning-guided exploration: [link](https://arxiv.org/pdf/2007.14381)
- DeepCoder [link](https://arxiv.org/pdf/1611.01989)
- DreamCoder [link](https://dl.acm.org/doi/pdf/10.1145/3453483.3454080)
