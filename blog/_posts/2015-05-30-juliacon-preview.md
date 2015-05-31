---
layout: post
title:  JuliaCon 2015 Preview - Deep Learning, 3D Printing, Parallel Computing, and so much more
author: The JuliaCon Committee
---

*[JuliaCon 2015](http://juliacon.org) is being held at the Massachusetts Institute of Technology from June 24th to the 28th. [Get your tickets](http://www.eventbrite.com/e/juliacon-2015-tickets-16517619645) and [book your hotel](http://juliacon.org/#accom) before June 4th to take advantage of early bird pricing.*

---

The [first ever JuliaCon](http://juliacon.org/2014/) was held in Chicago last year and was a great success. JuliaCon is back for 2015, this time in Cambridge, Massachusetts at [MIT](http://web.mit.edu/)'s architecturally-delightful Stata Center, the [home of computer science at MIT](https://www.csail.mit.edu/). Last year we had a single-track format, but this year we've expanded into a four-day extravaganza:

* On Wednesday 24th there will an introduction to Julia workshop run by [David P. Sanders (@dpsanders)](https://github.com/dpsanders) as well as a Julia **hackathon** - a great chance to get some help for your new Julia projects, or to begin contributing to Julia or its many packages.
* On Thursday 25th and Friday 26th we will be having speakers talking about a range of topics - we were fortunate to have so many fantastic submissions that we had to open up a second track of talks. The near-final [schedule is on the main page](http://juliacon.org). We'll be alternating between ~40 minute long "regular" talks, and ~10 minute long "lightning" talks across all the sessions.
* On Saturday 27th we will finish with a series of **workshops** on a range of topics: data wrangling and visualization, [optimization](http://juliaopt.org), high-performance computing and more. These workshops run from 1.5 to 3 hours and will be a great way to rapidly boost your Julia skills.

### Thursday's Talks

<img src="https://avatars3.githubusercontent.com/u/6486271" width="20%"><img src="http://juliaastro.github.io/images/logo.svg" width="20%"><img src="https://www.juliabox.org/assets/img/juliacloudlogo.png" width="20%">

After getting everyone settled in, we'll start the conference proper with a session about the use of Julia in a wide variety of **scientific applications**. Many of the talks at the conference focus on Julia package organizations: groupings of similar packages that promote interoperability and focussing of efforts. In the session [Daniel C. Jones (@dcjones)](https://github.com/dcjones), the creator of the visualization package [Gadfly](http://gadflyjl.org), will discuss the advances being made in the [BioJulia](https://github.com/BioJulia) **bioinformatics** organization, and [Kyle Barbary (@kbarbary)](https://github.com/kbarbary) will present [JuliaAstro](http://juliaastro.github.io/), a home for **astronomy and astrophysics** packages. Theres something for everyone: quantitative **economic modeling** ([QuantEcon.jl](http://quantecon.org/)), **quantum statistical simulations**, and how to fit Julia into a pre-existing body of code in other languages.

After lunch we'll be splitting into two tracks: **visualization and interactivity** and **statistics**. The **visualization** track will be demonstrating some of the exciting advances being made that enable Julia to both produce high-quality visualizations, but also share them. [Mike Innes (@one-more-minute)](https://github.com/one-more-minute), creator of the **[Juno](http://junolab.org/) IDE for Julia**, will be sharing his working on building **web-powered apps** in Julia, while [Viral B. Shah (@ViralBShah)](https://github.com/ViralBShah), one of the Julia founders, will be discussing more about the inner workings of and plans for **[JuliaBox](http://juliabox.org)**. For a different take on "visualization", [Jack Minardi of Voxel8](https://github.com/jminardi) will be sharing how Julia is powering their **3D printing work**.

The **statistics** session covers some hot topics in the field, including two talks from researchers at MIT about how Julia is playing a big part: **probabilistic programming** ([Sigma.jl](https://github.com/zenna/Sigma.jl)) and **deep learning** ([Mocha.jl](https://github.com/pluskid/Mocha.jl)). Facebooker John Myles White, author of ["Machine Learning for Hackers"](http://shop.oreilly.com/product/0636920018483.do) and a variety of packages in R and Julia, will share his thoughts on how statistics in Julia can be taken to the next stage in development, and [Pontus Stenetop (@ninjin)](https://github.com/ninjin) will educate and entertain in his talk "Suitably Naming a Child with Multiple Nationalities using Julia".

We'll come together at the end of Thursday to learn more about how to write [good](https://github.com/tonyhffong/Lint.jl) Julia code, how to write packages that Just Work on Windows, and how wrappers around C libraries can be made easier than you might think through the magic of [Clang.jl](https://github.com/ihnorton/Clang.jl). [Iain Dunning (@IainNZ)](http://github.com/IainNZ), maintainer of [Julia's package listing and test infrastructure](http://pkg.julialang.org) will follow up on last years talk by giving a brief history and updated status report on Julia's package ecosystem. Finally current Googler [Lean Hanson (@astrieanna)](https://github.com/astrieanna) will share some of her tips for people looking to get started with contributing to Julia and to open-source projects.

Whatever you get up to after the talks end on Thursday, make sure you are up in time for...

### Friday's talks

<img src="http://www.juliaopt.org/images/juliaopt.svg" width="20%"><img src="https://camo.githubusercontent.com/12d691a97c0fb8364be856247ceb90c9204c2e01/687474703a2f2f6c6962656c656d656e74616c2e6f72672f5f7374617469632f656c656d656e74616c2e706e67" width="20%">

If you are interested in learning **how Julia works** from the people who work on it every day, then Friday morning's session is for you. The morning will kick off with newly-minted-PhD and Julia co-founder [Jeff Bezanson (@JeffBezanson)](https://github.com/JeffBezanson), who is still recovering from his defense and will be updating us on the title of his talk soon. We'll be learning more about different stages of the **compilation process** from contributors [Jake Bolewski (@jakebolewski)](https://github.com/jakebolewski) and [Jacob Quinn (@quinnj)](https://github.com/quinnj), and we'll be covering a miscellany of other cutting-edge topics for Julia like tuning LLVM, debugging, and interfaces.

In the afternoon we'll have four sessions split across two rooms. In the second **scientific applications** session we'll be learning more about how Julia is being used to **prevent airborne collisions** from Lincoln Lab's Robert Moss, and [Iain Dunning (@IainNZ)](http://github.com/IainNZ) will give a sequel to last years [JuliaOpt](http://juliaopt.org) talk to update us on how Julia is becoming the language of choice for many for **optimization**. We'll also hear how Julia is enabling rapid development of advanced algorithms for simulating **quantum systems**, evolving graphs, and analyzing **seismic waves**.

The **numerical computing** track kicks of with Stanford's Prof. [Jack Poulson (@poulson)](https://github.com/poulson), creator of the [Elemental](https://github.com/elemental/Elemental) library for **distributed-memory linear algebra**. Right after, the linear algebra wizard [Zhang Xianyi (@xianyi)](https://github.com/xianyi) will give a talk about [OpenBLAS](https://github.com/xianyi/OpenBLAS), the high-performance linear algebra library Julia ships with. After a break, we'll hear Viral's thoughts on how **sparse matrices** currently and should work in Julia, before finishing off with lightning talks about **validated numerics** and **Taylor series**.

We'll see out the day with two sessions that hit some topics of interest to people deploying Julia into larger systems: **data** and **parallel computing**. In the data session we'll learn how about the nuts and bolts of **sharing and storing data** in Julia and hear more about plans for the future by the contributors working in these areas. Make sure to check out the talk by [Avik Sengupta (@aviks)](https://github.com/aviks) about his real-world industry experiences about putting Julia code behind a **web-accessible API**.

The parallel computing session will tackle parallelism at all levels. Contributor [Amit Murthy (@amitmurthy)](https://github.com/amitmurthy/) will open the session with a discussion of his recent work and plans for managing Julia in a cluster. We'll also hear about work being done to **make Julia multithreaded** at Intel, and about running Julia on a **Cray supercomputer**. 

After all that you will surely be inspired to hack on Julia projects all night, but make sure to wake up for a full day of **workshops** on Saturday!

Remember to [get your tickets](http://www.eventbrite.com/e/juliacon-2015-tickets-16517619645) and [book your hotel](http://juliacon.org/#accom) before June 4th to take advantage of early bird pricing. We'd also like to thank our **platinum sponsors**: the Gordon and Betty Moore Foundation, BlackRock, and Julia Computing. We can't forget out **silver sponsors** either: Intel and Invenia. We're looking forward to seeing you there!
