@def authors = "Tim Holy and Nathan Daly"
@def published = "1 December 2020"
@def title = "Reducing compiler latency in Julia packages"
@def rss_pubdate = Date(2020, 12, 1)
@def rss = """Julia runs fast, but suffers from latency due to compilation. This post describes how to detect and eliminate major sources of latency in packages."""

\toc

[The Julia programming language][Julia] delivers remarkable runtime performance and flexibility.  Julia's flexibility depends on the ability to of methods to handle arguments of many different types.  This flexibility would be in competition with runtime performance, were it not for the "trick" of *method specialization*.  Julia compiles a separate "instance" of a method for each distinct combination of argument types; this specialization allows code to be optimized to take advantage of specific features of the inputs, eliminating most of the *runtime* cost that would otherwise be the result of Julia's flexibility.

Unfortunately, method specialization has its own cost: compiler latency.  Since compilation is expensive, there is a measurable delay that occurs on first invokation of a method for a specific combination of argument types.  There are cases where one can do some of this work once, in advance, using utilities like [`precompile`] or building a custom system with [PackageCompiler].  In other cases, the number of distinct argument types that a method might be passed seems effectively infinite, and in such cases precompilation seems unlikely to be a comprehensive solution.

This post introduces some new tools to detect the major sources of compiler latency, focusing specifically on the *type inference* step of compilation. [Type inference] is the process of deducing the types of all the internal variables in a method, given the types of the input arguments.  This is an early, but crucial, step in compilation, and the first to introduce substantial latency.  Later steps (optimization and native-code generation) are typically even more expensive, but in many cases inference latency is roughly proportional to these other forms of latency: typically, each run of inference is followed by these later steps of compilation.  (An exception are methods annotated with [`@nospecialize`], which get compiled to native code only for generic argument types.  Julia also has a number of heuristics which in essence add `@nospecialize` automatically for certain combinations of argument types.)

In this post, we'll walk through the process of analyzing and optimizing the [DataFrames] package.  We chose DataFrames for several reasons:

- DataFrames is widely used
- the DataFrames API seems fairly stable, and they are approaching their 1.0 release
- DataFrames is designed to work with any type of data and any user-supplied transformation functions, and so [faces substantial latency challenges](https://discourse.julialang.org/t/best-practices-for-profiling-compilation/48249)
- DataFrames is developed by a sophisticated and conscientious team, and the package has already been [aggressively optimized for latency](https://discourse.julialang.org/t/release-announcements-for-dataframes-jl/18258/112?u=tim.holy) using tools that were, until now, state-of-the-art; this sets a high bar for any new tools (don't worry, we're going to crest that bar ;-) )
- In a previous [blog post][invalidations], one of the authors indirectly "called out" DataFrames (and more accurately its dependency [CategoricalArrays]) for having a lot of difficult-to-fix invalidations.  To their credit, the developers made changes that dropped the number of invalidations by about 10×. This post is partly an attempt to return the favor.  That said, we hope they don't mind being guinea pigs for these new tools.

This post is based on DataFrames 0.22.1, and version 0.9 of the underlying CategoricalArrays.  If you follow the steps of this blog post with different versions, you're likely to get different results from those shown here, partly because many of the issues we identified have been fixed in more recent releases.  It should also be emphasize that these analysis tools are only supported on Julia 1.6 and above; at the time of this post, Julia 1.6 not yet to "alpha" release phase but can be obtained from [nightly] snapshots or built from [source].

## Taking a baseline measurement

A good first step is to roughly document the current compiler latency costs.  For a package like DataFrames that contains an extensive test suite, an easy way to do this is to time the entire test suite:

```julia
shell> pwd
/home/tim/.julia/dev/DataFrames/test

julia> using DataFrames; @time include("runtests.jl")
Running tests:
⋮                     # lots of suppressed lines of output
620.652994 seconds (1.25 G allocations: 72.799 GiB, 3.35% gc time, 96.29% compilation time)
```

Julia told us that a whopping 96.29% of the time was spent on compilation. It's pretty common among Julia packages that compilation is the dominant cost of running the test suite. Unsurprisingly, it's considerably faster if we just run the suite a second time within the same session:

```julia
julia> @time include("runtests.jl")
⋮
235.602932 seconds (396.67 M allocations: 23.434 GiB, 3.05% gc time, 89.01% compilation time)
```

While this is much faster, you'll note that compilation still accounts for almost 90% of the time. Why is there any recompilation at all?  One reason is that tests that (re)define functions, including lines like

```julia
map(x->x^2, a)   # when run from "top level," this defines a new anonymous function
```
force a new round of specialization of the `map` method.  DataFrames has a *lot* of tests that look like this.

Having obtained this simple baseline measurement, let's get started.

## Identifying the most costly-to-infer methods

Our first goal is to identify methods that cost the most in inference.
To do this, start from a fresh Julia session and do the following:

```julia
shell> pwd
/home/tim/.julia/dev/DataFrames/test

julia> using SnoopCompile

julia> tinf = @snoopi_deep include("runtests.jl");
Running tests:
⋮
```

`@snoopi_deep` is a new tool in [SnoopCompile] which leverages new functionality in Julia.  Like the older `@snoopi`, it measures what is being inferred and how much time it takes.  However, `@snoopi` measures aggregate time for each "entrance" into inference, and it includes the time spent inferring all the methods that get inferrably dispatched from the entrance point.  In contrast, `@snoopi_deep` extracts this data for each method instance, regardless of whether it is an "entrance point" or called by something else.

Having obtained these measurements in `tinf`, we can now do a lot of analysis.
`tinf` is a very large tree (warning: printing the whole tree takes minutes, but you can interrupt it with Ctrl-C):

```julia
julia> using AbstractTrees

julia> print_tree(tinf)
4.43487909448e8μsec: MethodInstance for ROOT()
├─ 332.049μsec: MethodInstance for include(::String)
│  └─ 118.253μsec: MethodInstance for getproperty(::Module, ::Symbol)
├─ 1692.625μsec: MethodInstance for require(::Module, ::Symbol)
│  ├─ 98.411μsec: MethodInstance for identify_package(::Module, ::String)
│  │  └─ 1029.586μsec: MethodInstance for identify_package(::Base.PkgId, ::String)
│  │     ├─ 79.496μsec: MethodInstance for getproperty(::Base.PkgId, ::Symbol)
│  │     ├─ 28.933μsec: MethodInstance for convert(::Type{Union{Nothing, Base.PkgId}}, ::Base.PkgId)
│  │     ├─ 32.701μsec: MethodInstance for getproperty(::Base.PkgId, ::Symbol)
│  │     ├─ 571.372μsec: MethodInstance for identify_package(::String)
│  │     └─ 1020.444μsec: MethodInstance for manifest_deps_get(::String, ::Base.PkgId, ::String)
│  │        ├─ 3478.298μsec: MethodInstance for explicit_manifest_deps_get(::String, ::Base.UUID, ::String)
│  │        │  ⋮
```

Each branch of a node indents further to the right, and represents callees of the node.  The `ROOT` object is special: it measures the approximate time spent on the entire operation, excepting inference, and consequently combines native code generation and runtime. Each other entry reports the time needed to infer just that method instance, not including the time spent inferring its callees.

One of the first steps you can take is to "flatten" the tree, sorting the nodes in increasing order of inference time:

```julia
julia> flatten_times(tinf)
663530-element Vector{Pair{Float64, Core.Compiler.Timings.InferenceFrameInfo}}:
      7.394e-6 => Core.Compiler.Timings.InferenceFrameInfo(MethodInstance for copy(::InvertedIndices.InvertedIndexIterator{Int64, Base.Slice{Base.OneTo{Int64}}, Base.OneTo{Int64}}), 0x0000000000007741, Any[], Any[Core.Const(copy), InvertedIndices.InvertedIndexIterator{Int64, Base.Slice{Base.OneTo{Int64}}, Base.OneTo{Int64}}], 2, false)
               ⋮
   0.249446057 => Core.Compiler.Timings.InferenceFrameInfo(MethodInstance for do_call(::Type, ::Vector{Int64}, ::Vector{Int64}, ::Vector{Int64}, ::GroupedDataFrame{DataFrame}, ::Tuple{Vector{NamedTuple{(:a, :b), Tuple{Int64, Int64}}}}, ::Int64), 0x0000000000007632, Any[], Any[Core.Const(DataFrames.do_call), Type, Vector{Int64}, Vector{Int64}, Vector{Int64}, GroupedDataFrame{DataFrame}, Tuple{Vector{NamedTuple{(:a, :b), Tuple{Int64, Int64}}}}, Int64, Union{}], 8, false)
   0.343503454 => Core.Compiler.Timings.InferenceFrameInfo(Toplevel MethodInstance thunk, 0x0000000000007741, Any[], Any[Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}  …  Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}], 0, false)
   0.369120319 => Core.Compiler.Timings.InferenceFrameInfo(Toplevel MethodInstance thunk, 0x0000000000007741, Any[], Any[Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}  …  Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}], 0, false)
   0.923845737 => Core.Compiler.Timings.InferenceFrameInfo(MethodInstance for precompile(::Bool), 0x0000000000007759, Any[], Any[Core.Const(DataFrames.precompile), Bool, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}  …  Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}, Union{}], 2, false)
 443.487909448 => Core.Compiler.Timings.InferenceFrameInfo(MethodInstance for ROOT(), 0x0000000000000000, Any[], Any[Core.Const(Core.Compiler.Timings.ROOT)], 1, false)
```

We see >600K nodes, of which some take an appreciable fraction of a second to infer.  It is these most expensive method instances that should be the main focus of our optimization.  The `thunk` items represent calls made from the test file itself, so aside from `precompile`, which is in a special category, the worst call here is `DataFrames.do_call`.

This is a truncated version of the output; if you look at more of the entries carefully, you'll notice a number of near-duplicates: `do_call` appears numerous times, with different argument types. While `do_call` has eight methods, there are many more entries in `flatten_times(tinf)` than these eight, and this is explained by multiple specializations of single methods.  It's of particular interest to aggregate all the instances of a particular method, since this represents the cost of the method itself:

```julia
julia> tm = accumulate_by_method(flatten_times(tinf))
6974-element Vector{Pair{Float64, Method}}:
           1.465e-5 => LogBo256L(::Val{:ℯ}, ::Type{Float64}) in Base.Math at special/exp.jl:46
                    ⋮
 3.5665204619999993 => iterate(t::Tuple, i::Int64) in Base at tuple.jl:64
  4.829588363999999 => do_call(f::Union{Function, Type}, idx::AbstractVector{var"#s249"} where var"#s249"<:Integer, starts::AbstractVector{var"#s248"} where var"#s248"<:Integer, ends::AbstractVector{var"#s146"} where var"#s146"<:Integer, gd::GroupedDataFrame, incols::Tuple{AbstractVector{T} where T}, i::Integer) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/callprocessing.jl:91
         7.12010299 => var"#_combine_prepare#473"(keepkeys::Bool, ungroup::Bool, copycols::Bool, keeprows::Bool, renamecols::Bool, ::typeof(DataFrames._combine_prepare), gd::GroupedDataFrame, cs::Union{Regex, AbstractString, Function, Signed, Symbol, Unsigned, Pair, AbstractVector{T} where T, Type, All, Between, Cols, InvertedIndex}...) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:21
 11.909738723000002 => _combine_with_first(first::Union{AbstractDataFrame, NamedTuple, DataFrameRow}, f::Union{Function, Type}, gd::GroupedDataFrame, incols::Union{Nothing, Tuple, AbstractVector{T} where T, NamedTuple}, firstmulticol::Val, idx_agg::Union{Nothing, AbstractVector{var"#s249"} where var"#s249"<:Integer}) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/complextransforms.jl:21
      443.487909448 => ROOT() in Core.Compiler.Timings at compiler/typeinfer.jl:75
```

This much smaller number of entries paints a somewhat different picture from the one above: `do_call` is now the third-worst offender, but it is handily beat by `_combine_with_first`.  How can this happen? A key is to look at the number of specializations of each function:

```julia
julia> length(methodinstances(DataFrames._combine_with_first))
624
```

The aggregate cost is a sum of the cost of all individual `MethodInstance`s.
(`do_call` has even more instances, at 1260, but some of these instances must be must less time-consuming than the worst offender we noted above.)

This is a *lot* of specializations, and their aggregate cost is high: not only is there the 12s spent inferring all these instances of `_combine_with_first`, there is also the unmeasured cost of native code generation for these specializations.  If we can do something to reduce the number of specializations, or to make the compilation cost of each much smaller, we might be able to shave a fair amount from the cost of running the test suite.

## Strategy 1: reducing the cost of argument type-diversity

Let's take a look at `_combine_with_first`:

```julia
julia> methods(DataFrames._combine_with_first)
# 1 method for generic function "_combine_with_first":
[1] _combine_with_first(first::Union{AbstractDataFrame, NamedTuple, DataFrameRow}, f::Union{Function, Type}, gd::GroupedDataFrame, incols::Union{Nothing, Tuple, AbstractVector{T} where T, NamedTuple}, firstmulticol::Val, idx_agg::Union{Nothing, AbstractVector{var"#s249"} where var"#s249"<:Integer}) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/complextransforms.jl:21
```

with implementation

```julia
function _combine_with_first(first::Union{NamedTuple, DataFrameRow, AbstractDataFrame},
                             f::Base.Callable, gd::GroupedDataFrame,
                             incols::Union{Nothing, AbstractVector, Tuple, NamedTuple},
                             firstmulticol::Val, idx_agg::Union{Nothing, AbstractVector{<:Integer}})
    extrude = false

    if first isa AbstractDataFrame
        n = 0
        eltys = eltype.(eachcol(first))
    elseif first isa NamedTuple{<:Any, <:Tuple{Vararg{AbstractVector}}}
        n = 0
        eltys = map(eltype, first)
    elseif first isa DataFrameRow
        n = length(gd)
        eltys = [eltype(parent(first)[!, i]) for i in parentcols(index(first))]
    elseif firstmulticol == Val(false) && first[1] isa Union{AbstractArray{<:Any, 0}, Ref}
        extrude = true
        first = wrap_row(first[1], firstmulticol)
        n = length(gd)
        eltys = (typeof(first[1]),)
    else # other NamedTuple giving a single row
        n = length(gd)
        eltys = map(typeof, first)
        if any(x -> x <: AbstractVector, eltys)
            throw(ArgumentError("mixing single values and vectors in a named tuple is not allowed"))
        end
    end
    idx = isnothing(idx_agg) ? Vector{Int}(undef, n) : idx_agg
    local initialcols
    let eltys=eltys, n=n # Workaround for julia#15276
        initialcols = ntuple(i -> Tables.allocatecolumn(eltys[i], n), _ncol(first))
    end
    targetcolnames = tuple(propertynames(first)...)
    if !extrude && first isa Union{AbstractDataFrame,
                                   NamedTuple{<:Any, <:Tuple{Vararg{AbstractVector}}}}
        outcols, finalcolnames = _combine_tables_with_first!(first, initialcols, idx, 1, 1,
                                                             f, gd, incols, targetcolnames,
                                                             firstmulticol)
    else
        outcols, finalcolnames = _combine_rows_with_first!(first, initialcols, 1, 1,
                                                           f, gd, incols, targetcolnames,
                                                           firstmulticol)
    end
    return idx, outcols, collect(Symbol, finalcolnames)
end
```

Obviously, it helps if you know something about the internals of the package, which we, the authors of this blog post, do not.   But even if you are as naive as we are, you can pretty quickly discover a couple of key points.
First, note that this method isn't entirely trivial; size alone is a (very rough) predictor of the cost of inference, and at nearly 50 lines this seems likely to be a method worth optimizing.  (Conversely, 1-line methods rarely require the kind of attention we're giving to `_combine_with_first`, unless there is extensive inlining.)  Second, there are several arguments that might be specialized on:

- two arguments (`first` and `incols`) could potentially be `NamedTuple`s, and since `(x=1,)` and `(y=1,)` are different `NamedTuple` types, these arguments alone have potentially-huge possibility for specialization.  (If these are specialized for the particular column names in a DataFrame, then the scope for specialization is essentially limitless.) Indeed, a check `methodinstances(DataFrames._combine_with_first)` reveals that many of these specializations are for different `NamedTuple`s.

- the `f::Base.Callable` argument is either a function or a type, again a potentially-limitless source of specialization. However, checking the output of `methodinstances`, you'll see that this argument is not specialized.  Presumably this is due to the major callers of `_combine_with_first` using a `@nospecialize` on their corresponding argument.  In this case, over-specialization does not seem to be a concern, but generally speaking function or type arguments are prime candidates for risk of over-specialization.

Some strategies, like adding `@nospecialize`s, might be effective in reducing compile-time cost.  But without knowing a lot more about this package, it is difficult to know whether this might have undesirable effects on runtime performance.  So here we pursue a different strategy: let's focus on the fact that inference has to be performed for each unique combination of input types.  Since we have two highly-diverse argument types, the effect is essentially *multiplicative*.  But we also note that `incols` is just "passed through"; while we might want to preserve this type information, specializing on `incols` does not affect any portion of the body of this method other than the final calls to `_combine_tables_with_first!` or `_combine_rows_with_first!`.  Consequently, we may be wasting a lot of time specializing code that doesn't actually change dependening on the type of `incols`.

Taking advantage of this observation, let's split the "prelude"--everything before `incols` gets used--out into a separate method:

```julia
function _combine_with_first(first::Union{NamedTuple, DataFrameRow, AbstractDataFrame},
                             f::Base.Callable, gd::GroupedDataFrame,
                             incols::Union{Nothing, AbstractVector, Tuple, NamedTuple},
                             firstmulticol::Val, idx_agg::Union{Nothing, AbstractVector{<:Integer}})
    n, eltys, extrude, idx, initialcols, targetcolnames = _combine_with_first_prelude(first, f, gd, firstmulticol, idx_agg)
    if !extrude && first isa Union{AbstractDataFrame,
                                   NamedTuple{<:Any, <:Tuple{Vararg{AbstractVector}}}}
        outcols, finalcolnames = _combine_tables_with_first!(first, initialcols, idx, 1, 1,
                                                             f, gd, incols, targetcolnames,
                                                             firstmulticol)
    else
        outcols, finalcolnames = _combine_rows_with_first!(first, initialcols, 1, 1,
                                                           f, gd, incols, targetcolnames,
                                                           firstmulticol)
    end
    return idx, outcols, collect(Symbol, finalcolnames)
end

function _combine_with_first_prelude(first::Union{NamedTuple, DataFrameRow, AbstractDataFrame},
                                     f::Base.Callable, gd::GroupedDataFrame,
                                     firstmulticol::Val, idx_agg::Union{Nothing, AbstractVector{<:Integer}})
    extrude = false

    if first isa AbstractDataFrame
        n = 0
        eltys = eltype.(eachcol(first))
    elseif first isa NamedTuple{<:Any, <:Tuple{Vararg{AbstractVector}}}
        n = 0
        eltys = map(eltype, first)
    elseif first isa DataFrameRow
        n = length(gd)
        eltys = [eltype(parent(first)[!, i]) for i in parentcols(index(first))]
    elseif firstmulticol == Val(false) && first[1] isa Union{AbstractArray{<:Any, 0}, Ref}
        extrude = true
        first = wrap_row(first[1], firstmulticol)
        n = length(gd)
        eltys = (typeof(first[1]),)
    else # other NamedTuple giving a single row
        n = length(gd)
        eltys = map(typeof, first)
        if any(x -> x <: AbstractVector, eltys)
            throw(ArgumentError("mixing single values and vectors in a named tuple is not allowed"))
        end
    end
    idx = isnothing(idx_agg) ? Vector{Int}(undef, n) : idx_agg
    local initialcols
    let eltys=eltys, n=n # Workaround for julia#15276
        initialcols = ntuple(i -> Tables.allocatecolumn(eltys[i], n), _ncol(first))
    end
    targetcolnames = tuple(propertynames(first)...)

    return n, eltys, extrude, idx, initialcols, targetcolnames
end
```

`_combine_with_first` has to be inferred for all the same argument types as before, but now it is quite short and will hopefully be faster to infer; `_combine_with_first_prelude` should be inferred for fewer argument types, as it omits all the diversity of `incols`, and so we might hope it will take less aggregate time.

While we could make several changes before testing again, for the purposes of learning it's worth knowing the impact of each change.  In this particular case, we can assess the impact by running just the `"grouping.jl"` tests.  Let's compare the results for this specific test: before our changes, we had

```julia
julia> using DataFrames; tinf = @snoopi_deep include("grouping.jl");

julia> tm = accumulate_by_method(flatten_times(tinf))
4587-element Vector{Pair{Float64, Method}}:
                    ⋮
  6.247620940999997 => var"#_combine_prepare#473"(keepkeys::Bool, ungroup::Bool, copycols::Bool, keeprows::Bool, renamecols::Bool, ::typeof(DataFrames._combine_prepare), gd::GroupedDataFrame, cs::Union{Regex, AbstractString, Function, Signed, Symbol, Unsigned, Pair, AbstractVector{T} where T, Type, All, Between, Cols, InvertedIndex}...) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:21
 11.148180995000015 => _combine_with_first(first::Union{AbstractDataFrame, NamedTuple, DataFrameRow}, f::Union{Function, Type}, gd::GroupedDataFrame, incols::Union{Nothing, Tuple, AbstractVector{T} where T, NamedTuple}, firstmulticol::Val, idx_agg::Union{Nothing, AbstractVector{var"#s249"} where var"#s249"<:Integer}) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/complextransforms.jl:21
      177.799848342 => ROOT() in Core.Compiler.Timings at compiler/typeinfer.jl:75

julia> length(methodinstances(DataFrames._combine_with_first))
624
```

and after we had

```julia
julia> tm = accumulate_by_method(flatten_times(tinf))
⋮
 1.3418041849999998 => _combine_with_first(first::Union{AbstractDataFrame, NamedTuple, DataFrameRow}, f::Union{Function, Type}, gd::GroupedDataFrame, incols::Union{Nothing, Tuple, AbstractVector{T} where T, NamedTuple}, firstmulticol::Val, idx_agg::Union{Nothing, AbstractVector{var"#s249"} where var"#s249"<:Integer}) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/complextransforms.jl:21
 1.3735432279999995 => getindex(df::DataFrame, row_inds::AbstractVector{T}, col_inds::Union{Colon, Regex, AbstractVector{T} where T, All, Between, Cols, InvertedIndex}) where T in DataFrames at /home/tim/.julia/dev/DataFrames/src/dataframe/dataframe.jl:445
 1.4696530570000017 => indexed_iterate(t::Tuple, i::Int64, state) in Base at tuple.jl:86
 2.3362005260000003 => (::DataFrames.var"#_combine_prepare##kw")(::Any, ::typeof(DataFrames._combine_prepare), gd::GroupedDataFrame, cs::Union{Regex, AbstractString, Function, Signed, Symbol, Unsigned, Pair, AbstractVector{T} where T, Type, All, Between, Cols, InvertedIndex}...) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:21
 2.4520451379999986 => iterate(t::Tuple, i::Int64) in Base at tuple.jl:64
  3.669860345999997 => _combine_tables_with_first!(first::Union{AbstractDataFrame, NamedTuple{var"#s249", var"#s248"} where var"#s248"<:Tuple{Vararg{AbstractVector{T} where T, N} where N} where var"#s249"}, outcols::Tuple{Vararg{AbstractVector{T} where T, N}}, idx::Vector{Int64}, rowstart::Integer, colstart::Integer, f::Union{Function, Type}, gd::GroupedDataFrame, incols::Union{Nothing, Tuple, AbstractVector{T} where T, NamedTuple}, colnames::Tuple{Vararg{Symbol, N}}, firstmulticol::Val) where N in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/complextransforms.jl:188
  4.162802701999999 => _combine_with_first_prelude(first::Union{AbstractDataFrame, NamedTuple, DataFrameRow}, f::Union{Function, Type}, gd::GroupedDataFrame, firstmulticol::Val, idx_agg::Union{Nothing, AbstractVector{var"#s249"} where var"#s249"<:Integer}) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/complextransforms.jl:39
 4.4092450299999975 => do_call(f::Union{Function, Type}, idx::AbstractVector{var"#s249"} where var"#s249"<:Integer, starts::AbstractVector{var"#s248"} where var"#s248"<:Integer, ends::AbstractVector{var"#s146"} where var"#s146"<:Integer, gd::GroupedDataFrame, incols::Tuple{AbstractVector{T} where T}, i::Integer) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/callprocessing.jl:91
 6.1610018790000005 => var"#_combine_prepare#473"(keepkeys::Bool, ungroup::Bool, copycols::Bool, keeprows::Bool, renamecols::Bool, ::typeof(DataFrames._combine_prepare), gd::GroupedDataFrame, cs::Union{Regex, AbstractString, Function, Signed, Symbol, Unsigned, Pair, AbstractVector{T} where T, Type, All, Between, Cols, InvertedIndex}...) in DataFrames at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:21
      173.067687099 => ROOT() in Core.Compiler.Timings at compiler/typeinfer.jl:75

julia> length(methodinstances(DataFrames._combine_with_first))
624

julia> length(methodinstances(DataFrames._combine_with_first_prelude))
259
```

Now we have to look quite a ways back in the list to see the cost of `_combine_with_first`, despite having just as many instances as before. Meanwhile, we have fewer than half as many instances of `_combine_with_first_prelude`, for an aggregate cost of 4.16s.  The sum of `5.5s` is much less than the `11.15s` when we started; moreover, notice that the total time for `ROOT` dropped by almost 5s, presumably reflecting an additional decrease in the cost of native code generation.  We saved more than 10s just by moving part of the body out into a separate method.

This strategy can be applied in other places too.  Now, the most expensive method is [`_combine_prepare`](https://github.com/JuliaData/DataFrames.jl/blob/86a5ee6cbb539096ef012b790ea16c518b7536f5/src/groupeddataframe/splitapplycombine.jl#L21-L111) (technically, the "body method" `#_combine_prepare#473` that Julia automatically generates to do the work of the method once all keyword arguments have been assigned; note also the `var"#_combine_prepare##kw"` just a bit higher up, which is the keyword-filling portion of this method).  If we look at `methodinstances(DataFrames.var"#_combine_prepare#473")`, we see lots of specializations on the final `cs` argument(s).  However, the source code is annotated `@nospecialize`, so all this inference specialization may initially be a surprise.[[†](#footnote1)]   We can save this cost by noting that `cs` is only used to construct `cs_vec`, and consequently splitting it into

```julia
function _combine_prepare(gd::GroupedDataFrame,
                          @nospecialize(cs::Union{Pair, Base.Callable,
                                        ColumnIndex, MultiColumnIndex}...);
                          keepkeys::Bool, ungroup::Bool, copycols::Bool,
                          keeprows::Bool, renamecols::Bool)
    if !ungroup && !keepkeys
        throw(ArgumentError("keepkeys=false when ungroup=false is not allowed"))
    end

    cs_vec = []
    for p in cs
        if p === nrow
            push!(cs_vec, nrow => :nrow)
        elseif p isa AbstractVecOrMat{<:Pair}
            append!(cs_vec, p)
        else
            push!(cs_vec, p)
        end
    end
    return _combine_prepare(gd, cs_vec, keepkeys, ungroup, copycols, keeprows, renamecols)
end

function _combine_prepare(gd::GroupedDataFrame,
                          cs_vec::Vector{Any},
                          keepkeys::Bool, ungroup::Bool, copycols::Bool,
                          keeprows::Bool, renamecols::Bool)
    if any(x -> x isa Pair && first(x) isa Tuple, cs_vec)
...
```

eliminates most of the inference time.

These and a few other similar changes reduced `@time include("grouping.jl")` in a fresh session by nearly 15%, from 283s to 248s.  In general, reducing argument type-diversity in long methods is one of the easiest ways to reduce latency.  Here we've handled this just by splitting methods; if we had a deeper understanding of the package internals, we might consider more extensive refactoring that reduces the diversity at an earlier stage of the call chain and yields even greater benefits.  In either case, the new `@snoopi_deep` makes it easy to discover which methods would benefit most from this kind of treatment.

## Strategy #2: inspecting and addressing inference failures

Some calls produce a result with unpredictable type, and thus to an inference "failure."  Such failures can be roughly divided into "avoidable" and "unavoidable" failures.  An example of an "unavoidable" failure might be `data = load("myfile.ext")`, where the type of `data` depends on the contents of `"myfile.ext"`--there is no plausible way for inference to know what type to expect of `data`.  In cases like these, it is expected that any calls made to process `data` will have to be made by *runtime dispatch*, in which execution is paused to ask `data` for its type and then search the method tables for compatible methods.

In constrast, some types of inference failure are avoidable. For example, in
```julia
s = []
push!(s, 1, 2)
sum(s)
```
an inference failure in the `sum` could have been avoided by defining `s = Int[]` rather than `s = []`.

In real-world circumstances, you're likely to encounter a mixture of avoidable and unavoidable failures.  Fortunately, it will turn out to be possible to make progress with both types.

### Identifying inference failures

In addition to its ability to measure inference time for each method, the new `@snoopi_deep` also introduces a new capability that makes identifying inference failures easier than ever: while snooping, inference collects a [backtrace] upon each new (runtime) entrance into inference.  This makes it possible to discover the caller that triggered runtime dispatch, thus identifying the method and call that fails to infer.  When a package is well-inferred, most of these entrances come from toplevel (the commands you issue in the REPL, or inside a `@testset`), but by default these are excluded from SnoopCompile's reports; the goal is to identify internal, hopefully-avoidable inference failures.

Let's apply this to DataFrames. After collecting the data with `@snoopi_deep include("runtests.jl")`, we can see inference failures with

```julia
julia> ibs = SnoopCompile.inference_breaks(tinf)
14812-element Vector{SnoopCompile.InferenceBreak}:
 Inference break costing 1.6178e-5s: dispatch MethodInstance for ismissing(::GroupedDataFrame{DataFrame}) from _pretty_tables_highlighter_func at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/prettytables.jl:14
 ⋮
 Inference break costing 0.818058154s: dispatch MethodInstance for (::Base.var"#show##kw")(::NamedTuple{(:allrows, :allcols, :allgroups, :rowlabel, :summary, :truncate), Tuple{Bool, Bool, Bool, Symbol, Bool, Int64}}, ::typeof(show), ::Base.PipeEndpoint, ::GroupedDataFrame{DataFrame}) from precompile at ./essentials.jl:470
 Inference break costing 1.061462398s: dispatch MethodInstance for do_call(::ComposedFunction{typeof(Statistics.std), typeof(skipmissing)}, ::Vector{Int64}, ::Vector{Int64}, ::Vector{Int64}, ::GroupedDataFrame{DataFrame}, ::Tuple{Vector{Matrix{Float64}}}, ::Int64) from _combine_process_pair at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:463
 Inference break costing 1.651674066s: dispatch MethodInstance for precompile(::Bool) from precompile at /home/tim/.julia/dev/DataFrames/src/other/precompile.jl:16
 Inference break costing 2.03736002s: dispatch MethodInstance for show(::IOBuffer, ::DataFrameRow{DataFrame, DataFrames.SubIndex{DataFrames.Index, UnitRange{Int64}, UnitRange{Int64}}}) from #sprint#383 at ./strings/io.jl:105
```

Each line of this display corresponds to a single inference failure, sorted by the cost (in seconds) of the complete recursive inference run after the break.  After the time, the first portion shows the `MethodInstance` that got executed by runtime dispatch; after "from" it shows the calling method (the one with the inference failure that forced runtime dispatch) and its file:line location. (Because this can be a bit complex, in a REPL session SnoopCompile applies different coloration to the separate portions of this output, but that color doesn't reproduce here.)

### A spurious "inference failure" that can be addressed by precompilation

From the last entry, we would rightly conclude that inferring `show` for a `DataFrameRow` can be quite expensive, almost 2s! Does this correspond to an internal inference failure? Let's extract this element and see:

```julia
julia> ib = ibs[end]
Inference break costing 2.03736002s: dispatch MethodInstance for show(::IOBuffer, ::DataFrameRow{DataFrame, DataFrames.SubIndex{DataFrames.Index, UnitRange{Int64}, UnitRange{Int64}}}) from #sprint#383 at ./strings/io.jl:105

julia> stacktrace(ib.bt)
32-element Vector{Base.StackTraces.StackFrame}:
 exit_current_timer at typeinfer.jl:166 [inlined]
 typeinf(interp::Core.Compiler.NativeInterpreter, frame::Core.Compiler.InferenceState) at typeinfer.jl:208
 typeinf_ext(interp::Core.Compiler.NativeInterpreter, mi::Core.MethodInstance) at typeinfer.jl:835
 typeinf_ext_toplevel(interp::Core.Compiler.NativeInterpreter, linfo::Core.MethodInstance) at typeinfer.jl:868
 typeinf_ext_toplevel(mi::Core.MethodInstance, world::UInt64) at typeinfer.jl:864
 sprint(f::Function, args::DataFrameRow{DataFrame, DataFrames.SubIndex{DataFrames.Index, UnitRange{Int64}, UnitRange{Int64}}}; context::Nothing, sizehint::Int64) at io.jl:105
 sprint(f::Function, args::DataFrameRow{DataFrame, DataFrames.SubIndex{DataFrames.Index, UnitRange{Int64}, UnitRange{Int64}}}) at io.jl:101
 macro expansion at dataframerow.jl:434 [inlined]
 macro expansion at Test.jl:1146 [inlined]
 top-level scope at dataframerow.jl:409
 eval at boot.jl:360 [inlined]
 include_string(mapexpr::typeof(identity), mod::Module, code::String, filename::String) at loading.jl:1089
 ⋮
```

The first few lines correspond to inference itself, including the timing and backtrace collection performed by `@snoopi_deep`. The first "real" entry here is for `sprint`, a `Base` function and method. Does that mean that `sprint` has an inference problem? If we look just a little further in the stacktrace, we see this came from line 434 in a "macro expansion" of `"dataframerow.jl"`, which is the name of one of DataFrames' test files and corresponds to

```julia
@test sprint(show, dfr) == """
      ⋮
```

This indicates that this isn't a true inference failure in the package; SnoopCompile's filter that excludes calls coming directly from the test suite was defeated by the fact `show` was executed via `sprint`. Might we still consider adding a `precompile` directive to our package, so that we don't have to pay this cost in each session? Let's see if we own the method:

```julia
julia> ib.it.mi_info.mi.def
show(io::IO, dfr::DataFrameRow; allcols, rowlabel, eltypes, truncate, kwargs...) in DataFrames at /home/tim/.julia/dev/DataFrames/src/dataframerow/show.jl:1
```

so indeed the method is defined within `DataFrames`.  If we were to add a `precompile` directive for this `MethodInstance`, we can expect it to succeed in reducing latency.

We've identified one place where we could reduce compiler latency by adding a precompile directive, but we could have discovered this with older tools like `@snoopi`.
Let's do a little further analysis to get something that's only easily discovered via `@snoopi_deep`.

### An example with an unavoidable inference failure: more opportunities to reduce specialization

As with `flatten_times` above, it's helpful to simplify these results by combining similar items, this time combining inference failures that come from the same source location:

```julia
julia> libs = accumulate_by_callsite(ibs)
814-element Vector{Pair{Float64, SnoopCompile.LocationBreaks}}:
            4.4337e-5 => typeinfo_prefix at ./arrayshow.jl:536 (1 instances)
                      ⋮
    3.057783997999998 => collect at ./array.jl:669 (756 instances)
   3.2925309560000007 => _combine_process_agg at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:213 (366 instances)
    3.347522272000001 => iterate at ./generator.jl:47 (524 instances)
   3.9274885120000005 => #groupby#270 at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/groupeddataframe.jl:199 (108 instances)
    5.153102519000001 => precompile at ./essentials.jl:470 (248 instances)
          9.494128427 => _combine_process_pair at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:469 (177 instances)
   12.543704604999991 => _combine_process_pair at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:463 (963 instances)
```

Once again, we get a quite different picture: now [`_combine_process_pair`](https://github.com/timholy/DataFrames.jl/blob/66feddffe6069571aac3c6e0c78479cf587e2a84/src/groupeddataframe/splitapplycombine.jl#L443-L477) sticks out as a particularly-expensive source of inference failure.

Let's see if we can fix it. First, we extract the last item and then collect some instances of that method:

```julia
julia> lib = libs[end]
12.543704604999991 => _combine_process_pair at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:463 (963 instances)

julia> lb = lib.second
_combine_process_pair at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:463 (963 instances)

julia> lb.ibs
963-element Vector{SnoopCompile.InferenceBreak}:
 Inference break costing 0.000130878s: dispatch MethodInstance for do_call(::Main.TestGrouping.var"#396#404", ::Vector{Int64}, ::Vector{Int64}, ::Vector{Int64}, ::GroupedDataFrame{DataFrame}, ::Tuple{}, ::Int64) from _combine_process_pair at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:463
 ⋮
 Inference break costing 1.061462398s: dispatch MethodInstance for do_call(::ComposedFunction{typeof(Statistics.std), typeof(skipmissing)}, ::Vector{Int64}, ::Vector{Int64}, ::Vector{Int64}, ::GroupedDataFrame{DataFrame}, ::Tuple{Vector{Matrix{Float64}}}, ::Int64) from _combine_process_pair at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/splitapplycombine.jl:463
```

As expected from the source line of `DataFrames/src/groupeddataframe/splitapplycombine.jl:463`, all of these are calls to `do_call`; we can collect all the unique `MethodInstance`s with `umis = unique(ib.it.mi_info.mi for ib in lb.ibs)`, for which we get 959 separate instances.  How many instances of the caller are there?

```
julia> mis = collect_instances(lb, tinf)
3-element Vector{Core.MethodInstance}:
 MethodInstance for _combine_process_pair(::Pair, ::Bool, ::DataFrame, ::GroupedDataFrame{DataFrame}, ::Dict{Symbol, Tuple{Bool, Int64}}, ::Vector{DataFrames.TransformationResult}, ::Vector{Int64})
 MethodInstance for _combine_process_pair(::Pair, ::Bool, ::DataFrame, ::GroupedDataFrame{DataFrame}, ::Dict{Symbol, Tuple{Bool, Int64}}, ::Vector{DataFrames.TransformationResult}, ::Nothing)
 MethodInstance for _combine_process_pair(::Pair, ::Bool, ::DataFrame, ::GroupedDataFrame{DataFrame}, ::Dict{Symbol, Tuple{Bool, Int64}}, ::Vector{DataFrames.TransformationResult}, ::Union{Nothing, AbstractVector{Int64}})
```

Just 3! This suggests that `_combine_process_pair` is a huge source of expansion in type-diversity.  This often happens if, for example, you extract elements from a `Vector{Any}` or `Dict{String,Any}`; the container is a single type, but the values it stores could be of very diverse types.  When you have external knowledge that there are only a limited number of possibilities, you might fix it with the [ManualDispatch] package.  In this case, even if we ignore the diversity of [`fun`](https://github.com/timholy/DataFrames.jl/blob/66feddffe6069571aac3c6e0c78479cf587e2a84/src/groupeddataframe/splitapplycombine.jl#L464-L465), it's still pretty high:

```julia
# The first parameter in specTypes is do_call, and the second is the `fun` type; for this analysis, we skip these
julia> length(unique(Base.unwrap_unionall(mi.specTypes).parameters[3:end] for mi in umis))
52
```
Most of that diversity comes from the [`incols` argument](https://github.com/timholy/DataFrames.jl/blob/66feddffe6069571aac3c6e0c78479cf587e2a84/src/groupeddataframe/splitapplycombine.jl#L464-L465); if we exclude that parameter as well,
```julia
julia> unique(Base.unwrap_unionall(mi.specTypes).parameters[[3,4,5,6,8]] for mi in umis)
2-element Vector{Core.SimpleVector}:
 svec(Vector{Int64}, Vector{Int64}, Vector{Int64}, GroupedDataFrame{DataFrame}, Int64)
 svec(Vector{Int64}, UnitRange{Int64}, UnitRange{Int64}, GroupedDataFrame{DataFrame}, Int64)
```
these two types could be handled by manual dispatch.

Given that `do_call` isn't annotated with `@nospecialize`, we might guess that it is a performance hotspot. It would take a bit more understanding of the internals of this package to really come up with a good solution, but let's experiment a bit.  We open the `"groupeddataframe/callprocessing.jl"` source file, which contains all the implementations of `do_call`, and duplicate them while changing the name to `do_call_unspecialized`, and then adding `@nospecialize` around the `f` (equivalent to `fun` in `_combine_process_pair`) and `incols`.  We then modify `_combine_process_pair` to call `do_call_unspecialize` instead of `do_call`.

For the inference breaks that occur at line 469, just to illustrate a slightly different approach we change `_combine_process_pair_symbol` and `_combine_process_pair_astable` so that they have `@nospecialize` around all of the three final arguments (`fun` already had a `@nospecialize`, but the other two did not).  We don't know for sure whether this is a good idea, but we can always submit a pull request and let the maintainers decide.

Since all, or almost all of these calls again came from the `"grouping.jl"` test, let's time the result in a fresh session:

```julia
julia> using DataFrames; @time include("grouping.jl")
...
224.375223 seconds (502.20 M allocations: 29.593 GiB, 3.69% gc time, 95.47% compilation time)
```

Since previously we were at 248s, we've shaved another 10% off the total time of this test. Whether this is really a good idea will require input from someone who really knows the package internals well.

### Identifying and fixing avoidable inference failures

Now we focus on "avoidable" failures, cases in which code is written in a way that defeats inference. Our goal here will be to identify and fix such failures.  It should be acknowledged at the outset that *fixing inference failures is not guaranteed to reduce compiler latency*, and indeed there is a chance that it could increase compilation time by allowing for more aggressive specialization.  That said, there are good reasons to consider fixing inference problems:

- inference with abstract types generally takes more time than inference with concrete types, so by helping inference succeed you may speed it up
- inference failures almost always hurt runtime performance
- inference failures leave your package more vulnerable to [invalidation][invalidations], which can result in very high latency costs due to recompilation of previously-compiled methods
- inference failures break the chain of precompilation. If you don't own the method (if it is not defined in your package) that gets executed after the break, you can't directly precompile it (a `precompile` directive will have no impact, because Julia doesn't know where to store the result). In contrast, inferrable calls introduce "backedges" that link the precompiled MethodInstance to your package and allow it to be cached in your package's precompiled `*.ji` file.

Before tackling this problem more generally, let's look at a specific case that, in the authors' experience, comes up in many packages.

#### The case of `collect` (and usage of `callingframe`)

If you look above where `accumulate_by_callsite` was first introduced, you'll notice an entry for `Base`'s `collect` function.  Let's extract that entry to `lib` and look at where some of these breaks in inference came from:

```julia
julia> lb = lib.second
collect at ./array.jl:669 (756 instances)

julia> accumulate_by_callsite(callingframe.(lb.ibs))
26-element Vector{Pair{Float64, SnoopCompile.LocationBreaks}}:
          0.002334037 => #describe#61 at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/abstractdataframe.jl:569 (1 instances)
          0.003319698 => #filter#84 at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/abstractdataframe.jl:1017 (1 instances)
          0.003351513 => #filter#91 at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/abstractdataframe.jl:1030 (1 instances)
          0.003359164 => #filter#79 at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/abstractdataframe.jl:1004 (1 instances)
          0.003822701 => #_print_info#58 at /home/tim/.julia/packages/PrettyTables/W16qB/src/private.jl:215 (1 instances)
          0.003901159 => _expand_to_table at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/selection.jl:384 (2 instances)
          0.003985022 => do_call_unspecialized at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/callprocessing.jl:197 (1 instances)
          0.004036144 => do_call at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/callprocessing.jl:85 (1 instances)
           0.00404644 => do_call at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/callprocessing.jl:131 (1 instances)
          0.004112145 => #_pt_text#96 at /home/tim/.julia/packages/PrettyTables/W16qB/src/backends/text/print.jl:127 (1 instances)
          0.004178041 => do_call_unspecialized at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/callprocessing.jl:151 (1 instances)
 0.007789356999999999 => _describe at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/abstractdataframe.jl:593 (2 instances)
          0.008026907 => _unstack at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/reshape.jl:395 (2 instances)
 0.012170741999999998 => #DataFrame#658 at /home/tim/.julia/dev/DataFrames/src/other/tables.jl:51 (5 instances)
 0.014518023000000001 => _combine_with_first_prelude at /home/tim/.julia/dev/DataFrames/src/groupeddataframe/complextransforms.jl:52 (7 instances)
 0.016908285000000002 => #crossjoin#442 at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/join.jl:1293 (8 instances)
 0.017022008999999998 => _describe at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/abstractdataframe.jl:639 (8 instances)
 0.024877225000000003 => map at ./abstractarray.jl:2311 (4 instances)
 0.026061234000000003 => collect at /home/tim/.julia/packages/InvertedIndices/l2dyo/src/InvertedIndices.jl:60 (2 instances)
          0.034342234 => #_stackview#458 at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/reshape.jl:185 (6 instances)
          0.045933587 => #stack#449 at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/reshape.jl:162 (15 instances)
          0.053632256 => #_pt_text#96 at /home/tim/.julia/packages/PrettyTables/W16qB/src/backends/text/print.jl:120 (2 instances)
  0.11374774800000001 => schema at /home/tim/.julia/dev/DataFrames/src/other/tables.jl:24 (14 instances)
          0.181136655 => eval at ./boot.jl:360 (47 instances)
  0.26616912000000004 => #manipulate#399 at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/selection.jl:1311 (114 instances)
   2.2469492800000004 => #manipulate#394 at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/selection.jl:1209 (510 instances)
```

`callingframe` is another convenient new tool in SnoopCompile that lets you advance the apparent caller by one Julia frame; using this, we hope to rise out of `Base.collect` itself and into whatever method (perhaps in DataFrames) called it.  From this, we see that by far the dominant contribution comes from a single site in `"selection.jl"`.  Here's a section of that code:

```julia
function manipulate(df::DataFrame, @nospecialize(cs...); copycols::Bool, keeprows::Bool, renamecols::Bool)
    cs_vec = []
    for v in cs
        if v isa AbstractVecOrMat{<:Pair}
            append!(cs_vec, v)
        else
            push!(cs_vec, v)
        end
    end
    return _manipulate(df, [normalize_selection(index(df), c, renamecols) for c in cs_vec],      # this is line 1209
                    copycols, keeprows)
end

function _manipulate(df::AbstractDataFrame, @nospecialize(normalized_cs), copycols::Bool, keeprows::Bool)
```

On line 1209, we see a comprehension, and this is one of the common sources for non-inferrable calls to `collect`.  Why does this yield an inference break? We see that `cs_vec` is a `Vector{Any}`, and consequently the result type of the call to `normalize_selection` can't be inferrable.  Consequently the call is made by runtime dispatch.

While there are some circumstances where it makes sense to allow this to be made by runtime dispatch, in the majority of cases it's recommended to annotate the container eltype.  Everything about this code, including the `@nospecialize` in `_manipulate`, indicates that this is a section of code that has to deal with unavoidable type diversity, so we'll pick `Any` as the container type. Our changes are shown in the following `diff`:

```diff
diff --git a/src/abstractdataframe/selection.jl b/src/abstractdataframe/selection.jl
index df58ac2c..07f29bd5 100644
--- a/src/abstractdataframe/selection.jl
+++ b/src/abstractdataframe/selection.jl
@@ -1206,11 +1206,11 @@ function manipulate(df::DataFrame, @nospecialize(cs...); copycols::Bool, keeprow
             push!(cs_vec, v)
         end
     end
-    return _manipulate(df, [normalize_selection(index(df), c, renamecols) for c in cs_vec],
+    return _manipulate(df, Any[normalize_selection(index(df), c, renamecols) for c in cs_vec],
                     copycols, keeprows)
 end

-function _manipulate(df::AbstractDataFrame, @nospecialize(normalized_cs), copycols::Bool, keeprows::Bool)
+function _manipulate(df::AbstractDataFrame, normalized_cs::Vector{Any}, copycols::Bool, keeprows::Bool)
     @assert !(df isa SubDataFrame && copycols==false)
     newdf = DataFrame()
     # the role of transformed_cols is the following
@@ -1308,7 +1308,7 @@ function manipulate(dfv::SubDataFrame, @nospecialize(args...); copycols::Bool, k
                 push!(cs_vec, v)
             end
         end
-        return _manipulate(dfv, [normalize_selection(index(dfv), c, renamecols) for c in cs_vec],
+        return _manipulate(dfv, Any[normalize_selection(index(dfv), c, renamecols) for c in cs_vec],     # this is line 1311, see above
                            true, keeprows)
     else
         # we do not support transformations here
```

First, we changed `[normalize_...]` to `Any[normalize_...]`; this prevents Julia from even trying to figure out the result type, and results in a predictable `Vector{Any}` result type for the comprehension.  Second, given that `Vector{Any}` is a concrete type, we can remove the `@nospecialize` from `_manipulate`; this can be quite helpful, because now calls like `length(normalized_cs)` will be inferrable whereas before they were not.  Finally, to "lock in" these improvements we added a `::Vector{Any}` type annotation to `normalized_cs`, and fixed any other callers in DataFrames that might otherwise have been broken by this change---and this ended up addressing the call on line 1311 that was the second-most costly non-inferrable caller of `collect`.

When the eltype of a comprehension is inferrable, it's often best to let Julia infer it; but when you know that you're dealing with an inherently non-inferrable case, it's a great idea to specify the eltype directly.  Fortunately, you don't have to be paranoid about remembering to do so, because `@snoopi_deep` lets you easily discover any important cases you may have missed.

While none of the other `collect` call sites have anywhere near the impact of this one, while we're here it's not a bad idea to try to fix them.  Briefly, here's a summary of looking into some of these:

- the `eval` is unfixable---one can guess right away that these are called directly from the test suite
- `schema` is a case where it appears the intent is to deliberately re-introduce a parametrized type for dispatch--very unlikely to be fixable unless one were to reconsider the entire strategy. There are likely very good reasons the authors chose to do this, and at less than 0.2s of inference time the scope for improvement is modest
- `#_pt_text#96` is in the PrettyTables package, not DataFrames, so let's ignore it for now
- `#stack#449` can be fixed by adding another `AbstractVector` to the [inner comprehension](https://github.com/JuliaData/DataFrames.jl/blob/2d0413a018e2647042bcb596916b73cbdd703bc3/src/abstractdataframe/reshape.jl#L162)
- `#_stackview#458` has the same fix as `#stack#449`
- `collect` and `map` are from the InvertedIndices package and Base respectively, so again let's skip these for now
- `_describe` proves to be a case in which we could fix some inference problems in the code mostly unrelated to `collect`. Therefore, we'll stop here and treat that in the next section.

#### Fixing avoidable inference problems

`_describe` showed up in our previous analysis of `collect`. While 17ms is not a lot of time, perhaps `collect` isn't the only function it dispatches to:

```julia
julia> filter(libs) do lib
           lib.second.loc.func === :_describe
       end
2-element Vector{Pair{Float64, SnoopCompile.LocationBreaks}}:
            0.0017508 => _describe at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/abstractdataframe.jl:585 (1 instances)
 0.025253789999999998 => _describe at /home/tim/.julia/dev/DataFrames/src/abstractdataframe/abstractdataframe.jl:639 (8 instances)
```

27ms is a little better, but it's still not a lot of time; while there's every reason to hope we could improve `_describe`, we're looking for the big fish, and this clearly isn't one of them. Because the DataFrames developers are very good at their job, we have to go a long ways back, almost 40 entries, in `libs` before we get to a candidate that can be substantially improved:

```
julia> lib
0.6566298570000001 => #_vcat#124 at /home/tim/.julia/packages/DataFrames/Zx5mm/src/abstractdataframe/abstractdataframe.jl:1625 (23 instances)

julia> mis = collect_instances(lib.second, tinf)
10-element Vector{Core.MethodInstance}:
 MethodInstance for var"#_vcat#124"(::Symbol, ::typeof(DataFrames._vcat), ::AbstractVector{var"#s17"} where var"#s17"<:AbstractDataFrame)
 MethodInstance for var"#_vcat#124"(::Symbol, ::typeof(DataFrames._vcat), ::Vector{AbstractDataFrame})
 MethodInstance for var"#_vcat#124"(::Symbol, ::typeof(DataFrames._vcat), ::Vector{T} where T<:AbstractDataFrame)
 MethodInstance for var"#_vcat#124"(::Symbol, ::typeof(DataFrames._vcat), ::Vector{DataFrame})
 MethodInstance for var"#_vcat#124"(::Symbol, ::typeof(DataFrames._vcat), ::Vector{SubDataFrame{DataFrame, DataFrames.Index, Vector{Int64}}})
 MethodInstance for var"#_vcat#124"(::Symbol, ::typeof(DataFrames._vcat), ::Vector{SubDataFrame{DataFrame, S, UnitRange{Int64}} where S<:DataFrames.AbstractIndex})
 MethodInstance for var"#_vcat#124"(::Vector{String}, ::typeof(DataFrames._vcat), ::AbstractVector{var"#s17"} where var"#s17"<:AbstractDataFrame)
 MethodInstance for var"#_vcat#124"(::Vector{String}, ::typeof(DataFrames._vcat), ::Vector{DataFrame})
 MethodInstance for var"#_vcat#124"(::Vector{Symbol}, ::typeof(DataFrames._vcat), ::AbstractVector{var"#s17"} where var"#s17"<:AbstractDataFrame)
 MethodInstance for var"#_vcat#124"(::Vector{Symbol}, ::typeof(DataFrames._vcat), ::Vector{DataFrame})
```

This is a relatively small number (10) of calling `MethodInstance`s, and relatively few runtime-dispatched instances (23), so this might suggest one or more steps where inference is just having a hard time figuring out a type that could be made predictable.  We extract any one of these `MethodInstance`s and fire up [Cthulhu] :

```julia
julia> using Cthulhu

julia> descend(mis[1]; iswarn=true, optimize=false)
```

If you've not used Cthulhu before, it's a wonderful tool; there's a video [here](https://www.youtube.com/watch?v=7VbXbI6OmYo) which (starting at minute 7) is essentially a Cthulhu tutorial.  Cthulhu will tell you, for instance, that `header` is a `Core.Box`, and in part the code `cols` is a `Union{Vector{String}, Core.Box}`.  This is typically a sign of the infamous [Julia issue 15276][julia15276], and workarounds are documented [here](https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-captured).  Specifically, changing [this line](https://github.com/JuliaData/DataFrames.jl/blob/8645651e30785fbedca82a9f125d21d1f27a726e/src/abstractdataframe/abstractdataframe.jl#L1589) to

```julia
let header=header     # julia #15276
    filter!(u -> !issetequal(u, header), uniqueheaders)
end
```

fixes the first `Core.Box`, and renaming [this `cols`](https://github.com/JuliaData/DataFrames.jl/blob/8645651e30785fbedca82a9f125d21d1f27a726e/src/abstractdataframe/abstractdataframe.jl#L1593-L1595) to `badcols` fixes the second.  The only other easily-fixable case is that [this usage](https://github.com/JuliaData/DataFrames.jl/blob/8645651e30785fbedca82a9f125d21d1f27a726e/src/abstractdataframe/abstractdataframe.jl#L1563) of `names` is not inferrable for an `AbstractDataFrame`, but changing [this line](https://github.com/JuliaData/DataFrames.jl/blob/8645651e30785fbedca82a9f125d21d1f27a726e/src/other/index.jl#L425) to

```julia
Base.names(x::SubIndex) = string.(_names(x))::Vector{String}
```

fixes that. All of these are quite easily discoverable via Cthulhu.

## Final results

Let's check and see how much of an overall improvement the changes have made:

```julia
julia> using DataFrames; @time include("runtests.jl")
⋮
571.898755 seconds (1.04 G allocations: 60.339 GiB, 3.40% gc time, 96.14% compilation time)
```

Compared to where we started (almost 621s), this shaves almost a minute off the time to run the test suite.
Even the second run is faster now:

```julia
julia> @time include("runtests.jl")
⋮
196.870680 seconds (276.72 M allocations: 16.498 GiB, 2.65% gc time, 87.12% compilation time)
```

which is 40s less than the original (a savings of approximately 16%).

This is certainly not everything we *could* do on the package, but it's enough to illustrate some of the main strategies for improving latency.  Someone who understood the internals well might reject these changes, and instead make them at higher levels and obtain even greater benefits. But this should illustrate the different tools, considerations, and techniques for improving latency in packages.

## Conclusions

Latency ("first time to plot") is one of the most common complaints for users of Julia. Using the soon-to-be-released Julia 1.6 and new capabilities of the SnoopCompile package, it's easier than ever to diagnose and fix sources of latency.  Here, we've emphasized reducing specialization, simplifying methods that need many specializations, and fixing inference failures as techniques for reducing latency.  We've not strongly emphasized precompilation (that has existed for quite a while now), but it should not be ignored by developers looking to reduce latency.  Indeed, the strategies we explored here should extract more benefit from precompilation: by fixing inference problems we can precompile more code, and by reducing type-diversity some portions of code that were not practical to precompile previously may suddenly become worthy of precompilation.  These changes can immediately improve the user experience.  Moreover, if a future version of Julia delivers native-code precompilation, these same changes will allow packages to exploit it to its fullest.  These new tools, arriving in Julia 1.6, give a far richer understanding of how a large code base is viewed from the standpoint of the compiler.


[Julia]: https://julialang.org/
[SnoopCompile]: https://github.com/timholy/SnoopCompile.jl
[`precompile`]: https://docs.julialang.org/en/v1/base/base/#Base.precompile
[PackageCompiler]: https://github.com/JuliaLang/PackageCompiler.jl
[Type inference]: https://docs.julialang.org/en/v1/devdocs/eval/#dev-type-inference
[`@nospecialize`]: https://docs.julialang.org/en/v1/base/base/#Base.@nospecialize
[DataFrames]: https://github.com/JuliaData/DataFrames.jl
[CategoricalArrays]: https://github.com/JuliaData/CategoricalArrays.jl
[invalidations]: https://julialang.org/blog/2020/08/invalidations/
[nightly]: https://julialang.org/downloads/#nightly_builds
[source]: https://github.com/JuliaLang/julia
[AbstractTrees]: https://github.com/JuliaCollections/AbstractTrees.jl
[backtrace]: https://en.wikipedia.org/wiki/Stack_trace
[ManualDispatch]: https://github.com/jlapeyre/ManualDispatch.jl
[Cthulhu]: https://github.com/JuliaDebug/Cthulhu.jl
[julia15276]: https://github.com/JuliaLang/julia/issues/15276

~~~<a name="footnote1"></a>[†] ~~~ Technically, `@nospecialize` controls code-generation rather than inference, although it indirectly affects inference by preventing specialization on call sites.  Running inference on methods annotated `@nospecialize` allows callers, who often do know the argument types, to infer the return type(s) of the method.