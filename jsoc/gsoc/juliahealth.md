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


## Medical Imaging Subecosystem Projects

[MedPipe3D.jl](https://github.com/JuliaHealth/MedPipe3D.jl) together with [MedEye3D.jl](https://github.com/JuliaHealth/MedEye3d.jl) [MedEval3D.jl](https://github.com/JuliaHealth/MedEval3D.jl) and currently in development [MedImage.jl](https://github.com/JuliaHealth/MedImage.jl) is a set of libraries created to provide essential tools for 3D medical imaging to the Julia language ecosystem. 

MedImage is a package for the standardization of loading medical imaging data, and for its basic processing that takes into consideration its spatial metadata.
MedEye3D is a package that supports the display of medical imaging data. 
MedEval3D has implemented some highly performant algorithms for calculating metrics needed to asses the performance of 3d segmentation models. 
MedPipe3D was created as a package that improves integration between other parts of the small ecosystem (MedEye3D, MedEval3D, and MedImage). 


### Project 3: Adding functionalities to medical imaging visualizations

**Description:** 
MedEye3D is a package that supports the display of medical imaging data. It includes multiple functionalities specific to this use case like automatic windowing to display soft tissues, lungs, and other tissues. The display takes into account voxel spacing, support of overlaying display for multimodal imaging, and more. All with high performance powered by OpenGL and Rocket.jl. Still, a lot of further improvements are possible and are described in the Potential Outcomes section. 

- **Mentor:** Jakub Mitura [email: jakub.mitura14@gmail.com]

- **Difficulty**: Hard

- **Duration**: 350 hours

- **Suggested Skills and Background**: 
  - Experience with Julia
  - Basic familiarity with computer graphics preferably OpenGL example [link](https://www.opengl-tutorial.org/beginners-tutorials/)
  - Some experience with 3d volumetric data with spatial metadata (or a willingness to learn!) look into for example [link](https://simpleitk.readthedocs.io/en/master/fundamentalConcepts.html)

- **Potential Outcomes:** 
Although MedEye3D already supports displaying medical images, there are still some functionalities that will be useful for the implementation of some more advanced algorithms, like supervoxel segmentation or image registration (and both of them are crucial for solving a lot of important problems in medical imaging). To achieve this this project's goal is to implement.
1) Developing support for multiple image viewing with indicators for image registration like display of the borders, and display lines connecting points.
2) Automatic correct windowing for MRI and PET.
3) Support of display for supervoxels (sv). Show borders of sv; indicate whether the gradient of the image is in agreement with sv borders.
4) Improve start time.
5) Simplify basic usage by providing high-level functions.

- **Success criteria and time needed:** How the success of functionality described above is defined and the approximate time required for each.

1) The user can load 2 different images, and they would display concurrently one next to the other. During scrolling the same area of the body should be displayed (for well-registered sample images) based on the supplied metadata. While moving the mouse cursor on one image the position of the cursor in the same physical spot on the other image should be displayed (physical location calculated from spatial metadata).  120h
2) Given the most common PET and MRI modalities (random FDG PET/CT, and T2, T1, FLAIR, ADC, DWI on MRI) - the user will see the image similar to what is automatically displayed in 3DSlicer - 10h
3) Given an integer mask where a unique integer value will encode information about a single supervoxel and an underlying 3d medical image user will have the option to overlay the original image with the borders of the superpixels where adjacent borders will have different colors, or show those borders on the background of the image convolved with edge filter, for example, Sobel filter - 180h
4) Any measurable decrease in the start time of the viewer -   20h
5) The user will be able to display images just by supplying MedImage objects from the MedImage.jl library to a single display function -  20h


### Project 4: Adding dataset-wide functions and integrations of augmentations

**Description:** 
MedPipe3D was created as a package that improves integration between other parts of the small ecosystem (MedEye3D, MedEval3D, and MedImage). Currently, it needs to be expanded and adapted so it can be a basis for a fully functional medical imaging pipeline. It requires utilities for preprocessing specific to medical imaging - like uniformization of spacing, orientation, cropping, or padding. It needs to k fold cross validation and simple ensembling. Other necessary part of the segmentation pipeline are the augmentations that should be easier to use, and provide test time augmentation for uncertainty quantification. The last thing in the pipeline that is also important for practitioners is postprocessing - and the most popular postprocessing is finding and keeping only the largest connected component.

- **Mentor:** Jakub Mitura [email: jakub.mitura14@gmail.com]

- **Difficulty**: Medium

- **Duration**: 350 hours

- **Suggested Skills and Background**: 
  - Experience with Julia
  - Familiarity with some of the following Julia packages would be a strong asset: 
    - MedEye3D.jl 
    - MedEval3D.jl


- **Potential Outcomes:** 
1) Integrate augmentations like rotations recalling gamma etc.
2) Enable invertible augmentations and support test time augmentations.
3) Add patch-based data loading with probabilistic oversampling.
4) Calculate median and mean spacing and enable applying resampling to the median or mean spacing of the dataset.
5) Add basic post-processing like the largest connected component analysis.
6) Set all hyperparameters (of augmentation; size of a patch, threshold for getting binary mask from probabilities) in a struct or dictionary to enable hyperparameter tuning.
7) Enable automated display of the algorithm output in the validation epoch, including saving such outputs to persistent storage.
8) Support k-fold cross-validation.

This set of changes although time-consuming to implement should not pose a significant issue to anybody with experience with the Julia programming language. However, implementing those will be a huge step in making Julia language a good alternative to Python in developing end-to-end medical imaging segmentation algorithms.

- **Success criteria and time needed:** How the success of functionality described above is defined and the approximate time required for each.

1) Given the configuration struct supplied by the user the supplied augmentations will be executed with some defined probability after loading the image: Brightness transform, Contrast augmentation transform, Gamma Transform, Gaussian noise transform, Rician noise transform, Mirror transform, Scale transform, Gaussian blur transform, Simulate low-resolution transform, Elastic deformation transform -100h. 
2) Enable some transformation to be executed on the model input, then inverse this transform on the model output; execute model inference n times when n is supplied by the user and return mean and standard deviation of segmentation masks produced by the model as the output -60h.
3) given the size of the 3D patch by the user algorithm after data loading will crop or pad the supplied image to meet the set size criterion. The part of the image where the label is present should be selected more frequently than the areas without during cropping, the probability that the area with some label indicated on segmentation mas will be chosen will equal p (0-1) where p is supplied by the user -40h. 
4) given the list of paths to medical images it will load them calculate the mean or median spacing (option selected by the user), and return it. Then during pipeline execution, all images should be resampled to a user-supplied spacing and user-supplied orientation - 40h.
5) Given a model output and a threshold that will be used for each channel of the output to binarize the output user will have an option to retrieve only n largest components from binarized algorithm output - 20h.
6) Probabilities and hyperparameters of all augmentations, thresholds for binarization of output channels chosen spacing for preprocessing, number and settings of test time augmentations should be available in a hyperparam struct that is the additional argument of the pipeline function and that can be used for hyperparameter tuning -30h.
7) During the validation epoch the images can be saved into persistent storage and a single random image loaded together with the output mask into MedEye3d for visualization during training -30h.
8) The user can set either val_percentage - which will lead to the division of the dataset to training and validation fold or supply k which will lead to k-fold cross-validation. In the latter option mean, threshold, and standard deviation of the ensemble will be returned as the final output of the model -30h.

For each point mentor will also supply the person responsible for implementation with examples of required functionalities in Python or will point to the Julia libraries already implementing it (that just need to be integrated).


### Project 5: Highly-efficient MRI Simulations with Multi-Vendor GPU Support

**Description:** 
KomaMRI.jl is a Julia package designed for highly-efficient Magnetic Resonance Imaging (MRI) simulations, serving both educational and research purposes. Simulations can help to grasp hard-to-understand MRI concepts, like pulse sequences, signal generation and acquisition. Moreover, they can guide the design of novel pulse sequences, and generate synthetic data for training machine learning models.

Currently, our simulator performs GPU-accelerated computations using CUDA arrays. We are now advancing to implement a new simulation method (`BlochKernel<:SimulationMethod`) based on GPU kernel programming using KernelAbstractions.jl. This enhancement will not only boost computation speeds but also broaden accessibility with KernelAbstractions.jl's multi-vendor GPU support. This could enable the use of MRI simulations in iterative algorithms to solve inverse problems. We are seeking enthusiastic people interested in developing this functionality.

- **Mentors:** Carlos Castillo [email: cncastillo@uc.cl], Boris Oróstica [email: beorostica@uc.cl], Pablo Irarrazaval [email: pim@uc.cl]

- **Difficulty:** Hard

- **Duration:** 350 hours (2 months, 8 hours per day)

- **Suggested Skills and Background:**
  - Experience with Julia
  - Exposure to MRI concepts and ideas
  - High-level knowledge of GPU programming
  - Familiarity with some of the following Julia packages would be desired:
    - KernelAbstractions.jl
    - CUDA.jl
    - Adapt.jl
    - Functors.jl

- **Outcomes**:

We expect the following outcomes by the end of this program:

1) Extended and/or improved GPU-accelerated simulations, having generated a new simulation method `BlochKernel` with multi-vendor GPU support.
2) Developed documentation explaining the new simulation method, including showcasing some use-case examples.
3) Implemented automatic pipelines on Buildkite for testing the simulations across multiple GPU architectures.
4) Reported performance improvements between `BlochKernel` and `Bloch`.

Please contact the mentors of this project if you are interested and want to discuss other aspects that could be pursued during the course of this project.
