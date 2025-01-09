@def rss_pubdate = Date(2012, 2, 14)
@def rss_description = """ 为什么我们要创造Julia (Simplified Chinese) | 我们之中有些是使用MATLAB的重量级用户，有些是来自Lisp的极客，还有一些是来自Python和Ruby的魔法师，甚至还有来自Perl社区的大魔法师。我们之中还有从胡子都没长齐时就开始使用Mathematica的。其中的有些人现在都没长胡子喱！我们... """
@def published = "14 February 2012"
@def title = "为什么我们要创造Julia (Simplified Chinese)"
@def authors = "Jeff Bezanson Stefan Karpinski Viral B. Shah Alan Edelman"

~~~
<a href="https://github.com/JeffBezanson/">Jeff Bezanson</a>
<a href="https://karpinski.org/">Stefan Karpinski</a>
<a href="https://github.com/ViralBShah/">Viral B. Shah</a>
<a href="https://math.mit.edu/~edelman/">Alan Edelman</a>
~~~


> 这是一篇重译，参考了2012年的一篇豆瓣（链接在最后）。

简短来讲，是因为我们很贪婪。

我们之中有些是使用MATLAB的重量级用户，有些是来自Lisp的极客，还有一些是来自Python和Ruby的魔法师，甚至还有来自Perl社区的大魔法师。我们之中还有从胡子都没长齐时就开始使用Mathematica的。其中的有些人现在都没长胡子喱！我们像是疯了一样用R画了越来越多的图，而C是我们的硬核摇滚（也有大杀器之意）。

我们热爱所有这些语言，他们实在很好很强大。在我们从事的领域（科学计算，机器学习，数据挖掘，大规模线性代数计算，分布式和并行计算）中，每一种语言都对某一项工作的一项特定需求非常完美，但是却无法胜任其它需求。于是使用什么语言都需要我们去权衡。

而我们很贪婪，我们还想要更多。

我们想要的是一个自由开源的语言，并且它同时拥有C的速度和Ruby的动态性；我们想要一个具有[同像性]()（可以将语言的脚本本身当作数据进行处理）的语言，它有着真正的和lisp一样的宏，但是却像Matlab一样有着显然的，类似于数学表达式的标记；我们想要一个既可以像Python一样作为通用编程语言的工具，又可以像R那样适用于统计分析，能像Perl那样自然地处理字符串，能像Matlab那样给力地处理矩阵运算，它还要能像shell一样作为胶水将各种程序粘合在一起；我们想要一个简单易学的语言，同时它还能让最苛刻的魔法师们（hackers）开心。我们希望它是交互式的，但我们也希望它能被编译。

我们刚刚有提它要和C一样快嘛？！）

当我们在构思这些需求的时候，我们发现它还得有Hadoop这样强大的分布式能力，却不想要Hadoop里面那些冗长Jave和XML模板，更不想被被迫在几个GB的日志文件和几百台机器里找bug。我们不想要那些令人费解的层次结构。我们想让简单的标量循环能被编译成仅用寄存器和一块CPU的干净的机器码。我们希望简单地写下`A*B`就能够在成千上万的机器上用成千上万地运算来计算这个庞大的矩阵乘法。

如无必要，那就不用声明类型。但当我们需要多态函数（polymorphic functions）时，我们也想要用泛型编程（generic programming）仅仅书写一次算法，就能够在无限多的类型上使用。我们想要多重派发（multiple dispatch）来为一个函数所有可能的参数选出最佳的执行方法。这些参数可能有着不同定义，不同类型，但是却有着相同功能。在拥有以上能力的同时，我们还希望这种语言简单，干净。

要求有点多，是不是？

尽管我们意识到了自己有多贪心，我们还是想要拥有这些功能。大概在两年半之前，我们开始创造这种能满足我们贪念的语言。它还没有完工——但是已经可以发布一个1.0版本了（其实等了6年才要发布）——我们创造的这个语言叫做Julia。它已经实现了我们这次乱七八糟需求的90%，而现在她需要来自更多人的乱七八糟的需求，来让她走得更远。如果你也是一位贪心不足，不可理喻，需索无度的码场二逼青年，希望你能来试试这个东东。

~~~
<p>
作者：Jeff Bezanson, Stefan Karpinski, Viral Shah, Alan Edelman
</br>
译者：Roger
</br>
翻译自：<a href="/blog/2012/02/why-we-created-julia/">Why we create Julia</a>
</br>
参考自：<a href="https://www.douban.com/note/203945680/">豆瓣：为什么我们要创造Julia</a>
</p>
~~~

Trackbacks:
- [Reddit](https://www.reddit.com/r/programming/comments/pv3k9/why_we_created_julia_a_new_programming_language/)
- [Hacker News](https://news.ycombinator.com/item?id=3606380)
- [Lambda-the-Ultimate](http://lambda-the-ultimate.org/node/4452)
- [Phoronix](https://www.phoronix.com/scan.php?page=news_item&px=MTA2ODg)
- [The Endeavor (John D. Cook)](https://www.johndcook.com/blog/2012/02/22/julia-random-number-generation/)
- [Walking Randomly (Mike Croucher)](http://www.walkingrandomly.com/?p=87)
- [Douglas Bates](https://dmbates.blogspot.in/2012/03/julia-version-of-multinomial-sampler_12.html)
- [Vince Buffalo](https://vincebuffalo.com/blog/2012/03/07/thoughts-on-julia-and-r.html)
- [John Myles White](https://www.johnmyleswhite.com/notebook/2012/03/31/julia-i-love-you/)
- [Habrahabr.ru (Russian)](https://habrahabr.ru/blogs/programming/138577/)
- [Linux.org.ru (Russian)](https://www.linux.org.ru/news/opensource/7440863)
- [hellogcc.org (Chinese)](http://www.hellogcc.org/?p=20)
- [Linuxfr.org (French)](https://linuxfr.org/news/version-1-0-de-julia)
