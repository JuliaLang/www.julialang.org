# JuliaGenAI Projects

[JuliaGenAI](https://github.com/JuliaGenAI) is an organization focused on advancing Generative AI research and looking for its applications within the Julia programming language ecosystem. Our community comprises AI researchers, developers, and enthusiasts passionate about pushing the boundaries of Generative AI using Julia's high-performance capabilities. We strive to create innovative tools and solutions that leverage the unique strengths of Julia in handling complex AI challenges.

There is a high overlap with organizations, you might be also interested in:
- [Projects with MLJ.jl](https://julialang.org/jsoc/gsoc/MLJ/) - For more traditional machine learning projects
- [Projects in Reinforcement Learning](https://julialang.org/jsoc/gsoc/machine-learning/) - For projects around AlphaZero.jl
- [Projects with FluxML](https://fluxml.ai/gsoc/) - For projects around Flux.jl, the backbone of Julia's deep learning ecosystem

## Large Language Model Projects

### Project 1: Enhancing llama2.jl with GPU Support

**Project Overview:** [Llama2.jl](https://github.com/cafaxo/Llama2.jl) is a Julia native port for Llama architectures, originally based on [llama2.c](https://github.com/karpathy/llama2.c). This project aims to enhance Llama2.jl by implementing GPU support through KernelAbstraction.jl, significantly improving its performance.

**Mentor:** [Cameron Pfiffer](https://github.com/cpfiffer)

**Project Difficulty**: Hard

**Estimated Duration**: 350 hours

**Ideal Candidate Profile:**
- Proficiency in Julia programming
- Understanding of GPU computing
- Experience with KernelAbstractions.jl

**Project Goals and Deliverables:**
- Implementation of GPU support in llama2.jl
- Comprehensive documentation and examples demonstrating the performance improvements
- Contribution to llama2.jl's existing codebase and documentation

### Project 2: Llama.jl - Low-level C interface

**Project Overview:** [Llama.jl](https://github.com/marcom/Llama.jl) is a Julia interface for [llama.cpp](https://github.com/ggerganov/llama.cpp) that powers many open-source tools today. It's currently leveraging only the high-level binaries. This project focuses on generating a low-level C interface to llama.cpp, enabling native access to internal model states, which would open incredible research opportunities and attractive applications (eg, constraint generation, novel sampling algorithms, etc.)

**Mentor:** [Cameron Pfiffer](https://github.com/cpfiffer)

**Project Difficulty**: Hard

**Estimated Duration**: 175 hours

**Ideal Candidate Profile:**
  - Proficiency in Julia and C programming

**Project Goals and Deliverables:**
- Auto-generated C interface for tokenization and sampling functionality
- Access to internal model states in llama.cpp during token generation
- Ability to generate text from a given model state

### Project 3: Supercharging the Knowledge Base of AIHelpMe.jl

**Project Overview:**

Julia stands out as a high-performance language that's essential yet underrepresented in GenAI training datasets. AIHelpMe.jl is our ambitious initiative to bridge this gap by enhancing Large Language Models' (LLMs) understanding of Julia by providing this knowledge via In-Context Learning (RAG, prompting). This project focuses on expanding the embedded knowledge base with up-to-date, context-rich Julia information and optimizing the Q&A pipeline to deliver precise, relevant answers. By injecting targeted Julia code snippets and documentation into queries, AIHelpMe.jl aims to significantly improve the accuracy and utility of generative AI for Julia developers worldwide.

**Mentor:** [Jan Siml](https://github.com/svilupp) / `@svilup` on JuliaLang Slack

**Project Difficulty:** Medium

**Estimated Duration:** 175 hours

**Who Should Apply:**
- Individuals with a solid grasp of the Julia programming language who are eager to deepen their involvement in the Julia and AI communities.
- Applicants should have a foundational understanding of Retrieval-Augmented Generation (RAG) optimization techniques and a passion for improving AI technologies.

**Project Goals and Deliverables:**

1. **Knowledge Base Expansion:** Grow the AIHelpMe.jl knowledge base to include comprehensive, up-to-date resources from critical Julia ecosystems such as the Julia documentation site, DataFrames, Makie, Plots/StatsPlots, the Tidier-verse, SciML, and more. See [Issue #3 on AIHelpMe.jl's GitHub](https://github.com/svilupp/AIHelpMe.jl/issues/3). This expansion is crucial for enriching the context and accuracy of AI-generated responses related to Julia programming.
   
2. **Performance Tuning:** Achieve at least a 10% improvement in accuracy and relevance on a golden Q&A dataset, refining the AIHelpMe.jl Q&A pipeline for enhanced performance.

### Project 4: Enhancing Julia's AI Ecosystem with ColBERT v2 for Efficient Document Retrieval

**Project Overview:**

Dive into the forefront of generative AI and information retrieval by bringing ColBERT v2, a cutting-edge document retrieval and re-ranking framework, into the Julia programming world. This initiative aims not only to translate ColBERT v2 to operate natively in Julia but to seamlessly integrate it with AIHelpMe.jl (and other downstream libraries). This integration promises to revolutionize the way users interact with AI by offering locally-hosted, more cost-efficient and highly performant document search capabilities. By enabling this sophisticated technology to run locally, we reduce dependency on large-scale commercial platforms, ensuring privacy and control over data, while maintaining minimal memory overheads.

**Mentor:** [Jan Siml](https://github.com/svilupp) `@svilup` on JuliaLang Slack

**Project Difficulty:** Hard

**Estimated Duration:** 350 hours

**Ideal Candidate Profile:**
- Solid understanding of transformer architectures, with proficiency in Flux.jl or Transformers.jl.
- Experience in semantic document retrieval (or with Retrieval-Augmented Generation applications), and a keen interest in pushing the boundaries of AI technology.
- A commitment to open-source development and a passion for contributing to an evolving ecosystem of Julia-based AI tools.

**Project Goals and Expected Outcomes:**

1. **Native Julia Translation of ColBERT v2:** Successfully adapt ColBERT v2 to run within the Julia ecosystem. Focus is only the indexing and retrieval functionality of ColBERT v2, eg, the Retrieval and Indexing snippets you see in the [Example Usage Section](https://github.com/stanford-futuredata/ColBERT). For guidance, refer to the existing Indexing and Retrieval examples.

2. **Integration with AIHelpMe.jl:** Seamlessly integrate as one of the embedding and retrieval backends AIHelpMe.jl (defined in PromptingTools.jl).

3. **Package Registration and Documentation:** Register the fully functional package within the Julia ecosystem, accompanied by comprehensive documentation and usage examples to foster adoption and contribution from the community.

### Project 5: Integrating Standard Prompt Schemas into PromptingTools.jl

**Project Overview:**

PromptingTools.jl stands at the cutting edge of generative AI within the Julia ecosystem. This project involves enhancing the support for various backends by providing more prompt templates (schemas) for users to leverage. This initiative directly responds to [Issue #67 on PromptingTools.jl's GitHub](https://github.com/svilupp/PromptingTools.jl/issues/67). Successful completion of this project will significantly enhance the usability of PromptingTools.jl, making it an indispensable tool for developers working with open-source LLM. By contributing, participants will play a key role in advancing Julia's AI capabilities, ensuring the community remains at the forefront of technological innovation.

**Mentor:** [Jan Siml](https://github.com/svilupp) `@svilup` on JuliaLang Slack

**Project Difficulty:** Medium

**Estimated Duration:** 175 hours

**Ideal Candidate Profile:**
- Individuals with a solid grasp of the Julia programming language who are eager to deepen their involvement in the Julia and AI communities.
- Experience with open-source large language models (eg, llama.cpp, vLLM) and with prompt templating (eg, Llama instruction template).

**Project Goals and Deliverables:**

1. **Schema Integration:** Implement common prompt schemas as dedicated types (similar to `OpenAISchema`). See details [here](https://github.com/svilupp/PromptingTools.jl/issues/67).
   
2. **Functionality Extension:** Provide methods for `render` and `aigenerate` functions to enable users to render conversations in these templates. Including clear examples, documentation and testing.


### Project 5: Enhancing PromptingTools.jl with Advanced Schema Support and Functionality

**Project Overview:**

PromptingTools.jl, a key tool in the Julia GenAI ecosystem. This project is a concerted effort to broaden the utility and applicability of PromptingTools.jl by incorporating a wider array of prompt templates and schemas, thereby catering to a diverse set of LLM backends. The initiative directly corresponds to [Issue #67](https://github.com/svilupp/PromptingTools.jl/issues/67) and [Issue #68](https://github.com/svilupp/PromptingTools.jl/issues/68) on PromptingTools.jl's GitHub. By enhancing the library's functionality to support structured extraction with the Ollama backend and introducing more standardized prompt schemas, we aim to make PromptingTools.jl an even more powerful and indispensable resource for developers engaging with open-source Large Language Models (LLMs).

**Mentor:** [Jan Siml](https://github.com/svilupp) / `@svilup` on JuliaLang Slack

**Project Difficulty:** Medium

**Estimated Duration:** 175 hours

**Ideal Candidate Profile:**
- Proficient in Julia with a commitment to the advancement of the Julia AI ecosystem.
- Experience with open-source LLMs, such as llama.cpp and vLLM, and familiarity with prompt engineering concepts.

**Project Goals and Deliverables:**

1. **Schema Integration and Functionality Enhancement:** Implement and integrate a variety of common prompt schemas (see details in [Issue #67](https://github.com/svilupp/PromptingTools.jl/issues/67)). Develop methods for the `render` and `aigenerate` functions that enable easy use and rendering of these templates, complete with comprehensive documentation, examples, and tests.

2. **Structured Extraction Support:** Add `aiextract` support for the Ollama backend, as currently, this functionality is not supported. This involves creating methods and templates that facilitate structured data extraction, thereby broadening the use cases and efficiency of interacting with AI models through PromptingTools.jl.
