---
layout: post
title:  Lang.NEXT Announcement
authors:
    - <a href="http://karpinski.org/">Stefan Karpinski</a>
---

Jeff and I will be giving a [presentation on Julia](http://channel9.msdn.com/Events/Lang-NEXT/Lang-NEXT-2012/Julia) at the upcoming [Lang.NEXT conference](http://channel9.msdn.com/Events/Lang-NEXT/Lang-NEXT-2012), a gathering of "programming language design experts and enthusiasts" featuring "talks, panels and discussion on leading programming language work from industry and research."
We are honored and excited to have been invited to speak at an event alongside so many programming language luminaries.

**Abstract:**

Julia is a dynamic language in the tradition of Lisp, Perl, Python and Ruby. It aims to advance  expressiveness and convenience for scientific and technical computing beyond that of environments like Matlab and NumPy, while simultaneously closing the performance gap with compiled languages like C, C++, Fortran and Java.

Most high-performance dynamic language implementations have taken an existing interpreted language and worked to accelerate its execution. In creating Julia, we have reconsidered the basic language design, taking into account the capabilities of modern JIT compilers and the specific needs of technical computing. Our design includes:

- Multiple dispatch as the core language paradigm.
- Exposing a sophisticated type system including parametric dependent types.
- Dynamic type inference to generate fast code from programs with no declarations.
- Aggressive specialization of generated code for types encountered at run-time.

Julia feels light and natural for data exploration and algorithm prototyping, but has performance that lets you deploy your prototypes.

**Update:** You can see the slides for our talk [here](/images/lang.next.pdf). Video of the presentation is available [here](http://channel9.msdn.com/Events/Lang-NEXT/Lang-NEXT-2012/Julia).
