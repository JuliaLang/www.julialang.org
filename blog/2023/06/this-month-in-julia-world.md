@def title = "This Month in Julia World (May 2023)"
@def authors = "Stefan Krastanov"
@def published = "30 May 2023"
@def rss_pubdate = Date(2023, 5, 30)
@def rss = """Community Newsletter for May 2023"""
@def mintoclevel = 2
@def maxtoclevel = 2
@def div_content = "container main newsletter"

There was a [call to action](https://discourse.julialang.org/t/why-open-source-timelines-roadmaps-dont-work/99518/17?u=krastanov) for someone to make a newsletter that lists interesting developments in the Julia world, in order to communicate improvements to the language that are not visible unless you track GitHub and Slack closely. This is my humble attempt, an editorialized, biased, incomplete list of what I personally found interesting this month. 

\toc

## Discourse

* [Tim’s post](https://discourse.julialang.org/t/why-open-source-timelines-roadmaps-dont-work/99518) prompting me to keep this type of notes

* [Chris asking](https://discourse.julialang.org/t/are-revise-packagecompiler-and-pkg-part-of-julia-and-how-do-we-better-share-them/99491) how to make Revise and other tooling more cohesively documented

* [Guillaume spearheading](https://discourse.julialang.org/t/the-graphs-ecosystem/99463) more cohesive Graphs ecosystem

* [RustFTT.jl](https://discourse.julialang.org/t/ann-rustfft-jl-compute-forward-and-inverse-ffts-with-rustfft/99574/14) - FFT implemented in rust, available as a julia package, not really better than FFTW, but interesting showcase of using rust inside julia

## Slack

* [ttfx] [Lilith and others discussing](https://julialang.slack.com/archives/C03LD7K8HLN/p1684602107700499) the potential for tiered JIT for better latency

* [appreciation] [Me being very impressed with SumTypes.jl](https://julialang.slack.com/archives/C6FGJ8REC/p1684278109859559) - followed by a discussion of techniques for avoiding runtime dispatch / union splitting

* [ttfx] [Tim discussing](https://julialang.slack.com/archives/C03LD7K8HLN/p1683654788117629) work on making precompile cache files smaller by avoiding caching unnecessary “junk”

## GitHub

* [draft] [libuv being bumped to significantly newer version](https://github.com/JuliaLang/julia/pull/49937): libuv is used by Julia (and Node and others) as the core IO/async building block. Julia’s devs have been the main contributors to libuv for a while and they have their own significantly diverged fork

* [nearing completion] [JuliaSyntax as a new julia parser](https://github.com/JuliaLang/julia/pull/46372), providing much better error messages, etc. Got a spur of progress after 1.9 was released

* [merged] [Simpler, more readable stacktraces](https://github.com/JuliaLang/julia/pull/49795)

* [draft] [A proposal for redesigning the Array interface](https://gist.github.com/JeffBezanson/a25dde3bebb5a734af87bb5ddcf31fb0) with a lower-level memory buffer structure

* [merged] [Multithreaded garbage collection](https://github.com/JuliaLang/julia/pull/48600), significantly speeding up GC

* [draft] [Make precompile cache files relocatable](https://github.com/JuliaLang/julia/pull/49866)

## Dustbin of history

* At some point there was work on [profile-guided-optimization for building even faster Julia](https://github.com/JuliaLang/julia/pull/45641)

* At some point there were experiment with [tiered JIT for Julia](https://github.com/JuliaLang/julia/pull/47484)

You can engage in the discussion of this newsletter on [Discourse](https://discourse.julialang.org/c/community/news/66)
