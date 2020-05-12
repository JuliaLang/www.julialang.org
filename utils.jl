using Dates

"""
    {{meta}}

Plug in specific meta information for a blog page. The `meta` local page
variable should be given as a list of tuples of pairs like so:
```
@def meta = [("property"=>"og:video", "content"=>"http://example.com/"),
             ("propery"=>"og:title", "content"=>"The Rock")]
```
"""
function hfun_meta()
    m = locvar(:meta)
    io = IOBuffer()
    for tuple in locvar(:meta)
        write(io, "<meta ")
        for (prop, val) in tuple
            write(io, "$prop=\"$val\" ")
        end
        write(io, ">")
    end
    return String(take!(io))
end


"""
    {{blogposts}}

Plug in the list of blog posts contained in the `/blog/` folder.
"""
function hfun_blogposts()
    curyear = Dates.Year(Dates.today()).value
    io = IOBuffer()
    for year in curyear:-1:2012
        ys = "$year"
        year < curyear && write(io, "\n**$year**\n")
        for month in 12:-1:1
            ms = "0"^(1-div(month, 10)) * "$month"
            base = joinpath("blog", ys, ms)
            isdir(base) || continue
            posts = filter!(p -> endswith(p, ".md"), readdir(base))
            for post in posts
                ps  = splitext(post)[1]
                url = "/blog/$ys/$ms/$ps/"
                surl = strip(url, '/')
                title = pagevar(surl, :title)
                pubdate = pagevar(surl, :published)
                if isnothing(pubdate)
                    date = "$ys-$ms-10"
                else
                    date = Date(pubdate, dateformat"d U Y")
                end
                write(io, "\n[$title]($url) $date \n")
            end
        end
    end
    # markdown conversion adds `<p>` beginning and end but
    # we want to  avoid this to avoid an empty separator
    r = Franklin.fd2html(String(take!(io)), internal=true)
    startswith(r, "<p>")    && (r = chop(r, head=3))
    endswith(r,   "</p>")   && return chop(r, tail=4)
    endswith(r,   "</p>\n") && return chop(r, tail=5)
    return r
end
