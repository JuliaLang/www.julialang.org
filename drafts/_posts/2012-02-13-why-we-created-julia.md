---
layout: post
title:  Why We Created Julia
authors:
    - <a href="http://www.allthingshpc.org/">Viral Shah</a>
    - Jeff Bezanson
    - <a href="http://karpinski.org/">Stefan Karpinski</a>
    - <a href="http://www-math.mit.edu/~edelman/">Alan Edelman</a>
---

In short, because we are greedy.

All of us are Matlab experts;
some are Lisp hackers.
Some are Pythonistas, others Rubyists.
Some are masters of Perl one-liners.
Some have used Mathematica since before we could grow facial hair.
Some of us still can't grow facial hair.
We've generated more R plots than any sane person should.
C is our desert island language.

We love all of these languages;
they are wonderful and powerful.
But for the work we do — scientific computing, machine learning, data mining, large-scale linear algebra, distributed and parallel computing — each one is wonderful for some aspects of the work and terrible for others.

We are greedy.
We want more.

We want the speed of C and the dynamism of Ruby.
We want a language that's homoiconic, with true, powerful macros like Lisp, but with obvious, familiar mathematical notation like Matlab.
We want something as good for general programming as Python,
as easy for statistics as R,
as natural at string processing as Perl,
as ideal for linear algebra as Matlab,
and that glues programs together as effortlessly as the shell.
Something that's dirt simple to learn, yet satisfies the most serious of hackers.

Did we mention that should be as fast as C?

While we're being demanding, we want something that gives the tremendous distributed power of Hadoop — without the kilobytes of boilerplate Java and XML;
without being forced to sift through gigabytes of log files on hundreds of machines to find our bugs.
We want the power without incomprehensible layers upon layers of accumulated complexity.
We want to write simple scalar loops that compile down to tight machine code that keeps all its values in registers on a single CPU;
we want to simply write `A*B` and launch a thousand computations on a thousand machines, working together to compute an enormous matrix product.

We want to never mention types when we don't feel like it.
But when we do feel like it, we want to define highly polymorphic functions using generic programming and multiple dispatch, efficiently picking the most specific method definition for all of a function's arguments, across an infinite lattice of parametric types.
Despite this power, we want the language to be simple and clean.

That doesn't seem like too much to ask for, does it?

Even though we recognize that we are inexcusably greedy, we want to have it all — in one language.
So we set out, about two and a half years ago, to create the language of our greed.
It's been a long, strange, wonderful trip — and it's most certainly not done.
The result is called Julia.
It's not complete, but it's ready for a 1.0 release, and it delivers on 90% of our ungracious demands.
If you are also a greedy, unreasonable bastard, maybe you should give it a try.
