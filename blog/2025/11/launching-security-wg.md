+++
mintoclevel = 2
maxtoclevel = 3
title = "Launching the Julia Security Working Group"
authors = "Matt Bauman ([@mbauman])"
published = "20 November 2025"
rss_pubdate = Date(2025, 11, 20)
rss = """Launching the Julia Security Working Group"""
+++

There's been a lot of security work in the Julia ecosystem recently, and those of us pushing
on this effort have informally self-organized around a slack channel ([#security-dev]) and a
handful of repositories and pull requests. We are past due in officially listing our efforts
as a working group! With this blog post, we are announcing the creation of the Julia Security
Working Group (JLSEC) — an official community effort to improve the security tooling of the
Julia package ecosystem.

Join us! We'll have our inaugural working group call on Friday, December 5 at noon
US Eastern. If that date doesn't work for you, drop by the [Slack #security-dev channel][#security-dev]
and let us know!

It's worth taking the opportunity here to discuss all that's happened to catalyze
this working group — not only is it a great occassion to celebrate all this work,
but it helps describe the scope of this working group and points to the many places
where folks can get involved.

\toc

## SBOM support for Julia projects, libraries, and applications

Software Bills of Materials (SBOMs) form the backbone of many security analyses;
before you can make any statement a particular Julia package or project you must
first know what it contains. For us Julians, it's obvious that the Manifest.toml
_is_ our SBOM, and you can use the excellent [PkgToSoftwareBOM.jl] by **[@SamuraiAku]**
within Julia itself to generate a standard SPDX JSON (by way of [SPDX.jl]). There
are other formats and schemas for SBOMs, but SPDX is a very common one

Many IT and security teams work in heterogeneous environments, so there are dozens
of third-party tools that support _many_ language ecosystems and can scan through
polyglot projects or entire images. Very few, however, have implemented the support
that's required for them to understand Julia's `Manifest.toml`. Last year (2024),
Ryan Benasutti (**[@Octogonapus]**) added Julia SBOM support to [trivy], an open
source security tool that supports both SPDX and CycloneDX formats.

There are many other tools, both proprietary and open source, and one great way
for folks wanting to get involved in these efforts could be in helping implement
Julia support across other open source tooling.

### PURL support for Julia packages

One challenge in a multi-language context is understanding what a particular name
like "HTTP" references; Rust, Python, and Julia all have http packages (and some
ecosystems aren't case-sensitive). While we have a strong convention of using the
`.jl` suffix when talking about packages (and even naming their repositories), the
name in the Manifest (and what you type when you `import` or `Pkg.add`) is truly just
`HTTP`. The [PURL spec][purl-docs] is a strong effort at standardizing the way to
consistently refer to a particular ecosystem's HTTP package without getting confused.

As of October (2025; thanks again to Ryan's efforts), Julia is an [officially designated
type][purl-types] within the schema, allowing you to specify HTTP.jl more officially as
    pkg:julia/HTTP?uuid=cd3eb016-35fb-5094-929b-558a96fad6f3
or even with a version like:
    pkg:julia/HTTP@1.10.16&uuid=cd3eb016-35fb-5094-929b-558a96fad6f3

Both Trivy and PkgToSoftwareBOM.jl generate SBOMs with these PURL identifiers. A
wonderful place to get involved here could be in the development of a pure-Julia
PURL.jl package like [Go][packageurl-go] or [Python][packageurl-python]'s (the
lead maintainer there even [asked us for one][purl-ask]!).

## Security advisories for Julia packages

Knowing what's inside a particular project is only the first step in a security
review. The next step is to start asking if any of the dependencies have critical
vulnerabilities or other security issues. The industry-standard mechanism for
alerting about serious security issues is through **advisories**, most commonly
as [CVEs][cve.org]. These identifiers allow folks to very precisely name and
discuss particular problems, and security tooling can help flag software packages
that have unpatched vulnerabilities. One challenge is that the CVE ecosystem is
_industry wide_, and the advisories themselves just contain a block of plaintext.
There are many efforts to augment (or "enrich") the CVE advisories with more precise
and structured metadata (including package ecosystems and versions), but there
are also many challenges at this global level.

### The first Julia package security advisories

Prior to June (2025), there simply weren't any advisories for any Julia package<attr title="see the JLL section below">*</attr>.
This didn't mean there _weren't issues!_ We filed the first advisories against
a handful of packages as GitHub Security Advisories on their repository security
pages, thanks in part to JuliaHub's security program and **[@aviks]**. For example,
the [security tab on HTTP.jl][HTTP-security] now lists multiple advisories like
[GHSA-4g68-4pxg-mw93]. Those `GHSA-` identifiers act like CVEs, but they are issued
directly by GitHub. The HTTP.jl maintainers then asked GitHub support to review
these particular issues and — as GitHub is a CVE naming authority — issue a
corresponding CVE identifier (as an _alias_): [CVE-2025-52479].

Now put yourselves in the shoes of an automated vulnerability scanner. You
have an SBOM that has includes Julia's HTTP package at version v1.10.15. How do
you connect _either_ that CVE or the GHSA to Julia's package? The CVE doesn't
have structured package/version data, and the GHSA _doesn't actually appear_ in
GitHub's global advisory database because Julia is not (yet) a "reviewed ecosystem"
(yes, even though GitHub staff reviewed the advisory and filed the CVE as a CNA).
You'd have to scan the security pages of _every_ registered package to piece
this together!

This is precisely one of the reasons behind:

### The [SecurityAdvisories.jl] database

Prior to these recent efforts, we were unable to issue or even gather together
such Julia advisories. Having a dedicated database of Julia-specific advisories
allows our package ecosystem to more effectively participate in the global advisory
universe:
* Only a registered CVE Naming Authority (CNA) can reserve and issue CVE identifiers.
  It is challenging and opaque to determine how to best issue a new CVE advisory.
* While GitHub's GHSA can act as a CNA and issue CVEs through their GitHub-based security
  advisories, Julia is not (yet) an officially GitHub-supported ecosystem. So while
  repositories can generate advisories with GHSA ids, they are not available in GitHub's
  global advisory database and simply aren't discoverable. They aren't even _fetchable_
  by API without knowing their issuing repository.
* We also have many registered packages in our ecosystem that are not GitHub-hosted;
  these too may need to issue advisories.
* There may be _existing_ CVE advisories that pertain to a Julia package, but the
  only way to explicitly state that the Julia package is affected (and at which
  versions) is by issuing an "alias" or "downstream" advisory.
* Most fundamentally, it grants the Julia community full ownership and control
  of the advisories that pertain to our ecosystem.

Building a database of advisories comes with a number of challenges, not least of
which is the structure and schema.

#### The `JLSEC-` advisory prefix and OSV-schema specification

The `CVE-` prefix is not special beyond its well established name-cred and decades
of use. There are *many* other advisory ecosystems (like `GHSA-`), all of which
collaborate together and can bring more specific (and structured) data to bear,
often within a more limited purview. Many other well-established languages have their
_own_ advisory prefix that allows them to very specifically only address issues
within their respective package ecosystems. For example, advisories with the prefixes
`RUSTSEC-`, `PYSEC-` and `GO-` pertain to the Rust, Python, and Go ecosystems,
respectively.

Julia's SecurityAdvisories.jl database exclusively issues `JLSEC-` identifiers,
with its advisories distributed in a standardized open source vulnerability
(OSV) schema. The `JLSEC-` prefix is officially supported as of osv-schema v1.7.4,
with tooling support to lint and validate our advisories, including checks to
ensure that they refer to a package (and version!) that is registered in General.

#### Redistribution on osv.dev

The [osv.dev] initiative aggregates together many open source advisory ecosystems
in one place. As a first-class OSV ecosystem, Julia's SecurityAdvisories.jl database
is now imported (and validated! and redistributed!) by osv.dev.  This simple integration
will hopefully facilitate further adoption by downstream tools that are already using
osv.dev as an advisory source.

#### Advisory publication and maintenance

The creation of advisories for package maintainers should be very straightforward:
you can either create a GHSA (which a GitHub action can then import), or you can
propose a new JLSEC advisory directly. See the repository's [CONTRIBUTING.md][SA-contrib]
for more details on advisory authorship.

### [GeneralMetadata.jl]: JLL and Artifact Component analysis

Remember that asterisk in the "no advisories against Julia packages" above? It's not
entirely true. The Julia package ecosystem consists of nearly 10,000 pure Julia
packages, but there are also about 1500 packages that _redistribute_ upstream
libraries _from other ecosystems_, mostly as "JLLs". While there hadn't been direct
advisories published against any of the pure Julia packages, many JLLs contain upstream
components that have themselves reported CVEs. The trouble is that a vulnerability
scanner won't know that, for example, [OpenBLAS_jll] v0.3.17+2 built and redistributed
the upstream OpenBLAS v0.3.17. Or more challenging, that [NetCDF_jll] v401.900.300+0 is
really `netcdf` v4.9.3. Or even more challenging, that [MbedTLS_jll] v2.28.1010+0 is
really `mbed_tls` v2.28.10 with _backported patches_ which address four CVEs that are
outstanding on that no-longer-maintained v2 series.

There are hundreds if not thousands of upstream advisories that also apply to JLLs.
SecurityAdvisories.jl can issue `JLSEC-` advisories to relay this information, but
we first must know what the upstream components _are_! This is the purview of the new
[GeneralMetadata.jl] repository in the JuliaRegistries org. It aims to automatically
(insofar as it is possible) identify which sources (and at which versions) were used
in the builing of all the JLLs.

Armed with this component information, GitHub actions on SecurityAdvisories.jl
can semi-automatically suggest the publication of such "relaying" advisories.

This is where there are many opportunities for improvement across three or four levels:
* Improve [BinaryBuilder.jl]'s ability to directly record this component information
* Improve [GeneralMetadata.jl]'s recording of historical JLL component data
* Improve [SecurityAdvisories.jl]'s automations to make it clearer when a proposed upstream advisory is correct
* Help review and maintain the proposed upstream advisories on SecurityAdvisories.jl

## Vulnerability scanning

With a first-class advisory database and SBOM support, we can now ask automated
vulnerability scanners to implement support for reporting on any outstanding
advisories against Julia packages. Or — in the case of an open source tool — we
can propose such changes ourselves. That's exactly what I've been doing with
[trivy]; they are close to merging a sequence of pull requests to enable this:

```txt
2025-11-13T17:04:35Z	INFO	[julia] Detecting vulnerabilities...
2025-11-13T17:04:35Z	WARN	Using severities from other vendors for some vulnerabilities. Read https://trivy.dev/dev/docs/scanner/vulnerability#severity-selection for details.

Report Summary

┌───────────────┬───────┬─────────────────┬─────────┐
│    Target     │ Type  │ Vulnerabilities │ Secrets │
├───────────────┼───────┼─────────────────┼─────────┤
│ Manifest.toml │ julia │        2        │    -    │
└───────────────┴───────┴─────────────────┴─────────┘
Legend:
- '-': Not scanned
- '0': Clean (no security findings detected)


Manifest.toml (julia)

Total: 2 (UNKNOWN: 1, LOW: 0, MEDIUM: 1, HIGH: 0, CRITICAL: 0)

┌─────────────┬────────────────┬──────────┬────────┬───────────────────┬───────────────┬──────────────────────────────────────────────────────────────┐
│   Library   │ Vulnerability  │ Severity │ Status │ Installed Version │ Fixed Version │                            Title                             │
├─────────────┼────────────────┼──────────┼────────┼───────────────────┼───────────────┼──────────────────────────────────────────────────────────────┤
│ HTTP        │ CVE-2025-61689 │ UNKNOWN  │ fixed  │ 1.10.17           │ 1.10.19       │ Header injection/Response splitting via header construction. │
│             │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2025-61689                   │
├─────────────┼────────────────┼──────────┤        ├───────────────────┼───────────────┼──────────────────────────────────────────────────────────────┤
│ MbedTLS_jll │ CVE-2025-27810 │ MEDIUM   │        │ 2.28.6+0          │ 2.28.10+0     │ Mbed TLS before 2.28.10 and 3.x before 3.6.3, in some cases  │
│             │                │          │        │                   │               │ of...                                                        │
│             │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2025-27810                   │
└─────────────┴────────────────┴──────────┴────────┴───────────────────┴───────────────┴──────────────────────────────────────────────────────────────┘
```

This is yet another place to get involved — trivy is just one tool and there are indeed many.

## GitHub Dependabot support

For both security and general maintenance, it's very helpful for packages to keep
their dependencies up to date. GitHub packages have long used a custom GitHub action,
CompatHelper.jl, but GitHub has first-class dependency management support through
dependabot. (**[@IanButterworth]**) spearheaded work with GitHub's dependabot team to add
beta support for Julia packages. Benefits over CompatHelper include: showing release
notes/changelogs for the new version in the PR, updating checked-in manifests and
warning when it cannot be updated, CI running automatically (without close-open),
not having to worry about workflows being silently turned off after a few months
of repo inactivity. And it should eventually integrate with the above security
advisory efforts. See [examples of PRs][dependabot-prs] and [example setups][dependabot-examples].
It is in a testing period and feedback would be much appreciated.

# Join us!

Lots has happened over the last six months, but there are many ways to get involved!
Don't hesitate to ask questions and join in on the slack channel, any of the above
repositories, or in our upcoming meeting!




[@SamuraiAku]: https://github.com/SamuraiAku
[@Octogonapus]: https://github.com/Octogonapus
[@IanButterworth]: https://github.com/IanButterworth
[@mbauman]: https://github.com/mbauman
[@aviks]: https://github.com/aviks

[#security-dev]: https://julialang.org/slack/
[PkgToSoftwareBOM.jl]: https://github.com/SamuraiAku/PkgToSoftwareBOM.jl
[SPDX.jl]: https://github.com/SamuraiAku/SPDX.jl

[purl-docs]: https://package-url.github.io/packageurl.org/docs/purl-spec/purl-spec-documentation
[purl-types]: https://package-url.github.io/packageurl.org/docs/purl-spec/purl-spec-purl-types#registered-purl-types
[packageurl-go]: https://github.com/package-url/packageurl-go
[packageurl-python]: https://github.com/package-url/packageurl-python
[purl-ask]: https://github.com/JuliaLang/SecurityAdvisories.jl/issues/145

[cve.org]: https://www.cve.org
[CVE-2025-52479]: https://nvd.nist.gov/vuln/detail/CVE-2025-52479
[CVE-2025-52483]: https://nvd.nist.gov/vuln/detail/CVE-2025-52483
[GHSA-4g68-4pxg-mw93]: https://github.com/JuliaWeb/HTTP.jl/security/advisories/GHSA-4g68-4pxg-mw93
[HTTP-security]: https://github.com/JuliaWeb/HTTP.jl/security
[trivy]: https://trivy.dev

[SecurityAdvisories.jl]: https://github.com/JuliaLang/SecurityAdvisories.jl
[SA-contrib]: https://github.com/JuliaLang/SecurityAdvisories.jl/blob/main/CONTRIBUTING.md
[osv.dev]: https://osv.dev
[OpenBLAS_jll]: https://github.com/JuliaBinaryWrappers/OpenBLAS_jll.jl
[NetCDF_jll]: https://github.com/JuliaBinaryWrappers/NetCDF_jll.jl
[MbedTLS_jll]: https://github.com/JuliaBinaryWrappers/MbedTLS_jll.jl
[GeneralMetadata.jl]: https://github.com/JuliaRegistries/GeneralMetadata.jl
[BinaryBuilder.jl]: https://github.com/JuliaPackaging/BinaryBuilder.jl
[dependabot-prs]: https://github.com/IanButterworth/CSV.jl/pull/6
[dependabot-examples]: https://github.com/IanButterworth/CSV.jl/blob/master/.github/dependabot.yml
