# Theme: Web stack / networking improvements

Julia's web and higher level networking framework is largely consolidated within the [JuliaWeb](https://github.com/JuliaLang) github organization.

## HTTP2 Implementation

Add HTTP2 support to [HttpServer.jl](https://github.com/JuliaWeb/HttpServer.jl) and [Requests.jl](https://github.com/JuliaWeb/Requests.jl).

**Knowledge Prerequisites:** basic familiarity with HTTP

## Middlewares for common web application chores in Mux.jl

Implementation of mid-level features - specifically routing, load-balancing, cookie/session handling, and authentication - in [Mux.jl](https://github.com/JuliaWeb/Mux.jl).  The implementation should be extensible enough to allow easy interfacing with different kinds of caching, databases or authentication backends. (See [Clojure/Ring](https://github.com/ring-clojure/ring/wiki/Why-Use-Ring%3F) for inspiration)

**Expected Results:** Some experience with web development.
