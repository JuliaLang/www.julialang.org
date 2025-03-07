# GPU Projects - Summer of Code

[JuliaGPU](https://github.com/JuliaGPU) provides a suite of packages for programming GPUs in Julia. We have support for AMD, NVIDIA and Intel GPUs through various backends, unified by high-level array abstractions and a common programming model based on kernel programming.

## Improving GPU Stack Portability

**Difficulty:** Medium

**Duration:** 175 or 350 hours (the scope of functionality to port can be adjusted accordingly)

**Description:** The Julia GPU stack consists of several layers, from low-level vendor-specific packages like CUDA.jl to high-level abstractions like GPUArrays.jl. While the high-level packages aim to be vendor-agnostic, many optimized operations are still implemented in vendor-specific ways. This project aims to improve portability by moving these implementations to GPUArrays.jl using KernelAbstractions.jl.

The project will involve:
- Identifying vendor-specific kernel implementations in packages like CUDA.jl
- Porting these kernels to KernelAbstractions.jl in GPUArrays.jl
- Improving KernelAbstractions.jl where needed to support these kernels
- Ensuring performance remains competitive with vendor-specific implementations
- Adding tests to verify correctness across different GPU backends

**Required Skills:**
- Experience with Julia programming
- Familiarity with GPU programming concepts
- Experience with GPU programming in Julia is a plus
- Understanding of performance optimization

**Expected Results:** A set of optimized GPU kernels in GPUArrays.jl that are vendor-agnostic and performant across different GPU backends. This will improve the portability of the Julia GPU stack and make it easier to support new GPU architectures.

**Mentors:** [Tim Besard](https://github.com/maleadt), [Valentin Churavy](https://github.com/vchuravy)
