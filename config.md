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
ignore = ["visual-tests/"]

# Templating of the Downloads
# NOTE: When updating for a new release, make sure to also rerun
# `downloads/oldreleases.jl`
stable_release = "1.13.3"
stable_release_short = "1.13"
stable_release_date = "October 25, 2026"
lts_release = "1.10.12"
lts_release_short = "1.10"
lts_release_date = "August 16, 2026"

# plotly
hasplotly = false

# map (leaflet)
hasmap = false

# If the following lines are commented, the "upcoming release" section
# in `downloads/index.md` will not be shown.
upcoming_release = "1.14.0-alpha2"
upcoming_release_short = "1.14"
upcoming_release_date = "October 26, 2026"
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\note}[2]{
@@admonition-note
@@admonition-title Note: #1 @@
@@admonition-body #2 @@
@@
}

\newcommand{\warn}[2]{
@@admonition-warn
@@admonition-title Warning: #1 @@
@@admonition-body #2 @@
@@
}
