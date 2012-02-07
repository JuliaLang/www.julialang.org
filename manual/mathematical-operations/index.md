---
layout: manual
title:  Mathematical Operations
---

Julia provides a complete collection of basic arithmetic and bitwise operators across all of its numeric primitive types, as well as providing portable, efficient implementations of a comprehensive collection of standard mathematical functions.

## Arithmetic and Bitwise Operators

The following [arithmetic operators](http://en.wikipedia.org/wiki/Arithmetic#Arithmetic_operations) are supported on all primitive numeric types:

- `+x` — unary plus is the identity operation.
- `-x` — unary minus maps values to their additive inverses.
- `x + y` — binary plus performs addition.
- `x - y` — binary minus performs subtraction.
- `x * y` — times performs multiplication.
- `x / y` — divide performs division.

The following [bitwise operators](http://en.wikipedia.org/wiki/Bitwise_operation#Bitwise_operators) are supported on all primitive integer types:

- `~x` — bitwise not.
- `x & y` — bitwise and.
- `x | y` — bitwise or.
- `x $ y` — bitwise xor.
- `x >>> y` — [logical shift][] right.
- `x >> y` — [arithmetic shift][] right.
- `x << y` — logical/arithmetic shift left.

[logical shift]:    http://en.wikipedia.org/wiki/Logical_shift
[arithmetic shift]: http://en.wikipedia.org/wiki/Arithmetic_shift

Here are some simple examples using arithmetic operators:

    julia> 1 + 2 + 3
    6

    julia> 1 - 2
    -1

    julia> 3*2/12
    0.5

(By convention, we tend to space less tightly binding operators less tightly, but there are no syntactic constraints.)

Julia has a type promotion system that allows arithmetic operations on mixtures of argument types to "just work" naturally and automatically (see [Conversion and Promotion](../conversion-and-promotion) for details of the promotion system):

    julia> 1 + 2.5
    3.5

    julia> 0.5*12
    6.0

    julia> 3*2/12 + 1
    1.5

The above expressions all promote to `Float64`.
However, more nuanced promotions also work:

    julia> uint8(12) - int8(15)
    -3

    julia> typeof(ans)
    Int16

    julia> uint8(12) - float32(1.5)
    10.5

    julia> typeof(ans)
    Float32

Here are some examples with bitwise operators:

    julia> ~123
    -124

    julia> ~uint32(123)
    4294967172

    julia> ~uint8(123)
    132

    julia> 123 & 234
    106

    julia> 123 | 234
    251

    julia> typeof(ans)
    Int64

    julia> uint8(123) | uint16(234)
    251

    julia> typeof(ans)
    Uint16

    julia> 123 $ 234
    145

As a general rule of thumb, arguments are promoted to the smallest type that can accurately represent all of the arguments.

Every binary arithmetic and bitwise operator also has an updating version that assigns the result of the operation back into its left operand.
For example, the updating form of `+` is the `+=` operator.
Writing `x += 3` is equivalent to writing `x = x + 3`:

      julia> x = 1
      1

      julia> x += 3
      4

      julia> x
      4

The updating versions of all the binary arithmetic and bitwise operators are:

    +=  -=  *=  /=  &=  |=  $=  >>>=  >>=  <<=

## Numeric Comparisons

Standard comparison operations are defined for all the primitive numeric types:

- `==` — equality.
- `!=` — inequality.
- `<` — less than.
- `<=` — less than or equal to.
- `>` — greater than.
- `>=` — greater than or equal to.

Here are some simple examples:

    julia> 1 == 1
    true

    julia> 1 == 2
    false

    julia> 1 != 2
    true

    julia> 1 == 1.0
    true

    julia> 1 < 2
    true

    julia> 1.0 > 3
    false

    julia> 1 >= 1.0
    true

    julia> -1 <= 1
    true

    julia> -1 <= -1
    true

    julia> -1 <= -2
    false

    julia> 3 < -0.5
    false

As is evident here, promotion also applies to comparisons:
the comparisons are performed in whatever type the arguments are promoted to, which is generally the smallest type in which the values can be faithfully represented.

After promotion to a common type, integers are compared in the standard manner:
by comparison of bits.
Floating-point numbers are compared according to the [IEEE 754 standard](http://en.wikipedia.org/wiki/IEEE_754-2008):

- finite numbers are ordered in the usual manner
- `Inf` is equal to itself and greater than everything else except `NaN`
- `-Inf` is equal to itself and less then everything else except `NaN`
- `NaN` is not equal to, less than, or greater than anything, including itself.

The last point is potentially suprprising and thus worth noting:

    julia> NaN == NaN
    false

    julia> NaN != NaN
    true

    julia> NaN < NaN
    false

    julia> NaN > NaN
    false

For situations where one wants to compare floating-point values so that `NaN` equals `NaN`, such as hash key comparisons, the function `isequal` is also provided, which considers `NaN`s to be equal to each other:

    julia> isequal(NaN,NaN)
    true

Unlike most languages, with the [notable exception of Python](http://en.wikipedia.org/wiki/Python_syntax_and_semantics#Comparison_operators), comparisons can be arbitrarily chained:

    julia> 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
    true

Chaining comparisons is often quite convenient in numerical code.
Only as many initial comparisons and their operand expressions as are necessary to determine the final truth value of the entire chain are evaluated.
See [Short-Circuit Evaluation](../control-flow#Short-Circuit+Evaluation) for further discussion of this behavior.

## Mathematical Functions

Julia provides a comprehensive collection of mathematical functions and operators.
These mathematical operations are defined over as broad a class of numerical values as permit sensible definitions, including integers, floating-point numbers, rationals, and complexes, wherever such definitions make sense.

- `round(x)` — round `x` to the nearest integer.
- `iround(x)` — round `x` to the nearest integer, giving an integer-typed result.
- `floor(x)` — round `x` towards `-Inf`.
- `ceil(x)` — round `x` towards `+Inf`.
- `trunc(x)` — round `x` towards zero.
- `itrunc(x)` — round `x` towards zero, giving an integer-typed result.
- `div(x,y)` — truncated division; quotient rounded towards zero.
- `fld(x,y)` — floored division; quotient rounded towards `-Inf`.
- `rem(x,y)` — remainder; satisfies `x == div(x,y)*y + rem(x,y)`, implying that sign matches `x`.
- `mod(x,y)` — modulus; satisfies `x == fld(x,y)*y + mod(x,y)`, implying that sign matches `y`.
- `gcd(x,y...)` — greatest common divisor of `x`, `y`... with sign matching `x`.
- `lcm(x,y...)` — least common multiple of `x`, `y`... with sign matching `x`.
- `abs(x)` — a positive value with the magnitude of `x`.
- `abs2(x)` — the squared magnitude of `x`.
- `sign(x)` — indicates the sign of `x`, returning -1, 0, or +1.
- `signbit(x)` — indicates the sign bit of `x`, returning -1 or +1.
- `copysign(x,y)` — a value with the magnitude of `x` and the sign of `y`.
- `sqrt(x)` — the square root of `x`.
- `cbrt(x)` — the cube root of `x`.
- `hypot(x,y)` — accurate `sqrt(x^2 + y^2)` for all values of `x` and `y`.
- `pow(x,y)` — `x` raised to the exponent `y`.
- `exp(x)` — the natural exponential function at `x`.
- `expm1(x)` — accurate `exp(x)-1` for `x` near zero.
- `ldexp(x,n)` — `x*2^n` computed efficiently for integral `n`.
- `log(x)` — the natural logarithm of `x`.
- `log(b,x)` — the base `b` logarithm of `x`.
- `log2(x)` — the base 2 logarithm of `x`.
- `log10(x)` — the base 10 logarithm of `x`.
- `log1p(x)` — accurate `log(1+x)` for `x` near zero.
- `logb(x)` — returns the binary exponent of `x`.
- `erf(x)` — the [error function](http://en.wikipedia.org/wiki/Error_function) at `x`.
- `erfc(x)` — accurate `1-erf(x)` for large `x`.
- `gamma(x)` — the [gamma function](http://en.wikipedia.org/wiki/Gamma_function) at `x`.
- `lgamma(x)` — accurate `log(gamma(x))` for large `x`.

For an overview of why functions like `hypot`, `expm1`, `log1p`, and `erfc` are necessary and useful, see John D. Cook's excellent pair of blog posts on the subject:
[expm1, log1p, erfc](http://www.johndcook.com/blog/2010/06/07/math-library-functions-that-seem-unnecessary/), and [hypot](http://www.johndcook.com/blog/2010/06/02/whats-so-hard-about-finding-a-hypotenuse/).

All the standard trigonometric functions are also defined:

    sin    cos    tan    cot    sec    csc
    sinh   cosh   tanh   coth   sech   csch
    asin   acos   atan   acot   asec   acsc
    acoth  asech  acsch  sinc   cosc   atan2

These are all single-argument functions, with the exception of [`atan2`](http://en.wikipedia.org/wiki/Atan2), which gives the angle in [radians](http://en.wikipedia.org/wiki/Radian) between the *x*-axis and the point specified by its arguments, interpreted as *x* and *y* coordinates.

For notational convenience, there are equivalent operator forms for the `mod` and `pow` functions:

- `x % y` is equivalent to `mod(x,y)`.
- `x ^ y` is equivalent to `pow(x,y)`.

Like arithmetic and bitwise operators, `%` and `^` also have updating forms.
As with other operators, `x %= y` means `x = x % y` and `x ^= y` means `x = x^y`:

    julia> x = 2; x ^= 5; x
    32

    julia> x = 7; x %= 4; x
    3
