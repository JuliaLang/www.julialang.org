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
    io = IOBuffer()
    for year in 2020:-1:2012
        ys = "$year"
        write(io, "\n**$year**\n")
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
    return Franklin.fd2html(String(take!(io)), internal=true)
end
