# README

This is the GitHub repository for the Julia Programming Language's main website, [julialang.org](https://julialang.org/).
The repository for the source code of the language itself can be found at [github.com/JuliaLang/julia](https://github.com/JuliaLang/julia).

The Julia website is generated using GitHub pages and [Franklin.jl](https://github.com/tlienart/Franklin.jl), a Julia native package for building static websites.


## Making Simple Changes

To suggest a change to the website, you can simply navigate to the page with the content you think should be changed, and edit it.
You will be prompted to fork the repo (if you haven't already) and then open a Pull Request.
Once your Pull Request is merged, you should see your changes show up on the website in a few minutes or less.

Build previews for each Pull Request will be linked in the comment section of the PR once the site has been successfully build.

**Note**: please only use _fenced_ code blocks (i.e. code blocks delimited by backticks) and not indented code blocks.

## Making More Complex Changes

To suggest a change to the website that is more significant, it is suggested that you make said changes and test them locally on your device.
You can do this by simply forking the base repo, cloning it locally onto your device, making the changes you want, and then following the "Installing locally" instructions below.

Once you have validated that everything looks good, you can open a Pull Request and check the Deploy Preview from Netlify as a final sanity check.

Build previews for each Pull Request are available at: https://julialang.netlify.app (note that given the GitHub Actions design, build previews are only available for those who have write access to the repo).

## Making modifications and seeing the changes locally

Clone the repository and `cd` to it. Start julia with `julia --project` and do

```julia
julia> using Pkg; Pkg.instantiate()

julia> using Franklin

julia> serve()
→ Initial full pass...
→ evaluating code [...] (learning/code-examples.md)
→ Starting the server...
✓ LiveServer listening on https://localhost:8000/ ...
  (use CTRL+C to shut down)
```

Navigate to `localhost:8000` in a browser and you should see a preview of any modifications you make locally.

**Modifying the CSS**: modify the relevant files in `_css/`.

**Modifying the HTML structure**: if you want to modify the navbar, or the footer, go to `_layout/` and modify the relevant template fragment.

**Modifying the landing page**: since the landing page has its own design, it is written in HTML with a few insertions of repurposeable fragments where appropriate, just modify `index.html`

## Adding a blog post

Follow the blueprint of the many other blog posts in terms of folder structure and file structure.
One important thing to bear in mind is that RSS is a bit picky in terms of what it can accept so be careful for what goes in

* `@def rss = ...`
* `@def title = ...`

In particular:

* avoid the use of `&`, for instance change `ML&PL` to `ML-PL`,
* only use plain text in `rss`, no links, no markup, no HTML entities.

If in doubt, after running Franklin's server, copy the content of `__site/feed.xml` into [the w3 feed validator](https://validator.w3.org/feed/check.cgi), it should show "Valid RSS feed".

### Metadata

In order to add `<meta aaa="bbb" content="ccc">` tags on your blog post, add

```julia
@def meta =[("aaa", "bbb", "ccc"),]
```

(you can specify multiple tags of course). See for instance [Keno's recent blog post](https://raw.githubusercontent.com/JuliaLang/www.julialang.org/master/blog/2020/05/rr.md).

## Looking for broken links

Every so often, one should do an in-depth check that there are no broken links.
While Franklin provides a quick way to do this, it's a good idea to this in depth from time to time.
The [broken-link-checker](https://github.com/stevenvachon/broken-link-checker) package is a pretty neat way to do this.
After installing it with `npm` just do

```
blc https://julialang.org -ro
```

(it takes a while, and may require you to do it in several steps).
