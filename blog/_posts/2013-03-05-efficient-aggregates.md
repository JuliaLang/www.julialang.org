---
layout: post
title: Efficient Aggregates in Julia
author: <a href="https://github.com/JeffBezanson">Jeff Bezanson</a>
---

We recently introduced an exciting feature that has been in planning for some
time: immutable aggregate types. In fact, we have been planning to do this
for so long that this feature is the subject of our issue #13 on GitHub,
out of more than 2400 total issues so far.

Essentially, this feature drastically reduces the overhead of user-defined
types that represent small number-like values, or that wrap a small number
of other objects. Consider an RGB pixel type:

    immutable Pixel
        r::Uint8
        g::Uint8
        b::Uint8
    end

Instances of this type can now be packed efficiently into arrays, using
exactly 3 bytes per object. In all other respects, these objects continue
to act like normal first-class objects. To see how we might use
this, here is a function that converts an RGB image in standard 24-bit
framebuffer format to grayscale:

    function rgb2gray!(img::Array{Pixel})
        for i=1:length(img)
            p = img[i]
            v = uint8(0.30*p.r + 0.59*p.g + 0.11*p.b)
            img[i] = Pixel(v,v,v)
        end
    end

This code will run blazing fast, performing no memory allocation. We
have not done thorough benchmarking, but this is in fact likely to be the
fastest way to write this function in Julia from now on.

The key to this behavior is the new `immutable` keyword, which means
instances of the type cannot be modified. At first this sounds like
a mere restriction — how come I'm not allowed to modify one? — but
what it really means is that the object is identified with its contents,
rather than its memory address. A mutable object has "behavior"; it changes
over time, and there may be many references to the object, all of which
can observe those changes. An immutable object, on the other hand, has only
a value, and no time-varying behavior. Its location does not matter. It is
"just some bits".

Julia has always had some immutable values, in the form of bits types,
which are used to represent fixed-bit-width numbers. It is highly intuitive
that numbers are immutable. If `x` equals 2, you might later change the value
of `x`, but it is understood that the value of 2 itself does not change.
The `immutable` keyword generalizes this idea to structured data types with
named fields. Julia variables and containers, including arrays, are all
still mutable. While a `Pixel` object itself can't change, a new `Pixel`
can be written over an old one within an array, since the array is mutable.

Let's take a look at the benefits of this feature.

1. The compiler and GC have a lot of freedom to move and copy these objects
around. This flexibility can be used to store data more efficiently,
for example keeping the real and imaginary parts of a complex number in
separate registers, or keeping only one part in a register.

2. Immutable objects are easy to reason about. Some languages, such as C++
and C#, provide "value types", which have many of the benefits of immutable
objects. However, their behavior can be confusing. Consider code like
the following:

      item = lookup(collection, index)
      modify!(item)
The question here is whether we have modified the same `item` that is in
the collection, or if we have modified a local copy. In Julia there are
only two possibilities: either `item` is mutable, in which case we modified the
one and only copy of it, or it is immutable, in which case modifying it is
not allowed.

3. No-overhead data abstractions become possible. It is often useful to
define a new type that simply wraps a single value, and modifies its
behavior in some way. Our favorite modular integer example type fits this
description:

      immutable ModInt{n} <: Integer
          k::Int
          ModInt(k) = new(mod(k,n))
      end
Since a given `ModInt` doesn't need to exist at a particular address, it
can be passed to functions, stored in arrays, and so on, as efficiently as
a single `Int`, with no wrapping overhead. But, in Julia, the overhead will not
*always* be zero. The `ModInt` type information will "follow the data around"
at compile time to the extent possible, but heap-allocated wrappers will be
added as needed at run time. Typically these wrappers will be short-lived;
if the final destination of a `ModInt` is in a `ModInt` array, for example,
the wrapper can be discarded when the value is assigned. But if the value is
only used locally inside a function, there will most likely be no wrappers
at all.

4. Abstractions are fully enforced. If a custom constructor is written for
an immutable type, then all instances will be created by it. Since the
constructed objects are never modified, the invariants provided by the
constructor cannot be violated. At this time, uninitialized arrays are an
exception to this rule. New arrays of "plain data" immutable types have
unspecified contents, so it is possible to obtain an invalid value from one.
This is usually harmless in practice, since arrays must be initialized anyway,
and are often created through functions like `zeros` that do so.

5. We can automatically type-specialize fields. Since field values at
construction time are final, their types are too, so we learn everything
about the type of an immutable object when it is constructed.

There are many potential optimizations here, and we have not implemented
all of them yet. But having this feature in place provides another lever to
help us improve performance over time.

For now though, we at least have a much simpler implementation of complex
numbers, and will be able to take advantage of efficient rational matrices
and other similar niceties.


## Addendum: Under the hood

For purposes of calling C and writing reflective code, it helps to know a
bit about how immutable types are implemented. Before this change, we had
types `AbstractKind`, `BitsKind`, and `CompositeKind`, for separating which
types are abstract, which are represented by immutable bit strings, and which
are mutable aggregates. It was sometimes convenient that the type system
reflected these differences, but also a bit unwarranted since all these
types participate in the same hierarchy and follow the same subtyping rules.

Now, the type landscape is both simpler and more complex. The three Kinds
have been merged into a single kind called `DataType`. The type of every
value in Julia is now either a `DataType`, or else a tuple type (union types
still exist, but of course are always abstract). To find out the details
of a `DataType`'s physical representation, you must query its properties.
`DataType`s have three boolean properties `abstract`, `mutable`, and
`pointerfree`, and an integer property `size`. The `CompositeKind` properties
`names` and `types` are still there to describe fields.

The `abstract` property indicates that the type was declared with the
`abstract` keyword and has no direct instances. `mutable` indicates, for
concrete types, whether instances are mutable. `pointerfree` means that
instances contain "just data" and no references to other Julia values.
`size` gives the size of an instance in bytes.

What used to be `BitsKind`s are now `DataType`s that are immutable, concrete,
have no fields, and have non-zero size. The former `CompositeKind`s are
mutable and concrete, and either have fields or are zero size if they
have zero fields. Clearly, new combinations are now possible. We have
already mentioned immutable types with fields. We could have the equivalent
of mutable `BitsKind`s, but this combination is not exposed in the language,
since it is easily emulated using mutable fields. Another new combination
is abstract types with fields, which would allow you to declare that all
subtypes of some abstract type should have certain fields. That one is
definitely useful, and we plan to provide syntax for it.

Typically, the only time you need to worry about these things
is when calling native code, when you want to know whether some array
or struct has C-compatible data layout. This is handled by the type
predicate `isbits(T)`.
