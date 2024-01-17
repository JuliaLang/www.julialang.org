# JuliaHealth Projects 

JuliaHealth is an organization dedicated to improving healthcare by promoting open-source technologies and data standards.
Our community is made up of researchers, data scientists, software developers, and healthcare professionals who are passionate about using technology to improve patient outcomes and promote data-driven decision-making.
We believe that by working together and sharing our knowledge and expertise, we can create powerful tools and solutions that have the potential to transform healthcare.

## Potential Projects

### Project 1: Developing Tooling for Observational Health Research in Julia

**Description:** The OMOP Common Data Model (OMOP CDM) is a widely used data standard that allows researchers to analyze large, heterogeneous healthcare datasets in a consistent and efficient manner.
JuliaHealth has several packages that can interact with databases that adhere to the OMOP CDM (such as OMOPCDMCohortCreator.jl or OMOPCDMDatabaseConnector.jl).
For this project, we are looking for students interested in further developing the tooling in Julia to interact with OMOP CDM databases. 

- **Mentor:** Jacob Zelko (aka TheCedarPrince) [email: jacobszelko@gmail.com]

- **Difficulty**: Medium

- **Duration**: 175 hours

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

### Project 3: Highly-efficient MRI Simulations with Multi-Vendor GPU Support

**Description:** 
KomaMRI.jl is a Julia package designed for highly-efficient Magnetic Resonance Imaging (MRI) simulations, serving both educational and research purposes.

Simulations can help to grasp hard-to-understand MRI concepts, like signal acquisition, and image reconstruction. Moreover, they can guide the design of novel pulse sequences, and generate synthetic data for training machine learning models.

Currently, our simulator performs GPU-accelerated computations using CUDA arrays. We are now advancing to implement a new simulation method (`BlochKernel<:SimulationMethod`) based on GPU kernel programming using KernelAbstractions.jl. This enhancement will not only boost computation speeds but also broaden accessibility with KernelAbstractions.jl's multi-vendor GPU support. This could enable the use of MRI simulations in iterative algorithms to solve inverse problems. We are seeking enthusiastic people interested in developing this functionality.

- **Mentors:** Carlos Castillo [email: cncastillo@uc.cl], Boris Oróstica [email: beorostica@uc.cl]

- **Difficulty:** Hard

- **Duration:** 320 hours (2 months, 8 hours per day)

- **Suggested Skills and Background:**
  - Experience with Julia
  - Exposure to MRI concepts and ideas
  - High-level knowledge of GPU programming
  - Familiarity with some of the following Julia packages would be a strong asset:
	  - KernelAbstractions.jl
	  - CUDA.jl
	  - Adapt.jl
	  - Functors.jl

- **Outcomes**:

We expect the following outcomes by the end of this program:

  - Extend and/or improve our GPU-accelerated simulations by generating a new simulation method `BlochKernel`, with multi-vendor GPU support.
  - Documentation explaining the new simulation method showcasing some use-case examples.
  - Implement automatic pipelines on Buildkite to test the simulations in multiple GPU architectures.
  - Report performance improvements between `BlochKernel` and `Bloch`.

Please contact the mentors of this project if you are interested and want to discuss other aspects that could be pursued during the course of this project.