---
layout: post
title:  "GSoC 2017: Documentation Browser for Juno"
author: Sebastian Pfitzner
---

<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS_HTML"></script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
tex2jax: {
inlineMath: [ ['$','$'], ["\\(","\\)"] ],
displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
processEscapes: true,
processEnvironments: true
},
// Center justify equations in code and markdown cells. Elsewhere
// we use CSS to left justify single line equations in code cells.
displayAlign: 'center',
"HTML-CSS": {
styles: {'.MathJax_Display': {"margin": 0}},
linebreaks: { automatic: true }
}
});
</script>

The aim of this GSoC project is to provide a convenient way to access documentation in the
Juno IDE. Any work on this has to be on the Julia side (for getting the necessary
information by introspection) *and* on the Atom side (for presenting said information).

Most of the work on the Julia side went into a new package, [DocSeeker.jl](https://github.com/pfitzseb/DocSeeker.jl),
which implements all of the introspection necessary to get docstrings from installed packages;
a small shim in Atom.jl ([Atom.jl#99](https://github.com/JunoLab/Atom.jl/pull/99)) then
delegates any front end requests to that package.

The front end work is directly included in the Juno stack ([atom-julia-client#377](https://github.com/JunoLab/atom-julia-client/pull/377)
and [atom-ink#148](https://github.com/JunoLab/atom-ink/pull/148), to be precise), since it's pretty
fundamental IDE functionality.

## Backend: DocSeeker.jl
The two main challenges here are *collecting docstrings* and *filtering docstrings*, both in
the most performant and reliable manner possible.

### Collecting Information
DocSeeker.jl contains a function `alldocs()`, which will return information about all
symbols available in the current Julia session. Those symbols are easily found by recursing
through all currently loaded `Module`s and calling `Base.names()` on them. Additionally,
Julia's docsystem collects all symbols with attached docstrings, which can be easily retrieved.

All of that is pretty slow -- it takes on the order of half a second on my machine with a
couple of loaded packages (and returns information about ~13,000 symbols). At the same time
the available symbols don't change too often, so caching is a viable solution.

### Filtering
There are all sorts of possible options to consider when filtering and searching through the
symbols (and attached docstrings) returned by `alldocs`, but I've decided on a few that
turned out to be most important while testing:

  - Exported: Julia doesn't (yet) have a way to make certain symbols part of a module's
    public API, so I'm using the set of exported symbols instead.
  - Module: It's possible to search in a specified module, in all loaded modules or in all
    installed modules.
  - Search: Either in names only, or in names and docstrings.

That last point warrants some more information, because it's not as trivial as the other two
to get at least somewhat right. The basic problem here is a (fuzzy) full text search, which
is what each search engine out there in the depth of the internet tries to do. Naturally
there are quite a few (open source) implementations out there already: solr, lunr (which is
used by [docs.julialang.org](https://docs.julialang.org)), but also e.g. the FTS extension
for SQL and many more.

In the early days of the summer I was trying a couple of things to get this to work properly,
but shelling out to Java or JavaScript seemed like overkill for the problem at hand, while
SQL.jl was giving me quite a hard time *and* doesn't ship the FTS extension by default.

A custom implementation did not seem too hard at first, but requires a *good* scoring function
that, given a search query `needle`, maps a docstring to a number between 0 and 1:
$$
score: (needle,\\,docstr) \\mapsto [0, 1]
$$
At first I tried rolling my own string comparison function (with mixed success), but then I
stumbled upon the excellent [StringDistances.jl](https://github.com/matthieugomez/StringDistances.jl)
which does pretty much all I needed.

The scoring function is applied to all relevant symbols in a threaded loop (which gives a
free 1.5x speedup on my machine); afterwards all applicable filters are applied and the top
20 results are returned.

Filtering and searching takes about 0.1s on my machine, which means that it's almost negligible
compared to the time necessary for retrieving the docstrings.

## Frontend
Now that DocSeeker.jl has found the results we asked for, it's time to display them in an
appealing manner:
![search](/images/blog/2017-08-28-gsoc-docs-in-juno/search.png)

If you've used Juno before you may notice the much improved markdown rendering (which is of
course available all throughout Juno): There's syntax highlighting, LaTeX rendering and lots
of general improvements.

Apart from that the docpane UI shows most relevant information (type of the binding, defining
module, whether the binding is exported etc.); a click on the binding will take you to the
defining location and a click on the module will give some information on that. Links also
generally work fine (external ones will open in your default browser, while those defined with
Documenter.jl's `[link](@ref)` syntax will start a new search).

## Try it!
These features will have been integrated into Juno at the beginning of September 2017, so feel
free to try them!

## Acknowledgements
I'd like to thank Mike Innes for all the fruitful discussions about implementation and
functionality, as well as his guidance on Julia/Juno development in general (well before
GSoC even started).
