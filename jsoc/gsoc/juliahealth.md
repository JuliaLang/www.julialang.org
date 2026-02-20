# JuliaHealth Projects – Summer of Code

JuliaHealth is an organization dedicated to improving healthcare by promoting open-source technologies and data standards.
Our community is made up of researchers, data scientists, software developers, and healthcare professionals who are passionate about using technology to improve patient outcomes and promote data-driven decision-making.
We believe that by working together and sharing our knowledge and expertise, we can create powerful tools and solutions that have the potential to transform healthcare.

## Observational Health Subecosystem Projects

### Project 1: Supporting Patient Level Prediction Pipelines within JuliaHealth

**Description:** Patient level prediction (PLP) is an important area of research in observational health research that involves using patient data to predict outcomes such as disease progression, response to treatment, and hospital readmissions.
JuliaHealth is interested in developing supportive tooling for PLP that utilizes historical patient data, such as patient medical claims or electronic health records, that follow the OMOP Common Data Model (OMOP CDM), a widely used data standard that allows researchers to analyze large, heterogeneous healthcare datasets in a consistent and efficient manner.
For this project, we are looking for students interested in developing supportive PLP tooling within JuliaHealth.

- **Mentor:** Jacob S. Zelko (aka TheCedarPrince) [email: jacobszelko@gmail.com]

- **Difficulty**: Medium

- **Duration**: 175 hours

- **Suggested Skills and Background**:
  - Experience with Julia
  - Exposure to machine learning concepts and ideas
  - Familiarity with some of the following Julia packages would be a strong asset:
    - DataFrames.jl
    - OMOPCDMCohortCreator.jl
    - MLJ.jl
    - ModelingToolkit.jl
  - Comfort with the OMOP Common Data Model (or a willingness to learn)

- **Outcomes:**

This project will be very experimental and exploratory in nature.
To constrain the expectations for this project, here is a possible approach students will follow while working on this project:

  - Review existing literature on approaches to PLP
  - Familiarize oneself with tools for machine learning and prediction within the Julia ecosystem
  - Develop infrastructure needed for doing PLP within the JuliaHealth ecosystem such as:
      - Consistent DataFrames.jl interface
      - Data harmonization methods
      - Sampling considerations for large scale patient data
  - Document findings and novel software

In whatever functionality that gets developed for tools within JuliaHealth, it will also be expected for students to contribute to the existing package documentation to highlight how new features can be used.
Another perspective of this project is that its intended goal is to provide the foundational support needed within JuliaHealth to better accommodate multiple modalities of data available within public health settings.
The long term goal is to use the development of foundational tooling with JuliaHealth to better support patient level prediction workflows across observational health data and additional information such as survey data, social determinants of health data, and climate data.

Additionally, depending on the success of the package, there is a potential to run experiments on actual patient data to generate actual patient population insights based on a chosen research question.
This could possibly turn into a separate research paper, conference submission, or poster submission.
Whatever may occur in this situation will be supported by project mentors.

# Medical Imaging Subecosystem Projects

# Julia Radiomics

**Project Title:** Julia Radiomics  
**Difficulty:** Medium  
**Duration:** 375 hours (22 Weeks)  
**Mentor:** Jakub Mitura  

## Description
Radiomic features are quantitative metrics extracted from medical images using data-characterization algorithms. These features capture tissue and lesion characteristics, such as heterogeneity and shape, which may provide valuable insights beyond what the naked eye can perceive.

This project aims to implement algorithms for extracting radiomic features from 2D and 3D medical images, similar to PyRadiomics, using Julia. The implementation will include Gray Level Co-occurrence Matrix (GLCM), Gray Level Size Zone Matrix (GLSZM), Gray Level Run Length Matrix (GLRM), Neighborhood Gray Tone Difference Matrix (NGTDM), and Gray Level Dependence Matrix (GLDM). The extracted features will be validated against PyRadiomics and applied to medical imaging data, such as the AutoPET dataset, to demonstrate the methodology. 


## Deliverables

### Implementation of Radiomic Feature Extraction Algorithms
- **First Group:** GLCM, GLSZM, GLRM
- **Second Group:** NGTDM, GLDM

### Feature Extraction Pipeline
- Extract all features from segmented lesions in PET and CT modalities.
- Use MedImages.jl for image handling.
- Leverage KernelAbstractions.jl for performance optimization where possible.

### Validation
- Compare extracted features against PyRadiomics outputs.
- Ensure statistical equivalence in extracted features.

### Final Report & Code Repository
- Methodology, results, benchmarking.
- Public GitHub repository under an MIT license.

## Success Criteria and Timeline

### 1. Literature Review and Setup (3 Weeks)
- Review PyRadiomics documentation, MedImages.jl, KernelAbstractions.jl APIs, and AutoPET dataset structure.
- **Success Criteria:** Understanding of feature definitions, dataset access, and GPU kernel design.

### 2. Feature Implementation (6 Weeks)
- Implement GLCM, GLSZM, GLRM, NGTDM, and GLDM matrices.
- Validate outputs against PyRadiomics (>90% similarity in unit tests).
- **Success Criteria:** GPU-accelerated implementation for 3D volumes.

### 3. Feature Extraction Pipeline (4 Weeks)
- Build a pipeline to process AutoPET lesions using MedImages.jl.
- **Success Criteria:** Extraction of 100+ features per lesion, support for batch processing.

### 4. Validation (3 Weeks)
- Compare Julia feature extraction results with PyRadiomics.
- **Success Criteria:** Statistical equivalence (e.g., t-test p > 0.05), with documented discrepancies <5%.

### 5. Documentation and Packaging (4 Weeks)
- Write documentation for the Julia-based radiomics library.
- Write automated tests for the proper functioning of the library.
- Register the package in the Julia package registry.
- **Success Criteria:** The final working library is successfully available in the Julia ecosystem.

### 6. Reporting (2 Weeks)
- Document methodology, results, and benchmarking.
- **Success Criteria:** Reproducible code, Jupyter notebooks, open-source repository.

## Stretch Goals
- Implementation of additional radiomic features such as:
  - Wavelet Features (Transform-based texture analysis)
  - Fractal Analysis (Estimating complexity in medical images)
  - Laplacian of Gaussian (LoG) Features (Edge detection-based feature extraction)
- Optimized parallel computation using GPU acceleration in KernelAbstractions.jl.
- Implementation of an interactive Julia-based visualization tool for extracted radiomic features.

## Clarification
This implementation will be done entirely in Julia, and Python will not be used in any part of the implementation.  
Any cross-validation with PyRadiomics is purely for benchmarking purposes.

## Importance and Impact

### Technical Impact
- **Julia Ecosystem Growth:** First native Radiomics toolkit in Julia.
- **GPU Acceleration:** Utilizes KernelAbstractions.jl for efficient 3D feature extraction.
- **Reproducibility:** Open-source implementation ensures transparency in radiomics research.

### Clinical Impact
- **Cancer Differentiation:** Model insights may aid in non-invasive cancer subtyping.
- **Standardization:** Cross-tool validation enhances study comparability across different platforms.

### Community Impact
- **Foundation for Future Work:** Enables Julia-based radiomics pipelines for projects like TCIA.
- **Educational Value:** Demonstrates GPU-accelerated medical image processing in Julia for researchers and students.

## References
- [PyRadiomics Documentation](https://pyradiomics.readthedocs.io)
- [AutoPET Dataset](https://autopet.grand-challenge.org/)
- [MedImages.jl](https://github.com/JuliaHealth/MedImages.jl)
- [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl)
- Radiomics Research: Various studies on the clinical relevance of radiomics in medical imaging.
- Kumar, V., et al. "Radiomics: the process and the challenges." Magnetic Resonance Imaging, 2012.
- Gillies, R.J., et al. "Radiomics: images are more than pictures, they are data." Nature Reviews Cancer, 2016.
- Lambin, P., et al. "Radiomics: extracting more information from medical images using advanced feature analysis." European Journal of Cancer, 2012.


# KLAY-Core: High-Performance Neurosymbolic Constraint Layers for Trustworthy Medical AI

**Difficulty:** Hard / Ambitious  
**Duration:** 350 hours (22 weeks)  
**Mentor:** Jakub Mitura  
**Technology Stack:** Julia, Lux.jl, NNlib.jl, ChainRules.jl, LogExpFunctions.jl

## Description

Deep learning in medical diagnostics suffers from a well-known trust gap. Models often behave as black boxes and may produce physiologically implausible predictions — for example simultaneously predicting cachexia and obesity. This lack of interpretability and clinical consistency limits adoption of AI systems in healthcare environments.

Neurosymbolic artificial intelligence (NeSy) addresses this limitation by integrating structured logical knowledge directly into neural models. However, many existing approaches struggle with numerical stability, scalability, and GPU efficiency when deployed in realistic clinical settings.

KLAY-Core is a high-performance logical constraint layer designed for Lux.jl. It enables domain experts and developers to encode clinical knowledge as differentiable logical constraints integrated directly into neural network architectures.

Using the Knowledge Layers (KLAY) architecture, the project introduces static linearization of logical circuits (d-DNNF) into optimized tensor buffers. Circuit evaluation is reduced to sequences of NNlib.scatter operations and tensor indexing, significantly improving GPU parallel efficiency while ensuring physiologically consistent predictions.

## Main Goals and Implementation

### Medical Logic Compiler and d-DNNF Bridge (Julia-Native)

The project follows a "compile once, evaluate often" paradigm for efficient integration of symbolic knowledge into neural models.

**Yggdrasil and JLL Integration**

High-performance symbolic compilers (e.g., d4, SDD) will be distributed as precompiled binaries via Yggdrasil and JLL packages. This guarantees a fully Julia-native workflow without requiring Python environments or local C++ toolchain configuration.

**Level-Order Flattening**

A dedicated algorithm groups logical graph nodes into layers based on structural height. This converts hierarchical logical circuits into flat GPU-friendly buffers, eliminating recursion and enabling efficient parallel execution.

**Solving the Derivative Bottleneck**

Custom adjoints (rrule) implemented using ChainRules.jl ensure backward-pass efficiency comparable to standard neural layers while avoiding excessive memory overhead typical of recursive automatic differentiation.

### User Interface – The @clinical_rule Macro

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

### KLAY-Core Engine for Lux.jl

**Explicit Layer Design**

Implementation of an AbstractExplicitLayer where circuit structure is stored in the layer state while constraint strengths remain trainable parameters. This supports determinism, transparency, and reproducibility required in medical AI systems.

**Log-Space Numerical Stability**

Logical gates are evaluated in logarithmic space using logsumexp (OR) and summation (AND), preventing numerical instability and vanishing-gradient effects.

## Comparison with Existing Solutions

| Feature | KLAY-Core (Julia) | Dolphin (Python/PyTorch) | DeepProbLog / LTN | Juice.jl (Julia) |
|---|---|---|---|---|
| GPU Parallelism | Native scatter-reduce | Standard PyTorch ops | Mostly sequential | Limited optimized kernels |
| Integration | Native Lux.jl | Wrapper-style integration | Python–C++ bridges | Independent library |
| Ecosystem | JLL / Yggdrasil | Pip / Conda environments | Mixed dependencies | Native Julia ecosystem |
| Interface | High-level DSL macro | Python API definitions | Logic-heavy syntax | Low-level graph APIs |
| Gradient Stability | Custom rrule | Standard AD | Potential instability | Variable stability |

**Competitive Edge:** KLAY-Core combines Julia's performance, macro system, and binary artifact ecosystem with a modern explicit deep learning framework (Lux.jl). Rather than functioning as an external wrapper, it becomes an integral neural network component, simplifying deployment, improving reproducibility, and reducing operational complexity in clinical AI environments.

## Project Timeline (22 Weeks)

- **Phase 1 (Weeks 1–4):** Development of the @clinical_rule DSL and Yggdrasil/JLL integration.
- **Phase 2 (Weeks 5–9):** Flattening logical circuits into recursion-free GPU buffers.
- **Phase 3 (Weeks 10–13):** Custom rrule differentiation and log-space stability optimization.
- **Phase 4 (Weeks 14–17):** Validation using the Heart Failure Prediction Dataset with focus on: Accuracy, Brier Score, Expected Calibration Error (ECE), AUROC, and Constraint violation rates.
- **Phase 5 (Weeks 18–20):** Performance benchmarking against Dolphin, DeepProbLog, and Juice.jl.
- **Phase 6 (Weeks 21–22):** Final documentation, testing, and publication in the Julia General Registry.

## References
- Alam, S., et al. (2026). Constraint-aware neurosymbolic uncertainty quantification with Bayesian deep learning for scientific discovery. arXiv preprint (arXiv:2601.12442).
- Chicco, D., & Jurman, G. (2020). Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone. BMC Medical Informatics and Decision Making, 20, 16.
- Dang, M., et al. (2021). JUICE: A Julia package for logic and probabilistic circuits. In Proceedings of the AAAI Conference on Artificial Intelligence, 35(14).
- Fedesoriano. (2021). Heart failure prediction dataset [Dataset]. Kaggle.
- Lagniez, J.-M., & Marquis, P. (2017). An improved decision-DNNF compiler (d4). In Proceedings of the 26th International Joint Conference on Artificial Intelligence (IJCAI 2017).
- Maene, J., & Derkinderen, V. (2024). KLAY: Accelerating arithmetic circuits for neurosymbolic AI. arXiv preprint (arXiv:2410.11415).
- Manhaeve, R., Demeester, T., Rocktäschel, T., & De Raedt, L. (2018). DeepProbLog: Neural probabilistic logic programming. In Advances in Neural Information Processing Systems (NeurIPS 2018).
- Pal, A. (2023). Lux: Explicit parameterization of deep neural networks in Julia [Software]. Zenodo.


# Capsule Networks for 3D Medical Imaging Segmentation in Julia

**Difficulty:** Hard  
**Duration:** 350 hours  
**Mentor:** Jakub Mitura  
**Technologies:** Julia, Lux.jl, MedPipe3D.jl, KernelAbstractions.jl, CUDA.jl, MLUtils.jl, MoonCake.jl

## Deliverables

- 3D Capsule Network layer primitives (dynamic routing, locally-constrained routing) as reusable Lux.jl modules
- Two full architectures: 3D SegCaps and 3D SegCaps-UNet hybrid
- Custom GPU-accelerated routing kernels via KernelAbstractions.jl
- End-to-end training/evaluation pipeline integrated with MedPipe3D.jl
- Comprehensive benchmarks (Dice, HD95, cross-task transfer) across all 10 Medical Segmentation Decathlon tasks vs. 3D U-Net baseline
- Documentation, pretrained weights, and reproducible experiment scripts contributed to JuliaHealth

## Success Criteria and Timeline

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

## Description

This project implements 3D Capsule Network (CapsNet) architectures within the Julia ecosystem using Lux.jl and MedPipe3D.jl for volumetric medical image segmentation. The core work involves building a SegCaps (Segmentation Capsules) layer abstraction supporting dynamic routing-by-agreement, extending it to 3D convolution capsules with equivariance-preserving pose matrices. We will implement two key variants: (1) a 3D SegCaps U-Net hybrid that replaces encoder/decoder conv blocks with capsule layers while retaining skip connections, and (2) an efficient locally-constrained routing variant to manage the quadratic computational cost of full capsule coupling in volumetric data. Custom CUDA kernels via KernelAbstractions.jl will accelerate the routing procedure, and the full pipeline—preprocessing, training, and evaluation—will integrate with MedPipe3D.jl's NIFTI/DICOM I/O and metric infrastructure.

The central hypothesis is that capsule networks' explicit encoding of part-whole spatial hierarchies and viewpoint-equivariant pose vectors yields superior cross-domain generalization compared to standard CNNs, which rely on max-pooling and thus discard spatial relationships. We will rigorously benchmark 3D SegCaps against a 3D U-Net baseline across all 10 tasks of the Medical Segmentation Decathlon (covering CT and MRI across brain, liver, lung, pancreas, etc.), measuring not only per-task Dice/HD95 but critically cross-task transfer: models pretrained on one organ/modality and fine-tuned on another. We expect capsule routing to better preserve geometric structure across domains, improving few-shot adaptation. All code, pretrained weights, and reproducible experiment scripts will be contributed to the JuliaHealth ecosystem under MIT license.

## References

- Sabour, S., Frosst, N., & Hinton, G. E. (2017). *Dynamic Routing Between Capsules*. Advances in Neural Information Processing Systems (NeurIPS). [https://arxiv.org/abs/1710.09829](https://arxiv.org/abs/1710.09829)
- Hinton, G. E., Sabour, S., & Frosst, N. (2018). *Matrix Capsules with EM Routing*. International Conference on Learning Representations (ICLR). [https://openreview.net/forum?id=HJWLfGWRb](https://openreview.net/forum?id=HJWLfGWRb)
- LaLonde, R., & Bagci, U. (2018). *Capsules for Object Segmentation*. (SegCaps). [https://arxiv.org/abs/1804.04241](https://arxiv.org/abs/1804.04241)
- Simpson, A. L., Antonelli, M., Bakas, S., et al. (2019). *A Large Annotated Medical Image Dataset for the Development and Evaluation of Segmentation Algorithms*. (Medical Segmentation Decathlon). [http://medicaldecathlon.com/](http://medicaldecathlon.com/) / [https://arxiv.org/abs/1902.09063](https://arxiv.org/abs/1902.09063)
- Çiçek, Ö., Abdulkadir, A., Lienkamp, S. S., Brox, T., & Ronneberger, O. (2016). *3D U-Net: Learning Dense Volumetric Segmentation from Sparse Annotation*. Medical Image Computing and Computer-Assisted Intervention (MICCAI). [https://arxiv.org/abs/1606.06650](https://arxiv.org/abs/1606.06650)
- Lux.jl: A deep learning library for Julia. [https://github.com/JuliaAI/Lux.jl](https://github.com/JuliaAI/Lux.jl)
- MedPipe3D.jl: A modular 3D medical imaging pipeline in Julia. [https://github.com/JuliaHealth/MedPipe3D.jl](https://github.com/JuliaHealth/MedPipe3D.jl)
- KernelAbstractions.jl: A vendor-neutral GPU programming model for Julia. [https://github.com/JuliaGPU/KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl)
# Enhancing MedPipe3D: Building a Comprehensive Medical Imaging Pipeline in Julia

## Description
MedPipe3D was created to improve integration between other parts of the small ecosystem (MedEye3D, MedEval3D, and MedImage). Currently, it needs to be expanded and adapted to serve as the basis for a fully functional medical imaging pipeline.

**Mentor:** Jakub Mitura [email: jakub.mitura14@gmail.com]

## Project Difficulty and Timeline
**Difficulty:** Hard  
**Duration:** 12 weeks

## Required Skills and Background
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

## Potential Outcomes
- Implement comprehensive logging with TensorBoard Integration and Error and Warning Logs with Logging.jl for better tracking and debugging.
- Improve the performance of augmentations.
- Enable per-layer memory usage inspection of Lux models.
- Enable gradient checkpointing of chosen layers to save memory.
- Support loading tabular data (e.g., clinical data) together with the image into the supplied model.
- Enhance documentation with in-depth tutorial, code examples, and a refined README for easy onboarding.

This set of changes, although time-consuming to implement, should not pose a significant issue to anyone with experience with the Julia programming language. Each feature will be implemented using existing Julia libraries and frameworks where possible. However, implementing these changes will be a huge step in making the Julia language a good alternative to Python for developing end-to-end medical imaging segmentation algorithms.

## Success Criteria and Time Needed
1. **Logging:** Implement logging to track the progress and debug issues - 2 weeks.
2. **Performance Improvements:** Optimize the performance of augmentations to ensure efficient processing - 2 weeks.
3. **Memory Usage Inspection:** Enable per-layer memory usage inspection of Lux models to monitor and optimize memory consumption - 2 weeks.
4. **Gradient Checkpointing:** Enable gradient checkpointing of chosen layers to save memory during training - 4 weeks.
5. **Tabular Data Support:** Support loading tabular data (e.g., clinical data) together with the image into the supplied model - 1 week.
6. **Documentation:** Improve documentation to provide clear instructions and examples for users - 1 week.

**Total estimated time:** 12 weeks.

## Why Implementation of These Features is Important
Implementing these features is crucial for advancing medical imaging technology. Enhanced logging with TensorBoard integration will allow for better insight into model training. Performance improvements ensure reliable and efficient processing of large datasets. Improved documentation and memory management make the tools more accessible and usable for medical professionals, facilitating better integration into clinical workflows. Supporting tabular data alongside imaging allows for comprehensive analysis, combining clinical and imaging data to improve diagnostic accuracy and patient outcomes.

For each point, the mentor will also supply the person responsible for implementation with examples of required functionalities in Python or will point to the Julia libraries already implementing it (that just need to be integrated).
