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
stable_release = "1.9.0"
stable_release_short = "1.9"
stable_release_date = "May 7, 2023"
lts_release = "1.6.7"
lts_release_short = "1.6"
lts_release_date = "July 19, 2022"

# plotly
hasplotly = false

# If the following lines are commented, the "upcoming release" section
# in `downloads/index.md` will not be shown.
#upcoming_release = "1.9.0-rc3"
#upcoming_release_short = "1.9"
#upcoming_release_date = "April 26, 2023"
+++
