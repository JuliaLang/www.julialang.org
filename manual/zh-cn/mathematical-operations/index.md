---
layout: manual
title:  Mathematical Operations
---
<cn>
---
layout: manual
title:  Mathematical Operations
---
</cn>

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

<cn>
Julia提供了对元数据类型的基本算术和位操作运算符的一个完整的集,并提供了和标准的数学函数提供的运算操作一样的易用和高效性。

## 算术和位操作运算符

以下是 [算术运算符](http://en.wikipedia.org/wiki/Arithmetic#Arithmetic_operations) 所有的元数据类型都提供:

- `+x` — 一元加运算符是恒等运算，等于其自身(译者注：a = -1; +a 值为-1)。
- `-x` — 一元减运算符得到与x的相反的数.
- `x + y` — 二元加运算符得到两个数的和.
- `x - y` — 二元减运算符得到两个数的差.
- `x * y` — 星号求两个数的积.
- `x / y` — 除号求两个数的商.（译者注：2/3=0.66666666666）

一下是[位操作符](http://en.wikipedia.org/wiki/Bitwise_operation#Bitwise_operators)所有的整形提供了这些操作:

- `~x` — 求反位操作.
- `x & y` — 求与位操作.
- `x | y` — 求或位操作.
- `x $ y` — 求异或位操作.
- `x >>> y` — [逻辑移位][] 右移.
- `x >> y` — [算术移位][] 右移.
- `x << y` — 逻辑/算术 左移.
</cn>

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

Julia's promotion system makes arithmetic operations on mixtures of argument types "just work" naturally and automatically.
See [Conversion and Promotion](../conversion-and-promotion) for details of the promotion system.

Here are some examples with bitwise operators:

    julia> ~123
    -124

    julia> 123 & 234
    106

    julia> 123 | 234
    251

    julia> 123 $ 234
    145

    julia> ~uint32(123)
    0xffffff84

    julia> ~uint8(123)
    0x84

<cn>
[逻辑移位]:    http://en.wikipedia.org/wiki/Logical_shift
[算术移位]: http://en.wikipedia.org/wiki/Arithmetic_shift

下面是算术运算符的例子：

    julia> 1 + 2 + 3
    6

    julia> 1 - 2
    -1

    julia> 3*2/12
    0.5

(按惯例，我们在运算符两边加上空格，但这并不是语法上的要求)

Julia的类型转换系统让算术运算符在混合参数之间自然并自动起作用.跟多关于类型转换的内容见[Conversion and Promotion](../conversion-and-promotion).

下面是一些位操作运算符:

    julia> ~123
    -124

    julia> 123 & 234
    106

    julia> 123 | 234
    251

    julia> 123 $ 234
    145

    julia> ~uint32(123)
    0xffffff84

    julia> ~uint8(123)
    0x84

每个二进制算术和位操作运算符都提供了一个升级版，可以将运算结果赋值给左操作数。
请看下面的列子, `+`的高级运算符是 `+=` . `x += 3` 等价于`x = x + 3`:

      julia> x = 1
      1

      julia> x += 3
      4

      julia> x
      4

所有算术和位操作运算符的升级版如下：

    +=  -=  *=  /=  &=  |=  $=  >>>=  >>=  <<=

## 数值比较运算符

标准比较运算符定义在所有的元数据类型上：

- `==` — 判等.
- `!=` — 不等.
- `<` — 小于.
- `<=` — 小于或等于.
- `>` — 大于.
- `>=` — 大于等于.

请看示例：

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

</cn>
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

Integers are compared in the standard manner — by comparison of bits.
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

Mixed-type comparisons between signed integers, unsigned integers, and floats can be very tricky.
A great deal of care has been taken to ensure that Julia does them correctly.

Unlike most languages, with the [notable exception of Python](http://en.wikipedia.org/wiki/Python_syntax_and_semantics#Comparison_operators), comparisons can be arbitrarily chained:

    julia> 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
    true

<cn>
整形按照标准的比较法————逐位比较。
浮点数比较的依据按照[IEEE 754 standard](http://en.wikipedia.org/wiki/IEEE_754-2008):

- 有限的浮点数按通常的方式表达
- `Inf` 等于它自己但是比其他所有数都大，除了'NaN'
- `-Inf`等于它自己但是比其他所有数都小，除了'NaN
- `NaN` 不等于，不小于，不大于任何数，甚至包括它自己。

最后一点是个小陷阱，因此值得注意：

    julia> NaN == NaN
    false

    julia> NaN != NaN
    true

    julia> NaN < NaN
    false

    julia> NaN > NaN
    false

当需要比较浮点数而遇到`NaN`等于`NaN`时,如hash值比较,函数`isequal`提供了帮助,它可以正确的识别`NaN`等于它自己:

    julia> isequal(NaN,NaN)
    true

混合类型之间的比较，如有符号整形、无符号整形、浮点数之间的比较是惑人的。 一个考虑很好的方案确保了Julia可以正确的处理上述问题。

不像其他大多数语言, 如 [典型的Pyhont表达式](http://en.wikipedia.org/wiki/Python_syntax_and_semantics#Comparison_operators),
比较可以随意连接:

    julia> 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
    true

</cn>
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
- `signbit(x)` — indicates whether the sign bit is on (1) or off (0).
- `copysign(x,y)` — a value with the magnitude of `x` and the sign of `y`.
- `flipsign(x,y)` — a value with the magnitude of `x` and the sign of `x*y`.
- `sqrt(x)` — the square root of `x`.
- `cbrt(x)` — the cube root of `x`.
- `hypot(x,y)` — accurate `sqrt(x^2 + y^2)` for all values of `x` and `y`.
- `pow(x,y)` — `x` raised to the exponent `y`.
- `exp(x)` — the natural exponential function at `x`.
- `expm1(x)` — accurate `exp(x)-1` for `x` near zero.
- `ldexp(x,n)` — `x*2^n` computed efficiently for integer values of `n`.
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

In the former case, the spelled-out `mod` operator is the "canonical" form, and the `%` operator form is retained for compatibility with other systems, whereas in the latter case, the `^` operator form is canonical and the spelled-out `pow` form is retained for compatibility.
Like arithmetic and bitwise operators, `%` and `^` also have updating forms.
As with other operators, `x %= y` means `x = x % y` and `x ^= y` means `x = x^y`:

    julia> x = 2; x ^= 5; x
    32

    julia> x = 7; x %= 4; x
    3
<cn>
连接的比较操作符在数值运算代码中通常可以增加方便。
只有在计算了所有的比较操作后才能决定整个比较表达式链的真值。
跟多的讨论见[Short-Circuit Evaluation](../control-flow#Short-Circuit+Evaluation)。

## 数学函数

Julia 提过了一个完整的数学函数和操作符集。
这些算术操作定义在一个非常广的数值类型上，包括有整形、浮点型、有理数、复数等

- `round(x)` — 求最靠近'x'的整数值（译者注，表示为浮点数）.
- `iround(x)` —求最靠近'x'的整数值（译者注，表示为整形数）.
- `floor(x)` — 求从负无穷方向最靠近'x'的的整数值。（译者注，表示为浮点数）.
- `ceil(x)` —  求从正无穷方向最靠近'x'的整数值。（译者注，表示为浮点数）.
- `trunc(x)` — 求最从'0'靠近'x'的整数值。（译者注，表示为浮点数）.
- `itrunc(x)` — 求最从‘0'靠近'x'的整数值。（译者注，表示为整数）.
- `div(x,y)` — 截断除，得到从‘0’逼近的整数。
- `fld(x,y)` — 地板除，得到从负无穷逼近的整数。
- `rem(x,y)` — 求余; 符合条件 `x == div(x,y)*y + rem(x,y)`, 其符号和`x`一致.
- `mod(x,y)` — 求摸; 符合条件 `x == fld(x,y)*y + mod(x,y)`, 其符号和`x`一致.
- `gcd(x,y...)` — 求最大公约数，符号和 `x`一致.
- `lcm(x,y...)` — 最小公倍数，符号和 `x`一致.
- `abs(x)` — 求'x'的绝对值。
- `abs2(x)` — 求'x'的平方根。
- `sign(x)` — 指明'x'的符号，分别返回 -1, 0, or +1.
- `signbit(x)` — 测试某位是否被设置了，设置了为(1) 没有被设置为 (0).
- `copysign(x,y)` — 返回值的绝对值为'x'绝对值的大小，但是拥有'y'的符号。
- `flipsign(x,y)` — 返回值的绝对值为'x'绝对值的大小，但是拥有'x*y'的符号.
- `sqrt(x)` — `x`的平方根.
- `cbrt(x)` — `x`的立方根.
- `hypot(x,y)` — 计算 `sqrt(x^2 + y^2)` .
- `pow(x,y)` — 求`x`的 `y`次幂.
- `exp(x)` — 求'e'的'x'次幂。
- `expm1(x)` — 计算`exp(x)-1`（译者注：最后一个是数字一不是字母'l'）.
- `ldexp(x,n)` — 计算`x*2^n`值（译者注：x需为浮点型，而n需为整形）。
- `log(x)` — 求`x`自然对数.
- `log(b,x)` — 求以 `b`为底的 `x`对数.
- `log2(x)` —  求以 `2`为底的 `x`对数.
- `log10(x)` — 求以 `10`为底的 `x`对数.
- `log1p(x)` — 求 `log(1+x)`.
- `logb(x)` — returns the binary exponent of `x`.
- `erf(x)` —  [error function](http://en.wikipedia.org/wiki/Error_function) .
- `erfc(x)` — 计算 `1-erf(x)` .
- `gamma(x)` — [gamma function](http://en.wikipedia.org/wiki/Gamma_function).
- `lgamma(x)` — 计算 `log(gamma(x))`.

要想知道为什么函数 `hypot`, `expm1`, `log1p`, 以及 `erfc`是如此的必要和有用，见John D. Cook's excellent pair of blog posts on the subject: [expm1, log1p, erfc](http://www.johndcook.com/blog/2010/06/07/math-library-functions-that-seem-unnecessary/),
以及[hypot](http://www.johndcook.com/blog/2010/06/02/whats-so-hard-about-finding-a-hypotenuse/).

所有的标准三角函数定义如下：

    sin    cos    tan    cot    sec    csc
    sinh   cosh   tanh   coth   sech   csch
    asin   acos   atan   acot   asec   acsc
    acoth  asech  acsch  sinc   cosc   atan2

这些都是一元参数函数，表达式 [`atan2`](http://en.wikipedia.org/wiki/Atan2), 计算了角度的[radians](http://en.wikipedia.org/wiki/Radian) 
*x*-axis和参数中的由 *x* 和 *y* 给出的点。

为了表达的方便，Julia提供了和函数`mod` and `pow`一样功能的操作符:

- `x % y` 等价于 `mod(x,y)`.
- `x ^ y` 等价于 `pow(x,y)`.

在之前的情况中，操作符`mod`是官方的格式, `%`是为了和其他系统的兼容而提供的，'^'操作符也是一样的情况。
和算术和位操作符一样，`%`和`^` 也有其升级形式.
和其他操作符一样`x %= y` 等于 `x = x % y` ； `x ^= y`等于`x = x^y`:

    julia> x = 2; x ^= 5; x
    32

    julia> x = 7; x %= 4; x
    3

</cn>
