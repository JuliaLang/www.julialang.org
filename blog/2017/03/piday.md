@def rss_pubdate = Date(2017, 3, 14)
@def rss_description = """ Some fun with &pi; in Julia | !pi (/assets/blog/2017-03-14-piday/pi.png) ^credit ... """
@def published = "14 March 2017"
@def title = "Some fun with &#928; in Julia"
@def authors = "Simon Byrne, Luis Benet and David Sanders"
@def hasmath = true
@def hascode = true

![pi](/assets/images/pi.png)

> Image courtesy of [Cormullion](https://github.com/cormullion), code [here](https://gist.github.com/cormullion/e979d819e478da73280faaeb67490888).
> \\
> This post is available as a Jupyter notebook [here](https://github.com/simonbyrne/Pi.jl/blob/master/pi.ipynb).

\toc

## &pi; in Julia

by [Simon Byrne](https://github.com/simonbyrne)

Like most technical languages, Julia provides a variable constant for &pi;. However Julia's handling is a bit special.

```julia
pi

π = 3.1415926535897...
```

It can also be accessed via the unicode symbol (you can get it at the REPL or in a notebook via the TeX completion `\pi` followed by a tab)

```julia
π

π = 3.1415926535897...

```

You'll notice that it doesn't print like an ordinary floating point number: that's because it isn't one.

```julia
typeof(pi)

Irrational{:π}
```

&pi; and a few other irrational constants are instead stored as special `Irrational` values, rather than being rounded to `Float64`. These act like ordinary numeric values, except that they can are converted automatically to any floating point type without any intermediate rounding:

```julia
1 + pi # integers are promoted to Float64 by default

4.141592653589793
```

```julia
Float32(1) + pi # Float32

4.141593f0
```

This is particularly useful for use with arbitrary-precision `BigFloat`s, as &pi; can be evaluated to full precision (rather than be truncated to `Float64` and converted back).

```julia
BigFloat(1) + pi # 256 bits by default

4.141592653589793238462643383279502884197169399375105820974944592307816406286198
```

If &pi; were stored as a `Float64`, we would instead get

```julia
BigFloat(1) + Float64(pi)

4.141592653589793115997963468544185161590576171875000000000000000000000000000000

```

In fact `BigFloat` (which uses the [MPFR](https://www.mpfr.org) library) will compute &pi; on demand to the current precision, which is set via `setprecision`. This provides an easy way to get its digits:

```julia
# to 1024 bits
setprecision(BigFloat, 1024) do
    BigFloat(pi)
end

3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233786783165271201909145648566923460348610454326648213393607260249141273724586997
```

The last few printed digits may be incorrect due to the conversion from the internal binary format of `BigFloat` to the decimal representation used for printing.
This is just a presentation issue, however – the internal binary representation is correctly rounded to the last bit.

Another neat property of `Irrational`s is that inequalities are correct:

```julia
Float64(pi) < pi < nextfloat(Float64(pi))

true
```

## &pi; via inline assembly instructions

by [Simon Byrne](https://github.com/simonbyrne)

Julia provides a very low-level `llvmcall` interface, which allows the user to directly write [LLVM intermediate representation](https://llvm.org/docs/LangRef.html), including the use of inline assembly. The following snippet calls the `fldpi` instruction ("**f**loating point **l**oa**d** **pi**") which loads the constant &pi; onto the floating point register stack (this works only on x86 and x86_64 architectures)

```julia
function asm_pi()
    Base.llvmcall(
    """ %pi = call double asm "fldpi", "={st}"()
        ret double %pi""",
    Float64, Tuple{})
end

asm_pi (generic function with 1 method)
```

```julia
asm_pi()

3.141592653589793

```

We can look at the actual resulting code that is generated:

```julia
@code_native asm_pi()

    	.section	__TEXT,__text,regular,pure_instructions
    Filename: In[10]
    	pushq	%rbp
    	movq	%rsp, %rbp
    Source line: 2
    	fldpi
    	fstpl	-8(%rbp)
    	movsd	-8(%rbp), %xmm0         ## xmm0 = mem[0],zero
    	popq	%rbp
    	retq

```

If you're wondering what the rest of these instructions are doing:

1. the `pushq` and `movq` adds to the [call stack frame](https://en.wikipedia.org/wiki/Call_stack).
2. `fldpi` pushes &pi; to the x87 floating point register stack
  - x87 is the older legacy floating point instruction set dating back to the original [Intel 8087 coprocessor](https://en.wikipedia.org/wiki/Intel_8087).
3. `fstpl` and `movsd` moves the value to the SSE floating point register `xmm0`
  - Julia, like most modern software, uses the newer SSE instruction set for its floating point operations. This also allows us to take advantage of things like [SIMD operations](https://en.wikipedia.org/wiki/SIMD).
4. `popq` and `retq` pops the call stack frame.

## &pi; using a Taylor series expansions

by [Luis Benet](https://github.com/lbenet), Instituto de Ciencias Físicas, Universidad Nacional Autónoma de México (UNAM))

This will demonstrate how to evaluate &pi; using various Taylor series expansions via the [TaylorSeries.jl](https://github.com/JuliaDiff/TaylorSeries.jl) package.

```julia
using TaylorSeries
```

### Madhava's formula

One of the standard trigonmetric identities is

$$ \tan\left( \frac{\pi}{6} \right) = \frac{1}{\sqrt{3}}. $$

Therefore, by taking the Taylor expansion of $ 6 \arctan(x) $ around 0 we may obtain the value of $\pi$, by evaluating it at $1/\sqrt{3}$, a value which is within the radius of convergence.

We obtain the Taylor series of order 37th, using `BigFloat`s:

```julia
series1 = 6atan( Taylor1(BigFloat, 37) )
convert(Taylor1{Rational{BigInt}},series1)

6//1 t - 2//1 t³ + 6//5 t⁵ - 6//7 t⁷ + 2//3 t⁹ - 6//11 t¹¹ + 6//13 t¹³ - 2//5 t¹⁵ + 6//17 t¹⁷ - 6//19 t¹⁹ + 2//7 t²¹ - 6//23 t²³ + 6//25 t²⁵ - 2//9 t²⁷ + 6//29 t²⁹ - 6//31 t³¹ + 2//11 t³³ - 6//35 t³⁵ + 6//37 t³⁷ + 𝒪(t³⁸)

```

Note that the series above has only odd powers, so we will be using in this case 18 coefficients.

Evaluating that expression in $1/\sqrt{3}$ we get

```julia
pi_approx1 = evaluate(series1, 1/sqrt(big(3)))

3.141592653647826046431202390582141253830948237428790668441592864548346569098516
```


Then, the 37th order Taylor expansion yields a value which differs from $\pi$ in:

```julia
abs(pi - pi_approx1)

5.803280796855900730263836963377883805368484746664827224053016281231814650118929e-11
```


To obtain more accurate results, we may simply increase the order of the expansion:

```julia
series2 = 6atan( Taylor1(BigFloat,99) ) # 49 coefficients of the series
pi_approx2 = evaluate(series2, 1/sqrt(BigInt(3)))

3.141592653589793238462643347272152237127662423839333289949470742535834074912581
```


```julia
abs(pi - pi_approx2)

3.600735064706950697553577253102547384977198233137361734413175534929622111373249e-26
```


This formulation is one of the [*Madhava* or *Gregory–Leibniz series*](https://en.wikipedia.org/wiki/Madhava_series#Another_formula_for_the_circumference_of_a_circle):

$$\pi = 6 \sum_{n=0}^{\infty} (-1)^n \frac{(1/\sqrt{3})^{2n+1}}{2n+1}.$$

### Machin's approach

Following the same idea, [John Machin](https://en.wikipedia.org/wiki/John_Machin#Formula) derived an algorithm which converges much faster, using the identity

$$\frac{\pi}{4} = 4 \arctan\left(\frac{1}{5}\right) - \arctan\left(\frac{1}{239}\right).$$

Following what we did above, using again a 37th Taylor expansion:

```julia
ser = atan( Taylor1(BigFloat, 37) )
pi_approx3 = 4*( 4*evaluate(ser, 1/big(5)) - evaluate(ser, 1/big(239)) )
3.141592653589793238462643383496777424642594661632063407072684671069773618535135
```


```julia
abs(pi - pi_approx3)
2.17274540445425262256957586097740078761957212248936631045983596428448951876822e-28
```


## Finding guaranteed bounds on &pi;

by [David P. Sanders](http://sistemas.fciencias.unam.mx/~dsanders/),  Department of Physics, Faculty of Sciences, National University of Mexico (UNAM)

### Using standard floating-point arithmetic

We will calculate *guaranteed* (i.e., *validated*, or mathematically rigorous) bounds on $\pi$ using just floating-point arithmetic. This requires "directed rounding", i.e. the ability to control in which direction floating-point operations are rounded.

This is based on the book [*Validated Numerics*](https://press.princeton.edu/titles/9488.html) (Princeton, 2011) by [Warwick Tucker](https://www2.math.uu.se/~warwick/CAPA/warwick/warwick.html).

Consider the infinite series

$$ S := \sum_{n=1}^\infty \frac{1}{n^2},$$

whose exact value is [known](https://en.wikipedia.org/wiki/Basel_problem) to be $S = \frac{\pi^2}{6}$.
Thus, if finding guaranteed bounds on $S$ will give guaranteed bounds on $\pi$.

The idea is to split $S$ up into two parts, $S = S_N + T_N$, where
$ S_N := \sum_{n=1}^N \frac{1}{n^2}$ contains the first $N$ terms,
and $T_N := S - S_N = \sum_{n=N+1}^\infty \frac{1}{n^2}$ contains the rest (an infinite number of terms).

We will evaluate $S_N$ numerically, and use the following analytical bound for $T_N$:

$$\frac{1}{N+1} \le T_N \le \frac{1}{N}$$.

This is obtained by approximating the sum in $T_N$ using integrals from below and above:

$$\int_{x=N+1}^\infty \frac{1}{x^2} dx \le T_N \le \int_{x=N}^\infty \frac{1}{x^2} dx.$$

$S_N$ may be calculated easily by summing either forwards or backwards:

```julia
function forward_sum(N, T=Float64)
    total = zero(T)
    for i in 1:N
        total += one(T) / (i^2)
    end
    total
end

function reverse_sum(N, T=Float64)
    total = zero(T)
    for i in N:-1:1
        total += one(T) / (i^2)
    end
    total
end

reverse_sum (generic function with 2 methods)

```

To find *rigorous* bounds for $S_N$, we use "directed rounding", that is, we round downwards for the lower bound and  upwards for the upper bound:

```julia
N = 10^6

lowerbound_S_N =
    setrounding(Float64, RoundDown) do
        forward_sum(N)
    end

upperbound_S_N =
    setrounding(Float64, RoundUp) do
        forward_sum(N)
    end

(lowerbound_S_N, upperbound_S_N)

(1.6449330667377557,1.644933066959796)

```

We incorporate the respective bound on $T_N$ to obtain the bounds on $S$, and hence on $\pi$:

```julia
N = 10^6

lower_π =
    setrounding(Float64, RoundDown) do
        lower_bound = forward_sum(N) + 1/(N+1)
        sqrt(6 * lower_bound)
    end

upper_π =
    setrounding(Float64, RoundUp) do
        upper_bound = forward_sum(N) + 1/N
        sqrt(6 * upper_bound)
    end

(lower_π, upper_π, lowerbound_S_N)

(3.1415926534833463,3.1415926536963346,1.6449330667377557)
```

```julia
upper_π - lower_π

2.1298829366855898e-10

```

We may check that the true value of $\pi$ is indeed contained in the interval:

```julia
lower_π < pi < upper_π

true
```

Summing in the opposite direction turns out to give a more accurate answer:

```julia
N = 10^6

lower_π =
    setrounding(Float64, RoundDown) do
        lower_bound = reverse_sum(N) + 1/(N+1)
        sqrt(6 * lower_bound)
    end

upper_π =
    setrounding(Float64, RoundUp) do
        upper_bound = reverse_sum(N) + 1/N
        sqrt(6 * upper_bound)
    end

(lower_π, upper_π)
(3.1415926535893144,3.141592653590272)

```

```julia
upper_π - lower_π

9.57456336436735e-13

lower_π < pi < upper_π
true
```

In principle, we could attain arbitrarily good precision with higher-precision `BigFloat`s, but the result is hampered by the slow convergence of the series.

## Summing a series using interval arithmetic

We repeat the calculation using *interval arithmetic*, provided by the [ValidatedNumerics.jl](https://github.com/dpsanders/ValidatedNumerics.jl) package.

```julia
using ValidatedNumerics
```

```julia
setdisplay(:standard)  # abbreviated display of intervals
6
```

```julia
N = 10000
S = forward_sum(N, Interval)
S += 1/(N+1) .. 1/N  # interval bound on the remainder of the series
π_interval = √(6S)

[3.14159, 3.1416]

```

Here we used an abbreviated display for the interval. Let's see the whole thing:

```julia
setdisplay(:full)
π_interval

Interval(3.1415926488148807, 3.141592658365341)
```

Its diameter (width) is

```julia
diam(π_interval)
9.550460422502738e-9
```

Thus, the result is correct to approximately 8 decimals.

In this calculation, we used the fact that arithmetic operations of intervals with numbers automatically promote the numbers to an interval:

```julia
setdisplay(:full)  # full interval display
Interval(0) + 1/3^2

Interval(0.1111111111111111, 0.11111111111111112)
```

This is an interval containing the true real number $1/9$ (written `1//9` in Julia):

```julia
1//9 ∈ convert(Interval{Float64}, 1/3^2)

true
```

Finally, we can check that the true value of $\pi$ is indeed inside our interval:

```julia
pi ∈ π_interval

true
```

## Calculating an area

Although the calculation above is simple, the derivation of the series itself is not. In this section, we will use a more natural way to calculate $\pi$, namely that the area of a circle of radius $r$ is $A(r) = \pi r^2$. We will calculate the area of one quadrant of a circle of radius $r=2$, which is equal to $\pi$:

```julia
using Plots; gr();
```

```julia
f(x) = √(4 - x^2)

f (generic function with 1 method)
```

```julia
plot(f, 0, 2, aspect_ratio=:equal, fill=(0, :orange), alpha=0.2, label="")
```

~~~
<?xml version="1.0" encoding="utf-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="https://www.w3.org/1999/xlink" width="600" height="400" viewBox="0 0 600 400">
<defs>
  <clipPath id="clip00">
    <rect x="0" y="0" width="600" height="400"/>
  </clipPath>
</defs>
<polygon clip-path="url(#clip00)" points="
0,400 600,400 600,0 0,0
  " fill="#ffffff" fill-opacity="1"/>
<defs>
  <clipPath id="clip01">
    <rect x="120" y="0" width="421" height="400"/>
  </clipPath>
</defs>
<polygon clip-path="url(#clip00)" points="
125.283,384.952 501.384,384.952 501.384,3.93701 125.283,3.93701
  " fill="#ffffff" fill-opacity="1"/>
<defs>
  <clipPath id="clip02">
    <rect x="125" y="3" width="377" height="382"/>
  </clipPath>
</defs>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  216.82,379.237 216.82,9.65223
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  312.078,379.237 312.078,9.65223
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  407.336,379.237 407.336,9.65223
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  130.924,384.952 495.742,384.952
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  130.924,289.694 495.742,289.694
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  130.924,194.435 495.742,194.435
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  130.924,99.1771 495.742,99.1771
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  125.283,384.952 501.384,384.952
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  216.82,384.952 216.82,379.237
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  312.078,384.952 312.078,379.237
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  407.336,384.952 407.336,379.237
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  125.283,384.952 125.283,3.93701
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  125.283,384.952 130.924,384.952
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  125.283,289.694 130.924,289.694
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  125.283,194.435 130.924,194.435
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  125.283,99.1771 130.924,99.1771
  "/>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:middle;" transform="rotate(0, 216.82, 396.952)" x="216.82" y="396.952">0.5</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:middle;" transform="rotate(0, 312.078, 396.952)" x="312.078" y="396.952">1.0</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:middle;" transform="rotate(0, 407.336, 396.952)" x="407.336" y="396.952">1.5</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:end;" transform="rotate(0, 124.083, 389.452)" x="124.083" y="389.452">0.0</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:end;" transform="rotate(0, 124.083, 294.194)" x="124.083" y="294.194">0.5</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:end;" transform="rotate(0, 124.083, 198.935)" x="124.083" y="198.935">1.0</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:end;" transform="rotate(0, 124.083, 103.677)" x="124.083" y="103.677">1.5</text>
</g>
<polygon clip-path="url(#clip02)" points="
125.283,3.93701 159.69,5.83128 180.367,8.48391 197.849,11.6338 216.84,16.0233 234.347,20.9937 253.117,27.3498 274.864,36.1189 294.191,45.2676 311.138,54.4265
  329.615,65.7341 348.202,78.6508 368.752,94.9811 388.305,112.86 408.636,134.403 425.75,155.483 436.197,170.031 446.644,186.187 456.465,203.221 466.285,222.62
  474.152,240.5 482.019,261.433 485.952,273.57 489.885,287.362 493.819,303.645 497.752,324.397 498.963,332.468 500.173,342.064 501.384,354.602 501.384,384.952
  500.173,384.952 498.963,384.952 497.752,384.952 493.819,384.952 489.885,384.952 485.952,384.952 482.019,384.952 474.152,384.952 466.285,384.952 456.465,384.952
  446.644,384.952 436.197,384.952 425.75,384.952 408.636,384.952 388.305,384.952 368.752,384.952 348.202,384.952 329.615,384.952 311.138,384.952 294.191,384.952
  274.864,384.952 253.117,384.952 234.347,384.952 216.84,384.952 197.849,384.952 180.367,384.952 159.69,384.952 125.283,384.952
  " fill="#ffa500" fill-opacity="0.2"/>
<polyline clip-path="url(#clip02)" style="stroke:#0099ff; stroke-width:0.8; stroke-opacity:0.2; fill:none" points="
  125.283,3.93701 159.69,5.83128 180.367,8.48391 197.849,11.6338 216.84,16.0233 234.347,20.9937 253.117,27.3498 274.864,36.1189 294.191,45.2676 311.138,54.4265
  329.615,65.7341 348.202,78.6508 368.752,94.9811 388.305,112.86 408.636,134.403 425.75,155.483 436.197,170.031 446.644,186.187 456.465,203.221 466.285,222.62
  474.152,240.5 482.019,261.433 485.952,273.57 489.885,287.362 493.819,303.645 497.752,324.397 498.963,332.468 500.173,342.064 501.384,354.602
  "/>
</svg>
~~~

The circle of radius $r=2$ is given by $x^2 + y^2 = 2^2 = 4$, so

$$\pi = \frac{1}{4} A(2) = \int_{x=0}^2 y(x) \, dx = \int_{x=0}^2 \sqrt{4 - x^2}.$$

In calculus, we learn that we can approximate integrals using **Riemann sums**. Interval arithmetic allows us to make these Riemann sums **rigorous** in a very simple way, as follows.

We split up the $x$ axis into intervals, for example of equal width:

```julia
function make_intervals(N=10)
    xs = linspace(0, 2, N+1)
    return [xs[i]..xs[i+1] for i in 1:length(xs)-1]
end

intervals = make_intervals()

10-element Array{ValidatedNumerics.Interval{Float64},1}:
 Interval(0.0, 0.2)
 Interval(0.19999999999999998, 0.4)
 Interval(0.39999999999999997, 0.6000000000000001)
 Interval(0.6, 0.8)
 Interval(0.7999999999999999, 1.0)
 Interval(1.0, 1.2000000000000002)
 Interval(1.2, 1.4000000000000001)
 Interval(1.4, 1.6)
 Interval(1.5999999999999999, 1.8)
 Interval(1.7999999999999998, 2.0)
```

Given one of those intervals, we evaluate the function of interest:

```julia
II = intervals[1]

Interval(0.0, 0.2)
```

```julia
f(II)

Interval(1.9899748742132397, 2.0)
```

The result is an interval that is **guaranteed to contain** the true range of the function $f$ over that interval. So the lower and upper bounds of the intervals may be used as lower and upper bounds of the height of the box in a Riemann integral:

```julia
intervals = make_intervals(30)

p = plot(aspect_ratio=:equal)
for X in intervals
    Y = f(X)

    plot!(IntervalBox(X, Interval(0, Y.lo)), c=:blue, label="", alpha=0.1)
    plot!(IntervalBox(X, Interval(Y.lo, Y.hi)), c=:red, label="", alpha=0.1)
end

plot!(f, 0, 2)

p
```

~~~
<?xml version="1.0" encoding="utf-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="https://www.w3.org/1999/xlink" width="600" height="400" viewBox="0 0 600 400">
<defs>
  <clipPath id="clip00">
    <rect x="0" y="0" width="600" height="400"/>
  </clipPath>
</defs>
<polygon clip-path="url(#clip00)" points="
0,400 600,400 600,0 0,0
  " fill="#ffffff" fill-opacity="1"/>
<defs>
  <clipPath id="clip01">
    <rect x="120" y="0" width="421" height="400"/>
  </clipPath>
</defs>
<polygon clip-path="url(#clip00)" points="
122.826,384.952 503.841,384.952 503.841,3.93701 122.826,3.93701
  " fill="#ffffff" fill-opacity="1"/>
<defs>
  <clipPath id="clip02">
    <rect x="122" y="3" width="382" height="382"/>
  </clipPath>
</defs>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  122.826,379.237 122.826,9.65223
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  218.08,379.237 218.08,9.65223
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  313.333,379.237 313.333,9.65223
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  408.587,379.237 408.587,9.65223
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  503.841,379.237 503.841,9.65223
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  128.541,384.952 498.126,384.952
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  128.541,289.698 498.126,289.698
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  128.541,194.444 498.126,194.444
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  128.541,99.1907 498.126,99.1907
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" stroke-dasharray="1, 2" points="
  128.541,3.93701 498.126,3.93701
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  122.826,384.952 503.841,384.952
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  122.826,384.952 122.826,379.237
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  218.08,384.952 218.08,379.237
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  313.333,384.952 313.333,379.237
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  408.587,384.952 408.587,379.237
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  503.841,384.952 503.841,379.237
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  122.826,384.952 122.826,3.93701
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  122.826,384.952 128.541,384.952
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  122.826,289.698 128.541,289.698
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  122.826,194.444 128.541,194.444
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  122.826,99.1907 128.541,99.1907
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  122.826,3.93701 128.541,3.93701
  "/>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:middle;" transform="rotate(0, 122.826, 396.952)" x="122.826" y="396.952">0.0</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:middle;" transform="rotate(0, 218.08, 396.952)" x="218.08" y="396.952">0.5</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:middle;" transform="rotate(0, 313.333, 396.952)" x="313.333" y="396.952">1.0</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:middle;" transform="rotate(0, 408.587, 396.952)" x="408.587" y="396.952">1.5</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:middle;" transform="rotate(0, 503.841, 396.952)" x="503.841" y="396.952">2.0</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:end;" transform="rotate(0, 121.626, 389.452)" x="121.626" y="389.452">0.0</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:end;" transform="rotate(0, 121.626, 294.198)" x="121.626" y="294.198">0.5</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:end;" transform="rotate(0, 121.626, 198.944)" x="121.626" y="198.944">1.0</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:end;" transform="rotate(0, 121.626, 103.691)" x="121.626" y="103.691">1.5</text>
</g>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:end;" transform="rotate(0, 121.626, 8.43701)" x="121.626" y="8.43701">2.0</text>
</g>
<polygon clip-path="url(#clip02)" points="
122.826,384.952 135.526,384.952 135.526,4.14874 122.826,4.14874 122.826,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  122.826,384.952 135.526,384.952 135.526,4.14874 122.826,4.14874 122.826,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
122.826,4.14874 135.526,4.14874 135.526,3.93701 122.826,3.93701 122.826,4.14874
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  122.826,4.14874 135.526,4.14874 135.526,3.93701 122.826,3.93701 122.826,4.14874
  "/>
<polygon clip-path="url(#clip02)" points="
135.526,384.952 148.227,384.952 148.227,4.78465 135.526,4.78465 135.526,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  135.526,384.952 148.227,384.952 148.227,4.78465 135.526,4.78465 135.526,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
135.526,4.78465 148.227,4.78465 148.227,4.14874 135.526,4.14874 135.526,4.78465
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  135.526,4.78465 148.227,4.78465 148.227,4.14874 135.526,4.14874 135.526,4.78465
  "/>
<polygon clip-path="url(#clip02)" points="
148.227,384.952 160.927,384.952 160.927,5.84687 148.227,5.84687 148.227,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  148.227,384.952 160.927,384.952 160.927,5.84687 148.227,5.84687 148.227,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
148.227,5.84687 160.927,5.84687 160.927,4.78465 148.227,4.78465 148.227,5.84687
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  148.227,5.84687 160.927,5.84687 160.927,4.78465 148.227,4.78465 148.227,5.84687
  "/>
<polygon clip-path="url(#clip02)" points="
160.927,384.952 173.628,384.952 173.628,7.33899 160.927,7.33899 160.927,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  160.927,384.952 173.628,384.952 173.628,7.33899 160.927,7.33899 160.927,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
160.927,7.33899 173.628,7.33899 173.628,5.84687 160.927,5.84687 160.927,7.33899
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  160.927,7.33899 173.628,7.33899 173.628,5.84687 160.927,5.84687 160.927,7.33899
  "/>
<polygon clip-path="url(#clip02)" points="
173.628,384.952 186.328,384.952 186.328,9.26615 173.628,9.26615 173.628,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  173.628,384.952 186.328,384.952 186.328,9.26615 173.628,9.26615 173.628,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
173.628,9.26615 186.328,9.26615 186.328,7.33899 173.628,7.33899 173.628,9.26615
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  173.628,9.26615 186.328,9.26615 186.328,7.33899 173.628,7.33899 173.628,9.26615
  "/>
<polygon clip-path="url(#clip02)" points="
186.328,384.952 199.029,384.952 199.029,11.6351 186.328,11.6351 186.328,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  186.328,384.952 199.029,384.952 199.029,11.6351 186.328,11.6351 186.328,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
186.328,11.6351 199.029,11.6351 199.029,9.26615 186.328,9.26615 186.328,11.6351
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  186.328,11.6351 199.029,11.6351 199.029,9.26615 186.328,9.26615 186.328,11.6351
  "/>
<polygon clip-path="url(#clip02)" points="
199.029,384.952 211.729,384.952 211.729,14.4542 199.029,14.4542 199.029,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  199.029,384.952 211.729,384.952 211.729,14.4542 199.029,14.4542 199.029,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
199.029,14.4542 211.729,14.4542 211.729,11.6351 199.029,11.6351 199.029,14.4542
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  199.029,14.4542 211.729,14.4542 211.729,11.6351 199.029,11.6351 199.029,14.4542
  "/>
<polygon clip-path="url(#clip02)" points="
211.729,384.952 224.43,384.952 224.43,17.734 211.729,17.734 211.729,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  211.729,384.952 224.43,384.952 224.43,17.734 211.729,17.734 211.729,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
211.729,17.734 224.43,17.734 224.43,14.4542 211.729,14.4542 211.729,17.734
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  211.729,17.734 224.43,17.734 224.43,14.4542 211.729,14.4542 211.729,17.734
  "/>
<polygon clip-path="url(#clip02)" points="
224.43,384.952 237.13,384.952 237.13,21.4869 224.43,21.4869 224.43,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  224.43,384.952 237.13,384.952 237.13,21.4869 224.43,21.4869 224.43,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
224.43,21.4869 237.13,21.4869 237.13,17.734 224.43,17.734 224.43,21.4869
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  224.43,21.4869 237.13,21.4869 237.13,17.734 224.43,17.734 224.43,21.4869
  "/>
<polygon clip-path="url(#clip02)" points="
237.13,384.952 249.831,384.952 249.831,25.7276 237.13,25.7276 237.13,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  237.13,384.952 249.831,384.952 249.831,25.7276 237.13,25.7276 237.13,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
237.13,25.7276 249.831,25.7276 249.831,21.4869 237.13,21.4869 237.13,25.7276
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  237.13,25.7276 249.831,25.7276 249.831,21.4869 237.13,21.4869 237.13,25.7276
  "/>
<polygon clip-path="url(#clip02)" points="
249.831,384.952 262.531,384.952 262.531,30.4738 249.831,30.4738 249.831,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  249.831,384.952 262.531,384.952 262.531,30.4738 249.831,30.4738 249.831,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
249.831,30.4738 262.531,30.4738 262.531,25.7276 249.831,25.7276 249.831,30.4738
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  249.831,30.4738 262.531,30.4738 262.531,25.7276 249.831,25.7276 249.831,30.4738
  "/>
<polygon clip-path="url(#clip02)" points="
262.531,384.952 275.232,384.952 275.232,35.746 262.531,35.746 262.531,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  262.531,384.952 275.232,384.952 275.232,35.746 262.531,35.746 262.531,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
262.531,35.746 275.232,35.746 275.232,30.4738 262.531,30.4738 262.531,35.746
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  262.531,35.746 275.232,35.746 275.232,30.4738 262.531,30.4738 262.531,35.746
  "/>
<polygon clip-path="url(#clip02)" points="
275.232,384.952 287.932,384.952 287.932,41.5684 275.232,41.5684 275.232,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  275.232,384.952 287.932,384.952 287.932,41.5684 275.232,41.5684 275.232,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
275.232,41.5684 287.932,41.5684 287.932,35.746 275.232,35.746 275.232,41.5684
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  275.232,41.5684 287.932,41.5684 287.932,35.746 275.232,35.746 275.232,41.5684
  "/>
<polygon clip-path="url(#clip02)" points="
287.932,384.952 300.633,384.952 300.633,47.9696 287.932,47.9696 287.932,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  287.932,384.952 300.633,384.952 300.633,47.9696 287.932,47.9696 287.932,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
287.932,47.9696 300.633,47.9696 300.633,41.5684 287.932,41.5684 287.932,47.9696
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  287.932,47.9696 300.633,47.9696 300.633,41.5684 287.932,41.5684 287.932,47.9696
  "/>
<polygon clip-path="url(#clip02)" points="
300.633,384.952 313.333,384.952 313.333,54.9833 300.633,54.9833 300.633,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  300.633,384.952 313.333,384.952 313.333,54.9833 300.633,54.9833 300.633,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
300.633,54.9833 313.333,54.9833 313.333,47.9696 300.633,47.9696 300.633,54.9833
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  300.633,54.9833 313.333,54.9833 313.333,47.9696 300.633,47.9696 300.633,54.9833
  "/>
<polygon clip-path="url(#clip02)" points="
313.333,384.952 326.034,384.952 326.034,62.6494 313.333,62.6494 313.333,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  313.333,384.952 326.034,384.952 326.034,62.6494 313.333,62.6494 313.333,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
313.333,62.6494 326.034,62.6494 326.034,54.9833 313.333,54.9833 313.333,62.6494
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  313.333,62.6494 326.034,62.6494 326.034,54.9833 313.333,54.9833 313.333,62.6494
  "/>
<polygon clip-path="url(#clip02)" points="
326.034,384.952 338.734,384.952 338.734,71.0158 326.034,71.0158 326.034,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  326.034,384.952 338.734,384.952 338.734,71.0158 326.034,71.0158 326.034,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
326.034,71.0158 338.734,71.0158 338.734,62.6494 326.034,62.6494 326.034,71.0158
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  326.034,71.0158 338.734,71.0158 338.734,62.6494 326.034,62.6494 326.034,71.0158
  "/>
<polygon clip-path="url(#clip02)" points="
338.734,384.952 351.435,384.952 351.435,80.14 338.734,80.14 338.734,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  338.734,384.952 351.435,384.952 351.435,80.14 338.734,80.14 338.734,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
338.734,80.14 351.435,80.14 351.435,71.0158 338.734,71.0158 338.734,80.14
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  338.734,80.14 351.435,80.14 351.435,71.0158 338.734,71.0158 338.734,80.14
  "/>
<polygon clip-path="url(#clip02)" points="
351.435,384.952 364.135,384.952 364.135,90.0924 351.435,90.0924 351.435,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  351.435,384.952 364.135,384.952 364.135,90.0924 351.435,90.0924 351.435,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
351.435,90.0924 364.135,90.0924 364.135,80.14 351.435,80.14 351.435,90.0924
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  351.435,90.0924 364.135,90.0924 364.135,80.14 351.435,80.14 351.435,90.0924
  "/>
<polygon clip-path="url(#clip02)" points="
364.135,384.952 376.836,384.952 376.836,100.96 364.135,100.96 364.135,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  364.135,384.952 376.836,384.952 376.836,100.96 364.135,100.96 364.135,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
364.135,100.96 376.836,100.96 376.836,90.0924 364.135,90.0924 364.135,100.96
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  364.135,100.96 376.836,100.96 376.836,90.0924 364.135,90.0924 364.135,100.96
  "/>
<polygon clip-path="url(#clip02)" points="
376.836,384.952 389.536,384.952 389.536,112.853 376.836,112.853 376.836,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  376.836,384.952 389.536,384.952 389.536,112.853 376.836,112.853 376.836,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
376.836,112.853 389.536,112.853 389.536,100.96 376.836,100.96 376.836,112.853
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  376.836,112.853 389.536,112.853 389.536,100.96 376.836,100.96 376.836,112.853
  "/>
<polygon clip-path="url(#clip02)" points="
389.536,384.952 402.237,384.952 402.237,125.912 389.536,125.912 389.536,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  389.536,384.952 402.237,384.952 402.237,125.912 389.536,125.912 389.536,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
389.536,125.912 402.237,125.912 402.237,112.853 389.536,112.853 389.536,125.912
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  389.536,125.912 402.237,125.912 402.237,112.853 389.536,112.853 389.536,125.912
  "/>
<polygon clip-path="url(#clip02)" points="
402.237,384.952 414.937,384.952 414.937,140.323 402.237,140.323 402.237,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  402.237,384.952 414.937,384.952 414.937,140.323 402.237,140.323 402.237,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
402.237,140.323 414.937,140.323 414.937,125.912 402.237,125.912 402.237,140.323
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  402.237,140.323 414.937,140.323 414.937,125.912 402.237,125.912 402.237,140.323
  "/>
<polygon clip-path="url(#clip02)" points="
414.937,384.952 427.638,384.952 427.638,156.343 414.937,156.343 414.937,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  414.937,384.952 427.638,384.952 427.638,156.343 414.937,156.343 414.937,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
414.937,156.343 427.638,156.343 427.638,140.323 414.937,140.323 414.937,156.343
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  414.937,156.343 427.638,156.343 427.638,140.323 414.937,140.323 414.937,156.343
  "/>
<polygon clip-path="url(#clip02)" points="
427.638,384.952 440.338,384.952 440.338,174.338 427.638,174.338 427.638,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  427.638,384.952 440.338,384.952 440.338,174.338 427.638,174.338 427.638,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
427.638,174.338 440.338,174.338 440.338,156.343 427.638,156.343 427.638,174.338
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  427.638,174.338 440.338,174.338 440.338,156.343 427.638,156.343 427.638,174.338
  "/>
<polygon clip-path="url(#clip02)" points="
440.338,384.952 453.039,384.952 453.039,194.868 440.338,194.868 440.338,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  440.338,384.952 453.039,384.952 453.039,194.868 440.338,194.868 440.338,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
440.338,194.868 453.039,194.868 453.039,174.338 440.338,174.338 440.338,194.868
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  440.338,194.868 453.039,194.868 453.039,174.338 440.338,174.338 440.338,194.868
  "/>
<polygon clip-path="url(#clip02)" points="
453.039,384.952 465.739,384.952 465.739,218.871 453.039,218.871 453.039,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  453.039,384.952 465.739,384.952 465.739,218.871 453.039,218.871 453.039,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
453.039,218.871 465.739,218.871 465.739,194.868 453.039,194.868 453.039,218.871
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  453.039,218.871 465.739,218.871 465.739,194.868 453.039,194.868 453.039,218.871
  "/>
<polygon clip-path="url(#clip02)" points="
465.739,384.952 478.44,384.952 478.44,248.163 465.739,248.163 465.739,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  465.739,384.952 478.44,384.952 478.44,248.163 465.739,248.163 465.739,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
465.739,248.163 478.44,248.163 478.44,218.871 465.739,218.871 465.739,248.163
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  465.739,248.163 478.44,248.163 478.44,218.871 465.739,218.871 465.739,248.163
  "/>
<polygon clip-path="url(#clip02)" points="
478.44,384.952 491.14,384.952 491.14,287.398 478.44,287.398 478.44,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  478.44,384.952 491.14,384.952 491.14,287.398 478.44,287.398 478.44,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
478.44,287.398 491.14,287.398 491.14,248.163 478.44,248.163 478.44,287.398
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  478.44,287.398 491.14,287.398 491.14,248.163 478.44,248.163 478.44,287.398
  "/>
<polygon clip-path="url(#clip02)" points="
491.14,384.952 503.841,384.952 503.841,384.952 491.14,384.952 491.14,384.952
  " fill="#0000ff" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  491.14,384.952 503.841,384.952 491.14,384.952
  "/>
<polygon clip-path="url(#clip02)" points="
491.14,384.952 503.841,384.952 503.841,287.398 491.14,287.398 491.14,384.952
  " fill="#ff0000" fill-opacity="0.5"/>
<polyline clip-path="url(#clip02)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:0.5; fill:none" points="
  491.14,384.952 503.841,384.952 503.841,287.398 491.14,287.398 491.14,384.952
  "/>
<polyline clip-path="url(#clip02)" style="stroke:#0099ff; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  126.547,3.95518 160.952,5.84936 181.628,8.50187 199.11,11.6516 218.099,16.0409 235.606,21.0111 254.375,27.3669 276.121,36.1356 295.447,45.2838 312.393,54.4423
  330.869,65.7493 349.455,78.6654 370.005,94.9949 389.557,112.873 409.886,134.415 427,155.494 437.446,170.042 447.893,186.196 457.713,203.23 467.533,222.627
  475.399,240.507 483.266,261.439 487.199,273.576 491.132,287.367 495.065,303.649 498.998,324.4 500.209,332.47 501.42,342.067 502.63,354.603
  "/>
<polygon clip-path="url(#clip00)" points="
406.736,55.057 485.841,55.057 485.841,24.817 406.736,24.817
  " fill="#ffffff" fill-opacity="1"/>
<polyline clip-path="url(#clip00)" style="stroke:#00002d; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  406.736,55.057 485.841,55.057 485.841,24.817 406.736,24.817 406.736,55.057
  "/>
<polyline clip-path="url(#clip00)" style="stroke:#0099ff; stroke-width:0.8; stroke-opacity:1; fill:none" points="
  412.736,39.937 448.736,39.937
  "/>
<g clip-path="url(#clip00)">
<text style="fill:#00002d; fill-opacity:1; font-family:Arial,Helvetica Neue,Helvetica,sans-serif; font-size:12; text-anchor:start;" transform="rotate(0, 454.736, 44.437)" x="454.736" y="44.437">y61</text>
</g>
</svg>
~~~

Now we just sum up the areas:

```julia
N = 20
intervals = make_intervals(N)

width = 2/N
width * sum(√(4 - X^2) for X in intervals)

Interval(3.0284648797549782, 3.2284648797549846)
```

As we increase the number of sub-intervals, the approximation gets better and better:

```julia
setdisplay(:standard, sigfigs=5)

println("N \t area interval \t \t diameter")
for N in 50:50:1000
    intervals = make_intervals(N)
    area = (2/N) * sum(√(4 - X^2) for X in intervals)

    println("$N \t $area \t $(diam(area))")
end

N 	 area interval 	 	 diameter
50 	 [3.0982, 3.1783] 	 0.0800000000000165
100 	 [3.1204, 3.1605] 	 0.040000000000032454
150 	 [3.1276, 3.1543] 	 0.02666666666670814
200 	 [3.1311, 3.1512] 	 0.02000000000006308
250 	 [3.1332, 3.1493] 	 0.016000000000075065
300 	 [3.1346, 3.1481] 	 0.013333333333415354
350 	 [3.1356, 3.1472] 	 0.011428571428676815
400 	 [3.1364, 3.1465] 	 0.010000000000123688
450 	 [3.137, 3.146] 	 0.008888888889027502
500 	 [3.1374, 3.1455] 	 0.008000000000148333
550 	 [3.1378, 3.1452] 	 0.007272727272884527
600 	 [3.1381, 3.1449] 	 0.006666666666829357
650 	 [3.1384, 3.1446] 	 0.006153846154013376
700 	 [3.1386, 3.1444] 	 0.0057142857144931725
750 	 [3.1388, 3.1443] 	 0.005333333333562784
800 	 [3.139, 3.1441] 	 0.005000000000246363
850 	 [3.1391, 3.1439] 	 0.004705882353203794
900 	 [3.1393, 3.1438] 	 0.004444444444719142
950 	 [3.1394, 3.1437] 	 0.004210526316076102
1000 	 [3.1395, 3.1436] 	 0.004000000000294435
```
