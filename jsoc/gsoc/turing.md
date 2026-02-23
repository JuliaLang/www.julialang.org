# Turing Projects - Summer of Code

[Turing.jl](https://turinglang.org/) is a universal probabilistic programming language embedded in Julia.
Turing allows the user to write statistical models in standard Julia syntax, and provides a wide range of sampling-based inference methods for solving problems across probabilistic machine learning, Bayesian statistics, and data science.
Since Turing is implemented in pure Julia code, its compiler and inference methods are amenable to hacking: new model families and inference methods can be easily added.

For GSoC 2026 we offer projects from core AD work to scalable inference and user-facing tools.

If a project interests you, contact the mentors listed below or open a discussion on the relevant GitHub repo.
Please drop a short introduction message in the [`#turing`](https://julialang.slack.com/archives/CCYDC34A0) channel on the [Julia Slack](https://julialang.org/slack/) and feel free to ping [Shravan Goswami](https://github.com/shravanngoswamii) there, he is a past GSoC contributor and currently active in [TuringLang](https://github.com/TuringLang/). Mentors will be happy to discuss project details, scope, and expectations, and you can find mentor contacts at [Turing team page](https://turinglang.org/team/).

Also cross-posted on [Turing Blog](https://turinglang.org/news/).

## Mentor Contacts on Julia Slack

| Mentor | Slack Contact |
|--------|---------------|
| Hong Ge | [Slack](https://julialang.slack.com/team/UCRDHV7PB) |
| Xianda Sun | [Slack](https://julialang.slack.com/team/U03AV5JMJ8N) |

## New AbstractMCMC-based Gibbs Sampler for Turing.jl and JuliaBUGS.jl

**Mentors**: [Hong Ge](https://github.com/yebai) and [Xianda Sun](https://github.com/sunxd3)

**Project difficulty**: Medium

**Project length**: 350 hrs

Gibbs sampling is one of the most widely used inference strategies in Bayesian computation, but Turing.jl's current Gibbs implementation is tightly coupled to its internals and difficult to extend.

This project is about designing a clean, composable Gibbs sampler built on top of the [AbstractMCMC.jl](https://github.com/TuringLang/AbstractMCMC.jl) interface so that it works perfectly across both Turing.jl and [JuliaBUGS.jl](https://github.com/TuringLang/JuliaBUGS.jl).
Work will include:

- Agreeing on a minimal AbstractMCMC-compatible interface for conditional samplers.
- Implementing the new Gibbs combinator and verifying correctness on standard models.
- Migrating existing Turing.jl Gibbs usage to the new interface.
- Ensuring JuliaBUGS.jl can plug in its own conditional samplers without modification.

## Stateful Hand-Written Rules and Thread Support in Mooncake.jl

**Mentors**: [Hong Ge](https://github.com/yebai) and [Xianda Sun](https://github.com/sunxd3)

**Project difficulty**: Medium to Hard

**Project length**: 350 hrs

[Mooncake.jl](https://github.com/chalk-lab/Mooncake.jl) is a source-to-source reverse-mode AD package for Julia.
Two open issues currently limit its performance and applicability in real-world workloads.

The first is that every hand-written `rrule!!` must allocate scratch memory on every call ([issue #403](https://github.com/chalk-lab/Mooncake.jl/issues/403)).
Derived rules already avoid this by carrying persistent state between calls, but hand-written rules have no such mechanism.
The fix is a `StatefulRRule` struct that holds a `Stack` of saved state, constructed via a `build_primitive_rrule` function.
Rule authors implement `stateful_rrule!!`, which receives the current state (or `nothing` on the first call) and returns updated state alongside the usual outputs -- stack push/pop is handled automatically.
The work is to (1) add a test that fails when a primal is allocation-free but its `rrule!!` is not, (2) audit all existing hand-written rules with that test, and (3) convert the offenders.

The second is that Mooncake currently errors on any code using `Threads.@threads` ([issue #570](https://github.com/chalk-lab/Mooncake.jl/issues/570)).
Even a race-condition-free primal can produce race conditions on the reverse pass -- two threads may concurrently increment the same tangent element, so increments must be atomic.
Additionally, rule caches (the stacks inside `OpaqueClosure`s) must be Task-specific; sharing them across Tasks causes pushes and pops to interleave incorrectly.
The work involves writing rules for the `ccall`s that enter and exit threaded regions, ensuring atomic tangent updates, and making rule caches Task-local without relying on `threadid()`.

## Pigeons.jl Integration with Turing and JuliaBUGS via AbstractMCMC

**Mentors**: [Xianda Sun](https://github.com/sunxd3)

**Project difficulty**: Medium to Hard

**Project length**: 350 hrs

[Pigeons.jl](https://github.com/Julia-Tempering/Pigeons.jl) implements parallel tempering and related algorithms that are particularly effective for multimodal and high-dimensional posteriors.
This project has two related goals that together make Pigeons a first-class citizen of the TuringLang ecosystem.

The first part is documentation and examples.
Turing.jl models can already be used as targets for Pigeons, but the combination is under-documented.
The contributor will produce reproducible tutorials that walk through common use cases -- multimodal posteriors, hierarchical models, models with difficult geometry -- and compare Pigeons against HMC/NUTS on the same problems.
These will be published on the Turing website and any integration rough edges found along the way will be fixed.

The second part is implementing the efficient Gibbs sampler from [arXiv:2410.03630](https://arxiv.org/abs/2410.03630) in [JuliaBUGS.jl](https://github.com/TuringLang/JuliaBUGS.jl).
The paper shows that by exploiting the structure of the compute graph (rather than the graphical model), the time per sweep of a full-scan Gibbs sampler on GLMs can be reduced from $O(d^2)$ to $O(d)$ in the number of parameters $d$ -- making high-dimensional GLMs feasible where traditional Gibbs is not, and outperforming HMC on effective samples per unit time in many regimes.
JuliaBUGS already exposes the graph structure this approach relies on.
The implementation must be correct and performant, validated against standard benchmarks with comparisons to both traditional Gibbs and HMC.

## Contributor-proposed Project

**Mentors**: Community

If you have an idea not listed here, propose it. Submit a short proposal with motivation, a concise plan, expected deliverables, and a timeline. Maintainers and mentors will review and help turn it into a plan. Be prepared to discuss scope with mentors early.

To discuss proposals and next steps, contact [Shravan Goswami](https://julialang.slack.com/team/U04UZB5U740) on the [Julia Slack](https://julialang.org/slack/).
