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
    descr = locvar(:rss_description)
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
                # Franklin.pagevar appears to be an internal function that has a guard against
                # recursive overflow so we need to reset the counter to 0, otherwise we cannot read
                # pagevars for all pages.
                Franklin.PAGEVAR_DEPTH[] = 0
                title = pagevar(surl, :title; default="Untitled")
                Franklin.PAGEVAR_DEPTH[] = 0
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
                Franklin.PAGEVAR_DEPTH[] = 0
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
        Franklin.PAGEVAR_DEPTH[] = 0
        title = pagevar(surl, :title)
		title === nothing && (title = "Untitled")
        sdate = "$(day(date)) $(monthname(date)) $(year(date))"
        Franklin.PAGEVAR_DEPTH[] = 0
        blurb = pagevar(surl, :rss_description)
        blurb = blurb === nothing ? "" : "<p>$blurb</p>"
        write(io, """
            <div class="col-lg-4 col-md-12 blog">
              <h3><a href="$url" class="title" data-proofer-ignore>$title</a>
              </h3><span class="article-date">$sdate</span>
              $blurb
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

"""
    {{article_schema}}

Generate a JSON-LD `BlogPosting` structured data block for blog posts.
See https://developers.google.com/search/docs/data-types/article
"""
function hfun_article_schema()
    title = locvar(:title)
    isnothing(title) && return ""
    descr = locvar(:rss_description)
    isnothing(descr) && (descr = locvar(:rss))
    isnothing(descr) && (descr = "")
    descr = strip(descr)

    # Parse the published date into ISO 8601
    pubdate_str = locvar(:published)
    isnothing(pubdate_str) && return ""
    date_iso = try
        Dates.format(Date(pubdate_str, dateformat"d U Y"), "yyyy-mm-dd") * "T00:00:00+00:00"
    catch
        return ""
    end

    # Get image URL from meta or use default
    image_url = "/assets/images/julia-open-graph.png"
    meta = locvar(:meta)
    if !isnothing(meta)
        for m in meta
            if m[2] == "og:image"
                image_url = m[3]
                break
            end
        end
    end
    # Resolve {{base}} if present (some posts use a `base` page variable in meta values)
    base = locvar(:base)
    if !isnothing(base)
        image_url = replace(image_url, "{{base}}" => base)
    end

    # Strip HTML tags from a string (some older posts have <a> links in author)
    striptags(s) = replace(s, r"<[^>]*>" => "")

    # Parse author entries, extracting name and optional URL from <a> tags.
    # Returns a vector of (name, url_or_nothing) tuples.
    function parse_authors(raw)
        entries = Tuple{String,Union{String,Nothing}}[]
        # Split on comma or " and " (but not inside tags)
        for part in split(raw, r"\s*,\s*|\s+and\s+")
            part = strip(part)
            isempty(part) && continue
            # Try to extract href and link text from <a> tag
            m = match(r"<a\s+href=\"([^\"]+)\"[^>]*>([^<]+)</a>", part)
            if m !== nothing
                push!(entries, (strip(m[2]), strip(m[1])))
            else
                name = strip(striptags(part))
                isempty(name) || push!(entries, (name, nothing))
            end
        end
        entries
    end

    # Build author list
    author = locvar(:author)
    authors = locvar(:authors)
    raw_authors = if !isnothing(authors)
        authors
    elseif !isnothing(author)
        author
    else
        ""
    end
    author_entries = parse_authors(raw_authors)

    # Build the author JSON entries
    function author_obj((name, url))
        if url !== nothing
            """{"@type": "Person", "name": "$name", "url": "$url"}"""
        else
            """{"@type": "Person", "name": "$name"}"""
        end
    end
    author_json = if length(author_entries) == 1
        author_obj(author_entries[1])
    elseif length(author_entries) > 1
        "[$(join(author_obj.(author_entries), ", "))]"
    else
        """{"@type": "Organization", "name": "The Julia Language"}"""
    end

    website_url = strip(globvar(:website_url), '/')

    # Get the page URL
    page_url = "$website_url/$(Franklin.locvar(:fd_rpath))"
    # Normalize: /blog/2024/05/post.md -> /blog/2024/05/post/
    page_url = replace(page_url, r"\.md$" => "/")

    # Ensure image URL is absolute
    if startswith(image_url, "/")
        image_url = "$website_url$image_url"
    end

    # Escape strings for JSON (also strip any HTML tags and newlines)
    function esc(s)
        s = striptags(s)
        s = replace(s, "\\" => "\\\\")
        s = replace(s, "\"" => "\\\"")
        s = replace(s, r"\s+" => " ")
        strip(s)
    end

    return """
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "BlogPosting",
      "headline": "$(esc(title))",
      "description": "$(esc(descr))",
      "image": "$(esc(image_url))",
      "datePublished": "$date_iso",
      "author": $author_json,
      "publisher": {
        "@type": "Organization",
        "name": "The Julia Language",
        "logo": {
          "@type": "ImageObject",
          "url": "$website_url/assets/images/julia-open-graph.png"
        }
      },
      "mainEntityOfPage": {
        "@type": "WebPage",
        "@id": "$(esc(page_url))"
      }
    }
    </script>
    """
end

function hfun_all_gsoc_projects()
	base_dir = joinpath("jsoc", "gsoc")
	all_projects = readdir(base_dir)
	md = IOBuffer()
	for project in all_projects
		endswith(project, ".md") || continue
        for line in eachline(joinpath(base_dir, project))
            # remove any table of contents
            if line == "\\toc"
                continue
            end

            # remove ' - Summer of Code' suffix from the primary header
            line = replace(line, r"^# (.*) - Summer of Code" => s"# \1")

            # increase the header level by 1
            if startswith(line, "#")
                line = "#" * line
            end

            println(md, line)
        end
		write(md, "\n\n")
	end
	allmd = String(take!(md))
	return fd2html(allmd, internal=true)
end
