This is the GitHub repository for the Julia programming language project's main website, [julialang.org](http://julialang.org/). The repository for the source code of the language itself can be found at [github.com/JuliaLang/julia](https://github.com/JuliaLang/julia).

The Julia website is generated using GitHub pages and Jekyll, as [explained here](https://help.github.com/articles/using-jekyll-with-pages).

## Running using Docker

After installing [`docker`](http://docker.com/), run `make run` to build and run the website within the a container built from the [`jekyll/jekyll` image](https://hub.docker.com/r/jekyll/jekyll/) that contains all the necessary prerequisites.  Modifying files will cause the website to rebuild in real time.

## Installing locally with RVM

    # gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB # if next line fails, it'll tell you to do this first
    curl -L get.rvm.io | bash -s stable --ruby # install rvm and ruby to $HOME
    . ~/.profile # pick up rvm binary
    echo www.julialang.org > .ruby-gemset # define a new gemset
    cd . # make the gemset active
    bundler update
    # jekyll serve --incremental -H 0.0.0.0 -P 4000 -l --future --unpublished --drafts
    jekyll serve --future


If installing on macOS, you may need to have MacPorts or Homebrew installed first, and it still might not work at all, so YMMV.
Also, it'll apparently break stuff if you previously used rb-env, so buyer-beware (https://github.com/rbenv/rbenv#how-it-works).

## Installing globally, manually

In short, be sure you have ruby installed, and then run these commands

    gem install bundler

to install bundler, run

    bundle install

from the root of this repository to fetch all dependencies. You only have to do this once.

Now you can run

    bundle exec jekyll serve

in the root of this repository to serve it, usually on [http://localhost:4000](http://localhost:4000).

You can then edit the sources and Jekyll will rebuild changed files. To see
changes, reload the page you edited.
