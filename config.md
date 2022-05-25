<!-- RSS parameters -->
@def generate_rss = true
@def website_title = "JuliaLang - The Julia programming language"
@def website_descr = "Official website for the Julia programming language."
@def website_url = get(ENV, "JULIA_FRANKLIN_WEBSITE_URL", "https://julialang.org/")
@def prepath = get(ENV, "JULIA_FRANKLIN_PREPATH", "")

<!-- NOTE: don't change what's below -->
@def div_content = "container main" <!-- instead of franklin-content -->
@def author = ""

<!-- Templating of the Downloads -->
@def stable_release = "1.7.3"
@def stable_release_short = "1.7"
@def stable_release_date = "May 6, 2022"
@def lts_release = "1.6.6"
@def lts_release_short = "1.6"
@def lts_release_date = "March 28, 2022"

<!-- plotly -->
@def hasplotly = false

<!--
If the following lines are commented, the "upcoming release" section
in `downloads/index.md` will not be shown.
-->
@def upcoming_release = "1.8.0-beta3"
@def upcoming_release_short = "1.8"
@def upcoming_release_date = "March 29, 2022"
