@def rss_pubdate = Date(2018, 8, 8)
@def rss_description = """ Julia 1.0 正式发布 (Simplified Chinese) | 备受期待的Julia语言 (https://julialang.org)的1.0版本积累了富有野心的程序员们的十年心血。... """
@def published = "8 August 2018"
@def title = "Julia 1.0 正式发布 (Simplified Chinese)"
@def authors = "the Julia developers"


备受期待的[Julia语言](https://julialang.org)的1.0版本积累了富有野心的程序员们的十年心血。
在 JuliaCon2018 发布会上，Julia 社区正式将该版本[设置为1.0.0](https://www.youtube.com/watch?v=1jN5wKvN-Uk#t=3850)。

<!-- The much anticipated 1.0 release of [Julia](https://julialang.org) is the culmination of
nearly a decade of work to build a language for greedy programmers. JuliaCon2018
celebrated the event with a reception where the community officially [set the version to
1.0.0 together](https://www.youtube.com/watch?v=1jN5wKvN-Uk#t=3850). -->

Julia项目[起初](/blog/2012/02/why-we-created-julia)是因为这些强烈的需求而公开发起的开源项目：

<!-- Julia was [first publicly
announced](/blog/2012/02/why-we-created-julia) with a number of strong
demands on the language: -->

> 我们想要的是一个自由开源的语言，并且它同时拥有C的速度和Ruby的动态性；我们想要一个具有同像性（可以将语言的脚本本身当作数据进行处理）的语言，
> 它有着真正的和lisp一样的宏，但是却像Matlab一样有着显然的，类似于数学表达式的标记；我们想要一个既可以像Python一样作为通用编程语言的工具，
> 又可以像R那样适用于统计分析，能像Perl那样自然地处理字符串，能像Matlab那样给力地处理矩阵运算，它还要能像shell一样作为胶水将各种程序粘
> 合在一起；我们想要一个简单易学的语言，同时它还能让最苛刻的魔法师们（hackers）开心。我们希望它是交互式的，但我们也希望它能被编译。

<!-- > We want a language that’s open source, with a liberal license. We want the speed of C with
> the dynamism of Ruby. We want a language that’s homoiconic, with true macros like Lisp,
> but with obvious, familiar mathematical notation like Matlab. We want something as usable
> for general programming as Python, as easy for statistics as R, as natural for string
> processing as Perl, as powerful for linear algebra as Matlab, as good at gluing programs
> together as the shell. Something that is dirt simple to learn, yet keeps the most serious
> hackers happy. We want it interactive and we want it compiled. -->

一个充满活力和繁荣的社区就围绕这种语言成长起来，世界各地的人们都在为了这个目标而不断努力改进和塑造Julia。
超过700人为Julia做出了自己的贡献，更多人创造了成千上万开源的Julia包。总而言之，我们创造了这样一种语言：

<!-- A vibrant and thriving community has grown up around this language, with people from all
around the world iteratively refining and shaping Julia in pursuit of that goal. Over 700
people have contributed to Julia itself and even more people have made thousands of amazing
open source Julia packages. All told, we have built a language that is: -->

* 快速：Julia一开始就是为高性能而设计的。Julia可以通过LLVM而跨平台被编译成高效的本地代码。
* 通用：Julia使用多分派作为编程范式，使其更容易表达面向对象和函数式编程范式。标准库提供了异步I/O，进程控制，日志记录，性能分析，包管理器等等。
* 动态：Julia是动态类型的，与脚本语言类似，并且对交互式使用具有很好的支持。
* 数值计算：Julia擅长于数值计算，它的语法适用于数学计算，支持多种数值类型，并且支持并行计算。Julia的多分派自然适合于定义数值和类数组的数据类型。
* 可选的类型标注：Julia拥有丰富的数据类型描述，类型声明可以使得程序更加可读和健壮。
* 可组合：Julia的包可以很自然的组合运行。单位数量的矩阵或数据表一列中的货币和颜色可以一起组合使用并且拥有良好的性能。

<!-- * **Fast**: Julia was designed from the beginning for high performance. Julia programs
  compile to efficient native code for multiple platforms via LLVM.
* **General**: It uses multiple dispatch as a paradigm, making it easy to express many
  object-oriented and functional programming patterns. The standard library provides
  asynchronous I/O, process control, logging, profiling, a package manager, and more.
* **Dynamic**: Julia is dynamically-typed, feels like a scripting language, and has good
  support for interactive use.
* **Technical**: It excels at numerical computing with a syntax that is great for math, many
  supported numeric data types, and parallelism out of the box. Julia's multiple dispatch
  is a natural fit for defining number and array-like data types.
* **Optionally typed**: Julia has a rich language of descriptive data types, and type
  declarations can be used to clarify and solidify programs.
* **Composable**: Julia’s packages naturally work well together. Matrices of unit
  quantities, or data table columns of currencies and colors, just work — and with good
  performance. -->

现在可以通过[下载Julia 1.0版本](/downloads/)来尝试Julia。
如果你现在从Julia 0.6或者更早的版本开始升级代码，我们建议你先使用过渡性的0.7版本，
其中包括了弃用警告（deprecation warning）来指导你的升级过程。一旦你的代码无警告通过，
那么你可以在没有任何功能变化的情况下将代码更改为1.0版本。
已注册过的包可以利用这个来过渡并发布与1.0版本兼容的更新。


<!-- Try Julia by [downloading version 1.0 now](/downloads/). If you’re
upgrading code from Julia 0.6 or earlier, we encourage you to first use the transitional 0.7
release, which includes deprecation warnings to help guide you through the upgrade process.
Once your code is warning-free, you can change to 1.0 without any functional changes. The
registered packages are in the midst of taking advantage of this stepping stone and
releasing 1.0-compatible updates. -->

当然，在Julia 1.0版本中一个最重要的新特性是对语言API稳定性的承诺：你为Julia1.0编写的代码将可以继续在
Julia 1.1, 1.2中运行。这种语言是“足够成熟的”。基于这样的一个坚实的基础，
核心语言的开发者和社区都可以集中于第三方包，工具，和新特性的开发上。


<!-- The single most significant new feature in Julia 1.0, of course, is a commitment to language
API stability: code you write for Julia 1.0 will continue to work in Julia 1.1, 1.2, etc.
The language is “fully baked.” The core language devs and community alike can focus on
packages, tools, and new features built upon this solid foundation. -->

但是Julia 1.0并不意味着稳定，它也带来一些新的，强大的并且创新的语言特性。其中一些新的特性是0.6开始就有的：

<!-- But Julia 1.0 in not just about stability, it also introduces several new, powerful and
innovative language features. Some of the new features since version 0.6 include: -->

* 一个全新的内建 [包管理器](https://docs.julialang.org/en/latest/stdlib/Pkg/)。它比过去的包管理器性能更好，
也更加简单。它也支持虚拟环境和记录当前工作环境的状态然后将其分享给其它开发者或者是自己。最后重新设计的包管理器也带来了
私有包和包的仓库的无缝衔接。你可以用使用开源生态同样的方式用它来管理自己的私有包。这个 [JuliaCon的幻灯片](https://www.youtube.com/watch?v=GBi__3nF-rM)
展示了新设计的包管理器。

<!-- * A brand new built-in [package manager](https://docs.julialang.org/en/latest/stdlib/Pkg/)
  brings enormous performance improvements and makes it easier than ever to install packages
  and their dependencies. It also supports per-project package environments and recording
  the exact state of a working application to share with others—and with your future self.
  Finally, the redesign also introduces seamless support for private packages and package
  repositories. You can install and manage private packages with the same tools as you’re
  used to for the open source package ecosystem. The [presentation at
  JuliaCon](https://www.youtube.com/watch?v=GBi__3nF-rM) provides a good overview of the new
  design and behavior. -->

* Julia具有新的 [对于缺失值（missing value）的正则表达](/blog/2018/06/missing)。处理缺失值的能力对于统计学和数据科学是一项基本能力。
在典型的Julia写法里，这个解决方案是一般性的，可扩展的也是高性能的。任何一般的集合类型（collection type）都可以简单地通过使用
预先定义好的 `missing` 变量来有效支持缺失值。而这样的集合类型的性能在过去的Julia版本里可能会很慢，但是现在编译器已经
可以使得Julia在缺失值的表示上达到类似 C 或者 C++ 的速度，而远比 C 或者 C++ 一般和灵活。

<!-- * Julia has a new [canonical representation for missing
  values](/blog/2018/06/missing). Being able to represent and work with
  missing data is fundamental to statistics and data science. In typical Julian fashion, the
  new solution is general, composable and high-performance. Any generic collection type can
  efficiently support missing values simply by allowing elements to include the pre-defined
  value `missing`. The performance of such “union-typed” collections would have been too
  slow in previous Julia versions, but compiler improvements now allow Julia to match the
  speed of custom C or C++ missing data representations in other systems, while also being
  far more general and flexible. -->

* 内建的 `String` 类型可以安全的使用任意的数据类型。你的程序不会因为一个单独的无效Unicode字节而失效好几个小时或者好几天。
所有的字符串数据会保留，同时指出哪些字符是有效的哪些是无效的，这样允许你的应用安全并方便地运行在不可避免会出现缺陷的真实世界的数据中。

<!-- * The built-in `String` type can now safely hold arbitrary data. Your program won’t fail
  hours or days into a job because of a single stray byte of invalid Unicode. All string
  data is preserved while indicating which characters are valid or invalid, allowing your
  applications to safely and conveniently work with real world data with all of its
  inevitable imperfections. -->

* 尽管广播早已成为一项语言的核心特性并且有着方便的语法支持，而现在它将比过去更加强大。在Julia 1.0里[为自定义类型扩展广播](/blog/2018/05/extensible-broadcast-fusion)和实现高效的GPU和向量化硬件上的扩展都
更加容易，为未来实现更高的性能铺平了道路。

<!-- * Broadcasting is already a core language feature with convenient syntax—and it’s now more
  powerful than ever. In Julia 1.0 it’s simple to [extend broadcasting to custom
  types](/blog/2018/05/extensible-broadcast-fusion) and implement
  efficient optimized computations on GPUs and other vectorized hardware, paving the way for
  even greater performance gains in the future. -->

* 可命名元组是一个新的语言特性，它将是的通过名字直接获取数据变得更加高效和方便。例如，你可以这样表示一列数据 `row =
(name="Julia", version=v"1.0.0", releases=8)` 并且通过 `row.version` 访问 `version` 的数据，而这和
`row[2]` 有着相似的性能，但是却更加方便。

<!-- * Named tuples are a new language feature which make representing and accessing data by name
  efficient and convenient. You can, for example, represent a row of data as `row =
  (name="Julia", version=v"1.0.0", releases=8)` and access the `version` column as
  `row.version` with the same performance as the less convenient `row[2]`. -->

* 点算符现在可以被重载，并且允许类型使用类似于 `obj.property` 的方式表示某种意义，而不是用来设置和获取合成类型（struct）的
成员。这对于将具有 `class` 的语言例如 `Python` 和 `Java` 翻译到Julia来说更加平滑。性质的访问器重载也将是的获取匹配数据的名
称的一列于可命名元组更加一致：你可以写 `table.version` 来获取表格中的 `version` 这一列就好像 `row.version` 会获取 `version`
这一行的这个元素一样。

<!-- * The dot operator can now be overloaded, allowing types to use the `obj.property` syntax
  for meanings other than getting and setting struct fields. This is especially useful for
  smoother interop with class-based languages such as Python and Java. Property accessor
  overloading also allows the syntax for getting a column of data to match named tuple
  syntax: you can write `table.version` to access the `version` column of a table just as
  `row.version` accesses the `version` field of a single row. -->

* Julia的优化器在诸多方面都更加聪明来，以至于我们无法全部列在这里，但是可以列举一些重要的特点。优化器现在可以在函数
调用之间传播常数变量，这将使得编译器可以比过去更好的消除死代码（dead-code）和进行静态求值。编译器现在也能够对短期存在
的长期对象的封装避免多余的内存分配，这将使得程序员可以使用更方便的高级抽象而不会担心带来性能损失。

<!-- * Julia’s optimizer has gotten smarter in more ways than we can list here, but a few
  highlights are worth mentioning. The optimizer can now propagate constants through
  function calls, allowing much better dead-code elimination and static evaluation than
  before. The compiler is also much better at avoiding allocation of short-lived wrappers
  around long-lived objects, which frees programmers to use convenient high-level
  abstractions without performance costs. -->

* 参数类型的构造函数现在将使用和声明同样的语法来调用。这将减少一些对语法小的误解。

<!-- * Parametric type constructors are now always called with the same syntax as they are
  declared. This eliminates an obscure but confusing corner of language syntax. -->

* 迭代器协议被重新设计。新的迭代器协议更加简单，而不需要定义三个不同的函数：`start`，`next`，`done`。现在只需定义一个变量
和两个变量的 `iterate` 函数即可。这将常常使得我们可以简单地通过定义了一个函数参数默认值的函数来实现迭代器。更加重要的是，这将使得
实现一个只有在尝试返回值失败之后才知道需要结束的迭代器成为可能。这种迭代器在 I/O，网络和生产者/消费者模型中普遍存在；而Julia现在
可以以更加直接和正确的方式表达这样的迭代器。

<!-- * The iteration protocol has been completely redesigned to make it easier to implement many
  kinds of iterables. Instead of defining methods of three different generic
  functions—`start`, `next`, `done`—one now defines one- and two-argument methods of the
  `iterate` function. This often allows iteration to be conveniently defined with a single
  definition with a default value for the start state. More importantly, it makes it
  possible to implement iterators that only know if they're done once they've tried and
  failed to produce a value. These kinds of iterators are ubiquitous in I/O, networking, and
  producer/consumer patterns; Julia can now express these iterators in a straightforward and
  correct manner. -->

* 作用域的规则被简化了。引入局部作用域的构造将更加一致，而不需要管全局的命名绑定是否已经存在。
这将消除之前存在的 “软/硬 作用域”的区别，也意味着现在Julia可以静态地确定变量是局部的还是全局的。

<!-- * Scope rules have been simplified. Constructs that introduce local scopes now do so
  consistently, regardless of whether a global binding for a name already exists or not.
  This eliminates the “soft/hard scope” distinction that previously existed and means that
  now Julia can always statically determine whether variables are local or global. -->

* Julia语言本身变得更加轻量级来，很多部分都不放在来标准库中。这个标准库将和Julia一起发布但是不会作为语言的基础依赖。
如果你需要他们，那么只需导入这些库即可（不需要再安装）但是它们不再强制你使用了。在未来这些标准库将会单独被标记版本和更新
以获取更快的改进和升级。

<!-- * The language itself is significantly leaner, with many components split out into “standard
  library” packages that ship with Julia but aren’t part of the “base” language. If you need
  them, they’re an import away (no installation required) but they’re no longer forced on
  you. In the future, this will also allow standard libraries to be versioned and upgraded
  independently of Julia itself, allowing them to evolve and improve at a faster rate. -->

我们仔细地审查了Julia的API，并且提高了它的一致性和可用性。很多费解的命名和低效的实现都被重新命名和重构，使得其能够
更优雅地发挥Julia的能力。这将使得使用集合类的方式更加一致和连贯。变量的顺序被确保在整个语言中遵循一个统一的标准，并且
将关键词变量（现在更快了）加入到了API中。

<!-- * We’ve done a thorough review of all of Julia’s APIs to improve consistency and usability.
  Many obscure legacy names and inefficient programming patterns have been renamed or
  refactored to more elegantly match Julia's capabilities. This has prompted changes to make
  working with collections more consistent and coherent, to ensure that argument ordering
  follows a consistent standard throughout the language, and to incorporate (the now faster)
  keyword arguments into APIs where appropriate. -->

* 围绕Julia 1.0的新特性，我们特别地创建了一些新的外部包：
    * 数据处理生态系统通过翻新利用了新的缺失值支持
    * [Cassette.jl](https://github.com/jrevels/Cassette.jl)将为Julia带来向编译器中注入代码变换，使得

<!-- removed the indent on this paragraph to avoid StringIndexError -->
事后分析（post-hoc analysis）和扩展已有的代码成为可能。在除了提供profiling和debugging这样的工具之外，
这甚至可以用于实现用于机器学习任务的自动微分。
* 异构计算的支持被大大提高，并且从Julia编译器中分离了出来。Intel KNL系列硬件可以直接使用Julia。而Nvidia的GPU
也可以通过[CUDANative.jl](https://github.com/JuliaGPU/CUDAnative.jl)来直接编程（无须编写CUDA代码），而
支持Google TPU的接口也正在开发中。


<!-- * A number of new external packages are being built specifically around the new capabilities
  of Julia 1.0. For example:
    * The data processing and manipulation ecosystem is being revamped to take advantage of
      the new missingness support.
    * [Cassette.jl](https://github.com/jrevels/Cassette.jl) provides a powerful mechanism to
      inject code-transformation passes into Julia’s compiler, enabling post-hoc analysis
      and extension of existing code. Beyond instrumentation for programmers like profiling
      and debugging, this can even implement automatic differentiation for machine learning
      tasks.
    * Heterogeneous architecture support has been greatly improved and is further decoupled
      from the internals of the Julia compiler. Intel KNLs just work in Julia. Nvidia GPUs
      are programmed using the [CUDANative.jl](https://github.com/JuliaGPU/CUDAnative.jl)
      package, and a port to Google TPUs is in the works. -->

还有很多没有被列举的大大小小的提高。你可以通过 [0.7 NEWS 文件](https://github.com/JuliaLang/julia/blob/release-0.7/NEWS.md)查看
完整的更新。在我们2012年的 ["为什么我们创造来Julia"博文](/blog/2012/02/why-we-created-julia)里，我们写到：

> 它还没有完工——但是已经可以发布一个1.0版本了（其实等了6年才要发布）——我们创造的这个语言叫做Julia。

<!-- There are countless other improvements, both large and small. For a complete list of
changes, see the [0.7 NEWS file](https://docs.julialang.org/en/release-0.7/NEWS/). In our
original [“Why We Created Julia” blog
post](/blog/2012/02/why-we-created-julia) in 2012, we wrote

> It’s not complete, but it’s time for a 1.0 release—the language we’ve created is called
> [Julia](https://julialang.org). -->


虽然对于1.0的发布我们放了大家好几次鸽子，但是这一次我们终于正式发布了。
我们真心为所有为这个真正为数值计算和通用编程设计的现代语言的各种形式的贡献的人感到自豪和高兴。


<!-- We may have jumped the gun a bit with mentioning an impending 1.0 release, but the time has
finally arrived and it is a heck of a release. We are truly proud of what’s been
accomplished by the thousands of people who have contributed in so many ways to this truly
modern language for numerical and general programming. -->
