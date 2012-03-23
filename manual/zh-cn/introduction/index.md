---
layout: manual
title:  Introduction
---
<cn>
---
layout: manual
title:  Introduction
---
</cn>

Scientific computing has traditionally required the highest performance, yet domain experts have largely moved to slower dynamic languages for daily work.
We believe there are many good reasons to prefer dynamic languages for these applications, and we do not expect their use to diminish.
Fortunately, modern language design and compiler techniques make it possible to mostly eliminate the performance trade-off and provide a single environment productive enough for prototyping and efficient enough for deploying performance-intensive applications.
The Julia programming language fills this role:
it is a flexible dynamic language, appropriate for scientific and numerical computing, with performance comparable to traditional statically-typed languages.
<cn>
科学计算一贯需要要高效率，然而业内的专家有很大一部份在日常工作中使采用更慢的动态语言。
我们有理由相信采用动态语言解决这些问题是有很多好处的，并且不希望减少对动态语言的使用。
有幸的是现代语言设计和编译器技术让排除性能瓶颈，提供一个能产生足够的原型设计和高效的部署性能密集型应用的简单的工作环境成为了可能。
Julia编程语言填补了这一空白。
Julia是一种灵活的，适合科学计算和数值计算并且能和传统的静态编译语言的性能相媲美的动态语言。
</cn>

Julia features optional typing, multiple dispatch, and good performance, achieved using type inference and [just-in-time (JIT) compilation](http://en.wikipedia.org/wiki/Just-in-time_compilation), implemented using [LLVM][].
It is multi-paradigm, combining features of imperative, functional, and object-oriented programming.
The syntax of Julia is similar to [MATLAB®][] and consequently MATLAB® programmers should feel immediately comfortable with Julia. While MATLAB® is quite effective for prototyping and exploring numerical linear algebra, it has limitations for programming tasks outside of this relatively narrow scope.
Julia keeps MATLAB®'s ease and expressiveness for high-level numerical computing, but transcends its general programming limitations.
To achieve this, Julia builds upon the lineage of mathematical programming languages, but also borrows much from popular dynamic languages, including [Lisp][], [Perl][], [Python][], [Lua][], and [Ruby][].
<cn>
Julia通过 [LLVM][]实现的 [just-in-time (JIT) compilation](http://en.wikipedia.org/wiki/Just-in-time_compilation)和类型推断从而达到可选类型，多重调度以及高效的表现。
她是多功能的，结合了命令、函数、和面向对象编程。Julia的语法和[MATLAB®][]非常相似，因此MATLAB®用户能很舒服的使用Julia。然而MATLAB®高效的原型构建和线性代数处理能力限制了他在除此之外其他领域的编程任务。
Julia保持了MATLAB®的简单和对高等级数值计算的经验，同时克服了他在一般性编程领域的限制。
为此，Julia既带有数值计算编程语言的血统，同时也借鉴了很多流行的动态语言，如：[Lisp][], [Perl][], [Python][], [Lua][], and [Ruby][]
</cn>

The most significant departures of Julia from typical dynamic languages are:

- The core language imposes very little; the standard library is written in Julia itself, including primitive operations like integer arithmetic
- A rich language of types for constructing and describing objects, that can also optionally be used to make type declarations
- The ability to define function behavior across many combinations of argument types via [multiple dispatch](http://en.wikipedia.org/wiki/Multiple_dispatch)
- Automatic generation of efficient, specialized code for different argument types
- Good performance, approaching that of statically-compiled languages like C

Although one sometimes speaks of dynamic languages as being "typeless", they are definitely not:
every object, whether primitive or user-defined, has a type.
The lack of type declarations in most dynamic languages, however, means that one cannot instruct the compiler about the types of values, and often cannot explicitly talk about types at all.
In static languages, on the other hand, while one can — and usually must — annotate types for the compiler, types exist only at compile time and cannot be manipulated or expressed at run time.
In Julia, types are themselves run-time objects, and can also be used to convey information to the compiler.

While the casual programmer need not explicitly use types or multiple dispatch, they are the core unifying features of Julia:
functions are defined on different combinations of argument types, and applied by dispatching to the most specific matching definition.
This model is a good fit for mathematical programming, where it is unnatural for the first argument to "own" an operation as in traditional object-oriented dispatch.
Operators are just functions with special notation — to extend addition to new user-defined data types, you define new methods for the `+` function.
Existing code then seamlessly applies to the new data types.

Partly because of run-time type inference (augmented by optional type annotations), and partly because of a strong focus on performance from the inception of the project, Julia's computational efficiency exceeds that of other dynamic languages, and even rivals that of statically-compiled languages.
For large scale numerical problems, speed always has been, continues to be, and probably always will be crucial: the amount of data being processed has easily kept pace with Moore's Law over the past decades.
<cn>
尽管有人说动态语言是非类型的，但他们绝对不是说：每个对象，无论是内建的或者用户自定义的都必须有个类型。大部分动态语言含有的类型声明的缺陷意味着程序员不能向编译器指明一个值的类型，甚至是明确的不能说明值的类型。
然而在静态语言中，程序员能而且必须向编译器注明值的类型，类型只在编译器期间而不能在执行期间操作或者表达。
在Julia中，类型本身是运行时的对象，同时也可以传递信息给编译器。
然而一个悠闲的程序员不用明确的指出类型或者多重调度，他们是Julia的核心功能：函数定义在参数类型的组合的基础上，并响应于定义最符合的调度。
这样的模型非常适合在觉得传统的面向对象调用中用首个参数指明其所有者不自然的数值编程。
操作符只是用特殊标记的定义的函数--为了扩展用户定义类型，而为“+”函数定义了一个新的方法。
使得现有的代码可以无缝的使用于新的数据类型。
或许因为运行时的类型判断（通过可选的类型注解增加），或许因为该工程对性能的强烈要求，使得Julia执行效率超过了其他动态语言，甚至是可以和静态编译语言相匹敌。
对于大多数数值问题，速度通常是最重要的：将要处理的数据很容易跟上摩尔定律在过去几十年的步伐。
</cn>

Julia aims to create an unprecedented combination of ease-of-use, power, and efficiency in a single language.
In addition to the above, some advantages of Julia over comparable systems include:

- Free and open source ([MIT licensed](https://github.com/JuliaLang/julia/blob/master/LICENSE))
- User-defined types are as fast and compact as built-ins
- Designed for parallelism and distributed computation
- Lightweight "green" threading ([coroutines](http://en.wikipedia.org/wiki/Coroutine))
- Unobtrusive yet powerful type system
- Elegant and extensible conversions and promotions for numeric and other types
- Efficient support for [Unicode](http://en.wikipedia.org/wiki/Unicode), including but not limited to [UTF-8](http://en.wikipedia.org/wiki/UTF-8)
- Call C functions directly (no wrappers or special APIs needed)
- Powerful shell-like capabilities for managing other processes
- Lisp-like macros and other metaprogramming facilities
<cn>
Julia 的目的在于创建一种集易用、强大、高效的于一身的编程语言。
除了上述特点，Julia相比于其他系统的一些优点还包括：
- 自由并且开源（采用MIT license授权(https://github.com/JuliaLang/julia/blob/master/LICENSE)） 
- 用户自定义数据类型和内建类型一样高效 
- 为并行计算和分布式计算而设计 
- 轻量级“绿色”线程 ([coroutines](http://en.wikipedia.org/wiki/Coroutine))
- 简洁高效的类型系统 
- 对数值和其他类型提供优雅的扩展性转换和改进 
- 对[Unicode](http://en.wikipedia.org/wiki/Unicode)包括[UTF-8](http://en.wikipedia.org/wiki/UTF-8)提供有效的支持
- 直接调用C函数(无需包装和调用特殊函数)
- 拥有管理其他进程的类似shell的高效能力 
- 提过Lisp类型的宏和其他亚程序特性 
</cn>

[LLVM]:        http://en.wikipedia.org/wiki/Low_Level_Virtual_Machine
[MATLAB®]:     http://en.wikipedia.org/wiki/Matlab
[Mathematica]: http://en.wikipedia.org/wiki/Mathematica
[Lisp]:        http://en.wikipedia.org/wiki/Lisp_(programming_language)
[Perl]:        http://en.wikipedia.org/wiki/Perl_(programming_language)
[Python]:      http://en.wikipedia.org/wiki/Python_(programming_language)
[Lua]:         http://en.wikipedia.org/wiki/Lua_(programming_language)
[Ruby]:        http://en.wikipedia.org/wiki/Ruby_(programming_language)
[C]:           http://en.wikipedia.org/wiki/C_(programming_language)
[Java]:        http://en.wikipedia.org/wiki/Java_(programming_language)

<cn>
[LLVM]:        http://en.wikipedia.org/wiki/Low_Level_Virtual_Machine
[MATLAB®]:     http://en.wikipedia.org/wiki/Matlab
[Mathematica]: http://en.wikipedia.org/wiki/Mathematica
[Lisp]:        http://en.wikipedia.org/wiki/Lisp_(programming_language)
[Perl]:        http://en.wikipedia.org/wiki/Perl_(programming_language)
[Python]:      http://en.wikipedia.org/wiki/Python_(programming_language)
[Lua]:         http://en.wikipedia.org/wiki/Lua_(programming_language)
[Ruby]:        http://en.wikipedia.org/wiki/Ruby_(programming_language)
[C]:           http://en.wikipedia.org/wiki/C_(programming_language)
[Java]:        http://en.wikipedia.org/wiki/Java_(programming_language)
</cn>
