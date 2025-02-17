# JuliaHealth Projects – Summer of Code

JuliaHealth is an organization dedicated to improving healthcare by promoting open-source technologies and data standards.
Our community is made up of researchers, data scientists, software developers, and healthcare professionals who are passionate about using technology to improve patient outcomes and promote data-driven decision-making.
We believe that by working together and sharing our knowledge and expertise, we can create powerful tools and solutions that have the potential to transform healthcare.

## Observational Health Subecosystem Projects

### Project 1: Developing Tooling for Observational Health Research in Julia

**Description:** The OMOP Common Data Model (OMOP CDM) is a widely used data standard that allows researchers to analyze large, heterogeneous healthcare datasets in a consistent and efficient manner.
JuliaHealth has several packages that can interact with databases that adhere to the OMOP CDM (such as OMOPCDMCohortCreator.jl or OMOPCDMDatabaseConnector.jl).
For this project, we are looking for students interested in further developing the tooling in Julia to interact with OMOP CDM databases.

- **Mentor:** Jacob Zelko (aka TheCedarPrince) [email: jacobszelko@gmail.com]

- **Difficulty**: Medium

- **Duration**: 350 hours

- **Suggested Skills and Background**:
  - Experience with Julia
  - Familiarity with some of the following Julia packages would be a strong asset:
    - FunSQL.jl
    - DataFrames.jl
    - Distributed.jl
    - OMOPCDMCohortCreator.jl
    - OMOPCDMDatabaseConnector.jl
    - OMOPCommonDataModel.jl
  - Comfort with the OMOP Common Data Model (or a willingness to learn!)

- **Potential Outcomes:**

Some potential project outcomes could be:

- Expanding OMOPCDMCohortCreator.jl to enable users to add constraints to potential patient populations they want to create such as conditional date ranges for a given drug or disease diagnosis.
- Support parallelization of OMOPCDMCohortCreator.jl based queries when developing a patient population.
- Develop and explore novel ways for how population filters within OMOPCDMCohortCreator.jl can be composed together for rapid analysis.

In whatever functionality that gets developed for tools within JuliaHealth, it will also be expected for students to contribute to the existing package documentation to highlight how new features can be used.
Although not required, if students would like to submit a lightning talks, posters, etc. to JuliaCon in the future about their work, they will be supported in this endeavor!

Please contact the mentor for this project if interested and want to discuss what else could be pursued in the course of this project.

### Project 2: Developing Patient Level Prediction Tooling within Julia

**Description:** Patient level prediction (PLP) is an important area of research in healthcare that involves using patient data to predict outcomes such as disease progression, response to treatment, and hospital readmissions.
JuliaHealth is interested in developing tooling for PLP that utilizes historical patient data, such as patient medical claims or electronic health records, that follow the OMOP Common Data Model (OMOP CDM), a widely used data standard that allows researchers to analyze large, heterogeneous healthcare datasets in a consistent and efficient manner.
For this project, we are looking for students interested in developing PLP tooling within Julia.

- **Mentor:** Sebastian Vollmer [email: sjvollmer@gmail.com], Jacob Zelko (aka TheCedarPrince) [email: jacobszelko@gmail.com]

- **Difficulty**: Hard

- **Duration**: 350 hours

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
  - Determine PLP research question to drive package development
  - Develop PLP package utilizing JuliaHealth tools to work with an OMOP CDM database
  - Test and validate PLP package for investigating the research question
  - Document findings and draft JuliaCon talk

In whatever functionality that gets developed for tools within JuliaHealth, it will also be expected for students to contribute to the existing package documentation to highlight how new features can be used.
For this project, it will be expected as part of the proposal to pursue drafting and giving a talk at JuliaCon.
Furthermore, although not required, publishing in the JuliaCon Proceedings will both be encouraged and supported by project mentors.

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





# Enhancing MedPipe3D: Building a Comprehensive Medical Imaging Pipeline in Julia

## Description
MedPipe3D was created to improve integration between other parts of the small ecosystem (MedEye3D, MedEval3D, and MedImage). Currently, it needs to be expanded and adapted to serve as the basis for a fully functional medical imaging pipeline.

**Mentor:** Jakub Mitura [email: jakub.mitura14@gmail.com]

## Project Difficulty and Timeline
**Difficulty:** Medium  
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


# Project Title: A Digital Twin Approach for Advanced Supervoxel Visualization for Multi-Image View in Medical Imaging

## General Idea
This project aims to develop visualization and interaction software for advanced supervoxel visualization on multi-image views. Building on the experiences from MedEye3D, the project will focus on creating a tool that allows users to interact with and visualize supervoxels across different imaging modalities (e.g., CT and MRI) simultaneously. The software will highlight corresponding supervoxels in different images when the user hovers over them, facilitating reliable analysis even in the presence of natural elastic deformations.

## Potential Outcomes
- **Enhanced Visualization:** A software tool that provides side-by-side views of different imaging studies, displaying supervoxel borders and highlighting corresponding supervoxels across images.
- **Improved Interaction:** An interactive interface allowing users to manually correct supervoxel associations by clicking and highlighting supervoxels in both images.
- **Control Points Annotation:** Support for annotating and displaying control points to aid in registration and user orientation.
- **User Feedback Integration:** Mechanisms for users to indicate incorrect supervoxel associations, improving the reliability of the tool.

## Success Criteria and Time Needed
- **Software Development:** [10 Weeks]
  - Develop the core visualization tool with side-by-side image views.
  - Implement supervoxel border display and highlighting functionality.
  - Integrate control points annotation and display features.
- **User Interaction Features:** [6 Weeks]
  - Develop interactive features for manual correction of supervoxel associations.
  - Implement user feedback mechanisms for indicating incorrect associations.
- **Testing and Validation:** [2 Weeks]
  - Conduct extensive testing with sample medical imaging data.
  - Validate the tool's accuracy and reliability in highlighting corresponding supervoxels.
- **Documentation and User Training:** [2 Weeks]
  - Create comprehensive documentation for the software.
  - Develop training materials and conduct user training sessions.
- **Final Review and Deployment:** [2 Weeks]
  - Review the project outcomes and make necessary adjustments.
  - Deploy the software for use by the scientific community.

The total estimated time for the project is approximately 22 weeks. Success will be measured by the tool's ability to accurately highlight corresponding supervoxels, ease of use, and positive feedback from users in the medical imaging community.

## Technical Requirements and Expected Expertise
- Strong programming skills in Julia/C++
- Experience with medical imaging libraries (ITK, SimpleITK, NIfTI)
- Familiarity with GUI development (preferably ModernGL.jl)
- Understanding of 3D visualization techniques
- Basic knowledge of medical image processing concepts
- Experience with version control (Git)

## Tools and Technologies
- **Primary Language:** Julia
- **GUI Framework:** ModernGL.jl/ Vulkan.jl
- **Image Processing:** ITK/SimpleITK
- **Visualization:** OpenGL
- **Building upon:** MedEye3D framework

## User Interaction Examples
- **Hovering Over Supervoxels:** When the user hovers the mouse over a supervoxel in one image (e.g., CT scan), the corresponding supervoxel in the other image (e.g., MRI scan) will be highlighted automatically.
- **Manual Correction:** If the user identifies an incorrect supervoxel association, they can click on the supervoxel in one image to freeze it, then manually find and click the correct supervoxel in the other image to establish the correct association.
- **Control Points:** Users can annotate control points by clicking on corresponding anatomical areas in both images. These points will be saved and displayed to assist in image registration and orientation.

## Importance and Impact
This project is significant because it addresses the challenges of non-rigid registration in medical imaging, which is crucial for accurate diagnosis and treatment planning. By providing a reliable tool for visualizing and interacting with supervoxels across different imaging modalities, the project has the potential to:
- Enhance the accuracy of image registration and subsequent measurements.
- Reduce the time required for manual registration by radiologists and nuclear medicine specialists.
- Enable the development of new algorithms and methods in the medical imaging field.
- Improve clinical decision-making by providing more reliable imaging data.

While various medical image visualization tools exist, there is currently no software solution that specifically addresses supervoxel-based visualization across multiple imaging modalities with interactive correction capabilities. This project builds upon MedEye3D as an independent extension, enhancing its capabilities with new features for supervoxel visualization and interaction.


Overall, this project aims to contribute to the advancement of medical imaging technology, ultimately benefiting both the scientific community and patient care. Additionally, it will serve as a support tool for digital twin projects, enhancing the reliability of image registration and subsequent measurements.




