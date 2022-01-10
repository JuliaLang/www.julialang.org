
# Web Platform Projects – Summer of Code

Julia has early support for targeting WebAssembly and running in the web browser. Please note that this is a rapidly moving area (see the [project repository](https://github.com/Keno/julia-wasm) for a more detailed overview), so if you are interested in this work, please make sure to inform yourself of the current state and talk to us to scope out an appropriate project. The below is intended as a set of possible starting points.

Mentor for these projects is [Keno Fischer](https://github.com/Keno) unless otherwise stated.

## Code generation improvements and async ABI

Because Julia relies on an asynchronous task runtime and WebAssembly currently lacks native support for stack management, Julia needs to explicitly manage task stacks in the wasm heap and perform a compiler transformation to use this stack instead of the native WebAssembly stack. The overhead of this transformation directly impacts the performance of Julia on the wasm platform. Additionally, since all code Julia uses (including arbitrary C/C++ libraries) must be compiled using this transformation, it needs to cover a wide variety of inputs and be coordinated with other users having similar needs (e.g. the Pyodide project to run python on the web). The project would aim to improve the quality, robustness and flexibility of this transformation.

**Recommended Skills**: Experience with LLVM.

## Wasm threading

WebAssembly is in the process of standardizing [threads](https://github.com/WebAssembly/threads). Simultaneously, work is ongoing to introduce a new threading runtime in julia (see [#22631](https://github.com/JuliaLang/julia/pull/22631) and replated PRs). This project would investigate enabling threading support for Julia on the WebAssembly platform, implementing runtime parallel primitives on the web assembly platform and ensuring that high level threading constructs are correctly mapped to the underlying platform. Please note that both the WebAssembly and julia threading infrastructure is still in active development and may continue to change over the duration of the project. An informed understanding of the state of these projects is a definite prerequisite for this project.

**Recommended Skills**: Experience with C and multi-threaded programming.

## High performance, Low-level integration of js objects

WebAssembly is in the process of adding [first class references to native objects](https://github.com/WebAssembly/reference-types) to their specification. This capability should allow very high performance integration between julia and javascript objects. Since it is not possible to store references to javascript objects in regular memory, adding this capability will require several changes to the runtime system and code generation (possibly including at the LLVM level) in order to properly track these references and emit them either as direct references to as indirect references to the reference table.

**Recommended Skills**: Experience with C.

## DOM Integration

While julia now runs on the web platform, it is not yet a language that's suitable for first-class development of web applications. One of the biggest missing features is integration with and abstraction over more complicated javascript objects and APIs, in particular the DOM. Inspiration may be drawn from similar projects in [Rust](https://github.com/koute/stdweb) or other languages.

**Recommended Skills**: Experience with writing libraries in Julia, experience with JavaScript Web APIs.

## Porting existing web-integration packages to the wasm platform

Several Julia libraries (e.g. WebIO.jl, Escher.jl) provide input and output capabilities for the web platform. Porting these libraries to run directly on the wasm platform would enable a number of existing UIs to automatically work on the web.

**Recommended Skills**: Experience with writing libraries in Julia.

## Native dependencies for the web

The Julia project uses [BinaryBuilder](https://github.com/JuliaPackaging/BinaryBuilder.jl) to provide binaries of native dependencies of julia packages. Experimental support exists to extend this support to the wasm platform, but few packages have been ported. This project would consist of attempting to port a significant fraction of the binary dependencies of the julia ecosystem to the web platform by improving the toolchain support in BinaryBuilder or (if necessary), porting upstream packages to fix assumptions not applicable on the wasm platform.

**Recommended Skills**: Experience with building native libraries in Unix environments.

## Distributed computing with untrusted parties

The Distributed computing abstractions in julia provide convenient abstraction for implementing programs that span many communicating julia processes on different machines. However, the existing abstractions generally assume that all communicating processes are part of the same trust domain (e.g. they allow messages to execute arbitrary code on the remote). With some of the nodes potentially running in the web browser (or multiple browser nodes being part of the same distributed computing cluster via WebRPC), this assumption no longer holds true and new interfaces need to be designed to support multiple trust domains without overly restricting usability.

**Recommended Skills**: Experience with distributed computing and writing libraries in Julia.

## Deployment

Currently supported use cases for julia on the web platform are primarily geared towards providing interactive environments to support exploration of the full language. Of course, this leads to significantly larger binaries than would be required for using Julia as part of a production deployment. By disabling dynamic language features (e.g. eval) one could generate small binaries suitable for deployment. Some progress towards this exists in packages like [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl), though significant work remains to be done.

**Recommended Skills**: Interest in or experience with Julia internals.

