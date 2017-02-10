---
layout: post
title:  GPU development in the Julia programming language
author: <a href="https://github.com/maleadt">Tim Besard</a>
cudanative_tree: https://github.com/JuliaGPU/CUDAnative.jl/blob/6e6ec23ef4def367dec6ae0ba3e43f1d9daae7ec
cudadrv_tree: https://github.com/JuliaGPU/CUDAdrv.jl/blob/78a8d13044b19e41efd0424554a26ab8dd8983cf
---

[Julia](http://julialang.org/) is a dynamic programming language for technical computing,
with syntax that is familiar to users of other technical computing environments. The
language has been created with performance in mind, and combines careful language design
with a sophisticated LLVM-based compiler.

Julia is well regarded for programming multicore CPUs and large parallel computing systems,
but the tools for using Julia with GPUs are worth a look as well. In this blogpost, I will
list some of those packages but focus on the latest addition: native GPU programming with
CUDAnative.jl



## Available tools

The Julia package ecosystem contains quite a few GPU-related packages, targeting different
levels of abstraction. At the highest abstraction level, domain-specific packages like
[MXNet.jl](https://github.com/dmlc/MXNet.jl) or
[TensorFlow.jl](https://github.com/malmaud/TensorFlow.jl) can transparently use any
available GPUs. More generic development is possible with
[ArrayFire.jl](https://github.com/JuliaComputing/ArrayFire.jl), and if you need a
specialized implementation you can use wrappers for vendor-specific library packages
(cuBLAS, cuFFT, cuSPARSE, ...) available at the [JuliaGPU GitHub
organization](https://github.com/JuliaGPU/). Each of those packages is just a single
`Pkg.add(...)` away!

What's missing from this list is the lowest abstraction level, where you can write kernels
and manage execution like you would in CUDA. This is where CUDAnative.jl comes in.



## Native GPU programming with CUDAnative.jl

[CUDAnative.jl](https://github.com/JuliaGPU/CUDAnative.jl) is a brand-new package adding
native GPU programming capabilities to the Julia programming language. Together with a
package like [CUDAdrv.jl](https://github.com/JuliaGPU/CUDAdrv.jl) or
[CUDArt.jl](https://github.com/JuliaGPU/CUDArt.jl) for interfacing with the CUDA libraries,
it is now possible to do CUDA development in Julia without the need for an external language
or compiler. As an introductory example, the following listing shows how to compute the sum
of two vectors:

```julia
using CUDAdrv, CUDAnative

function kernel_vadd(a, b, c)
    i = (blockIdx().x-1) * blockDim().x + threadIdx().x
    c[i] = a[i] + b[i]

    return nothing
end

dev = CuDevice(0)
ctx = CuContext(dev)

# generate some data
len = 512
a = rand(Int, len)
b = rand(Int, len)

# allocate & upload on the GPU
d_a = CuArray(a)
d_b = CuArray(b)
d_c = similar(d_a)

# execute and fetch results
@cuda (1,len) kernel_vadd(d_a, d_b, d_c)
c = Array(d_c)

destroy(ctx)
```

The real workhorse of this example is the `@cuda` macro, which generates specialized code
for compiling the kernel function to GPU assembly, uploading it to the driver, and preparing
the execution environment. Together with Julia's JIT compiler, this results in a very
efficient kernel launch sequence, avoiding the runtime overhead typically associated with
dynamic languages. The generated code is also specific to the types of the arguments;
Calling the same kernel with differently typed arguments would Just Work.

<!-- Mention libNVVM? -->

Behind the scenes, CUDAnative.jl hooks into the Julia compiler to lower kernel functions to
LLVM IR, an intermediate representation used by the LLVM compiler framework. We've created
[LLVM.jl](https://github.com/maleadt/LLVM.jl) to interface with the framework, and use it to
compile IR to PTX code, the virtual instruction set used to program CUDA GPUs. Finally, we
use CUDAdrv.jl to interact with the CUDA driver: upload the PTX code, compile it to
hardware-specific Shader Assembly (SASS), and launch the kernel.

![Overview of the different components making up the native programming
support.](/images/blog/2017-01-24-cudanative/overview.png)

By reusing the Julia compiler to generate IR we avoid multiple language implementations with
slightly different semantics. That means you can use all features of the Julia language,
like metaprogramming or dynamically-typed multimethods, to implement GPU functions. There
are still [some limitations]({{page.cudanative_tree}}#julia-support) though. For example we
haven't ported Julia's runtime library or implemented a GPU garbage-collector yet. But these
aren't structural limitations, and we will work towards covering more of the language.


### Example: parallel reduction

For a more realistic example, we'll have a look at a parallel reduction [as documented on
this blog
before](https://devblogs.nvidia.com/parallelforall/faster-parallel-reductions-kepler/). The
Julia version is part of the [CUDAnative
examples]({{page.cudanative_tree}}/examples/reduce/reduce.jl) and too long to discuss in
full, so let's zoom in on some details instead. Listing 2 shows the innermost GPU function
responsible for reducing within a warp using shuffle instructions (slightly simplified for
readability's sake).

```julia
function reduce_warp(op, val)
    offset = CUDAnative.warpsize() ÷ 2
    while offset > 0
        val = op(val, shfl_down(val, offset))
        offset ÷= 2  % truncating division
    end
    return val
end
```

This function takes two arguments, a reduction operator function and a value to reduce. The
Julia compiler will generate specialized code based on the type of these arguments, avoiding
runtime overhead for checking dynamic types. Listing 3 shows the PTX code generated for this
function if we were to call it with the `+` operator and pass in a 32-bit integer (similar
tools exist to inspect the typed AST, LLVM IR, or even SASS code).

```
julia> CUDAnative.code_ptx(reduce_warp, (typeof(+), Int32))

.visible .func  (.param .b32 func_retval0) reduce_warp(
        .param .b32 param_0
)
{
        .reg .pred      %p<3>;
        .reg .s32       %r<14>;

        ld.param.u32    %r13, [param_0];
        mov.u32         %r9, WARP_SZ;
        shr.u32         %r12, %r9, 1;
        setp.eq.s32     %p1, %r12, 0;
        @%p1 bra        LBB0_2;
LBB0_1:
        shfl.down.b32 %r10, %r13, %r12, 31;
        add.s32         %r13, %r10, %r13;
        shr.u32         %r12, %r12, 1;
        setp.eq.s32     %p2, %r12, 0;
        @%p2 bra        LBB0_2;
        bra.uni         LBB0_1;
LBB0_2:
        st.param.b32    [func_retval0+0], %r13;
        ret;
}
```

Specialization is automatic, and empowers much of the generic code in Julia's standard
library. In the case of our example, it results in [clean and compact PTX
code]({{page.cudanative_tree}}/examples/reduce/reduce.jl.ptx) very similar to the [code
generated by `nvcc`]({{page.cudanative_tree}}/examples/reduce/reduce.cu.ptx).

But how does it perform? The chart below shows the minimum execution time of both
implementations as measured by [this benchmark
script]({{page.cudanative_tree}}/examples/reduce/benchmark.jl). The code generated by
CUDAnative.jl performs well for a large problem size, but there seems to be a constant
overhead (note the logarithmic scale). Luckily, there is an easy explanation: we haven't
fully implemented the NVVM ABI yet, and pass aggregate objects like the arrays in this
example by pointer. This requires extra memory allocations and copies, which synchronize the
GPU and slow down the kernel launch sequence.

![Performance comparison of parallel reduction
implementations.](/images/blog/2017-01-24-cudanative/performance.png)

We also aim to be compatible with existing tools from the CUDA toolkit. For example, we
generate the necessary line-number information for the NVIDIA Visual Profiler to [work as
expected](/images/blog/2017-01-24-cudanative/nvpp.png), and [wrap relevant API
functions]({{page.cudadrv_tree}}/src/profile.jl) to have more fine-grained control. The
line-number information also enables accurate backtraces in combination with tools like
`cuda-memcheck`:

```
$ cuda-memcheck julia examples/oob.jl
========= CUDA-MEMCHECK
========= Invalid __global__ write of size 4
=========     at 0x00000148 in examples/oob.jl:14:julia_memset_66041
=========     by thread (10,0,0) in block (0,0,0)
=========     Address 0x1020b000028 is out of bounds
```

Full debug information is not supported by the LLVM NVPTX back-end yet, so `cuda-gdb` and
friends will not work as well.

<!-- TODO: make sure profile.jl contains some more impressive code -->


### Future developments

Julia's combination of carefully-designed language semantics and a specializing JIT compiler
makes it possible to create abstractions without paying the price. CUDAnative.jl aims to
extend this to the GPU and make it possible to create high-performance GPU abstractions in a
high-level language. We aren't quite there yet — certain language features are not supported
or well-optimized, the standard library still needs to be integrated — but interesting new
developments are already appearing.

For example, the [GPUArrays.jl](https://github.com/JuliaGPU/GPUArrays.jl) package is a
playground for a vendor- and toolkit-agnostic array abstraction. It implements Julia's
higher-order functions, like `map` and `broadcast`, compiling user-code for the GPU in use.

Another powerful demonstration of Julia's capabilities is the proof-of-concept
[CUDAnativelib.jl](https://github.com/JuliaGPU/CUDAnativelib.jl), which makes it possible to
use device libraries from Julia GPU functions. It uses
[Cxx.jl](https://github.com/Keno/Cxx.jl) to parse and compile CUDA C header files, building
on Julia's powerful foreign function interface to generate the required calling sequences.
This will allow us to take advantage of native device libraries like
[cuRAND](http://docs.nvidia.com/cuda/curand/device-api-overview.html#device-api-overview).



## Try it out!

Many of the packages listed at the top of this post are relatively mature, and support a
wide range of platforms and Julia versions. CUDAnative.jl however, is still experimental and
does not offer the same level of compatibility yet. For example, we only support Linux and
macOS, and require a source-build of Julia. Head over to **this blogpost** <!-- TODO --> for
an overview of the (pretty easy) installation instructions.

If you're interested in using Julia for native GPU programming, please try out CUDAnative.jl
and let us know how you like it! While we will continue to improve platform support and
language compatibility, it's good to have feedback on real users and use-cases.
