# JuliaGenerativeAI Projects

[JuliaGenerativeAI](https://github.com/JuliaGenerativeAI) is an organization focused on advancing Generative AI research and looking for its applications within the Julia programming language ecosystem. Our community comprises AI researchers, developers, and enthusiasts passionate about pushing the boundaries of Generative AI using Julia's high-performance capabilities. We strive to create innovative tools and solutions that leverage the unique strengths of Julia in handling complex AI challenges.

There is a high overlap with organizations, you might be also interested in:
- [Projects with MLJ.jl](https://julialang.org/jsoc/gsoc/MLJ/) - For more traditional machine learning projects
- [Projects in Reinforcement Learning](https://julialang.org/jsoc/gsoc/machine-learning/) - For projects around AlphaZero.jl
- [Projects with FluxML](https://fluxml.ai/gsoc/) - For projects around Flux.jl, the backbone of Julia's deep learning ecosystem

## Large Language Model Projects

### Project 1: Enhancing llama2.jl with GPU Support

**Description:** [Llama2.jl](https://github.com/cafaxo/Llama2.jl) is a Julia native port for Llama architectures, originally based on [llama2.c](https://github.com/karpathy/llama2.c). This project aims to enhance Llama2.jl by implementing GPU support through KernelAbstraction.jl, significantly improving its performance.

- **Mentor:** [Cameron Pfiffer](https://github.com/cpfiffer)
- **Difficulty**: Hard
- **Duration**: 350 hours
- **Suggested Skills and Background**: 
  - Proficiency in Julia programming
  - Understanding of GPU computing, ideally, some experience with KernelAbstractions.jl
- **Expected Outcomes:** 
  - Implementation of GPU support in llama2.jl
  - Comprehensive documentation and examples demonstrating the performance improvements
  - Contribution to llama2.jl's existing codebase and documentation

### Project 2: Llama.jl - Low-level C interface

**Description:** [Llama.jl](https://github.com/marcom/Llama.jl) is a Julia interface for [llama.cpp](https://github.com/ggerganov/llama.cpp) that powers many open-source tools today. It's currently leveraging only the high-level binaries. This project focuses on generating a low-level C interface to llama.cpp, enabling native access to internal model states, which would open incredible research opportunities and attractive applications (eg, constraint generation, novel sampling algorithms, etc.)

- **Mentor:** [Cameron Pfiffer](https://github.com/cpfiffer)
- **Difficulty**: Hard
- **Duration**: 175 hours
- **Suggested Skills and Background**: 
  - Proficiency in Julia and C programming
- **Expected Outcomes:** 
  - Creation of a low-level C interface for llama.cpp

### Project 4: Llama.jl - GPU Support Enhancements
**Description:** Llama.jl is a Julia interface for [llama.cpp](https://github.com/ggerganov/llama.cpp) that powers many open-source tools today. It's currently leveraging only the high-level binaries. This project focuses on improving the GPU support on non-MacOS platforms (eg, CUDA, ROCm), enabling GPU support for more users.

- **Mentor:** [Mentor's Name and Contact]
- **Difficulty**: Hard
- **Duration**: 175 hours
- **Suggested Skills and Background**: 
  - Experience with CUDA and GPU computing
  - Experience with cross-platform development (eg, BinaryBuilder.jl)
- **Expected Outcomes:** 
  - Extension of GPU support to additional platforms

### Project 5: AIHelpMe.jl - Enhancing LLM's Julia Knowledge

**Description:** Julia is a low-resource language (ie, not well represented in GenAI training data), so any methods that can bring more precise context or more up-to-date sources are extremely important. AIHelpMe.jl aims to enhance any model's knowledge by injecting the relevant knowledge (eg, Julia code snippets) into the query. The project involves growing the embedded knowledge base and tuning the performance of the Q&A pipeline underpinning all answers.

- **Mentor:** [Jan Siml](https://github.com/svilupp) -- looking for co-mentors?
- **Difficulty**: Medium
- **Duration**: 175 hours
- **Suggested Skills and Background**: 
  - Familiarity with Julia
  - Basic understanding of RAG optimization techniques
- **Expected Outcomes:** 
  - Expansion of the embedded knowledge base
  - At least a +10% improvement on the golden Q&A dataset

### Project 6: Native Julia Implementation of ColBERT v2 for Document Retrieval

**Description:** This project involves translating [ColBERT v2](https://github.com/stanford-futuredata/ColBERT), a document retrieval and re-ranking framework, to run natively in Julia. The goal would be to integrate it with AIHelpMe.jl, improving performance and reducing costs.

- **Mentor:** [Jan Siml](https://github.com/svilupp) -- looking for co-mentors?
- **Difficulty**: Hard
- **Duration**: 350 hours
- **Suggested Skills and Background**: 
  - Familiarity with transformer architecture and Flux.jl (/Transformers.jl)
  - Experience in document retrieval and re-ranking algorithms
- **Expected Outcomes:** 
  - Successful translation of ColBERT v2 to native Julia
  - Integration with AIHelpMe.jl
  - Registration of the working package

### Project 7: PromptCompiler.jl - Declarative Interface for GenAI Applications

**Description:** The goal of PromptCompiler.jl is to port [DSPy](https://github.com/stanfordnlp/dspy) to Julia, offering a more user-friendly and efficient way to write complex Generative AI pipelines and programs, leveraging Julia's metaprogramming capabilities.

- **Mentor:** [Jan Siml](https://github.com/svilupp) -- looking for co-mentors?
- **Difficulty**: Medium
- **Duration**: 175 hours
- **Suggested Skills and Background**: 
  - Familiarity with prompt engineering
  - Ability to read Python code (for [DSPy](https://github.com/stanfordnlp/dspy))
  - Ideally, experience with metaprogramming in Julia
- **Expected Outcomes:** 
  - Porting of DSPy to Julia
  - Development of at least 2 optimizers and 3 modules
  - Registration of the working

### Project 8: JuliaEval - Building Julia Coding Challenges for Generative AI Fine-Tuning

**Description:** Inspired by [HumanEval](https://github.com/openai/human-eval), JuliaEval aims to create a comprehensive set of Julia coding challenges, along with their solutions, akin to HumanEval. This project is crucial for fine-tuning Generative AI models specifically in the Julia language. It will not only enhance the capabilities of these models in Julia coding tasks but also serve as a valuable resource for the broader community to incorporate into their training pipelines.

- **Mentor:** [Jan Siml](https://github.com/svilupp) -- looking for co-mentors?
- **Difficulty**: Medium
- **Duration**: 175 hours
- **Suggested Skills and Background**: 
  - Proficiency in Julia programming
- **Expected Outcomes:** 
  - Development of a robust set of Julia coding challenges, covering a wide range of difficulty levels and topics
  - Comprehensive solutions and explanations for each challenge