+++
mintoclevel = 2
maxtoclevel = 3
title = "Launching the Julia Security Working Group"
authors = "Matt Bauman (JuliaHub)"
published = "23 November 2025"
rss_pubdate = Date(2025, 11, 23)
rss = """Launching the Julia Security Working Group"""
+++

There's been a lot of security work in the Julia ecosystem recently, and those of us pushing
on this effort have informally self-organized around a slack channel (`#security-dev`) and a
handful of repositories and pull requests. We are past due in officially organizing our efforts
into a working group! With this blog post, we are announcing the creation of the Julia Security
Working Group (JLSEC): an official community effort to improve the security tooling of the
Julia package ecosystem.

Join us! We'll have our inaugural working group call on Friday, December 5 at noon
US Eastern. One of the first orders of business will be establishing a regular
(every-other-week) standing meeting, so if you'd like to join but that time doesn't
generally work for you, drop by the [Slack #security-dev channel][#security-dev] and
let us know!

This is also a great opportunity to gather together all the work we have already done
to help catalyze this working group. It helps describe the scope and (even better!)
points to some of the many places where folks — you! — can look to get involved.

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
- `pkg:julia/HTTP?uuid=cd3eb016-35fb-5094-929b-558a96fad6f3`
or even with a version like:
- `pkg:julia/HTTP@1.10.16&uuid=cd3eb016-35fb-5094-929b-558a96fad6f3`

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

Prior to June (2025), there simply weren't any advisories for any Julia package.
This didn't mean there _weren't issues!_ We filed the first advisories against
a handful of packages as GitHub Security Advisories on their repository security
pages, thanks in part to [JuliaHub's security program][trust.juliahub.com] and
Avik Sengupta (**[@aviks]**). For example,
the [security tab on HTTP.jl][HTTP-security] now lists multiple advisories like
[GHSA-4g68-4pxg-mw93]. Those `GHSA-` identifiers act like CVEs, but they are issued
directly by GitHub. The HTTP.jl maintainers then asked GitHub support to review
these particular issues and — as GitHub is a CVE naming authority — issue a
corresponding CVE identifier (as an _alias_): [CVE-2025-52479].

Now put yourselves in the shoes of an automated vulnerability scanner. You
have an SBOM that has includes Julia's HTTP package at version v1.10.15. How do
you connect _either_ that CVE or the GHSA to Julia's package? The CVE doesn't
have structured package/version data, and _neither_ the GHSA nor the CVE appear in
GitHub's global advisory database. You'd have to scan the security pages of all
10,000 packages or do NLP/LLM processing of the hundreds of thousands of CVEs
to piece this together!

This is precisely one of the reasons behind:

### The SecurityAdvisories.jl database

Prior to these recent efforts, we were unable to issue or even gather together such
Julia package advisories. Having a dedicated database of advisories allows our package
ecosystem to more effectively participate in the global advisory universe:
* It enables the direct authorshop and publication of Julia-related advisories with
  well-defined semantics around its package and version data. There are many limitations
  with using the existing multi-ecosystem databases:
    * CVEs don't (natively) have structured package/version data and publications are gated
      by registered CVE Naming Authorities (CNAs). The "enrichment" of CVEs with structured
      package/version information is opaque, gated, and often proprietary.
    * GitHub-based packages can issue _repository_ GHSAs, and GitHub can act as a CNA and
      assign CVE aliases (as was done for HTTP.jl above), but Julia is not (yet) an officially
      supported ecosystem for GitHub's _global_ database. That's why the HTTP advisories
      don't show up there; they aren't even _fetchable_ by their ID alone. It'd be great to
      someday be an official ecosystem, but we also have many registered packages that are
      not GitHub-hosted; these too may need to issue advisories.
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

The [SecurityAdvisories.jl] database exclusively issues advisories with our own
dedicated `JLSEC-*` identifiers and structures them according to the standardized
[Open Source Vulnerability (OSV) schema][osv-schema]. The `JLSEC-` prefix is officially
registered and supported as of osv-schema v1.7.4, with tooling support to lint and
validate our advisories, including checks to ensure that they refer to a package
(and version!) that is registered in General.

#### Redistribution on osv.dev

The [osv.dev] initiative aggregates together many open source advisory ecosystems
in one place. As an OSV-native advisory database, SecurityAdvisories.jl fits right in!
The Julia ecosystem advisories are now imported (and validated! and redistributed!)
by osv.dev. This simple integration will hopefully facilitate further adoption by
downstream tools that are already using osv.dev as an advisory source.

#### Advisory publication and maintenance

The creation of advisories for package maintainers should be very straightforward:
you can either create a GHSA (which a GitHub action can then import), or you can
propose a new JLSEC advisory directly. See the repository's [CONTRIBUTING.md][SA-contrib]
for more details on advisory authorship.

### GeneralMetadata.jl: JLL and Artifact Component analysis

While there weren't advisories published against any _Julia_ packages prior to June
2025, there are many software libraries and executables from _other language ecosystems_
that we rely upon. These pre-built binaries are provided as **Artifacts** that the
package manager knows how to download, most commonly as dedicated packages themselves
known as ["JLLs"][binarybuilder.org]. There are over 1500 of these JLLs in the General
registry, and each provides and redistributes an upstream component — something that may
itself have published a security advisory. The trouble is that a vulnerability
scanner won't know that, for example, [OpenBLAS\_jll][OpenBLAS-jll] v0.3.17+2 built and redistributed
the upstream [`OpenBLAS`] v0.3.17. Or more challenging, that [NetCDF\_jll][NetCDF-jll] v401.900.300+0 is
really [`netcdf`] v4.9.3. Or even more challenging, that [MbedTLS\_jll][MbedTLS-jll] v2.28.1010+0 is
really [`mbed-tls`] v2.28.10 with _backported security patches_ to address four CVEs that were
still outstanding on that no-longer-maintained and end-of-life v2 series.

There are hundreds if not thousands of upstream advisories that also apply to JLLs.
SecurityAdvisories.jl can issue `JLSEC-` advisories to relay this information, but
we first must know what the upstream components _are_! This is the purview of the new
[GeneralMetadata.jl] repository in the JuliaRegistries org. It aims to automatically
(insofar as it is possible) identify what sources and which versions were used in the
building of all the registered JLLs.

Armed with this component information, GitHub actions on SecurityAdvisories.jl
can semi-automatically suggest the publication of such "relaying" advisories.

This is where there are many opportunities for improvement across three or four levels:
* Improve [BinaryBuilder.jl]'s ability to directly record this component information
* Improve [GeneralMetadata.jl]'s recording of the historical (JLL) component data, enable arbitrary (non-JLL) artifact tracking, and even add component licensing information
* Improve [SecurityAdvisories.jl]'s automations to make it clearer when a proposed upstream advisory is correct
* Help review and maintain the proposed upstream advisories on SecurityAdvisories.jl

## Vulnerability scanning

With a first-class advisory database and SBOM support, we can now ask automated
vulnerability scanners to implement support for reporting on any outstanding
advisories against Julia packages. Or — in the case of an open source tool — we
can propose such changes ourselves. That's exactly what I've been doing with
[trivy]; they are close to merging a sequence of my pull requests that enable
adding vulnerability information in its SBOMs and reports like this:

```txt
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
CompatHelper.jl, but GitHub itself has first-class dependency management support through
dependabot for some package ecosystems. (**[@IanButterworth]**) spearheaded work with
GitHub's dependabot team to add beta support for Julia packages. Some benefits over CompatHelper
include: showing release notes/changelogs for the new version in the PR, updating checked-in
manifests and warning when it cannot be updated, CI running automatically (without close-open),
and not having to worry about workflows being silently turned off after a few months
of repo inactivity. We hope for it to eventually integrate with the above security advisory
efforts to power security updates, too. See [examples of PRs][dependabot-prs] and
[example setups][dependabot-examples]. It is in a testing period and feedback would be much appreciated.

# Join us!

What I've listed here is far from a complete roundup of all the recent security work
around the Julia ecosystem, and that's precisely one of the reasons for forming this
working group. If any of these efforts (or even better: a security effort I haven't
mentioned here) match up with work you've been doing or are interested in doing, please
join us! The inaugural call on Friday December 5 will be geared towards scoping some of
the ongoing efforts and priorities of the group, and we'll continue many more discussions
on [slack][#security-dev]. Don't hesitate to share your ideas, ask questions, and pitch in!



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

[trust.juliahub.com]: https://trust.juliahub.com
[cve.org]: https://www.cve.org
[CVE-2025-52479]: https://nvd.nist.gov/vuln/detail/CVE-2025-52479
[CVE-2025-52483]: https://nvd.nist.gov/vuln/detail/CVE-2025-52483
[GHSA-4g68-4pxg-mw93]: https://github.com/JuliaWeb/HTTP.jl/security/advisories/GHSA-4g68-4pxg-mw93
[HTTP-security]: https://github.com/JuliaWeb/HTTP.jl/security
[trivy]: https://trivy.dev

[SecurityAdvisories.jl]: https://github.com/JuliaLang/SecurityAdvisories.jl
[SA-contrib]: https://github.com/JuliaLang/SecurityAdvisories.jl/blob/main/CONTRIBUTING.md
[osv-schema]: https://ossf.github.io/osv-schema/
[osv.dev]: https://osv.dev
[OpenBLAS-jll]: https://github.com/JuliaBinaryWrappers/OpenBLAS_jll.jl
[NetCDF-jll]: https://github.com/JuliaBinaryWrappers/NetCDF_jll.jl
[MbedTLS-jll]: https://github.com/JuliaBinaryWrappers/MbedTLS_jll.jl
[`OpenBLAS`]: http://www.openmathlib.org/OpenBLAS/docs/
[`netcdf`]: https://www.unidata.ucar.edu/software/netcdf
[`mbed-tls`]: https://mbed-tls.readthedocs.io/en/latest/
[GeneralMetadata.jl]: https://github.com/JuliaRegistries/GeneralMetadata.jl
[BinaryBuilder.jl]: https://github.com/JuliaPackaging/BinaryBuilder.jl
[binarybuilder.org]: https://binarybuilder.org
[dependabot-prs]: https://github.com/IanButterworth/CSV.jl/pull/6
[dependabot-examples]: https://github.com/IanButterworth/CSV.jl/blob/master/.github/dependabot.yml
