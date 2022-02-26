# Loop Optimization projects

LoopModels is the successor to [LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl), supporting more sophisticated analysis and transforms so that it may correctly optimize a much broader set of loop nests. It uses an internal representation of loops that represents the iteration space of each constituent operation as well as their dependencies. The iteration spaces of inner loops are allowed to be functions of the outer loops, and multiple loops are allowed to exist at each level of a loopnest.
LoopModels aims to support optimizations including fusion, splitting, permuting loops, unrolling, and vectorization to maximize throughput.
Broadly, this functionality can be divided into five pieces:
1. The Julia interface / support for custom LLVM pipelines.
2. The internal representation of the loops (Loop IR).
3. Building the internal representation from LLVM IR.
4. Analyze the representation to determine an optimal, correct, and target-specific schedule.
5. Transform the IR according to the schedule.

Open projects on this effort include:
## Developing a Julia plugin/frontend allowing the application of a custom compiler pipeline
**Difficulty**: Hard.

**Description**: In order to be able to use LoopModels from Julia, we must be able to apply a custom pass pipeline.
This is likely something other packages will want to be able to do in the future, and something some packages ([Enzyme.jl](https://github.com/wsmoses/Enzyme.jl)) do already. In this project, your aim will be to create a package that provides infrastructure others can 
depend on to simplify applying custom pass pipelines.

**Expected Results**: Register a package that allows applying custom LLVM pass pipelines to Julia code.

**Skills**: Julia programming, preferably with some understanding of Julia's IR. Prior familiarity with libraries such as [GPUCompiler](https://github.com/JuliaGPU/GPUCompiler.jl) and [StaticCompiler](https://github.com/tshort/StaticCompiler.jl) a bonus.

**Expected Length**: 175 hours.

## Developing Loop Models (350 hours):
**Difficulty**: Medium.

**Description**: This is open ended, with many potential projects here. These range from using [Presburger arithmetic](https://dl.acm.org/doi/10.1145/3485539) to [support decidable polyhedral modeling](https://lirias.kuleuven.be/retrieve/361209), working on canonicalizations to handle more kinds of loops frequently encountered from Julia (e.g. from `CartesianIndicies`), modeling the costs of different schedules, to efficiently searching the iteration space and find the fastest way to evaluate a loop nest. We can discuss your interests and find a task you'll enjoy and make substantive contributions to.

**Expected Results**: Help develop some aspect of the loop modeling and/or optimization.

**Skills**: C++, knowledge of LLVM, loop optimization, SIMD, and optimizing compute kernels such as GEMM preferred. A passion for performance is a must!

**Expected Length**: 350 hours.

Mentors: [Chris Elrod](https://github.com/chriselrod), [Yingbo Ma](https://github.com/YingboMa).


