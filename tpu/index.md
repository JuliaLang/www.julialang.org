---
layout: default
title: Julia on TPUs
---

# Julia on TPUs

Google’s [Cloud TPUs](https://cloud.google.com/tpu/) are a promising
new hardware architecture for machine learning and possibly other
mathematical workloads. They have powered achievements in the recent
years such as [Android
Speech](https://www.wired.com/2017/04/building-ai-chip-saved-google-building-dozen-new-data-centers/),
[DeepMind's AlphaGo](https://deepmind.com/research/alphago/) and
[AlphaZero](https://en.wikipedia.org/wiki/AlphaZero).

Julia is now capable of offloading suitable sections of Julia programs
to TPUs via the [XLA compiler](https://www.tensorflow.org/xla/). Julia
can currently completely fuse the forward pass of a VGG19 model into a
single TPU executable to be offloaded to the device. The Julia approach
composes well with existing compiler-based automatic differentiation
techniques on Julia code, and it is thus able to also automatically
obtain the VGG19 backwards pass and similarly offload it to the
TPU.

The paper by Keno Fischer and Elliot Saba, [Automatic Full Compilation
of Julia Programs and ML Models to Cloud
TPUs](https://arxiv.org/abs/1810.09868) describes the compiler in
detail.

# Performance

Performance chart from the paper above:
```
                  N     1       10     100
==============================================
           Flux CPU   0.79s   6.67s   52.4s
        PyTorch CPU   1.16s   9.55s   93.0s
         FluXLA CPU  12.06s  64.80s >600.0s
  FluXLA TPU (total)  0.86s   0.74s    0.9s
FluXLA TPU (compute)  0.02s   0.04s    0.2s
```

# Run on CPU

The source code for the Julia TPU compiler lives in
[XLA.jl](https://github.com/JuliaTPU/XLA.jl) in the
[JuliaTPU](https://github.com/JuliaTPU) Github organization.

## Setup

```
git clone git@github.com:JuliaTPU/XLA.jl.git XLA.jl
cd XLA.jl
julia --project=.
<Instantiate and update projects>
```

## Run the `xrt_server`
```
using TensorFlow
using XLA
run(`$(joinpath(dirname(pathof(TensorFlow)),"..","deps","downloads","bin","xrt_server"))`)
```

## Run the client
```
julia> using TensorFlow

julia> using XLA

julia> pop!(Base.Multimedia.displays)

julia> sess = Session(Graph(); target="grpc://localhost:8470")
Session(Ptr{Nothing} @0x00007facd2d910b0)

julia> x = XRTArray(rand(3,3))
3×3 XRTArray{Float64,(3, 3),2}:
 0.446645  0.035088   0.460987
 0.671569  0.643864   0.95108
 0.351924  0.0643237  0.0961697
```

# Run on GPU




# Run on TPU




# Comments

Discuss your experiences and ideas for Julia on TPUs on the [Julia Discourse](https://discourse.julialang.org).
