# JuliaHealth Projects – Summer of Code

JuliaHealth is an organization dedicated to improving healthcare by promoting open-source technologies and data standards.
Our community is made up of researchers, data scientists, software developers, and healthcare professionals who are passionate about using technology to improve patient outcomes and promote data-driven decision-making.
We believe that by working together and sharing our knowledge and expertise, we can create powerful tools and solutions that have the potential to transform healthcare.

## General Ecosystem

### A Generalized RAG LLM-Workflow Support Tool for JuliaHealth

**Description:**
HealthLLM.jl is a Retrieval-Augmented Generation (RAG) framework that provides a foundation for domain-specific LLM workflows across JuliaHealth. 
The long-term vision for HealthLLM.jl is to enable workflows across JuliaHealth that lower the barrier to health data analysis while maintaining the reproducibility and auditability that health research demands.
Validation efforts will focus on FunSQL.jl queries for a testing harness, while the architecture is designed to generalize to broader JuliaGenAI LLM tooling for JuliaHealth.

- **Mentor:** Jacob S. Zelko (aka TheCedarPrince) [email: jacobszelko@gmail.com]
- **Difficulty:** Medium
- **Duration:** 175 hours
- **Suggested Skills and Background:**
  - Experience with Julia
  - Strong expertise with LLM and RAG pipelines
  - Experience with the following is necessary:
    - FunSQL.jl
    - PromptingTools.jl or other Julia-native GenAI tooling
    - Vector database technologies (e.g. PgVector, FAISS, Qdrant)
  - Comfort with the OMOP CDM or health informatics concepts 
- **Outcomes:**
  - Refactor the RAG pipeline into modular components (retrieval, generation, post-processing, evaluation) with improved prompt templates, error handling, and logging
  - Survey and evaluate multiple LLMs on FunSQL-based query generation tasks using standardized metrics (accuracy, latency, cost)
  - Provide comprehensive documentation, reproducible evaluation scripts, and final experimental results
  - Design and implement an abstract interface supporting multiple vector database backends, with benchmarking across backends (stretch goal)

## Observational Health Subecosystem Projects

> No projects this year!

## Medical Imaging Subecosystem Projects

### KLAY-Core: High-Performance Neurosymbolic Constraint Layers for Trustworthy Medical AI

**Difficulty:** Hard / Ambitious  
**Duration:** 350 hours (22 weeks)  
**Mentor:** Jakub Mitura  
**Technology Stack:** Julia, Lux.jl, NNlib.jl, ChainRules.jl, LogExpFunctions.jl

#### Description

Deep learning in medical diagnostics suffers from a well-known trust gap. Models often behave as black boxes and may produce physiologically implausible predictions — for example simultaneously predicting cachexia and obesity. This lack of interpretability and clinical consistency limits adoption of AI systems in healthcare environments.

Neurosymbolic artificial intelligence (NeSy) addresses this limitation by integrating structured logical knowledge directly into neural models. However, many existing approaches struggle with numerical stability, scalability, and GPU efficiency when deployed in realistic clinical settings.

KLAY-Core is a high-performance logical constraint layer designed for Lux.jl. It enables domain experts and developers to encode clinical knowledge as differentiable logical constraints integrated directly into neural network architectures.

Using the Knowledge Layers (KLAY) architecture, the project introduces static linearization of logical circuits (d-DNNF) into optimized tensor buffers. Circuit evaluation is reduced to sequences of NNlib.scatter operations and tensor indexing, significantly improving GPU parallel efficiency while ensuring physiologically consistent predictions.

#### Main Goals and Implementation

##### Medical Logic Compiler and d-DNNF Bridge (Julia-Native)

The project follows a "compile once, evaluate often" paradigm for efficient integration of symbolic knowledge into neural models.

**Yggdrasil and JLL Integration**

High-performance symbolic compilers (e.g., d4, SDD) will be distributed as precompiled binaries via Yggdrasil and JLL packages. This guarantees a fully Julia-native workflow without requiring Python environments or local C++ toolchain configuration.

**Level-Order Flattening**

A dedicated algorithm groups logical graph nodes into layers based on structural height. This converts hierarchical logical circuits into flat GPU-friendly buffers, eliminating recursion and enabling efficient parallel execution.

**Solving the Derivative Bottleneck**

Custom adjoints (rrule) implemented using ChainRules.jl ensure backward-pass efficiency comparable to standard neural layers while avoiding excessive memory overhead typical of recursive automatic differentiation.

##### User Interface – The @clinical_rule Macro

To reduce usability barriers for clinicians and developers, the package introduces a domain-specific DSL macro supporting full Boolean logic and weighted relationships where w ∈ [0,1].

Unlike Python-based frameworks such as Dolphin, which rely on object-oriented logic definitions, KLAY-Core offers a declarative macro interface integrated directly with the Julia compiler. This improves readability, auditability, and interdisciplinary collaboration between clinicians and AI engineers.

**Supported Logical Operators:**
- AND (`&`) — logical conjunction
- OR (`|`) — logical alternative
- NOT (`!`) — logical negation
- Implication (`->`) — logical implication

**Constraint Types:**

*Hard Constraints (w = 1.0):* Strict logical rules ensuring physiological consistency.

*Soft Constraints (w < 1.0):* Probabilistic correlations or clinical risk relationships.

##### KLAY-Core Engine for Lux.jl

**Explicit Layer Design**

Implementation of an AbstractExplicitLayer where circuit structure is stored in the layer state while constraint strengths remain trainable parameters. This supports determinism, transparency, and reproducibility required in medical AI systems.

**Log-Space Numerical Stability**

Logical gates are evaluated in logarithmic space using logsumexp (OR) and summation (AND), preventing numerical instability and vanishing-gradient effects.

#### Comparison with Existing Solutions

| Feature | KLAY-Core (Julia) | Dolphin (Python/PyTorch) | DeepProbLog / LTN | Juice.jl (Julia) |
|---|---|---|---|---|
| GPU Parallelism | Native scatter-reduce | Standard PyTorch ops | Mostly sequential | Limited optimized kernels |
| Integration | Native Lux.jl | Wrapper-style integration | Python–C++ bridges | Independent library |
| Ecosystem | JLL / Yggdrasil | Pip / Conda environments | Mixed dependencies | Native Julia ecosystem |
| Interface | High-level DSL macro | Python API definitions | Logic-heavy syntax | Low-level graph APIs |
| Gradient Stability | Custom rrule | Standard AD | Potential instability | Variable stability |

**Competitive Edge:** KLAY-Core combines Julia's performance, macro system, and binary artifact ecosystem with a modern explicit deep learning framework (Lux.jl). Rather than functioning as an external wrapper, it becomes an integral neural network component, simplifying deployment, improving reproducibility, and reducing operational complexity in clinical AI environments.

#### Project Timeline (22 Weeks)

- **Phase 1 (Weeks 1–4):** Development of the @clinical_rule DSL and Yggdrasil/JLL integration.
- **Phase 2 (Weeks 5–9):** Flattening logical circuits into recursion-free GPU buffers.
- **Phase 3 (Weeks 10–13):** Custom rrule differentiation and log-space stability optimization.
- **Phase 4 (Weeks 14–17):** Validation using the Heart Failure Prediction Dataset with focus on: Accuracy, Brier Score, Expected Calibration Error (ECE), AUROC, and Constraint violation rates.
- **Phase 5 (Weeks 18–20):** Performance benchmarking against Dolphin, DeepProbLog, and Juice.jl.
- **Phase 6 (Weeks 21–22):** Final documentation, testing, and publication in the Julia General Registry.

#### References
- Alam, S., et al. (2026). Constraint-aware neurosymbolic uncertainty quantification with Bayesian deep learning for scientific discovery. arXiv preprint (arXiv:2601.12442).
- Chicco, D., & Jurman, G. (2020). Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone. BMC Medical Informatics and Decision Making, 20, 16.
- Dang, M., et al. (2021). JUICE: A Julia package for logic and probabilistic circuits. In Proceedings of the AAAI Conference on Artificial Intelligence, 35(14).
- Fedesoriano. (2021). Heart failure prediction dataset [Dataset]. Kaggle.
- Lagniez, J.-M., & Marquis, P. (2017). An improved decision-DNNF compiler (d4). In Proceedings of the 26th International Joint Conference on Artificial Intelligence (IJCAI 2017).
- Maene, J., & Derkinderen, V. (2024). KLAY: Accelerating arithmetic circuits for neurosymbolic AI. arXiv preprint (arXiv:2410.11415).
- Manhaeve, R., Demeester, T., Rocktäschel, T., & De Raedt, L. (2018). DeepProbLog: Neural probabilistic logic programming. In Advances in Neural Information Processing Systems (NeurIPS 2018).
- Pal, A. (2023). Lux: Explicit parameterization of deep neural networks in Julia [Software]. Zenodo.


#### Capsule Networks for 3D Medical Imaging Segmentation in Julia

**Difficulty:** Hard  
**Duration:** 350 hours  
**Mentor:** Jakub Mitura  
**Technology Stack:** Julia, Lux.jl, MedPipe3D.jl, KernelAbstractions.jl, CUDA.jl, MLUtils.jl, MoonCake.jl

#### Deliverables

- 3D Capsule Network layer primitives (dynamic routing, locally-constrained routing) as reusable Lux.jl modules
- Two full architectures: 3D SegCaps and 3D SegCaps-UNet hybrid
- Custom GPU-accelerated routing kernels via KernelAbstractions.jl
- End-to-end training/evaluation pipeline integrated with MedPipe3D.jl
- Comprehensive benchmarks (Dice, HD95, cross-task transfer) across all 10 Medical Segmentation Decathlon tasks vs. 3D U-Net baseline
- Documentation, pretrained weights, and reproducible experiment scripts contributed to JuliaHealth

#### Success Criteria and Timeline

This project is scoped for a 350-hour GSoC timeframe (approximately 12–13 weeks). The following milestones and success criteria outline the expected progression.

**Community Bonding (pre-coding period)**
- Finalize detailed project plan and milestones with mentors.
- Familiarize with Lux.jl, MedPipe3D.jl, KernelAbstractions.jl, and existing MedPipe3D pipelines.
- Set up development environment, GPU access, and reproduction of a baseline 3D U-Net on a subset of the Medical Segmentation Decathlon.

**Weeks 1–3: Core Capsule Primitives and 3D Extensions**
- Implement and test core capsule network building blocks in Lux.jl:
  - Squash nonlinearity, routing coefficients, and routing-by-agreement loops.
  - Pose and activation representations suitable for 3D convolutional capsules.
- Extend these primitives to 3D convolution capsules (pose matrices, shared transformation matrices).
- Unit tests validating tensor shapes, numerical stability, and differentiability.
- Success criterion: Stable forward and backward passes for 3D capsule layers on synthetic 3D data.

**Weeks 4–6: SegCaps Architectures and Integration**
- Design and implement:
  - A 3D SegCaps encoder–decoder architecture.
  - A 3D SegCaps–UNet hybrid that replaces CNN blocks with capsule blocks while retaining skip connections.
- Integrate architectures with MedPipe3D.jl data loading and preprocessing (NIFTI/DICOM I/O, patching/tiling).
- Implement basic training scripts (single-task training on 1–2 Decathlon tasks).
- Success criterion: End-to-end training runs to convergence on at least one Decathlon task, with validation metrics logged.

**Weeks 7–9: Efficient Routing and GPU Optimization**
- Implement locally-constrained routing strategies to reduce computational cost and memory usage for volumetric data.
- Prototype and benchmark custom GPU-accelerated routing kernels using KernelAbstractions.jl.
- Profile training to identify and remove performance bottlenecks (e.g., memory layout, batching strategy).
- Success criterion: Capsule models train with acceptable throughput (within 2–3× of 3D U-Net) on a modern GPU and fit into GPU memory for standard Decathlon volumes.

**Weeks 10–11: Benchmarking and Cross-Task Transfer**
- Train and evaluate 3D SegCaps and SegCaps–UNet models across all 10 Medical Segmentation Decathlon tasks.
- Implement cross-task transfer experiments (pretrain on one organ/modality, fine-tune on another).
- Compare performance against a strong 3D U-Net baseline using Dice, HD95, and cross-task transfer performance.
- Success criterion: Complete benchmark tables/plots and clear analysis of where capsule models help or hurt relative to U-Net.

**Week 12+: Documentation, Polish, and Upstreaming**
- Clean and document code, ensuring idiomatic Julia and Lux.jl usage.
- Write user-facing documentation and examples (e.g., minimal training script, configuration templates).
- Prepare pretrained weights, experiment configuration files, and reproducibility instructions (including random seeds and environment description).
- Submit pull requests to relevant JuliaHealth repositories and iterate based on maintainer feedback.
- Success criterion: Merged contributions into JuliaHealth repositories plus a project report summarizing methods, experiments, and lessons learned.

#### Description

This project implements 3D Capsule Network (CapsNet) architectures within the Julia ecosystem using Lux.jl and MedPipe3D.jl for volumetric medical image segmentation. The core work involves building a SegCaps (Segmentation Capsules) layer abstraction supporting dynamic routing-by-agreement, extending it to 3D convolution capsules with equivariance-preserving pose matrices. We will implement two key variants: (1) a 3D SegCaps U-Net hybrid that replaces encoder/decoder conv blocks with capsule layers while retaining skip connections, and (2) an efficient locally-constrained routing variant to manage the quadratic computational cost of full capsule coupling in volumetric data. Custom CUDA kernels via KernelAbstractions.jl will accelerate the routing procedure, and the full pipeline—preprocessing, training, and evaluation—will integrate with MedPipe3D.jl's NIFTI/DICOM I/O and metric infrastructure.

The central hypothesis is that capsule networks' explicit encoding of part-whole spatial hierarchies and viewpoint-equivariant pose vectors yields superior cross-domain generalization compared to standard CNNs, which rely on max-pooling and thus discard spatial relationships. We will rigorously benchmark 3D SegCaps against a 3D U-Net baseline across all 10 tasks of the Medical Segmentation Decathlon (covering CT and MRI across brain, liver, lung, pancreas, etc.), measuring not only per-task Dice/HD95 but critically cross-task transfer: models pretrained on one organ/modality and fine-tuned on another. We expect capsule routing to better preserve geometric structure across domains, improving few-shot adaptation. All code, pretrained weights, and reproducible experiment scripts will be contributed to the JuliaHealth ecosystem under MIT license.

#### References

- Sabour, S., Frosst, N., & Hinton, G. E. (2017). *Dynamic Routing Between Capsules*. Advances in Neural Information Processing Systems (NeurIPS). [https://arxiv.org/abs/1710.09829](https://arxiv.org/abs/1710.09829)
- Hinton, G. E., Sabour, S., & Frosst, N. (2018). *Matrix Capsules with EM Routing*. International Conference on Learning Representations (ICLR). [https://openreview.net/forum?id=HJWLfGWRb](https://openreview.net/forum?id=HJWLfGWRb)
- LaLonde, R., & Bagci, U. (2018). *Capsules for Object Segmentation*. (SegCaps). [https://arxiv.org/abs/1804.04241](https://arxiv.org/abs/1804.04241)
- Simpson, A. L., Antonelli, M., Bakas, S., et al. (2019). *A Large Annotated Medical Image Dataset for the Development and Evaluation of Segmentation Algorithms*. (Medical Segmentation Decathlon). [http://medicaldecathlon.com/](http://medicaldecathlon.com/) / [https://arxiv.org/abs/1902.09063](https://arxiv.org/abs/1902.09063)
- Çiçek, Ö., Abdulkadir, A., Lienkamp, S. S., Brox, T., & Ronneberger, O. (2016). *3D U-Net: Learning Dense Volumetric Segmentation from Sparse Annotation*. Medical Image Computing and Computer-Assisted Intervention (MICCAI). [https://arxiv.org/abs/1606.06650](https://arxiv.org/abs/1606.06650)
- Lux.jl: A deep learning library for Julia. [https://github.com/JuliaAI/Lux.jl](https://github.com/JuliaAI/Lux.jl)
- MedPipe3D.jl: A modular 3D medical imaging pipeline in Julia. [https://github.com/JuliaHealth/MedPipe3D.jl](https://github.com/JuliaHealth/MedPipe3D.jl)
- KernelAbstractions.jl: A vendor-neutral GPU programming model for Julia. [https://github.com/JuliaGPU/KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl)

### Enhancing MedPipe3D: Building a Comprehensive Medical Imaging Pipeline in Julia

#### Description
MedPipe3D was created to improve integration between other parts of the small ecosystem (MedEye3D, MedEval3D, and MedImage). Currently, it needs to be expanded and adapted to serve as the basis for a fully functional medical imaging pipeline.

**Mentor:** Jakub Mitura [email: jakub.mitura14@gmail.com]

#### Project Difficulty and Timeline
**Difficulty:** Hard  
**Duration:** 12 weeks

#### Required Skills and Background
- Strong knowledge of the Julia programming language is required.
- Experience with the following Julia packages is highly desirable:
  - MedPipe3D.jl
  - MedEye3D.jl
  - MedEval3D.jl
  - MedImage.jl
- Familiarity with the following packages would be a valuable asset:
  - Lux.jl
  - TensorBoard
  - Logging.jl

#### Potential Outcomes
- Implement comprehensive logging with TensorBoard Integration and Error and Warning Logs with Logging.jl for better tracking and debugging.
- Improve the performance of augmentations.
- Enable per-layer memory usage inspection of Lux models.
- Enable gradient checkpointing of chosen layers to save memory.
- Support loading tabular data (e.g., clinical data) together with the image into the supplied model.
- Enhance documentation with in-depth tutorial, code examples, and a refined README for easy onboarding.

This set of changes, although time-consuming to implement, should not pose a significant issue to anyone with experience with the Julia programming language. Each feature will be implemented using existing Julia libraries and frameworks where possible. However, implementing these changes will be a huge step in making the Julia language a good alternative to Python for developing end-to-end medical imaging segmentation algorithms.

#### Success Criteria and Time Needed
1. **Logging:** Implement logging to track the progress and debug issues - 2 weeks.
2. **Performance Improvements:** Optimize the performance of augmentations to ensure efficient processing - 2 weeks.
3. **Memory Usage Inspection:** Enable per-layer memory usage inspection of Lux models to monitor and optimize memory consumption - 2 weeks.
4. **Gradient Checkpointing:** Enable gradient checkpointing of chosen layers to save memory during training - 4 weeks.
5. **Tabular Data Support:** Support loading tabular data (e.g., clinical data) together with the image into the supplied model - 1 week.
6. **Documentation:** Improve documentation to provide clear instructions and examples for users - 1 week.

**Total estimated time:** 12 weeks.

#### Why Implementation of These Features is Important
Implementing these features is crucial for advancing medical imaging technology. Enhanced logging with TensorBoard integration will allow for better insight into model training. Performance improvements ensure reliable and efficient processing of large datasets. Improved documentation and memory management make the tools more accessible and usable for medical professionals, facilitating better integration into clinical workflows. Supporting tabular data alongside imaging allows for comprehensive analysis, combining clinical and imaging data to improve diagnostic accuracy and patient outcomes.

For each point, the mentor will also supply the person responsible for implementation with examples of required functionalities in Python or will point to the Julia libraries already implementing it (that just need to be integrated).

### `komamripy` - Python Wrapper for KomaMRI

**Difficulty:** Medium

**Duration:** 90 hours (small project)

**Description:** 
KomaMRI.jl is a high-performance Julia package for MRI simulation. This project delivers a long-requested Python entry point ([issue #68](https://github.com/JuliaHealth/KomaMRI.jl/issues/68)) by building `komamripy`: a thin, pip-installable Python wrapper around KomaMRI (with no reimplementation in Python). The goal is to create a Python package that calls Julia under the hood via `juliacall`/PythonCall.jl, similar to [diffeqpy](https://github.com/SciML/diffeqpy) and [PySR](https://github.com/MilesCranmer/PySR).

**Suggested Skills and Background:**

  - Python packaging (pyproject), wheels, CI (GitHub Actions)
  - Basic experience with Julia and package environments
  - Familiarity with scientific computing and GPU concepts
  - Interest in deep learning workflows (PyTorch or JAX)
  - Familiarity with some of the following Julia packages is desirable:
      - PythonCall.jl / `juliacall`
      - PrecompileTools.jl

**Expected Results:** 

1. Release `komamripy` as a `pip`-installable package exposing a minimal API for simulation.
2. Add Python CI (lint + tests + build) and automated tagged releases to publish package artifacts.
3. Implement explicit **Julia-side** precompile workloads using PrecompileTools.jl to reduce first-use compilation overhead for common simulation/autodiff paths.
4. Enable backend selection support for CUDA/AMDGPU/Metal/oneAPI (when available in the host Julia environment).
5. Provide one validated end-to-end Python example (PyTorch or JAX) that runs differentiable optimization on a single GPU.

**Mentors:** Carlos Castillo [email: cacp@stanford.edu], Daniel Ennis, Jakub Mitura

### Extensible MRI Scanner Models for Realistic MRI Simulations

**Difficulty:** Hard  

**Duration:** 350 hours (large project)

**Description:**
KomaMRI simulation behavior does not yet fully rely on explicit scanner models. This project introduces an extensible scanner framework that supports both idealized and realistic MRI hardware while keeping basic simulations simple and fast. The primary focus is gradient modeling, with an architecture that can later be extended to additional scanner effects.

**Suggested Skills and Background:**
  - Strong Julia experience (parametric types, multiple dispatch, performance)
  - Knowledge of MRI physics (gradients, eddy currents, GIRF, RF behavior)
  - Experience with numerical and scientific computing workflows
  - Familiarity with some of the following Julia packages is a plus:
      - KernelAbstractions.jl
      - CUDA.jl
      - Adapt.jl / Functors.jl
      - MRIReco.jl / GIRFReco.jl
      - HDF5.jl

**Outcomes:** The following goals should be achieved on both CPU and GPU:
1. Define a typed `Scanner` foundation (with `HardwareLimits`, `<: RFSystem`, and `<: GradientSystem`) to standardize scanner representation. Make the new types GPU-compatible using Adapt.jl and Functors.jl.
2. Implement core extensible functions (`get_B1`, `get_coils`, `get_Bz`, ...) and make them depend on selected scanner system configurations via multiple dispatch.
3. Add optional hardware-limit validation with clear warnings or errors before simulation runs (using `HardwareLimits`).
4. Deliver baseline linear-gradient behavior (`LinearGradients`) through `get_Bz`, with tests matching current idealized results on both CPU and GPU.
5. Introduce modular spatially nonlinear gradient models (quadratic and PatLoc-like) on top of the baseline, and show their effects in an example.
6. Add a temporally dependent gradient model (eddy currents) and provide an example showing a Nyquist ghosting artifact.
7. Include a GIRF-compatible `GradientSystem` with loaders via `KomaMRIFiles.jl`, using realistic GIRF acquisitions, and provide examples showing gradient delays or GIRF-induced k-space distortion.
8. Add support for saving and loading `Scanner` definitions through `KomaMRIFiles.jl` (as is currently done for `Phantom`s).
9. Provide plotting helper functions in `KomaMRIPlots.jl` for scanner-imperfection visualization, validation, and GIRF workflows.

**Mentors:** Carlos Castillo [email: cacp@stanford.edu], Daniel Ennis, Jakub Mitura

### Differentiable GPU-accelerated MRI Simulations

**Difficulty:** Hard  

**Duration:** 350 hours (large project)

**Description:**
KomaMRI.jl is a high-performance Julia package for MRI simulation. Recent progress with Enzyme.jl and Reactant.jl has demonstrated promising results for running optimization-based design problems efficiently. However, several gaps remain before KomaMRI.jl is fully compatible with Enzyme/Reactant across its full stack.

The main challenge of this project is the **multiple levels of abstraction** in KomaMRI.jl, where highly dynamic, high-level workflows interact with low-level, performance-critical kernels. Some functions that act on or modify high-level objects are more dynamic than standard Enzyme workflows typically assume. Success will therefore require not only making existing code differentiable, but also designing robust data structures (if needed) that simplify execution and enable gradients through workflows that may mix CPU and GPU code paths.

The work is organized across the following levels:

- **High-level:** `simulate`, and objects such as `Phantom`, `Sequence`, and `Scanner`
- **Mid-level:** `discretize`, CPU/GPU memory transfers, `run_spin_iter`
- **Low-level:** parallel functions `run_spin_(excitation/precession)_parallel`
- **Kernel-level:** GPU kernels `run_spin_(excitation/precession)`

Implementation should proceed bottom-up, beginning with kernel and low-level compatibility, then moving upward to mid- and high-level APIs.

A practical strategy is to start with the `BlochSimple` variants (array programming + broadcasting), establish reliable differentiable pipelines there, and then extend support to highly optimized kernel-based `Bloch` methods.

**Suggested Skills and Background:**
- Strong Julia experience, including performant code and type-stable design
- Familiarity with CUDA, XLA, and LLVM-level tooling
- Solid understanding of automatic differentiation
- Familiarity with some of the following Julia packages is a plus:
  - KernelAbstractions.jl
  - CUDA.jl
  - Adapt.jl / Functors.jl
  - DifferentiationInterface.jl / Mooncake.jl / Enzyme.jl / Reactant.jl

**Outcomes:** 
1. Assess the state of Mooncake.jl/FiniteDifferences.jl via DifferentiationInterface.jl for differentiating simulations on CPU and GPU.
2. Implement a reverse-mode AD pipeline using Enzyme/Reactant for the `BlochSimple` simulation method on CPU.
3. Implement a reverse-mode AD pipeline using Enzyme/Reactant for the `BlochSimple` simulation method on GPU.
4. Assess whether a new `Simulation` data structure is needed for optimization pipelines to avoid CPU/GPU memory transfers (containing inputs, preallocations, etc.).
5. Implement a reverse-mode AD pipeline using Enzyme/Reactant for the `Bloch` simulation method on CPU.
6. Implement a reverse-mode AD pipeline using Enzyme/Reactant for the `Bloch` simulation method on GPU.
7. Deliver `Bloch` CPU/GPU differentiation examples, including forward/reverse Enzyme workflows and Reactant workflows for benchmarking.
8. Add a tutorial for 1D RF pulse optimization using the developed tools.
9. Document required changes to the codebase to enable fast differentiation of GPU-based simulations.

**Mentors:** Carlos Castillo [email: cacp@stanford.edu], Daniel Ennis, Jakub Mitura
