# Google Season of Docs 2022 Proposal

## PROPOSAL TITLE - Documenting Machine Learning Models in MLJ.jl

### About your organization

> In this section, tell us about your organization or project in a few short paragraphs. What problem does your project solve? Who are your users and contributors? How long has your organization or project been in existence? Give some context to help us understand why funding your proposal would create a positive impact in open source and the world.

The Julia Programming Language (current version 1.7.3, first released in 2012) is an MIT-licensed High-performance programming language designed for speed, usability, and reproducibility. Given Julia’s speed, it is considered by many to be the best-in-class tool for scientific computing. Since 2012, the domain in which Julia is being used to solve complex computation problems has expanded along with our user base. We currently have over 7,000 registered Julia packages, 35 Million + downloads of Julia, and thousands of contributors worldwide. Julia is also one of the fastest-growing (IEEE Programming Language rankings 2019) and most loved (2019 Stack Overflow Developer Survey) programming languages due in large part to the dedicated community of users and developers alike. The Machine Learning Julia (MLJ) project was originally created at the Alan Turing Institute in 2019 and continues to be the most robust machine learning package in the Julia ecosystem. People are using Julia to solve some of the most complicated and difficult problems in the world, but there are also lots of new users on-boarding into the ecosystem so having high quality documentation is paramount.

### Your project’s problem

> Tell us about the problem your project will help solve. Why is it important to your organization or project to solve this problem?

Right now, when a user wants to understand what various models do in the content of MLJ, there is little to no detail on the model itself nor how it can be used. This makes it really difficult for someone without extensive experience and comfort with machine learning to use MLJ. On top of that, there is no single place in the docs to see and look at the information about all of the available models. This is a feature that is critical to usability and something the project needs to have in order for potential users of all backgrounds to leverage MLJ.

### Your project’s scope

> Tell us about what documentation your organization will create, update, or improve. If some work is deliberately not being done, include that information as well. Include a time estimate, and whether you have already identified organization volunteers and a technical writer to work with your project.

The project to document machine learning models in MLJ will:

- Audit the few existing model documentation examples to get content for what is being asked
- Ensure the less than 5 existing model docs fulfill the usability requirements
- Create model examples, hyper-parameters, and supporting literature for ~20 models which don’t yet have docs
- Integrate those docs into a single page where users can search through and find a model they fits their needs
- Work with community members to make sure there is enough content for expert users but also that new users are not overwhelmed 


__Work that is out-of-scope for this project__:
- Unless the model documentation goes much faster than anticipated, we don’t expect the writer to cover any models not mentioned here: https://github.com/alan-turing-institute/MLJ.jl/issues/913
- We do not expect the technical writer to create any new visuals around the architecture of the models. Many of those images exist and we hope to use and cite them appropriately.

### Measuring your project’s success

> How will you know that your new documentation has helped solve your problem? What metrics will you use, and how will you track them?

Right now, the documentation we are proposing to create does not exist. Users would already have to know what the model they want to use does and how to use it which means very few people can leverage these models. Users could also go externally and try to research the models which increases the turnover of the documentation. By having a unified model documentation section we hope to empower users with all of the information they could want in one single place. 

We would consider the project successful if, after the new guide goes live:

- 25% increase in documentation traffic (measured from site analytics page)
- Use of MLJ increases by +10% (measured by package downloads)
- < 90% of new models added have detailed documentation to begin with (this project would be the forcing factor)

### Timeline

> How long do you estimate this work will take? Are you able to breakdown the tech writer tasks by month/week?

We estimate that a technical writer would spend approximately 1 week per model documented. This gives them time to read appropriate literature, find resources, and construct the relevant background info necessary to write the doc for the model. The detailed tentative timeline would be:

- Week 1: Onboarding + Container page creation for models
- Week 2: MLJGLMInterface
- Week 3: MLJMultivariateStatsInterface
- Week 4: EvoTrees
- Week 5: MLJClusteringInterface
- Week 6: MLJFlux
- Week 7: MLJModels
- Week 8: MLJNaiveBayesInterface
- Week 9: MLJTSVDInterface
- Week 10: MLJText
- Week 11: MLJXGBoostInterface
- Week 12: OutlierDetectionNeighbors
- Week 13: OutlierDetectionNetworks
- Week 14: OutlierDetectionPython
- Week 15: ParallelKMeans
- Week 16: PartialLeastSquaresRegressor
- Week 17: BetaML
- Week 18: LightGBM
- Week 19: MLJScikitLearnInterface
- Week 20: Wrap up / touch up of overall model docs page

This timeline is tentative and we expect that different models will be slightly more challenging than others but this breakdown gives us the opportunity to have a way to stay accountable to the overall goal of the project.

### Project budget

General guidelines

> You can include your budget in your proposal or as a separate link. If your budget is fewer than ten items, we recommend including it in your proposal.

| Budget item                                                               | Amount  | Running Total | Notes/justifications            |
| :------------------------------------------------------------------------ | :------ | :------------ | :------------------------------ |
| Technical writer | 7000.00 | 7000.00       |
| Volunteer Mentor stipends                                                 | 400.00  | 7800.00       | 2 volunteer stipends x 400 each |
| T-shirts for writer and those involved                                                 | 150  | 7950.00       | 5 shirts x 30 each |


We expect the two technical writer mentors to be critical to this process since last year, due to covid, our main writer was out sick so having multiple people familiar with the project helped to ensure the ultimate success of it.

**TOTAL: 7950.00 USD**

### Additional information

> Previous experience with technical writers or documentation: If you or any of your mentors have worked with technical writers before, or have developed documentation, mention this in your application. Describe the documentation that you produced and the ways in which you worked with the technical writer. For example, describe any review processes that you used, or how the technical writer's skills were useful to your project. Explain how this previous experience may help you to work with a technical writer in Season of Docs.

Previous experience with technical writers or documentation: In 2020, the Julia Language was a mentoring organization and successfully mentored 3 projects through GSoD. In 2020, we also paid our own technical writers to work on various projects following the same timeline as GSoD. These projects proved to be extremely valuable, and we are hoping to build off their success. In 2021, we had one project under the Julia umbrella which despite delays due to COVID and family emergencies ultimately ended up being successful. The MLJ project specifically has not had a technical writer before but the core Julia team and our technical writers from previous years will be supporting as mentors / admins for the project to make sure it is successful. We do all our reviews publicly on GitHub which was very helpful in getting outside feedback from core project members who were not directly involved in the project.

> Previous participation in Season of Docs, Google Summer of Code or others: If you or any of your mentors have taken part in Google Summer of Code or a similar program, mention this in your application. Describe your achievements in that program. Explain how this experience may influence the way you work in Season of Docs.

The Julia project has been part of GSoC for many years now. We routinely mentor < 20 students and for the last few years have supplemented GSoC and GSoD by paying contributors and writers directly. We generally only have 1 or max 2 project which fail GSoC and it tends to be because of some extenuating circumstance. Our mentoring team is robust and has many years of GSoC under its belt. Our contributors also tend to stick around in the community after GSoC. In the case of GSoD, some of our 2020 writers ended up mentoring for 2021 and are still involved writing on various projects in the community. GSoD has given us the ability to recruit and retain these writers which has helped us a ton in the last few years.
