---
layout: post
title:  What's New About Julia?
author: Jeff Bezanson
---

## Introduction

Scientific computing has traditionally required the highest performance,
yet domain experts generally use high-level dynamic languages (e.g.
MATLAB&reg;, Python \cite{numpy}, R \cite{Rlang},
Octave \cite{Octave}, SciLab \cite{scilab}) for daily work. These systems
have greatly increased productivity, but are known to lack performance
for many demanding applications. In designing and implementing the Julia
language, my collaborators and I have attempted to rethink dynamic technical
computing languages, and show that it is possible to fix the performance
issue (and other design limitations) while preserving the benefits of
existing systems. This thesis will
present the design of the system and evaluate its performance.

The designs of the technical computing languages listed above are all
basically the same— they use the "array language" idea made famous
by APL \cite{APL}. In each case there is a large core of library routines
implemented in C or FORTRAN,
and an interpreter for executing user programs, which are expected to spend
most of their time in these routines. This arrangement works well for
problems that are easily "vectorized" and are able to take advantage of
sufficiently large arrays. However, not every problem is like this.
In particular, writing programs in terms of coarse-grained library
routines does not work when the behavior of those very routines is what one
wishes to explore or alter. As a result the productivity benefits of the
higher-level language are often not realized for library developers, who
continue to use C or FORTRAN.

Julia, by contrast, performs well enough that its entire standard library
can be written in the language itself, and achieve performance
better than all the above systems in most cases.
Julia is a dynamic language designed for performance and flexibility, by
combining multiple dispatch, type inference by abstract
interpretation, and aggressive code specialization to consistently provide
high-quality type information to the compiler in a way that is unobtrusive
to the user. The resulting language is readily extended to various
domains of interest to technical users, for example permitting the definition
of alternate arithmetics without undue performance loss. Efficient
definitions of the polymorphic operators needed in such systems (e.g.
array indexing and concatenation) naturally arise from the generic
function system and compiler.

Many of the ideas explored here are not exclusively applicable to technical
computing, but we have chosen to target that application area for several
reasons. First, technical computing has unique concerns that can be
especially awkward or inefficient to handle in existing dynamic languages.
Examples include the need for a wide variety of numeric types, and the need for
efficient arrays of those types. Second, the performance
of high-level technical computing languages has begun to seriously lag behind
that of more mainstream languages (notably JavaScript), creating a present
need for attempts to improve the situation.
General-purpose languages like Java, Python, or perhaps even JavaScript, could
be used for technical computing, but we feel the community will continue to
prefer environments that cater to its syntactic needs, and are able to
prioritize issues of numerical accuracy and performance.


## Related Work

There is a rich history of efforts to improve the performance of high-level
dynamic languages. These can be broadly categorized into clever
implementation tricks, which attempt to do the same work faster, and
compiler-based techniques, which try to remove unnecessary
operations from programs. An example of the first category would be
moving bits of the language's run time system into hardware
\cite{lispmachine}. This thesis is in the second
category, which promises the greatest gains— the fastest way to do
something is to avoid doing it altogether.

The operations we seek to remove are the run-time type manipulations
that characterize dynamic languages: checking, applying, and removing
type tags \cite{taggingopt}, and (typically) dispatching functions based on
type tags.
This can be seen as a special case of partial evaluation \cite{futamura},
wherein potentially *any* part of a program might be removed by
reducing it to a constant before execution begins. There are some projects
to develop partial evaluation as a practical tool for dynamic language execution
(PyPy \cite{pypyjit} is particularly relevant). The potential payoff there
is quite high, as one may obtain not just a compiler for a particular
language, but a compiler generator. However, this entails additional
challenges that are not necessary if we are willing to focus on a single
language. And for any given subject language, obtaining type information
is the key goal for removing execution overhead.

Kaplan and Ullman produced an optimal algorithm
for dynamic type inference \cite{kaplanullman}, where the compiler
attempts to guess what the run-time types of values will be.
Inference is cast as a maximum-fixed-point dataflow problem.
This is different from type inference in the ML family of languages
\cite{MLtypeinf}, where the compiler *must* be able to determine
types, using an algorithm based on unification.
Dynamic type inference is typically applied to an existing language
with the hope of improving performance or safety. There are several
examples in the
Lisp world (\cite{TICL}, \cite{pticl}, \cite{nimble}, \cite{taggingopt}),
and in the world of object-oriented languages such as Self \cite{selflang}
and JavaScript \cite{typeinfjavascript}.

% TODO: say something here about how julia does type inference and hint at
% what's a bit different about it.

Dynamic type inference schemes obey a correctness property that
inferred types must subsume all possible run-time
types. A trivial correct algorithm can be obtained by always returning
a largest `Any` type. Thus an advantage of dynamic type inference is
that the inference algorithm can be separate from the language specification.
This allows the compiler to evolve and improve without changing the set of
valid programs and without updating documentation.

On the other hand, dynamic type inference is easily defeated by systems with
excessive type complexity. In these cases the alternate method of
tracing \cite{tracingjit} might work better.
The idea of tracing is to record type
information as a program actually runs instead of trying to guess it in
advance. Tracing is well known for its use in modern JavaScript
implementations \cite{tracingjit2}.
Tracing is appealing as a "model-free" approach that can work for
essentially any language, no matter how uncooperative its design. The
corresponding disadvantages are that it cannot completely eliminate type
checks (or "guards"), and that code must be interpreted with tracing overhead.
When tracing fails to yield useful information, this overhead cannot be
recovered and code might run slower than in the original system.

Yet another category of techniques involves altering a dynamic language
by imposing a static type system, as in Typed Scheme \cite{typedscheme}
or an extended version of Dylan \cite{dylantypes}, or adding dynamic typing
to a statically-typed
language \cite{dyntype}. Gradual typing \cite{gradualobjects} allows programs
to contain both statically-checked and run-time-checked components.

These techniques continue to be enhanced and applied to the current
generation of popular scripting languages. DRuby \cite{druby} adds static
type inference to Ruby. PRuby \cite{profileguided} extends this system to
support highly dynamic constructs such as `eval`. RubyDust
\cite{rubydust} uses a combination of constraint resolution and trace
information to infer types.

In this body of work it is commonly observed that dynamic language programs
are not as dynamic as their authors might think: "We found that dynamic
features are pervasive throughout the benchmarks and the libraries they
include, but that most uses of these features are highly constrained..."
\cite{profileguided}. In this sense, the designs of existing dynamic languages
do not present a good trade-off. Much code is statically-typeable and could be
executed more efficiently, but the language designs and implementations do not
anticipate this fact. As Henry Baker observes of Common Lisp, "...the
polymorphic type complexity of the Common Lisp library functions is mostly
gratuitous, and both the efficiency of compiled code and the efficiency of the
programmer could be increased by rationalizing this complexity."\cite{nimble}
Others have echoed these sentiments \cite{lispcrit}.

With type inference in mind from the beginning, unnecessary type complexity
could be removed and a better overall system may result.
Most importantly, the goal should not be just to make a dynamic language
faster or safer, but to provide a more powerful language at the same time.
For example, in applying type inference to a pre-existing language, it is
typically useful
to employ a finer type lattice than that provided by the original language
(e.g. splitting integers into positive and negative subtypes).
In some sense, this is unfortunate, as the
extra expressiveness provided by these types is not available to the programmer
for use in declarations, typecase statements, and the like.
In light of the speedups possible with the techniques cited here, many common
features of these languages can be seen as premature optimizations— for
example employing only single dispatch and simple type systems (or, to be
precise, "tag systems"). When we go to great lengths to make dynamic
languages perform well, we should ask what else we can get for the same
level of effort. Julia answers this question by employing more
sophisticated types and tags that would make the language even slower without
our compiler.

Julia uses generic functions and multiple dispatch as its primary
abstraction mechanism. This feature famously appeared in the Common Lisp
Object System (CLOS) \cite{closoverview} \cite{closspec}, and has been the
subject of research languages such as Cecil \cite{cecil} and
Diesel \cite{dieselspec}. We find this style to be a good fit for
mathematical programming, where operators are typically defined for many
different combinations of arguments. In our context, an invaluable
feature of generic functions is that they permit overloading for a variety
of reasons: not just specializing behavior for subclasses, but for
special cases
that can be implemented more efficiently (e.g. dense double-precision
arrays). We also find it a great simplification to support only
generic functions, and not the usual mix including instance methods and
class methods.

The Dylan language \cite{dylanlang} is close in spirit to
the present work. It is also a dynamic language with multiple dispatch,
designed with high performance as a goal. However, in Julia,
automatic specialization is the primary source of type information, rather
than user-supplied type declarations. We also explore the potential of
automatic mechanisms for avoiding a combinatorial explosion of method
specializations.
Unlike Dylan, Julia does not make the distinction between generic functions
and methods visible to the user— functions with the same name are simply
combined into one generic function without restrictions.
Julia method argument specializers also have a few more features
useful for defining the highly polymorphic operators needed in technical
computing. In Julia we also use our type machinery to introduce an
extensible type promotion system, which allows operators to support all
relevant combinations of arguments without requiring a large number
of definitions for each new type.

The telescoping languages (TL) project \cite{telescoping} shares many of our
goals, especially with respect to the domain of scientific computing.
TL optimizes programs in MATLAB&reg; and
R by pre-processing those systems' standard libraries to
generate a compiler that knows about commonly-used routines in order
to optimize uses of them in subject programs. This project dramatically
underscores the need for faster execution of these programs. The authors
target library development as an especially important use case. The
TL approach is fairly effective, but requires user
annotations for peak performance. Julia's multimethods provide a way to
collect type "annotations" in a less tedious manner— argument types
specify dispatch behavior, so they are part of the functionality of a program
instead of being extraneous information. The off-line library analysis step in
TL is subsumed by the Julia compiler's routine
type analysis and its ability to cache type information to disk. Julia
uses a mostly run-time compilation model, contrasted with TL's static
generation of C or FORTRAN code. This enables an additional category of
library implementation techniques where needed code can be generated on demand.

Of course, working on existing MATLAB&reg; code is TL's greatest
asset and greatest challenge. TL has also implemented advanced optimizations
for vectorization \cite{telescopingvectorization} and array size analysis
\cite{slicehoisting} that we have yet to explore. However, we feel Julia's
open-source nature and powerful, "clean slate" base system would provide
an excellent platform for future such work.
