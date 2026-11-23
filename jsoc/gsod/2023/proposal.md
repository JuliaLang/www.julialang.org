# Google Season of Docs 2023 Proposal

## PROPOSAL TITLE - Build Tidier.jl Usage Guides and Core Documentation

### About your organization

> In this section, tell us about your organization or project in a few short paragraphs. What problem does your project solve? Who are your users and contributors? How long has your organization or project been in existence? Give some context to help us understand why funding your proposal would create a positive impact in open source and the world.

The Julia Programming Language (current version 1.9.0, first released in 2012) is an MIT-licensed High-performance programming language designed for speed, usability, and reproducibility. Given Julia’s speed, it is considered by many to be the best-in-class tool for scientific computing. Since 2012, the domain in which Julia is being used to solve complex computation problems has expanded along with our user base. We currently have over 8,000 registered Julia packages, 40 Million + downloads of Julia, and thousands of contributors worldwide. Julia is also one of the fastest-growing (IEEE Programming Language rankings 2019) and most loved (2019 Stack Overflow Developer Survey) programming languages due in large part to the dedicated community of users and developers alike. Tidier.jl is a new and fast-growing Julia package that aims to replicate the widely used R tidyverse ecosystem in Julia. Developers would benefit from the familiar syntax and ecosystem of tidyverse while also leveraging the benefits of Julia from the ground up.

### Your project’s problem

> Tell us about the problem your project will help solve. Why is it important to your organization or project to solve this problem?

Today, there is no clear options for R users to make the transition to Julia. Tidier.jl is working to solve this problem by building the entire tidyverse ecosystem from the ground up in Julia. The tidyverse is one of the main reasons developers stick with the R programming language, despite the many benefits of a modern programming language like Julia. We plan to leverage Tidier.jl to usher in the next 1 million Julia users. 

### Your project’s scope

> Tell us about what documentation your organization will create, update, or improve. If some work is deliberately not being done, include that information as well. Include a time estimate, and whether you have already identified organization volunteers and a technical writer to work with your project.

As a relatively new project, Tidier.jl lacks sufficient core documentation and usage guides that make using the tidyverse itself so powerful. We plan to build the following resources: 

- Extensive examples covering all the main functionalities provided by Tidier (see existing examples here: https://kdpsingh.github.io/Tidier.jl/dev/#example)
- Document which packages are included in the Tidier.jl ecosystem (as is done here: https://www.tidyverse.org/packages/)
- Build a minimal viable contributing guide based off of the Julia ecosystem contributor guide build in GSoD 2021)
- Integrate and document Tidier.jl into various resources though the Julia ecosystem (Julia website, Julia Discourse, etc.) in order to ensure the project is visible to Julia users
- Since Tidier.jl is designed to be close syntactically to the tidyverse, there needs to be work done to make sure the documentation for various functions clearly explains how the underlying code works differently in Julia than it would in R.
- Use open source tools or Canva to create necessary visuals for the documentation (no design experince required, just simple visuals for package functionality)


__Work that is out-of-scope for this project__:
- There is no expectation to do any benchmarking of the two tools (Tidier.jl vs the tidyverse)
- While beneficial, we do no expect the technical writer to be deeply profficent in R

### Measuring your project’s success

> How will you know that your new documentation has helped solve your problem? What metrics will you use, and how will you track them?

Today, the adoption of Julia from R users is minimal given the desire to stick with familiar syntax. We expect that with proper documentation, we would be able to have thousands of R users make the transition to Julia in the next few months and put us on the path to the next million Julia developers.

We would consider the project successful if, after the new guide goes live:

- 50% Increase in external contributions after the contributing guide goes live
- Use of Tidier.jl increases by +100% (measured by package downloads)
- All major functionality has an example in the documentation along with sufficiently similar docs to the tidyverse

### Timeline

> How long do you estimate this work will take? Are you able to breakdown the tech writer tasks by month/week?

We estimate that the full project will take ~20 weeks part time. This also accounts for some potential changing priorities given the development speed of Tidier.jl. The tentative timeline would be:

- Week 1: Onboarding
- Week 2-3: Contributor guidelines
- Week 4-8: Document packages that are part of Tidier.jl
- Week 8-16: Add examples for all major facilities 
- Week 16-18: Ensure all functions have sufficiently similar documentation to the tidyverse
- Week 18-20: Wrap up, share Tidier.jl in the Julia and R community

This timeline is tentative and we expect that as the development of Tidier.jl accelerates, priorities may shift slightly to different functionality.

### Project budget

General guidelines

> You can include your budget in your proposal or as a separate link. If your budget is fewer than ten items, we recommend including it in your proposal.

| Budget item                                                               | Amount  | Running Total | Notes/justifications            |
| :------------------------------------------------------------------------ | :------ | :------------ | :------------------------------ |
| Technical writer | 7000.00 | 7000.00       |
| Volunteer Mentor stipends                                                 | 400.00  | 7800.00       | 2 volunteer stipends x 400 each |
| T-shirts for writer and those involved                                                 | 150  | 7950.00       | 5 shirts x 30 each |


We expect the two technical writer mentors to be critical to this process since last year, due to covid in 2020, our main writer was out sick so having multiple people familiar with the project helped to ensure the ultimate success of it.

**TOTAL: 7950.00 USD**

### Additional information

> Previous experience with technical writers or documentation: If you or any of your mentors have worked with technical writers before, or have developed documentation, mention this in your application. Describe the documentation that you produced and the ways in which you worked with the technical writer. For example, describe any review processes that you used, or how the technical writer's skills were useful to your project. Explain how this previous experience may help you to work with a technical writer in Season of Docs.

Previous experience with technical writers or documentation: In 2020, the Julia Language was a mentoring organization and successfully mentored 3 projects through GSoD. In 2020, we also paid our own technical writers to work on various projects following the same timeline as GSoD. These projects proved to be extremely valuable, and we are hoping to build off their success. In 2021, we had one project under the Julia umbrella which despite delays due to COVID and family emergencies ultimately ended up being successful. In 2022, we successfully employed a technical writer who supported the MLJ.jl ecosystem and lead to the amazing new Models section of the docs which is being used to increase the adoption of MLJ. 

In my full-time role (Logan Kilpatrick), I do technical writing on a daily basis and will support the project mentor and well as the technical writer in their work.

> Previous participation in Season of Docs, Google Summer of Code or others: If you or any of your mentors have taken part in Google Summer of Code or a similar program, mention this in your application. Describe your achievements in that program. Explain how this experience may influence the way you work in Season of Docs.

The Julia project has been part of GSoC for many years now. We routinely mentor < 20 students and for the last few years have supplemented GSoC and GSoD by paying contributors and writers directly. We generally only have 1 or max 2 projects which fail GSoC and it tends to be because of some extenuating circumstance. Our mentoring team is robust and has many years of GSoC under its belt. Our contributors also tend to stick around in the community after GSoC. In the case of GSoD, some of our 2020 writers ended up mentoring for 2021 and are still involved in writing on various projects in the community. In 2022, our technical writer was already someone who was deeply involved in using Julia, but not the open source community. This program allowed us to bring them into the community and they have contributed to various projects.
