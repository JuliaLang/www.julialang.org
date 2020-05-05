"""
    {{meta}}

Plug in specific meta information for a blog page. The `meta` local page
variable should be given as a tuple of pairs like so:
```
@def meta = ("property"=>"og:video", "content"=>"http://example.com/")
```
"""
function hfun_meta()
    io = IOBuffer()
    write(io, "<meta ")
    for (k, v) in locvar(:meta)
        write(io, "$k=\"$v\" ")
    end
    write(io, ">")
    return String(take!(io))
end
