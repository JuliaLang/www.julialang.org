@def rss_pubdate = Date(2018, 8, 9)
@def rss = """ Union-splitting: what it is, and why you should care | Among those who follow Julia's development closely, one of the (many) new features causing great excitement is something called "Union-splitting."... """
@def published = "9 August 2018"
@def title = "Union-splitting: what it is, and why you should care"
@def authors = """<a href="https://github.com/timholy">Tim Holy</a>"""  
@def hascode = true

Among those who follow Julia's development closely, one of the (many) new features causing great excitement is something called "Union-splitting."
Here at JuliaCon 2018 I've found myself explaining this feature repeatedly, so I thought I'd write this blog post to help disseminate this important information more widely.
Let me start by saying that I'm not the expert here—this is a feature added by Jameson Nash and Jacob Quinn, and enhanced by optimizer improvements by Keno Fisher—but I am one of the many people truly excited about how this is already changing how I write Julia code.

Here's the background: in the old days, you had to take great care to make sure that nearly every function you wrote returned a predictable type.
Experienced Julia programmers regularly reached for a tool, `@code_warntype`, to check whether code exhibited the dreaded "type instability."
This was code that returned (as determined by Julia's inference engine) objects either of type `Any` or objects of type `Union{Type1, Type2, ...}`.
The first meant that the inference engine was unable to make any specific statements about the return type; the latter meant that inference was able to determine a specific list of possible return types.
Unfortunately, the compiler wasn't particularly good at taking advantage of this partial knowledge, and so in practice either of these outcomes predictably implied very bad things for the performance of your code.

Fast forward to 0.7 and 1.0, and the landscape is both "the same" and "completely different."
By this I mean that `Any` still indicates a likely problem, as the compiler can't do anything to optimize the code.
But often, `Union{Type1, Type2, ...}` is nothing to worry about, because it causes little or no performance hit of any kind.

How does this magic work?
Very briefly, let's imagine you have a block of code inside a function that looks like this:

```julia
ret1 = function1(args...)
ret2 = function2(ret1, ...)
ret3 = function3(ret1, ret2, ...)
...
```

Let's imagine that `ret1` can be one of two types, `A` or `B` (i.e, `Union{A,B}`).
In older versions of Julia, here's what would happen: starting after `function1`, the compiler would say "I can't tell which method of `function2` should be used."
So it wouldn't specialize any of the code
thereafter; instead, each time this block got executed, it would take the actual type of `ret1` and start poring through the method tables,  performing type-intersection trying to find an applicable compiled version of `function2`.
The computations involved in type intersection, while very well optimized, are nevertheless quite demanding, and consequently the "method lookup" step was quite slow (especially for functions that had tens or hundreds of methods).

In Julia 0.7 and 1.0, the compiler does something quite different: it automatically (without any effort on your part) compiles the block above to something that schematically looks like this:

```julia
ret1 = function1(args...)    # ret1 isa Union{A,B}
if ret1 isa A
    ret2 = function2_specialized_for_A(ret1, ...)
    ret3 = function3_specialized_for_A(ret1, ret2, ...)
    ...
else
    ret2 = function2_specialized_for_B(ret1, ...)
    ret3 = function3_specialized_for_B(ret1, ret2, ...)
    ...
end
```

The difference here is huge.
While Julia can't know ahead of time the precise type of `ret1`, within the first block it definitely is of type `A` (because it checked), and within the second block it is definitely of type `B` (because that's the only other option).
Consequently, Julia can **look up the appropriate compiled methods for `function2` and `function3` at compile time rather than run time**, and that allows it to be blazingly fast when you actually run it.

Now, I hear some of you saying, "but there's that branch in there, and branches are slow compared to many other CPU instructions."
True enough.
But a single branch is almost inconsequential compared to method lookup; moreover, in cases where Union-splitting gets used, it's often the case that you would have needed that branch anyway.
In such cases, the cost is literally zero.

To illustrate why, consider the operation `findfirst(isequal(7), A)` for an array `A`, which formerly always returned an integer indicating the first index of `A` at which it found the value 7.
One problematic case arises: what if `A` doesn't contain any 7s?
Previously, we used to return 0, and the receiver had to check `if ret1 == 0` to determine whether execution needed to divert to error-handling code.
Consequently, in properly-written code there was no getting away from needing that branch.
Worse, if you forgot to check, and `function2` didn't error when you passed it 0, then you would likely get a meaningless answer.
That is far worse than getting an error, because it's much harder to track down where wrong results come from.

In Julia 0.7 and 1.0, Milan Bouchet-Valat rewrote all of our `find*` functions, of which one change (among many) was that `findfirst` now returns `nothing` when it fails to find the requested value.
Unlike the old approach of returning 0, this return value is truly unambigous and robust against generalizations of indexing where 0 might be a perfectly valid array index.
It also gives you more reliable code, because if you forget to check, really there's not much you can do with `nothing` that doesn't trigger a (very welcome) error.
And thanks to Union-splitting, it doesn't cause any kind of performance penalty whatsoever.

So, while Union-splitting might initially sound like some kind of arcane feature of interest only to compiler gurus, the reality is that it changes how you should be designing your code, and it allows more understandable and robust software.
That's the kind of feature everyone can appreciate.
