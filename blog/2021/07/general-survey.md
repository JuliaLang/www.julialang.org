@def title =  "Code, docs, and tests: what's in the General registry?"
@def authors = "Eric P. Hanson, Mosè Giordano"
@def published = "28 July 2021"
@def rss_pubdate = Date(2021, 7, 28)
@def rss = """Code, docs, and tests: what's in the General registry?"""

Julia users like to think the programming language they love is easy to use and
promotes good programming practices, like writing documentation, testing the
code and using continuous integration.  But... is that true?  In order to try
and answer this question and get more insights about the Julia ecosystem we
developed a package called
[`PackageAnalyzer.jl`](https://github.com/JuliaEcosystem/PackageAnalyzer.jl) and
over a 2-month period leading up to JuliaCon 2021 we used it to make a survey of
the packages in the [General](https://github.com/JuliaRegistries/General)
registry.  In this post we summaries the main findings we presented in our
[JuliaCon talk](https://youtu.be/9YWwiFbaRx8), which we recommend to watch for more details.

\toc

## Lines of code in General

We found that as of 2021-01-07 the packages in the General registry have a total
of 8,015,887 lines of Julia code in their `src` directories, and 11,777,430
lines of Julia code in package directories overall (including docs and tests).
Note that these figures include docstrings, because of a [bug in
Tokei](https://github.com/XAMPPRocky/tokei/issues/763), the software we used to
count the lines of code.

The following chart shows the distribution of packages by number of lines of
code, in semi-log scale: we can observe that the packages follow a log-normal
distribution, with a median of 507 lines.

![Distribution of packages by number of lines of code](/assets/blog/2021-07-general-survey/lines-of-code.png)

We also used [`WordCloud.jl`](https://github.com/guo-yong-zhi/WordCloud.jl) to
create a word cloud of the packages in the General registry by number of lines
and code.

![Word cloud of packages in the General registry by number of lines of code](/assets/blog/2021-07-general-survey/wordcloud.png)

The following table shows the 14 largest packages in the registry, by number of
lines of code in their `src` directories.  We should note that most of these
packages have their source code automatically generated from the API of the
external libraries or web services they wrap.

|                      name | Lines of Julia code in `src` |
|---------------------------|------------------------------|
|                    AWSSDK |                      264,115 |
|                       AWS |                      225,723 |
|                     Hecke |                      130,560 |
|                TensorFlow |                      115,544 |
|            OrdinaryDiffEq |                       92,308 |
|                       GSL |                       69,761 |
|                      DSGE |                       58,835 |
|            ClimateMachine |                       58,281 |
|                     Kuber |                       54,331 |
|          MathOptInterface |                       51,297 |
|                     Azure |                       44,766 |
|                      Nemo |                       41,377 |
|                     NIDAQ |                       40,913 |
| GlobalSensitivityAnalysis |                       40,719 |

This chart shows the distributions of languages used in the files present in the
`src` directories of packages: it was probably easy to guess that the most
popular language is Julia itself, by a very large factor, followed by
Javascript, JSON and Fortran.  However note that these figures don't capture
packages wrapping binary libraries using the so-called [JLL
packages](https://docs.binarybuilder.org/stable/jll/), as they would
automatically download pre-built copies of such libraries, without the need to
vendor their source code.

![Distribution of packages by number of lines of code](/assets/blog/2021-07-general-survey/lines-of-code-src.png)

## Licenses

While over 96% of packages in the General registry have licenses approved by the
[Open Source Initiative](https://opensource.org/licenses) (OSI), about 200
packages appear to not have any license at all, while 20 have a license which
isn't automatically detected as OSI-approved.

![Distribution of packages with OSI-approved licenses](/assets/blog/2021-07-general-survey/osi-licenses.png)

Julia's public package registries have long required OSI-approved licenses
(stretching back to [October 2015](https://github.com/JuliaLang/METADATA.jl/pull/3788)),
but this requirement was [not documented in the General registry README](https://github.com/JuliaRegistries/General/issues/24038)
for some time, and has only been
[automatically enforced since last March](https://discourse.julialang.org/t/fyi-the-general-registry-now-checks-for-an-osi-approved-software-license-when-registering-new-packages-and-new-versions/57018).
Now, any new package or new version of an already-registered package must have
an auto-detected OSI-approved license to get automatic approval for merging into
General.  Since the introduction of this automated
check, the fraction of packages with OSI-approved license has been steadily
increasing.

![Trend of fraction of packages with OSI-approved licenses over time](/assets/blog/2021-07-general-survey/osi-license-trend.png)

The MIT "Expat" license is by far the most popular in the Julia ecosystem,
likely due to the fact it's the license adopted by the source code of Julia
itself.  Other popular licenses include GPL (v3 or v3 and any later versions),
Apache 2.0 and the 3-clause BSD.

![Distribution of licenses used by packages in the General registry](/assets/blog/2021-07-general-survey/licenses-distribution.png)

## Documentation

If you want to let other people use your package, you likely want to document
it!  This usually comes in the form of some paragraphs in the README file, or a
dedicated manual written with the tools available to Julia users
(e.g. [`Documenter.jl`](https://github.com/JuliaDocs/Documenter.jl)).  About 88%
of the packages in General have either 20 lines in the README file or proper
documentation.

![Levels of documentation in General](/assets/blog/2021-07-general-survey/docs-readme.png)

The following chart shows the distribution of the percentage of docs in the
codebase of the repository, by computing the fraction of lines of code in the
`docs` directory over the total number of lines of code in the `docs` and `src`
directories.  Less than 50% of the packages have `Documenter.jl`-based
documentation in their repository.  Does this mean over half of Julia packages
are not documented?  Not necessarily: authors of very simple packages may
consider the `README` enough to describe the use of their package, and in some
cases the source code of the documentation may be hosted in a different
repository, which wouldn't be counted here.

![Distribution of docs as percentage of codebase](/assets/blog/2021-07-general-survey/fraction-docs.png)

## Testing

Testing is another important programming practice: it lets make sure the code
behave as expected and that bugs that have been fixed once aren't reintroduced by later changes.
Julia comes with the [`Test`](https://docs.julialang.org/en/v1/stdlib/Test/)
standard library.  Likely the fact that Julia comes with a built-in unit
testing framework encourages users to test their packages: over 96% of packages
in the General registry have the `test/runtests.jl` file, which is the entry
point for running the tests with Julia's the package manager.  If we consider
only packages with at least 10 lines of code in the `test` directory, to make
sure we exclude simple auto-generated files with no actual tests, the fraction
goes down to 89%.  In the following chart, the percentages ("10% tests", and
"20% tests") mean the number of lines of Julia code in `test` compared to the
number of lines of Julia code in `src` plus `test`.

![Fractions of packages with different levels of testing](/assets/blog/2021-07-general-survey/test-levels.png)

Similarly to what we have seen above for docs, the following chart shows the
distribution of the percentage of tests in the codebase of the repository, as
fraction of lines of code in the `tests` directory over the total number of
lines of code in the `tests` and `src` directories.  We can observe that the
level of testing is fairly high: 57% of packages have at least 20% of code as
tests, while 8% of packages have more lines of tests than of source code.

![Fractions of packages with different levels of testing](/assets/blog/2021-07-general-survey/fraction-tests.png)

## Continuous integration

Julia users seem to love [continuous
integration](https://en.wikipedia.org/wiki/Continuous_integration) (CI)!  A
staggering 95% of packages in the ecosystem are set up to use any continuous
integration service, with GitHub Action being the most popular service (80%),
followed by Travis (42%) and AppVeyor (13%).

![Distributions of continuous integration services](/assets/blog/2021-07-general-survey/fraction-ci.png)

We can take a look at the popularity of CI services over time: a common trend is
that GitHub Actions is taking over from Travis and Appveyor, which used to
be the main choice for Julia users to test their packages on the most popular
operating systems (Linux, macOS, Windows).  The decreasing trend for Travis has
been exacerbated last year when changes to their conditions made this service
less favourable to be used by open-source projects.

![Trend of popularity of CI services over time](/assets/blog/2021-07-general-survey/trend-ci.png)

## Contributors

As of 2021-06-27, at least 4931 different users contributed to Julia packages
hosted on GitHub, about 250 more compared to two months before.  Note that these
figures are conservative as they don't include contributors identified as
anonymous by GitHub API (for example because they committed changes using an
email address not registered in any GitHub account), or any contributions to
packages hosted on different websites, like GitLab.

![Trend of numbers of contributors](/assets/blog/2021-07-general-survey/trend-contributors.png)

The distribution of number of contributors to Julia packages presents a grim
picture: the vast majority of packages have a handful of contributors, with a median
of 2 contributors per package.  Only about 11% of packages have more than 10
contributors, and about 1% have more than 40.

![Distribution of numbers of contributors per package](/assets/blog/2021-07-general-survey/distribution-contributors.png)

![Reverse cumulative distribution of number of contributors per package](/assets/blog/2021-07-general-survey/rev-cdf-contributors.png)

<!-- The number of commits per package follow a log-normal distribution, with median -->
<!-- of 59 commits.  About 35% of packages have at least 100 commits, while 2% have -->
<!-- more than 1000. -->

<!-- ![Distribution of numbers of commits per package](/assets/blog/2021-07-general-survey/distribution-commits.png) -->

<!-- ![Reverse cumulative distribution of number of commits per package](/assets/blog/2021-07-general-survey/rev-cdf-commits.png) -->

It's also interesting to see how likely Julia users are to contribute to
multiple packages: 52% of users have contributed to a single package, a bit less than
10% contributed to at least 10 different packages, while 26 super active people
contributed to more than 100 packages.

![Reverse cumulative distribution of number of packages contributed to](/assets/blog/2021-07-general-survey/rev-cdf-contributed.png)

Finally, we looked at how many git commits users made: half of the community of
the developers of Julia packages have at least 10 commits, 21% have at least 100
commits, while 51 people made more than 2500 commits.

![Reverse cumulative distribution of number of commits per contributor](/assets/blog/2021-07-general-survey/rev-cdf-contributors-commits.png)
