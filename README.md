This is the GitHub repository for the Julia programming language project's main website, [julialang.org](http://julialang.org/). The repository for the source code of the language itself can be found at [github.com/JuliaLang/julia](https://github.com/JuliaLang/julia).

Julia Website is generated using GitHub pages and Jekyll, [explained here](https://help.github.com/articles/using-jekyll-with-pages).

In short, be sure you have ruby installed, and then run these commands

    gem install bundler

to install bundler, run

    bundle install

from the root of this repository to fetch all dependencies. You only have to do this once.

Now you can run

    bundle exec jekyll serve

in the root of this repository to serve it, usually on [http://localhost:4000](http://localhost:4000).

You can then edit the sources and Jekyll will rebuild changed files. To see changes reload the page
you edited.
