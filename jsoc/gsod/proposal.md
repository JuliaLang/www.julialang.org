# Google Season of Docs 2021 Proposal

## PROPOSAL TITLE - Create a Comprehensive Julia Contributing Guide

### About your organization

> In this section, tell us about your organization or project in a few short paragraphs. What problem does your project solve? Who are your users and contributors? How long has your organization or project been in existence? Give some context to help us understand why funding your proposal would positively impact open source and the world.

The Julia Programming Language (current version 1.5.4, first released in 2012) is an MIT-licensed High-performance programming language designed for speed, usability, and reproducibility. Given Julia’s speed, it is considered by many to be the best-in-class tool for scientific computing. Since 2012, the domain in which Julia is being used to solve complex computation problems has expanded along with our user base. We currently have over 5,000 registered Julia packages, 25 Million + downloads of Julia, and thousands of contributors worldwide. Julia is also one of the fastest-growing (IEEE Programming Language rankings 2019) and most loved (2019 Stack Overflow Developer Survey) programming languages due in large part to the dedicated community of users and developers alike. Given that the Julia community is still relatively small, we feel that strategic investments now in making the language and ecosystem friendly to new contributors will enable the next generation of developers to be a part of this friendly and vibrant community.
About your project

### Your project’s problem

> Tell us about the problem your project will help solve. Why is it important to your organization or project to solve this problem?

Right now, when someone wants to get started in Julia with the intent to contribute to Julia Packages across the ecosystem or the core language, there is really no guide to help them. We implicitly require that folks already have some background in OSS as well as an understanding of the inner workings of the Julia Ecosystem. This may have been a fair assumption to make in the past, but as Julia continues to grow in popularity, more and more folks are coming to try. Julia does not have an extensive Open Source nor technical background, so we need to step up and meet our community where they are. This project would create a comprehensive contributor guide geared to be a one-stop-shop for all things contributing to Julia. It would cover the basics of OSS, how to get involved with a project, what to say to open source maintainers, how to structure your PR’s to make sure they get approved, and much more. Most of these ideas have been articulated already, and we would just be including them in our guide. Our hope with this project is that it would significantly reduce the barrier to entry for folks interested in learning Julia and making contributions to the core language or the package ecosystem.

### Your project’s scope

> Tell us about what documentation your organization will create, update, or improve. If some work is deliberately not being done, include that information as well. Include a time estimate and whether you have already identified organization volunteers and a technical writer to work with your project.

The project to update the contributing guide will:

- Audit the existing contributing guide for the core language (https://github.com/JuliaLang/julia/blob/master/CONTRIBUTING.md)
  Work with community leaders and members to identify the different groups of folks we want to write guides for (students, professionals, open-source enthusiasts, etc.)
- Create guides geared towards each of these different groups (perhaps making them similar in content but with different levels of verboseness)
- Create general guides for things like making a Pull Request or Opening an Issue (leveraging existing materials we have).
- Highlight all of the non-technical ways folks can contribute to the Julia Language and the ecosystem.
- Work with existing and new community members to make sure that the new section of the website (https://julialang.org/contribute/) is comprehensive yet still light-handed such that first-time contributors are not overwhelmed.
  Work that is out-of-scope for this project:
- Unless significant issues are uncovered with the contributing guide (https://github.com/JuliaLang/julia/blob/master/CONTRIBUTING.md), updating that document will be out of scope.
- One of our community members has written a great first PR guide (https://kshyatt.github.io/post/firstjuliapr/) we plan to leverage this to avoid duplicating any work.
  We currently have a couple of technical writers who have expressed interest (introduced to us by some of our 2020 GSoD writers) in working with the Julia Language for 2021. We also plan to put out a call for interest in our Discourse shortly after submitting our application. This project will be supported by Avik Sengupta, Viral Shah, with input from our past GSoD writers, who will provide periodic reviews. We will also seek input from the community via PR review and feedback requests on https://Discourse.julialang.org.

### Measuring your project’s success

> How will you know that your new documentation has helped solve your problem? What metrics will you use, and how will you track them?

Given the scope of this project and the large base of existing contributors, we intend to be very intentional about how we try to measure success. On the one hand, it will be simple to track core Julia Language contributors (and hopefully increase the number of PR’s made and merged by new folks). However, the scope of this project is beyond core Julia itself and extends to the entire Julia Ecosystem. That is why we plan to try and add a hashtag or a specific bot user, which we ask folks to tag on GitHub when making a PR/Issue/Commit inspired by the new contributing guide (think to cite a paper). This will help us better understand the broader impact of the guide outside the bounds of the core Julia repo.
We will track two main metrics each month after the guide goes live—first, the number of pageviews the new contributing guide section receives. Second, the number of folks who “@” mention the contributor guide bot user, which would look something like: “Here is my PR, it does XYZ, etc. @JuliaContributorBot”. Note that this may be a hashtag instead. We need to explore which is easier to track on GitHub. This will show us that folks read the guide and allow us to track the impact across the entire ecosystem.

We would consider the project successful if, after the new guide goes live:

- 100 + mentions of the Contributing guide on GitHub per month (this number is likely to start off smaller as we ramp up awareness of the new doc and tagging process)
- 3,000 + pageviews on the guide per month (this is slightly lower than our “learning page” gets per month, so we think this is a realistic number, and we expect it to grow over time)

### Project budget

General guidelines

> You can include your budget in your proposal or as a separate link. If your budget is fewer than ten items, we recommend including it in your proposal.

| Budget item                                                               | Amount  | Running Total | Notes/justifications            |
| :------------------------------------------------------------------------ | :------ | :------------ | :------------------------------ |
| Technical writer audit and creation of a comprehensive contributor guide. | 6000.00 | 6000.00       |
| Volunteer Mentor stipends                                                 | 400.00  | 6800.00       | 2 volunteer stipends x 400 each |

**TOTAL: 6800.00 USD**

### Additional information

> Include here any additional information that is relevant to your proposal.

Previous experience with technical writers or documentation: In 2020, the Julia Language was a mentoring organization and successfully mentored 3 projects through GSoD. In 2020, we also paid our own technical writers to work on various projects following the same timeline as GSoD. These projects proved to be extremely valuable, and we are hoping to build off their success. This year, we asked a couple of our successful GSoD students to leverage their technical writing experience and come back as mentors. We are really excited to have these mentors stay in the community with us and hopefully help the next round of technical writer(s).

Previous participation in Season of Docs, Google Summer of Code, or others: In 2020, the Julia Language successfully mentored 3 GSoD projects. 2020 being our first year in GSoD, we learned a ton about what we need to do to support technical writers better. A big lesson learned was the need for project and writer mentors. This is something that we are doing in 2021 with the hope of having content feedback for writer(s) and mentors with technical writing expertise so our writer(s) can continue developing their skills. Another welcome change for GSoD 2021, which we would have implemented on our own, but is not part of the core program, is monthly updates. Given that the timelines can be longer for these projects, it makes sense to check in regularly.
