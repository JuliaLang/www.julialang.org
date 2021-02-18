@def title = "Transitioning Code From Closed To Open: A JuliaCon 2020 Discussion Between Julia Users In Industry"
@def authors = "Jarrett Revels"
@def published = "16 September 2020"
@def rss_pubdate = Date(2020, 9, 16)
@def rss = """Within private companies, it can be difficult to smoothly transition internal code into high quality open-source contributions. At JuliaCon 2020, industry Julia users came together to discuss how to maximize their impact in the Julia ecosystem."""

Despite its virtual nature, [this year's JuliaCon](https://julialang.org/blog/2020/08/juliacon-2020-wrapup/) was just as energetic as every previous JuliaCon I've attended - absolutely bustling with fresh ideas and lively discussion amongst key leaders from across the open-source technical computing community. While JuliaCon has always been a hit with academic scientists/engineers that require large-scale simulation and modeling capabilities, recent iterations of the conference have seen a dramatic increase in industry user attendance.

Keeping pace with this growth, this year's JuliaCon featured more industry-focused content than ever before, from [Jacob Quinn's workshop on building microservices in Julia](https://www.youtube.com/watch?v=uLhXgt_gKJc) to the tried-and-true annual [Julia In Production BoF](https://pretalx.com/juliacon2020/talk/3AGJ3V/) ("Birds-of-a-Feather" discussion session).

This blog post is a summary of a similarly industry-targeted session: [the "Transitioning Code From Closed To Open" BoF](https://pretalx.com/juliacon2020/talk/L9LV3N/), attended by 15+ community members from 10+ companies. The basic premise of the session was:

> Within private companies/institutions, it can be difficult to implement effective internal practices that enable internal code to smoothly transition into high quality, open-source contributions. In this BoF, we’ll swap techniques for maximizing open-source impact in the Julia ecosystem while minimizing refactor time/effort and code churn.

## How The BoF Came To Be

Allow me to provide some background before diving in - I'm Jarrett :wave: Formerly a research software developer with [the Julia Lab at MIT](https://julia.mit.edu/), I left in 2019 to start [Beacon Biosignals](https://beacon.bio) with some incredibly talented neuroscience + Julia friends. We’re building technology to render brain monitoring more accessible, interpretable, and actionable, and the Julia ecosystem has played a critical role in many of our early wins.

By early 2020, Beacon had accumulated a lot of interesting work internally that I knew we should open-source/upstream, but perhaps unsurprisingly, it was difficult to actually prioritize doing so when there were so many other pressing concerns competing for our finite bandwidth. I imagined that we weren't the only private entity in the Juliaverse in which the phrase “ah, we should definitely open-source <internal tool> at some point” is commonly uttered but seldom acted upon.

I also recognized that every organization is unique, and the contribution challenges we faced at Beacon might not be the same challenges faced by other industry users. "Wouldn't it be great," I thought, "if us industry folks could get together and hash out strategies for tipping the OSS cost/benefit scales for our organizations?" And thus, the BoF proposal was born.

The rest of this post summarizes the thoughts, ideas, and conclusions that came out of the ensuing discussion at JuliaCon.

## Why Companies Contribute To Julia's OSS Ecosystem

Many early adopters of Julia in industry are already prolific contributors (and employers!) within the Julia open-source software (OSS) ecosystem. Here are a few motivating factors that have pushed these companies to contribute:

- Maintaining a community presence is great for recruiting both community collaborators and future FTEs, especially to attract the scientific domain experts that are prevalent in the Julia community.
- Open-sourcing a piece of software encourages well-scoped, composable APIs and discourages overcoupling of orthogonal functionality.
- Open-sourcing a project encourages structuring/maintaining the project in a manner that keeps the contribution/collaboration barrier low
- Improvements to the health/growth of the Julia ecosystem are felt by the companies that contribute to it, as a more robust/featureful ecosystem attracts more great community members and improves productivity for existing community members.
- As a language, Julia's strongly compositional nature (and its awesome package manager) makes it relatively intuitive to build and vendor self-contained packages from the get-go. From inception, such packages can be easier to separate from internal/private code than components of traditional monolithic codebases, thus lowering the effort required to publicly release them.
- Companies that take on open-source dependencies can more easily diagnose/fix issues that they encounter in their particular usage of the dependency. Contributing these patches upstream enables the patches to be tested and maintained by a much wider community.
- Companies can more easily extend open-source dependencies to better address their particular needs. By upstreaming these extensions (or releasing them as packages in their own right), companies can drive a dependency in the direction that is most impactful to them.

## Barriers To OSS Contribution From Industry

Industry users face many unique technical and non-technical challenges when making open-source contributions. Here are a few of the items discussed at the BoF.

#### "Clopen" Dependency Chains

This problem is introduced when open-sourceable code has a nontrivial (sometimes transitive) dependency that needs to remain closed-source. For example, package `A` is mostly open-sourceable, but depends on internal package `B` which is not.

One solution (that may require a small or large amount of effort, depending on the implementations involved) is to refactor the code-to-be-open-sourced's API to feature some form of [control inversion](https://en.wikipedia.org/wiki/Inversion_of_control) that allows internal users of the code to [pass in values that encapsulate private dependencies](https://en.wikipedia.org/wiki/Dependency_injection). Not only will doing this solve your open-sourcing problem; it'll also make your code more extensible/composable, so that both internal and external users can more easily extract value from the contribution.

Another flavor of this problem can exist when open-sourced code features many downstream closed-source dependencies. Multiple attendees noted that organizations would sometimes require the implementation/maintenance of an additional internal wrapper overtop the open-source version of their package.

#### Organizations That Don't Use OSS In The First Place

One attendee brought up that, for many organizations, the first barrier to allowing employee OSS contributions is to allow internal usage of OSS at all. It can be hard for decision makers at organizations that have no prior OSS experience to come to terms with the traditional motivations and arguments for OSS. They may even harbor [common misconceptions](https://www.dreamsongs.com/IHE/IHE-29.html#58965) about how the process actually works. Luckily, there's [a plethora of material available online](https://bfy.tw/OvDl) that targets exactly this audience that organization members can bundle up in a manner that's most effective for their organization.

#### Licensing, Patents, and IP

One difficulty reported during the BoF was getting organizational approval to release software [under permissive licenses](https://en.wikipedia.org/wiki/Permissive_software_license). This can be tricky, indeed, as there isn't a one-size-fits-all solution for every business, and non-technical decision makers might not have prior understanding of the legal aspects of OSS. A few different suggestions/ideas came up on this topic during the BoF:

- Organizations can appoint an informed decision maker that is trusted by both engineering and business stakeholders to hold final veto power over open-sourcing decisions. At Beacon, this person is the Chief Technology Officer (me!), while at [Zapata](https://www.zapatacomputing.com/), this person is the Chief Product Officer. Regardless of their title or role, it's crucial for an organization to have a decision maker that takes point on bridging the gap between technical and business concerns.

- Organizations should include appropriate licensing criteria directly in their OSS policy up-front. For example, here's Beacon's policy, ripped straight from our Engineering Handbook:

  > Any software which can feasibly be open-sourced without detriment to Beacon should be open-sourced. Open-sourcing code may be detrimental if doing so would add a substantial maintenance/development burden, introduce new security risks, or leak valuable intellectual property. We open-source code under the MIT license; it's extremely well-known, uncontroversial, and likely to be one of the few licenses universally accepted by virtually all other organizations. Furthermore, it acts as a check on our open-sourcing decisions - if it seems like the MIT license is too permissive for a given piece of code, then we probably shouldn't be open-sourcing that code in the first place!

- Companies whose primary commercial offering is software itself, rather than software-enabled products or services, may experience greater difficulty at delineating open-sourceable components from non-open-sourceable components. In this scenario, organization members can seek out similar companies in their market (or adjacent/similar markets) that appear to "do open-source well", and try to understand those company's decisions and figure out how the same reasoning might apply (or not) to their own situations.

- If possible, organizations should formulate their OSS plans in harmony with their IP strategy. It's easier to plan an IP strategy that incorporates OSS up-front than it is to retrofit OSS policies over top existing IP policies. For later-stage companies, the development of new products/services can provide an opportunity to revisit older IP models and refactor them into more OSS-amenable strategies.

#### Open Sourcing Packages That Previously Used Internal CI/CD

One important element of successful open-source projects is that CI logs should generally be available to all contributors. This can be a burdensome criteria to meet if a previously closed-source package utilized internal CI/CD pipelines with nicer properties than publicly available CI pipelines. In some instances, certain flavors of this problem can be solved with better tooling, e.g. self-hosted (but publically accessible) package registries can vendor open-sourced packages just as nicely as Julia's General Registry, but might leverage custom CI/CD for pre-registration checks.

#### Open Source Efforts Could Reveal Strategic Intent

One attendee proposed a very interesting challenge that they've faced in industry: In theory, their company was fine with contributing their internal implementation of a technique back to the OSS community, but couldn't actually do so because it would reveal that the company was working in a specific area of strategic interest to their market that they didn't want to reveal publicly. One solution to this problem would be to anonymously open source the implementation; however, this is obviously nonideal and the risk to business-critical strategic information will often be too high.

#### Git History/Metadata Preservation

Commit history and associated PRs, issues, etc. provide important context about design decisions that can ideally be preserved in the transition from closed-source to open-source. However, this can be a significant challenge depending on the provenance of the code and documentation practices. It appears that this process is easier (or less necessary) if...

- ...design decisions and their motivations are captured in history-agnostic documentation as a matter of practice.
- ...the to-be-open-sourced code is coming from its own repo rather than from a monorepo.
- ...the development platform is the same as the open-sourcing platform, e.g. going from private GitHub repo to public GitHub repo can be easier than migrating from GitLab to GitHub (though [Invenia](https://github.com/invenia) has proven that the latter is totally doable!).

## Conclusions

The BoF ultimately touched on a few high-level takeaways:

- Many technical problems associated with OSS are the same problems that make building robust and modular software difficult in the first place. The process is often analogous (and sometimes equivalent) to factoring a reusable library out of an application-centric codebase. The Julia ecosystem alleviates many of the burdens traditionally associated with this process by arming contributors with great open-source tooling, a well-designed package manager, and - of course - a highly composable underlying language.
- Many technical problems associated with OSS stem from the *transition* from closed-source to open-source, rather than post hoc maintainenance of open-sourced code. This may indicate that, where possible, it's more favorable to open-source code early (possibly even by default) to avoid accumulating technical/organizational debt that impedes open-sourcing later.
- Many organizational problems associated with OSS stem from poor incentivation for key decision makers and misalignment of open-source goals with business goals.

**This last point is, in my opinion, one of the most challenging obstacles faced by industry users who wish to participate in OSS.** To help overcome this issue, I'm announcing [The Annual Industry Julia Users Contributhon](https://docs.google.com/document/d/1maYTY_hzniSOYdbRiuC1Qqs5H92WydQFUOIaArA-f0g/edit?usp=sharing), an annual Julia community hackathon where participating industry organizations can come together to contribute back to the Julia ecosystem. Via the Contributhon, I hope we can...

- ...foster/strengthen collaboration across organizational boundaries, and reduce potentially duplicated efforts.
- ...both push forward and prove the Julia ecosystem’s readiness for “production” use.
- ...provide a nice promotional incentive for the involved organizations to dedicate time to and participate in OSS efforts.
- ...provide promotional and technical benefits to the Julia community as whole.
- ...have a huge amount of fun!

Have thoughts/questions about this blog post, the Contributhon, and/or the use of Julia in industry? Come join the discussion in [the Julia Slack's](https://julialang.slack.com/join/shared_invite/zt-ggsythg2-qYjdCBzGPeXceYCnCfpKsQ#/) `#industry-users` channel!
