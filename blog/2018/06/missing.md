@def rss_pubdate = Date(2018, 6, 19)
@def rss_description = """ First-Class Statistical Missing Values Support in Julia 0.7 | The 0.7 release of Julia will soon introduce first-class support for statistical... """
@def published = "19 June 2018"
@def title = "First-Class Statistical Missing Values Support in Julia 0.7"
@def authors = """ <a href="https://bouchet-valat.site.ined.fr">Milan Bouchet-Valat</a>"""
@def hascode = true

The 0.7 release of Julia will soon introduce first-class support for statistical
missing values. Being essential for statistical analyses and data management,
this feature is common among specialized languages, such as
[SQL](https://en.wikipedia.org/wiki/Null_(SQL)) (with the `NULL` value),
[R](http://cran.r-project.org/doc/manuals/r-release/R-lang.html#NA-handling) (`NA`),
[SAS](https://support.sas.com/documentation/cdl/en/lrcon/62955/HTML/default/viewer.htm#a001292604.htm)
(`.`, `' '`, etc.) or
[Stata](https://www.stata.com/support/faqs/data-management/logical-expressions-and-missing-values/)
(`.`, etc.). It is however quite rare among general-purpose languages, where [`Nullable`](https://en.wikipedia.org/wiki/Nullable_type) or [`Option`](https://en.wikipedia.org/wiki/Option_type) types generally do not allow
implicit propagation of null values (they require [lifting](https://blogs.msdn.microsoft.com/ericlippert/2007/06/27/what-exactly-does-lifted-mean/))
and do not provide an efficient representation of arrays with missing values[^nullable].

Starting from Julia 0.7, missing values are represented using the new `missing` object.
Resulting from intense design discussions, experimentations and language
improvements developed over several years, it is the heir of the `NA` value
implemented in the [DataArrays](https://github.com/JuliaStats/DataArrays.jl)
package, which used to be the standard way of representing missing data in Julia.
`missing` is actually very similar to its predecessor `NA`, but it benefits from many
improvements in the Julia compiler and language which make it fast, making it possible
to drop the `DataArray` type and using the standard `Array` type instead[^PDA].
Drawing from the experience of existing languages, the design of `missing` closely
follows that of SQL's `NULL` and R's `NA`, which can be considered
as the most consistent implementations with regard to the support of missing values.
Incidentally, this makes it easy to generate SQL requests from Julia code or to have
R and Julia interoperate.

This framework is used by
[version 0.11](https://discourse.julialang.org/t/dataframes-0-11-released/7296/)
of the [DataFrames](https://github.com/JuliaStats/DataFrames.jl/) package,
which already works on Julia 0.6 via the [Missings](https://github.com/JuliaData/Missings.jl)
package, even if performance improvements are only available on Julia 0.7.

The new implementation of statistical missing values follows three principles we deem
as essential for a modern scientific computing environment:

1. Missing values are safe by default: when passed to most functions, they either
   propagate or throw an error.

2. The `missing` object can be used in combination with any type, be it defined in
   Base, in a package or in user code.

3. Standard Julia code working with missing values is efficient, without special tricks.

The post first presents the behavior of the new `missing` object, and then details its
implementation, in particular showing how it provides blazing performance while still
being fully generic. Finally, current limitations and future improvements are discussed.

## The 'missing' object: safe and generic missing values

One of Julia's strengths is that user-defined types are as powerful and fast as built-in
types. To fully take advantage of this, missing values had to support not only standard
types like `Int`, `Float64` and `String`, but also any custom type. For this reason,
Julia cannot use the so-called *sentinel* approach like R and Pandas to represent
missingness, that is reserving special values within a type's domain. For example,
R represents missing values in integer and boolean vectors using the smallest
representable 32-bit integer (`-2,147,483,648`), and missing values in floating point
vectors using a specific `NaN` payload (`1954`, which rumour says refers to Ross Ihaka's
year of birth). Pandas only supports missing values in floating point vectors,
and conflates them with `NaN` values.

In order to provide a consistent representation of missing values which can be combined
with any type, Julia 0.7 will use `missing`, an object with no fields which is the only
instance of the `Missing` singleton type. This is a normal Julia type for which a series
of useful methods are implemented. Values which can be either of type `T` or missing
can simply be declared as `Union{Missing,T}`. For example, a vector holding either integers
or missing values is of type `Array{Union{Missing,Int},1}`:

```julia
julia> [1, missing]
2-element Array{Union{Missing, Int64},1}:
 1
  missing
```

An interesting property of this approach is that `Array{Union{Missing,T}}` behaves just
like a normal `Array{T}` as soon as missing values have been replaced or skipped
(see below).

As can be seen in the example above, promotion rules are defined so that concatenating
values of type `T` and missing values gives an array with element type `Union{Missing,T}`
rather than `Any`[^typejoin]:

```julia
julia> promote_type(Int, Missing)
Union{Missing, Int64}
```

These promotion rules are essential for performance, as we will see below.

In addition to being generic and efficient, the main design goal of the new `missing`
framework is to ensure safety, in the sense that missing values should never
be silently ignored nor replaced with non-missing values. Missing values are a
delicate issue in statistical work, and a frequent source of bugs or invalid results.
Ignoring missing values amounts to performing data imputation, which should never
happen silently without an explicit request. This is unfortunately the case in some
major statistical languages: for example, in SAS and Stata, `x < 100` will silently
return `true` or `false` even if `x` is missing[^lt]. This behavior is known to
have caused incorrect results in published scientific work[^35h].
Sentinel approaches also suffer from bugs in corner cases: for example, in R,
`NA + NaN` returns `NA` but `NaN + NA` returns `NaN` due to floating point
computation rules.

Therefore, passing `missing` to a function will always return `missing` or throw
an error (except for a few special functions presented below). For convenience,
standard operators and mathematical functions systematically propagate missing
values:

```julia
julia> 1 + missing
missing

julia> missing^2
missing

julia> cos(missing)
missing

julia> round(missing)
missing

julia> "a" * missing
missing
```

Reduction operations inherit the propagating behavior of basic operators:

```julia
julia> sum([1, missing, 2])
missing

julia> mean([1, missing, 2])
missing
```

On the other hand, indexing into a `Vector` with missing values is an error.
Missing values are *not* silently skipped, which would be equivalent to assuming
that they are `false`.

```julia
julia> x = 1:3
1:3

julia> x[[true, missing, false]]
ERROR: ArgumentError: unable to check bounds for indices of type Missing

julia> x[[1, missing]]
ERROR: ArgumentError: unable to check bounds for indices of type Missing
```

Convenience functions are provided to get rid of missing values explicitly.
First, the `skipmissing` function returns an iterator over the non-missing values
in the passed collection. It is particularly useful to ignore missing values when
computing reductions. Call `collect` to obtain a vector with all non-missing values.

```julia
julia> sum(skipmissing([1, missing, 2]))
3

julia> mean(skipmissing([1, missing, 2]))
1.5

julia> collect(skipmissing([1, missing, 2]))
2-element Array{Int64,1}:
1
2

julia> x[collect(skipmissing([1, missing, 2]))]
2-element Array{Int64,1}:
1
2
```

Second, the `coalesce` function returns the first non-missing argument (as in SQL),
which as a special case allows replacing missing values with a particular value.
Combined with the "dot" broadcasting syntax, it allows replacing all missing
values in an array:

```julia
julia> coalesce(missing, 0)
0

julia> coalesce(missing, missing, 0)
0

julia> coalesce.([1, missing, 2], 0)
3-element Array{Int64,1}:
1
0
2

julia> coalesce.([1, missing, 2], [2, 3, missing])
3-element Array{Int64,1}:
1
3
2
```

A restricted set of functions and operators follow different semantics than
those described above. They can be grouped into four classes:

- `ismissing` returns `true` if the input is `missing`, and `false` otherwise.

- `===`, `isequal` and `isless` always return a Boolean. `===` and `isequal` return
  `true` when comparing `missing` to `missing`, and `false` otherwise.
  `isless` also belongs to this class, and returns `true` when
  comparing any non-missing value to `missing`, and `false` otherwise: missing values
  are sorted last.

- `&`, `|` and `⊻`/`xor` implement [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic),
  returning either a Boolean value or `missing` depending on whether the result is
  fully determined even without knowing what could be the value behind `missing`.

- `==`, `<`, `>`, `<=` and `>=` return `missing` if one of the operands is `missing`
  just like any other operators. When called on collections containing missing values,
  these operators are applied recursively and also follow three-valued logic: they
  return `missing` if the result would depend on what value a `missing` element would take.
  This also applies to `all`, `any` and `in`.

Short-circuiting operators `&&` and `||`, just like `if` conditions, throw an error
if they need to evaluate a missing value: whether or not code should be run cannot
be determined in that case.

Naturally, functions defined based on those listed above inherit their behavior. For example,
`findall(isequal(1), [1, missing, 2])` returns `[1]`, but `findall(==(1), [1, missing, 2])`
throws an error when encountering a missing value.

See the [manual](https://docs.julialang.org/en/v1/manual/missing/) for more details
and illustrations about these rules. As noted above, they are generally consistent with
those implemented by SQL's `NULL` and R's `NA`.

## From 'Nullable' to 'missing' and 'nothing'

While it is similar to the previous `NA` value, the new `missing` object also replaces
the `Nullable` type introduced in Julia 0.4, which turned out not to be the best choice
to represent missing values[^jmw]. `Nullable` suffered from several issues:

- It was used to represent two very different kinds of missingness, that we
  sometimes call respectively the "software engineer's null" and the "data
  scientist's null". The former refers to what `Nullable` is generally used for
  in most languages, i.e. `null` denotes the absence of a value, and one of the
  advantages of the `Nullable` type is to force developers to handle explicitly
  the case when there is no value. The latter refers to statistical missing values,
  which generally *propagate* silently in specialized languages, which is essential
  for convenience. It has become increasingly clear that these two uses conflict
  (even if specialized syntax could have helped mitigating this).

- To ensure type-stability, the `T` type parameter of `Nullable{T}` had to be
  specified whether a value was present or not. Finding out the appropriate type
  in the absence of any value (dubbed the "counterfactual return type") has
  turned out to be problematic in many cases, where code had to rely heavily
  on explicit calls to type inference, which would better be handled directly
  by the compiler.

- `Array{Nullable{T}}` objects used a sub-optimal memory layout where `T` values
  and the associated `Bool` indicator were stored side-by-side, which wastes
  space due to alignment constraints and is not the most efficient for processing.
  Therefore, specialized array types like
  [`NullableArray`](https://github.com/JuliaStats/NullableArrays.jl) had to be used
  (similar to `DataArray`).

For all these reasons, `Nullable`
[no longer exists](https://github.com/JuliaLang/julia/pull/23642)
in Julia 0.7. Several replacements are provided, depending on the use case:

- As presented above, data which can contain statistical missing values should be
  represented as `Union{Missing,T}`, i.e. either a value of type `T` or the
  `missing` object.

- Situations where there may be a value of type `T` or no value should use
  `Union{Nothing,T}` (equivalent to `Union{Void,T}` on Julia 0.6). As a special case,
  if `nothing` is a possible value (i.e. `Nothing <: T`), `Union{Nothing,Some{T}}`
  should be used instead. This pattern is used by e.g. `findfirst` and `tryparse`.

This blog post is centered on the first case, and hopefully the description of the behavior
of `missing` above makes it clear why it is useful to distinguish it from `nothing`.
Indeed, while `missing` generally propagates when passed to standard mathematical operators
and functions, `nothing` does not implement any specific method and therefore generally
gives a `MethodError`, forcing the caller to handle it explicitly. However, considerations
regarding performance developed below apply equally to `missing` and `nothing` (as well as
to other custom types in equivalent situations).

## An efficient representation

Another of Julia's strengths is that one does not need to use tricks such as vectorized
calls to make code fast. In this spirit, working with missing values had to be
efficient without requiring special treatment. While the `Union{Missing,T}` approach
would have been very inefficient in previous Julia versions, the situation has
dramatically changed thanks to two improvements implemented in the compiler in
Julia 0.7.

The first improvement involves optimizations for small `Union` types.
When type inference detects that a variable can hold values of multiple types but
that these types are in limited number (as is the case for `Union{Missing,T}`),
the compiler will generate optimized code for each possible type in separate branches,
and run the appropriate one after checking the actual type of the value[^splitting].
This produces code which is very close to that typically used with the sentinel
approach, in which one needs to check manually whether the processed value is equal
to the sentinel. This optimization is of course only available when the type is
inferred as a small `Union`: it is therefore essential to work with
`Array{Union{Missing,T}}` rather than `Array{Any}` objects, to provide the compiler
with the necessary type information.


The second improvement consists in using a compact memory layout for `Array` object
whose element type is a `Union` of bits types, i.e. immutable types which contain
no references (see the [`isbits`](https://docs.julialang.org/en/latest/base/base/#Base.isbits)
function). This includes `Missing` and basic types such as `Int`, `Float64`,
`Complex{Float64}` and `Date`. When `T` is a bits type, `Array{Union{Missing,T}}`
objects are internally represented as a pair of arrays of the same size:
an `Array{T}` holding non-missing values and uninitialized memory for missing values;
and an `Array{UInt8}` storing a *type tag* indicating whether each entry
is of type `Missing` or `T`.

This layout consumes slightly more memory than the sentinel approach, as the
type tag part occupies one byte for each entry. But this overhead is reasonable:
for example, the memory usage of an `Array{Union{Missing,Float64}}` is only
12.5% higher than that of an `Array{Float64}`. Compared with the sentinel approach,
it has the advantage of being fully generic (as we have seen above).
Actually, this mechanism can be used in other situations, for example with `Union{Nothing,Int}`
(which is the element type of the array returned by `indexin` in Julia 0.7).

Arrays of non-bits types with missing values were already and continue to be represented
as efficiently as their counterparts without missing values. Indeed, such arrays consist of
pointers to the actual objects which live in a different memory area. Missing values
can be represented as a special pointer just like non-missing values. This is notably
the case for `Array{Union{Missing,String}}`.

The efficient memory layout of `Array` in the presence of missing values makes it
unnecessary to use dedicated array types like
[`DataArray`](https://github.com/JuliaStats/DataArrays.jl). In fact, the layout
of the `DataArray` type is very similar to that of `Array{Union{Missing,T}}`
described above. The only difference is that it uses a `BitArray` rather than an
`Array{UInt8}` to indicate whether a value is missing, therefore taking 1 bit per
entry rather than 8 bits. Even if it consumes more memory, the `Array{UInt8}` mask
approach is faster (at least in the current state of `BitArray`), and it generalizes
to `Union`s of more than two types. However, we are aware that other implementations
such as [PostgreSQL](https://www.postgresql.org/docs/9.5/static/storage-page-layout.html)
or [Apache Arrow](https://arrow.apache.org/docs/memory_layout.html#null-bitmaps)
use bitmaps equivalent to `BitArray`.

This efficient representation allows the compiler to generate very efficient code when
processing arrays with missing values. For example, the following function is one of
the most straightforward ways of computing the sum of non-missing values in an array:

```julia
function sum_nonmissing(X::AbstractArray)
    s = zero(eltype(X))
    @inbounds @simd for x in X
        if x !== missing
            s += x
        end
    end
    s
end
```

On Julia 0.7, this relatively naive implementation generates very efficient native
code when the input is an `Array{Int}` object. In fact, thanks to masked
[SIMD](https://en.wikipedia.org/wiki/SIMD) instructions, the presence of missing values
*does not make any significant difference* to performance.
In the following benchmark, `X1` is a vector of random `Int32` entries, `X2` holds the same
data but also potentially allows for the presence of `missing` values, and `X3` actually
contains 10% of `missing` values at random positions. `sum_nonmissing` takes about the
same time for all three arrays (on an Intel Skylake CPU with AVX2 instructions enabled).

```julia
julia> X1 = rand(Int32, 10_000_000);

julia> X2 = Vector{Union{Missing, Int32}}(X1);

julia> X3 = ifelse.(rand(length(X2)) .< 0.9, X2, missing);

julia> using BenchmarkTools

julia> @btime sum_nonmissing(X1);
  2.738 ms (1 allocation: 16 bytes)

julia> @btime sum_nonmissing(X2);
  3.216 ms (1 allocation: 16 bytes)

julia> @btime sum_nonmissing(X3);
  3.214 ms (1 allocation: 16 bytes)
```

As a reference point, R's `sum(x, na.rm=TRUE)` function, which is implemented in C,
takes about 7 ms without missing values and 19 ms with missing values (in R, `integer`
arrays always allow for missing values).

## Current limitations and future developments

Everything is not perfect though, and some improvements are still needed. The good news is
that the most difficult parts have already been implemented in Julia 0.7.

A first series of limitations concerns performance. Even though the sum example above is
arguably impressive, at the time of writing the compiler is not yet able to generate
fast code like this in all situations. For example, missing values still have a
significant performance impact for arrays of `Float64` elements, which are essential
for numeric computing:

```julia
julia> Y1 = rand(10_000_000);

julia> Y2 = Vector{Union{Missing, Float64}}(Y1);

julia> Y3 = ifelse.(rand(length(Y2)) .< 0.9, Y2, missing);

julia> @btime sum_nonmissing(Y1);
  5.733 ms (1 allocation: 16 bytes)

julia> @btime sum_nonmissing(Y2);
  13.854 ms (1 allocation: 16 bytes)

julia> @btime sum_nonmissing(Y3);
  17.780 ms (1 allocation: 16 bytes)
```

However, this is nothing to be ashamed of, as Julia is still faster than R:
`sum(x, na.rm=TRUE)` takes about 11 ms for a `numeric` array with no missing values,
and 21 ms for an array with 10% of missing values. This proves the validity of the
`Union{Missing,T}` approach , even though there is still some room for improvement.

Compiler improvements are also needed to ensure fast native code is generated like
in the examples above even for more complex patterns. In particular, replacing
`x !== missing` by `ismissing(x)` in `sum_nonmissing`
[currently](https://github.com/JuliaLang/julia/issues/27681) leads to a large
performance drop. One can also note that conversion between `Array{T}` and
`Array{Union{Missing,T}}` [currently](https://github.com/JuliaLang/julia/issues/26681)
involves a copy, which could in theory be avoided for bits types. Finally,
`sum(skipmissing(x))` is [currently](https://github.com/JuliaLang/julia/issues/27679)
 somewhat slower than the custom `sum_nonmissing` function due to the way the generic
`mapreduce` implementation works.
Hopefully these issues will be fixed in a not-too-distant future, as they do not
require any fundamental changes.

Another area which could be improved concerns convenience syntax and functions
to deal with missing values. We are fully aware that `Union{Missing,T}` is quite verbose
for those using missing values in daily work. The `T?` syntax has been discussed
as a compact alternative, inspired by languages with `Nullable` types. However it is
not clear yet whether it would be more appropriate to attribute this syntax to
`Union{Missing,T}` or to `Union{Nothing,T}`. It is therefore currently reserved waiting
for a decision. A possible solution would be to introduce one dedicated syntax for each
of these types.

Convenience functions would also be useful to propagate missing values with functions
which have not been written to do it automatically. Constructs like `lift(f, x)`,
`lift(f)(x)` and `f?(x)` have been [discussed](https://github.com/JuliaLang/julia/pull/26661)
to provide a shorter equivalent of `ismissing(x) ? missing : f(x)`.

A more fundamental limitation is inherent to the choice of the `Union{Missing,T}`
representation. In this representation, a non-missing value does not carry any information
about whether it could have been missing, i.e. about whether it has been extracted from an
array or from a column of a data set which allows for missing values. In practice, this means
that, if `x` is an `Array{Union{Missing,T}}` but does not actually contain missing values,
`map(identity, x)` will return an `Array{T}`. This is because `map` chooses its return type
based only on the actual contents of the output, to avoid depending on type inference
(which can vary depending on compiler improvements). This also means that when applying
a function to each element in an `Array{Union{T,Missing}}`, one cannot choose the result
type based on the type of the first element, which can be problematic e.g. to decide
whether a table column should allow for `NULL` entries in a SQL database. This issue has
been discussed [at length](https://discourse.julialang.org/t/missing-data-and-namedtuple-compatibility/8136/)
in several occasions, but it is not clear yet which mitigating approach is the best one.

Despite these limitations, we believe that missing values support in Julia 0.7 will be one
of the most complete even among specialized statistical languages, both in terms of features
and in terms of performance.

**Author**: [Milan Bouchet-Valat](https://bouchet-valat.site.ined.fr), Sociologist,
Research scientist at the French Institute for Demographic Studies (Ined), Paris.

**Acknowledgements**: This framework is the result of collective efforts over several
years. John Myles White led the reflection around missing values support in Julia
until 2016. Jameson Nash and Keno Fischer implemented compiler optimizations, and Jacob Quinn
implemented the efficient memory layout for arrays. Alex Arslan,
Jeff Bezanson, Stefan Karpinski, Jameson Nash and Jacob Quinn have been the most central
participants to this long and complex design work. Discussions have involved many other
developers with sometimes dissenting views, among which David Anthoff deserves
a special mention.

### Footnotes

[^nullable]:

 [C#](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/nullable-types/using-nullable-types)
 (with `null`) and [VB.NET](https://docs.microsoft.com/en-us/dotnet/visual-basic/programming-guide/language-features/data-types/nullable-value-types)
 (with `Nothing`) are two partial exceptions to this rule, since they provide
 *lifted* operators which operate on `Nullable` arguments and return `Nullable`s.

[^PDA]:
 The `PooledDataArray` type shipped in the same package can be replaced with
 either [`CategoricalArray`](https://github.com/JuliaData/CategoricalArrays.jl) or
 [`PooledArray`](https://github.com/JuliaData/PooledArrays.jl) depending on whether
 the data is really categorical or simply contains a small number of distinct values.

[^splitting]:
 This optimization applies to all `Union`s of a small number of types,
 whether they are bits types or not. "Small" is defined by the `MAX_UNION_SPLITTING`
 constant, which is currently set to 4.

[^typejoin]:
 In addition to these `promote_rule` methods, the `Missing` and `Nothing` types
 implement the internal `promote_typejoin` function, which ensures that functions such
 as `map` and `collect` return arrays with element types `Union{Missing,T}` or
 `Union{Nothing,T}` instead of `Any`.

[^lt]:
More precisely, SAS considers missing values as smaller than any non-missing
value, and Stata considers them as greater than any non-missing value. This behavior
can be explained by the particular choice of sentinel values of each of these languages
and by an imperfect abstraction revealing implementation details.

[^35h]:
See for example Olivier Godechot's
["Can We Use Alsace-Moselle for Estimating the Employment Effects of the 35-Hour Workweek Regulation in France?"](/assets/blog/chemin-wasmer-09.pdf).

[^jmw]:
In [a 2014 blog post](https://www.johnmyleswhite.com/notebook/2014/11/29/whats-wrong-with-statistics-in-julia/),
John Myles White advocated the use of `Nullable` due to its much higher performance
compared with`Union{T,NA}`. This performance gap no longer exists thanks to compiler
improvements which have been a game-changer for missing values support.
