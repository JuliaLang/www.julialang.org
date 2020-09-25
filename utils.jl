using Dates

"""
    {{meta}}

Plug in specific meta information for a blog page. The `meta` local page
variable should be given as an iterable of 3-tuples like so:
```
@def meta = [("property", "og:video", "http://example.com/"),
             ("name", "twitter:player", "https://www.youtube.com/embed/XXXXXX")]
```
A full example can be found in `blog/2020/05/rr.md`.
"""
function hfun_meta()
    p = "property"
    # default og properties, can be overwritten by the user
    ogdflt = (
        title = (p, "og:title", "The Julia Language"),
        image = (p, "og:image", "/assets/images/julia-open-graph.png"),
        descr = (p, "og:description", "Official website for the Julia programming language"),
        )
    # check what the user has provided (if anything) use defaults otherwise
    meta = locvar(:meta)
    if !isnothing(meta)
        for c in keys(ogdflt)
            any(m -> m[2] == "og:$c", meta) || push!(meta, getindex(ogdflt, c))
        end
    else
        meta = values(ogdflt)
    end
    io = IOBuffer()
    for m in meta
        write(io, "<meta $(m[1])=\"$(m[2])\" content=\"$(m[3])\">\n")
    end
    return String(take!(io))
end


"""
    {{blogposts}}

Plug in the list of blog posts contained in the `/blog/` folder.
"""
function hfun_blogposts()
    curyear = year(Dates.today())
    io = IOBuffer()
    for year in curyear:-1:2012
        ys = "$year"
        year < curyear && write(io, "\n**$year**\n")
        for month in 12:-1:1
            ms = "0"^(month < 10) * "$month"
            base = joinpath("blog", ys, ms)
            isdir(base) || continue
            posts = filter!(p -> endswith(p, ".md"), readdir(base))
            days  = zeros(Int, length(posts))
            lines = Vector{String}(undef, length(posts))
            for (i, post) in enumerate(posts)
                ps  = splitext(post)[1]
                url = "/blog/$ys/$ms/$ps/"
                surl = strip(url, '/')
                title = pagevar(surl, :title)
                pubdate = pagevar(surl, :published)
                if isnothing(pubdate)
                    date    = "$ys-$ms-01"
                    days[i] = 1
                else
                    date    = Date(pubdate, dateformat"d U Y")
                    days[i] = day(date)
                end
                lines[i] = "\n[$title]($url) $date \n"
            end
            # sort by day
            foreach(line -> write(io, line), lines[sortperm(days, rev=true)])
        end
    end
    # markdown conversion adds `<p>` beginning and end but
    # we want to  avoid this to avoid an empty separator
    r = Franklin.fd2html(String(take!(io)), internal=true)
    return r
end

"""
    {{recentblogposts}}

Input the 3 latest blog posts.
"""
function hfun_recentblogposts()
    curyear = Dates.Year(Dates.today()).value
    ntofind = 3
    nfound  = 0
    recent  = Vector{Pair{String,Date}}(undef, ntofind)
    for year in curyear:-1:2019
        for month in 12:-1:1
            ms = "0"^(1-div(month, 10)) * "$month"
            base = joinpath("blog", "$year", "$ms")
            isdir(base) || continue
            posts = filter!(p -> endswith(p, ".md"), readdir(base))
            days  = zeros(Int, length(posts))
            surls = Vector{String}(undef, length(posts))
            for (i, post) in enumerate(posts)
                ps       = splitext(post)[1]
                surl     = "blog/$year/$ms/$ps"
                surls[i] = surl
                pubdate  = pagevar(surl, :published)
                days[i]  = isnothing(pubdate) ?
                                1 : day(Date(pubdate, dateformat"d U Y"))
            end
            # go over month post in antichronological orders
            sp = sortperm(days, rev=true)
            for (i, surl) in enumerate(surls[sp])
                recent[nfound + 1] = (surl => Date(year, month, days[sp[i]]))
                nfound += 1
                nfound == ntofind && break
            end
            nfound == ntofind && break
        end
        nfound == ntofind && break
    end
    #
    io = IOBuffer()
    for (surl, date) in recent
        url   = "/$surl/"
        title = pagevar(surl, :title)
        sdate = "$(day(date)) $(monthname(date)) $(year(date))"
        blurb = pagevar(surl, :rss)
        write(io, """
            <div class="col-lg-4 col-md-12 blog">
              <h3><a href="$url" class="title" data-proofer-ignore>$title</a>
              </h3><span class="article-date">$date</span>
              <p>$blurb</p>
            </div>
            """)
    end
    return String(take!(io))
end

"""
    {{redirect url}}

Creates a HTML layout for a redirect to `url`.
"""
function hfun_redirect(url)
    s = """
    <!-- REDIRECT -->
    <!doctype html>
    <html>
      <head>
        <meta http-equiv="refresh" content="0; url=$(url[1])">
      </head>
    </html>
    """
    return s
end
