# Documentation tooling

## Documenter.jl

The Julia manual and the documentation for a large chunk of the ecosystem is generated using [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) -- essentially a static site generator that integrates with Julia and its docsystem. There are tons of opportunities for improvements for anyone interested in working on the interface of Julia, documentation and various front-end technologies (web, LaTeX).

* **ElasticSearch-based search backend for Documenter.** (350 hours) Loading the search page of Julia manual is slow because the index is huge and needs to be downloaded and constructed on the client side on every page load (currently implemented with [lunr.js](https://lunrjs.com/)). Instead, we should look at hosting the search server-side. The goal is to implement an [ElasticSearch](https://www.elastic.co/)-based search backend for Documenter.

**Recommended skills:** Basic knowledge of web-development (JS, CSS, HTML).

**Mentors:** [Morten Piibeleht](https://github.com/mortenpi)
