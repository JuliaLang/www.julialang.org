@def rss_pubdate = Date(2022, 2, 14)
@def rss = """10 years ago today, we published 'Why we Created Julia' ..."""
@def published = "14 February 2022"
@def title = "Why We Use Julia, 10 Years Later"
@def authors = """The Julia Community"""
@def mintoclevel=2
@def maxtoclevel=3

+++
meta = [ ("property", "og:image", "https://user-images.githubusercontent.com/35577566/153917389-f9e3cbbf-8c14-47f7-a8ae-a3dcbd60f4a8.png"), ("name", "twitter:creator", "@JuliaLanguage"), ("name", "twitter:card", "summary_large_image") ]
+++

~~~
<img src="https://user-images.githubusercontent.com/35577566/153917389-f9e3cbbf-8c14-47f7-a8ae-a3dcbd60f4a8.png" width="80%" alt="Why We Use Julia, 10 Years Later">
~~~


Exactly ten years ago today, we published "[Why We Created Julia](https://julialang.org/blog/2012/02/why-we-created-julia/)", introducing the Julia project to the world.
At this point, we have moved well past the ambitious goals set out in the original blog post.
Julia is now used by hundreds of thousands of people.
It is taught at hundreds of universities and entire companies are being formed that build their software stacks on Julia.
From personalized medicine to climate modeling, novel materials and even space mission planning — everywhere you look, the Julia community is pushing the boundaries of human discovery.
Some lines of code in a git repository give an open source project its form, but a community gives it life.
We continue to be impressed every day by the breadth of knowledge and kindness of spirit of the people who have gravitated to Julia.
Below, we collate the stories of some of the members of the Julia community (both old and new) in a shared reflection on the past 10 years.

\toc

## Keno Fischer [(@keno)](https://github.com/keno)

Ten years ago, when "Why we created Julia" was published, I was just finishing my senior year of high school as an exchange student at a tiny school on the Eastern Shore of Maryland. With some painful memories of attempting school projects and online courses in Octave, college acceptance in hand and not much else to do, I resonated strongly with the need for better tools in computational science and started working on Julia that very day. 10 years, there has been hardly a day in the past decade that I did not work on Julia. In this time I've worked on everything from astronomy, over homomorphic encryption, to simulating semiconductors and much in between. There have been many memorable events along the way. For example, 5 years ago, in a first for a dynamic language, we pushed Julia over the Petaflop barrier (a feat that is much easier now ;) ) running more than a million simultaneous threads of Julia on one of the worlds' largest computers. Every year, I look forward to JuliaCon to get together with the friends I've made along the way and admire how far we've come from the tiny group of people hacking away in a conference room at MIT. It's been a wild 10 years, and things are only getting more exciting.

## Avik Sengupta [(@aviks)](https://github.com/aviks)

My first reaction on seeing the headline on Hacker News that day was a decidedly lukewarm "oh, do we really need yet another programming language". Reading the blog post however piqued my interest -- "it surely can't deliver on all that it promises, can it?". It was a slow day at work, so I downloaded the source, and was surprised to see that it built successfully on the first try. My [first PR](https://github.com/JuliaLang/julia/pull/471) came two weeks later. In adding a new numerical type, it proved to me that easy and performant numerical computing was certainly possible. In the years since, I've been privileged to be part of this amazing community, as well as being able to write Julia everyday at work. Julia has without doubt changed my life, and I reckon it's already changed the world in a small way.

## Chris Rackauckas [(@chrisrackauckas)](https://github.com/chrisrackauckas)

I came rather late to the scene, around 2016. I had written GUIs in R, libraries in Python and MATLAB, handled MEX files and wrote my MPI using C. I wrote some ODE solvers using Fortran like a good ol' kid. I did my due diligence. It was an absolute mess, especially being a Windows user, and so when I found Julia I was astonished to find something that would actually work. No more SciPy installation error from some compiler missing on Windows: Julia was the compiler. And more and more, Julia is the compiler. It was wild when everything was new. In those early days of v0.5-beta I remember creating the Plots.jl and the Juno IDE documentation as trades for getting bug fixes. And from all of that experience in the "wild west", my experience with language and computation had changed. Before, I was thinking language was fixed and it's the differential equation solvers ([DifferentialEquations.jl](https://diffeq.sciml.ai/stable/)) that were "my" work, but with Julia everything opened up. Is the implementation of generating random Poisson numbers fast enough, or for this use case is there something faster that hits the statistical tolerance that I needed? Well that code is in Julia, so let's take a look. Having everything in one language soon meant the world expanded to thinking about how every floating point operation could be optimized for the application at hand. Everything that was taken for granted was now in the hands of the domain. That was how differential equation solving expanded into scientific machine learning and the [SciML Open Source Software Organization](https://sciml.ai/)). Now we [have SciML benchmarks](https://github.com/SciML/SciMLBenchmarks.jl) along the whole stack, top to bottom, incorporating everything from [physics-informed neural network solvers of partial differential equations](https://neuralpde.sciml.ai/dev/) to recursive array data structures. There are so many places in math that are simply untouched because they sound like the domain of a compilers instead of "computational science", and I'm excited to see how the next 10 years bridges this gap in Julia.

## Elliot Saba [(@staticfloat)](https://github.com/staticfloat)

I originally read about the release of Julia v0.1 on slashdot, and immediately attempted to get it to build on my MacBook.  I was a fresh graduate student and scarred by working in MATLAB.  While I had discovered numpy and was making good use of it in my research and coursework, my soul longed for something better.  When running `make` resulted in a linker error, I googled around a bit and made a [two-character pull request](https://github.com/JuliaLang/julia/pull/717) to fix it.  Little did I know that the next ten years would take me on a journey through learning about compilers, writing our first "CI system" as a for loop in `bash`, building a [global content delivery network](https://pkg.julialang.org/), rebuilding a [neural network toolkit](https://github.com/FluxML/NNlib.jl/pull/94), designing a [cross-compiler build environment](https://binarybuilder.org/) to satisfy all of our non-Julia needs, and much, much more.  While I was originally attracted to the Julia world due to the technology, the welcoming nature of the community, and the lack of ego made me feel right at home.  As we like to say, "Come for the speed, stay for the community".  It's been a long journey with many good friends, and I can't wait for the next in-person JuliaCon to see the scores of fellow nerdlings that will undoubtedly blow my mind with all the creative, ingenious ways they have been working to make the world a better place.

## Valentin Churavy [(@vchuravy)](https://github.com/vchuravy)

I first started using Julia in 2014, I remember spending the winter of 2013 writing a multi-agent robotic simulator in Scala for neuro-evolutionary experiments. I think I had seen the "Why we created Julia" blog during that time and frustrated with the experience of writing numerical codes in Scala, I decided to use my next project as an opportunity to learn Julia. My first real projects was taking a Matlab code, written by a collaborator, that was too slow and translating it 1:1 to Julia. Since it was using explicit loops, I immediatly got something like a 10x speedup, and further optimizations made it 100x faster. I was hooked. Later in this project I started experimenting with GPUs, and especially [`OpenCL.jl`](https://github.com/JuliaGPU/OpenCL.jl). The warm welcome I got from Jake B., when I submitted my first serious pull-request, drew me into the community and stayed with me as a reflection of what the Julia Community is. Over the years Julia became an ever greater part of my life, co-maintaining the [JuliaGPU](https://juliapu.org) and [JuliaHPC](https://github.com/JuliaHPC) ecosystem, contributing to Julia core, and organising [JuliaCon](https://juliacon.org) since 2017. As Elliot wrote, "Come for the speed, stay for the community" has certainly been true for me, and I have made a great many friends over the last years. Here's to another 10 years, and that Julia stays my favorite frontend to LLVM, and that there will be many [shenanigans](https://github.com/JuliaDebug/Cthulhu.jl) [left](https://github.com/EnzymeAD/Enzyme.jl) [to do](https://github.com/JuliaGPU/KernelAbstractions.jl).

## Jose Storopoli [(@storopoli)](https://github.com/storopoli)

I stumbled into Julia while trying to do a crazy data transformation in R that was taking forever. I was instantaneously hooked! The syntax is so easy, and it has also a "math" feel to it. You can use all your `ϵ` and `δ`, along with the statistician's favorites `α` and `β`.
Since then, I've become a contributor to the [`JuliaStats`](https://github.com/JuliaStats) and [`Turing`](https://github.com/TuringLang/) (Bayesian modeling) Julia's ecosystems. The community is great and very welcoming. I've made amazing friendships here, co-authored a [free open access and open source Julia Data Science book](https://juliadatascience.io) with Rik Huijzer and Lazaro Alonso. The book has been translated to Portuguese and Chinese by volunteers, that which I am grateful and humbled. Julia is taking big strides now, since its first appearance 10 years ago. I am really excited about its future and honored to be a part of it.

## Jacob Scott Zelko [(@TheCedarPrince/)](https://github.com/TheCedarPrince/)

In 2019, it was my opinion that extracting the signal from nigh infinite data was going to become imperative in the future. I grew very concerned not only about how to apply methods of high performance computing to data but also about the inequity such tooling would create - those with super computers could do cutting edge research and those without, how could they compete? I was researching a tool to invest in and came across Common Lisp, but saw it wasn't for me. Lisp seemed like my ideal tool and then I came across Julia. Not only was it designed for high performance, but also the syntax was friendly and the community was great. I made my first core contribution a few short months later. Since then, I co-created the fun animation package [Javis.jl](https://github.com/JuliaAnimators/Javis.jl) with my friend Ole Kröger, joined various Julia workgroups and use it daily. Today, we are acutely aware, delays can lead to lives lost. I use Julia in my health research to address and rapidly identify health disparities, deliver insight, and to perhaps assist in decisions to protect lives. I believe that Julia is _the_ tool to do this and I look forward to another 10 years.

## Matt Brzezinski [(@mattBrzezinski/)](https://github.com/mattBrzezinski/)

July 2019 I left my job at AWS and joined a small company Invenia as a software engineer. During my interview I first heard about the new programming language I would need to learn, Julia. Invenia had recently ported over their entire code base from Matlab to Julia, and was quickly becoming one of the foremost companies use Julia in a production environment. I spent my first week at Invenia porting various internal and external packages from Julia 0.7 to 1.0 and found it to be a simple and intuitive language to use coming from a Python background. My second week was spent in Baltimore meeting and chatting and learning with the community in Baltimore for JuliaCon 2019. I was hooked. Almost 3 years later I've found that Julia has been my go to language for nearly everything. The ease of use, speed and community keep bringing me back for more. I'm excited to see where it goes from here.

## Julian Samaroo [(@jpsamaroo)](https://github.com/jpsamaroo)

About 8 years ago, I was a student studying neuroscience in college, very interested in computational modeling. I had implemented some basic spiking neural network simulators in MATLAB, and ported them to JavaScript, but always found both languages lacking. Still, I persisted with JavaScript, until about 3 years later, when I first heard about Julia from somewhere on the interwebs. Out of boredom and a mild displeasure with JavaScript, I decided to give Julia a try. I will be honest; I had no shortage of problems using it! The errors were unintuitive, the syntax was strange, and it was *slow* (to compile, but what was the difference?). I kept using JavaScript for work, but slowly on the side I started getting more familiar with Julia, and tried using it for some of my simulations and side projects. Skipping to about 4 years ago, I got "nerd-sniped" by a certain Valentin Churavy to implement support for AMD GPUs in Julia, since I was so vocal about wanting to support a more open-source friendly GPU vendor. Over the next 2 years, I developed AMDGPUnative.jl (now AMDGPU.jl) and Dagger.jl in my free time, slowly gaining an appreciation for Julia, and attended my very first JuliaCon in 2019! Somewhat shortly afterwards, Valentin reached out from the JuliaLab and offered me an RSE position (which was an offer I could have only dreamed of at that point in life!), which I gladly accepted. Since then, I've been working full-time on AMDGPU.jl, Dagger.jl, BPFnative.jl, and Julia itself, and have been loving every moment of it. I don't think I could ever give up the wonderful ecosystem, language, and people that I've come to know and love over the last 5 years, and I look forward to many more wonderful years to come.

## Rik Huijzer [(@rikhuijzer)](https://github.com/rikhuijzer)

During my master thesis, I did some machine learning in Python but kept getting annoyed by object-oriented code bases. They seemed more complicated than was absolutely necessary, especially around testing, and I felt that classes where the cause for it. So, as a proper hacker, I tried to write all my Python code without classes to great discomfort of people who read it. A few months later, very naively, I tried the same thing at a C# job to even greater discomfort of the people who read it. Luckily, all my problems were solved when I read about the Julia language on some blog post. Julia doesn't have classes. Also, the language looked really well thought out, so I set out on a mission to not touch another language since that day somewhere in 2019. It has been a very interesting ride so far. I'm constantly amazed by how much can be learned from reading Julia code and discussions and getting feedback on pull requests. This is due to the solid foundation that the language provides and the great community that is building things with Julia. Thanks to these things, I'm hopeful that Julia will be the primary tool for research in industry and academia in 10 years.
I think we can do it in 9.

## Eric Davies [(@iamed2)](https://github.com/iamed2)

2011 was my first year at Invenia, where we were maintaining a fairly elaborate production system written in MATLAB 2007b. Python had begun to replace Perl in our helper scripts and web services, and several of us were keen to move to a language with a healthy community that made modern software development possible. My first experiments were disheartening, though; how could I expect a researcher to be happy moving from `A'*A` to `np.matmul(A.conj().T, A)`?

In 2012 a coworker shared the Julia blog post with me. To my surprise, the first examples of Julia I encountered were concise, readable, highly performant, and even valid MATLAB code! This language was new and unstable but clearly aimed to fit our needs exactly, without expensive and closed-source license terms or buggy Neural Network Toolboxes. I became active on the mailing lists, watching for new developments and continuously evaluating its feature set against our needs. In 2014 Invenia sent two of us to the first JuliaCon and we have been present every year since, growing alongside each other. It was in 2014 that the first package groundwork was laid for our system to fully transition to Julia, which completed several years later.

Those first years on the mailing lists set the tone for the community to come. Core developers were happy to explain how the language worked and the detailed and thoughtful reasoning behind design decisions. Every month brought new and exciting features (Keyword arguments! A package manager! Inline arrays of immutables!). Newcomers could quickly get help, collaborate, and contribute. While the community has grown immensely since the early days (it's much more challenging to bait Jeff Bezanson into fixing your pet compiler bug), this community attitude is alive and well, distributed through the hundreds of active community contributors.

## Alejandro Merchan [(@alejandromerchan)](https://github.com/alejandromerchan)

I heard about Julia for the first time probably around 2015. I was doing some GLMM analyses in R for my PhD in Entomology and just looking for as much information I could find. I found some book on Github authored by Douglas Bates that was unpublished and I wondered why. Pulling that thread brought me to some post where Doug said that he was leaving R and moving his programming to Julia. I checked, it was probably the 0.3 version and the language was so barebones that I was scared (not a computer scientist!). At that point I had gone from R in the terminal to RStudio and I was happy with that. However, I kept going back to the project from time to time and kept looking at the code in the GLM package, very surprised that it was written in Julia all the way and I could pretty much read it, unlike what had happened in R. Later, during my postdoc, I had a new project that required a lot of data, so I used it as an excuse to finally use Julia for real. Version 0.6 was out and I started learning the basics for data analysis in Julia. Juno was also available, which makes things easier for me too. And since then, I pretty much only use Julia for data analysis. At work I still have to use R, Python and SQL, but on my laptop I try to centralize everything in Julia and I really love the language and the community. I don't have many PR's, I did publish one small package that I needed and have a lot of personal packages for my work, plus plans to work on a couple more, I'm somewhat active on Discourse and Slack and in general try to stay engage. I hope this project continues growing and maturing.

## Johnny Chen [(@johnnychen94)](https://github.com/johnnychen94)

I remember it so clearly that it was during a deep learning summer school when for the first time I heard about the word "Julia" two days after its 1.0 release. It was a lab where people don't see programming seriously and I was disappointed about MATLAB for quite a long time. The summer school was a bit boring to me so I took the entire 10 days there reading the Julialang and its ecosystem documentation. I can still rebuild the very memories that how excited I was when two months later I created a small [`repeat` patch PR](https://github.com/JuliaLang/julia/pull/29626) that receives a :+1: from Jeff Bezanson (although I immediately noticed that people do this for every new contributor :laughing:), and that how proud I was when two years later I accidentally fixed a 6-year-old performance issue in the [`CartesianIndices` step support feature PR](https://github.com/JuliaLang/julia/pull/37829) for which Tim holy sent an appreciation in the famous #appreciation slack channel. Those are all good memories I have in the julia community and I'm always thankful for growing together with Julia and for learning from the talented yet friendly people here.

## Jerry Ling [(@Moelf)](https://github.com/Moelf)

I was, like many people, moderately skeptical when I saw Julia's promise of "the best of both worlds" the first time; in fact, I remember walking away not particularly impressed the first time I tried Julia in 2018, largely due to latency (TTFT) issue with plotting. That soon change when I tried again near v1.0 release after hearing a PhD student (Katharine Hyatt) in UCSB physics was doing cool quantum stuff in Julia. Things moved fast after that: once you know the two-language problem, it's everywhere in physics. So many things are "free" in Julia, millions lines of C++/Python can be skipped because Julia is not slow, auto diff would have helped with numerous inverse problem in physics etc. Today, though not as proficient in compiler or typing system than many core devs in this post, I strive to bring better computing tools to physics, and I hope to witness a rapid adoption of Julia in the next decade.

## Alex Arslan [(@ararslan)](https://github.com/ararslan)

I first came across Julia at version 0.2, back in the days of the Julia Studio IDE and its bundled tutorials. At the time I was using SAS for work and didn't have much reason to use Julia for anything. However, shortly thereafter I got involved with online code golf challenges, which finally provided an excuse to use Julia for something. I quickly became known as "the guy who uses Julia" in that community, as it was otherwise exceedingly uncommon to see a solution posted in Julia. That community also introduced me to making open source contributions, something I had been completely unfamiliar with prior. After a couple of years as a casual Julia user, in 2015-2016 I finally started contributing to Julia and its packages, and got to interact with, meet, learn from, and befriend some absolutely wonderful people. In 2017 I left my job to work full time on Julia as the community manager, and since then I've continued to do releases and have been using Julia full time in one capacity or another. I even had the pleasure of getting to tag Julia v1.0.0 on stage at JuliaCon 2018 in London alongside Julia's creators, a real once-in-a-lifetime opportunity. Thank you to everyone who's made Julia what it is over these past 10 years, and a special thank you to the people instrumental in onboarding me to the community: Milan Bouchet-Valat, Andreas Noack, Tony Kelman, Stefan Karpinski, and Jiahao Chen; the people who made it possible for me to use Julia professionally for the past 5 years: Viral Shah, Curtis Vogt, and Jarrett Revels; and Jeff Bezanson for getting me hooked on Scheme.

## Cristóvão Sousa [(@cdsousa)](https://github.com/cdsousa)

Julia is the language I was longing for. And in the late summer of 2013, that "Why We Created Julia" was mind-blowing to me! I had been taught to program in C and C++ and later I learned some MATLAB too.  I always looked for performance and I'm the kind of person that prefers to waste more time optimizing code than wasting little time waiting for it to run. But on the other hand, I need to write math/scientific code and I like to do it in a high-level language. When starting the PhD in 2009, along with C++ I wanted to use an open-source higher-level language, so I opted for Python. However, the slowness was a bummer and I had to rely on workarounds like Cython. I was not happy, and I was greedy, always wondering "Why can't a better language, high-level but performant, be devised? It must be possible somehow!". While playing with PythonTEX in that summer of 2013, its documentation referred to some language by the name of "Julia". My first reaction was exactly "Oh no! Yet another high-level language like Python, Ruby, etc. Why... why?". Then I read its manifesto, and "WOW! YAY!". It ticked all the boxes, even the one-based indexing was a cherry on top! Eight years have gone by, I'm a very happy Julia user and I'm always excited and looking forward to all the new cool stuff coming from the excellent community.

## Jakob Nissen [(@jakobnissen)](https://github.com/jakobnissen)

Back in 2017, I needed to properly implement code for my PhD project. My naive "Python for everything" ideology bumped into hard reality, as I realized my implementation of a core component was 100 times slower than acceptable. I tried Numba, Cython and diving into deep Numpy lore, but no solution was satisfactory. With great resentment, I realized that for performance sensitive computing, there can be no such thing as a Python programmer: I could wrap my code in a Python cloak, but I would have to write all the hard stuff in C. A friend who had picked up Julia for theoretical physics taught me that my frustration was common in scientific computing, and had a name: "The two language problem". Even better, it had a solution: Julia.

Like most people, I was initially skeptical of the promises of Julia, and resisted getting dragged out of my Python comfort zone. But while I found Julia alien and had all kinds of superficial grievances, I was also curious and kept playing with it. After a few months, the relative elegance of performance of my Julia code was undeniable. As many others have experienced, learning Julia is somehow a slippery slope, and before I knew it, I learned about CI, good testing practice, and low-level computing. In 2020, I switched my work code to Julia, and have never looked back since.

## Gabriel Baraldi [(@gbaraldi)](https://github.com/gbaraldi)

I first saw julia in a blog post about S4TF and differential programming. The concept attracted my attention but went over my head completely and it being swift meant I wasn't very keen on trying it out. The post did mention a language called julia, and said that it looked like python and ran like C, and that attracted me. Like lots of people here I wrote prototype code in python and either had to struggle with making it performant or rewrite it in C++.

I had kept it on the backburner for a little while but when I saw Grant from 3b1b mention it I decided it was time to give it an actual go in a project, and doing that project I fell in love with the language, and with the language came the community and now I keep getting nerd sniped from every side thanks to the interesting things people do with julia. I now use it everyday and hope to help lots of people use it too :).

## Logan Kilpatrick [(@logankilpatrick)](https://github.com/logankilpatrick)
Back in 2018, I was lucky enough to join a team at NASA that was using Julia. I had the chance to work through the 0.6 to 1.0 transition. This led to me getting involved in open source and ultimately helping out on getting the community momentum behind Stack Overflow. After that, I was lucky enough to help lead Google Code-in for the Julia community in 2019 where we mentored 212 high school students.

What has kept me involved in the Julia community for all these years is the opportunity to give back. There are so many amazing opportunities to do work that has a real impact and it keeps me motivated to continue helping!

## Shashi Gowda [(@shashi)](https://github.com/shashi)

In 2014 I spent a 5 hour bus ride going through the language documentation on my phone. It was a joy to read, and I might have said "hell yes" many times. Later, I ported a MATLAB project to Julia. It dealt with thousands of EEG datasets. The code was a fraction of the size, self-organizing, fast, and I could parallelize it trivially! The project had to do a lot of string manipulation to load the right files. That was actually fun and similar to what I knew from Perl and Python (MATLAB's string manipulation was as low level as that of C, and also inconsistent). I was very excited to be able to write higher-order functions that made changing the analyses a cinch. I did not know I had a two-language problem, and Julia had just solved it. I felt excited about my project for the first time. I knew that if the goals of "Why we created Julia" are realized, Julia is going to be a force to reckon with in the future.

I did not know that a large part of my career was to be intertwined with this beautiful piece of software, and the equally enthralling community that was building around it. In the summer of 2014, I got to work with Julia in the GSoC program. I wrote Interact.jl -- it became very popular in the community in the following years. For the next 4 years I got to work on Julia full-time, I wrote Escher.jl, Dagger.jl, and co-developed JuliaDB at CSAIL and Julia Computing. In 2018 I joined the Julia Lab as a PhD student. I am currently working on Symbolics.jl -- the basic building block many simulation packages in Julia currently use. Everyday I'm grateful to have the opportunity to contribute my code to the daily lives of so many amazing scientists, engineers, and teachers.

At the end of my PhD I would have spent 9 years of  my early career dedicated to the language--an opportunity only a few young engineers could dream of! I can safely say that, through Julia, I have gained some mastery over many skills--performance tuning, compilers, distributed computing, linear algebra, and pedagogy. Most of all, I have also learnt humility, craftsmanship, and care that are essential in successful engineering projects, especially in the open source world.

## Mark Kittisopikul [(@mkitti)](https://github.com/mkitti)

I heard about Julia in 2012 as I was finishing graduate school research in San Diego. I read the “Why We Created Julia” post then, and thought this is exactly what I want. I was too busy to get involved then, but I kept tabs on it as it developed.

By early 2020, I saw the 1.0 release a couple years back and decided to start learning Julia, and I was immediately impressed. By March 2020, I submitted my [first pull request](https://github.com/JuliaLang/julia/pull/35048) to `JuliaLang/Julia` and soon discovered that Julia was a language that I could not only use but also help develop. As I started a new job, I needed a tool to help me quickly explore C APIs. I found Julia did that, but also outperformed other tools I was using in many tasks in terms of both development time and execution time. I could use [SIMD](https://github.com/eschnett/SIMD.jl), [call any C function I wanted](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/), and [solve complicated mathematical problems](https://sciml.ai/). Julia is the perfect language for scientific computing and beyond.

Along the way, I also engaged in the Julia community, which was very helpful and approachable. It is not uncommon to speak directly with one of the founders who signed the original “Why We Created Julia” post. I look forward to using Julia as it rapidly grows and to helping to achieve the original vision put forth ten years ago.

## Qingyu Qu [(@ErikQQY)](https://github.com/ErikQQY)

By early 2020, I first knew about Julia from Roger’s post on Zhihu. With the first try of Julia, I just love the feeling of writing Julia code, similar with Python, MATLAB and Fortran, but easier and more elegant, what impressed me most is the amazing performance and friendly community!

Being inspired by [SciML](https://sciml.ai/), I decided to use Julia help with numerical methods in fractional order area. And here we are, we initiated [SciFracX project](https://github.com/SciFracX), aiming at making fractional order computing and modeling easier with Julia. And it turns out we chose the right path. The performance is awesome and amazing! Some packages gradually become the most useful packages in fractional order scientific computing.

It’s very nice to see Julia community is growing bigger, what will happen in next decade? Let us witness together;)

## Kirill Zubov [(@KirillZubov)](https://github.com/KirillZubov)

The first time, I heard about Julia language, was in 2016, I was then studying for a master's degree at the department of Computational physics. One of my  professors by numerical methods said in a lecture something like “Julia is a new and interesting programming language, pay attention to it.” I said to myself - well, ok, I will know, but did not pay much attention. And already a couple of years later, in 2019, I learned about a new direction in computational science - solving differential equations using deep learning methods. I've thought it had great prospects and I would be very interested in doing it. I firmly decided to move in this direction. It so happened that this is what the [SciML](https://sciml.ai/) was actively doing. Well, then it started, first I participated in the Julia Season Of Contribution, then I was a mentor at Google Code-in and then participated in Google Summer of Code, where we started implementing [Physics-informed neural networks(PINNs)](https://nextjournal.com/kirill_zubov/physics-informed-neural-networks-pinns-solver-on-julia-gsoc-2020-final-report) at [NeuralPDE.jl](https://neuralpde.sciml.ai/stable/).
At first, I just liked the Julia language - syntax, simplicity, convenience, understandability, and sure, a great people and community, and after some time of use, learning, and immersion in details. I began to be more sure that Julia is the best way for all fresh directions of computational science, where need to work with complex mathematical models in a symbolic and numeric way and combine it together with experimental data and new deep-learning methods, and high-speed calculations, so it is one of reason why I guess that JuliaLang is the future of numerical computing.

## Michael F. Herbst [(@mfherbst)](https://github.com/mfherbst)

Similar to many others, I did not really take Julia seriously when I first heard about it in 2016. It just sounded too good to be true: A language that is both flexible and fast. However, having received enthusiastic comments from a number of different people independently, I was curious enough to give it a try in 2018. This turned out to be a revelation and the start into my ongoing Julia journey.

At my next scientific position, I was fortunately able to work with Julia full-time and develop what has now become the [density-functional toolkit (DFTK)](https://dftk.org). Our goal with DFTK was to produce a code base, which fosters collaboration between simulation scientists, mathematicians and computer scientists in the context of electronic-structure simulations. For this Julia turned out to be the right choice as it "magically" offers the flexibility and readability needed to develop novel models or algorithms as well as the low-level access to tweak performance. In this way Julia has become a vital ingredient not only to my research in this field. I am grateful for everyone who is part of this incredibly supportive and welcoming community and for everyone who has and will contribute to make Julia even better. I'm certainly looking forward to the next 10 years to come :).

## Paul Barrett [(@barrettp)](https://github.com/barrettp)

I heard about Julia in about 2016, but did not have the opportunity to seriously use it until late 2020 when I began developing software to analyze radio astronomy data, because I was not satisfied with the software supplied by the radio astronomy community. Because Julia has a REPL and performs JIT compilation, it is easy to define simple functions or models interactively. There is no need to create a specialized language and parser for those functions because they are implemented in C or FORTRAN for performance reasons. Julia solves the two language problem. This brings me to the development of Numpy and Scipy 25 years ago. As an astronomer and scientific programmer at the Space Telescope Science Institute, I was one of the early developers of Numpy and matplotlib, and early advocates for its use by the astronomical community. It is now the de facto language in astronomy. However, we were aware of the two language problem at the time, but did not have the time nor the resources to implement a new language. Knowing this limitation, I was prepared to adopt Scipy's successor, if and when it arrived. Julia is that successor. Like 25 years ago, I am now advocating for Julia to become the de facto language in astonomy.

## George Gkountouras

It all started with a need to simulate audio circuits. After a survey of various frameworks for solving differential equations in 2021, I settled on DiffEq, a 'killer app' of the Julia ecosystem. Incidentally, JuliaCon was around that time. I was aware of the language since early 2019, when a Julia implementation of that infamous PyTorch paper on Neural ODEs appeared.

Languages are about more than pointers and monads. The amiable community and robust package manager impressed more than bold claims about speed and readability. Of course, the benefits are real and substantial. 2 weeks of painful manual derivations reduced to 4 lines of code. Getting multiphysics simulation for free. The ease of SPICE combined with the power of a full programming language... if the programming language were also differentiable. ;)

If brevity is the soul of wit, then Julia is catnip for the soul. Here's to the next 10 years!

## Jeff Bezanson [(@jeffbezanson)](https://github.com/jeffbezanson)

We (I am comfortable here speaking for other long-term Julia maintainers) have always seen a programming language not just as a piece of code to drop on Github but as a continuous process and a commitment. In 2012, occasionally a prospective Julia user came to us with very understandable questions about the future of the project: what if you all decide to move on to something else in a year or two? Well, I believe I knew I would still be working on it 10 years later, but I did not know how quickly those years would go by, neatly filling the decade of my 30s as it happens. If we don't start writing the 25-year retrospective soon, it will sneak right up on us --- and I'm not sure even that will be enough time to achieve all of our goals. Fortunately I am having a lot of fun working with everybody. The other day I tried to time some allocations and didn't understand the results. Turns out the compiler had gained the ability to remove them without my realizing it --- I'm quite proud of that!

## Tim Holy [(@timholy)](https://github.com/timholy)

I missed the original release of the now-famous blog post by about a month: I was "just" a scientist and not in the habit of reading programming blogs. However, in early 2012 it was becoming clear that my scientific needs were going to force me to give up on slow dynamic languages, though I had deep reluctance to abandon the efficiencies of interactive code development. A fortuitous search for "interactive command line C" introduced me, via the blog post, to an intriguing language called Julia. Little did I know that it was about to become a way of life for me. Helping make Julia better has led me to write perhaps more C code than I would care to admit (deep within Julia's internals), but the purpose and community it serves is its own reward.

What I find surprising is that the pace of progress never seems to slow. Three and a half years after the release of Julia 1.0 with consistent dedication to backwards compatibility, the Julia of today nevertheless feels like a different animal from the one we released in 2018. I can't wait to see what happens in the next 10 years!

## Kim Louisa Auth [(@kimauth)](https://github.com/kimauth)

I first heard of Julia around the time of the 1.0 release during my master’s degree. At the time I was confronted with a different programming language in almost every course. So, I didn’t take much notice, until I started my master thesis and was asked to “give Julia a try and decide if I want to keep going with it for my PhD work”. I gave it a try, quickly liked Unicode characters, the automatic-differentiation capabilities, and the package manager. Even more than any of the language features, I however appreciated the helpfulness and interest of my Julia using coworkers who patiently answered all my questions and, much more importantly, pointed me on the things of which I didn’t know that I would want to ask about (wait, I can set the number of BLAS threads and that gives my simulation a huge speed-up?! Why?). Along the way of turning from a beginner to a user to a contributor, I got used to following the Julia Slack and Discourse and got into the Julia community. Being from an engineering background, I was somewhat used to male dominated environments. When watching a JuliaCon 2018 video however, I was pretty stunned about *how* few women were sitting in the auditorium – and figured that I want to contribute to changing that. That’s how I became a member of [Julia Gender Inclusive](https://discourse.julialang.org/t/announcing-julia-gender-inclusive/63702) (which, as the name suggests, is not only about women!). I was amazed at meeting other women who shared my passion for programming, and it is great how appreciative the Julia community has been towards initiatives like this!

## Kristoffer Carlsson [(@KristofferC/)](https://github.com/KristofferC/)

Like probably many others, I found Julia while searching for a replacement to Python to help with my code not having the performance I needed. At that point, I did not have much coding experience and I had not really contributed to any open source project. After I started doing some small contributions to Julia it just escalated and now, five years later, I have worked on package managers, debuggers, sparse linear algebra, SIMD, managing releases, and all kinds of diverse projects and even managed to make contributing to Julia a part of my day job. So for me, discovering Julia had a tremendous impact on my life and what is exciting is that I feel that things are just getting started. Every Julia release has a lot of new awesome things in it and I can only imaging how Julia 10 years in the future will look.

## Alan Edelman [(Website)](https://https://math.mit.edu/~edelman/)

Ten years. Wow.  In some ways it feels like yesterday, but then when I think of all the progress that the community has brought to Julia, and the resulting high quality reputation Julia enjoys today, I am humbled by what is possible. I just reminisced by checking my [MIT graduate course 18.337](http://courses.csail.mit.edu/18.337/2011/)  in 2011 (2011!) just to remember where we were a decade ago. Thank you everyone.  No stopping Julia now.

## Viral B. Shah [(@ViralBShah)](https://github.com/ViralBShah)

While we published this blog on Valentine's day 10 years ago, we were hands on keyboard all the way back in 2009. It is amazing to see that so much of the early motivation from back then still is what drives Julia today - solving the two language problem - and that the "Why Julia" post still resonates today. I still remember the pain of writing a mix of Matlab and C++/MPI during my PhD thesis, and how hard it was to build scientific software like [Circuitscape](https://circuitscape.org) (an ecology application which over 20 years moved from Java->Matlab->Python->Julia). Julia was a direct response to how we felt the world was broken, and what we should do about it. Since those early days, we've gone from strength to strength - participating in NumFocus to cement the open source foundations, growing the Julia Lab at MIT where Julia originated into a research powerhouse, and founding Julia Computing to build a sustainable business model. What gives me the deepest satisfaction is the community that develops and uses Julia to do really cool things that matter - from climate modeling to drug design to space missions. I have built some incredible friendships over these years, and I think this cabal of Julia people is going to have an outsize impact when we look back from the future. 10 years is a long time to spend on one thing, and rather than any kind of fatigue, I still feel the same excitement as day one when we got started.

## Katharine Hyatt [(@kshyatt)](https://github.com/kshyatt)

I started using Julia around 0.4 (before Arraypocalypse, when `helpdb` was still around) while I was a graduate student. Since I was unhappy with my C++-to-Python workflow I decided to try out this new language my officemate, Jim Garrison, wouldn't stop telling me about. From there I got started making contributions. Although I missed the first two JuliaCons I was able to go to most of the subsequent ones and it's been amazing to see the community continue to grow and diversify. Julia is continuing to make inroads into the quantum information and condensed matter physics communities and I'm very optimistic for the next ten years!

## Stefan Karpinski [(@StefanKarpinski)](https://github.com/StefanKarpinski)

About that "Why We Created Julia" blog post... it was maybe the fourth attempt to write something that conveyed what Julia was all about. It's shockingly hard to do that without it coming off as either a boring list of technical features or a rant about what annoys you in other programming languages. The approach that finally worked was to focus on what we loved in other languages and wanted to emulate. And I think that viewpoint is still at the core of who we collectively are as a community. We're a bunch of people who believe that you can have your cake and eat it too. People who see the boundaries of what can currently be done and think to themselves "Nah, we can do better!" Juan Pablo Vielma may have put it best in his 2020 JuliaCon keynote when he remarked that "Julia makes you bold". Here's to all you bold ones, you who are trying to do things that seems outside of what's doable. Never stop being bold.

## Jacob Quinn [(@quinnj)](https://github.com/quinnj)

Ten years ago, I loved following the latest releases of anything in tech, while simultaneously trying to learn SQL and just enough R to do data analytics in my first real job out of college. I remember working on an R script that needed to loop through 33 million rows of data, doing a complicated lag/join/basket kind of computation that would take 18 hours to run. Literally during one of these 18 hour runs, I saw the Julia announcement post and was immediately desperate for the kind of simple performance it promised. I read the initial manual over a weekend, rewrote my script the following Monday morning, and it ran in 5 minutes. I thought for sure I had made some kind of early termination mistake, but no, it was really just that fast. From that point, I knew I needed ways to read my data directly into Julia, hence I started work on my first 2 Julia packages: ODBC.jl and CSV.jl. I had never taken a computer science class and wasn't a developer by any means, so I like to think I'm one of the first people to learn programming purely through Julia.

## Zeng Funan

In the fall of 2019, I first knew Julia when I was watching an online course from MIT which recommends Julia for assignments. Upon the first contact, I was immediately impressed by the unlimited composibility that multiple dispatch brings. Along with lisp-style meta programming, in Julia we can easily impliment interfaces that require complicated and unwieldy design patterns in other languages. Even better, as long as you permit a short time for initial compilation, Julia does these things very efficiently.

I have had very nice exprience with the community since then. It was the first time I contributed to an open-source project when I created a one-line PR that fixes r-str formatting, which received warm welcome from the maintainers in no time. I have been contributing to the Julia community regularly ever since because I feel like my attempts, maybe naive, will make a big difference to everyone.

## Mosè Giordano [(@giordano)](https://github.com/giordano)

I read the "Why We Created Julia" blogpost a few days after the original announcement, but I didn't give it much credit at the time.  About 3-4 years later, during my PhD in Astrophysics I found myself using a patchwork of multiple languages (Fortran for speed, IDL for exploratory work, and so on) and read a paper mentioning again Julia, so I finally had my "hey, this two-language problem has a point" revelation moment.  What hooked me wasn't the speed (I was using Fortran before, which was more than adequate for that purpose), but the composability of the whole ecosystem, which lets you easily leverage other people's work, and the great community of incredibly smart and knowledgeable people.

For some reasons I still don't understand, nowadays I ended up being a co-maintainer of [`BinaryBuilder.jl`](https://binarybuilder.org/) and [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil/), two pieces of the ecosystem which highlight an often forgotten feature of Julia: the ease of interaction with other languages.  However, my greatest contribution to the community is undoubtedly [`StarWarsArrays.jl`](https://github.com/giordano/StarWarsArrays.jl), which I never miss to mention in the endless discussions about the merits of 0- vs 1-based indexing of arrays.

## Matt Bauman [(@mbauman)](https://github.com/mbauman)

I first remember seriously evaluating Julia at the November 2013 Society for Neuroscience conference. I was working on my PhD and getting extraordinarily frustrated by MATLAB, and in particular, challenges with implementing custom arrays. My lab had developed an array-like object to support our data analyses, but despite over 2000 lines of code dedicated to `subsref` alone we were still struggling with bugs, inconsistencies, and performance challenges. Not only were we re-writing our analyses into C/mex for performance, but basic core functionalities too (seriously, including `dir` and `fread`). Julia—even in its rough state at v0.2—was like a breath of fresh air, and I immediately saw the promise.

Even more exciting than the software itself was the vibrant open source community that was coalescing around it. I found even the most modest contributions to be tangibly rewarding, especially in contrast to the other challenges I was facing. I soon focused my efforts on arrays (for example, making a [fast custom array possible](https://github.com/JuliaLang/julia/pull/10525#issuecomment-108617467) with just three lines of code) and later broadcasting as we pushed towards 1.0. I'm honored to be a part of this community of astounding people, and I'm so proud of what we've built together.

## Francesco Martinuzzi [(@MartinuzziFrancesco)](https://github.com/MartinuzziFrancesco)

I encountered Julia when I was looking for an alternative to Python to use for my master thesis. At the time I was mainly a Fortran user, as many physics students still are, and Python felt unbelievably slow. I stumbled into Julia almost by chance in looking for something in beetween these two languages. What most amazes me about the language is not the technical feats in itself, but it is how much Julia and its community are intertwined. Coming from a world in which code is handed down from supervisor to student, with little to no explanation or comments, this was something I valued incredibly.

I was lucky enough to start contributing to the [SciML](https://sciml.ai/) organization in the summer of 2020 as part of the [Google Summer of Code](https://summerofcode.withgoogle.com/) program working on [ReservoirComputing.jl](https://github.com/SciML/ReservoirComputing.jl). This also was the start of my personal journey into contributing to open source software, and the Julia language made that an incredibly easy transition.


## Pamela Alejandra Bustamante Faúndez

I first started using Julia while doing a research internship at GERAD research center (Montreal, Canada), in the context of my master and bachelor’s thesis on Mathematical Optimization. Some years have passed since then, I am now a PhD candidate in Engineering, I will do an internship at INRIA (France), but one thing remains constant… my love for the Julia Language. I always promote Julia among friends and colleagues in Latin America, even when it has been difficult to convince them because of the scarce resources of Julia in Spanish. I firmly believe in open access knowledge without barriers (either language barriers, accessibility, or others), and I will always advocate for that.

I am honored to have been part of the translation of one of the first books of Julia in Spanish [“Intro a Julia”](https://introajulia.org/), in order to facilitate the use of Julia in the Hispanic community.

I hope to continue being part of this awesome community for the years to come. Let’s make it 20 years!

Greeting from Concepción, Chile!


## Ranjan Anantharaman [(@ranjanan)](https://github.com/ranjanan)

I was first introduced to Julia in 2015, while I was still an undergraduate who had no idea what scientific computing was. Then, I joined a research lab that wrote very low-level scientific code in C. Once I saw the time and the effort required to write and maintain that code, I understood Julia's promise. In my opinion, if you want to write fast scalable numerical code but do not want to write C/C++/Fortran, Julia is probably your only option.

Julia wasn't the only solution people turned to for productive scientific computing. C/C++ libraries with Python interfaces were becoming popular too, but through the [Circuitscape](https://circuitscape.org) project, we showed that pure Julia code all the way down can outperform those libraries while being as easy to develop and maintain as a scripting language. Julia also brings exciting new ideas to scientific computing too! Using the Julia compiler to reason about and manipulate code lets you leverage old numerical tricks that used to have to be hardcoded, and invent new tricks such as automatic differentiation to make scientific code differentiable.

The Julia community is open, unassuming and inclusive, and works hard everyday to welcome new contributors and reduce the barrier to entry for students. It is one of Julia's biggest strengths. I personally owe my entire career so far to the relationships I have established through the community.

I am confident the language will get better and better and grow even faster. I [would not be surprised](https://www.nature.com/articles/d41586-019-02310-3), if, within the next 10 years, Julia is dubbed "the language of science".


## Sharan Yalburgi [(@sharanry)](https://github.com/sharanry)

My first interaction with Julia was in early 2019 when I was looking for alternative deep learning ecosystems as an undergrad and came across Flux. Having been scarred by unreliable pip/conda installs of Python and the mess of CUDA/cuDNN installations, I was amazed by the ease of setup and how soon I was able to get a network training. Judging the ecosystem by its 0.x status and easy to grasp syntax, I was almost certain the performance would be terrible -- but the competitive speed of training was a pleasant surprise and got me hooked.

This motivated me to participate in JSoC 2019 working with [TuringLang](https://github.com/TuringLang) and GSoC 2020 by helping build [JuliaGaussianProcesses](https://github.com/JuliaGaussianProcesses/AbstractGPs.jl/) ecosystem. The experience was so good that it convinced me to use Julia for my thesis at MIT-ProbComp and later join Julia Computing full-time to contribute to the development of the [SciML](https://github.com/SciML) ecosystem.

To this day, I am amazed by the modularity of the entire ecosystem and grateful for the existence of projects like [Requires.jl](https://github.com/JuliaPackaging/Requires.jl), [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl), [Pluto.jl](https://github.com/fonsp/Pluto.jl), [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl), to name a few, which greatly enhances the quality of my workflow and gets me excited to get to work on the daily.

## Steve Kelly [(@sjkelly)](https://github.com/sjkelly)

My first knowledge of Julia was sometime in college when I was doing my junior year Interactive Qualifying Project at WPI. My project was focused on the languages and visualization techniques for Finite Element Methods. IPython Notebooks (now Jupyter) was quite new at the time, and it was a central part of my project. Julia had quite good integration with IPython Notebooks and at the time I was a big fan of Octave. I felt at home in the early Octave-like syntax and methods, and IPython Notebooks were really nice for presentation.
Two posts by Graydon Hoare (the creator of Rust) really sold me on Julia:

- [technicalities: interactive scientific computing #1 of 2, pythonic parts](https://graydon2.dreamwidth.org/3186.html)
- [technicalities: interactive scientific computing #2 of 2, goldilocks languages](https://graydon2.dreamwidth.org/189377.html)

The summer between junior and senior year I did 3D printing research with one foot in Python and the other in Julia. When Graydon published his Part 2 in July I think that was enough to get off the fence. I later joined a spin-off company from the lab called Voxel8, where we developed a path planner written in Julia. It has been great making friends and collaborating in this community. I am excited when the future holds for Julia.

## Jeremie Desgagne-Bouchard [(@jeremiedb)](https://github.com/jeremiedb)

I first hear of Julia around 2017. I had then been mainly a R user and got increasingly exposed to Python, yet it didn’t appear like a satisfactory expansion of my toolkit. Then came Julia, which first showed its potential as a substitute for a simple Rcpp routine. Julia educative documentation was an eye-opener on computing best practices. This opened the door of Julia’s promise, a highly productive language with compiled performance. Fast-forward into an investment firm start up, Julia makes its way as a centerpiece of our predictive modeling toolkit as we expand boosted trees functionalities with a lightweight codebase and implement new gradient-based methods thanks to ChainRules. Taking advantage of its expanding package ecosystem such as Genie, Julia became pivotal to our infrastructure, from new algorithmic development to accounting system, data monitoring and client facing visualisation. Building core company components out of a newer language sure brought its insecurities, yet has been fully rewarded so far.

## Micah Halter [(@mehalter)](https://github.com/mehalter)

I was first introduced to Julia back around 2016 by a co-worker in my research lab and spent a decent amount of time playing around with the language, but wasn't using Julia for any projects or day-to-day use. Fast-forward to 2018, our lab started up a new research project to explore meta-modeling questions such as model composition and model exploration. With Julia's official `v1.0` release along with it's first class metaprogramming support and multiple dispatch, there really wasn't another language that could easily support the work we were doing without hacky, inelegant solutions. After many different meta-modeling approaches and several rewrites we were able to start [AlgebraicJulia](https://www.algebraicjulia.org/) and bring together scientific modeling with the compositional ideas of Category Theory. Every time I add a new feature to our software that leverages the metaprogramming features of Julia, I reaffirm our decision to use Julia for this project.


## Vaibhav Dixit [(@Vaibhavdixit02)](https://github.com/Vaibhavdixit02)

I came across julia while trying to find an open source project of interest to participate in GSoC'17, I ended up not applying that year but started hanging out on slack and discourse and it became a part of everyday routine for me. I can almost say that I learnt programming through julia, I am very grateful for the tremendous community we have and very excited to see all that's in store in the years to come.

## Krishna Bhogaonker [(@00krishna)](https://github.com/00krishna)

I was not an immediate convert to Julia. I first heard about the language while in grad school around 2014 through a series of blog posts. Julia looked like python and was supposed to be faster, so I thought I might use it to accelerate some geostatistical models that I was trying to compute. I don't come from a strong numerical computing background, so I was a bit intimidated, at first, by all of the unfamiliar vocabulary. Back then there were a lot of blog posts about how wonderful Julia was, but few resources on writing julia code or interacting with Python/R, so I went back to R and Python and decided to keep an eye on Julia.

A few years later I watched Chris Rackaukas give some youtube tutorials on how to solve differential equations in Julia and how to create packages in julia, and was impressed at just how easy it looked. Not only had all of the packages advanced, but there were also people who were willing to help others learn how to use the language. So I started to incorporate more julia code into my projects whenever I could. Now Julia is my first choice when starting a new project, though I still rely on Python for some deep learning work.

The best thing about julia--besides the language itself--are the julia users. I have never found a group so willing to provide informal mentoring and support to new users at all levels of ability.

## Gregory Wagner

I first encountered Julia around 2017, when I was working on a pet project to write a "general purpose" code for solving two-dimensional PDEs with psuedospectral methods. I tried writing my software --- which consists mainly of broadcasted array operations and FFTs --- in MATLAB (clunky) and python (slow!) until finally turning to Julia, which yielded a 30% speed up! Even more importantly, I discovered the support and brilliance of the Julia community, and a love for software engineering I never knew I had. A year or two later, the Climate Modeling Alliance decided to use Julia as the language for their new climate model, and I signed up right away.

## Frames Catherine White [(@oxinabox)](https://github.com/oxinabox)

I don't remember when I started using Julia. I do know it was shortly before I started my PhD; and the version of julia was 0.3.x, but soon after I switched to a source bould of 0.4. For some reason I was working through a book on implementing kalman filters.

I believe my first impressions were: Unlike Python the syntax for maths is actually nice and first class; and unlike MATLAB it is actually a usable programming language.

I do know without the Julia community it is unlikely I would have completed my PhD (and I certainly wouldn't have my current job). It is such a collegiate community in the ideal that few universities actually meet. A mixing pot of immense expertise from such a wide range of fields.

## Roger Powell [(@togo59)](https://github.com/togo59)

In 2015, I was a Senior Lecturer at Brunel University in the UK, teaching control systems theory among others. I was convined that there had to be something better around than MATLAB/Octave/Scilab. I was also determined to find something more scientifically capable than Erlang, which I was also trying to use. Then I found Julia and I have been an evangalist ever since.


## Prem Chintalapudi [(@pchintalapudi)](https://github.com/pchintalapudi)

I first learned about Julia in 2019, where as part of my linear algebra course we used Julia to explore the effects of various matrix operations. Jumping from there to 2021, I developed an interest in performance optimization, and met Valentin Churavy, which lead naturally to my work on the Julia backend to improve the speed of code generation and the performance of the generated code itself.

## Sari S. Dalum

I started with Julia back in 2017, when the version number was still 0.5.  I initially made contact with the community through the IRC channel, then got pulled over to Gitter, where I was immediately met with an extremely positive and inclusive atmosphere.  Within few days, I was encouraged to open PRs and take part in discussions surrounding the language, in particular related to linear algebra and generic programming.  I have always felt that the community structure has been very flat, and the distance to the core developers short.  Everyone I have communicated with have been open-minded and willing to discuss proposals and include users, both new and old, in the decisions.  The community events I have participated in have also been very warm and welcoming, which is without doubt the most important aspect of any programming language to me.  I now work with Julia full-time in a private company, and unfortunately have very little time to engage with the community, but I thought I'd put a few words here anyway, and hope to be able to join JuliaCon one day!

## Ronny Bergmann [(@kellertuer)](https://github.com/kellertuer)

I went through several programming languages during my studies and my PhD. I first learned about Julia somewhen in 2014 or 2015 but did not get to use it much. In 2016 I was annoyed by both the 2 language barrier as well as the coding style for objects in Matlab. So I decided to try whether this would work better with Julia. I was overwelmed by the constructive and helpful community from the beginning and endet up starting [Manopt.jl](https://manoptjl.org/). What then really surprised me was that the first feedback when annoncing the package endet up in a second package with two co-developers, which these days has a much larger code base than my first package. [Manifolds.jl](https://juliamanifolds.github.io/Manifolds.jl/stable/) is developed by people that never met in real life. Besides the code style and possibility to easily combine different packages, I like best that while the code still looks very simple and is easy to use, the speed is still astonishing. I am still amazed how nice and helpful the community is in the forum or any of the channels discussions take place. Both these aspects – code style and speed as well as the community – is why I think using Julia is one of the best choices I made concerning my numerics and code development.

## Tom Kwong [(@tk3369)](https://github.com/tk3369)

In 2017, I was looking for a technology that I can use to replace a slow SAS-based portfolio risk management platform. Julia actually caught my attention a year earlier but it used to crash occasionally. By November 2017, I took a second look at Julia and had great experience with that (version 0.6.3). I built [SASLib.jl](https://github.com/tk3369/SASLib.jl) as part of that exercise. So what was my experience?
- Community: I used Discourse and friendly people helped me along the way.
- Productivity: using [Revise.jl](https://github.com/timholy/Revise.jl), I was able to quickly prototype new ideas with a REPL-based workflow
- Performance: 10-100x performance improvement over Python's SAS reader after applying some simple changes e.g. using concrete types in structs

In order to replace an enterprise-class system with Julia, I had to do more prototypes, which involves:
- Reading/writing SAS datasets
- Running Oracle queries and perform inserts/updates
- Integrate with a financial C-library (FINCAD)

All of the above involves running performance benchmark with competing tech stacks such as Apache Spark. After few months of prototyping and lobbying, I was pleased to promote Julia as a language of choice for the risk management system.

I love Julia language so much that I wanted to spread my love to others. I did that in the form of writing the [Hands-on Design Patterns and Best Practices with Julia](https://www.amazon.com/Hands-Design-Patterns-Julia-comprehensive/dp/183864881X) book. I felt that many people coming from a different background (e.g. object-oriented programming) could benefit from learning a new paradigm pioneered by the Julia language. Writing the book also helped me grow to be a better Julia programmer.

While I do not have the opportunity to use Julia anymore at my current job (Meta), I am still quite deeply involved in Julia community work. I am an admin/moderator for the [Humans-of-Julia Discord server](https://discord.com/invite/mm2kYjB). And, I have been voluteering to help organize/review proposals for JuliaCon.

## Sebastian Micluța-Câmpeanu [(@SebastianM-C)](https://github.com/SebastianM-C)

I started using Julia in 2017 when I was looking for ways to speed up numerical integration of a system of ordinary differential equations.
I came across the DifferentialEquations.jl docs and I was very impressed, and I realized that it's worth it to learn a new language just for this package.
Soon after, I started to ask questions in the chat and I had my first PR a couple weeks later. The community was very welcoming and I learned a lot of new interesting things along the way.

## Simon Danisch [(@SimonDanisch)](https://github.com/SimonDanisch)

In 2012 I did an internship at VW/Audi, where I worked on image and sensor processing in C++.
Shocked about how much boilerplate even the smallest things need and how difficult everything is, I started looking for another language to settle on. Python looked great, but wasn't really an option, since I really like projects that need high performance like ray tracing, 3D rendering, ML and image processing.
I started designing a little toy language with good meta programming support, C and GPU interop without overhead and which didn't use OOP to make Mathematical code more extendable and easier to write.

Half a year later a friend forwarded me the "Why we created Julia" blogpost.I got super excited, since it checked off any of the features my toy language was supposed to offer.I dropped the pipe dream to write my own language (thank God) and started writing my bachelor thesis and all my other projects in Julia.

Best programming decision I ever made :)

## Anant Thazhemadam [(@thazhemadam)](https://github.com/thazhemadam)

My first *real* introduction to Julia was thanks to [18.S191](https://ocw.mit.edu/courses/mathematics/18-s191-introduction-to-computational-thinking-fall-2020/). I had heard about Julia in passing, from the TIOBE index and the occassional Hacker News post, but I never really bothered to look any more than that.However, this time it was different. It was finals week, and of course, I was looking for ways to "productively procrastinate".One of my routines for "productive procrastination" is browsing MIT-OCW and following literally any course that seems even remotely interesting to me.

That's when I saw 18.S191. It caught my eye for two reasons. One, I knew that there was an previous version of this course that was taught in Python, which made me very curious as to why they would switch to another language. Two, more imporantly, I saw that Grant Sanderson was one of the lecturers taking the course?!? What was the man behind 3B1B doing in an MIT course?! It might not have been clickbait, but it sure got my attention.

I followed the course a bit, really liked how easy and fluid-like everything seemed.I wanted to try things out. I headed over to the website, downloaded Julia and set things up. I really liked how easily I could get up and running and how intuitive it felt to me. I felt like for the first time ever, a language *actually* clicked with me. I still feel the same way.
I browsed some projects and packages in Julia. I understood very little. I hadn't even heard of some of these words before. I was *much more* excited now, by the prospect of being able to discover so much more that I had absolutely no idea about.
I ended up doing a Google Summer of Code with The Julia Language, which was honestly one of the best experiences I've ever had. I use Julia on a daily basis now and I genuinely look forward to doing so for a very long time.

I continue to discover so much more that I have absolutely no idea about, all thanks to Julia, and the *wonderful* community and ecosystem built around it.

*Come for the syntax, stay for the speed **and the community***. I know I did. :)

## Ian Butterworth [(@IanButterworth)](https://github.com/IanButterworth)

I started working at MIT a year after _that_ blog post. I was eager to find the new things lying around in the corridors to play with, and when I was told about this _cool new language_ developed in the building next door that promises to be fast, elegant, and fresh, I signed up. It's been great to see julia stabilize and grow while remaining true to mission. Perhaps my favourite thing is the ease of installation and reproducibility... the Pkg and JLL infrastructure make this a killer feature. Or perhaps it's the community... Contributing to packages, and more recently julia itself, has really taught me how good the FOSS experience can be and how much you can learn from it. I look back at my early contributions and grimace, but if you're not doing that, then you're not improving, right?

## Gaurav Arya [(@gaurav-arya)](https://github.com/gaurav-arya)

I'm a second-year undergraduate and started using Julia a few months ago for a project involving automatic differentiation, migrating from NumPy. Working in Julia has been *fun*. Sure, when I encountered a bug with a library, I might not have found someone on StackOverflow with the exact same error. But instead, there was readable source code! I've learned so much about language design, HPC, and much more in my use of Julia. Nothing feels like a black box, and I've found myself itching to contribute to the ecosystem. I'm excited to work through my to-do list of PRs and to see how the language evolves in the coming years :)

## Sebastian Pfitzner [(@pfitzseb)](https://github.com/pfitzseb)

I first stumbled upon Julia when looking for an open alternative to MATLAB back in 2014, during the transition from 0.2 to 0.3. A quick search for development environments turned up an abandoned IDE that didn't work with Julia 0.3, a simple Sublime Text integration, and this cool looking effort called [Juno](https://junolab.org/) (based on [Light Table](http://lighttable.com/) at the time); getting that working better on Windows was my intro to open source. A bit later Juno moved to the new Atom editor and I started contributing more and more, which led to me maintaining Juno for the next few years -- until joining forces with the team behind the [Julia extension for VS Code](https://www.julia-vscode.org/), where a lot of the effort in building better language tooling is focused today.

The language itself steadily improved over these years, albeit with the occasional speedbump or hugely breaking change. Many more people with vastly different interests and applications for Julia joined the community, which originally was a tightly knit group of enthusiastic early adopters (mostly with a scientific background); in all these years the community stayed welcoming, helpful, friendly, and overall amazing.

## Tim Besard [(@maleadt)](https://github.com/maleadt)

I started my PhD by experimenting with LLVM and a bunch of languages built on top of it. Right at that time, a Hacker News post announced a new and interesting language, Julia, which was both high level and targeting LLVM! So obviously I needed to incorporate that language into my research on hardware accelerators. As a result, I started working on a GPU back-end for Julia, and haven't stopped since. It used to be pretty difficult to get Julia to support our GPU shenanigans, but nowadays the language is becoming ever more extensible, so we should be well positioned to target the next 10 years of computer hardware!

## Simeon Schaub [(@simeonschaub)](https://github.com/simeonschaub)

I stumbled upon Julia in 2018. The thing that attracted me to this new language was really just curiousity. I had just taken a course in data analysis with Python the semester before and used a bunch of languages before that, so I just wanted to know what set it apart. I never contributed to open source before, but there seems to be something special about the Julia community in that it quickly sucks people in from answering questions on Discourse and Slack to actually contributing to different projects and base. So it didn't take long until I developed a small package on my own for something I needed for a class and eventually I also made my first PR to base. It was easy for me to fall into the Julia rabbithole and I quickly found myself learning a bunch of things about compilers. Because I wanted new Julia syntax I also had to pick up a bit of Lisp along the way and eventually I found myself at MIT doing computational science among a lot of other people equally passionate about Julia working on exciting new applications. To the next 10 years, can't wait to see what the future holds for Julia!

## Pablo Zubieta [(@pabloferz)](https://github.com/pabloferz)

In 2014 I was writing C and Python code for running simulations and doing calculations for my PhD, but I was somewhat unsatisfied with both. My brother after hearing this told me about this language called Julia which might be a better fit for what I was doing. I started playing with the 0.3 version and the Learn X in Y minutes examples, then I started reading the manual and I was hooked. Previously, I was unaware of many pitfalls of working with floating point numbers or many numerical linear algebra tricks, but the manual, the source code, the contributors all were incredible sources of knowledge. At the beginning if I had problems, I would report them on GitHub and wait, but then I noticed how easy it was to go over the source code and understand what was going and propose fixes, it then also led me to learn git, about good coding practices, many computer science concepts. Overall, it made me a better programmer and a better scientist. Even if I'm not doing work in Julia, I'm always prototyping in the language. In addition, the Julia community, is one of the bests I have found online. No matter if Julia has been around for 10 years, I know I will continue to learn from and be amazed by the language and the people around it in the years to come.

## Anas Abdelrehim [(@AnasAbdelR)](https://github.com/AnasAbdelR)

I first stumbled across Julia when I was looking to build a high performance digital twin simulator for industrial systems. It took me a day to build an end-to-end differentiable simulator that was 1000x faster, and seamlessly integrated a mix of differential equations and machine learning models. In comparison to using python, which up to that point was my go to programming language for over 5 years, I was 3 weeks in, and still wasn't finished. I was in such awe, that I became certain that this was where the future of real, safety critical engineering applications augmented with machine learning would happen. From there on, I knew I was never turning back, and that I was going to be apart of the journey of making it happen.

## Andreas Noack [(@andreasnoack)](https://github.com/andreasnoack)

I only found the original blog post about a month after it came out. I had read [another blog post by Doug Bates](http://dmbates.blogspot.com/2012/03/julia-version-of-multinomial-sampler_12.html) where he had been experimenting with

> a very interesting new language called Julia

At the time, I was a graduate student specializing in econometrics and had used R extensively. Hence, I knew about Doug Bates and I immediately decided to take a closer look at this interesting new language. The next thing I read was the "Why we created..." blog post and I was ready for more.

I needed linear algebra functionality for my PhD so I tried out what was available in Julia at the time. First to figure out that a lot of it was broken and then to realize that I could just fix it. I started doing just that. It was a lot of fun and very instructive to interact with the creators of the language as well as the other early adopters of Julia. It also ended up shaping the next ten years of my life.

## Patrick Kofod Mogensen [(@pkofod)](https://github.com/pkofod)

When I was a master's student I was doing a quantile regression exercise in Matlab. I was compute bound and asked around for alternatives. A PhD. student at the department told me to: "Ask Andreas Noack, he's involved in something called Julia that's supposed to be fast." It didn't take long before I had Julia Studio installed and was testing out the linear algebra functionality.

As a graduate student I found myself doing maximum likelihood estimation a lot, so I needed to do non-linear optimization. I found Optim.jl that was already well underway, but still had a lot of rough edges. One Google Summer of Code lead to another, and now I am using Julia every day in my job.


## Peter Cheng [(@chengchingwen)](https://github.com/chengchingwen)

I first started using Julia (v0.5/v0.6) in 2017, I was a sophomore at that time. Iblis Lin and I were in the same club and he introduced the language to me. I was fascinated by the language design, the use of multiple dispatch, and the ambition to solve 2 language problem. So I start to read the document and step by step port some code to Julia, and now I write almost everything with it. It is really amazing to see how a language evole, getting better and better.


## Scott Paul Jones [(@ScottPJones)](https://github.com/ScottPJones)

Back in March 2015, during my first week at a startup (with some people I'd worked with at InterSystems previously), I was tasked with choosing a programming language for the intensive numeric analysis we'd need for the product (a database based on natural language processing ideas). One of the engineers said I should look into Julia, that it might be a good fit.  Julia was at 0.3 back then, and was right in the middle of some fairly major syntax changes, so it wasn't an easy choice, however I quickly found that I could write code that was as fast as my highly optimized C code, but much more productively, with generic code, metaprogramming, and multiple dispatch. There were some difficulties with bugs in string handling at the time, so I spent a lot of time in the first few months making PRs to base Julia, but I could see that it was well worth the effort - after that we dropped C & Python, and switched to using only Julia for the database implementation.  I was able to attend Jeff Bezanson's Ph.D. thesis defense that May and JuliaCon in July at MIT, and have been a huge fan ever since.  I've also made many friends in the wonderful community over the past seven years, at JuliaCons, Gitter, Slack, Zulip, Discourse, and lately on the Humans of Julia Discord server. I'm still discovering new and interesting things about the language, and hope to still be programming mostly or totally in Julia for the next 10 years!

## Guilherme Haetinger [(@ghaetinger)](https://github.com/ghaetinger)

I had my first experience with Julia when taking a linear optimization class around 2017. The first time I saw the clear syntax and thoughtful macros, I had the feeling it would be a very closed and niched language, so I decided not to use it for other projects. A year later, I had the chance to work with Image processing research using Julia. The experience was overwhelmingly satisfying since there were a lot of tools available in "Images.jl". That time, I learned how extensible Julia is and how it solved almost all my undergraduate student problems. It's easy to say that, from here on out, I don't have to think twice about what language I should use for school/personal projects.

## Ricardo Rosa [(@rmsrosa)](https://github.com/rmsrosa)

I was attracted to Julia by a student, in 2020. I was teaching an extra class for a few group of students, after regular classes had been shut down due to the Covid-19 pandemics. We were using python and the code was quite slow (a stochastic, agent-based model with about 7 million agents, corresponding to the population of Rio de Janeiro, and including all sorts of demographics and social, school, and work-related networks, etc.). We were trying to optimize the code when one student came with a Julia version of the code that was blazing fast. I then learned about the DifferentialEquations ecosystem (my main research area), Flux, JuMP, and  SciML. I had to get into that. Shortly after that, I did the Advent of Code 2020 in Julia, with the help of the good people at the Humans of Julia Discord server. I learned some more about multiple dispatch, meta-programming, and performance tips. I was hooked. The fact that most of the code is written in Julia itself makes you learn so much about so many aspects of your code. Package and Tests makes life so easy. And the community is so friendly. As for the one-based index... well, I guess that just means we also have a head start...


## David Sanders [(@dpsanders)](https://github.com/dpsanders)

I first came across Julia at the SciPy 2013 conference, where Jeff and Stefan gave a talk -- at which I totally failed to understand how Julia differed from Python and why it was interesting. (This is still not so easy to explain!) I met them again later that summer when they and Steven Johnson were creating the first non-Python kernel for IPython, which later became the Jupyter project. Jeff spent an hour over lunch patiently explaining to me what was different and neat about Julia, which got me more curious.

The following semester I asked an undergrad student of mine to give a demo of Julia, but once again I failed to grok it. Finally, at the start of 2014 my colleague Luis Benet tried it out for the new interval arithmetic library we were trying to write. The code was *so clean and nice* compared to the horrible Python version! Performance wasn't relevant at the time for that particular project; nonetheless it was eye-opening that computing a set of random walk trajectories in Julia could easily run 50x faster than almost identical code in Python. From then on I was hooked.

In 2014 I gave a Julia tutorial at the SciPy conference, which was designed to force myself to learn the language properly. (I later discovered that Jeff and Stefan had been asked to give one, but were unable to attend.) I spent a couple of weeks at the MIT Julia Lab with Alan Edelman and his group beforehand in order to have people on hand to answer my questions; Jiahao Chen was another of the people that helped a lot with this.

The following semester I forced my poor computational physics students to use Julia -- version 0.3 came out a couple of weeks into the course. I've been using Julia exclusively since then for both teaching and research, and have learned a huge amount about how to think about software development from the amazing community.

## Tyler Thomas [(@tylerjthomas9)](https://github.com/tylerjthomas9)

I first worked with Julia when v1.4 (March 2020) was released. The early pandemic gave me some extra time to actually explore this new language that I kept hearing great things about. I was just starting research on my dissertation and loved the idea of using one language instead of switching between Python and C++/Rust (I hadn’t decided at the time which one I was going to go with). At first, the most interesting thing about the language was the speed. However, I quickly became obsessed language design (type system, multiple dispatch …) and it has been my primary language ever since. The Julia Discourse, slack and zulip chats have allowed me to learn a lot about the inner workings of the language while feeling like a part of this passionate, talented community.

## Bernie Wang [(Website)](http://mit.edu/~ywang02/www)

From the first time I heard about Julia in Alan’s office in 2011, Julia has brought so much joy and excitement over the last decade, and has become the key companion in my academic and professional life. A repeated theme of what leaves in me in awe about Julia is “it just works,” beyond anything I could have imagined! I would never forget the trill of running massive scale numerical experiments to explore what’s beyond universality laws of random matrix theory. Nor did I forget the magic seeing the ForwardDiff “just gets” the correct answer for the Jacobian of random matrix factorizations. A unprecedented feat that Julia has achieved, is successfully bridging the gap between computational science and computer science, not just the technical side, it brings different communities together! That, in my opinion, is really the foundation of solving big problems of our current and future times.


## Panagiotis Georgakopoulos [(@pankgeorg)](https://github.com/pankgeorg)

I was introduced to Julia by the MIT - Computational Thinking course. That was start of the quarantine era and I was cruising online resources to understand scientific computing a bit more. Coming from the front-end world of computing, I found Julia amazing because of its unique integration with HTML through Pluto. I started contributing to the Pluto.jl project - initially by fixing some CSS, then some React and finally diving deeper into Pluto's internals. Pluto's appearance in the Julia ecosystem is no accident; Julia is _so_ friendly when it comes to `show`ing stuff in HTML. Alongside its speed, which enables lag-free interaction, Julia creates the perfect environment for interactive programming and I feel glad and priviledged to be part of the journey!

## Huda Nassar [(@nassarhuda)](https://github.com/nassarhuda)

I first heard about Julia in Spring 2015 from an email from my PhD advisor. The task: try and install Julia from source and port some Matlab code. That occurred during my first year of my Ph.D. and this was for my very first project with my advisor. Initially, I needed to generate some very large graphs to validate a certain property on them but my entire pipeline beforehand (which consisted of a combination of C++ and Matlab code) was taking a few hours. With Julia, that same pipeline went down to less than an hour.

This first experience set the trajectory for my entire PhD, and we quickly knew that I would be doing the rest of my research projects using Julia. That summer, I predominantly worked on [MatrixNetworks.jl](https://github.com/JuliaGraphs/MatrixNetworks.jl), which included most of the graph algorithms that I and the rest of our research team would later need. It was fascinating and thrilling at the same time. It was fascinating to create something written with such simple and easy to understand code, yet have the performance of C or C++. To realize that you have the power to drill deeper, go into Julia internals, and squeeze every ounce of performance out of your code was a thrill ride. It was like, finally, there’s a language that allows you to express any algorithmic idea, without the language posing barriers.

At a certain point (probably around JuliaCon 2016), I realized that Julia had become more than just a programming language to me. It gave me a community where I met some of my most favorite humans in this world and a community I learn from every day. I am so grateful that Julia exists today!

## James Fairbanks [(@jpfairbanks)](https://www.github.com/jpfairbanks)

My first experience with Julia was back in the v0.2 days when I tried to use it for a higher productivity environment for high performance computing in a course project. It wasn't quite ready and the momentum in scientific computing was shifting to Python as people said "Numpy is fast enough." My research projects involved some C/OpenMP code and according to established researchers in HPC said, "OpenMP is easy enough." So, I went back to a combination of C/OpenMP and Python and started working on developing new numerical methods for spectral clustering. Eventually, I needed access to an ARPACK feature for accessing unconverged Ritz vectors that wasn't exposed through the Scipy API, which led me to read the ARPACK source code. There I found a TODO note to add the feature that I needed. Rich LeHoucq knew it was important, but didn't get around to it after taking note in 1996. Fortunately by that point Jiahao Chen and Andreas Noack were working on a pure Julia implementation of the Arnoldi method. I picked that up and got to work. That year, Jiahao, Andreas, Rich, and I met at a conference. I presented my first research results obtained with Julia and never looked back.

I'm thankful for everyone in the Julia community that has put in the work to build Julia and its amazing package ecosystem. Thankfully we never let "X is fast enough" or "Y is easy enough" prevent us from building the language, ecosystem, and community that we have today.

## Arturo Erdely [(@aerdely)](https://github.com/aerdely)

I'm a statistician that used R since 1997 until 2018 when I got stuck with performance for a simulation study I was working on. A specialist in Python tried to help me but the slow performance was similar in that programming language. I was considering going through the pain of learning C when somebody mentioned to me that Julia was quite promising, so I started to read about it and follow the Julia page. Finally, I decided to jump into Julia, not to try it, but to completely move all my work to Julia, no matter what. I'm very satisfied with what I have been able to do in Julia, still learning a lot because my poor computing skills and almost 53 years of age do not help, but so far since 2019 I do all my coding in Julia, I love the syntax, I do not miss R at all. 

## Tobias Knopp [(@tknopp)](https://github.com/tknopp)

I learned about Julia in 2012 some weeks after the famous blog post. My reaction was: Yet another project that makes great promises but cannot compete with my Numpy-optimized workflow. Tested it a little bit, but gave up soon. One year later the project was still alive and I gave it another try on what later became the NFFT.jl package. I compared my Julia NFFT implementation to a C implementation and it was slow. Opened  issue 4832 and Jeff and Tim Holy helped me fixing the type instabilities. Bam, I was sold. This language is awesome.

What followed was at least one year intensive programming in every single minute of my spare time. It was the time where Jameson pushed the Gtk.jl project and he helped me get involved. I worked at a company and coded an internal GUI prototype with Julia instead of Python. This was in 2014, just two years after its introduction. I was proud to make small improvements to the Julia core, nothing big, but small things that helped me learn more about this fascinating language. My dream was to embed Julia into the companies C# framework: This motivated me to write the first version of the embedding documentation. And despite my unperfected english skills it got merged. Wow that was a great feeling.

Then I had my famous Julia moment that is summarized in the PR 6741 called "WIP: Multithreading Experiment". At that time Jeff and others indicated that multi-threading is not needed in Julia. Distributed computing is less error prone. But I was greedy and wanted to convince Jeff, that Julia needs multi-threading and that Julia has the potential to get even more awesome when we have it! I had this intuition that it must be doable since compiled Julia code does not infer with the runtime library (hello Python, hello GIL).  I then went very deep into the Julia internals, spread locks everywhere, had segfaults, had deadlocks, was frustrated. But then, at some point I had something that did not crash. I still remember this moment where I started the PR and the community began pushing me forward. I need to quote what Jeff wrote: "One cannot help but admire this PR. This starts as an exercise in crashing the system in every possible way, but tknopp does not care, knowing that fortune favors the bold :)" Never in my live will I forget this post. I was part of this great community. I had the opportunity to make a difference. This was certainly my biggest contribution although the PR never landed in that form. But I convinced the core devs that multi-threading is a thing. This was in 2014.

Then my live switched completely since I went back to academia and got the opportunity to become a professor for biomedical imaging. I based my entire software infrastructure on Julia which was somewhat risky at that time but it was one of the best decisions I made. Follow your heart. I always get positive feedback by my colleagues that Julia made them very productive. Putting our research code into packages and publishing them as open source also made the code much more sustainable, which is a key in an academic career.

10 years, what a great time, what a great technology, what great people. But the time is now: I am looking forward to the next 10 years of exciting developments and the moment where the numerics students ask me what "Matlab" is, since they never heard about it.

## George Datseris [(@Datseris)](https://github.com/Datseris)
My first contact with Julia came to me at 2016, around the first semester of my PhD. I was initially a pure C coder, did some basic work with self-coded iterative map and Runge-Kutta ODE solvers for my Bachelor thesis. For my PhD I started using Python, and I was completely mindblown. Having only used C so far, I thought to myself "WOW, I can do science _interactively_ and see the output of any line of code _on the spot_?" I couldn't believe it. Well, sadly for me, I was solving 10000s of ODEs for my project, so I soon came to the dreadful realization that Python is just too slow and I have to go back to C... At the time a colleague (Rainer Engelken, fellow Julian) was going around offices "preaching" Julia: "It is as interactive as Python, but as fast as C!". Sounded like exactly what I wanted. I started with 0.4.7, and the prophecy was true. So I've stuck with it, and now I'm the guy that goes around offices and preaches Julia.

I am tremendously grateful to have come across the language, as well as its community and all the wonderful people that have helped me on this journey. It is not an exaggeration to say that much of my career successes I owe to the language. The code I was writing for my PhD became my very first Julia package: [DynamicalBilliards.jl](https://juliadynamics.github.io/DynamicalBilliards.jl/stable/). Making this package taught me a lot about writing good code, but also showed me how unbelievably easy to is to create a high quality package with Julia. Tutoring a course for nonlinear dynamics made me realize, in total frustration, that no general purpose library existed for nonlinear dynamics. Given my experience with DynamicalBilliards.jl, I thought "Well, I'll make it myself, shouldn't be so hard!". It took some time, but Julia made it as seamless as possible, and this gave birth to [DynamicalSystems.jl](https://juliadynamics.github.io/DynamicalSystems.jl/dev/), which went on to win an international award for software on nonlinear dynamics, and to compose a full introductory textbook about nonlinear dynamics [published by Springer-Nature](https://link.springer.com/book/9783030910334) that [explicitly includes Julia code snippets](https://www.youtube.com/watch?v=04HAQXl5aj4) in every chapter! Now, the JuliaDynamics organization has grown up to be composed of many contributors and packages, and I can't even wait for all that is to come in the next years!

## Michael Savastio [(@ExpandingMan)](https://gitlab.com/ExpandingMan)
In early 2016 I had recently finished my PhD in high energy physics having worked mostly in C++
during that time.  I was in my new job as a data scientist and looking for a language, particularly
after experiencing challenges trying to work with large-scale constrained
convex optimization in Python.  There didn't seem to be many good options (there was a lot of hype
about Scala at the time).  I had discovered Julia, a new language focused on scientific and
numerical computing.  The language had some interesting new ideas, particularly multiple dispatch as
its central paradigm, but was in a very early development phase (I think v0.4 had recently come
out), and there was *no way* I was going to wind up using it, especially in my new job, right?

6 years later, I have used Julia almost exclusively both at my job and individually ever since.  It
is still far and away my favoriate language.  It has been a significant part of my life and I'm
pleased to have made some small contribution to a large number of projects.  The Julia community
seems to be a natural niche for a lot of interesting people, especially those who have some aptitude
simultaneously for computing and for the physical sciences, a fact to which Julia owes many of its
wise design choices.  I anticipate continuing to use Julia and to be involved with open source Julia
projects for the foreseeable future.

## Alexandre A. Renchon [(@AlexisRenchon)](https://github.com/AlexisRenchon)
I discovered programming during my bioengineer Master studies, in a class about informatics and algorithms, with visual basic. I quickly became excited about the 
creative potential of coding. I created a few GUIs in VB, for mechanical engineer stuff and environmental sensing, the process was full of reflection and excitement,
I loved it. I was later introduced to MATLAB, also during my Master, and that became my main language for the next 10 years. I did my entire PhD in MATLAB, creating more 
GUIs for interactive visualisation of data analysis, many plots with complex layouts, and analysis with big datasets. When I transitioned to a postdoc position after my 
PhD, I had to switch to an open-source language as they didn't have a MATLAB license. That was a good oportunity as I wanted to go open-source anyway. I considered Python and R, 
but eventually opted for Julia. As a climate scientist, [this article](https://www.nature.com/articles/d41586-019-02310-3) was key. Also, after writing code in Python, R and 
Julia, I fell in love with the Julia REPL, whereas I wasn't very excited by anything about Python or R. It was also an opportunity to learn more about personal IDE (instead of 
just using R studio, or MATLAB built-in IDE). I tried all sort of IDE, and opted for VIM + vimteractive in the end. I also switched from Windows to Linux, and started using
GitHub more actively. I joined the Julia slack channel, tried Plots.jl, and discovered Makie.jl which became my favorite plotting package. I then discovered Franklin.jl, and
WGLMakie + JSServe. I discovered the possibility of doing so much in Julia. On top of it, I am convinced that it can solve the "2 language problem" that we have in environmental
science, where empiricists use scripting languages (R mostly), as they need simplicity and don't care about speed, and modelers use compiled languages (FORTRAN mostly), as they
need speed. By allowing both fields to use the same language, this creates new collaboration opportunities. This goes even beyond this, with the potential of creating super
modular Earth System Models with Multiple Dispatch, from empiricists and modelers. Machine learning is yet another aspect. I anticipate that Julia will grow rapidly in the
coming decades for Earth System Modelling work, so it makes total sense to use it as a young researcher in that field. I am always excited to see what new Julia releases, new
Julia packages of version will bring, and I created my first package [DAMMmodel.jl](https://github.com/CUPofTEAproject/DAMMmodel.jl) recently.

## SundaraRaman R [(@digital-carver)](https://github.com/digital-carver)

When I read 'Why we created Julia', "the two language problem" wasn't very much on my radar. I had a nerdy curiousity around what it took to solve it, but what actually grabbed my interest was the passion and interest the team showed for good language design, and the thoughtfulness with which they were approaching the task. As I slowly got more involved with the language, I found myself agreeing with the design decisions more and more, and appreciating the blend and balance of pragmatism and elegance in the language. Julia matched my mind's idea of what a programming language should be, and luckily also matched my interest in scientific computing and performant languages - I slowly came to have a "favourite programming language" again, and it was Julia. 

Around Julia 0.5 or 0.6, as I was playing around with regular expressions, I found some minor issues with them, and reported that. The responses mentioned the part of the code that might be responsible, and I was able to quickly pull them up from the language repository, understand the code, and fix the issue in an afternoon. That's when it hit me - the two language problem wasn't just about being able to write new performant code in the same language; it was also about being able to explore all (well, almost all) parts of the language and its ecosystem with the same knowledge it took to understand your own code. And being able to use the same tools and thought processes you use in your everyday code to explore, fix, or enhance them, however deep you are in the stack. It put power in the hands of the user, while keeping "easy things easy" (as Larry Wall would put it). That's what makes Julia a great language for me: it can lend itself to writing beautifully terse functional code one moment, and switching the next moment to carefully generating the most efficient code possible - the two can coexist and talk to each other, and sometimes even be the same thing!

## Douglas Bates [(@dmbates)](https://github.com/dmbates/)

Recently I wrote in a slack discussion

> This is why I found Julia so attractive when I stumbled across it late in 2011.  It is a dynamically-typed, REPL-based, language for technical computing built on a hideously efficient implementation of multiple dispatch plus a JIT compiler and designed by very talented people with a comprehensive knowledge of all aspects of programming.  And these developers think very carefully about any feature before incorporating it in the language.  It has been and continues to be a wonderful experience working with the Julia community.

Today I was working on a new package, [Wordlegames.jl](https://github.com/dmbates/Wordlegames.jl). 
I thought how the combination of [juliaup](https://github.com/JuliaLang/juliaup),  [PkgTemplates.jl](https://github.com/invenia/PkgTemplates.jl), the [VSCode extension](https://www.julia-vscode.org/) for Julia , [Pkg.jl](https://github.com/JuliaLang/Pkg.jl) and so many other tools make doing this so much easier.
It is a pleasure to work with such talented and generous people.

## Julius Krumbiegel [(@jkrumbiegel)](https://github.com/jkrumbiegel/)

I first learned about Julia in 2017 during my neuroscience Master's in Berlin.
I was doing a lab rotation where I kept trying (unsuccessfully) to convince everybody to ditch MATLAB for Python.
At one of these occasions a colleague quipped "Don't the cool kids use Julia instead of Python anyway?".
Surprised and slightly embarrassed that I had never heard of this language (and therefore was obviously not a cool kid) I looked online and found the "Why we created Julia" post.
Reading through it, I immediately felt connected to the people who had created Julia, because they shared so many of my values (and grievances with programming languages).
From that moment on I was quite hooked and explored Julia a lot in my free time - not for my university work, however, because I didn't need its speed, there was too much tooling friction, and the compilation latency scared me a bit.
Not much later, however, I had the need for interactive 3D plotting and got very frustrated with my Python options.
I found the package [Makie.jl](https://github.com/JuliaPlots/Makie.jl) which seemed elegant to me with its observable plots.
I soon wished for better axes and layout options, but when opening issues didn't magically materialize what I wanted, I realized I needed to become active myself.
So [out of the blue](https://github.com/JuliaPlots/Makie.jl/issues/354), never having done open-source development before, I first ported a constraint solver from C++, then contributed my own layouting system.
A couple years later, I'm still really glad to be able to work with such nice people on interesting Julia projects, it's a lovely community that I have become a part of.

## Robert Moss [(@mossr)](https://github.com/mossr/)

My introduction to Julia came in 2013 while working at MIT Lincoln Laboratory; the FAA needed a replacement for pseudocode when publishing the algorithm specification of the _next generation aircraft collision avoidance system_ [(ACAS X)](https://juliacomputing.com/case-studies/lincoln-labs.html)—ideally something runnable, fast, and concise. Being connected to MIT campus, Julia was on our radar and seemed like a promising approach. We were lucky enough to entrap the help of Jeff Bezanson shortly after. Since then, I've used Julia in my undergrad research (modeling galactic rotations), throughout my master's research ([black-box safety validation](https://github.com/mossr/mscs-stanford-thesis)), and now in my PhD at Stanford (where our lab, [SISL](http://sisl.stanford.edu/), has embraced Julia wholeheartedly thanks to Mykel Kochenderfer, ergo https://github.com/sisl). I found beauty in Julia's simplicity and closeness to mathematical syntax (e.g., [BeautifulAlgorithms.jl](https://github.com/mossr/BeautifulAlgorithms.jl)) and also have had (too much) fun playing code golf in Julia (e.g., [one-line Tetris in the REPL](https://github.com/mossr/Tetris.jl)). Starting early, I recognized the potential of Julia and also admired the openness, thoughtfulness, and logical community backing each decision made to the language. I've certainly committed to Julia (don't tell my wife) and hopefully act as an example for its usefulness in academia as a powerful research and teaching tool. It is no surprise that in ten years this language has gained the deserved traction—but more importantly has stayed on the original path of making programming _fast_ and _fun_.

## Nikhil Yewale [(@yewalenikhil65)](https://github.com/yewalenikhil65)

I was introduced to Julia(very late) by my friend and colleague [Mr. Gaurav](https://github.com/GKUCHANKAR) around 2019. I was happy with MATLAB and C++ and I did not pay much heed untill the pandemic started in 2020, when I saw the power of SciML using Julia when [Dr Christopher Rackaucas](https://github.com/ChrisRackauckas) in one of his online workshops of universal differential equations. I was amazed at the ease, elegance and speed of DifferentialEquations.jl package. I have since then adopted Julia as my scientific programming language for most of the science I do. I also admire the transparency and very helpful nature of Julialang community in their discussion forums such as discourse and slack channels. I enjoy exploring Julialang packages now, and have succesfully merged some of my implmentations in few SciML julia packages. Virtual JuliaCon's in last couple of years have also made life easier by aiding to catch up with the progress of scientific programming. I have a feeling Julia programmers are on constant watch for **whats new and novel published**, so that they can provide us with the implmentation quickly.
