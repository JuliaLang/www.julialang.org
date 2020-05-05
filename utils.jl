"""
    {{meta}}

Plug in specific meta information for a blog page. The `meta` local page
variable should be given as a tuple of pairs like so:
```
@def meta = ("property"=>"og:video", "content"=>"http://example.com/")
```
Multiple meta tags can be specified that way too by just passing a list:
```
@def meta = [("property"=>"og:video", "content"=>"http://example.com/"),
             ("propery"=>"og:title", "content"=>"The Rock")]
```
"""
function hfun_meta()
    m = locvar(:meta)
    if eltype(m) isa Pair
        return _meta(m)
    end
    return prod(_meta.(m))
end

_meta(m) = "<meta " * prod("$k=\"$v\" " for (k, v) in m) * ">"
