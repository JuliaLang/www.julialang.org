using Dates

"""
    page_url(website_url, rpath)

Public URL of the page built from source `rpath`, e.g. `blog/2024/05/post.md`
gives `\$website_url/blog/2024/05/post/` and `downloads/index.md` gives
`\$website_url/downloads/`.
"""
function page_url(website_url, rpath)
    path = replace(rpath, r"(^|/)index\.(md|html)$" => s"\1")
    path = replace(path, r"\.(md|html)$" => "/")
    return "$website_url/$path"
end

"""
    parse_pubdate(s)

Parse a `published` page variable like "12 August 2021", returning `nothing`
(with a warning) if it is not in that format.
"""
function parse_pubdate(s)
    date = tryparse(Date, s, dateformat"d U Y")
    isnothing(date) && @warn "Could not parse published date \"$s\" (expected e.g. \"12 August 2021\")"
    return date
end

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
    (isnothing(descr) || isempty(strip(descr))) && (descr = "Official website for the Julia programming language")
    p = "property"
    # Build page URL for og:url
    website_url = strip(globvar(:website_url), '/')
    page_rpath = locvar(:fd_rpath)
    url = isnothing(page_rpath) ? website_url : page_url(website_url, page_rpath)
    # default og properties, can be overwritten by the user
    ogdflt = (
        title = (p, "og:title", title),
        descr = (p, "og:description", descr),
        image = (p, "og:image", "/assets/images/julia-open-graph.png"),
        url   = (p, "og:url", url),
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
    base = locvar(:base)
    io = IOBuffer()
    for m in meta
        content = string(m[3])
        # Resolve {{base}} (some posts use a `base` page variable in meta values)
        isnothing(base) || (content = replace(content, "{{base}}" => base))
        # og:image must be an absolute URL
        m[2] == "og:image" && startswith(content, "/") && (content = "$website_url$content")
        # HTML-escape double quotes and newlines in content to produce valid attributes
        escaped = replace(content, "&" => "&amp;", "\"" => "&quot;", "\n" => " ")
        write(io, "<meta $(m[1])=\"$(m[2])\" content=\"$(escaped)\">\n")
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
    alt = false  # track alternating background
    for yr in curyear:-1:2012
        ys = "$yr"
        year_posts = IOBuffer()
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
                date = isnothing(pubdate) ? nothing : parse_pubdate(pubdate)
                if isnothing(date)
                    date    = "$ys-$ms-01"
                    days[i] = 1
                else
                    days[i] = day(date)
                end
                lines[i] = "<a href=\"$url\">$title</a> $date"
            end
            # sort by day
            foreach(line -> write(year_posts, "<p>$line</p>\n"), lines[sortperm(days, rev=true)])
        end
        year_html = String(take!(year_posts))
        isempty(year_html) && continue
        bg = alt ? "container-fluid alt-color packages" : "container pt-sm-2"
        alt = !alt
        write(io, """
        <div class="$bg"><br>
          <div class="container">
            <div class="row">
              <div class="col-lg-4 col-md-3 language-features"><hr/></div>
              <div class="col-lg-4 col-md-6 language-features section-heading">
                <h2 class="lead secondary-heading">$yr</h2>
              </div>
              <div class="col-lg-4 col-md-3 language-features"><hr/></div>
            </div>
            <div class="grid">$year_html</div>
          </div>
        <br></div>
        """)
    end
    return String(take!(io))
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
                date     = isnothing(pubdate) ? nothing : parse_pubdate(pubdate)
                days[i]  = isnothing(date) ? 1 : day(date)
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
    for (surl, date) in recent[1:nfound]
        url   = "/$surl/"
        Franklin.PAGEVAR_DEPTH[] = 0
        title = pagevar(surl, :title)
		title === nothing && (title = "Untitled")
        sdate = "$(day(date)) $(monthname(date)) $(year(date))"
        Franklin.PAGEVAR_DEPTH[] = 0
        blurb = pagevar(surl, :rss_description)
        blurb = blurb === nothing ? "" : "<p>$blurb</p>"
        write(io, """
            <div class="col-lg-4 col-md-12">
              <a class="blog" href="$url" data-proofer-ignore>
                <h3 class="title">$title</h3>
                <span class="article-date">$sdate</span>
                $blurb
              </a>
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
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <title>Redirecting…</title>
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
    return "<a href=\"$url\"><img src=\"/assets/infra/twitter.svg\" alt=\"Twitter\" width=\"22\" height=\"22\" style=\"margin-left:2px\"></a>"
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
          <img src="$img" class="author-img" alt="$(locvar(:author))" style="width: 150px">
		  <h2>$(locvar(:author))</h2>
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
    pubdate = parse_pubdate(pubdate_str)
    isnothing(pubdate) && return ""
    date_iso = Dates.format(pubdate, "yyyy-mm-dd") * "T00:00:00+00:00"

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
        # Split on comma, " and " or ", and " (but not inside tags)
        for part in split(raw, r"\s*,\s*(?:and\s+)?|\s+and\s+")
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

    # Escape strings for JSON (also strip any HTML tags and newlines)
    function esc(s)
        s = striptags(s)
        s = replace(s, "\\" => "\\\\")
        s = replace(s, "\"" => "\\\"")
        s = replace(s, r"\s+" => " ")
        strip(s)
    end

    # Build the author JSON entries
    function author_obj((name, url))
        if url !== nothing
            """{"@type": "Person", "name": "$(esc(name))", "url": "$(esc(url))"}"""
        else
            """{"@type": "Person", "name": "$(esc(name))"}"""
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

    # Get the page URL, e.g. /blog/2024/05/post.md -> /blog/2024/05/post/
    url = page_url(website_url, Franklin.locvar(:fd_rpath))

    # Ensure image URL is absolute
    if startswith(image_url, "/")
        image_url = "$website_url$image_url"
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
        "@id": "$(esc(url))"
      }
    }
    </script>
    """
end

function hfun_all_gsoc_projects()
	base_dir = joinpath("jsoc", "gsoc")
	# Only include projects that are linked from the curated projects page
	curated = String(read(joinpath("jsoc", "projects.md")))
	curated_slugs = Set(m.match for m in eachmatch(r"(?<=/jsoc/gsoc/)[^/)]+", curated))
	all_projects = readdir(base_dir)
	md = IOBuffer()
	for project in all_projects
		endswith(project, ".md") || continue
		replace(project, ".md" => "") in curated_slugs || continue
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

"""
    {{llms_txt}}

Writes `__site/llms.txt` (see https://llmstxt.org) from the template
`_layout/llms.txt`, replacing `{{var}}` with the global variable `var` from
`config.md` (e.g. `{{stable_release}}`), so that the release information stays
current. Called from `llms.html`, whose own output is a redirect to `/llms.txt`.
"""
function hfun_llms_txt()
    template = read(joinpath(Franklin.path(:layout), "llms.txt"), String)
    content = replace(template, r"\{\{\s*([A-Za-z_][A-Za-z0-9_]*)\s*\}\}" => function (m)
        name = String(match(r"[A-Za-z_][A-Za-z0-9_]*", m).match)
        val = globvar(name)
        val === nothing && error("llms.txt: unknown global variable `$name`")
        return string(val)
    end)
    write(joinpath(Franklin.path(:site), "llms.txt"), content)
    # Keep the helper /llms/ page out of the sitemap. For .html pages the
    # `sitemap_exclude` page variable is read before the page is converted, and
    # `{{sitemap_opts exclude}}` throws in this Franklin version, so remove the
    # entry directly.
    delete!(Franklin.SITEMAP_DICT, Franklin.url_curpage())
    return hfun_redirect(["/llms.txt"])
end
