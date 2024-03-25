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


## JuliaHealth -- Documenting MedPipe3DTutorial

### JuliaHealth

JuliaHealth is an organization dedicated to improving healthcare by promoting open-source technologies and data standards. Our community is made up of researchers, data scientists, software developers, and healthcare professionals who are passionate about using technology to improve patient outcomes and promote data-driven decision-making. We believe that by working together and sharing our knowledge and expertise, we can create powerful tools and solutions that have the potential to transform healthcare.

### The project's problem

[MedPipe3D](https://github.com/JuliaHealth/MedPipe3DTutorial) was created as a package that improves integration between other parts of the small ecosystem (MedEye3D, MedEval3D, and MedImage). In particular, the tutorial for MedPipe3D in Julia lacks comprehensive coverage. It currently provides minimal information, and users are left wanting more details to fully grasp the package's potential. For example, the tutorial could delve deeper into explaining key functions, use cases, and integration scenarios.

### Project Impact

Addressing this documentation gap will significantly impact MedPipe3D's accessibility and usability, making it an indispensable resource for both new and experienced users. By enhancing the documentation, the project aims to foster a more inclusive and supportive Julia community.

### Project Scope

* Add FAQ page for the Tutorial
* Add documentation and a companion to video tutorial GPU Accelerated Medical Image Segmentation Framework
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

### Timeline

We assume the tech writer will put in part time hours (10-15 hours/week) during this time.

| *Monthly Plan* | |
|---|---|
| *May*	| Technical writer is hired, onboarding|
| *June-July*	| Research into Julia community, user needs for FAQ/support page|
| *August*	| Documentation for video tutorials|
| *September-October* |	Detailed documentation for each sub packages|
| *November* |	Write a blog post|

*Weekly Plan*
* *Week (1-2)* - Reading and Familiarization
* *Week (3-4)* - Metrics Documentation
* *Week (5-7)* - MedEye Documentation
* *Week (8-10)* - FAQ Documentation
* *Week (11- 12)* - Unexpected Issues and Tutorials
* *Week (13- 15)* - MedPipe Documentation
* *Week (16-18)* - How to use Medimage
* *Week (19-20)* - Blog Posts
* *Week (21-22)* - Wrap up / touch up of overall packages docs page

This timeline is tentative and we expect that different packages will be slightly more challenging than others but this breakdown gives us the opportunity to have a way to stay accountable to the overall goal of the project.

### Communication Plan
Primary communication channel is the [Julialang Slack](https://julialang.org/slack/), and Jakub Mitura will be a person responsible for contact and mentoring throughout the project for regular updates and meetings. 


## Unify and Enhance Taija.jl Usage Guides and Core Documentation

[Taija](https://github.com/JuliaTrustworthyAI) is an organization that hosts software geared towards Trustworthy Artificial Intelligence in Julia. Currently, documentation is hosted separately for each package. The goal of this project is to unify and enhance the existing documentation following the example of [SciML](https://docs.sciml.ai/Overview/stable/). We also plan to fully automate documentation workflows by leveraging the interplay between Documenter.jl and Quarto (see [here](https://forem.julialang.org/kellertuer/render-quarto-tutorials-in-documenterjl-with-github-actions-3fo)). If you are interested in Trustworthy AI, Julia, open science and technical writing, then this project is ideal for you. 

Mentor: [Patrick Altmeyer](https://github.com/pat-alt)
