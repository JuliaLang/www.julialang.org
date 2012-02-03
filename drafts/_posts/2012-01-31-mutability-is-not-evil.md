---
layout: post
title:  Mutability Is Not Evil
author: <a href="http://karpinski.org/">Stefan Karpinski</a>
---

Some things are most naturally thought of as mutable containers of values.
For other things, mutability causes unexpected behavior and potentially nasty surprises.
The distinction, however, is entirely psychological:

- If you conceptualize something as a container of other values, having an independent identity from the particular values it contains, then you have an object that is naturally *mutable*.
- If, on the other hand, a thing is conceptually identified with its value, such that if you change that value, it ceases to psychologically be the same object, then you have something that is naturally *immutable*.

The classic example of a naturally immutable object is a number:
if you flip the last bit of an integer, it is not the same integer anymore.
Likewise, if you change the imaginary part of a complex number, it becomes a different complex number.
The intuitive immutability of numbers can be clarified with a simple code example:

    julia> x = 1
    1

    julia> y = x
    1

    julia> y += 1
    2

    julia> x
    1

Hopefully you are not surprised that the value of `x` is still 1.
It would be very counter-intuitive for `x` to be 2.
That would mean that the variables `x` and `y` referred to the same shared integer value, which could be modified in place.
In other words `x` and `y` are made to refer to the same integer object via assignment, and then the `y += 1` increment operation changes the value of the integer 1 itself to 2 — 1 *becomes* 2.
Yeah, that would be weird.
Instead, we expect 1 to always remain 1 and 2 to be an entirely different integer.
Thus, when we write `y += 1`, we are not modifying the value of the integer 1, but rather are assigning the entirely different integer value `2 = 1 + 1` to the variable `y`, having no effect on `x`.

Unintuitive as mutation of integer values may be, there is a very common family of languages in which this is precisely what happens: machine language.
Of course, machine language doesn't have variables.
Instead, values are stored in registers.
But you can modify an integer stored in a register in-place.
Thus, at the lowest level, all things — even integers — are mutable.
Once variables are introduced, however, this behavior becomes so unintuitive that even C, which is often talked about as being "portable assembly language," makes its built-in numeric types immutable:
if the above example where in C, `x` would be 1 as everyone expects.
However, the apparent immutability of numeric values is just a comforting illusion provided by the compiler:
in order to get any sort of performance, the compiler needs to translate immutable operations on integers and floats into explicit copies and in-place mutations of values in registers.
The seamlessness of the illusion stems purely from the fact that compilers are really, really good at doing this.

The most intuitive example of a naturally mutable data type is an array:
we think of an array as a container into which we can put values.
If we change a value in the array, we still think of it as the same array.
Let's see this natural mutability in action:

    julia> x = [1]
    [1]

    julia> y = x
    [1]

    julia> y[1] += 1
    2

    julia> x
    [2]

In this case, unless you've only ever done functional programming and/or PHP (in either case, welcome!), you will likely expect that both `x` and `y` to refer to the same array object, which at the end contains the integer `2` (Julia has 1-based array indexing like Matlab and Mathematica).
This expectation comes from thinking of an array like a box:
if a box contains an apple and I replace the apple with an orange, it's still the same box, and will subsequently contain an orange regardless of who looks in it.
Likewise, the operation `y[1] += 1` intuitively modifies the contents of that array, but doesn't affect the identity of the array itself:
`x` and `y` still refer to the same array, and therefore have the same contents.

Just as with integers, mutable array behavior comes naturally to computer hardware:
just represent an array as an address in memory, where the values in the array are stored, one after another;
the index and item size can be used to immediately compute where to look for each value.
When one of the values is altered by the programmer, modify the appropriate location in memory.
This, of course, is precisely what C does.
It provides a slight abstraction from what is happening in hardware — but not very much.
Higher-level imperative languages like Java, Python, Perl and Ruby provide some additional safety like bounds and type checks, but otherwise essentially inherit this approach.

There are, however, other reasonable semantics for arrays.
At the complete opposite extreme, Haskell, Clean, and other purely functional programming languages simply don't allow you mutation of any data structures once they're created.
Clojure takes an interesting hybrid approach:
the standard library provides a variety of data structure implementations that can share structure between modified copies, allowing low-cost immutable semantics.
When mutability is deemed unavoidable, however, blocks of code can declare that they are going to mutate a particular data structure, giving warning to both programmers and other code that might not expect mutation.

Even among imperative languages, there are cases where arrays aren't exactly mutable in the normal sense.
If the above example were done in PHP, the original array would still have its original contents at the end.
That doesn't quite mean that arrays are immutable in PHP, since you can change an array by updating one of its values, by writing `$x[0]+=1`, for example.
Instead, arrays behave as though they are copied on assignment, so that there is a conceptual one-to-one correspondence between variables and array objects referenced by them.
One can think of this behavior as immutability, however, by pretending that writing things like `$x[0]+=1` actually replaces the array `$x` with a new, modified array.
Thus, PHP exhibits immutable array behavior in mutable clothing.
Matlab takes an even more hybridized approach:
arrays are mutable and shared between variables but are copied (effectively) when passed into subroutines.
If you want to alter an array via a subroutine, you have to pass it to a subroutine that returns the modified array.

Since hardware favors easy and efficient implementation of mutable array semantics, some approach is required to implement immutable behavior.
For all kinds of values (not just arrays), there are three ways to achieve immutable behavior:

1. Actually never mutate values.
2. Mark assigned values to be copied on modification ("copy-on-write").
3. Write a very clever compiler that can efficiently simulate immutable semantics using mutation.

The first approach is problematic for obvious reasons:
if you never mutate a value, you have to create lots and lots of copies of everything;
you run out of memory pretty quickly and many algorithms that are efficient with mutation become horribly, painfully inefficient.

The copy-on-write approach is precisely how PHP's array behavior is implemented.
While copy-on-write is a clever optimization that can avoid some copies, it has its own downsides.
For one thing, it makes array modification an operation that can potentially be surprisingly expensive:
one day your program modifies an array and everything is cool, it's an O(1) operation;
the next day, some seemingly unrelated code changes and suddenly that array modification becomes an O(*n*) operations.
When *n* is big — say 100 GB — this can be problematic.
Of course, PHP is rarely in this situation.
There are also non-trivial overheads induced by keeping track of all the metadata required for copy-on-write behavior.

The third approach is the most desirable way to achieve immutable semantics, but the hardest to implement.
Fortunately, for small atomic values like integers and floats that can fit in registers, this is a well-solved problem.
C and Fortran compilers have this one down.
For larger data structures, Haskell compilers do a very formidable job of cleverly translating immutable semantics into efficient implementations.
However, it's taken them 20 years to get there — and they're not really <u>there</u> yet.
The reasoning and history behind this journey is detailed in [this fascinating talk](http://yow.eventer.com/events/1004/talks/1054) by Simon Peyton Jones, one of the designers of Haskell.

But why try to make arrays behave immutably in the first place?
Our intuition about arrays is that they are containers:
they have identity independent of what you put in them.
It's easy and intuitive for us to think about them like that, and it's fairly simple to come up with and express efficient mutating algorithms that operate on arrays.
It is generally acknowledged to be much harder to think up and understand purely functional algorithms on arrays — especially efficient ones — or rather ones that are compilers are clever enough to turn into efficient mutating implementations.

Therein lies the major difference between making numbers behave immutably and making arrays behave immutably:
in the case of arrays, we already think about them as contains, so mutation is our natural inclination.
Since this lines up with how hardware can most easily implement arrays, shouldn't we just go with it?
In the case of numbers, virtually all languages have chosen to make the compiler work harder so that the programmer can work less hard.
In the case of making data structures immutable, it seems like choosing immutability makes the compiler work even harder — so that the programmer can also work harder.
Maybe we should just embrace mutability and go with it.
After all it's threading that's actually evil.
But that's a story for another time.
