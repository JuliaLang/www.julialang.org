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

All of us are power Matlab users;
some are Lisp hackers.
Some are Pythonistas, others Rubyists, some are Perl hackers.
There are those of us who used Mathematica before we could grow facial hair.
There are those who still can't grow facial hair.
We've generated more R plots than any sane people should.
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
as powerful for string processing as Perl,
as natural for linear algebra as Matlab,
as easy for gluing programs together as the shell.
Something that's dirt simple to learn, yet keeps the most serious hackers satisfied.

While we're being demanding, we want something that gives the distributed power of Hadoop — without the kilobytes of boilerplate Java and XML;
without being forced to sift through gigabytes of log files on hundreds of machines to find our bugs.
We want the same power without the layers upon layers of impenetrable complexity.
We want to write simple scalar loops that compile down to tight machine code that keeps all its values in registers on a single CPU;
we want to write `A*B` and launch a thousand computations on a thousand machines, generating a vast matrix product together.

We want to never mention types when we don't feel like it.
When we do feel like it, we want to define polymorphic functions using generic programming and multiple dispatch, efficiently picking the right method definition for all of a function's arguments, across an infinite lattice of parametric types.
Despite all this power, we want the language to be simple and clean.

<!-- Did we mention that should be as fast as C? -->

That doesn't seem like too much to ask for, does it?

Even though we recognize that we are inexcusably greedy, we still want to have it all.
So we set out, about two and a half years ago, to create the language of our greed. <!-- It's been a long, strange, wonderful trip — and it's most certainly not done. -->
The language we've created is called Julia.
It's not complete, but it's time for a 1.0 release.
What we have so far delivers on 90% of our ungracious demands, and now it needs the ungracious demands of others.
If you are also a greedy, unreasonable bastard, maybe you should give it a try.
