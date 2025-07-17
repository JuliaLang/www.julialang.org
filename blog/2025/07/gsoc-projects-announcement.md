+++
title = "Announcing Google Summer of Code 2025 selected projects"
authors = "Julia GSoC admin team"
published = "17 July 2025"
rss_pubdate = Date(2025, 07, 17)
rss = "Announcing Google Summer of Code 2025 selected projects"
+++

# Announcing Google Summer of Code 2025 selected projects

— Orestis Ousoultzoglou on behalf of [the admin team](https://julialang.org/jsoc/admins/)

The Julia Project is [participating](https://summerofcode.withgoogle.com/programs/2025/organizations/the-julia-language) in [Google Summer of Code (GSoC)](https://summerofcode.withgoogle.com/) again this year. GSoC is a global program organized by Google that is designed to bring new contributors to the world of open-source.

Earlier this year, we published a list of [GSoC project ideas](https://julialang.org/jsoc/projects/), and started discussing these projects with potential GSoC applicants on our [Slack](https://julialang.slack.com/archives/C67L30Z3L). We had many interesting discussions with the potential contributors, and even saw some of them making non-trivial contributions, even before GSoC officially started!

After the initial discussions, GSoC applicants prepared and submitted their project proposals. We received a whopping 85 proposals this year! We are happy to see that there was so much interest in our projects.

A team of mentors primarily composed of Julialang contributors then thoroughly examined the submitted proposals. GSoC required us to produce a ranked list of the best proposals, which was a challenging task in itself since this is an umbrella organization with many priorities! The admin team considered factors such as prior conversations with the given applicant, the quality of their proposal, the importance of the proposed project for the Julia ecosystem and its wider community, but also the availability of mentors, who are often volunteers and thus have limited time available for mentoring.

As is usual in GSoC, even though some project topics received multiple proposals, we had to pick only one proposal per project topic. We also had to choose between great proposals targeting different work to avoid overloading a single mentor with multiple projects.

In the end, we narrowed the list down to a smaller number of the best proposals that we could still realistically support with our available mentor pool. We submitted this list and eagerly awaited how many of them would be accepted into GSoC.

## Selected projects

On the 8th of May, Google has announced the accepted projects. We are happy to share that **14** proposals were accepted by Google for Google Summer of Code 2025. That's a lot of projects, which makes us super excited about GSoC 2025!

Below you can find the list of accepted proposals (in no particular order), along with the names of their authors and the assigned mentor(s):

- **[Extending Reachability Analysis with Matrix Zonotopes in Reachability Analysis.jl](https://summerofcode.withgoogle.com/programs/2025/projects/lTdvJXDe)** by Alessandro Carraro, mentored by Christian Schilling and Marcelo Forets
- **[Sharing is Caring: Improving the Julia GPU Stack Portability](https://summerofcode.withgoogle.com/programs/2025/projects/9M7UdqlC)** by Christian Guinard, mentored by Valentin Churavy and Tim Besard
- **[Improving the Performance of GNNs Using Sparse Linear Algebra](https://summerofcode.withgoogle.com/programs/2025/projects/pVuVXJ5N)** by Davide Ferre', mentored by Carlo Lucibello
- **[Integrating Agents.jl with Reinforcement Learning Techniques](https://summerofcode.withgoogle.com/programs/2025/projects/T5qvWEvO)** by Giorgio Bertone, mentored by Giorgos Datseris and Adriano Meligrana
- **[Implementing a Graph-State Backend for QuantumClifford.jl](https://summerofcode.withgoogle.com/programs/2025/projects/vEtdXncS)** by Kanyang Ying, mentored by Stefan Krastanov and Andrew Kille
- **[Supporting Patient Level Prediction Pipelines within JuliaHealth](https://summerofcode.withgoogle.com/programs/2025/projects/xpSEgu5b)** by Kosuri Lakshmi Indu, mentored by Jacob Zelko
- **[Ab-Initio Quantum Chemistry with Rimu.jl](https://summerofcode.withgoogle.com/programs/2025/projects/rIUlYnPe)** by Chuhao Li, mentored by Joachim Brand, Daniel Kats, and Elke Pahl
- **[R interface for JuliaBUGS](https://summerofcode.withgoogle.com/programs/2025/projects/WgOorFxH)** by Mateus Maia, mentored by Xianda Sun and Robert Goudie
- **[Improving search functionality for Documenter.jl](https://summerofcode.withgoogle.com/programs/2025/projects/KGUrSI9I)** by Mohd Rahban Ghani, mentored by Morten Piibeleht and Hetarth Shah
- **[Time series forecasting at scales](https://summerofcode.withgoogle.com/programs/2025/projects/gy5J7ewY)** by Priyansh Jain, mentored by Andrii Babii
- **[Browser-Based Graphical Interface for JuliaBUGS](https://summerofcode.withgoogle.com/programs/2025/projects/4ecMbDwU)** by Shravanpuri Goswami, mentored by Xianda Sun
- **[Efficient RMA Integration and Graph Partitioning for Scalable Task Execution in MPI-based Dagger.jl](https://summerofcode.withgoogle.com/programs/2025/projects/aCA4KJ3B)** by Yan Guimarães, mentored by Julian Samaroo and Tom Felipe
- **[Development of a New Language Server for Julia](https://summerofcode.withgoogle.com/programs/2025/projects/9PZY6C2m)** by Yuchi Yamaguchi, mentored by Shuhei Kadowaki
- **[A Digital Twin approach for Advanced Supervoxel Visualization for Multi-Image View in Imaging](https://summerofcode.withgoogle.com/programs/2025/projects/0MEiJ7Ty)** by Divyansh Goyal, mentored by Jakub Mitura
  
**Congratulations to all applicants whose project was selected!** The mentors are looking forward to working with you on these exciting projects to improve the Julia ecosystem. You can expect to hear from us soon, so that we can start coordinating the work on your GSoC projects.

We would also like to thank all the applicants whose proposal was sadly not accepted, for their interactions with the Julia community and contributions to various Julia projects. Even if your proposal was not accepted, we would be happy if you would consider contributing to the projects that got you interested, even outside GSoC! Our [project idea list](https://julialang.org/jsoc/projects/) is still actual and could serve as a general entry point for contributors that would like to work on projects that would aid the Julia ecosystem. You can always [reach out to us](https://julialang.org/community/) and we'll make sure to help you in any way we can.

There is also a good chance we'll participate in GSoC next year as well (though we can't promise anything at this moment), so we hope to receive your proposals again in the future!

The accepted GSoC projects will run for several months. After GSoC 2025 finishes (in autumn of 2025), we will publish a blog post in which we will summarize the outcome of the accepted projects.

---

We've reached out to the GSoC 2025 contributors, and some of them wanted to communicate what they'll be working on to the outside world:

Christian Guinard:

> "My project involves incorporating specialized GPU kernels into the shared GPUArrays.jl backend using KernelAbstractions.jl to enable high-performance operations in all GPU backends while only writing them once. I will also be expanding tests and banchmarks to ensure no performance or functional regressions from this transition. I've been helping maintain Metal.jl for that past while now and I'm excited to contribute to the wider JuliaGPU project!"

Shravan Goswami:

> I'm working on a browser-based tool for [JuliaBUGS.jl](https://github.com/TuringLang/JuliaBUGS.jl) that lets users draw probabilistic models and generate code from DAGs. The goal is to make it easier to work with Bayesian models in Julia, especially for beginners. I made an initial prototype during the community bonding period.
  
> This is my first GSoC, but I actually applied in 2023 and wasn’t selected. Since then, I’ve learned a lot, and the Julia community has been a big part of that. Julia has given me a lot—not just in terms of skills, but also through the support and guidance I’ve received from the people here. I’ll be sharing my journey throughout the summer on my blog: [https://shravangoswami.com/](https://shravangoswami.com/). Here’s the first post about getting selected: [https://shravangoswami.com/blog/GSoC-2025-The-Journey-Begins/](https://shravangoswami.com/blog/GSoC-2025-The-Journey-Begins/)

Rahban Ghani:

> The project I am working on is improving the search functionality for Documenter.jl. I am writing  benchmarks for search relevance and then I will improve it by enhancing the tokenizer, making sure search index is getting the correct inputs and many other different techniques.

> My involvement with the community so far has been phenomenal. Everybody here is super kind and helpful. There have been numerous instances where I was stuck somewhere and the Julia community came to the rescue

Kosuri Lakshmi Indu:

> My project title goes by "**Supporting Patient-Level Prediction Pipelines within JuliaHealth**". The goal is to make patient-level prediction (PLP) workflows more efficient and reproducible by developing a standardized Tables.jl interface for OMOP CDM, along with a cohort feasibility assessment tool. These tools will help automate data preprocessing, simplify cohort construction and connect smoothly with the JuliaHealth ecosystem.

> My interest in healthcare and research naturally led me to JuliaHealth. I first got involved by working on a pipeline to predict diabetes onset in hypertensive patients, which gave me hands-on experience with Julia and the challenges of working with observational health data, all under the mentorship of Jacob S. Zelko ([@TheCedarPrince](https://julialang.slack.com/team/US64J0NPQ)), who guided me through each step and made the learning experience incredible. With his continued support, I went on to publish a blog series on Patient-Level Prediction (PLP) in Julia on the JuliaHealthBlog and so far the feedback and encouragement from the community has been great.

> Yep that's it and am looking forward to an exciting and productive coding period ahead!

> **P.S.** When I first joined the Julia Slack, you were the first person to welcome and guide me, just wanted to say thank you for making the space feel so warm and approachable right from the beginning!

Kanyang Ying:

> In a nutshell, my project will basically implement an alternative simulation backend for QuantumClifford.jl to speedup simulation for certain types of quantum circuit.

Alessandro Carraro:

> Hi, I am Alessandro! I'm currently working on extending the ReachabilityAnalysis.jl package by adding new algorithms that use matrix zonotopes as a matrix set representation. It's been a really fun and interesting project so far as there’s a nice mix of understanding the maths and thinking about how to design the code efficiently in a Julian way. I've also really enjoyed being part of the Julia community. Everyone’s been super welcoming, and my mentors have been very supportive and helpful.

Davide Ferre':

> This summer I’ll be working on improving GPU support for sparse operations in Julia, with the goal of making Graph Neural Networks more efficient via GraphNeuralNetworks.jl and CUDA.jl. These improvements should help reduce memory overhead and accelerate message-passing operations in GNNs. I’m really excited to contribute to the Julia ecosystem in an area that ties closely to my PhD research on neural networks and graphs.

Yuchi Yamaguchi:

> I’m Yuchi (https://github.com/abap34), an undergraduate student in Computer Science at the Institute of Science Tokyo. My main research focus is programming languages, but I also work in machine learning, statistics, and mathematical optimization — all areas where Julia truly shines. I've been using Julia for over 6 years.

> For Google Summer of Code, I’m working on the project “Development of a New Language Server for Julia.” This is a very exciting project to build a brand-new Language Server that provides powerful analysis by leveraging Julia’s latest compiler infrastructure. The new language server effectively use tools like JET (developed by my mentor Shuhei Kadowaki, who is also leading this project), JuliaSyntax.jl and JuliaLowering.jl. This will allow us to develop a Language Server that can detect potential bugs more effectively, report precise and fast diagnostics, and remain highly maintainable.

> I believe the new Language Server can significantly help developers write safer and higher-performance code. It will also improve my own experience of writing Julia, which is probably the biggest motivation for me to work on this project! My proposal focuses on implementing a variety of core features and improving performance, but I'm eager to contribute whatever make the Language Server practically useful as soon as possible :)

> Lastly, I want to thank my mentor Shuhei Kadowaki and the whole team for their ongoing support!

Mateus Maia:

> Hello! I’m Mateus, a Research Associate in Statistics at the University of Glasgow. As part of GSoC 2025, I’ll be working on developing an **R interface for JuliaBUGS**, under the umbrella of the Turing.jl project.

> The goal of this project is to make **JuliaBUGS**—a modern implementation of the BUGS language in Julia—available to the large community of R users who already rely on BUGS-based tools such as R2WinBUGS, R2OpenBUGS, and rjags. This new interface will allow users to access JuliaBUGS directly from R, combining the familiarity of existing BUGS workflows with Julia’s performance and advanced features like automatic differentiation and Hamiltonian Monte Carlo. It also opens the door to integrating powerful R-based visualization and diagnostics tools (like `bayesplot`, `posterior`, and `coda`) into Julia-based workflows.

> The project will use `JuliaCall` to facilitate the R–Julia connection and will include extensive documentation, examples, and a user-friendly design to help onboard users with minimal friction.
> While my background is mostly in Bayesian modeling with R—where I’ve developed and maintained several R packages—I’ve recently been exploring Julia’s capabilities and see this project as a great opportunity to contribute meaningfully to the community. I’m looking forward to engaging more with the Julia ecosystem and helping expand its accessibility, particularly for statisticians and applied researchers coming from R.

Yan Guimarães:

> My name is Yan Guimarães, and I'm working on optimizing MPI integration in Dagger, which involves enhancing the communication methods between ranks to achieve better performance in task distribution. I'm loving my experience with the Julia project this summer. At the beginning of this year, I had no idea I would be working with the Julia community, especially in parallel computing. I am surprised by how much I have grown my knowledge, not just in parallel computation, but also in code improvement, how computers work, and the significant impact of having great mentors on the learning process. I can only share positive feelings about my experience in the Google Summer of Code within the Julia community.
