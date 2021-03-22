# Policies for Security/Community Research

This document lays out the Julia projects policies and guidance for researchers
wishing to perform research on Julia's software development processes,
contributors or other aspects of the julia community,

For security issues in the software itself, please see the [Security policy](https://github.com/JuliaLang/julia/security/policy)
or email [security@julialang.org](security@julialang.org).

## Scope

This document applies to the Julia programming language itself, the Julia package registries, as well as any packages directly affiliated with the Julia project. *Additionally, wherever this policy imposes any notification, disclosure or other requirements, such requirements also apply for research involving any packages registered in the Julia package registry (and thus distributed by the Julia project)*.

## Non-interventional research

Passive analysis of public information is generally fine. However, please ensure that your retrieval of such information is not disruptive (e.g. no excessive numbers of request submission to community infrastructure, or excessive bandwidth usage). Additionally, when referring to specific actions or inactions by specific members of the community in published writing, please follow these best practices:

- Avoid explicit use of an individual's name or their precise words (paraphrase instead)
- Avoid implications of a particular individual's direct culpability in a particular issue (focus on systematics instead)
- Avoid attributing insufficiencies to lack of care or attention
- Where applicable provide suggestions for implementable improvements

The goal of these guidelines is to encourage researchers to engage in meaningful dialog with the community. In many cases, process suboptimalities are known, but hard to address for lack of available volunteer capacity, funding or a combination thereof. Researchers can help by providing concrete data to understand the scope and extent of a particular problem and by providing concrete suggestions.

## Interventional research

Stricter requirements apply for research that involves direct interaction of the researchers or their agents and the community (for purposes other than ordinary collaboration on software development). Such research is considered *human subject research* should be handled carefully.

Such research may include (but is not limited to):

- Developer Surveys
- The posting of messages/issues/PRs to ascertain community responsiveness
- The use of multiple artificial accounts/profiles/personas
- Attempts at the deliberate introduction of non-functional or malicious code
- Automated interaction with the community (e.g. the automated filing of GitHub issues, Discourse posts, etc.)

It is the Julia project's policy to allow such research provided that each interaction includes a clear statement of:

1. The fact that is it part of a research project
2. The identity of the research project's PI
3. The goal and methodologies of the research project (may be provided as a link)
4. Information on how to request cessation of activities, deletion of specific data or a general opt-out

If such disclosure is incompatible with the objectives of your research, strict procedures apply.
In such cases, please email the [Julia Stewards](/community/stewards/) at [stewards@julialang.org](mailto:stewards@julialang.org) with a description of the following:

- The goals of your research
- The proposed methodologies of your research
- The identity of the project PI and all project staff
- The source (agencies, contract numbers, program managers) of all funding for your research
- The handles of all user accounts that will be used to interact with the community in furtherance of the research
- Any IRB review opinions of your research methodology (N.B.: for this kind of research, IRB approval will likely be a condition of approval by Stewards)

**DO NOT** begin your research unless and until you have received approval from Stewards. If you are contemplating such research, you are encouraged to contact Stewards early to discuss your plans.
Coordinating with Stewards helps ensure that somebody from within the community can monitor the
progress of your research, intervene should any issues arise, and quickly facilitate resolution
should your research be detected as malicious activity.

Where possible, and where your research may impose additional work on the community, writing
direct funding to the Julia project into your grant proposal may be appropriate.