# Constraint Programming in Julia – Summer of Code

[JuliaConstraints](https://juliaconstraints.github.io/) is an organization supporting packages for Constraint Programming in Julia. Although it is independent of it, it aims for a tight integration with JuMP.jl over time. For a detailed overview of basic Constraint Programming in Julia, please have a look at our video from JuliaCon 2021 [Put some constraints into your life with JuliaCon(straints)](https://youtu.be/G4siuvNMj0c).

### General goal of JuliaConstraints

Often, problem-solving involves taking two actions: model and solve. Typically, there is a trade-off between ease of modeling and efficiency of solving. Therefore, one is often required to be a specialist to model and solve an optimization problem efficiently. We investigate the theoretical fundamentals and the implementation of tools to automize and make optimization frameworks. A general user should focus on the model of practical problems, regardless of the software or hardware available. Furthermore, we aim to encourage technical users to use our tools to improve their solving efficiency.

**Mentor:** [Jean-Francois Baffier](http://baffier.fr/) ([azzaare@github](https://github.com/Azzaare))

## Constraint Programming-Based Design for Kumi Kumi Slope


This project is at the forefront of developing a level-design tool for the Kumi Kumi Slope game, leveraging the Julia programming language's capabilities. It prioritizes creating an interactive graphical user interface (GUI) for users to actively engage in design optimization. While (GL)Makie.jl is a strong candidate for this GUI, the project remains open to other innovative solutions, such as a Genie.jl-based interface, to accommodate diverse development preferences. Key to this initiative is handling arbitrary domains, generating pools of solutions for multi-objective optimization, and providing visual outputs of game designs. This venture into Constraint Programming (CP) sets the groundwork for efficiency in design while embracing user-defined aesthetic goals and marks a pioneering step towards human-machine collaboration in architectural design.

### Core Objectives

1. **Multi-Objective Optimization and Arbitrary Domains (100-150 hours)**

   - *Framework for Multi-Objective Optimization*: Establish a robust framework to tackle multiple objectives simultaneously, ranging from efficiency and compactness to playability and aesthetics.
   - *Support for Arbitrary Domains*: Craft a method to define and manipulate arbitrary domains within the CP model, enabling a wide array of component types and design constraints.

2. **Pools of Solutions and Interactive GUI Development (150-200 hours)**

   - *Generation of Solution Pools*: Design algorithms to create diverse pools of feasible solutions, catering to different optimization criteria and user preferences, fostering a nuanced approach to human-machine collaboration in design.
   - *Interactive GUI Development*: Embark on the development of an interactive GUI, with (GL)Makie.jl or alternative tools, to facilitate the visualization and manipulation of Kumi Kumi Slope designs, empowering users to explore, select, and refine designs in a user-centric environment.

3. **Visual Output and User Interaction (100-150 hours)**

   - *Visual Representation of Designs*: Guarantee that all potential solutions are visually represented within the GUI, enhancing user ability to evaluate and contrast different designs.
   - *Feedback Mechanism for Design Refinement*: Integrate a feedback loop in the GUI, allowing user interactions to refine the solution pool, aligning it closer to user preferences and exemplifying the project's commitment to human-machine collaborative design.


This proposal aims to deliver a significant and impactful tool by the end of the GSoC period. It encourages candidates to dive deep into areas of particular interest, providing flexibility in project focus. By emphasizing realistic targets like the development of an interactive GUI and foundational work on handling arbitrary domains and multi-objective optimization, this project sets a precedent for future advancements in game design and opens the door to broader applications requiring sophisticated design and optimization tools.


