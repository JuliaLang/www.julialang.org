@def title = "The 2020 Industry Julia Users Contributhon"
@def authors = "TODO"
@def published = "TODO"
@def rss_pubdate = TODO
@def rss = """A Look Back At The 2020 Industry Julia Users Contributhon"""

A few months ago, I wrote [a blog post](https://julialang.org/blog/2020/09/juliacon-2020-open-source-bof-follow-up/) reflecting on an interesting JuliaCon 2020 discussion between a group of industry-focused Julia users that focused on the interplay between closed-source proprietary software development and Julia's open source software (OSS) ecosystem.
The blog post summarized a few key issues that our discussion group felt served as real hurdles to meaningful OSS contribution from within private organizations.
The post concluded by announcing our attempt to jump these hurdles: the Julia Industry Users Contributhon, a hackathon where participating industry organizations could come together to contribute back to the Julia ecosystem.

This event's goals were to...

> - ...foster/strengthen collaboration across organizational boundaries, and reduce potentially duplicated efforts.
> - ...both push forward and prove the Julia ecosystem’s readiness for “production” use.
> - ...provide a nice promotional incentive for the involved organizations to dedicate time to and participate in OSS efforts.
> - ...provide promotional and technical benefits to the Julia community as whole.
> - ...and have a huge amount of fun!

Now, in 2021, I'm happy to report on all of the great contributions made by the wonderful folks at [Beacon Biosignals](https://beacon.bio/), [Invenia](https://www.invenia.ca/), [TriScale innov](https://www.triscale-innov.com/), [RelationalAI](https://www.relational.ai/), and [PumasAI](https://pumas.ai/).
All shapes and sizes of contribution were welcome at the event: we released whole packages, made PRs, caught bugs, started new projects, and planned out our OSS roadmaps/backlogs for future work.

Here is a sampling of the standouts:

- [Lighthouse.jl](https://github.com/beacon-biosignals/Lighthouse.jl), which provides a minimal framework-agnostic interface to standardize/automate performance evaluation for multiclass, multirater classification models (Beacon Biosignals)
- [SerializationCaches.jl](https://github.com/beacon-biosignals/SerializationCaches.jl), which provides a simple, composable mechanism for caching objects that take significantly longer to compute from scratch than to (de)serialize from disk (Beacon Biosignals)
- [K8sClusterManagers.jl](https://github.com/beacon-biosignals/K8sClusterManagers.jl), which provides mechanisms to dynamically provision Julia workers overtop a K8s cluster (Beacon Biosignals)
- [KeywordSearch.jl](https://github.com/beacon-biosignals/KeywordSearch.jl), which leverages [StringDistances.jl](https://github.com/matthieugomez/StringDistances.jl) to provide a nice interface for fuzzy document searches (Beacon Biosignals)
- [PyMNE.jl](https://github.com/beacon-biosignals/PyMNE.jl), an interface to [MNE](https://mne.tools/stable/index.html) built on top of [PyCall](https://github.com/JuliaPy/PyCall.jl) (Beacon Biosignals)
- myriad JuliaPlots contributions (Beacon Biosignals): [AbstractPlotting.jl#569](https://github.com/JuliaPlots/AbstractPlotting.jl/pull/569), [AbstractPlotting.jl#570](https://github.com/JuliaPlots/AbstractPlotting.jl/pull/570), [WGLMakie.jl#71](https://github.com/JuliaPlots/WGLMakie.jl/pull/71), [JSServe.jl#76](https://github.com/SimonDanisch/JSServe.jl/pull/76)
- improved [RegistryCI.jl support for private package registries](https://github.com/JuliaRegistries/RegistryCI.jl/pull/306) (Beacon Biosignals)
- myriad AWS-related contributions (Invenia, Beacon Biosignals):, [AWSS3.jl#118](https://github.com/JuliaCloud/AWSS3.jl/pull/118), [AWSS3.jl#119](https://github.com/JuliaCloud/AWSS3.jl/pull/119), [AWSS3.jl#120](https://github.com/JuliaCloud/AWSS3.jl/pull/120), [AWSS3.jl#121](https://github.com/JuliaCloud/AWSS3.jl/pull/121), [AWSS3.jl#124](https://github.com/JuliaCloud/AWSS3.jl/pull/124), [AWS.jl#257](https://github.com/JuliaCloud/AWS.jl/pull/257), [AWS.jl#260](https://github.com/JuliaCloud/AWS.jl/pull/260), [AWS.jl#262](https://github.com/JuliaCloud/AWS.jl/pull/262), [AWS.jl#265](https://github.com/JuliaCloud/AWS.jl/pull/265)
- [DateSelectors.jl](https://github.com/invenia/DateSelectors.jl), which provides utilities for partitioning dates into test/train/validation/etc. sets for time-series machine learning (Invenia)
- [Cliquing.jl](https://github.com/invenia/Cliquing.jl), which implements various algorithms for finding a non-overlapping set of cliques in a graph (Invenia)
- [Checkpoints.jl](https://github.com/invenia/Checkpoints.jl), which provides mechanisms for dynamically checkpointing Julia program state (Invenia)
- [PDMatsExtras.jl](https://github.com/invenia/PDMatsExtras.jl), which extends [PDMats.jl](https://github.com/JuliaStats/PDMats.jl) with a couple different positive (semi-)definite matrix types that [nicely interopate with Distributions.jl](https://github.com/JuliaStats/Distributions.jl/issues/1219) (Invenia)
- [RegistryCLI.jl](https://github.com/triscale-innov/RegistryCLI.jl), a tool for easily managing private package registries directly from the command line (TriScale innov)
- [XUnit.jl](https://github.com/RelationalAI-oss/XUnit.jl), a unit test framework with nice parallelization capabilities (RelationalAI)
- Compiler support for compilation profiling during inference/LLVM optimization, [enabling cool new SnoopCompile.jl features](https://timholy.github.io/SnoopCompile.jl/stable/snoopi_deep/) (RelationalAI)
- Various quality-of-life improvements to [PProf.jl](https://github.com/JuliaPerf/PProf.jl), including flame graph support. (RelationalAI)

...and so many more issues/PRs/etc. that I couldn't fit here - especially the important work that went into [public OSS backlog creation](https://docs.google.com/document/d/16Rwkr5u8WdPh-AHVJHs2D2e-0SrUHQS_ZTB0fiepsmU/edit).

On top of the contributions themselves, this event taught us about (or in some cases, reminded us of) a few valuable points:

- Julia's package manager works seamlessly even when a single package's registered versions are split across private and public registries. In a lot of cases, this made it super easy to upgrade downstream internal packages to the now-open versions of their upstream dependencies - it just required a version bump!
- Having a well-documented, battle-tested internal process for safely open-sourcing private code drastically lowers the barrier to actually doing so. Creating an explicit (and if possible, public) "OSS backlog" is a great way to kickstart the development of an internal process.
- [Gather](https://gather.town/) is actually a pretty useful platform for collaboration! Adding a spacial component to video chat really goes a long way towards recreating the vibe of a shared workspace. After having a great experience using it to host the event, we at Beacon Biosignals created our own internal Gather space that we hang out in daily.
- Cross-org collaboration has always been a huge development driver in the Julia community, and this event was no different! It was fun to discover the various points of intersection between our orgs' tech stacks, and start working together directly on these tools. The JuliaCloud ecosystem (especially [AWS.jl](https://github.com/JuliaCloud/AWS.jl)) turned out to be of particular interest across participants.
- There are a lot of amazing engineers out there who, before joining an OSS-friendly company, never had an opportunity to contribute to OSS as part of their day-job. This event served as a great OSS onboarding ramp by enabling these individuals to translate pre-existing internal work into impactful external contributions.

All in all, I'd say the Contributhon was a success, and established some key points of collaboration between industry Julia users that I suspect will carry on for quite some time. More importantly, it was a whole lot of fun. Thanks to everybody that attended, everybody that facilitated, and all the wonderful folks in OSS community whose projects support Julia's continued rise in industry!

Have thoughts/questions about this blog post and/or the use of Julia in industry? Come join the discussion in [the Julia Slack's](https://julialang.slack.com/join/shared_invite/zt-ggsythg2-qYjdCBzGPeXceYCnCfpKsQ#/) `#industry-users` channel!
