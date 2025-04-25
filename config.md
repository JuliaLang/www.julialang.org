+++
# RSS parameters
generate_rss = true
website_title = "JuliaLang - The Julia programming language"
website_descr = "Official website for the Julia programming language."
website_url = get(ENV, "JULIA_FRANKLIN_WEBSITE_URL", "https://julialang.org/")
prepath = get(ENV, "JULIA_FRANKLIN_PREPATH", "")

# NOTE: don't change what's below
div_content = "container main"  # instead of franklin-content
author = ""

# Templating of the Downloads
# NOTE: When updating for a new release, make sure to also rerun
# `downloads/oldreleases.jl`
stable_release = "1.11.5"
stable_release_short = "1.11"
stable_release_date = "April 4, 2025"
lts_release = "1.10.9"
lts_release_short = "1.10"
lts_release_date = "March 10, 2025"

# plotly
hasplotly = false

# If the following lines are commented, the "upcoming release" section
# in `downloads/index.md` will not be shown.
upcoming_release = "1.12.0-beta2"
upcoming_release_short = "1.12"
upcoming_release_date = "April 25, 2025"
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\note}[2]{
@@admonition-note
@@admonition-title Note #1 @@
@@admonition-body #2 @@
@@
}

\newcommand{\warn}[2]{
@@admonition-warn
@@admonition-title Warning #1 @@
@@admonition-body #2 @@
@@
}
