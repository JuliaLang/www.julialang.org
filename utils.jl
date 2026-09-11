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
    title = locvar(:title)
    isnothing(title) && (title = "The Julia Language")
    descr = locvar(:rss)
    isnothing(descr) && (descr = "Official website for the Julia programming language")
    p = "property"
    # default og properties, can be overwritten by the user
    ogdflt = (
        title = (p, "og:title", title),
        descr = (p, "og:description", descr),
        image = (p, "og:image", "/assets/images/julia-open-graph.png"),
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
				title === nothing && (title = "Untitled")
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
		title === nothing && (title = "Untitled")
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

function get_author_twitter()
    meta = locvar(:meta)
    if meta !== nothing
        for (kind, tag, value) in meta
            if kind == "name" && tag == "twitter:creator:id"
                return "https://twitter.com/intent/user?user_id=$value"
            end
        end
    end
    return ""
end

"""
    {{author_twitter}}
"""
function hfun_author_twitter()
    url = get_author_twitter()
    isempty(url) && return ""
    return "<a href=\"$url\"><img src=\"/assets/infra/twitter.svg\"/ width=\"22px\" height=\"22px\" style=\"margin-left:2px\"></a>"
end

"""
    {{about_the_author}}
"""
function hfun_about_the_author()
	# verify that author_img and author_blurb are given
    any(isnothing ∘ locvar, (:author_img, :author_blurb)) && return ""
	img = "/assets/$(locvar(:author_img))"

	twitter = get_author_twitter()
    social = ""
    if !isempty(twitter)
        social *= """
                  <li class="author-social-link-twitter">
                    <a href=\"$twitter\"><i class="fa fa-twitter"></i></a>
                  </li>
                  """
    end

	html = """
		<div class="author-info">
          <img src="$img" class="author-img" alt="$(locvar(:author))" width="150px">
		  <h3>$(locvar(:author))</h3>
		  <div class="author-description">
		    $(locvar(:author_blurb))
		  </div>
          <div class="author-social">
            <ul class="author-social-icons">
            $social
            </ul>
		  </div>
		</div>
		"""
    return html
end

function hfun_all_gsoc_projects()
	base_dir = joinpath("jsoc", "gsoc")
	all_projects = readdir(base_dir)
	md = IOBuffer()
	for project in all_projects
		project in ("general.md", "tooling.md", "graphics.md") && continue
		endswith(project, ".md") || continue
		write(md, read(joinpath(base_dir, project)))
		write(md, "\n\n")
	end
	allmd = String(take!(md))
	return fd2html(allmd, internal=true)
end
