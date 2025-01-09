@def rss_pubdate = Date(2016, 9, 21)
@def rss_description = """ A Personal Perspective On JuliaCon 2016 | The gentle breeze brushed my face and the mild sunshine warmed an... """
@def published = "21 September 2016"
@def title = "A Personal Perspective On JuliaCon 2016"
@def authors = """Ranjan Anantharaman"""


The gentle breeze brushed my face and the mild sunshine warmed an
otherwise chilly morning. I was standing in front of a large building that can
only be described as unique: a series of metal plates jutting out at odd angles,
whose dull resplendence cast an instant impression. It was the Ray and Maria
Stata Centre, a towering monolith and the venue for an event that
people from all over the world came to attend and participate in. I was in town for
the [third edition of JuliaCon](https://www.youtube.com/watch?v=EZD3Scuv02g&list=PLP8iPy9hna6SQPwZUDtAM59-wPzCPyD_S),
the annual Julia Conference at MIT.

On the eve of JuliaCon, a series of workshops were organised on some important
areas people use Julia for. I was conducting the
[Parallel Computing workshop](https://www.youtube.com/watch?v=euZkvgx0fG8)
along with some other members of the [JuliaLab](https://julia.mit.edu/). The key idea in our workshop was
to show users the many different ways of writing and executing parallel code in Julia.
I was talking about easy GPU computing using my package called ArrayFire and achieving
acceleration using Julia’s multi-threading.

Day 1 started off with the first keynote speaker - Guy Steele, a stalwart
in the software industry and an expert in programming language design. He
[spoke](https://www.youtube.com/watch?v=EZD3Scuv02g) about his adventures designing
Fortress, a language that was intended to be good at mathematical programming.
He went through the key design principles and tradeoffs: from the type hierarchy,
to their model for parallelism (automatic work-stealing), and interesting choices
(such as non-transitive operator precedence). My colleague Keno Fischer was up next
with a [tour](https://www.youtube.com/watch?v=e6-hcOHO0tc) of the new Julia Debugger:
Gallium! Gallium was quite breathtaking in its complexity and versatility, so much so
that Keno himself uses it to debug code in C and C++! A powerful debugger becomes even
better with GUI-integration, which Mike Innes very usefully
[pitched in](https://www.youtube.com/watch?v=yDwUL3aRSRc) with during his demo of
Juno-Gallium integration. Stepping, printing and breakpoints promised a powerful
package development experience.

The next session was all about data science. Simon Byrne
[spoke](https://www.youtube.com/watch?v=ScCY_nE0hlU) about the data science ecosystem
in Julia and future plans. He touched on the
[famous problem](https://www.johnmyleswhite.com/notebook/2015/11/28/why-julias-dataframes-are-still-slow/)
with DataFrames, and then laid out a roadmap for the ecosystem. The rest of the
session featured an interesting demo in
[music processing](https://www.youtube.com/watch?v=IOVrVOacLP8),
while Arch Robison [showed](https://www.youtube.com/watch?v=02NkiDoRDCU)
us how to use Julia as a code generator.

The evening had two sessions in parallel at different rooms. This is a recurrent
feature of JuliaCon, and it’s always hard to decide which session to attend.
This time, I chose to attend the sessions on
[automatic differentation](https://www.youtube.com/watch?v=xtfNug-htcs) in
[JuMP](https://github.com/JuliaOpt/JuMP.jl) and
[forward](https://www.youtube.com/watch?v=r2hhRSHiQwY) differentiation using
[`ForwardDiff.jl`](https://github.com/JuliaDiff/ForwardDiff.jl). I didn’t want to miss the
[talk](https://www.youtube.com/watch?v=AJHyr-O5qfY) on iterative methods for sparse
linear systems. Performance of different kinds of techniques and approaches were compared
and evaluated against one another, which made for a compelling presentation,
which I really enjoyed.

The evening session featured Jeffrey Sarnoff, one of the sponsors of JuliaCon 2016.
Mr. Sarnoff had some [very interesting thoughts](https://www.youtube.com/watch?v=R111conL0jM)
on extended precision floating point numbers. And so ended the first day at JuliaCon.
Now it was time to head to the JuliaHouse! The JuliaHouse was an AirBnb that a bunch of
Julia contributors rented out. They had a yard and a barbecue and it was the ideal place
for people to go relax, unwind and network with the other Julia folks. People chilled there
till the wee hours of the morning, and somehow made it on time for the next day’s session.

The second day started with a [keynote speech](https://www.youtube.com/watch?v=fl0g9tHeghA)
by Professor Tim Holy, a prolific contributor to the Julia language and ecosystem.
He spoke about the state of arrays in Julia and showed us a few of his ideas for iterators.
I saw that Professor Holy is widely admired in the entire Julia community due to his involvement
in various packages and the key issues on the language. I noticed that he asked some pretty neat
insightful questions at various earlier sessions too. Stefan was up next with his super-important
Julia 1.0 [talk](https://www.youtube.com/watch?v=5gXMpbY1kJY). It was quite a comprehensive list
of things that needed to be done before Julia would be 1.0 ready and he touched on a variety of areas
such as the compiler, the type system, the runtime, multi-threading, strings and so on.

The next session saw a team from UC Berkeley show off their
[autonomous racing car](https://www.youtube.com/watch?v=bX4TXWO7dA0) that uses some optimization
packages (JuMP and Ipopt in particular) to solve real-time optimization problems. Julia was running
on an ARM chip with Ubuntu 14.04 installed. Julia can also run on the Raspberry Pi, and my colleague
Avik took some time to [show off](https://www.youtube.com/watch?v=EvJ-OvTC5eE) a cool Minecraft demo
running on the Pi. The talk after that was about JuliaBox. Nishanth, another colleague of mine, has
been hard at work porting JuliaBox to Google Cloud from AWS, and he
[spoke](https://www.youtube.com/watch?v=j0tmyWJ-aSQ) about his exciting plans for JuliaBox.

Post lunch, I had to choose again between parallel sessions, but I couldn’t quite
resist the session with stochastic PDEs and Finite Elements. Kristoffer Carlsson
reviewed the state of [FEM in Julia](https://www.youtube.com/watch?v=30TUEhbGmuc),
talking about the packages and ecosystem for every FEM step from assembly to the
conjugate gradient. The next [talk](https://www.youtube.com/watch?v=EEP2NMgC9Zo)
was given by a professor at TU Vienna whose group conducts research on nano-biosensors,
and the group uses Julia to solve the stochastic PDEs that come up when trying to model
noise and fluctuations. The next [talk](https://www.youtube.com/watch?v=IjJqVwtWO3s)
on astrodynamics was very interesting in that it gave me an insight into the kinds of
computational challenges faced by scientists in the field. There were also some interesting
demos which I enjoyed, particularly the one where we modelled and visualized a target orbit,
which superimposed upon a visual of the earth in space.

In the afternoon, after much consideration, I went to the session that featured statistical
modelling and least squares. The first talk on
[sparse least squares optimization](https://www.youtube.com/watch?v=S5sA-Ch_KPo) problems
gave me a flavor of the kinds of models and problems economists need to solve, and how the
Julia ecosystem helps them. The [next talk](https://www.youtube.com/watch?v=ZfjRjljXYXk)
on computational neuroscience focussed on dealing with tens of terabytes of brain data
coming from both animals and human surgery patients. I had a very interesting discussion
with John earlier about his work, and I was able to get a keen sense of how why the package
he was talking about (VinDsl.jl) was important for his work. And so ended Day 2 at JuliaCon,
a highly educational day for me personally, with insights into astrodynamics, finite elements
and computational neuroscience.

I would contest that one of the best ways to begin your day is to listen to a speech by a Nobel
Laureate. It was quite a [surreal experience](https://www.youtube.com/watch?v=KkKBwJkYgVk)
listening to Professor Tom Sargent, and to see him excited by Julia. He gave us a flavor of
macroeconomics research and introduced dynamic programming squared problems that were
“a walking advertisement for Julia”. As a case in point, the
[next session](https://www.youtube.com/watch?v=Vd2LJI3JLU0) on DSGE models in Julia highlighted
the benefits Julia can bring to macroeconomics research and analysis.

The next session had a bunch of Julia Summer of Code (JSOC) students present their projects.
Some couldn’t make it to the conference so they presented their work
[through Google Hangouts](https://www.youtube.com/watch?v=On0AtfGh758) or through
[pre-recorded video](https://www.youtube.com/watch?v=AVOooQYi9F4). Unfortunately, I couldn’t
catch all of them because I wanted to catch my colleague Jameson’s Machine Code
[talk](https://www.youtube.com/watch?v=ErGi9sNgUjw) which was in another room. The material
he spoke about was very interesting, and got me thinking about the Julia compiler. I also had a
very enlightening discussion with him later about the Julia parser.

It turned out that in the afternoon, I was crunched for time. I was helping Shashi plug
[ArrayFire](https://github.com/JuliaGPU/ArrayFire.jl) into
[Dagger.jl](https://github.com/JuliaParallel/Dagger.jl) for his talk that was due in a
couple of hours, while also working on my own ArrayFire notebooks for late that evening.
But we managed to pull through in time. So the afternoon session had
Shashi [presenting](https://www.youtube.com/watch?v=1hvCuQtt6Yg)
Dagger, his out-of-core framework, followed by a [tour](https://www.youtube.com/watch?v=Ti9qqAe_NF4)
of [ParallelAccelerator](https://github.com/IntelLabs/ParallelAccelerator.jl) from the IntelLabs team.
I have been following ParallelAccelerator for a while, and I’m excited by how certain aspects
of it (such as automatic elimination of bounds checking) can be incorporated into Base Julia.

The evening session showed people how they can accelerate their code in Julia. The speaker
before me covered vectorization with [Yeppp](https://www.youtube.com/watch?v=luScuvqiow4)
before I [covered](https://www.youtube.com/watch?v=2f32XSMYlDk) GPU acceleration with ArrayFire.
It was quite overwhelming to be speaking in front of a bunch of experts, but I think I did okay.
But I did finish 5 minutes faster than my allotted time. As it turned out, both parallel sessions
actually ended up concluding a few minutes early.

Finally, Andreas came up to the podium for the concluding remarks and closed off a very important
JuliaCon for me personally. I was able to appreciate the various kinds of people involved in the
Julia community: some who worked on the core language to some who worked on their own packages as
part of their research; some who worked on Julia part-time, to some (like myself) who worked
full-time; the relatively uninitiated JSOC students to experienced old-timers in the community.
One thing tied them all together though: a quite thorough appreciation of a new language whose
flexibility and power enabled people to solve important problems, whose community’s openness and sense
of democracy welcomed more smart people, and the idea that a group of individuals on different time zones
and from different walks of life can drive a revolution in scientific computing.
