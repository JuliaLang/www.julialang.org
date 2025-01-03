+++
title = "The SatelliteToolbox.jl Ecosystem"
authors = "Ronan Arraes Jardim Chagas"
published = "3 January 2025"
rss_pubdate = Date(2025, 01, 03)
rss = """The history of the SatelliteToolbox.jl ecosystem"""
+++

![](/assets/blog/2024-SatelliteToolbox/logo-reduced.png)

The [SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) is an ecosystem
of packages that enables the execution of a wide range of analysis tasks related to space
missions in the Julia programming language. These tasks encompass the propagation of
satellite orbits, the transformation of reference systems, the computation of atmospheric
density, and numerous other functionalities.

After a decade of uninterrupted development, the ecosystem has finally achieved the 1.0
milestone. This post shows the evolution of the ecosystem, from its initial conception to
its current state, highlighting some notable use cases that this package has enabled.

## The Beginning

The reason why I started to develop the SatelliteToolbox.jl is both common in the Julia
community and somewhat unique in the space engineering. Back in 2009 to 2012, I was pursuing
a PhD at the Aeronautics Institute of Technology (ITA) in São José dos Campos, São Paulo,
Brazil. My research focused on distributed estimation in a fleet of unmanned aerial vehicles
(UAVs) with communication delays. To test and analyze my algorithms, I needed a simulator.

Creating a simulation of an inertial navigation system (INS) is no easy feat. You have to
model the vehicle’s movement in a spinning, spherical Earth and integrate the navigation
equations to obtain the solution using the simulated sensor data. We also have to add in the
data communication behavior and, of course, the filters to estimate each vehicle’s state
vector. To handle this task, I decided to use a well-known programming software for
engineering. When I finished programming the algorithm, I found out that simulating the
system with a certain number of UAVs, given our computing power (which was pretty good for
the time!), would take around six months (ouch!). The problem was the curse of
dimensionality - each node (UAV) in this problem has 18 states. And we needed a lot of
realizations to test the algorithm’s performance in this stochastic system.

Since I didn’t have this much time to finish my PhD., I had to make a tough decision:
rewrite as much as I could in C, which led to the (in)famous two-language problem. This
approach cut down my execution time to about a week and helped me wrap up my studies.

In the winter of 2013 (in the southern hemisphere!), I started working a junior space
systems engineer at the Brazilian National Institute for Space Research (INPE). My first
task? To dive deep into the Amazonia-1 mission and become an expert in analyzing space
missions and developing attitude and orbit control subsystems (AOCS)[^1]. Around the same
time, I stumbled upon this new language called Julia, which was supposedly the solution to
the same problem I had been grappling with during my PhD.

I do believe you learn more when you implement what you’re learning. So, in my free time, I
decided to learn Julia and implement all the algorithms I needed to understand those topics
for my work. Of course, since the ecosystem was young, there were basically no packages
related to space engineering. So, I started coding the
[ReferenceFrameRotations.jl](https://github.com/JuliaSpace/ReferenceFrameRotations.jl)
(which was called Rotations.jl back then, but I didn’t register it and I lost the name 😄)
and the [SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl).

## Development Strategy

The development strategy of
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) was to not have a
development strategy at all 😅. I had no idea where this would take me, I just wanted to
learn all the cool stuff about space engineering. The fact that I needed to use the nightly
build of Julia and things were breaking every month (or week!) was not helping either. I
also was not expecting any external help since Julia was almost prohibited in Engineering
fields by that time.

Despite the challenges, I remained steadfast in my belief in Julia’s promises and diligently
applied the knowledge I gained from various sources. The API of
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) was constantly
evolving (breaking), often in unexpected ways, to meet the evolving needs of my work at
INPE.

The turning point came when Julia 0.7/1.0 was released, resulting in a super stable system.
At that time, we already had some really cool algorithms in place, and I was also starting
to use Julia at INPE to analyze data for Amazonia-1 development. By the way, I heard a lot
of criticism back then for using a non-traditional technology in a field that was still
mostly dominated by .f90 files. But guess what? That history turned out to be a happy
ending!

After a year of hard work,
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) finally became a
really useful tool for my work. So, in 2018, I decided to officially register it in
METADATA.jl (who remembers that?). That way, it became an “official” package of the Julia
ecosystem.

## The Amazonia-1 AOCS Simulator and the Julia Advantage

Up to the moment the package was registered,
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) was just yet
another package to perform space mission analysis. We already had good alternatives in many
other languages. However, we were about to experience the turning point, when using Julia
really paid off and everyone stopped complaining about this new technology.

The AOCS development needs a super accurate simulator for many tasks. The toughest one is
tuning control gains and parameters. We need to test how the system works after we set the
values. This simulation needs a good model for space dynamics, which
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) already had, and a
fast differential equation solver.

When I began working on the simulator, I had already experimented with
[DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl). I even opened
a few issues requesting features, and Chris Rackauckas was incredibly helpful! So, I was
confident that using
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) and
DifferentialEquations.jl was the best approach.

The callback mechanism in
[DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl) was a
game-changer for me. It enabled me to precisely capture the continuous (dynamics) and
discrete (embedded software) duality that exists in the satellite AOCS. After a lot of
research and tweaking, we built the full simulator, which includes over 40,000 lines of code
when you consider the
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) ecosystem.

This was a major turning point for Julia’s adoption at INPE. The system became so efficient
that we could simulate billions of seconds to check for all possible errors and design
fail-safes to save the mission if something unexpected happens. I really believe that no
other language or ecosystem could have given me such performance and simulation quality with
the time and resources I had.

The closure of this history occurred during the launch of Amazonia-1. After the separation,
I used the satellite state vector as input to the simulator. My goal was to predict the
satellite states during its first few orbits so I could design some tasks related to the
AOCS (like sensor calibration). The results were super accurate! This allowed us to perform
those tasks way faster and with much more confidence.

The following figure shows the predicted satellite angular momentum compared to the actual
angular momentum during some orbits. It’s amazing how well the simulator matched reality!
This result is only possible if the algorithms in
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) are super accurate!

![](/assets/blog/2024-SatelliteToolbox/aocs_simulator_result-reduced.png)

## The Current State of the SatelliteToolbox.jl Ecosystem

In 2023, I finally closed [the very first
issue](https://github.com/JuliaSpace/SatelliteToolbox.jl/issues/1) opened in the
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) repository. I split
that massive package into several smaller ones. This had two main effects. The system is now
much more organized, but the maintenance burden is much higher. However, after so many years
and with all the great tools we have for testing and registering packages, it was worth it.

We’ve made all the internal packages and analysis algorithms at INPE work with the new
versions. We use the
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) ecosystem every day
for tasks like:

1. Evaluating the performance of the Amazonia-1 AOCS.
2. Examining the test results we gathered during the development of our next satellite,
   Amazonia-1B.
3. Designing orbits for various studies, including those conducted at the Integrated Design
   Center for Space Missions (CPRIME) of INPE.

Up until now, the [SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl)
has been actively used in five different space missions at INPE, and over eleven preliminary
(Pre-Phase A) studies. I also got some great feedback at JuliaCon 2024. It was awesome to
see that big players in the space industry, both public and private, are using
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) in some really cool
ways.

After reviewing the opened issues, we haven’t had many complaints about the API or the
algorithms in the past five years. And all the studies we’ve done with this ecosystem
haven’t found any major problems with the algorithms. So, I decided to start upgrading all
the packages to version 1.0 at the beginning of 2025. That way, we can officially declare
the API stable.

[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) v1.0 provides the
following features to the Julia ecosystem:

1. Convert between Keplerian elements and orbit state vectors.
2. Convert between different types of anomalies when describing an orbit using Keplerian
   elements.
3. Obtain several space indices automatically from online sources.
4. Compute the atmospheric density using multiple models (exponential, Jacchia-Roberts 1971,
   Jacchia-Bowman 2008, and NRLMSISE-00). The required indices in each model can be
   automatically fetched.
5. Obtain the position vectors of the Sun and Moon, allowing us to perform several space
   mission analysis tasks. For example, we need this information to check if our star
   trackers will be blocked by those celestial bodies during the mission’s operational
   lifetime.
6. Compute the geomagnetic field using the IGRF model.
7. Obtain the gravity field derivative, gravitational acceleration, and the gravity
   acceleration using models obtained from [ICGEM](https://icgem.gfz-potsdam.de/home) files.
   This information is crucial to develop numerical orbit propagators.
8. Read, parse, and generate two-line elements (TLE).
9. Fetch TLEs of any catalogued satellite from online sources.
10. Propagate satellite orbits using several types of analytical algorithms (J2, J2
    osculating, J4, J4 osculating, SGP4/SDP4, and two-body).
11. Fit mean elements for any supported algorithms given a set of state vectors.
12. Perform transformations between any reference system defined by the conventions
    IAU-76/FK5 and IAU-2006/2010A.
13. Perform transformations between geocentric and geodetic coordinates.
14. Transform vectors from an Earth-Centered, Earth-Fixed reference frame to local reference
    frames.
15. Fetch and parse the Earth Orientation Parameters (EOP) from online sources, which can be
    used to improve the accuracy of the coordinate transformations.
16. Convert time between the required time epochs (UTC, UT1, TT).

All those algorithms are written entirely in Julia and don’t need any external libraries.
Hence, they run super fast! All the functions are also well-documented.

Wow, what a journey it’s been! I want to give a big shoutout to everyone in the Julia
community and contributors who helped make
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) what it is today.
This tool has become a game-changer for our workflow at INPE, and it’s made Julia and its
ecosystem a part of the Brazilian Space Program 🇧🇷!

## The Future

With our solid base and extensive testing, I will be implementing a range of analysis
algorithms in the [SatelliteAnalysis.jl](https://github.com/JuliaSpace/SatelliteAnalysis.jl)
package. This will empower Julia users to perform various space mission tasks effortlessly.
For instance, we already have a function that lists all the access windows between a
satellite and a ground station. This crucial information is vital for mission design for
example.

I’m curious about integrating
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl) with tools like
[Flux.jl](https://github.com/FluxML/Flux.jl). This could help us develop neural networks
that reduce the computational burden of some algorithms. I want to thank [Jordan
Murphy](https://github.com/jmurphy6895) for the amazing work he is doing on adding automatic
differentiation support for many functions in the
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl).

I will be also targeting the development of a very accurate, numerical orbit propagator.

Finally, I really hope to bring more contributors to the
[SatelliteToolbox.jl](https://github.com/JuliaSpace/SatelliteToolbox.jl)! We have the
opportunity here to make Julia an important technology in the space community.

---

[^1]: The attitude and orbit control subsystem is responsible for maintaining the satellite’s attitude, or “pointing,” ensuring that the payload (in our case, a camera) faces the Earth steadily to obtain a good image. Additionally, this subsystem is tasked with maintaining the operational orbit within the designated limits.
