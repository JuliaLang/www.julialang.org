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

# Unifying the [JuliaHeath Organization](https://github.com/JuliaHealth) Documentation Landscape

## About your organization 
> [!Note]
In this section, tell us about your organization or project in a few short paragraphs. What problem does your project solve? Who are your users and contributors? How long has your organization or project been in existence? Give some context to help us understand why funding your proposal would create a positive impact in open source and the world.

The Julia Programming Language is an MIT-licensed high-performance programming language designed for speed, usability, and reproducibility within both scientific and general purpose computing.
Currently the Julia community has over 7,000 registered Julia packages, 35 million+ downloads of Julia, and thousands of contributors worldwide.
Julia's popularity continues to grow thanks to the dedicated community of users and developers who have helped develop several smaller specialty ecosystems within Julia.

In particular, the [JuliaHealth Organization](https://github.com/JuliaHealth/) is one such ecosystem that was originally organized and founded 2020.
It is an organization dedicated to improving healthcare by developing open-source tools to work with a variety of health data and promotes interoperable data standards within the broader health research community.
The community is made up of health researchers, data scientists, software developers, and healthcare professionals who are passionate about using Julia to investigate and improve patient outcomes and promote data-driven decision-making.

Over the past four years, our organization membership has grown to more than 60 members actively working on the dozens of JuliaHealth packages we house.
As the entire JuliaHealth user community comprises more than 250 registered users across the Julia Slack and Julia Zulip instances, niche subecosystems have organically arisen under the JuliaHealth umbrella.
Currently, there are various subecosystems such as the Medical Imaging and the Observational Health subecosystem with more subecosystems beginning to emerge.

## Your project’s problem
> [!Note]
Tell us about the problem your project will help solve. Why is it important to your organization or project to solve this problem?

With JuliaHealth's terrific growth over the years -- both in terms of growth in users, members, and actively maintained packages -- we are beginning to see the need for more unified documentation.
Without this unified documentation, we are seeing:

- User confusion due to the lack of documentation around subecosystems (including both emerging and established subecosystems)

- Developing fragmentation of documentation across packages

- Lack of clarity in how users and developers can compose packages together across JuliaHealth and the broader Julia ecosystem to accomplish research tasks

In some ways, this is a very good place to be in in that we have grown to the point of having these issues.
Users and developers want to engage with the JuliaHealth community, but if we do not provide a more unified documentation approach, we could potentially lose members or new contributors and stagnate our growth.

### Project Impact
- By providing clearer guidance and improving accessibility, we seek to make navigating the different aspects of the JuliaHealth organization seamless and intuitive.
- We envision through participation in GSoD that by developing enhanced and unified documentation, we can assist all community levels within the JuliaHealth ecosystem.
- Additionally, as we construct solutions within JuliaHealth to address the needs we have encountered as a growing organization, we will share our insights to the broader Julia community to illustrate various methods other ecosystems within Julia can adapt to meet growing demand.

## Your project’s scope
> [!Note]
Tell us about what documentation your organization will create, update, or improve. If some work is deliberately not being done, include that information as well. Include a time estimate, and whether you have already identified organization volunteers and a technical writer to work with your project.

Although there are many subecosystems within JuliaHealth, our project will be scoped to specifically the Medical Imaging subecosystem as it has grown mature enough to encounter many of these problems already.
Working on documentation around the Medical Imagining subecosystem will benefit the rest of the JuliaHealth ecosystem as it will provide a roadmap for how other subecosystems can best document themselves and support their users.

To better position the Medical Imaging subecosystem within the JuliaHealth organization, we will first have to do some general documentation improvements to the main JuliaHealth website.
This includes:
- Upgrade website to latest Julia documentation deployment tool
     - DocumenterVitepress.jl may be one target
- Add additional organization details for JuliaHealth overall including:
     - A new landing page for the subecosystems
          - Medical Imaging
          - Observational Health
          - Standards and Interoperability
     - Package breakdown using our pre-existing package listing tool
- Add FAQ or support page
- Define and implement tracking metrics to monitor user engagement and interaction with the platform
     - Using an open source and GDPR compliant technology like GoatCounter
     
Once this initial groundwork is done, we will then address some of the specific core tooling within the Medical Imaging subecosystem.
Due to the modular nature of packages within this subecosystem, we will need to improve documentation across various packages to show what they should be used for, how they integrate with one another, and how to onboard as a potential new contributor:

- Documentation tasks for [MedImage]( https://github.com/JuliaHealth/MedImage.jl)
     - Introduction to the theory of medical imaging formats and spatial metadata 
     - Describe how to load and save image
     - Describe how apply basic transformation using MedImage
- Documentation tasks for [MedEye3d](https://github.com/JuliaHealth/MedEye3d.jl)
     - Write tutorial how to configure window size and amount of space allocated to text
     - Give detailed tutorial describing the possible configurations using TextureSpec objects
     - Add the section with all keyboard shortcuts and print screens showing their effects
     - Describe possible user interactions including:
         - Using tool with REPL for fast debugging, include how to modify and refresh image manually
         - Describe manual interaction of modifiable masks
- Documentation tasks for [MedEval3D](https://github.com/JuliaHealth/MedEval3D.jl)
     - Describe different metrics and what are their strength and weaknesses
     - Make a tutorial showing how to use each metric
- Documentation tasks for [MedPipe3D](https://github.com/JuliaHealth/MedPipe3D.jl)
     - Describe how to use Medpipe functionalities in different use cases
     - Give introduction to the functionalities in development like augmentations, largest component analysis or hyperparameter tuning (without usage examples)

- Documentation tasks for [KomaMRI](https://github.com/JuliaHealth/KomaMRI.jl):
     - Through coordination with the KomaMRI volunteers, [outstanding issues from KomaMRI will be addressed](https://github.com/JuliaHealth/KomaMRI.jl/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3Adocumentation)

Finally, if time permits, there will be some additional stretch goals that we would like to attempt accomplishing:
- Page for ongoing projects across JuliaHealth
- Page for research accomplishments within JuliaHealth
- Write a JuliaHealth blog entry on a Medeye topic to broaden project reach

#### Technical Writer

Name: [Sneha Pandey](https://github.com/sneha9231)

Sneha Pandey is a sophomore specializing in AI and ML and also serves as a Microsoft Learn Student Ambassador. Through this role, she had refined her ability to communicate complex concepts effectively to diverse audiences. Additionally, She had gained experience as a content writer, crafting content for her university. She has hands-on experience in developing various mini projects, such as a WhatsApp bot and ML captioning models using Streamlit and Python. Her familiarity with Julia stems from previous engagements in medical imaging alongside MD PhD Msc Jakub Mitura. Moreover, She ensured comprehensive documentation of her personal projects using Documenter.jl. These experiences collectively equip her with the skills and proficiency required to excel as a technical writer within the Julia ecosystem.

#### Volunteer Roles
**Volunteer 1: General JuliaHealth Organization Volunteer:**

Name: Jacob S. Zelko

Duties:

1. Providing support for general JuliaHealth documentation tasks.
2. Assisting in reviewing documentation pull requests (PRs) periodically.
3. Deploying documentation within the Julia ecosystem as needed.
4. Handling miscellaneous tasks as they arise.
5. Serving as a general support role while integrating Technical Writer's work into the broader JuliaHealth ecosystem.

**Volunteer 2: JuliaDocs and Documentation Deployment Volunteer:**

Name: Anshul Singhvi

Duties:

1. Transition support the main JuliaHealth page to the designated technology platform.
2. Provide guidance on safely implementing tracking metrics to monitor user engagement and interaction with the platform.
3. Offer technical consultation and guidance as needed throughout the project duration.
4. Help fix issues or rememdy needs that may arise from using tools from within the JuliaDocs ecosystem

**Volunteer 3: Medical Imaging Subecosystem Volunteer:**

Name: Guillermo Sahonero Alvarez

Duties:

1. Provide guidance on medical imaging theory and spatial metadata
2. Support in connecting imaging discussions to other aspects of the Julia ecosystem (such as MLJ or JuliaImages)
3. Provide subject matter expertise on imaging standards
4. Assist in writing theorethical introductions

**Volunteer 4: Task consultations on packages functionalities and function documentations**

Duties:

1. Support for technical writer related to practical development issues of Julia programming languages
2. To help checking weather docstrings of functions are working correctly
3. Collaborate with KormaMRI to create specialized documentation sections based on their research paper, covering advanced topics or techniques relevant to medical imaging.

### Work that is out of scope for this project:
To explicitly enumerate what work is out of scope for this project, we do not plan for work done in the following spaces:

- Developing thorough documentation for other subecosystems
- Any of the aforementioned medical imagining packages not related to documentation
     - Adding docstrings or crosslinks may fall in scope depending on the needs per task

## Measuring your project’s success
> [!Note]
How will you know that your new documentation has helped solve your problem? What metrics will you use, and how will you track them?

Currently, the documentation we do have does not yet have support for documentation traffic analytics.
As of this moment, our best direct source for traffic metrics is to use [JuliaHub](https://juliahub.com/ui/Packages?q=JuliaHealth/) to monitor package downloads and also to reference GitHub stars for a loose approximation of "discoverability".
Additionally, we take advantage of the [The Julia Programming Language YouTube Channel](https://www.youtube.com/@TheJuliaLanguage) that we use to monitor engagement with our recorded [JuliaHealth Workgroup meetings](https://www.youtube.com/playlist?list=PLP8iPy9hna6QCTkFxfHs2Y4foaYBJAjzO).
In these situations, potential users or contributors would have to know where to look to find these resources or entry points to our supported packages and their respective subecosystems.
#### We would consider the project successful if :

For JuliaHealth, we would consider this project successful if:
- We can readily track documentation traffic across packages
     - Encompasses deploying a safe traffic detection tool
     - Seeing at least a 10 - 15% growth in traffic after the deployment of tracking
- An overall increase by 5 - 10% in traffic across all JuliaHealth platforms
     - Includes JuliaHub, YouTube, GitHub, and documentation statistics
- Most (if not all) enumerated documentation tasks are completed for the Medical Imaging subecosystem
     - Some Related Issue Links:
[Sub-Package Documentation 1](https://github.com/JuliaHealth/MedPipe3D.jl/issues/10)
[Sub-Package Documentation 2](https://github.com/JuliaHealth/MedEye3d.jl/issues/10)
[Sub-Package Documentation 3](https://github.com/JuliaHealth/MedEye3d.jl/issues/11)
[Sub-Package Documentation 4](https://github.com/JuliaHealth/MedEye3d.jl/issues/9)

- At least 3 - 5 new active JuliaHealth contributors across the JuliaHealth ecosystem are onboarded
     - Tracked across GitHub contribution history
- A new blog post is published

## Timeline
> [!Note]
How long do you estimate this work will take? Are you able to breakdown the tech writer tasks by month/week?

We assume the tech writer will put in part time hours (10-20 hours/week) during this time.
### Monthly Plan

| Dates | Action items |
| ------------- | ------------- |
| May |  Technical writer and volunteers are hired, onboarding  |
| June-July  | Research into Julia community, Audit existing documentation |
| August-September | Create Standard Package Documentations, Medical imaging subecosystem documentation  |
| October |  Improvements to the main page of JuliaHealth |
| November | Write a blog post, Any outstanding tasks or stretch goals |

### Weekly Plan

- **Week (1-2)** - Reading and Familiarization

- **Week (3-4)** - Documentation Traffic Tracker Setup

- **Week (5-7)** - Setting up the environment and Updating Organization Details & Creating Subecosystem Sections

- **Week (8-10)** -  Linking Packages across subecosystems

- **Week (11- 16)** - Medical Imaging Subecosystem Packages Documentation

- **Week (17- 20)** - Review and Finalize Website Content also Feedback Incorporation

- **Week (20-24)** - Wrap up / touch up of overall packages docs page alongside stretch goals

This timeline is largely accurate but we expect that different packages or tasks may be slightly more challenging than others.
The November time period gives us the opportunity to revisit any unfinished tasks and to potentially explore stretch goals if there were not many outstanding tasks left.

### Communication Plan: 
The primary communication channel we will use is [Julia Slack](https://julialang.org/slack/) and Dr. Jakub Mitura (MD, PhD) will be the individual responsible for all contact and mentoring throughout the project for regular updates and meetings.
Outside of Slack, email will be used to handle communications with GSoD organizers and administrators with Jakub Mitura's email being: [jakub.mitura14@gmail.com](mailto:jakub.mitura14@gmail.com).
Volunteers will also be available for communication on the Slack on an as-needed basis.
Additionally, project updates will be given through the [Julia Health Slack Channel](https://app.slack.com/client/T68168MUP/C012NN70P5K) which is where the majority of JuliaHealth communication takes place between members, users, and the rest of the Julia community.

## Project Budget
> [!Note]
You can include your budget in your proposal or as a separate link. If your budget is fewer than ten items, we recommend including it in your proposal.

| Budget item | Amount | Running total |
| ------------- | ------------- | ------------- |
| Technical writer | $4000 | $4000  |
| Volunteer (500x4) | $2000 | $6000  |
| Swags (3 shirts and 10 sticker packs) | $125 | $6125  |
| TOTAL |   | $6125 |

Additional justifications:

- Volunteers: Please see the above section on Project Scope for details about selected volunteers
- Swag: is to create a more welcoming environment for our writer and volunteers
     - Sticker packs will also be given to welcome new contributors

### Additional information:
> [!Note]
Beyond the above proposal information, some additional notes about the composition of this project team:

**About GSoD Project Lead:**

MD PhD Msc Jakub Mitura Researcher specialising in creating artificial intelligence models for medical imaging. Holds a doctorate in medical sciences with a thesis titled ‘The Role of Positron Emission Tomography Using Fluorodeoxyglucose in the Diagnosis of Vascular Prosthesis Infections.’ Additionally, holds a master’s degree in informatics with a specialisation in Big Data. Has authored scientific publications in the fields of medicine and artificial intelligence.

**Additional Volunteer Notes:**

Jacob Zelko was selected as a volunteer as he has a proven track record as a successful Google Summer of Code mentor for the past 3 years and is currently the Julia Organization's co-administrator for this years Google Summer of Code where he handles questions from both students and mentors.
Given his experience, Jacob will provide guidance to Jakub and Sneha as needed to make sure this project is well-aligned with general Google Open Source program goals.
Additionally, Jacob has a overseen many grants in the past through Google Summer of Code and former positions at Georgia Tech Research Institute and the Centers for Disease Control and will provide a valuable asset in answering any questions about the project scope.

Anshul Singhvi is a former Google Summer of Code student and has a vast swath of experience of working across the Julia ecosystem.
In particular, Anshul has membership with numerous Julia organizations and will be a crucial asset to not only what are best practices for documentation deployment but can also help with how to best unify JuliaHealth packages within JuliaHealth itself and potentially across the greater Julia landscape.
His insight will be crucial to mitigate any redundant work or answer outsanding questions to make sure this project is ran as effectively as possible.
Also, given Anshul's tremendous experience in delivering contract work, he will be key in making sure the metrics we investigate and report on for the case study in our final report will be done rigorously and to the best of the technical writer's ability given the data we have access to.

</div>
