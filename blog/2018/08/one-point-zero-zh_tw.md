@def rss_pubdate = Date(2018, 8, 8)
@def rss_description = """ Julia 1.0 正式發佈 (Traditional Chinese) | 眾所期待的 Julia 語言 (https://julialang.org) 1.0 版是近十年的心血結晶。... """
@def published = "8 August 2018"
@def title = "Julia 1.0 正式發佈 (Traditional Chinese)"
@def authors = "the Julia developers"


~~~Translations:  <a href="https://julialang.org/blog/2018/08/one-point-zero-zh_cn">Simplified Chinese</a>, <a href="https://julialang.org/blog/2018/08/one-point-zero-zh_tw">Traditional Chinese</a>, <a href="https://julialang.org/blog/2018/08/one-point-zero-es">Spanish</a>
~~~

眾所期待的 [Julia 語言](https://julialang.org) 1.0 版是近十年的心血結晶。
在 JuliaCon 2018 年會上，Julia 社群歡慶並共同正式地將該版本 [升級為 1.0.0](https://www.youtube.com/watch?v=1jN5wKvN-Uk#t=3850)。

<!-- The much anticipated 1.0 release of [Julia](https://julialang.org) is the culmination of
nearly a decade of work to build a language for greedy programmers. JuliaCon2018
celebrated the event with a reception where the community officially [set the version to
1.0.0 together](https://www.youtube.com/watch?v=1jN5wKvN-Uk#t=3850). -->

Julia 語言 [第一次公開發佈](/blog/2012/02/why-we-created-julia) 並有不少強烈的期待：

<!-- Julia was [first publicly
announced](/blog/2012/02/why-we-created-julia) with a number of strong
demands on the language: -->

> 我們想要一個開源的語言，擁有自由的版權。我們想要 C 的速度和 Ruby 的動態。我們想要有一個語法與內在表示有一致性（homoiconic）的語言，
> 並且像 Lisp 一樣擁有真的 macro，但是擁有像 Matlab 一樣熟悉好懂的數學符號。我們也想要像 Python 一樣好用的泛用型程式語言，
> 處理統計要和 R 一樣，處理字串要和 Perl 一樣地自然，要有和 Matlab 一樣強大的線性代數功能，串接程式要如同 shell 一樣好用。
> 要學習的東西極致簡單，同時能讓大多數嚴苛的黑客寫起來開心。我們希望它是互動式的而且也是可編譯的。

<!-- > We want a language that’s open source, with a liberal license. We want the speed of C with
> the dynamism of Ruby. We want a language that’s homoiconic, with true macros like Lisp,
> but with obvious, familiar mathematical notation like Matlab. We want something as usable
> for general programming as Python, as easy for statistics as R, as natural for string
> processing as Perl, as powerful for linear algebra as Matlab, as good at gluing programs
> together as the shell. Something that is dirt simple to learn, yet keeps the most serious
> hackers happy. We want it interactive and we want it compiled. -->

一個充滿活力和繁榮的社群圍繞著這樣的語言成長起來，來自世界各地的人們都在為了這個目標而努力不懈地改進和塑造 Julia。
超過 700 人對 Julia 做出了貢獻，更多人創造了上千的開源的 Julia 套件。總而言之，我們創造了這樣一種語言：

<!-- A vibrant and thriving community has grown up around this language, with people from all
around the world iteratively refining and shaping Julia in pursuit of that goal. Over 700
people have contributed to Julia itself and even more people have made thousands of amazing
open source Julia packages. All told, we have built a language that is: -->

* 快速：Julia 一開始就是為高效能設計的。 Julia 可以藉由 LLVM 被編譯成不同平台的高效機器碼。
* 泛用：Julia 使用多重分派（multiple dispatch）作為程式典範（paradigm），可以更容易表達物件導向和函數式的設計模式。標準函式庫提供了非同步 I/O，行程控制，日誌記錄，效能分析，套件管理器等等。
* 動態：Julia 是動態型別的，用起來像腳本語言，並且很好地支援互動式的操作方式。
* 技術：Julia 擅長數值運算，有非常貼近數學的語法，支援多種數值型別，並且支援平行運算。Julia 的多重分派結合數值和陣列相關的資料型別可以說是渾然天成。
* 選擇性的型別標註：Julia 有豐富的資料型別描述，型別宣告可以使得程式更加清楚和穩固。
* 組合性：Julia 的套件可以很和諧的一起運作。矩陣的單位數量或是資料表中一行的貨幣和顏色可以一起運作並且擁有良好的效能。

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

現在可以 [下載 Julia 1.0 版本](https://julialang.org/downloads/) 來試試 Julia。
如果你現在從 Julia 0.6 或者更早的版本開始升級程式碼，我們建議你先使用過渡的 0.7 版本，
其中包括了棄用警告（deprecation warning）來指導你升級的過程。一旦你的程式碼無警告通過，
那麼你可以無痛將程式碼更改為 1.0 版本。
已註冊過的套件可以利用這個來作為墊腳石並發布與 1.0 相容的版本更新。

<!-- Try Julia by [downloading version 1.0 now](https://julialang.org/downloads/). If you’re
upgrading code from Julia 0.6 or earlier, we encourage you to first use the transitional 0.7
release, which includes deprecation warnings to help guide you through the upgrade process.
Once your code is warning-free, you can change to 1.0 without any functional changes. The
registered packages are in the midst of taking advantage of this stepping stone and
releasing 1.0-compatible updates. -->

當然，在 Julia 1.0 版本中一個最重要的新特性是對語言 API 穩定性的保證：你為 Julia 1.0 撰寫的程式碼將可以繼續在
Julia 1.1、1.2 中執行。這種語言是 **足夠成熟的**。基於這樣的一個穩固的基礎，
核心語言的開發者和社群都可以集中於第三方套件，工具，和新特性的開發上。

<!-- The single most significant new feature in Julia 1.0, of course, is a commitment to language
API stability: code you write for Julia 1.0 will continue to work in Julia 1.1, 1.2, etc.
The language is “fully baked.” The core language devs and community alike can focus on
packages, tools, and new features built upon this solid foundation. -->

但是 Julia 1.0 並不只意味著穩定，它也引入一些新的、強大的以及新穎的語言特性。其中一些新的特性是 0.6 版就有的：

<!-- But Julia 1.0 in not just about stability, it also introduces several new, powerful and
innovative language features. Some of the new features since version 0.6 include: -->

* 一個全新的內建 [套件管理器](https://docs.julialang.org/en/latest/stdlib/Pkg/)。它比過去的套件管理器效能更好，在安裝套件上也比以往更加簡單。
它也為每個專案支援虛擬環境並記錄目前工作環境的狀態然後將它分享給其它開發者或者是自己。最後重新設計的套件管理器也帶來了
私有套件和 repository 的無縫銜接。你同樣可以使用開源套件的方式來管理及安裝自己的私有套件。這個 [JuliaCon 的演講](https://www.youtube.com/watch?v=GBi__3nF-rM)
展示了套件管理器的新設計。

<!-- * A brand new built-in [package manager](https://docs.julialang.org/en/latest/stdlib/Pkg/)
  brings enormous performance improvements and makes it easier than ever to install packages
  and their dependencies. It also supports per-project package environments and recording
  the exact state of a working application to share with others—and with your future self.
  Finally, the redesign also introduces seamless support for private packages and package
  repositories. You can install and manage private packages with the same tools as you’re
  used to for the open source package ecosystem. The [presentation at
  JuliaCon](https://www.youtube.com/watch?v=GBi__3nF-rM) provides a good overview of the new
  design and behavior. -->

* Julia 具有新的 [遺失值（missing value）的正式表示法](/blog/2018/06/missing)。能表示及處理遺失值是統計學和資料科學一項基本能力。
在典型的 Julia 寫法（Julian fashion）裡，新的解決方案是具有廣義性、組合性，也是高效能的。任何一般的集合型別（collection type）都可以簡單地使用
預先定義好的 `missing` 變數來有效支援遺失值。而這種集合型別的效能在過去的 Julia 版本里可能會很慢，但是現在編譯器已經
可以使得 Julia 在遺失值的表示上達到類似 C 或者 C++ 的速度，然而遠比 C 或者 C++ 更廣義和靈活。

<!-- * Julia has a new [canonical representation for missing
  values](/blog/2018/06/missing). Being able to represent and work with
  missing data is fundamental to statistics and data science. In typical Julian fashion, the
  new solution is general, composable and high-performance. Any generic collection type can
  efficiently support missing values simply by allowing elements to include the pre-defined
  value `missing`. The performance of such “union-typed” collections would have been too
  slow in previous Julia versions, but compiler improvements now allow Julia to match the
  speed of custom C or C++ missing data representations in other systems, while also being
  far more general and flexible. -->

* 內建的 `String` 型別可以安全地使用並且處理任意的資料。你的程式不會因為一個無效 Unicode 字元而壞掉好幾個小時或者好幾天。
所有的字串資料會保留，同時指出哪些字元是有效的，哪些是無效的，這樣允許你的應用程式安全而方便地執行在不可避免缺陷的真實世界的資料中。

<!-- * The built-in `String` type can now safely hold arbitrary data. Your program won’t fail
  hours or days into a job because of a single stray byte of invalid Unicode. All string
  data is preserved while indicating which characters are valid or invalid, allowing your
  applications to safely and conveniently work with real world data with all of its
  inevitable imperfections. -->

* Broadcasting 已經成為語言的核心特性，並且有著方便的語法支援，現在，它將比過去更加強大。在 Julia 1.0 裡，
[賦予自定義型別 broadcasting 特性](/blog/2018/05/extensible-broadcast-fusion) 和在 GPU 和向量化硬體上實作最佳的運算都更加容易，
這是為未來更多的效能提升鋪路。

<!-- * Broadcasting is already a core language feature with convenient syntax—and it’s now more
  powerful than ever. In Julia 1.0 it’s simple to [extend broadcasting to custom
  types](/blog/2018/05/extensible-broadcast-fusion) and implement
  efficient optimized computations on GPUs and other vectorized hardware, paving the way for
  even greater performance gains in the future. -->

* Named tuples 是一個新的語言特性，它允許高效而方便地表示和存取資料的名字來獲取資料。例如，你可以這樣表示一列資料
`row = (name="Julia", version=v"1.0.0", releases=8)` 並且透過 `row.version` 存取 `version` 資料，而這和
`row[2]`有著同樣的效能，卻更加方便。

<!-- * Named tuples are a new language feature which make representing and accessing data by name
  efficient and convenient. You can, for example, represent a row of data as `row =
  (name="Julia", version=v"1.0.0", releases=8)` and access the `version` column as
  `row.version` with the same performance as the less convenient `row[2]`. -->

* 點運算子現在可以被重載，並且允許型別使用 `obj.property` 的方式來存取物件資訊，而不是用額外撰寫欄位 setting 和 getting function 的方式。
這有助於將以類別為基礎的語言例如 Python 和 Java 更加流暢地翻譯到 Julia。屬性存取器的重載讓存取一行資料與 named tuples 的存取語法一致：你可以寫 `table.version` 來獲取表格中的 `version` 這一行，就如同 `row.version` 會取得
`version` 這一列的這個欄位一樣。

<!-- * The dot operator can now be overloaded, allowing types to use the `obj.property` syntax
  for meanings other than getting and setting struct fields. This is especially useful for
  smoother interop with class-based languages such as Python and Java. Property accessor
  overloading also allows the syntax for getting a column of data to match named tuple
  syntax: you can write `table.version` to access the `version` column of a table just as
  `row.version` accesses the `version` field of a single row. -->

* Julia 語言的最佳化器在多個方面都更加聰明，我們無法全部羅列，但有值得列舉的一些重要的特點。最佳化器現在可以在函式
呼叫之間傳遞常數，這將使得編譯器可以有比過去更好地執行死碼刪除（dead-code elimination）和靜態求值。編譯器現在也能夠避免對短期封裝（short-lived wrappers）的
長期物件（long-lived objects）做記憶體配置，這讓程式設計師可以用方便的高階抽象而不會有效能損失。

<!-- * Julia’s optimizer has gotten smarter in more ways than we can list here, but a few
  highlights are worth mentioning. The optimizer can now propagate constants through
  function calls, allowing much better dead-code elimination and static evaluation than
  before. The compiler is also much better at avoiding allocation of short-lived wrappers
  around long-lived objects, which frees programmers to use convenient high-level
  abstractions without performance costs. -->

* 參數化型別（Parametric type）的建構子（constructors）現在將使用和宣告同樣的語法來呼叫。這將減少一些對語法的困惑。

<!-- * Parametric type constructors are now always called with the same syntax as they are
  declared. This eliminates an obscure but confusing corner of language syntax. -->

* 迭代器協定被重新設計。新的迭代器協定更加簡單，不需要定義三個不同的函式：`start`、`next`、`done`。現在只需定義一個參數
和兩個參數的 `iterate` 函式即可。這允許我們可以簡單地定義一個帶有預設值的函式來給出一個初始值。更重要的是，這也實現了一個只有在嘗試回傳失敗之後就結束的迭代器。這種迭代器可以非常普遍使用在 I/O、網絡和生產者-消費者模型中；而 Julia 現在
可以更直接和正確地撰寫這樣的迭代器。

<!-- * The iteration protocol has been completely redesigned to make it easier to implement many
  kinds of iterables. Instead of defining methods of three different generic
  functions—`start`, `next`, `done`—one now defines one- and two-argument methods of the
  `iterate` function. This often allows iteration to be conveniently defined with a single
  definition with a default value for the start state. More importantly, it makes it
  possible to implement iterators that only know if they're done once they've tried and
  failed to produce a value. These kinds of iterators are ubiquitous in I/O, networking, and
  producer/consumer patterns; Julia can now express these iterators in a straightforward and
  correct manner. -->

* 作用域的規則被簡化了。引入區域作用域的結構提高了一致性，而不需要管全域的命名綁定是否已經存在。
這將消除之前的 “軟/硬作用域” 的區別，也意味著現在 Julia 可以靜態地確定變數是區域的還是全域的。

<!-- * Scope rules have been simplified. Constructs that introduce local scopes now do so
  consistently, regardless of whether a global binding for a name already exists or not.
  This eliminates the “soft/hard scope” distinction that previously existed and means that
  now Julia can always statically determine whether variables are local or global. -->

* Julia 語言本身變得更加輕量級，很多部分都被從核心分離到標準函式庫中。這個標準函式庫將和 Julia 一起發布但是不會作為語言的基礎。
如果你需要他們，那麼只需引入這些函式庫即可（不需要再安裝）但是不會強制使用。在未來這些標準函式庫將會獨立被標記版本和更新
以達到更快的改進和升級。

<!-- * The language itself is significantly leaner, with many components split out into “standard
  library” packages that ship with Julia but aren’t part of the “base” language. If you need
  them, they’re an import away (no installation required) but they’re no longer forced on
  you. In the future, this will also allow standard libraries to be versioned and upgraded
  independently of Julia itself, allowing them to evolve and improve at a faster rate. -->

我們仔細地審查了 Julia 的 API，並且提高了它的一致性和可用性。很多費解的命名和低效的實作都被重新命名和重構，
能夠更優雅地發揮 Julia 的能力。這樣的改變促使集合的使用方式更加一致和連貫。確保在整個語言中遵循一致的參數的順序，
並且將關鍵字參數（現在更快了）整合到了 API 中。

<!-- * We’ve done a thorough review of all of Julia’s APIs to improve consistency and usability.
  Many obscure legacy names and inefficient programming patterns have been renamed or
  refactored to more elegantly match Julia's capabilities. This has prompted changes to make
  working with collections more consistent and coherent, to ensure that argument ordering
  follows a consistent standard throughout the language, and to incorporate (the now faster)
  keyword arguments into APIs where appropriate. -->

* 我們特地創建了一些新的外部套件相容於 Julia 1.0 的新特性，例如：
    * 資料處理相關套件已經改版並支援新的遺失值
    * [Cassette.jl](https://github.com/jrevels/Cassette.jl) 提供了 Julia 程式碼轉換到編譯器中的強大機制，允許 post-hoc analysis 和拓展既有程式碼。除了提供 profiling 和 debugging 這樣的工具之外，甚至可以用於實現機器學習任務的自動微分。
    * 異質架構（Heterogeneous architecture）的支援被大大提高，並且從 Julia 編譯器中解耦了出來。 Intel KNL 系列硬體上可以直接使用 Julia。 而 Nvidia 的 GPU 也可以透過 [CUDANative.jl](https://github.com/JuliaGPU/CUDAnative.jl) 來直接編寫程式（不需要撰寫 CUDA 程式碼）， 而支援 Google TPU 的介面也正在開發中。

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

還有無數個大大小小的改善。你可以查看 [0.7 NEWS 文件](https://github.com/JuliaLang/julia/blob/release-0.7/NEWS.md) 當中的完整的更新。
在我們 2012 年的 ["為什麼我們創造 Julia" 文章](/blog/2012/02/why-we-created-julia) 裡，我們寫到：

<!-- There are countless other improvements, both large and small. For a complete list of
changes, see the [0.7 NEWS file](https://docs.julialang.org/en/release-0.7/NEWS/). In our
original [“Why We Created Julia” blog
post](/blog/2012/02/why-we-created-julia) in 2012, we wrote -->

> 它還沒有完工，但是是時候發布一個 1.0 版本了（其實歷時 6 年才發布）—— 我們創造了一個語言叫做 Julia。

<!-- > It’s not complete, but it’s time for a 1.0 release—the language we’ve created is called
> [Julia](https://julialang.org). -->

雖然對於 1.0 的發布我們放了大家好幾次鴿子，但是這一次我們終於正式發布了。
我們真心為上千位以各種形式貢獻給這個真正的數值計算和泛用程式設計的現代語言的人感到自豪和無比欣喜。

<!-- We may have jumped the gun a bit with mentioning an impending 1.0 release, but the time has
finally arrived and it is a heck of a release. We are truly proud of what’s been
accomplished by the thousands of people who have contributed in so many ways to this truly
modern language for numerical and general programming. -->
