@def rss_pubdate = Date(2017, 8, 9)
@def rss = """ Creating domain-specific languages in Julia using macros | Since the beginning of Julia, it has been tempting to use macros to write **domain-specific languages** (DSLs), i.e. to *extend* Julia syntax to provide a simpler interface to create Julia objects with complicated behaviour. The first, and still most extensive, example is JuMP (https://github.com/Ju... """
@def published = "9 August 2017"
@def title = "Creating domain-specific languages in Julia using macros"
@def authors = """<a href="https://github.com/dpsanders">David P. Sanders</a>"""  
@def hascode = true


Since the beginning of Julia, it has been tempting to use macros to write **domain-specific languages** (DSLs), i.e. to *extend* Julia syntax to provide a simpler interface to create Julia objects with complicated behaviour. The first, and still most extensive, example is [JuMP](https://github.com/JuliaOpt/JuMP.jl).

Since the fix for the infamous early [Julia issue #265](https://github.com/JuliaLang/julia/issues/265), which was incorporated in Julia 0.6, some previous methods for creating DSLs in Julia, mainly involving `eval`, ceased to work.

In this post, we will describe a recommended pattern (i.e., a reusable structure) for creating DSLs *without* the use of `eval`, using syntax suitable for Julia 0.6 and later versions; it is strongly recommended to upgrade to Julia 0.6.

## Creating a `Model` object containing a function

This blog post arose from a question in the JuliaCon 2017 hackathon about the [Modia modelling language](https://github.com/ModiaSim/Modia.jl), where there is a `@model` macro. Here we will describe the simplest possible version of such a macro, which will create a `Model` object that contains a function, and is itself callable.

First we define the `Model` object. It is tempting to write it like this:


```julia
struct NaiveModel
    f::Function
end
```

We can then create an instance of the `NaiveModel` type (i.e., an object of that type) using the default constructor, e.g. by passing it an anonymous function:


```julia
julia> m1 = NaiveModel(x -> 2x)
NaiveModel(#1)
```

and we can call the function using


```julia
julia> m1.f(10)
20
```

If we wish instances like `m` to themselves behave like functions, we can overload the call syntax on the `NaiveModel` object:

```julia
julia> (m::NaiveModel)(x) = m.f(x)
```

so that we can now just write


```julia
julia> m1(10)
20
```


## Parametrising the type

Since `Function` is an abstract type, for performance we should *not* have a field of this type inside our object.
Rather, we parametrise the type using the type of the function:


```julia
struct Model{F}
    f::F
end

(m::Model)(x) = m.f(x)
```


```julia
julia> m2 = Model(x->2x)
Model{##3#4}(#3)
```


```julia
julia> m2(10)
20
```


Let's compare the performance:


```julia
julia> using BenchmarkTools

julia> @btime m1(10);
41.482 ns (0 allocations: 0 bytes)

julia> @btime m2(10);
20.212 ns (0 allocations: 0 bytes)
```

Indeed we have removed some overhead in the second case.

## Manipulating expressions

We wish to define a *macro* that will allow us to use a simple syntax, of our choosing, to create objects. Suppose we would like to use the syntax

```julia
julia> @model 2x
```

to define a `Model` object containing the function `x -> 2x`. Note that `2x` on its own is not valid Julia syntax for creating a function; the macro will allow us to use this simplified syntax for our own purposes.

Before getting to macros, let's first build some tools to manipulate the expression `2x` in the correct way to build a `Model` object from it, using standard Julia functions.

First, let's create a function to manipulate our expression:

```julia
function make_function(ex::Expr)
    return :(x -> $ex)
end
```


```julia
julia> ex = :(2x);

julia> make_function(ex)
:(x->begin  # In[12], line 2:
    2x
end)
```

Here, we have created a Julia expression called `ex`, which just contains the expression `2x` that we would like for the body of our new function, and we have passed this expression into `make_function`, which wraps it into a complete anonymous function.
This assumes that `ex` is an expression containing the variable `x` and makes a new expression representing an
anonymous function with the single argument `x`. (See e.g. [my JuliaCon 2017 tutorial](https://github.com/dpsanders/julia_towards_1.0/blob/master/4.%20Metaprogramming.ipynb) for an example of how to walk through the expression tree in order to extract *automatically* the variables that it contains.)

Now let's define a function `make_model` that takes a function, wraps it, and passes it into a `Model` object:


```julia
function make_model(ex::Expr)
    return :(Model($ex))
end
```


```julia
julia> make_model(make_function(:(2x)))
:(Model((x->begin  # In[12], line 2:
            2x
        end)))
```


If we evaluate this "by hand", we see that it correctly creates a `Model` object:


```julia
julia> m3 = eval(make_model(make_function(:(2x))))
Model{##7#8}(#7)

julia> m3(10)
20
```


## Macros

However, this is ugly and clumsy. Instead, we now wrap everything inside a **macro**. A macro is a code manipulator: it eats code, massages it in some way (possibly including completely rewriting it), and spits out the new code that was produced. This makes macros an incredibly powerful (and, therefore, dangerous) tool when correctly used.


In the simplest case, a macro takes as argument a single Julia `Expr` object, i.e. an unevaluated Julia expression (i.e., a piece of Julia code).
It manipulates this expression object to create a new expression object, which it then returns.

The key point is that this returned expression is "spliced into" the newly-generated code **in place of the old code**. The compiler will never actually see the old code, only the new code.


Let's start with the simplest possible macro:


```julia
macro model(ex)
    @show ex
    @show typeof(ex)
    return nothing
end
```

This just shows the argument that it was passed and exits, returning an empty expression.


```julia
julia> m4 = @model 2x
ex = :(2x)
typeof(ex) = Expr
```

We see that the Julia `Expr` object has been automatically created from the explicit code that we typed.

Now we can plug in our previous functions to complete the macro's functionality:


```julia
julia> macro model(ex)
           return make_model(make_function(ex))
       end

@model (macro with 1 method)

julia> m5 = @model 2x
Model{##7#8}(#7)

julia> m5(10)
20
```

To check that the macro is doing what we think it is, we can use the `@macroexpand` command, which itself is a macro (as denoted by the initial `@`):
```julia
julia> @macroexpand @model 2x
:((Main.Model)((#71#x->begin  # In[12], line 2:
                    2#71#x
                end)))
```

## Macro "hygiene"

However, our macro has an issue, called macro "hygiene". This has to do with where variables are defined. Let's put everything we have so far inside a module:


```julia
module Models

export Model, @model

struct Model{F}
    f::F
end

(m::Model)(x) = m.f(x)

function make_function(ex::Expr)
    return :(x -> $ex)
end

function make_model(ex::Expr)
    return :(Model($ex))
end

macro model(ex)
    return make_model(make_function(ex))
end

end
```

Now we import the module and use the macro:


```julia
julia> using Models

julia> m6 = @model 2x;

julia> m6(10)
20
```

So far so good. But now let's try to include a global variable in the expression:


```julia
julia> a = 2;

julia> m7 = @model 2*a*x
Models.Model{##7#8}(#7)

julia> m7(10)
UndefVarError: a not defined
Stacktrace:
 [1] #7 at ./In[1]:12 [inlined]
 [2] (::Models.Model{##7#8})(::Int64) at ./In[1]:9
```

We see that it cannot find `a`. Let's see what the macro is doing:


```julia
julia> @macroexpand @model 2*a*x
:((Models.Model)((#4#x->begin  # In[1], line 12:
                    2 * Models.a * #4#x
                end)))
```


We see that Julia is looking for `Models.a`, i.e. a variable `a` defined inside the `Models` module.

To fix this problem, we must write an "unhygienic" macro, by
"escaping" the code, using the `esc` function. This is a mechanism telling the compiler to look for variable definitions in the scope from which the macro is called (here, the current module `Main`), rather than the scope where the macro is defined (here, the `Models` module):


```julia
module Models2

export Model, @model

struct Model{F}
    f::F
end

(m::Model)(x) = m.f(x)

function make_function(ex::Expr)
    return :(x -> $ex)
end

function make_model(ex::Expr)
    return :(Model($ex))
end

macro model(ex)
    return make_model(make_function(esc(ex)))
end

end
```


```julia
julia> using Models2

julia> a = 2;

julia> m8 = @model 2*a*x
Models2.Model{##3#4}(#3)

julia> m8(10)
40
```


This is the final, working version of the macro.

## Conclusion

We have successfully completed our task: we have seen how to create a macro that enables a simple syntax for creating a Julia object that we can use later.

For some more in-depth discussion of metaprogramming techniques and macros, see my video tutorial *Invitation to intermediate Julia*, given at JuliaCon 2016:

- link to [the video](https://www.youtube.com/watch?v=rAxzR7lMGDM)
- link to the [Jupyter notebooks](https://github.com/dpsanders/intermediate_julia)

**Author**: [David P. Sanders](http://sistemas.fciencias.unam.mx/~dsanders/), Associate Professor, Department of Physics, Faculty of Sciences, National University of Mexico (UNAM).
