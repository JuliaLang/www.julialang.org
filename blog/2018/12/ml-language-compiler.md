@def rss_pubdate = Date(2018, 12, 3)
@def rss_description = """ Building a Language and Compiler for Machine Learning | Since we originally proposed the need for a first-class language, compiler and ecosystem for machine learning (ML), there have been plenty of interesting developments in the field. Not only have the tradeoffs in existing systems, such as TensorFlow and PyTo... """
@def published = "3 December 2018"
@def title = "Building a Language and Compiler for Machine Learning"
@def authors = "Mike Innes, James Bradbury, Keno Fischer, Dhairya Gandhi, Neethu Mariya Joy, Tejan Karmali, Matt Kelley, Avik Pal, Marco Concetto Rudilosso, Elliot Saba, Viral Shah, Deniz Yuret"
@def hascode = true

Since we [originally proposed](/blog/2017/12/ml-pl/) the need for a first-class language, compiler and ecosystem for machine learning (ML), there have been plenty of interesting developments in the field. Not only have the tradeoffs in existing systems, such as TensorFlow and PyTorch, not been resolved, but they are clearer than ever now that both frameworks contain distinct [“static graph”](https://pytorch.org/docs/master/jit.html) and [“eager execution”](https://www.tensorflow.org/guide/eager) interfaces. Meanwhile, the idea of ML models fundamentally being differentiable algorithms – often called [differentiable programming](https://www.facebook.com/yann.lecun/posts/10155003011462143) – has caught on.

Where current frameworks fall short, several exciting new projects have sprung up that dispense with graphs entirely, to bring differentiable programming to the mainstream. [Myia](https://github.com/mila-udem/myia), by the Theano team, differentiates and compiles a subset of Python to high-performance GPU code. [Swift for TensorFlow](https://github.com/tensorflow/swift) extends Swift so that compatible functions can be compiled to TensorFlow graphs. And finally, the [Flux](https://github.com/FluxML/Flux.jl) ecosystem is extending Julia’s compiler with a number of ML-focused tools, including first-class gradients, just-in-time CUDA kernel compilation, automatic batching and support for new hardware such as TPUs.

All of these projects have enormous potential, but we think Julia has an edge. This post, based on our [paper to be presented at NeurIPS MLSys](https://arxiv.org/abs/1811.01457), will explore how we have used Julia to re-think ML tooling from the ground up, and provides some insight into the work that modern ML tools need to do.

\toc


## Enter Flux

We need a language to write differentiable algorithms, and Flux takes Julia to be this language. Being designed from the ground up for mathematical and numerical computing, Julia is unusually well-suited for expressing ML algorithms.  Meanwhile, its mix of modern design and new ideas in the compiler makes it easier to address the high performance needs of cutting edge ML.

Where typical frameworks are all-encompassing monoliths in hundreds of thousands of lines of C++, Flux is only a thousand lines of straightforward Julia code. Simply take [one package for gradients (Zygote.jl)](https://github.com/FluxML/Zygote.jl), [one package for GPU support (CuArrays.jl)](https://github.com/JuliaGPU/CuArrays.jl/), sprinkle with some light convenience functions, bake for fifteen minutes and out pops a fully-featured ML stack.

Like the other next-gen ML systems, Flux is committed to providing an intuitive (“eager” or “define-by-run”) interface, and takes a hard line against any kind of [graph building](https://www.tensorflow.org/guide/autograph) or [performance annotations](https://pytorch.org/docs/master/jit.html). We support all of the language's features, from control flow and data structures to macros. Users can code interactively in Jupyter notebooks and combine high-performance numerics with convenient plotting and visualisation. But we also want to get the benefits traditionally held by “static graph” frameworks – zero-overhead source-to-source AD, operator fusion, multi-GPU/distributed training, and single-binary deployment.

How can we do all this? Effectively, we need to extract and analyse “static graphs” directly from written Julia syntax, which is in fact the entirely normal job of a *compiler*. Most ML systems problems turn out to be standard and well-studied compiler problems, viewed through the right lens. Using a compiled language is enough to solve many issues, and extending that compiler is the best way to solve many more. We cover just a sample of our current work in this field – namely taking gradients, compiling for GPUs and TPUs, and automatic batching.

## Taking Gradients

Pushing the limits of reverse-mode differentiation, we have come to see this as a [language-level problem](https://arxiv.org/abs/1810.07951). Differentiation is a symbolic transformation, which is the domain of compilers. Existing frameworks achieve this by *tracing* (effectively a form of *partial evaluation* or *abstract interpretation*). A new tensor type is introduced which records all the basic mathematical operations performed, yielding a graph (or symbolic expression) with the control flow and data structures of the host language removed. However, this presents a difficult tradeoff: we either accept the overhead of an interpreter (eager execution) or freeze user control flow and limit the kinds of models that can be built (static graphs).

What if, instead, the “graph” were simply Julia’s own syntax? Taking this idea to its limit, we have built [Zygote](https://github.com/FluxML/Zygote.jl), which works directly on SSA-form IR and supports language features like control flow, recursion, data structures and macros. We can then put the generated SSA-form adjoint code through a compiler such as [LLVM](https://llvm.org/), and get all the benefits of traditional compiler optimization applied to both our forward and backwards passes. In addition, this approach opens the opportunity to extend that compiler infrastructure with more advanced and domain-specific optimizations, such as kernel fusion and compilation to accelerators such as TPUs. Similar approaches are being explored by the [Swift for TensorFlow](https://gist.github.com/rxwei/30ba75ce092ab3b0dce4bde1fc2c9f1d) and [Myia](https://arxiv.org/abs/1810.11530) developers in a renaissance of source-to-source AD techniques.

A key advantage of Julia for this task is that it can be used to implement fundamental numerical libraries, like [differential equations solvers](https://sciml.ai/) or [optimisation libraries](https://github.com/JuliaOpt/JuMP.jl); this neatly solves a growing need in the ML community, in which researchers backpropagate through high-performance code such as [ray tracers](https://people.csail.mit.edu/tzumao/diffrt/) and [physics engines](https://arxiv.org/abs/1611.01652), but the gradients must still be implemented by hand in C++. In contrast, since Julia’s implementations are written in Julia, everything from [ODEs](https://github.com/FluxML/model-zoo/blob/a243e8b192236c30064fcdb7a36f17f3b6823c34/other/diffeq/diffeq.jl) to [financial pricing models](https://wilmott.com/automatic-for-the-greeks/) can be differentiated with ease. Bringing these powerful tools into models is where deep learning truly becomes differentiable programming.

## Compiling Julia for GPUs

GPU programming is an essential part of modern ML. But the GPU is often treated as an implementation detail; frameworks provide kernels internally, but the user only sees a limited set of mathematical operations and can’t program the GPU directly. In contrast, GPU programming in Julia is [first-class](https://devblogs.nvidia.com/gpu-computing-julia-programming-language/) all the way down to CUDA kernels (which can happily be written and run from a script or notebook).

A simple vector addition kernel looks similar to the CUDA C equivalent.

    function kernel_vadd(a, b, c)
        i = (blockIdx().x-1) * blockDim().x + threadIdx().x
        c[i] = a[i] + b[i]
        return
    end

However, Julia's type specialization enables a powerful set of additional abstractions on the GPU. For example, the code above is not restricted to dense arrays of floats, and could instead be given sparse arrays of complex numbers; Julia's normal specialization mechanisms would generate a new set of PTX instructions on the fly. We can even abstract this code further into a “higher-order kernel” that accepts the `+` function (or `*`, or arbitrary user-defined `f`) and thus create a whole family of functions `map(f, x, y)` in [four lines of code](https://mikeinnes.github.io/2017/08/24/cudanative.html).

This enables some powerful tricks, even if you never write CUDA code yourself. For example, we can transparently fuse a large broadcast expression like `1 / (1 + exp(-x))`, *and* its backwards pass, into a single GPU kernel, getting [significant speedups](https://arxiv.org/abs/1810.08297). We expect the native GPU code generation capabilities and ecosystem will power various Julia based machine learning libraries going forward.

## Julia on TPUs

Taking this one step further, Google recently opened up the XLA IR used by their Cloud TPUs, making it possible for both other frameworks and users outside of ML to take advantage of this heavyweight hardware. XLA is powerful but limited: it can’t run a Python interpreter, certainly not with good performance. Frameworks then end up in a similar position as with gradients – they have no choice but to [use program tracing](https://github.com/google/jax) to pry away the Python, and end up with a fast but much more limited ML language.

[Our response is predictable](https://arxiv.org/abs/1810.09868): we only need to extract the “static graph” from written Julia programs and compile it directly to XLA, allowing Julia itself to run on TPUs. (In fact, this is just a simple extension of Julia’s usual compilation process, which extracts the largest possible “static subgraphs” from your program before sending them to LLVM.) This lets us take full advantage of the expressiveness of the Julia language, including control flow, recursion, multiple dispatch, higher-order functions, powerful data structures and abstractions, custom numeric types, and existing packages like differential equations solvers and linear algebra routines. All of this runs while reaping the benefits of the high-performance systolic array engine within the TPU. You can [try it today](https://github.com/JuliaTPU/XLA.jl), with examples for both [large ML models like ResNet](https://github.com/JuliaTPU/XLA.jl/blob/d04c5914bc0d9f7d7fed68233f167d5b67003f7f/examples/resnet/resnet.jl) and [linear algebra routines like TSVD](https://github.com/JuliaTPU/XLA.jl/blob/d04c5914bc0d9f7d7fed68233f167d5b67003f7f/examples/tsvd.jl).

## Automatic Batching

To get the most from these accelerators – which can have significant overheads per kernel launch, but scale very well over input size – it is common to *batch* programs, applying the forwards and backwards passes to multiple training examples at once. In simple cases, such as with convolutional nets, it’s simple to handle this by concatenating, say, 10 images along an extra batch dimension. But this task becomes much harder when dealing with variably-structured inputs, such as trees or graphs.

Most researchers address this by taking on the significant burden of batching code by hand. Different solutions have been proposed for different frameworks ([DyNet](https://dynet.readthedocs.io/en/latest/tutorials_notebooks/Autobatching.html),  [TensorFlow Fold](https://github.com/tensorflow/fold), which heuristically try to batch some high level operations together when possible, but these typically either have their own usability issues or do not achieve the performance of hand-written code.

We suggest that this problem is identical to that of Single Program Multiple Data (SPMD) programming, which has been [well-studied](https://www.cs.cmu.edu/afs/cs.cmu.edu/Web/People/blelloch/papers/Ble90.pdf) by the language and compiler community for decades, and becomes visible in more recent approaches to batching like [matchbox](https://github.com/salesforce/matchbox). Indeed, it is very similar to the model of parallelism used by GPUs internally, and has been implemented as a compiler transform for the [SIMD units of CPUs](https://ispc.github.io/). Taking inspiration from this work, we are implementing the [same transform](http://compilers.cs.uni-saarland.de/projects/wfv/) in Julia to provide SPMD programming both for scalar SIMD units and for model-level batching. This allows us to reach the ideal of writing simple code that operates on individual samples, while still getting the best performance on modern hardware.

## Conclusion

We believe that the future of machine learning rests in language and compiler technology, and in particular, in extending new or existing languages to meet the high demands of ML research. This is good not just for the ML community, but for numerical programming in general; languages that can support differentiation, vectorisation and exotic hardware well will be powerful enough to drive many advancements in science.

There is some way to go before these next-generation tools – Myia, Swift/TF and [Flux](https://fluxml.ai) – are as production-ready as their existing framework counterparts, TensorFlow, PyTorch, and [Knet](https://github.com/denizyuret/Knet.jl). But if you’re breaking new ground in ML, they might well be your best bet. Give them a go, and see what the future of machine learning looks like.
