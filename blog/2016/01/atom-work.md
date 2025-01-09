@def rss_pubdate = Date(2016, 1, 7)
@def rss_description = """ Julia IDE work in Atom | > A PL designer used to be able to design some syntax and semantics for their language, implement a compiler, and then call it a day. –  Sean McDirmid... """
@def published = "7 January 2016"
@def title = "Julia IDE work in Atom"
@def authors = "Mike Innes"

~~~
<div align="center"><img src="https://github.com/JunoLab/atom-ink/raw/readme/demos/full.gif" /></div>
~~~

> A PL designer used to be able to design some syntax and semantics for their language, implement a compiler, and then call it a day. –  Sean McDirmid

In the few years since its [initial release](/blog/2012/02/why-we-created-julia/), the Julia language has made wonderful progress. Over [four hundred contributors](https://github.com/JuliaLang/julia/graphs/contributors) – and counting – have donated their time developing exciting and modern language features like [channels](https://github.com/JuliaLang/julia/pull/12042) for concurrency, a [native documentation system](https://docs.julialang.org/en/v1/manual/documentation/), [staged functions](https://docs.julialang.org/en/v1/manual/metaprogramming/#generated-functions), [compiled packages](https://docs.julialang.org/en/v1/manual/modules/#), [threading](https://github.com/JuliaLang/julia/pull/13410), and tons more. In the lead up to 1.0 we have a faster and more stable runtime, a more comprehensive standard library, and a more enthusiastic community than ever before.

However, a programming language isn’t just a compiler or spec in a vacuum. More and more, the ecosystem around a language – the packages, tooling, and community that support you – are a huge determining factor in where a language can be used, and who it can be used by. Making Julia accessible to everybody means facing these issues head-on. In particular, we’ll be putting a lot of effort into building a comprehensive IDE, Juno, which supports users with features like smart autocompletion, plotting and data handling, interactive live coding and debugging, and more.

Julia users aren’t just programmers – they’re engineers, scientists, data mungers, financiers, statisticians, researchers, and many other things, so it’s vital that our IDE is flexible and extensible enough to support all their different workflows fluidly. At the same time, we want to avoid reinventing well-oiled wheels, and don’t want to compromise on the robust and powerful core editing experience that people have come to expect. Luckily enough, we think we can have our cake and eat it too by building on top of the excellent [Atom](https://atom.io/) editor.

The Atom community has done an amazing job of building an editor that’s powerful and flexible without sacrificing a pleasant and intuitive experience. Web technologies not only make hacking on the editor extremely accessible for new contributors, but also make it easy for us to experiment with exciting and modern features like live coding, making it a really promising option for our work.

Our immediate priorities will be to get basic interactive usage working really well, including strong multimedia support for display and graphics. Before long we’ll have a comprehensive IDE bundle which includes Juno, Julia, and a bunch of useful packages for things like plotting – with the aim that anyone can get going productively with Julia within a few minutes. Once the basics are in place, we’ll integrate the documentation system and the up-and-coming debugger, implement performance linting, and make sure that there’s help and tutorials in place so that it’s easy for everyone to get started.

Juno is implemented as a [large collection](https://github.com/JunoLab) of independent modules and plugins; although this adds some development overhead, we think it’s well worthwhile to make sure that other projects can benefit from our work. For example, our collection of IDE components for Atom, [Ink](https://github.com/JunoLab/atom-ink), is completely language-agnostic and should be reusable by other languages.

New contributions are always welcome, so if you’re interested in helping to push this exciting project forward, check out the [developer install instructions](https://github.com/JunoLab/atom-julia-client/tree/master/docs) and send us a PR!
