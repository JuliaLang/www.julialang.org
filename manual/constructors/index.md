---
layout: manual
title:  Constructors
---

Constructors are functions that create new objects — specifically, instances of [composite types](../types#Composite+Types).
In Julia, type objects also serve as constructor functions:
they create new instances of themselves when applied to an argument tuple as a function.
This much was already mentioned briefly when composite types were introduced.
For example:

    type Foo
      bar
      baz
    end

    julia> foo = Foo(1,2)
    Foo(1,2)

    julia> foo.bar
    1

    julia> foo.baz
    2

For many types, forming new objects by binding their field values together is all that is ever needed to create instances.
There are, however, cases where more functionality is required when creating composite objects.
Sometimes invariants must be enforced, either by checking arguments or by transforming them.
[Recursive data structures](http://en.wikipedia.org/wiki/Recursion_%28computer_science%29#Recursive_data_structures_.28structural_recursion.29), especially those that may be self-referential, often cannot be constructed cleanly without first being created in an incomplete state and then altered programmatically to be made whole, as a separate step from object creation.
Sometimes, it's just convenient to be able to construct objects with fewer or different types of parameters than they have fields.
Julia's system for object construction addresses all of these cases and more.

## Outer Constructor Methods

A constructor is just like any other function in Julia in that its overall behavior is defined by the combined behavior of its methods.
Accordingly, you can add functionality to a constructor by simply defining new methods.
For example, let's say you want to add a constructor method for `Foo` objects that takes only one argument and uses the given value for both the `bar` and `baz` fields.
This is simple:

    Foo(x) = Foo(x,x)

    julia> Foo(1)
    Foo(1,1)

You could also add a zero-argument `Foo` constructor method that supplies default values for both of the `bar` and `baz` fields:

    Foo() = Foo(0)

    julia> Foo()
    Foo(0,0)

Here the zero-argument constructor method calls the single-argument constructor method, which in turn calls the automatically provided two-argument constructor method.
For reasons that will become clear very shortly, additional constructor methods declared as normal methods like this are called *outer* constructor methods.
Outer constructor methods can only ever create a new instance by calling another constructor method, such as the automatically provided default one.

<div class="sidebar">
<b>A Note On Nomenclature.</b>
While the term &ldquo;constructor&rdquo; generally refers to the entire function which constructs objects of a type, it is common to abuse terminology slightly and refer to specific constructor <i>methods</i> as &ldquo;constructors&rdquo;.
In such situations, it is generally clear from context that the term is used to mean &ldquo;constructor method&rdquo; rather than &ldquo;constructor function&rdquo;, especially as it is often used in the sense of singling out a particular method of the constructor from all of the others.
</div>

## Inner Constructor Methods

While outer constructor methods succeed in addressing the problem of providing additional convenience methods for constructing objects, they fail to address the other two use cases mentioned in the introduction of this chapter:
enforcing invariants, and allowing construction of self-referential objects.
For these problems, one needs *inner* constructor methods.
An inner constructor method is much like an outer constructor method, with two differences:

1. It is declared inside the block of a type declaration, rather than outside of it like normal methods.
2. It has access to a special locally existent function called `new` that creates objects of the block's type.

For example, suppose one wants to declare a type that holds a pair of real numbers, subject to the constraint that that the first number is not greater than the second one.
One could declare it like this:

    type OrderedPair
      x::Real
      y::Real

      OrderedPair(x,y) = x > y ? error("out of order") : new(x,y)
    end

Now `OrderedPair` objects can only be constructed such that `x <= y`:

    julia> OrderedPair(1,2)
    OrderedPair(1,2)

    julia> OrderedPair(2,1)
    out of order

You can still reach in and directly change the field values to violate this invariant (support for immutable composites is planned but not yet implemented), but messing around with an object's internals uninvited is considered poor form.
You (or someone else) can also provide additional outer constructor methods at any later point, but once a type is declared, there is no way to add more inner constructor methods.
Since outer constructor methods can only create objects by calling other constructor methods, ultimately, some inner constructor must be called to create an object.
This guarantees that all objects of the declared type must come into existence by a call to one of the inner constructor methods provided with the type, thereby giving some degree of real enforcement of a type's invariants, at least for object creation.

If any inner constructor method is defined, no default constructor method is provided:
it is presumed that you have supplied yourself with all the inner constructors you need.
The default constructor is equivalent to writing your own inner constructor method which takes all of the object's fields as parameters, passes them directly to `new`, and returns the resulting object like so:

    type Foo
      bar
      baz

      Foo(bar,baz) = new(bar,baz)
    end

This declaration has the same effect as the earlier definition of the `Foo` type without an explicit inner constructor method.
Even if a type's fields have constrained types, this equivalence holds because the `new` function attempts to convert arguments that are not already of the required type:

    type T1
      x::Int64
    end

    type T2
      x::Int64
      T2(x) = new(x)
    end

    julia> T1(1)
    T1(1)

    julia> T2(1)
    T2(1)

    julia> T1(1.9)
    T1(1)

    julia> T2(1.9)
    T2(1)

    julia> T1("hello")
    no method convert(Type{Int64},ASCIIString)

    julia> T2("hello")
    no method convert(Type{Int64},ASCIIString)

It is considered good form to provide as few inner constructor methods as possible:
only those taking all arguments explicitly and enforcing essential error checking and transformation.
Additional convenience constructor methods, supplying default values or auxiliary additional transformations, should be provided as outer constructors, calling the inner constructors to do the heavy lifting.
This separation is typically quite natural.

## Incomplete Initialization

The final problem which has still not been addressed is construction of self-referential objects, or more generally, recursive data structures.
Since the fundamental difficulty may not be immediately obvious, let us briefly explain it.
Consider the following recursive type declaration:

    type SelfReferential
      obj::SelfReferential
    end

This type may appear innocuous enough, until one considers how to construct an instance of it.
If `a` is an instance of `SelfReferential`, then a second instance can be created by the call:

    b = SelfReferential(a)

But how does one construct the first instance when no instance exists to provide as a valid value for its `obj` field?
The only solution is to allow creating an incompletely initialized instance of `SelfReferential` with an unassigned `obj` field, and using that incomplete instance as a valid value for the `obj` field of another instance, such as, for example, itself.

To allow for the creation of incompletely initialized objects, Julia allows the `new` function to be called with fewer than the number of fields that the type has, returning an object with the unspecified fields uninitialized.
The inner constructor method can then use the incomplete object, finishing its initialization before returning it.
Here, for example, we take another crack at defining the `SelfReferential` type, with a zero-argument inner constructor returning instances having `obj` fields pointing to themselves:

    type SelfReferential
      obj::SelfReferential

      SelfReferential() = (x = new(); x.obj = x)
    end

We can verify that this constructor works and constructs objects that are, in fact, self-referential:

    x = SelfReferential();

    julia> is(x, x)
    true

    julia> is(x, x.obj)
    true

    julia> is(x, x.obj.obj)
    true

Although it is generally a good idea to return a fully initialized object from an inner constructor, incompletely initialized objects can be returned:

    type Incomplete
      xx

      Incomplete() = new()
    end

    julia> z = Incomplete();

While you are allowed to create objects with uninitialized fields, any access to an uninitialized field is an immediate error:

    julia> z.xx
    access to undefined reference

This prevents uninitialized fields from propagating throughout a program or forcing programmers to continually check for uninitialized fields, the way they are required to check for `null` values everywhere in Java.
You can also pass incomplete objects to other functions from inner constructors to complete them:

    type Lazy
      xx

      Lazy(v) = complete_me(new(), v)
    end

As with incomplete objects returned from constructors, if `complete_me` or any of its callees try to access the `xx` field of the `Lazy` object before it has been initialized, an error will immediately be thrown.

## Parametric Constructors

Parametric types add a few wrinkles to the constructor story.
Recall from [Parametric Types](../types#Parametric+Types) that, by default, instances of parametric composite types can be constructed either with explicitly given type parameters or with type parameters implied by the types of the arguments given to the constructor.
For example:

    type Point{T<:Real}
      x::T
      y::T
    end

    ## implicit T ##

    julia> Point(1,2)
    Point(1,2)

    julia> Point(1.0,2.5)
    Point(1.0,2.5)

    julia> Point(1,2.5)
    no method Point(Int64,Float64)

    ## explicit T ##

    julia> Point{Int64}(1,2.5)
    Point(1,2)

    julia> Point{Float64}(1,2.5)
    Point(1.0,2.5)

For constructor calls with explicit type parameters, such as `Point{Int64}(1,2.5)`, the arguments can be of any type since the value of `T` is explicitly given.
If the arguments are not already of type `T`, then conversion is attempted.
When the type is implied by the arguments to the constructor call, as in `Point(1,2)`, then the types of the arguments must match — otherwise it's ambiguous which of the arguments should determine the value of `T`.

What's really going on here is that `Point`, `Point{Float64}` and `Point{Int64}` are all different constructor functions.
In fact, `Point{T}` is a distinct constructor function for each type `T`.
Without any explicitly provided inner constructors, the declaration of the composite type `Point{T<:Real}` automatically provides an inner constructor, `Point{T}`, for each possible type `T<:Real`, which behaves just like non-parametric default inner constructors do.
It also provides a single general outer `Point` constructor that takes pairs of real arguments, which must be of the same type.
This automatic provision of constructors is equivalent to the following explicit declaration:

    type Point{T<:Real}
      x::T
      y::T

      Point(x,y) = new(x,y)
    end

    Point{T<:Real}(x::T, y::T) = Point{T}(x,y)

Some features of parametric constructor definitions at work here deserve comment.
First, inner constructor declarations always define methods of `Point{T}` rather than methods of the general `Point` constructor function.
Since `Point` is not a concrete type, it makes no sense for it to even have inner constructor methods at all.
Thus, the inner method declaration `Point(x,y) = new(x,y)` provides an inner constructor method for each value of `T`.
It is, accordingly, this method declaration that makes the constructor calls with explicit type parameters, like `Point{Float64}(1,2)` and `Point{Int64}(1,2)`, work.
The outer constructor declaration defines a method for the general `Point` constructor, and only applies to pairs of values of the same real type.
This declaration makes constructor calls like `Point(1,2)` and `Point(1.0,2.5)`, without explicit type parameters, work.
Since the method declaration restricts the arguments to being of the same type, calls like `Point(1,2.5)`, with arguments of different types, result in "no method" errors.

Suppose we wanted to make the constructor call `Point(1,2.5)` work.
The simplest way to achieve this is to define the following additional outer constructor method:

    Point(x::Int64, y::Float64) = Point{Float64}(x,y)

This method definition calls the explicit type constructor for `Point{Float64}`, thereby giving the `Float64` type precedence over `Int64`:
both `x` and `y` will be converted to `Float64`.
With this method definition the previous "no method" error now creates a point:

    julia> Point(1,2.5)
    Point(1.0,2.5)

    julia> typeof(ans)
    Point{Float64}

However, other similar calls still don't work:

    julia> Point(1.5,2)
    no method Point(Float64,Int64)

For a much more general way of making all such calls work sensibly, see [Conversion and Promotion](../conversion-and-promotion).
At the risk of spoiling the suspense, we can reveal here that the all it takes is the following outer method definition to make all calls to the general `Point` constructor work as one would expect:

    Point(x::Real, y::Real) = Point(promote(x,y)...)

With this method definition, the `Point` constructor promotes its arguments the same way that numeric operators like `+` do, and works for all kinds of real numbers:

    julia> Point(1.5,2)
    Point(1.5,2.0)

    julia> Point(1,1//2)
    Point(1//1,1//2)

    julia> Point(1.0,1//2)
    Point(1.0,0.5)

While the implicit type parameter constructors provided by default in Julia are fairly strict, it is possible to make them behave in a more relaxed but sensible manner quite easily if one wants to.
Moreover, since constructors can leverage all of the power of the type system, methods, and multiple dispatch, providing sophisticated behavior is typically quite simple.

## Case Study: Rational

Perhaps the best way to tie all these pieces together is to present a real world example of a parametric composite type and its constructor methods.
To that end, here is beginning of [`rational.j`](https://github.com/JuliaLang/julia/blob/master/j/rational.j), which implements Julia's [rational numbers](../complex-and-rational-numbers#Rational+Numbers):

    type Rational{T<:Int} <: Real
        num::T
        den::T

        function Rational(num::T, den::T)
            if num != 0 || den != 0
                g = gcd(den, num)
                num = div(num, g)
                den = div(den, g)
            end
            new(num, den)
        end
    end
    Rational{T<:Int}(n::T, d::T) = Rational{T}(n,d)
    Rational(n::Int, d::Int) = Rational(promote(n,d)...)
    Rational(n::Int) = Rational(n,one(n))

    //(n::Int, d::Int) = Rational(n,d)
    //(x::Rational, y::Int) = x.num // (x.den*y)
    //(x::Int, y::Rational) = (x*y.den) // y.num
    //(x::Complex, y::Real) = complex(real(x)//y, imag(x)//y)
    //(x::Real, y::Complex) = x*y'//real(y*y')

    function //(x::Complex, y::Complex)
        xy = x*y'
        yy = real(y*y')
        complex(real(xy)//yy, imag(xy)//yy)
    end

The line `type Rational{T<:Int} <: Real` declares that `Rational` takes one type parameter of an integer type, and is itself a real type.
The field declarations `num::T` and `den::T` indicate that the data held in a `Rational{T}` object are a pair of integers of type `T`, one representing the rational value's numerator and the other representing its denominator.

Now things get interesting.
`Rational` has a single inner constructor method which ensures that every rational is constructed with numerator and denominator sharing no common factors with a non-negative denominator.
This is accomplished by dividing the given numerator and denominator values by their greatest common divisor, computed using the `gcd` function.
Since `gcd` returns the greatest common divisor of its arguments with sign matching the first argument — in this case, `den` — after this division, the new value of `den` is guaranteed to be non-negative.
Because this is the only inner constructor for `Rational`, we can be certain that `Rational` objects are always constructed in this normalized form.

`Rational` also provides several outer constructor methods for convenience.
The first is the "standard" general constructor that infers the type parameter `T` from the type of the numerator and denominator, in the case that they have the same type.
The second applies when the given numerator and denominator values have different types:
it promotes them to a common type and then delegates construction to the first outer constructor.
The third outer constructor turns integer values into rationals by supplying a value of `1` as the denominator.

Following the outer constructor definitions, we have a number of methods for the `//` operator, which provides a syntax for writing rationals.
Before these definitions, `//` is a completely undefined operator with only syntax and no meaning.
Afterwards, it behaves just as described in [Rational Numbers](../complex-and-rational-numbers#Rational+Numbers) — its entire behavior is defined in these few lines.
The first and most basic definition just makes `a//b` where `a` and `b` are integers construct a `Rational` by applying the `Rational` constructor to them.
When one of the operands of `//` is already a rational number, we construct a new rational for the resulting ratio slightly differently;
this behavior is actually identical to division of a rational with an integer.
Finally, applying `//` to complex integral values creates an instance of `Complex{Rational}` — a complex number whose real and imaginary parts are rationals:

    julia> (1 + 2im)//(1 - 2im)
    -3//5 + 4//5im

    julia> typeof(ans)
    ComplexPair{Rational{Int64}}

    julia> ans <: Complex{Rational}
    true

Thus, although the `//` operator usually returns an instance of `Rational`, if either of its arguments are complex integers, it will return an instance of `Complex{Rational}` instead.
The interested reader should consider perusing the rest of [`rational.j`](https://github.com/JuliaLang/julia/blob/master/j/rational.j):
it is short, self-contained, and implements an entire basic Julia type in just a little over a hundred lines of code.
