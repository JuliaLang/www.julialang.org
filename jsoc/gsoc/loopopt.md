# Loop Optimization projects

LoopModels.jl uses an internal representation of loops that represents the iteration space of each constituent operation as well as their dependencies. The iteration spaces of inner loops are allowed to be affine functions of the outer loops, and multiple loops are allowed to exist at each level of a loopnest.
LoopModels.jl aims to support optimizations including fusion, splitting, permuting loops, unrolling, and vectorization to maximize throughput.
Broadly, this functionality can be divided into four pieces:
1. The internal representation of the loops (Loop IR).
2. Means of creating the internal representation from Julia code. This must be able to deconstruct and simplify user provided types into the primitive types representable by IR, e.g. decompose `ForwardDiff.Dual{T1,ForwardDiff.Dual{T2,Float64,N},M}` operations into operations on the underlying `Float64`.
3. Analyze the representation to determine an optimal, correct, and target-specific schedule.
4. Generate runnable code according to the schedule.

Open projects on this effort include:
## Improving and refining the IR and analysis
This can include refining the search, dependency analysis, and cost modeling.

## Develop the frontend to infer the loop structure
Develop the front end that infers the loop structure from Julia code, and creates the Loop IR.
This will likely live as a compiler plugin, but infrastrcture such as GPUCompiler.jl to interface more directly on the LLVM level is worth exploring, as this would allow taking advantage of LLVM's existing infrastrcture.

## Generating code
Code would be generated through LLVM.jl.
It must be able to follow the schedule determined by the optimization. The schedule is abstract, so care must still be taken to generate optimal code when following the schedule, e.g. to optimally keep track of the loop bounds, handle remainders, and indexing the arrays.

Mentors: [Chris Elrod](https://github.com/chriselrod).


