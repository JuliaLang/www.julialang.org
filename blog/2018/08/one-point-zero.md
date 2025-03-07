@def title = "Announcing the release of Julia 1.0"
@def authors = "Julia developers"
@def rss_pubdate = Date(2018, 8, 8)
@def rss_description = "Announcing the release of Julia 1.0. The much anticipated 1.0 release of Julia is the culmination of..."
@def published = "8 August 2018"

~~~
Translations: <a href="/blog/2018/08/one-point-zero-zh_cn/">Simplified Chinese</a>, <a href="/blog/2018/08/one-point-zero-zh_tw/">Traditional Chinese</a>, <a href="/blog/2018/08/one-point-zero-es/">Spanish</a>
~~~

The much anticipated 1.0 release of [Julia](https://julialang.org) is the culmination of
nearly a decade of work to build a language for greedy programmers. JuliaCon 2018
celebrated the event with a reception where the community officially [set the version to
1.0.0 together](https://www.youtube.com/watch?v=1jN5wKvN-Uk#t=3850). The release was accompanied by a
talk: [*A brief history and wild speculation about the future of Julia*](/assets/blog/2018-08-08-one-point-zero/release-1.0-keynote.pdf).

Julia was [first publicly announced](/blog/2012/02/why-we-created-julia) with a number of strong demands on the language:

> We want a language that’s open source, with a liberal license. We want the speed of C with
> the dynamism of Ruby. We want a language that’s homoiconic, with true macros like Lisp,
> but with obvious, familiar mathematical notation like Matlab. We want something as usable
> for general programming as Python, as easy for statistics as R, as natural for string
> processing as Perl, as powerful for linear algebra as Matlab, as good at gluing programs
> together as the shell. Something that is dirt simple to learn, yet keeps the most serious
> hackers happy. We want it interactive and we want it compiled.



A vibrant and thriving community has grown up around this language, with people from all
around the world iteratively refining and shaping Julia in pursuit of that goal. Over 700
people have contributed to Julia itself and even more people have made thousands of amazing
open source Julia packages. All told, we have built a language that is:

* **Fast**: Julia was designed from the beginning for high performance. Julia programs compile to efficient native code for multiple platforms via LLVM.
* **General**: It uses multiple dispatch as a paradigm, making it easy to express many object-oriented and functional programming patterns. The standard library provides asynchronous I/O, process control, logging, profiling, a package manager, and more.
* **Dynamic**: Julia is dynamically-typed, feels like a scripting language, and has good support for interactive use.
* **Technical**: It excels at numerical computing with a syntax that is great for math, many supported numeric data types, and parallelism out of the box. Julia's multiple dispatch is a natural fit for defining number and array-like data types.
* **Optionally typed**: Julia has a rich language of descriptive data types, and type declarations can be used to clarify and solidify programs.
* **Composable**: Julia’s packages naturally work well together. Matrices of unit quantities, or data table columns of currencies and colors, just work — and with good performance.

Try Julia by [downloading version 1.0 now](/downloads/). If you’re
upgrading code from Julia 0.6 or earlier, we encourage you to first use the transitional 0.7
release, which includes deprecation warnings to help guide you through the upgrade process.
Once your code is warning-free, you can change to 1.0 without any functional changes. The
registered packages are in the midst of taking advantage of this stepping stone and
releasing 1.0-compatible updates.


The single most significant new feature in Julia 1.0, of course, is a commitment to language
API stability: code you write for Julia 1.0 will continue to work in Julia 1.1, 1.2, etc.
The language is “fully baked.” The core language devs and community alike can focus on
packages, tools, and new features built upon this solid foundation.

But Julia 1.0 in not just about stability, it also introduces several new, powerful and
innovative language features. Some of the new features since version 0.6 include:

* A brand new built-in [package manager](https://docs.julialang.org/en/latest/stdlib/Pkg/) brings enormous performance improvements and makes it easier than ever to install packages and their dependencies. It also supports per-project package environments and recording the exact state of a working application to share with others—and with your future self. Finally, the redesign also introduces seamless support for private packages and package repositories. You can install and manage private packages with the same tools as you’re used to for the open source package ecosystem. The [presentation at JuliaCon](https://www.youtube.com/watch?v=GBi__3nF-rM) provides a good overview of the new design and behavior.
* Julia has a new [canonical representation for missing values](/blog/2018/06/missing). Being able to represent and work with missing data is fundamental to statistics and data science. In typical Julian fashion, the new solution is general, composable and high-performance. Any generic collection type can efficiently support missing values simply by allowing elements to include the pre-defined value `missing`. The performance of such “union-typed” collections would have been too slow in previous Julia versions, but compiler improvements now allow Julia to match the speed of custom C or C++ missing data representations in other systems, while also being far more general and flexible.
* The built-in `String` type can now safely hold arbitrary data. Your program won’t fail hours or days into a job because of a single stray byte of invalid Unicode. All string data is preserved while indicating which characters are valid or invalid, allowing your applications to safely and conveniently work with real world data with all of its inevitable imperfections.
* Broadcasting is already a core language feature with convenient syntax—and it’s now more powerful than ever. In Julia 1.0 it’s simple to [extend broadcasting to custom types](/blog/2018/05/extensible-broadcast-fusion) and implement efficient optimized computations on GPUs and other vectorized hardware, paving the way for even greater performance gains in the future.
* Named tuples are a new language feature which make representing and accessing data by name efficient and convenient. You can, for example, represent a row of data as `row = (name="Julia", version=v"1.0.0", releases=8)` and access the `version` column as `row.version` with the same performance as the less convenient `row[2]`.
* The dot operator can now be overloaded, allowing types to use the `obj.property` syntax for meanings other than getting and setting struct fields. This is especially useful for smoother interop with class-based languages such as Python and Java. Property accessor overloading also allows the syntax for getting a column of data to match named tuple syntax: you can write `table.version` to access the `version` column of a table just as `row.version` accesses the `version` field of a single row.
* Julia’s optimizer has gotten smarter in more ways than we can list here, but a few highlights are worth mentioning. The optimizer can now propagate constants through function calls, allowing much better dead-code elimination and static evaluation than before. The compiler is also much better at avoiding allocation of short-lived wrappers around long-lived objects, which frees programmers to use convenient high-level abstractions without performance costs.
* Parametric type constructors are now always called with the same syntax as they are declared. This eliminates an obscure but confusing corner of language syntax.
* The iteration protocol has been completely redesigned to make it easier to implement many kinds of iterables. Instead of defining methods of three different generic functions—`start`, `next`, `done`—one now defines one- and two-argument methods of the `iterate` function. This often allows iteration to be conveniently defined with a single definition with a default value for the start state. More importantly, it makes it possible to implement iterators that only know if they're done once they've tried and failed to produce a value. These kinds of iterators are ubiquitous in I/O, networking, and producer/consumer patterns; Julia can now express these iterators in a straightforward and correct manner.
* Scope rules have been simplified. Constructs that introduce local scopes now do so  consistently, regardless of whether a global binding for a name already exists or not. This eliminates the “soft/hard scope” distinction that previously existed and means that now Julia can always statically determine whether variables are local or global.
* The language itself is significantly leaner, with many components split out into “standard library” packages that ship with Julia but aren’t part of the “base” language. If you need them, they’re an import away (no installation required) but they’re no longer forced on you. In the future, this will also allow standard libraries to be versioned and upgraded independently of Julia itself, allowing them to evolve and improve at a faster rate.
* We’ve done a thorough review of all of Julia’s APIs to improve consistency and usability. Many obscure legacy names and inefficient programming patterns have been renamed or refactored to more elegantly match Julia's capabilities. This has prompted changes to make working with collections more consistent and coherent, to ensure that argument ordering follows a consistent standard throughout the language, and to incorporate (the now faster) keyword arguments into APIs where appropriate.
* A number of new external packages are being built specifically around the new capabilities of Julia 1.0. For example:
  * The data processing and manipulation ecosystem is being revamped to take advantage of the new missingness support.
  * [Cassette.jl](https://github.com/jrevels/Cassette.jl) provides a powerful mechanism to inject code-transformation passes into Julia’s compiler, enabling post-hoc analysis and extension of existing code. Beyond instrumentation for programmers like profiling and debugging, this can even implement automatic differentiation for machine learning tasks.
  * Heterogeneous architecture support has been greatly improved and is further decoupled from the internals of the Julia compiler. Intel KNLs just work in Julia. Nvidia GPUs are programmed using the [CUDANative.jl](https://github.com/JuliaGPU/CUDAnative.jl) package, and a port to Google TPUs is in the works.



There are countless other improvements, both large and small. For a complete list of
changes, see the [0.7 NEWS file](https://github.com/JuliaLang/julia/blob/release-0.7/NEWS.md). In our original [“Why We Created Julia” blog post](/blog/2012/02/why-we-created-julia) in 2012, we wrote

> It’s not complete, but it’s time for a 1.0 release—the language we’ve created is called
> [Julia](https://julialang.org).

We may have jumped the gun a bit with mentioning an impending 1.0 release, but the time has
finally arrived and it is a heck of a release. We are truly proud of what’s been accomplished by the thousands of people who have contributed in so many ways to this truly
modern language for numerical and general programming.
