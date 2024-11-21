@def rss_pubdate = Date(2019, 8, 28)
@def rss_description = """ Julia’s Release Process | People involved in the day-to-day development of a project tend to become so familiar with its rhythm and process that they internalize it and it feels like everyone must just _know_ how each stage unfolds. Of course, from the outside looking in it's not so obvious. So I thought it might be helpful t... """
@def published = "28 August 2019"
@def title = "Julia’s Release Process"
@def authors = "Stefan Karpinski (JuliaHub)"


People involved in the day-to-day development of a project tend to become so familiar with its rhythm and process that they internalize it and it feels like everyone must just _know_ how each stage unfolds. Of course, from the outside looking in it's not so obvious. So I thought it might be helpful to the broader Julia community—and maybe even for other programming language communities—to actually write down Julia's release process, including the details of:

- what kinds of releases there are
- what can and cannot change in each kind of release
- what the stages of the release process are
- who should use which releases based on risk tolerance
- the phases of a release and sequence of events surrounding it.

This information is collected from a small set of posts on [discourse](https://discourse.julialang.org/) and conversations on [Slack](https://julialang.org/slack/), so the information exists "out there", but this blog post brings it all together in a single place. We may turn this post into an official document if it's well received. Julia follows "semantic versioning" as specified in the [SemVer](https://semver.org/) standard, but SemVer leaves a fair amount of room for interpretation and says very little about process, so this post aims to fill in those details.

\toc

## Patch releases

- Patch releases increment the last digit of Julia's version number, e.g. going from `1.2.3` to `1.2.4`.

- Patch releases, following SemVer, should only contain bug fixes, low-risk performance improvements, and documentation updates. Of course, what exactly constitutes a bug fix can be more subjective than one might naïvely imagine since people write code that relies on buggy behavior. In general, we try to be very conservative with patch releases and use PkgEval[^1] to ensure that there's minimal risk. People should be confident that they can just upgrade to the latest patch release without worrying about it breaking things.

- Patch releases should also avoid changing internals unless it is necessary to fix a bug. Even though changing non-public code is technically fair game in any release, we want to avoid it in the name of minimizing the risk associated with patch upgrades as much as possible.

- Patch releases will be released approximately monthly for the currently active release branches (more below), unless there are insufficient bug fixes on the release branch to warrant a new release, in which case a month might get skipped.

- About five days before a patch release is supposed to go out, we will run PkgEval on the backports branch; if it looks good, we'll merge it and then freeze the release branch and announce on discourse that the release branch is ready for testing. If everything looks good after five days, the new patch version will be tagged.

## Minor releases

- Minor releases increment the middle digit of Julia's version number, e.g. going from `1.2.3` to `1.3.0`.

- Minor releases may include bug fixes, new features and "minor changes"—which is the term we're using for technically breaking changes that are sufficiently unlikely to break anyone's code _and_ which, in fact, do not break things in the package ecosystem as determined by running PkgEval to verify that there isn't any breakage.

- Minor releases are also where significant refactorings of internals go, since we should only be refactoring to the extent that is necessary for fixing bugs in patch releases. This means that if you're relying on some internal Julia stuff that's not public, your code might break in a minor release. This is allowed according to SemVer since the change isn't to a public API—so technically it can break at any time; but we will avoid this in patch releases, so minor releases will be where you have to watch out if you rely on internals somehow.

- ~~Minor releases are branched every **four months**, which means that there are three minor releases per year. The rate is controlled by doing timed features freezes for minor releases: every four months, we announce on discourse that the current development version is about to feature freeze (with about two weeks notice); then on the freeze date, we branch a `release-1.3` branch for the minor release and after that no more feature development is allowed on that branch, from which the release will be tagged. More on that process below.~~
    - Edit (November 2024): The process of a new minor release begins with the feature freeze. Periodically, we announce on Discourse that the current development version is about to feature freeze (with some amount of advance notice); then on the freeze date, we branch a `release-1.x` branch for the `1.x` minor release and after that no more feature development is allowed on that branch, from which the release will be tagged. More on that process below.

## Major releases

- Major releases can, according to SemVer, break anything at all. However, realistically we know how we want to write Julia code and that's not going to fundamentally change: most user-level code will stay the same in Julia `2.0` even though we're "allowed" to break things. Breaking things for no reason is not what this is about.

- What a major release does allow, however, is fixing obvious API design mistakes—the kinds of bad, confusing APIs that everyone will be glad to be rid of. It also allows changing low-level things that will break some libraries, but which need to be broken in order to make really fundamental improvements to the language.

## Long term support

Some users are happy to upgrade Julia all the time to get the hottest new features as soon as they're ready. Some people are even happy to build Julia's master branch every day and try out new features before they may be fully baked. Others don't want to upgrade Julia more than every year or so, if that often. Ideally, we'd love to provide bug fixes forever for every minor release of Julia we've ever made. If we had infinite resources, we'd backport every bug fix to every old release branch it applies to. Realistically, however, we don't really have the capacity to maintain more than a few active backport branches at a time. So we've decided on a compromise of having at most four active branches going at any time:

- The **master** branch: where all feature development happens, and where most bug fixes are made; and eventually, when we start working on `2.0`, where breaking changes will be made as well.

- The **unstable release** branch (currently `release-1.3`): the release branch that is feature frozen but where active bug fixing and performance work is still happening _prior_ to the next minor release (i.e. `1.3.0`). Typically bug fixes are done on master and then backported to this branch. There isn't always an unstable release branch: it only exists after a feature freeze but before the corresponding release; after that it becomes the stable release branch and there is no unstable release branch until the next feature freeze.

- The **stable release** branch (currently `release-1.2`): the release branch of the most recently released minor (or major) version. This always exists and gets all applicable bug fixes backported to it from `master`. Future bug fix releases of the minor version will be made from this branch (e.g. `1.2.1`).

- A **long term support (LTS)** branch (currently `release-1.0`): an older release branch that will continue to get applicable bug fixes for as long as it continues to be the LTS branch. Extra effort is made to backport bug fixes to this branch—it may get its own versions of bug fixes as necessary when a later fix doesn't apply cleanly.

A new unstable release branch is created every time there's a feature freeze, it becomes the new stable release branch as soon as the first stable release is made on that branch: i.e. when we release `1.3.0` final, the `release-1.3` branch will become the new stable release branch, `release-1.2` will become unmaintained and there won't be any current unstable release branch until the next feature freeze.

The big question is when to change long term support branches. The `release-1.0` branch is the only LTS branch we've ever had. It's gotten four patch releases and has become very stable and widely supported. At some point, however, it will become increasingly rare for bug fix patches made on `master` to apply to `release-1.0` and fewer and fewer current versions of packages will support `1.0.x` versions of Julia—they'll be using too many new features. When that happens—and the right time is a judgment call—we'll have to pick a new long term support branch and declare the `1.0.x` series unmaintained. The new LTS branch might end up being `1.4` or `1.8`—or maybe it won't happen until `2.0`. We're not sure, but it will happen at some point. Fortunately, even this does not force people using Julia `1.0.x` to upgrade: they can keep using the last `1.0.x` version and packages that are compatible with it. At that point it will be the most stable, thoroughly tested, patched version of Julia in existence, so it will be safe to keep using indefinitely if one doesn't need newer features. Moreover, if some person or organization has a vested interest in keeping any particular older release branch going and is willing to contribute the work to make that happen (cherry-picking backports and kicking off PkgEval runs to make sure things aren't broken), we're more than happy to accept that help and make more releases. So you can always get longer term support by doing the maintenance yourself (or paying for someone to do it). For now, `release-1.0` continues to be an excellent, stable LTS branch and there will be plenty of warning before we change LTS branches.

## Risk Tolerance Personas

Different users of a language have very different levels of risk tolerance. Some users are perfectly ok with discovering and reporting the occasional bug and helping figure out why some packages aren't working with a new release. Others only want to use a version of the language that has had a many rounds of bug fixes and for which every package has been working flawlessly for a long time already. And there's a spectrum of risk tolerances between these cases. Most users will fall into one of the following four categories of risk tolerance:

1. **High risk tolerance:** "YOLO, I live on master. Of course, this isn’t as risky as it used to be since there won’t be breaking changes on master for a while, so packages should continue to work even on master, but bugs happen, y’know? I’m willing to help find them."

2. **Normal risk tolerance:** "I like things to work and don’t want to deal with transient bugs on master. So I’ll stick to the latest stable release and upgrade to the current patch release of that when it’s available since that’s pretty safe and I’ll get bug fixes and performance improvements. The only annoyance is when a package I’m using breaks because it was depending on some Julia internals and it may take a while before it gets a new release."

3. **Low risk tolerance:** "I’m conservative and risk-averse. I follow the current LTS branch since it has already gotten significant testing. When the LTS branch changes, I'll upgrade since by the time it becomes the new LTS branch, it's already on its fourth or fifth patch release, so the bugs are shaken out and any package breakage there might initially have been has long since been sorted out."

4. **Very low risk tolerance:** "I’m extremely risk averse. I never upgrade Julia (or anything) except for critical bug fixes and security issues. I run a version of Julia that’s no longer actively supported, but it’s the last release of a former LTS branch so has a double-digit patch number and has been really thoroughly debugged. If I need a new bug fix on this ancient release branch, I will backport it myself and help cut a new, even more reliable patch release."

These profiles make it a bit clearer that the main criteria for the long-term-support branch are that the branch has these properties:

- It has had sufficient patch releases that we’re confident that it’s highly reliable;
- Any packages that are ever going to support it have already released versions that do.

If these two criteria are satisfied by a new LTS branch, then users in the "low risk tolerance" category will be able to upgrade to the new LTS branch since they can already be confident that it will be reliable and well-debugged and that packages they need will be ready to use (although they may need to upgrade their versions of packages). We’ll have to learn from experience how many releases the LTS branch should lag the stable release branch by.

## The release process

We've discussed what various kinds of releases mean and what types of changes can go into them, but we haven't talked much about how a release actually gets made. In this section I'll outline how we go from working on features on the `master` branch to tagging a final version of the release and after that making patches of that release. I will use the word “bugs” to refer to both bugs in the usual sense of incorrect code but also “performance bugs”—i.e. code that runs slower than we consider acceptable. In Julia, performance is a vital property and we often consider performance issues to be blocking bugs. The following is an outline of the sequence of events surrounding a `x.y.0` minor release:

- **Development** (~~4 months~~ time period varies)
    - on the `master` branch
        - develop new features, fix bugs, etc.
    - tag `x.y.0-alpha` (optional)
        - very early preview of a new release—it is not feature frozen yet and may have known bugs
    - tag `x.y.0-beta` (optional)
        - slightly later preview of a new release—it is still not feature frozen yet and may have known bugs
    - `x.y.0` feature freeze
        - create `release-x.y`, the new unstable release branch
        - no new features will be merged on the release branch, only bug fixes
        - new features can continue to be merged on the `master` branch, they just won’t go into the `x.y.z` release
- **Stabilization** (1-4 months)
    - on the `release-x.y` branch
        - fix all known release-blocking bugs
    - tag `x.y.0-rc1`
        - fix all known release-blocking bugs
    - tag `x.y.0-rc2`
        - fix all known release-blocking bugs
    - ...
    - tag `x.y.0-rcN`
        - one week without any release-blocking bugs
    - tag `x.y.0` final
- **Maintenance** (until `x.y` declared unmaintained)
    - on the `release-x.y` branch
        - backport bug fixes to the `release-x.y` branch
    - tag `x.y.1` (a month or two later)
        - backport bug fixes to the `release-x.y` branch
    - ...

You can tell just from a glance that this might be a long and unpredictable process. In particular, the stabilization phase can take a highly variable amount of time—from a few weeks to months. This creates a tension between assuring quality and wanting to have a predictable rate of releases. On the one hand, we do not want to rush the release candidate process since it is very much what ensures that each Julia release has the quality and stability that you've come to expect. On the other hand, we don't want the overall rate of releases to be held hostage to the vagaries of how long debugging takes—and we all know that can be a long, painstaking process for any project, and especially for something as complex as a programming language.

We resolve the tension between assuring the quality of releases and keeping a predictable release rate by overlapping the stabilization of one release with the development of the next release. The development phase of each release is time-boxed at four months and the development phase of `x.(y+1)` starts as soon as the development phase for `x.y` is over. Come rain or shine we have a new feature freeze every four months: we pick a day and you’ve got to get your features merged by that day. If new features aren't merged, they’re not going in the release. But that's ok, they'll go in the next one. This approach also means that `master` is always open for new features rather than being frozen during the stabilization period.

As a result of overlapping development and stabilization, if release candidate process takes an unusually long time, the final release of `x.y.0` might happen at around the same time as the feature freeze for `x.(y+1).0`. This happened with `1.2.0` and `1.3.0`, for example. There was some confusion and consternation expressed about this on discourse, but that's the inevitable side effect of keeping a predictable release rate. The `1.2` stabilization phase was an unusually long one, which happens sometimes. We're always examining our process and thinking about how to improve it. One change which might help is running PkgEval more often in a completely automated fashion so that we know earlier when a change during development breaks packages. Running PkgEval early and often makes it easier to narrow down which change caused the breakage. If anyone wants to get involved and help make the Julia release process better, helping with PkgEval would be a really high impact piece of work which does not require deep technical knowledge.

One point to note, since people are sometimes confused by this: feature freeze only affects new functionality—bugs can be fixed at any point on any branch. It is never too late for a bug fix. The only time where a bug fix will not go on a release branch is if it is no longer maintained. Even then, if someone else wants to fix a bug and go through the process of making a new release, we will gladly help, we just won’t do it ourselves.

## Why pre-release versions?

Even though they are a standard part of release process, it may not be obvious to people what the purpose of alpha and beta releases is or what a "release candidate" is. Why do these "pre-release" versions exist? I know this was not fully apparent to me until I started to try to actually make software releases. These releases are all about communication with the people who depend on your software. They act as a signal saying "please test this now". Each one requests a different kind of feedback from different kinds of users:

- An **alpha release** says: "this is not feature complete yet and almost certainly has bugs, but we want early feedback on some important new features so that we can change them or fix them before they become carved in stone."

- A **beta release** is very similar to an alpha release but one can expect a bit more polish and fewer bugs since there has probably already been an alpha. We have only ever done beta releases for Julia `0.6` and `0.7` (aka `1.0` with deprecations), both of which had alpha releases first.

- A **release candidate** says: "this is really almost ready, please test it now and let us know if there are any bugs at all because otherwise we might end up making a release that has bugs that affect your application." A release candidate should actually be a version that, as far as we know when it's tagged, could be the next release. In other words, it should contain no known release-blocking bugs.

So when you see an alpha or a beta or a release candidate, try it! Let us know if it doesn't work for you in any way. Doing that will help make sure that the final release is as smooth and high quality _for you_ as possible.

## Release maintenance

On the subject of bug fixes: the life of a release is not done when `x.y.0` is tagged—there are any number of `x.y.z` bug-fix releases that may be tagged as well. How does this process work? Bugs are fixed on all active branches, but they are generally fixed on the most current branch which has the bug and then "backported" to all earlier branches which are still active. So, for example, if a bug exists on `master`, it will be fixed on `master` and the pull request (PR) that fixes it is labeled on GitHub with `backport x.y` for all active branches which also have the bug. Since the current active branches are `master`, `release-1.3` (unstable), `release-1.2` (stable) and `release-1.0` (LTS), the fix for a bug on master would be labeled with `backport 1.3`, `backport 1.2` and `backport 1.0`. The change is then cherry-picked (using `git cherry-pick -x`) onto each of these branches for the next patch release of that branch. If the fix applies cleanly and passes tests, that's great. If not, then additional manual work may be required to make a fix that applies to a branch.

Once a release branch has accumulated enough bug fixes and enough time has passed, a new bug fix release `x.y.z` is made. This is announced on discourse about five days in advance so that people can test the new version. We do not currently have the bandwidth or resources to make binaries or release candidates for patch releases—there are just too many of them. So in order to test you need to either use a nightly build or build Julia from source. Helping to automate and streamline the patch release process is another high-impact area for anyone looking to get involved in the project.

## Conclusion

Hopefully you've found this overview of Julia's release process and policies illuminating. The very best thing we can hope for is that some of you reading this will find it interesting and want to get involved and that by demystifying things, we've helped make becoming a Julia developer a little more accessible.


[^1]: [PkgEval](https://github.com/JuliaCI/NewPkgEval.jl) is a tool for running the test suites of all Julia packages, which helps us make sure that we haven't inadvertently broken anything. Each failure is examined when a release is made: we verify that the failure isn't due to a violation of SemVer and try to make pull requests to fix packages, regardless of the cause of the failure.
