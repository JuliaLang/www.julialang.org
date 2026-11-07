# Measures the latency numbers in the TTFX chart of the Julia 1.14 highlights blog post
# (https://julialang.org/blog/2026/10/julia-1.14-highlights/).
#
# For every task of the Julia-TTFX-Snippets suite and every Julia build it measures:
#
#   precompile  time to precompile the task's packages, from an empty compile cache
#   load        time of the task's `using` statements
#   cold        first call in a fresh process, with an empty native code cache
#   warm        first call in a fresh process, with the native code cache populated by the cold run
#
# The native code cache only exists from Julia 1.14, so on older versions cold and warm are the same.
# Each build gets its own depot for compiled code (packages and artifacts are shared), and its
# own native code cache, so nothing in ~/.julia is used or modified.
#
# Usage (needs git, and Julia 1.10 or later to run this script):
#
#     julia ttfx_latency.jl [options] [label=command ...]
#
# Each build is given as `label=command`. Without any, the juliaup channels are used:
#
#     1.10=julia +1.10  1.13=julia +1.13  1.14=julia +1.14  1.14+opt=julia +1.14+opt
#
# Options:
#
#     --workdir DIR     where the snippets, depots, logs and results go (default: ./ttfx-work)
#     --samples N       cold/warm samples per task and build, the minimum is used (default: 3)
#     --tasks REGEX     only run the tasks whose `Package/Task` name matches
#     --timeout MIN     timeout of each process in minutes (default: 30)
#     --summary         only print the summary of the results in the workdir
#
# Running the whole suite takes a few hours. Results are appended to `<workdir>/results.csv` as
# they come in, and a rerun with the same workdir skips the tasks that are done, so it can be
# interrupted and resumed. At the end it prints the geometric mean over the tasks that succeeded
# on every build, and writes the chart's data for this platform to `<workdir>/ttfx-latency-<platform>.js`.
# Copy that file next to this script, and add it to the blog post if the platform is new.

using Printf

const SNIPPETS_REPO = "https://github.com/tecosaur/Julia-TTFX-Snippets"
const SNIPPETS_COMMIT = "72fd3d18749faf138bfa5f55e4affb70d82da485"
# Tasks that do not work on all the measured versions (same as Julia's TTFX CI job).
const EXCLUDE = ["JET/Type-Stability-Analysis", "Enzyme/Gradient-Of-Square-Norm"]
const METRICS = ["precompile", "load", "cold", "warm"]
const DEFAULT_BUILDS = ["1.10=julia +1.10", "1.13=julia +1.13", "1.14=julia +1.14", "1.14+opt=julia +1.14+opt"]
const DEPOT_SEP = Sys.iswindows() ? ";" : ":"

struct Build
    label::String
    cmd::Cmd
    bundled_depots::Vector{String}  # where the build's stdlib package images are
end

function parse_args(args)
    opts = Dict{String,Any}("workdir" => "ttfx-work", "samples" => 3, "tasks" => nothing,
                            "timeout" => 30, "summary" => false)
    builds = String[]
    i = 1
    while i <= length(args)
        a = args[i]
        if a == "--summary"
            opts["summary"] = true
        elseif startswith(a, "--")
            k = a[3:end]
            haskey(opts, k) || error("unknown option $a")
            v = args[i+=1]
            opts[k] = k in ("samples", "timeout") ? parse(Int, v) : v
        else
            occursin('=', a) || error("expected `label=command`, got `$a`")
            push!(builds, a)
        end
        i += 1
    end
    return opts, isempty(builds) ? DEFAULT_BUILDS : builds
end

sanitize(s) = replace(s, r"[^A-Za-z0-9.]" => "_")

# A clean environment: no JULIA_* variables from the caller (juliaup's own are kept).
function julia_env(; kw...)
    env = Dict(k => v for (k, v) in ENV if !startswith(k, "JULIA_") || startswith(k, "JULIAUP"))
    for (k, v) in kw
        env[string(k)] = v
    end
    return env
end

function make_build(spec)
    label, cmdstr = split(spec, '='; limit=2)
    cmd = Cmd(Base.shell_split(cmdstr))
    script = """print(join(filter(d -> endswith(d, joinpath("share", "julia")), DEPOT_PATH), "\\n"))"""
    out = read(setenv(`$cmd --startup-file=no -e $script`, julia_env()), String)
    return Build(label, cmd, split(out, '\n'; keepempty=false))
end

function build_info(b::Build)
    script = """print(VERSION, " (", Base.GIT_VERSION_INFO.commit_short, ")")"""
    return read(setenv(`$(b.cmd) --startup-file=no -e $script`, julia_env()), String)
end

# Runs `cmd` with its output going to `log`. Returns whether it succeeded.
function run_logged(cmd, log, timeout_min)
    mkpath(dirname(log))
    open(log, "w") do io
        p = run(pipeline(ignorestatus(cmd); stdout=io, stderr=io); wait=false)
        if timedwait(() -> !process_running(p), 60.0 * timeout_min; pollint=0.5) === :timed_out
            kill(p)
            wait(p)
            println(io, "\nTIMED OUT after $timeout_min minutes")
            return false
        end
        return success(p)
    end
end

function last_match(re, log)
    m = nothing
    for line in eachline(log)
        m′ = match(re, line)
        m′ === nothing || (m = m′)
    end
    return m
end

function snippets_dir(workdir)
    dir = joinpath(workdir, "Julia-TTFX-Snippets")
    if !isdir(dir)
        run(`git clone --quiet $SNIPPETS_REPO $dir`)
    end
    run(`git -C $dir -c advice.detachedHead=false checkout --quiet $SNIPPETS_COMMIT`)
    return dir
end

function find_tasks(dir, filter_re)
    tasks = Pair{String,String}[]  # Package/Task => directory
    for (root, _, files) in walkdir(joinpath(dir, "tasks"))
        "task.jl" in files || continue
        name = join(splitpath(relpath(root, joinpath(dir, "tasks")))[2:end], "/")  # Package/Task
        name in EXCLUDE && continue
        filter_re === nothing || occursin(Regex(filter_re), name) || continue
        push!(tasks, name => root)
    end
    return sort!(tasks; by=first)
end

function record(io, label, task, metric, value)
    println(io, label, ",", task, ",", metric, ",", value)
    flush(io)
end

function measure(io, b::Build, task, src, opts)
    work = opts["workdir"]
    timeout = opts["timeout"]
    shared = joinpath(work, "depot-shared")
    depot = joinpath(work, "depot-" * sanitize(b.label))
    objcache = joinpath(work, "objcache-" * sanitize(b.label))
    logs = joinpath(work, "logs", sanitize(b.label), replace(task, "/" => "-"))
    proj = joinpath(work, "projects", sanitize(b.label), task)
    fail(step) = (record(io, b.label, task, "failed", step); println("  $(b.label): failed at $step, see $logs"); false)

    # Install the packages into the shared depot, without precompiling.
    rm(proj; force=true, recursive=true)
    mkpath(dirname(proj))
    cp(src, proj)
    install_env = julia_env(JULIA_DEPOT_PATH=join([shared; b.bundled_depots], DEPOT_SEP),
                            JULIA_PKG_PRECOMPILE_AUTO="0")
    cmd = `$(b.cmd) --startup-file=no --project=$proj -e "using Pkg; Pkg.instantiate()"`
    run_logged(setenv(cmd, install_env; dir=proj), joinpath(logs, "install.log"), timeout) || return fail("install")

    env = julia_env(JULIA_DEPOT_PATH=join([depot; shared; b.bundled_depots], DEPOT_SEP),
                    JULIA_PKG_PRECOMPILE_AUTO="0", JULIA_OBJCACHE_PATH=objcache)

    # Precompile from an empty compile cache.
    rm(joinpath(depot, "compiled"); force=true, recursive=true)
    script = """using Pkg; t = time(); Pkg.precompile(); println("PRECOMPILE ", time() - t)"""
    log = joinpath(logs, "precompile.log")
    run_logged(setenv(`$(b.cmd) --startup-file=no --project=$proj -e $script`, env; dir=proj), log, timeout) ||
        return fail("precompile")
    m = last_match(r"^PRECOMPILE (\S+)$", log)
    m === nothing && return fail("precompile")
    record(io, b.label, task, "precompile", parse(Float64, m[1]))

    # The task prints "load, run, total seconds".
    run_task(name) = begin
        log = joinpath(logs, name * ".log")
        cmd = setenv(`$(b.cmd) --startup-file=no --project=$proj task.jl`, env; dir=proj)
        run_logged(cmd, log, timeout) || return nothing
        m = last_match(r"^(\S+), (\S+), (\S+) seconds$", log)
        m === nothing ? nothing : (parse(Float64, m[1]), parse(Float64, m[2]))
    end
    # An untimed run first, which does anything left over from precompilation (and warms the OS file cache).
    run_task("warmup") === nothing && return fail("warmup")
    for s in 1:opts["samples"]
        rm(objcache; force=true, recursive=true)
        cold = run_task("cold-$s")
        cold === nothing && return fail("cold-$s")
        warm = run_task("warm-$s")
        warm === nothing && return fail("warm-$s")
        record(io, b.label, task, "load", cold[1])
        record(io, b.label, task, "load", warm[1])
        record(io, b.label, task, "cold", cold[2])
        record(io, b.label, task, "warm", warm[2])
    end
    record(io, b.label, task, "done", 0)
    return true
end

geomean(xs) = exp(sum(log, xs) / length(xs))

function platform_name()
    os = Sys.isapple() ? "macOS" : Sys.iswindows() ? "Windows" : Sys.islinux() ? "Linux" : string(Sys.KERNEL)
    arch = Sys.ARCH === :x86_64 ? "x86-64" : (Sys.isapple() && Sys.ARCH === :aarch64) ? "Apple silicon" : string(Sys.ARCH)
    return "$os ($arch)"
end

platform_slug() = (Sys.isapple() ? "macos" : Sys.iswindows() ? "windows" : lowercase(string(Sys.KERNEL))) * "-" * string(Sys.ARCH)

function summary(results, labels, workdir)
    # results[(label, task)][metric] = values; a task counts if it is done on every build.
    tasks = Dict{String,Int}()
    for ((label, task), r) in results
        label in labels && haskey(r, "done") && (tasks[task] = get(tasks, task, 0) + 1)
    end
    common = sort([t for (t, n) in tasks if n == length(labels)])
    failed = sort(unique(t for ((l, t), r) in results if l in labels && haskey(r, "failed")))
    isempty(common) && (println("No task has finished on every build yet."); return)

    gm = Dict(label => [geomean([minimum(results[(label, t)][m]) for t in common]) for m in METRICS]
              for label in labels)
    println("\nGeometric mean over $(length(common)) tasks, in seconds, on $(platform_name()):\n")
    @printf("%-12s %11s %8s %8s %8s\n", "build", METRICS...)
    for label in labels
        @printf("%-12s %11.2f %8.3f %8.3f %8.3f\n", label, gm[label]...)
    end
    isempty(failed) || println("\nLeft out, as they failed on some build: ", join(failed, ", "))

    # The chart's data. Builds whose label ends in "+opt" are the optimized builds.
    jsstr(s) = "\"" * escape_string(s, "\"") * "\""
    entry(ls) = "{" * join((jsstr(replace(l, r"\+opt$" => "")) * ":[" * join((@sprintf("%.3g", x) for x in gm[l]), ",") * "]"
                            for l in ls), ",") * "}"
    std = filter(l -> !endswith(l, "+opt"), labels)
    opt = filter(l -> endswith(l, "+opt"), labels)
    file = joinpath(workdir, "ttfx-latency-$(platform_slug()).js")
    write(file, """
        // Data for the latency chart in the Julia 1.14 highlights post, written by ttfx_latency.jl.
        // Per build: [precompile, load, first call (cold), first call (warm)] in seconds, the geometric
        // mean over the TTFX tasks that work on all builds.
        (window.TTFX_LATENCY = window.TTFX_LATENCY || {})[$(jsstr(platform_name()))] = {
        "tasks":$(length(common)),"cpu":$(jsstr(strip(Sys.cpu_info()[1].model))),
        "std":$(entry(std)),
        "opt":$(entry(opt))};
        """)
    println("\nChart data written to $file")
end

function read_results(file)
    results = Dict{Tuple{String,String},Dict{String,Vector{Float64}}}()
    isfile(file) || return results
    for line in eachline(file)
        label, task, metric, value = split(line, ',')
        r = get!(results, (label, task), Dict{String,Vector{Float64}}())
        push!(get!(r, metric, Float64[]), something(tryparse(Float64, value), NaN))
    end
    return results
end

function main(args)
    opts, specs = parse_args(args)
    work = opts["workdir"] = abspath(opts["workdir"])
    mkpath(work)
    file = joinpath(work, "results.csv")
    labels = [split(s, '='; limit=2)[1] for s in specs]
    if opts["summary"]
        return summary(read_results(file), labels, work)
    end

    builds = map(make_build, specs)
    println("Platform: ", platform_name(), ", ", Sys.cpu_info()[1].model, ", ", Sys.CPU_THREADS, " threads")
    for b in builds
        println("  ", rpad(b.label, 10), build_info(b))
    end
    dir = snippets_dir(work)
    tasks = find_tasks(dir, opts["tasks"])
    done = read_results(file)
    println("$(length(tasks)) tasks, results in $file\n")

    open(file, "a") do io
        for (i, (task, src)) in enumerate(tasks)
            println("[$i/$(length(tasks))] $task")
            # The builds are interleaved per task, so slow drift of the machine affects all of them alike.
            for b in builds
                r = get(done, (b.label, task), nothing)
                if r !== nothing && (haskey(r, "done") || haskey(r, "failed"))
                    println("  $(b.label): already done")
                    continue
                end
                t = time()
                ok = measure(io, b, task, src, opts)
                ok && @printf("  %s: done in %.0f s\n", b.label, time() - t)
            end
        end
    end
    summary(read_results(file), labels, work)
end

main(ARGS)
