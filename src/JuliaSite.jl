module JuliaSite

using NodeJS
using Franklin

export build_site

"""
    build_site()

This ensures that NodeJS and Franklin are loaded then it installs highlight.js which is needed
for the prerendering step. Then the environment is activated and instantiated to install all
Julia packages which may be required to successfully build your site.
"""
function build_site()
    run(`$(npm_cmd()) install highlight.js`)
    highlight_path = abspath(joinpath("_libs", "highlight", "highlight.min.js"))
    Franklin.HIGHLIGHTJS[] = highlight_path
    Franklin.optimize(; prerender=true)
    cp(joinpath("__site", "feed.xml"), joinpath("__site", "index.xml"))
end

end # module
