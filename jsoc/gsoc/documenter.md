# Documentation tooling

## Documenter.jl

The Julia manual and the documentation for a large chunk of the ecosystem is generated using [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) -- essentially a static site generator that integrates with Julia and its docsystem. There are tons of opportunities for improvements for anyone interested in working on the interface of Julia, documentation and various front-end technologies (web, LaTeX).

* **ElasticSearch-based search backend for Documenter.** Loading the search page of Julia manual is slow because the index is huge and needs to be downloaded and constructed on the client side on every page load. Instead, we should look at hosting the search server-side. Goal is to continue the work done during a MLH fellowship for implementing an [ElasticSearch](https://www.elastic.co/)-based search backend.

* **Improve the generated PDF in the PDF/LaTeX backend.** The goals is to improve the look of the generated PDF and make sure backend works reliably (improved testing). See [#949](https://github.com/JuliaDocs/Documenter.jl/issues/949), [#1342](https://github.com/JuliaDocs/Documenter.jl/issues/1342) and [other related issues](https://github.com/JuliaDocs/Documenter.jl/labels/Format%3A%20LaTeX).

**Recommended skills:** Basic knowledge of web-development (JS, CSS, HTML) or LaTeX, depending on the project.

**Mentors:** [Morten Piibeleht](https://github.com/mortenpi)

## Docsystem API

Julia supports docstrings -- inline documentation which gets parsed together with the code and can be accessed dynamically in a Julia session (e.g. via the REPL `?>` help mode; implemented mostly in the [Docs module](https://github.com/JuliaLang/julia/tree/master/base/docs)).

Not all docstrings are created equal however. There are bugs in Julia's docsystem code, which means that some docstrings do not get stored or are stored with the wrong key (parametric methods). In addition, the API to fetch and work with docstrings programmatically is not documented, not considered public and could use some polishing.

@@tight-list
* Create a package which would provide a clean up the API for working with docstrings, and abstract away the implementation details (and potential differences between Julia versions) of the docsystem in Base.
* Fix as many docsystem-related bugs in the Julia core as possible [[further reading](http://mortenpi.eu/gsoc2019/latest/notes/docsystem-internals/#Docsystem-bugs-1), [#16730](https://github.com/JuliaLang/julia/issues/16730), [#29437](https://github.com/JuliaLang/julia/issues/29437), [JuliaDocs/Documenter.jl#558](https://github.com/JuliaDocs/Documenter.jl/issues/558)]
@@

**Recommended skills:** Basic familiarity with Julia is sufficient.

**Mentors:** [Morten Piibeleht](https://github.com/mortenpi)
