@def rss_pubdate = Date(2017, 12, 25)
@def rss_description = """ 機器學習以及程式語言(Traditional Chinese) | > 任何足夠複雜的機器學習系統都包含一個特別設置、不符規範、充滿 bug 又緩慢實作的程式語言半成品。^greenspun ... """
@def published = "25 December 2017"
@def title = "機器學習以及程式語言(Traditional Chinese)"
@def authors = "By Mike Innes (JuliaHub), David Barber (UCL), Tim Besard (UGent), James Bradbury (Salesforce Research), Valentin Churavy (MIT), Simon Danisch (MIT), Alan Edelman (MIT), Stefan Karpinski (JuliaHub), Jon Malmaud (MIT), Jarrett Revels (MIT), Viral Shah (JuliaHub), Pontus Stenetorp (UCL) and Deniz Yuret (Koç University)"
@def hascode = true

> 任何足夠複雜的機器學習系統都包含一個特別設置、不符規範、充滿 bug 又緩慢實作的程式語言半成品。[^greenspun]


作為一個設計程式語言（PL）的人，我們抱持莫大的興趣看著機器學習（ML）迅速竄升 - 而且有了它，人們用來建立更複雜的 ML 模型與框架。極致（State-of-the-art）的模型正不斷增加，有了程式的構造元素像是迴圈及遞迴，這為我們的建造工具帶來了很多有趣的議題 - 那也就是，程式語言。

然而機器學習還沒有一個可靠的語言，許多人正在努力有效地創造隱藏在 Python API 底下的新語言（像是 TensorFlow），也有其他則是再利用 Python 當作一個建模語言（像是 PyTorch）。於是我們想問 —— 一個為機器學習量身定做的新語言是否有其必要的？如果是，為什麼？還有更重要的是，一個理想中未來的機器學習語言會是長什麼樣子？

\toc

## 兒童暗語（Pig Latin），及其他隱藏語言

> 譯者註：Pig Latin 是指是在英語上加上一點規則使發音改變的暗語。由在德國的英國戰俘發明來瞞混德軍守衛的，多半被兒童用來瞞著大人秘密溝通，有時則只是說著好玩。

TensorFlow (TF) 家族[^tf][儼然成為程式語言](https://dl.acm.org/citation.cfm?doid=3088525.3088527)，儘管有些限制。這對那些用Python 來寫 TF 的人來說會有點震驚。不過，想想 TF 需要你用 Python 語法來[建構表達式](https://www.tensorflow.org/programmers_guide/graphs)，並且在他的內部語言運算求值。


事實上，你可以用任何語言寫出 TensorFlow 的“惰性(lazy)”風格。參考底下的 JavaScript 程式，用這種風格實作了簡單的加法：

```
function add(a,b) {
  return `${a}+${b}`;
}
x = 1; y = 2
z = add('x', 'y') // 'x+y'
eval(z) // 3
x = 4
eval(z) // 6
```

在這邊我們用了 *metaprogramming* —— 用程式碼產生程式碼。在這種情況下模板語言與目標語言都是相同的(JavaScript)，但他們也可以是不同的（就像是 C 的前置處理器(preprocessor) 對應到 C），或者我們也可以用一個資料結構（一個語法樹([AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree))）來代替字串 —— 原則是相同的。在 TensorFlow 中，Python 作為一個模板語言用來編寫 TF 的 graph-based laguage[^ast]。如果你不相信，思考看看 TensorFlow 的 graph 甚至支援像是[變數作用域](https://www.tensorflow.org/programmers_guide/variables)跟[控制流程](https://www.tensorflow.org/api_docs/python/tf/cond)的構造元素 —— 而不是利用 Python 本身的語法，你正在透過 API 操作這些構造元素。


TensorFlow 以及其他相似的工具表示他們只是套件而已，但是他們是非常不尋常的一類，大多數的套件只提供一個簡單的函數及資料結構的集合而不是整個程式系統以及 runtime。
為什麼會需要這麼一個複雜的方式？

## 為什麼要創造新語言？

這個理由的核心是非常的簡單的：機器學習研究員有著非常高的計算需求，而簡化建模語言讓他們比較容易加入對不同領域的優化以及功能。訓練模型需要極好的硬體支援、好的數值系統、較低的直譯器 overhead 以及許多類型的平行。而對於像是 Python 這樣的一個通用型程式語言很難去提供這樣的功能，但 TensorFlow 就可以無縫地處理這些需求。

儘管這樣還是有個障礙，這些令人印象深刻的優化建立在簡化的假設上面(ML 模型不會有遞迴或是需要特別計算梯度, 對吧？)，而這些假設讓他比較容易去加入優化或是部署到小裝置上面。不幸的是，對於工程師來說模型得複雜度越來越高，而研究員又喜歡去違反這些假設。現在的模型需要條件分支（OK，很簡單可以修改）、重複的迴圈（不簡單但仍可能），或甚至[遞迴整個樹](https://arxiv.org/pdf/1503.00075.pdf)（理論上不可能）。在很多機器學習的領域，包含[神經網路](https://blog.keras.io/the-future-of-deep-learning.html)和[機率性程式設計](https://eng.uber.com/pyro/)，模型變得越來越像程式，包括一類會去推論*其他*程式的程式（也就是[程式產生器](https://arxiv.org/pdf/1705.03633.pdf)和[直譯器](https://arxiv.org/abs/1605.06640)），以及不可微分的部分像是蒙地卡羅樹搜尋。這是個巨大的挑戰，來建構一個 runtime 具有完全的彈性同時達成最佳性能，然而不斷增加地多數強大的模型，以及不斷突破的結果需要兩者。

~~~

<img src="/assets/images/sentiment-treebank.png"/>
<div class="desc">
使用 ML 在複雜的樹狀結構資料上（像是 <a href="https://nlp.stanford.edu/sentiment/treebank.html">Stanford Sentiment Treebank</a>）需要可微分的遞迴演算法。
</div>
~~~

這種作法的另一個實際缺點，至少是目前的典型，是需要上面討論的這種 metaprogramming。建造並執行樹會施加可觀的重擔在程式設計師以及編譯器上。因為現在程式有兩個執行期，他變得非常難以理解，每個都有各自語言的語意，而像是逐步除錯就變得更加困難。這個問題可以透過創造一個有句法結構的語言給新的 runtime， 但這件事情不亞於創造一個全新完整的程式語言。當我們已經有一個受歡迎的數值語言，這件事會是值得的嗎？

## 我們可以只用 Python 嗎？

當 ML 模型開始需要一個程式語言的完整能力， Chainer 以及其他開闢了一種 "[define-by-run](https://arxiv.org/pdf/1701.03980.pdf)" 的新方式，而在其中一個 Python 程式本身就是一個模型，透過執行期間的自動微分來計算導數。從一個可用性的觀點來看這是非常棒的：如果你想要一個模型來處理樹，單純寫下來就好，然後看 AD 變魔法！ 感覺上這樣的差別是[毋庸置疑的](https://twitter.com/karpathy/status/868178954032513024?lang=en)，畢竟能有個輕鬆的方式去玩轉新想法對研究來說是無價的。

然而，要讓 Python 達到 ML 的沈重計算需求是超乎你想像的困難。重複不斷的最佳化是個[巨大的工作量](https://www.youtube.com/watch?v=DBVLcgq2Eg0)，對於一個高效能的程式語言卻可以很輕鬆的達到，然而在 PL 的墓園中充斥著[漂亮的評測](https://arstechnica.com/information-technology/2009/03/google-launches-project-to-boost-python-performance-by-5x/)卻[未能成功](https://blog.pyston.org/2017/01/31/pyston-0-6-1-released-and-future-plans/)讓 Python 變快的專案。[Python 的語意](http://blog.kevmod.com/2017/02/personal-thoughts-about-pystons-outcome/)讓他從本質上就很難去提供模型等級的平行化或是將模型編譯給小型裝置使用。

MXNet 的 [Gluon](https://mxnet.incubator.apache.org/api/python/gluon.html) 就是在努力找到一個方式對兩邊都最好，至少到一定程度上。這個想法是透過結合基本的動態自動微分及程式碼追蹤方式，這個方式會製造可優化的"static sub-graphs"。不幸的是，這是某種完全不同的實做以及 API 的混合體。他也同樣有侷限性。MXNet 使用他的 graph 不只在核心層級的優化還有高階的 graph 排程，像是[將一個模型分散到數個 GPU 上](https://mxnet.incubator.apache.org/how_to/multi_devices.html)。這個混合體要如何處理這些並不清楚，除了加入其他新的 API 讓 graph 容器可以被運算節點動態計算。

## 那量身訂製的 ML 語言長什麼樣子？

除了 ML 外，還有其他領域也碰到需要語言層級的設計問題，但這並非是史無前例的。在像是[形式化推論及驗證](https://coq.inria.fr/)或是[叢集運算](https://chapel-lang.org/)的領域上，新量身訂做的語言已經證實了是有效的解決方案。同樣的，我們期望看到一個新的或是現存的語言對 ML 的數值系統，可微分，可平行且甚至是機率計算的需求做客製化。

對於 ML 語言，一個明顯的挑戰是同時達到通用性以及高效能，而提早混合的方式將會需要更大量的開發工作。我們希望未來的 ML runtimes 將會需要支援隨心所欲的混合各種方法(靜態的 computational graph 中嵌入動態的當中又嵌入靜態…）以及在部屬環境讓編譯動態程式碼做的更好。理想上，只會剩下單一種彈性的"graph format"（或是 AST)。這個 AST 需要有能夠靜態描述動態行為的語法（比如：一個 `for` loop) ― 換句話說，他應該看起來更像是個標準的程式語言。

*可程式化語意*將會開啟彈性的新階段， 而且可以提供一個類似 macros 的功能。 這將會允許類似多 GPU　訓練功能可以被建立在核心系統上，並且指定純資料流語意的程式碼（相對的是標準命令式語意，雖然較為彈性但是容易有負作用，對於優化來說較為不安全)。他同樣可以用來操作 probailistic programming ，或是自然語言處理模型常手動實作的[向量化](https://www.cs.cmu.edu/~guyb/papers/Ble90.pdf)(批量處理）傳遞。

同樣的在 PL 社群裡， ML 工程師應該要花更多時間注意傳統的自動微分（AD）社群。 ML 語言可以從頂尖的程式語言設計上得到[支援微分為真的第一公民（first-class）](https://arxiv.org/pdf/1611.03416.pdf)的靈感。這樣的語言可以簡單地混合符號和 runtime 技術（這可以幫忙以上提到的取捨）、混合前向及反向模式的 AD （以增進效能及記憶體使用），以及[區別不同的 GPU kernels](https://mikeinnes.github.io/2017/08/24/cudanative.html) ― 以上都沒有任何效能流失。

ML 研究將會不斷地需要更多強大的型別系統，使用者定義型別及更多延伸意義。滿足於 NVIDIA GPUs 上寫死的 strided array 的日子已經過去了；尖端技術相關的[稀疏機器學習](https://people.eecs.berkeley.edu/~elghaoui/Pubs/cidu2011_final.pdf)，新硬體像是 [TPU](https://cloud.google.com/tpu/)、[Nervana](https://www.intelnervana.com/) 和 [FPGA](https://www.forbes.com/sites/moorinsights/2017/08/28/microsoft-fpga-wins-versus-google-tpus-for-ai/#53b33c373904)，以及多樣的部署目標像是 [ARM 晶片](https://www.wired.co.uk/article/google-raspberry-pi-ai)或是 [iPhone 的 CoreML 晶片](https://developer.apple.com/documentation/coreml)都渴望更高層級的彈性。為每個新的開發項目[大規模重構 C++ 的核心程式碼](https://github.com/tensorflow/tensorflow/pull/5267/files)是不會有幫助的。

想像一個世界，在一個加入新硬體資源(或是新的資料表示法)可以簡單地被使用者透過高階語言達成，不需要改變原本的系統。這邊我們期望 ML 系統可以從現存已經可以輕鬆[處理這些問題](https://arxiv.org/pdf/1604.03410.pdf)的數值計算語言借鏡。

型別系統也可以有安全性好處，但目前的不適合在重度使用陣列的程式碼，而其中陣列的維度是有意義的（舉例來說，影像中的空間維度 vs RGB 維度 vs 批次維度）。這些差別只被視為[純粹的使用慣例](https://github.com/pytorch/pytorch/issues/1220)，粗魯的維度排列程式碼並沒有去避免錯誤，給關注陣列的型別系統留下很大的空間。我們期待動態型別的趨勢繼續[^types]，主要是因為從業人員偏好互動性以及撰寫腳本，但希望看到更多創新像是 [CNTK 的選擇性動態維度](https://cntk.ai/pythondocs/sequence.html)。

[^types]: 雖然我們知道現存的系統內部將整個系統從完全的動態（PyTorch 以及他的 ATen 後端）延伸到極度的靜態（在 TensorFlow 的 XLA 及 MXNet 中，在運算 graph 之前所有維度都是已知的）

ML 工程師對傳統[軟體工程的問題](https://papers.nips.cc/paper/5656-hidden-technical-debt-in-machine-learning-systems.pdf)(像是維護性以及產品系統的擴展性)的興趣正在提升。 [ML 程式模型](https://medium.com/@karpathy/software-2-0-a64152b37c35)讓他很難去創造抽象化以及元件之間的界面，而重新訓練模型可能輕易的打破向後相容性。 ML 語言可能可以整合正常語言對這些問題的解法，不過這依然是個設計上的開放問題。

~~~
<div style="text-align:center">
<a href="https://xkcd.com/1838/">
<img height="350px" src="https://imgs.xkcd.com/comics/machine_learning_2x.png"/>
</a>
</div>
<div class="desc">
  軟體工程 2.0? <i>(自 XKCD)</i>
</div>
~~~

任何的新語言的缺點就是需要一個新的套件生態系統，因為只有為新 runtime 寫的程式會受惠於新語言。舉例來說，TensorFlow 開發者需要在 graph language 中為了像是[影像處理](https://www.tensorflow.org/api_guides/python/image)以及[檔案讀寫](https://www.tensorflow.org/api_docs/python/tf/TextLineReader)這類事情重寫函式庫，而不是去再利用 Python 的生態，不考慮類似 SciPy 專案背後巨大的努力。這可能是前進的唯一道路，但是 ML 的從業者不應該跟廣大的數值運算跟高效能運算（HPC）社群分離。一個理想的 ML 生態系是一個理想的數值運算生態系，反之亦然，並且與這些社群攜手合作將會讓大家的努力成果有加成效應。

我們期待看到這些開發者們從各種觀點而來。 Graph 的 IR 以及格式（像是 [XLA](https://www.tensorflow.org/performance/xla/), [ONNX](https://github.com/onnx/onnx) 以及 [NNVM](https://github.com/dmlc/nnvm)）的發展變得更加的複雜且將很可能會從傳統語言設計[^chris]上借鏡更多，也許甚至是加入表面的語法變成一個完整的程式語言。 TensorFlow 的 XLA 已經開始朝向一個特殊目的的編譯器堆包含 [TVM](https://tvmlang.org/), [DLVM](http://dlvm.org/), [myelin](https://github.com/google/sling/tree/master/myelin) 以及其他的進行中的專案。 同時間，像是 [PyTorch JIT](https://github.com/pytorch/pytorch/tree/master/torch/csrc/jit), [Gluon](https://mxnet.incubator.apache.org/api/python/gluon.html) 以及 [Tangent](https://github.com/google/tangent) 的專案正在努力讓 Python 本身變成一個更好的建模語言，儘管有這些巨大的挑戰。我們已經討論過 ML 是一個數值程式語言問題，所以對 Julia 社群的我們來說感覺這是一個絕佳的素材讓我們來實驗這些語言層級的問題，並且會繼續在像是 [Knet](https://github.com/denizyuret/Knet.jl), [Flux](https://fluxml.github.io/), [Cassette](https://github.com/jrevels/Cassette.jl), [CUDAnative](https://github.com/JuliaGPU/CUDAnative.jl), [DataFlow.jl](https://github.com/MikeInnes/DataFlow.jl),…… 等這些專案中挑戰極限。


## 結論：An Inference about Machine Learning

機器學習模型已經成為了極度廣義的資訊處理系統，他建構了高階而更為複雜的抽象；重複、遞迴、高維模型，甚至 [stack machines](https://nlp.stanford.edu/blog/hybrid-tree-sequence-neural-networks-with-spinn/) 和[語言直譯器](https://arxiv.org/abs/1605.06640)，所有的實作都是這些基本元件的組合。ML 是一個新的程式典範，雖然比較奇怪的是他是重度數值的、微分的跟平行化的。就如同任何工程領域，可用的工具會深深地影響著未來工作的眼界及品質。

所有的這些暗示了 ML 系統的設計師有巨大的挑戰在他們面前。但是雖然這些都是千真萬確，還是有好消息的： 這些同樣的問題，如果還沒被解決，已經被語言學家在過去數十年間深入地探索過！要將這個新領域達到他的真正潛力，機器學習跟程式語言社群需要結合他們的力量，而真正的挑戰是要結合這兩群迥異領域的專家們。

我們能不能建立一個把數值、微分、以及平行當作是首要目標的系統，且這個系統不犧牲掉傳統程式語言的想法以及智慧？這是一個在接來十年程式語言需要去回答的更根本之問題。

[^greenspun]: 出自 [Philip Greenspun](https://en.wikipedia.org/wiki/Greenspun%27s_tenth_rule)
[^tf]: 在這邊我們使用 TensorFlow 當作例子, 但也可以用其他"執行前定義(define-before-run)"的框架替換，像是 CNTK 還有 MXNet。

[^ast]: TensorFlow 的 graph 實際上是一個基於資料流的語法樹（AST）。

[^chris]: Google Brain 正在增加僱用像是[Chris Lattner](https://techcrunch.com/2017/08/14/swift-creator-chris-lattner-joins-google-brain-after-tesla-autopilot-stint/)的程式語言專家，在這時間點上是個很有趣的發展
