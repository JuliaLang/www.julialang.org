# Julia's Google Season of Docs Projects

Below are the projects which have been proposed for Google Season of Docs under the umbrella of the Julia Language. If you have questions about potential projects, the first point of contact would be the mentor(s) listed on the project. If you are unable to get ahold of the potential mentor(s), you should email `jsoc@julialang.org` and CC `community@julialang.org`.

We at the Julia Language are committed to making the application process and participation in GSoD with Julia accessible to everyone. If you have questions or requests, please do reach out and we will do our best to accommodate you.

### The GSoD experience with The Julia Language

Learn from one of our technical writers about their experience with GSoD:
~~~
<iframe width="100%" height="450" src="https://www.youtube-nocookie.com/embed/6s9J-ObQaAs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
~~~

# Project Ideas for 2024

Below you can find a running list of potential GSoD projects. If any of these are of interest to you, please reach out to the respective mentor(s).


## Documenting JuliaHealth

### JuliaHealth

JuliaHealth is an organization dedicated to improving healthcare by promoting open-source technologies and data standards. Our community is made up of researchers, data scientists, software developers, and healthcare professionals who are passionate about using technology to improve patient outcomes and promote data-driven decision-making. There are various sub-ecosystems like Medical Imaging, Observational Health, Standards and Operability, and then there are other sub-ecosystems that might be emerging over time. Since 2020, Julia Health has continued to grow drastically. For example, on Slack right now, we have nearly 200 people within our health medicine channel, and on Zulip, about another 50 or so people involved with Julia Health there. There's a considerable number of packages now being actively maintained underneath the Julia Health umbrella.

### The project's problem

As Julia Health keeps growing since its start in 2020, we're seeing the need for better documentation.

* There are Inadequate structure of docs and user experience on the Julia Health main website and absence of distinct web pages for different sub-ecosystems within Julia, this fragmentation might result in new users abandoning Julia altogether unless action is taken.

* The Medical imaging sub ecosystem is one leading therefore MedPipe3D was created as a package that improves integration between other parts of the small ecosystem (MedEye3D, MedEval3D, and MedImage). Because of the modularity of libraries, currently active development is concentrated on MedEye3D and MedImage. In particular, the tutorial for MedEye3D and MedImage in Julia lacks comprehensive coverage. It currently provides minimal information, and users are left wanting more details to fully grasp the package's potential. For example, the tutorial could delve deeper into explaining key functions, use cases, and integration scenarios also checks for consistency of functions descriptions in the library

### Project Impact

With enhanced documentation, the project aims to streamline the user experience for individuals at all skill levels within the Julia community. By providing clearer guides and improving accessibility, we seek to make navigating the platform seamless and fulfilling. These efforts not only address existing documentation gaps but also foster inclusivity and supportiveness within the community. Ultimately, our goal is to elevate JuliaHealth while contributing valuable insights and solutions that benefit the broader Julia organization.

### Project Scope

* JuliaHealth organization website
   * Migrate website to DocumenterVitepress
   * Add new organization details for JuliaHealth overall
   * Create new sections for subecosystems
      * Medical Imaging
      * Observational Health
      * Standards and Interoperability
   * Add FAQ page
   * Link to packages across JuliaHealth for proper subecosystem
   * Page for research accomplishments within JuliaHealth
   * Add documentation and a companion to video tutorial GPU Accelerated Medical Image Segmentation Framework
   * Define and implement tracking metrics to monitor user engagement and interaction with the platform
* Extend project scope to include detailed documentation for each subpackage:
   * [MedImage](https://github.com/JuliaHealth/MedImage.jl)
      * Introduction to the theory of medical imaging formats and spatial metadata
      * Describe how to load and save image
      * Describe how apply basic transformation using MedImage
   * [MedEye3d](https://github.com/JuliaHealth/MedEye3d.jl)
      * Write tutorial how to configure window size and amount of space allocated to text
      * Give detailed tutorial describing the possible configurations using TextureSpec objects
      * Add the section with all keyboard shortcuts and print screens showing their effects
      * Describe possible user interactions including:
         * Using tool with REPL for fast debugging, include how to modify and refresh image manually
         * Describe manual interaction of modifiable masks
   * [MedEval3D](https://github.com/JuliaHealth/MedEval3D.jl)
      * Describe different metrics and what are their strength and weaknesses
      * Make a tutorial showing how to use each metric
   * [MedPipe3D](https://github.com/JuliaHealth/MedPipe3D.jl)
      * Describe how to use Medpipe functionalities in different use cases
      * Give theoretical introduction to the functionalities in development (without usage examples)
         * Describe transforms -Brightness transform, Contrast augmentation transform, Gamma Transform, Gaussian noise transform, Rician noise transform, Mirror transform, Scale transform, Gaussian blur transform, Simulate low-resolution transform, Elastic deformation transform
         * Describe concept k fold cross validation and ensembling resulting models
         * Describe probabilistic oversampling for image segmentation
         * Describe why different images needs to be modified to have the same spacing origin and orientation
         * Describe what is the largest component analysis
         * Give short introduction to hyperparameter tuning and usage of Hyperopt package
* Write a blog post on a MedPipe-related topic to broaden the project's reach.

Keeping the documentation concise, focused, and adding practical examples will greatly benefit users in understanding and utilizing the tools effectively.

### Out of scope for this project

* Working on the improvement for pkg development

### Success Criteria

Right now, the documentation we are proposing to create does not exist. Users would already have to know what the Package they want to use but does and how to use it which means very few people can use this. Users could also go externally and try to research the packages which increases the turnover of the documentation. By having a unified package documentation section we hope to empower users with all of the information they could want in one single place.

We would consider the project successful if :
* Most (or all) of the FAQ issues are complete
* Detailed documentation for each Sub packages will be available
* 25% increase in documentation traffic (measured from site analytics page)
* A new blog post is published

### Prerequisites

* Technical Writer
   * Familiarity with Documenter.jl and DocumenterVitepress
   * Basic knowledge of Medpipe3d packages

* Volunteer's Role
   * Volunteer 1: JuliaHealth Documentation volunteer
      * Providing support for general JuliaHealth documentation tasks.
      * Assisting in reviewing documentation pull requests (PRs) periodically.
      * Deploying documentation within the Julia ecosystem as needed.
      * Handling miscellaneous tasks as they arise.
      * Serving as a general support role while integrating Technical Writer's work into the broader JuliaHealth ecosystem.

   * Volunteer 2: Julia Documentation Deployment volunteer
      * Assist in transitioning the main JuliaHealth page to the designated technology platform.
      * Aid in structuring the initial page layout, establishing clear tiles, and organizing them into categories.
      * Define and implement tracking metrics to monitor user engagement and interaction with the platform.
      * Develop a standardized project template for documentation within the JuliaHealth framework.
      * Offer technical consultation and guidance as needed throughout the project duration.

   * Volunteer 3: Medical imaging subecosystem documentation volunteer for KomaMRI and their techniques
      * Introduction to Medical Imaging Theory and Spatial Metadata
      * Provide an introductory overview of medical imaging formats and spatial metadata.
      * Explain the fundamental concepts and principles underlying medical imaging.
      * Give a theoretical overview of functionalities under development, excluding usage examples.
      * Describe various image transformation functions
      * Explain the concept of K-fold cross-validation and its relevance in model evaluation.
      * Discuss the concept of probabilistic oversampling and its application in image segmentation tasks.
      * Explain how probabilistic oversampling techniques can enhance the robustness of segmentation models.
      * Describe the importance of standardizing image spacing, origin, and orientation.
      * Explain Largest Component Analysis utility in identifying and analyzing the largest connected components within datasets.
      * Give a brief introduction to hyperparameter tuning techniques.
      * Explain the usage of the Hyperopt package for automated hyperparameter optimization.

   * Volunteer 4: Task consultations on packages functionalities and function documentations
      * Help in refactoring function descriptions to increase consistency
      * To help checking weather docstrings of functions are working correctly
      * Collaborate with KormaMRI to create specialized documentation sections based on their research paper, covering advanced topics or techniques relevant to medical imaging.

### Timeline

We assume the tech writer will put in part time hours (10-15 hours/week) during this time.

| *Monthly Plan* | |
|---|---|
| *May*	| Technical writer is hired, onboarding|
| *June-July*	| Research into Julia community, user needs for FAQ/support page|
| *August*	| Create Standard Package Documentations, Medical imaging subecosystem documentation|
| *September-October* |	Improvements to the main page of JuliaHealth|
| *November* |	Write a blog post|

*Weekly Plan*
* *Week (1-2)* - Reading and Familiarization
* *Week (3-4)* - Setting up the environment and Updating Organization Details & Creating Subecosystem Sections
* *Week (5-7)* - Linking Packages and Setting Up FAQ Page
* *Week (8-10)* - Documentation Traffic Tracker Setup
* *Week (11- 12)* -Research Accomplishments and FAQ Page Completion
* *Week (13- 16)* - Medical Imaging Subecosystem Packages Documentation
* *Week (17-20)* - Review and Finalize Website Content also Feedback Incorporation
* *Week (20-22)* - Blog Posts
* *Week (23-24)* - Wrap up / touch up of overall packages docs page

This timeline is tentative and we expect that different packages will be slightly more challenging than others but this breakdown gives us the opportunity to have a way to stay accountable to the overall goal of the project.

### Communication Plan
Primary communication channel is the [Julialang Slack](https://julialang.org/slack/), and Jakub Mitura will be a person responsible for contact and mentoring throughout the project for regular updates and meetings. 

### Budget

| Budget item	| Amount	| Running total |
| --- | --- | --- |
| Technical writer	| $5000	| $5000 |
| Volunteer Stipend (500x4)	| $2000	| $7000 |
| T-shirts for team 	| $150	| $7150 |
| TOTAL |	$7150 | |
