# Readme.md

This is an attempt at copying [https://julialang.org]() using Franklin.jl.

## How to maintain this

Clone the repository, `cd` to it, and, in Julia, assuming you have Franklin do
`using Franklin; serve()` then go to `localhost:8000` on your browser and edit
away.

## Link checks

* [x] page `/benchmarks/` is missing
* subpagees of downloads:
  * [x] https://julialang.org/downloads/platform/
  * [x] https://julialang.org/downloads/oldreleases/
  * [x] https://julialang.org/downloads/nightlies/
* other subpages
  * [x] https://julialang.org/learning/getting-started/
  * [x] https://julialang.org/jsoc/archive/
  * [x] https://julialang.org/jsoc/guidelines/
  * [x] https://julialang.org/jsoc/projects/
* [x] pages  `projects/` `guidelines/` `archives/`
* 2019 multithreading blog needs checks
* [x] fix ico

find and fix https://julialang.org/


Looking at github directly

* [x] teaching (part of learning)
* [x] ideas page, redirect --> jsoc
* [x] research (note, not using the bibtex-like files)
* [x] project (orphan page??)
* [x] manual --> redirect to docs (note: not added)
* [x] license --> redirect to julia license (note, not linked to.)
* [x] community/standards -- https://julialang.org/community/standards/
* [x] community/stewards -- https://julialang.org/community/stewards/
* [x] diversity -- https://julialang.org/diversity/
* [x] download --> redirect to downloads (note, not linked to)
* [x] ecosystems --> seems superseded by community (not linked to)
* [x] code examples --> note: not linked to
* [x] jscoc/gsod/projects --> https://julialang.org/jsoc/gsod/projects/ (not linked to?)
* [x] jsoc/gsoc/* --> https://github.com/JuliaLang/www.julialang.org/tree/master/content/jsoc/gsoc , probably use a grid like for blog posts


Unclear

* [ ] utf8proc


* link issues on blog 2015-10-22 (gist missing)


## Notes

**todo**
* nightlies page [this one](https://julialang.org/downloads/nightlies)
* old release page [this one](https://julialang.org/downloads/oldreleases)
* diversity page [this one](https://julialang.org/diversity)
* fixed assets like [this one](https://julialang.org/images/2019-julia-user-developer-survey.pdf)
* lazy subpages (copy-paste html)
* some internal links may be erroneous (H* links are slightly different now)
* some  links with `julialang` in them link should be fixed
* some leftover `{{page.manurl}}` or related
* [x] styling on blog page to have dates on other line
* [x] add link to Franklin in footer

**notes**

* dumped a bunch of `<head>...</head>` statement (index.html)
* ~~need to check the scripts, put the relevant assets (e.g. bootstrap) in appropriate places~~
* ~~check index html then other~~
