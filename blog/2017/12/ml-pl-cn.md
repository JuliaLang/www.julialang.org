@def rss_pubdate = Date(2017, 12, 20)
@def rss_description = """ 机器学习与编程语言 (Simplified Chinese) | > 任何足够复杂的机器学习系统，里面都拼凑了半个不规范，处处错误，且运行缓慢的编程语言。^greenspun ... """
@def published = "20 December 2017"
@def title = "机器学习与编程语言 (Simplified Chinese)"
@def authors = "By Mike Innes (JuliaHub), David Barber (UCL), Tim Besard (UGent), James Bradbury (Salesforce Research), Valentin Churavy (MIT), Simon Danisch (MIT), Alan Edelman (MIT), Stefan Karpinski (JuliaHub), Jon Malmaud (MIT), Jarrett Revels (MIT), Viral Shah (JuliaHub), Pontus Stenetorp (UCL) and Deniz Yuret (Koç University)"
@def hascode = true

> 任何足够复杂的机器学习系统，里面都拼凑了半个不规范，处处错误，且运行缓慢的编程语言。[^greenspun]

器学习（ML）已如烈火烹油般火热。身处编程语言（PL）领域，我们饶有兴趣地关注着机器学习模型的复杂度和构造这些模型所用的框架。当今最前沿的模型越来越像*程序*：里面有循环和递归这样的编程结构；这对制造机器学习模型的工具本身，即编程语言，提出了许多有趣的挑战。

虽然目前还没有一个机器学习专属的语言，但实事求是地说，已有几种新语言（比如 TensorFlow）藏身于 Python 语言接口之后；也有一些（比如 PyTorch）则直接用 Python 作为自己的建模语言。我们要问这样一个问题——需不需要专门为机器学习定制一个全新的语言？如果是，为什么？更重要地，如果将来出现一个理想的机器学习语言，它会长什么样？

\toc

## [儿童黑话](https://zh.wikipedia.org/zh-hk/兒童黑話)及其它隐匿语言

TensorFlow（TF）等框架[^tf][已被公认属于编程语言](https://dl.acm.org/citation.cfm?doid=3088525.3088527)，尽管它们在某些方面还有局限。这多少有些意料之外，毕竟大家 TF 编程时用的是 Python。然而琢磨一下就会发现，TF 只是让你用 Python 代码[构造了一个表达式树](https://www.tensorflow.org/programmers_guide/graphs)，这个表达式树是用其内部语言表示的，之后再进行计算。


实际上，可以在任何语言上实现 TensorFlow 这种“延迟”计算的风格。如下 JavaScript 代码就用此风格写了一个 `add` 函数:

```javascript
function add(a,b) {
  return `${a}+${b}`;
}
x = 1; y = 2
z = add('x', 'y') // 'x+y'
eval(z) // 3
x = 4
eval(z) // 6
```

这就是*元编程*——编写用于写代码的代码。这个例子里的元语言和目标语言是一致的（都是 JavaScript），但它们完全可以是两种不同的语言（如 C 语言预处理器之于 C 语言）。同理，元编程也可以通过某种数据结构（[AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree)）来实现，而不仅限于字符串层面的处理。对 TensorFlow 而言，Python 就是一个用来书写 TF 基于图的编程语言[^ast]的元语言。如果您对此还有疑虑，那么请想一想，TensorFlow 在实现图的[变量作用域](https://www.tensorflow.org/programmers_guide/variables)和[流程控制](https://www.tensorflow.org/api_docs/python/tf/cond)这些编程结构时并没有采用 Python 语法，而是利用 API 来实现的。


TensorFlow 及类似的工具以“我仅仅是个库”的姿态出现。然而作为库，它们却异乎寻常。大多数的库只提供简单的一组函数和数据结构，而不是给一整套新的编程系统和运行时。那么，为什么说采用这样一种复杂的方式是有必要的呢？

## 为什么要创造一个新语言？

根本的原因非常简单：机器学习研究对计算有极高的要求，那么简化建模语言就能让我们更轻松地加入针对于特定领域的优化与功能。训练模型需要语言对硬件有很好的支持，拥有良好的数值库，很低的解释器开销，并且支持多种并行方式。像 Python 这样的通用语言很难满足这些需求，而 TensorFlow 却能轻松胜任。

话虽如此，有一个小问题不能忽略。卓有成效的优化依赖于能够简化问题的假设（机器学习模型里不会出现递归，也不需要自定义梯度，对吧？）。正是这些假设使得模型的优化更简单，也更易于部署到小型设备上。可惜研究员们沉醉于破坏这些假设的乐趣中，工程师们面对的模型也越来越复杂。一个模型现在会用到条件分支（不算什么，小菜一碟），循环（不怎么容易，但应该可以搞定），甚至[树的递归](https://arxiv.org/pdf/1503.00075.pdf)（好吧，基本上做不到）。 在机器学习的很多分支中，包括[神经网络](https://blog.keras.io/the-future-of-deep-learning.html)和[概率编程](https://eng.uber.com/pyro/)，模型越来越像程序：有些模型可以推导*其它*程序（例如[程序生成器](https://arxiv.org/pdf/1705.03633.pdf)和[解释器](https://arxiv.org/abs/1605.06640)）；有些则包括像蒙特卡罗树搜索这样的不可导组件。在保证最高性能的同时提供充分的灵活性，这对运行时的构建提出了极高的挑战，然而两者的兼顾却是最强大的模型和突破性的成果所越来越倚重的。

~~~
<img src="/assets/images/sentiment-treebank.png"/>
<div class="desc">
  用机器学习处理复杂的树结构数据，如<a href="https://nlp.stanford.edu/sentiment/treebank.html">斯坦福情绪树库</a>，用到了可微的，递归的算法。
</div>
~~~

这种方式，至少以现在的样子，还有一个操作层面上的不利因素，就是需要引入元编程。构建和计算表达式树给程序员和编译器同时施加了很大的额外负担。推导其过程变得尤为困难，因为代码将有两个运行时间，每个都有着不同的语言语义，诸如单步调试这样的操作也是难度陡增。给新运行时创造一个句法语言可以解决这个问题，但这又何异于创造一个新的完整的编程语言！在已经有非常流行的数值语言的情况下，这么做还有意义吗？

## 直接用 Python 不行吗？

当机器学习模型开始需要一个编程语言的全部能力，Chainer 等探索了一种
[“运行即定义”](https://arxiv.org/pdf/1701.03980.pdf)的方案：Python 程序本身被看作模型，梯度则由运行时自动微分（AD）来取得。从可用性角度看这非常炫酷：想要一个处理树结构的递归模型？那么只要把这个过程写下来，然后坐看 AD 变魔术就可以啦！这种方式带来的体验上的微妙变化[怎么夸都不过分](https://twitter.com/karpathy/status/868178954032513024?lang=en)。这样一种可以毫无压力地试验新想法的方式对学术研究也是无价之宝。

然而，让 Python 满足机器学习所要求的巨大计算量比想象中的要困难的多。人们投入了[大量的工作](https://www.youtube.com/watch?v=DBVLcgq2Eg0)只为了复现那些在其它语言看来是轻而易举的优化。许多想让 Python 变得更快的努力已长眠于编程语言的埋骨地，有些也[很知名](https://arstechnica.com/information-technology/2009/03/google-launches-project-to-boost-python-performance-by-5x/)，但都[失败了](https://blog.pyston.org/2017/01/31/pyston-0-6-1-released-and-future-plans/)。[Python 的语义](http://blog.kevmod.com/2017/02/personal-thoughts-about-pystons-outcome/)从根本上让模型级别的并行化和编译到小型设备这两件事变得很困难。

MXNet 的 [Gluon](https://mxnet.incubator.apache.org/api/python/gluon.html) 正在寻求一种鱼与熊掌兼得的方式，至少在某种程度上是这样。它的想法是先把基本的动态 AD 与代码跟踪结合起来得到“静态子图”，进而进行优化。可惜这样得到的是一个把迥然不同的实现和 API 混搅在一起的东西。而且这种做法也有局限：图在 MXNet 中不仅被用于核心级别的优化，也被用于高级的图调度，比如[把一个模型分到多个 GPU 上](https://mxnet.incubator.apache.org/how_to/multi_devices.html)；我们不清楚除了为那些支持动态计算的图容器额外加入新 API 之外，这些混合方案还有什么办法可以做到这件事。

## 机器学习的专属语言可能长什么样？

没有几个领域像机器学习这样对语言层面的设计有如此苛刻的要求。当然不是说这没有先例，在[形式推理与验证](https://coq.inria.fr/)和[集群计算](https://chapel-lang.org/)中的经验就证实了，新的定制的语言是非常有效的解决方案。同样，我们也希望看到，不论是创造新的还是利用现有的，为机器学习所需的数值、微分、并行及概率计算等功能而定制的语言。

机器学习语言一个公认的挑战是兼顾通用性与性能，早期的混合方案在这方面还需多加努力。我们希望将来的机器学习运行时支持任意方式的混合（静态的计算图包含在一个动态的图里，继而包含在另一个静态图里……），也更好地支持编译动态代码和部署。理想情况是用单个灵活的“图格式”（或 AST）。这个 AST 应当有一种语法可以静态地描述动态行为（比如写一个 `for` 循环）——换言之，它更像一个标准的编程语言。

*可编程语义*开启了灵活性的新层次，而且可以用类似于宏这样的功能来实现。这样的话，只要在核心系统上指定哪些代码应该有纯数据流语义，就可以实现多 GPU 训练这样的功能（与此对照，标准的祈使语义更灵活，但有不能安全优化的副作用）。它也可以实现概率编程语言所需的操作，以及 NLP 模型中通常手动实现的[向量化处理](https://www.cs.cmu.edu/~guyb/papers/Ble90.pdf)（批处理）。

和编程语言圈子一样，机器学习工程师们也应密切关注传统的自动微分（AD）领域。机器学习语言可以从[真正内置支持微分的语言设计](https://arxiv.org/pdf/1611.03416.pdf)等先驱性的工作中得到启发。这类语言中，混合运用符号化与运行时技巧（便于权衡之前提到的因素），混合使用正向和反向自动微分（可以改进速度和内存占用），以及[对 GPU 核心微分](https://mikeinnes.github.io/2017/08/24/cudanative.html)都不费吹灰之力，而且不以损失性能为代价。

机器学习研究日趋依赖更强大的类型系统、用户自定义类型和更多的扩展方法。硬编码就能支持 NVIDIA GPU 上的跨数组的美好时光已一去不返；像[稀疏机器学习](https://people.eecs.berkeley.edu/~elghaoui/Pubs/cidu2011_final.pdf)这样的前沿技术，[TPU](https://cloud.google.com/tpu/)、[Nervana](https://www.intelnervana.com/) 和 [FPGAs](https://www.forbes.com/sites/moorinsights/2017/08/28/microsoft-fpga-wins-versus-google-tpus-for-ai/#118733643904) 这样的全新硬件，[ARM 芯片](https://www.wired.co.uk/article/google-raspberry-pi-ai) 和 [iPhone 的 CoreML](https://developer.apple.com/documentation/coreml) 这样形形色色的部署目标，都要求灵活性能更上一层楼。每次新发展都[对核心 C++ 代码进行大规模重构](https://github.com/tensorflow/tensorflow/pull/5267/files)不是一个可持续的策略。

让我们想象这样一个世界：增加一个新的硬件支持或数据表示可以用高层代码轻松解决，而不必对原有系统做任何更改。当前数值计算语言[已经能轻松处理这些任务](https://arxiv.org/pdf/1604.03410.pdf)，我们期望机器学习系统能从中汲取灵感。

众所周知类型系统有安全性的优点，但当前的系统却不能适应充斥着数组的代码，因为数组的维度是有意义的（例如图像中有空间、通道和批别三种维度）。维度的区分[全靠约定](https://github.com/pytorch/pytorch/issues/1220)，置换维度的繁杂代码无法保证正确性，所以说完美支持数组的类型系统还有很大的探索空间。鉴于实践者们对交互和脚本的偏好，我们预计动态类型的趋势仍将继续，[^types]我们也希望看到更多像 [CNTK 的可选动态维度](https://cntk.ai/pythondocs/sequence.html)这样的创新。

[^types]: 不可否认，当前系统的内部已全范围覆盖从完全动态（PyTorch 和它的 ATen 后端）到异常地静态（TensorFlow 的 XLA 和 MXNet 中，所有维度在图运算之前都已知）等设计。

机器学习工程师们对传统[软件工程问题](https://papers.nips.cc/paper/5656-hidden-technical-debt-in-machine-learning-systems.pdf)——比如生产系统的维护与扩展——的兴趣日益增加。[机器学习编程模型](https://medium.com/@karpathy/software-2-0-a64152b37c35)让组件间抽象界限的区分和接口的设计更加困难，向后兼容性也可能因为重新训练一个模型就被破坏。正如普通语言要解决这些问题，机器学习语言也有希望配备相应的解决方案，虽然怎么做还是个公开的设计问题。

~~~

<div style="text-align:center">
<a href="https://xkcd.com/1838/">
<img height="350px" src="https://imgs.xkcd.com/comics/machine_learning_2x.png"/>
</a>
</div>
<div class="desc">
  软件工程 2.0？ <i>(摘自 XKCD)</i>
</div>
~~~

任何新语言不能回避的一个不利因素是要构建新的库生态系统，因为只有专为新运行时写的代码才能从中受益。举个例子，TensorFlow 开发者们必须用图语言重写[图像处理](https://www.tensorflow.org/api_guides/python/image)和[文件输入输出](https://www.tensorflow.org/api_docs/python/tf/TextLineReader)这些功能，而不是复用 Python 生态系统中已有的库，即使对 SciPy 这类投入巨大的项目也得忍痛割爱。虽说这是跨在前进路上的独木桥，但机器学习实践者们不应因此把自己孤立于广大的数值与高性能计算社区之外。理想的机器学习生态系统一定是理想的数值计算生态系统，反之亦然。社区间的通力合作能让所有人的努力事半功倍。

我们预计进展会来自几个方面。图 IR 及像 [XLA](https://www.tensorflow.org/performance/xla/)、[ONNX](https://github.com/onnx/onnx) 和 [NNVM](https://github.com/dmlc/nnvm) 等格式已变得日益复杂并可能去传统语言设计中寻求更多的灵感。[^chris] 再加上一些表层语法，它们或许就成了完备的编程语言。TensorFlow 的 XLA 开始向专用的编译栈方向发展，现在已经有 [TVM](https://tvmlang.org/)、[DLVM](http://dlvm.org/)、[myelin](https://github.com/google/sling/tree/master/myelin) 和其它一些推进中的项目。与此同时，[PyTorch JIT](https://github.com/pytorch/pytorch/tree/master/torch/csrc/jit)、[Gluon](https://mxnet.incubator.apache.org/api/python/gluon.html) 和 [Tangent](https://github.com/google/tangent) 等正努力让 Python 本身变成一个更好的建模语言，尽管它们面对的是巨大的挑战。刚才讨论过，机器学习是一个数值计算语言的问题，我们 Julia 社区认为这个观点也为探讨语言层面的问题奠定了良好的基石。我们会继续用[Knet](https://github.com/denizyuret/Knet.jl)、[Flux](https://fluxml.github.io/)、[Cassette](https://github.com/jrevels/Cassette.jl)、[CUDAnative](https://github.com/JuliaGPU/CUDAnative.jl) 和 [DataFlow.jl](https://github.com/MikeInnes/DataFlow.jl) 等项目去开拓新的疆土。


## 结论：一个关于机器学习的推断

机器学习模型已是极其通用的信息处理系统，它们创建了从未有过的高层的，更复杂的抽象；通过基本组件组合，可以实现循环、递归、高阶模型，甚至[堆栈机](https://nlp.stanford.edu/blog/hybrid-tree-sequence-neural-networks-with-spinn/)和[语言解释器](https://arxiv.org/abs/1605.06640)。机器学习是一个新的编程范式，即便它满身的数值、微分和并行标签让人觉得有些奇怪。像任何工程领域一样，现有可用的工具对将来工作的广度和质量有着不可估量的影响。

所有这些表明，机器学习系统的设计者要面对极其严峻的挑战。诚然如是，也有好消息：相同的问题也曾困扰语言研究者们数十年！如果说离彻底解决尚远，那这些问题至少已被深入地研究过了。想要发挥这个新领域的全部潜能，机器学习和编程语言社区必须联合起来。那时真正的挑战是如何把两组完全不同的专业知识整合为一体。

我们能创造一个把数值、微分、并行作为基本功能，且毋须牺牲传统的编程理念和智慧的系统吗？这将是编程语言在接下来十年里需要回答的一个基本问题。

[^greenspun]: 引申自 [Philip Greenspun](https://en.wikipedia.org/wiki/Greenspun%27s_tenth_rule)

[^tf]: 本文以 TensorFlow 为例。读者可以自行替换为其它“先定义—后计算”类型的框架，比如 CNTK 或 MXNet。

[^ast]: TensorFlow 的图本质上是一种基于数据流的抽象语法树（AST）。

[^chris]: 一个有趣的佐证是，Google Brain 正加大力度雇用编程语言专家，比如 [Chris Lattner](https://techcrunch.com/2017/08/14/swift-creator-chris-lattner-joins-google-brain-after-tesla-autopilot-stint/)。
