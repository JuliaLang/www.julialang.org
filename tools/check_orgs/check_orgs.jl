# A tool to identify publicly listed Julia organizations on
# https://julialang.org/community/organizations/ that have fewer than
# 2 public members

using GitHub

function check_orgs()
    myauth = GitHub.authenticate(ENV["GITHUB_AUTH"])

    fpath = joinpath(dirname(dirname(@__DIR__)), "community", "organizations.md")
    conts = String(read(fpath))
    occursin("## Julia GitHub Organizations", conts) || error("not reading the correct file $fpath")

    orgs = eachmatch(r"(?<url>https?://github\.com/[^/\s]+(?=\)))", conts)

    println("Finding orgs with fewer than 2 public memers that are listed in https://julialang.org/community/organizations/")

    num_below = 0
    for org_match in orgs
        org = split(org_match.captures[1], "https://github.com/", keepempty=false)[1]
        org = split(org, "http://github.com/", keepempty=false)[1]
        members, page_data = GitHub.members(Owner(org), auth=myauth, public_only=true)
        if length(members) < 2
            println(" - $org $(length(members)) members")
            num_below += 1
        end
    end

    if num_below > 0
        error("Found $num_below organization(s) with fewer than 2 public members")
    else
        println("None found")
    end
end
check_orgs()
