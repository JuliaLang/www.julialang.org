@def rss_pubdate = Date(2019, 7, 30)
@def rss = """ Julia将支持可组合的多线程并行机制 | 摩尔定律带来的免费性能提升（free lunch） free lunch 几近结束，... """
@def published = "30 July 2019"
@def title = "Julia将支持可组合的多线程并行机制"
@def author = "Jeff Bezanson (Julia Computing), Jameson Nash (Julia Computing), Kiran Pamnany (Intel)"
@def hascode = true

摩尔定律带来的[免费性能提升（free lunch）][free lunch]几近结束，
软件性能越来越依赖于利用多个处理器核心。
Julia社区一直以对计算性能的关注而出名。
为了追求性能，我们已经为多进程、分布式编程和 GPU 构建了许多功能，
但多年来，我们一直知道我们还需要一个可组合的多线程支持。
今天，我们很高兴地宣布这一方向的重要进展。
我们将发布一个全新的Julia线程接口：
一个受到[Cilk][]，[Intel Threading Building Blocks][] (TBB) 以及 [Go][]等启发的
通用任务并行（general task parallelism）机制。
任务并行现在已在 v1.3.0-alpha 版本中提供，Julia 1.3.0 的早期预览版预计将在几个月内发布。
您可以在下载页面上找到具有此功能的二进制文件，或者从源代码[主分支][master branch]构建。

在这个例子中，程序的任何部分都可以标记为并行执行，
并将启动一个“任务”在可用线程上自动运行该代码。
动态调度程序会处理所有决策和细节。
下面是一个并行代码示例，现在您可以在 Julia 中如此编写:

```julia
import Base.Threads.@spawn

function fib(n::Int)
    if n < 2
        return n
    end
    t = @spawn fib(n - 2)
    return fib(n - 1) + fetch(t)
end
```

当然，这是斐波那契序列的非常低效的经典树型递归实现。
但，它可以在任意数量的处理器核心上运行！
这一行 `t = @spawn fib(n - 2)` 启动一个计算 `fib(n - 2)` 的任务，
该任务与计算 `fib(n - 1)` 的代码并行运行。
而 `fetch(t)` 将等待任务 `t` 完成并获取其返回值。

这一并行模型有许多奇妙的特性。我们认为它有点像垃圾回收（GC）：
使用 GC，你可以自由分配对象而无需担心何时以及如何释放对象。
而使用任务并行，您可以自由生成任务（可能多达数百万个），而无需担心它们在哪运行。

这一模型非常轻量，且不用关心底层细节。
您无需显式启动和结束线程，甚至不需要知道有多少处理器或线程（尽管仍可以按需得知）。

该模型是可嵌套，可组合的：
您可以启动并行任务，这些任务调用库函数，而这些函数本身也可以启动并行任务，一切都会正常运行。
您的 CPU 不会因线程过多而饱和。
此特性对于高级语言至关重要，因为它们由库函数完成大量工作。
您只需要自由编写所需的任何代码（包括并行代码），而无需担心它调用的库是如何实现的
（目前仅适用于 Julia 代码，但将来我们计划将其扩展到 native 库（如 BLAS））。

事实上，这是此次发布令人兴奋的主要原因：
从现在开始，整个 Julia 生态系统都将能添加多核并行的能力。

\toc

## 一些历史

这一新功能最令人惊讶的方面之一是它极长的开发历史。
从非常早期（甚至从 0.1 版本之前）开始，Julia 就提供对称协程的`Task`类型，该类型用于基于事件的 I/O。
因此，我们始终在语言中具有*并发*单元（独立的执行流），只是它不是并行的（同时的执行流）。
我们需要基于线程的并行性，因此在 2014 年（大致是 0.3 版本），我们着手进行漫长的重构过程来使代码线程安全。
Yichao Yu在垃圾回收器和线程局部存储性能方面投入了一些特别令人印象深刻的工作。
作者之一（Kiran）设计了一些基础结构，用于调度多个线程和管理原子数据结构。

大约两年后，在版本 0.5 中，我们发布了具有“实验”性质的宏 `@threads for` ，
该宏可以处理在所有核心上运行的简单并行循环。
尽管这不是我们想要的最终设计，但它做了两项重要的工作：
它让 Julia 程序员可以利用多个核心，并提供测试用例来清除运行时中与线程相关的Bug。
然而，这个早期版本的 `@threads` 有一些巨大限制：
 `@threads` 循环不能嵌套：如果调用的函数递归调用`@threads`，这些内部循环将只能使用调用它们的CPU；
它还与我们的 `Task` 和 I/O 系统不兼容：您无法在线程循环内进行任何 I/O 或在 `Task` 间切换。

因此，逻辑上接下来应该将 `Task` 和线程系统合并，
并且“简单地”（此处应有笑声）允许 `Task` 在线程池上同时运行。
我们与 Arch Robison（当时在英特尔公司）进行了许多早期讨论，
并得出结论：这就是我们语言的最佳模式。
在版本 0.5（2016 年左右）之后，Kiran 开始基于深度优先调度尝试新的并行任务调度器[partr][]。
他用一些漂亮的动画幻灯片向我们所有人推销它，不过他愿意做一些工作也没什么坏处。
计划是首先将 partr 开发为独立的 C 库，以便可以自行进行测试和性能测试，
然后将其与 Julia 运行时集成。

在 Kiran 完成独立版本的 Partr 之后，
我们中的一些人（本文的作者，以及Keno Fischer和英特尔的Anton Malakhov）开始了一系列面对面的工作，
以研究如何进行集成。Julia 运行时带来了许多额外的功能，如垃圾回收和基于事件的 I/O，因此这一工作并不简单。
有点令人失望的是，搞定新系统的时间比预期的要长得多——将近两年，尽管对于一个复杂的软件项目来说这一周期并不罕见。
这篇文章的稍后部分将为好奇的人解释一些内部细节和涉及的难点，但首先让我们把它搁在一边。

## 如何使用

要在 Julia 中使用多线程，请设置环境变量：JULIA_NUM_THREADS

```bash
$ JULIA_NUM_THREADS=4 ./julia
```

[Juno IDE][] 可根据可用处理器核心数自动设置线程数，还提供用于更改线程数的图形界面，因此在该环境中不需要手动设置环境变量。

`Base` 的子模块 `Threads` 包含大多数线程特定的功能，例如查询线程数和当前线程的ID：

```julia-repl
julia> Threads.nthreads()
4

julia> Threads.threadid()
1
```

现有的 `@threads for` 仍然可用，而且现在完全支持 I/O：

```julia-repl
julia> Threads.@threads for i = 1:10
           println("i = $i on thread $(Threads.threadid())")
       end
i = 1 on thread 1
i = 7 on thread 3
i = 2 on thread 1
i = 8 on thread 3
i = 3 on thread 1
i = 9 on thread 4
i = 10 on thread 4
i = 4 on thread 2
i = 5 on thread 2
i = 6 on thread 2
```

废话少说，让我们尝试一下嵌套并行。
一个经典示例是并归排序，它将其输入分成两部分，并递归地对各部分排序。
这两部分可以独立排序，自然带来了并行的可能。
下面是代码:

```julia
import Base.Threads.@spawn

# sort the elements of `v` in place, from indices `lo` to `hi` inclusive
function psort!(v, lo::Int=1, hi::Int=length(v))
    if lo >= hi                       # 1 或 0 个元素，无需操作
        return v
    end
    if hi - lo < 100000               # 低于下限则串行运行
        sort!(view(v, lo:hi), alg = MergeSort)
        return v
    end

    mid = (lo+hi)>>>1                 # 找到中点

    half = @spawn psort!(v, lo, mid)  # 排序前半部分的任务将会与
    psort!(v, mid+1, hi)              # 当前排序后半部分的代码并行运行
                                      #
    wait(half)                        # 等待前半部分完成

    temp = v[lo:mid]                  # 用于合并的空间

    i, k, j = 1, lo, mid+1            # 合并两个已排序的子数组
    @inbounds while k < j <= hi
        if v[j] < temp[i]
            v[k] = v[j]
            j += 1
        else
            v[k] = temp[i]
            i += 1
        end
        k += 1
    end
    @inbounds while k < j
        v[k] = temp[i]
        k += 1
        i += 1
    end

    return v
end
```

这只是一个标准的并归排序实现，和 Julia `Base`库中的实现大体相同，
仅对其中一个递归调用添加了一个小小的 `@spawn`。
Julia 的 `Distributed` 标准库在相当长的一段时间内也导出了宏`@spawn`，但我们计划将其弃用，
以支持新的线程语义（尽管它仍将在 1.x 版本中提供，用于提供向前兼容性）。
这种表达并行的方式在共享内存中更有用，在任务并行 API 中，"spawn"是一个相当标准的术语（如在 Cilk 和 TBB 中就均被使用）。

`wait` 只需等待指定任务完成。代码通过修改其输入来工作，因此我们不需要任务的返回值。
与前面的 `fib` 示例中使用的 `fetch` 的唯一区别是不需要返回值。
请注意，我们在调用 Julia 的标准 `sort!` 时明确要求使用 `MergeSort`,
以确保我们进行公平地比较——默认情况下，我们使用快速排序对数字进行排序，
对于随机数据来说，这往往更快。
让我们在 `JULIA_NUM_THREADS=2` 的前提下运行代码并计时：

```julia-repl
julia> a = rand(20000000);

julia> b = copy(a); @time sort!(b, alg = MergeSort);   # 单线程
  2.589243 seconds (11 allocations: 76.294 MiB, 0.17% gc time)

julia> b = copy(a); @time sort!(b, alg = MergeSort);
  2.582697 seconds (11 allocations: 76.294 MiB, 2.25% gc time)

julia> b = copy(a); @time psort!(b);    # two threads
  1.770902 seconds (3.78 k allocations: 686.935 MiB, 4.25% gc time)

julia> b = copy(a); @time psort!(b);
  1.741141 seconds (3.78 k allocations: 686.935 MiB, 4.16% gc time)
```

虽然运行时间有些许波动，但我们看到使用两个线程的确会加速。
我们运行此代码的笔记本有四个超线程，如果我们添加第三个线程，
性能将继续提高，这尤其令人惊异:

```julia-repl
julia> b = copy(a); @time psort!(b);
  1.511860 seconds (3.77 k allocations: 686.935 MiB, 6.45% gc time)
```

考虑在三个线程上运行的这种双路分治算法会让人有点头疼，但我们认为，这有助于强调此接口的“自动”并行能力。

让我们尝试一台单线程性能稍低但 CPU 核心较多的机器:

```bash
$ for n in 1 2 4 8 16; do    JULIA_NUM_THREADS=$n ./julia psort.jl; done
  2.949212 seconds (3.58 k allocations: 686.932 MiB, 4.70% gc time)
  1.861985 seconds (3.77 k allocations: 686.935 MiB, 9.32% gc time)
  1.112285 seconds (3.78 k allocations: 686.935 MiB, 4.45% gc time)
  0.787816 seconds (3.80 k allocations: 686.935 MiB, 2.08% gc time)
  0.655762 seconds (3.79 k allocations: 686.935 MiB, 4.62% gc time)
```

`psort.jlpsort!`脚本只定义了函数`psort!`，调用它一次以避免测量编译开销，
然后运行与上面的命令相同的命令。

请注意，尽管并行代码分配的内存比标准程序*多得多*，但仍然有加速效果。
分配有两个来源：`Task` 对象和在每次调用上分配的临时 `temp` 数组。
参考排序程序在所有递归调用中重用了单个临时缓冲区。
但使用并行，重用临时数组比较困难，但仍然是可能的, 稍后将详细介绍。

## 如何迁移到并行世界

在 1.3 系列中，新线程运行时仍视为处于 beta 测试阶段。
“正式”版将出现在之后的版本中，以便有充足的时间用来确定可长期维护的 API。
如果要在此时间段内升级代码，您需要了解以下内容。

### 任务调度和同步

为了兼容性，默认情况下，代码将仍在单个线程中运行。
当使用现有原语 (`schedule`, `@async`) 启动任务时，它们将仅在启动它们的线程中运行。
同样，`Condition` 条件对象（用于在事件发生时向任务发出信号）也只能在创建它的线程中使用。
尝试在其他线程等待或通知 `Condition` 将引发错误。
独立的线程安全的条件变量 `Threads.Condition` 现已引入。
这需要是一个独立的类型，因为使用线程安全的条件变量需要获取锁。
在 Julia 中，锁与条件捆绑在一起，因此 `lock` 只能在条件本身上调用：

```julia
lock(cond::Threads.Condition)
try
    while !ready
        wait(cond)
    end
finally
    unlock(cond)
end
```

与以前的版本一样，用于保护临界区的标准锁 `ReentrantLock` 现已线程安全（以前仅用于同步任务）。
有一些其他类型的锁（`Threads.SpinLock` 和 `Threads.Mutex`）主要为内部目的而定义。
它们只用于极少数情况：(1) 只有线程需要同步，而不是任务，(2) 已知锁将只持有很短的时间。

`Threads` 模块还提供 `Semaphore`（信号量）和 `Event`（事件）类型，它们都遵循其标准定义。

### 线程局部状态

Julia 代码一般倾向于纯函数式（没有副作用或可变性），或者只使用局部可变性，
因此，在许多情况下迁移到完全线程安全的代码应该很容易。
但是，如果代码使用共享状态且希望使其线程安全，则有一些工作要做。
到目前为止，我们在 Julia 的标准库中使用了两种方法：同步(锁)和线程或任务局部状态。
锁适用于不经常访问的共享资源，或无法让每个线程都持有副本的资源。

但对于高性能代码，我们建议采用线程局部状态。
上面的 `psort!` 程序可以这样改进。以下是具体步骤：
首先，我们修改函数签名以接受预分配的缓冲区，
当调用方不提供预分配缓冲区时使用默认参数自动分配空间:

```julia
function psort!(v, lo::Int=1, hi::Int=length(v), temps=[similar(v, 0) for i = 1:Threads.nthreads()])
```

我们只需要为每个线程分配一个初始空数组。接下来，我们将修改递归调用以重用这一空间:

```julia
    half = @spawn psort!(v, lo, mid, temps)
    psort!(v, mid+1, hi, temps)
```

最后，使用为当前线程预留的数组（而不是分配一个新的）并根据需要调整其大小:

```julia
    temp = temps[Threads.threadid()]
    length(temp) < mid-lo+1 && resize!(temp, mid-lo+1)
    copyto!(temp, 1, v, lo, mid-lo+1)
```

经过这些细微的修改后，让我们测试一下程序在大规模机器上的性能:

```bash
$ for n in 1 2 4 8 16; do    JULIA_NUM_THREADS=$n ./julia psort.jl; done
  2.813555 seconds (3.08 k allocations: 153.448 MiB, 1.44% gc time)
  1.731088 seconds (3.28 k allocations: 192.195 MiB, 0.37% gc time)
  1.028344 seconds (3.30 k allocations: 221.997 MiB, 0.37% gc time)
  0.750888 seconds (3.31 k allocations: 267.298 MiB, 0.54% gc time)
  0.620054 seconds (3.38 k allocations: 298.295 MiB, 0.77% gc time)
```

### 随机数生成

对于 Julia 的默认全局随机数生成器（`rand()` 和相关函数），我们采取的策略是将它独立于特定线程。
首次使用时，每个线程将从系统熵创建一个默认 RNG 类型(当前为`MersenneTwister`)的独立随机种子实例。
然后，影响随机数状态（`rand`、`randn`、`seed!`等）的所有操作将仅对当前线程的 RNG 进行操作。
这样，随机种子和使用随机数的多个独立代码序列将按预期独立工作。

## 深入底层

与垃圾回收一样，简单的接口 (`@spawn`) 掩盖了底层的复杂性。
这里，我们将尝试总结我们面临的一些主要困难和设计决策。

### 分配和切换任务堆栈

每个 `Task` 都需要自己的执行堆栈，这与 Unix 操作系统提供的通常进程或线程堆栈不同。
Windows 具有与任务密切相关的纤程，并且 Unix 系列系统也有多个具有类似抽象的库实现。
有许多可能的方法，各有不同的权衡。
正如我们经常做的，我们尝试选择一种方法，将最大限度地提高吞吐量和可靠性。
我们有一个共享的堆栈池，由 `mmap`（在 Windows 上为 `VirtualAlloc`）分配，
默认为每个 4MiB（32 位系统上为 2MiB）。
这可能消耗相当多的虚拟内存，因此，
如果 `top` 提示你的新的多线程 Julia 代码使用了 100GiB 地址空间，请不要惊慌。
此空间的绝大多数不会消耗实际资源，
并且仅在任务需要执行深层调用链（一般不会持续很长时间）的情况下才存在。
这些堆栈比低级语言的任务系统中可能提供的要大，
但我们认为它很好地利用了 CPU 和 OS 内核高度精细的内存管理功能，
同时大大降低了堆栈溢出的可能性。

默认堆栈大小是一个编译时选项，在`src/options.h`中定义。
`Task`的构造函数还有一个未在文档提及的第二个参数，允许您指定每个任务的堆栈大小。
不建议使用它，因为很难预测程序需要多少堆栈空间，例如编译器或调用其他库。

线程只需调整其寄存器，即可模拟"return from"回到前一个任务，即完成任务切换。
在开始运行任务前，我们从本地内存池中分配一个新堆栈。
一旦任务运行完成，我们可以立即将其堆栈释放，避免过多的 GC 压力。

我们也有堆栈切换的备用实现（由`options.h`中的变量`ALWAYS_COPY_STACKS`控制）,
当任务切换发生时，通过复制实时堆栈数据来以时间换内存。
这可能与使用`cfunction`的外部代码不兼容，因此它不是默认值。

如果堆栈占用了太多的地址空间（某些平台（尤其是 Linux 和 32 位计算机）有极低的限制）,
则将使用这一实现。当然，每个实现都有针对多个平台和体系结构的代码，有时通过内联汇编进一步优化。
堆栈切换这一主题内容极为丰富，可以单独另写一篇博客。

### I/O

我们使用 libuv 实现跨平台基于事件的 I/O。
它设计为能够在多线程程序中工作，但不是专门的多线程 I/O 库，因此不支持开箱即用的多线程并发。
现在，我们使用一个全局锁保护对 libuv 结构的访问，然后允许任何线程（一次一个）运行事件循环。
当另一个线程需要事件循环线程唤醒时，它会发出异步信号。
这可能有多种原因，比如另一个线程调度新任务，
另一个线程开始垃圾回收，或另一个线程想要获取 IO 锁执行 IO。

### 跨系统线程的任务迁移

一般来说，任务可能开始在一个线程上运行，阻塞一段时间，然后在另一个线程上继续运行。
这改变了有关线程局部值何时改变的基本假设。
在内部，Julia代码*经常*使用线程局部变量，例如每次分配内存时。
我们尚未开始支持迁移所需的更改，因此现在任务必须始终在它开始运行的线程上运行
（当然，它可以在任何线程上开始运行）。
为了支持这一点,我们有一个“粘性”任务的概念，这些任务必须在给定线程上运行，
以及线程局部队列，用于运行与每个线程关联的任务。

### 休眠空闲线程

当没有足够的任务使所有线程保持忙碌时，有些线程需要休眠以避免一直使用 100% 的所有 CPU。
这是一个棘手的同步问题，因为某些线程可能正在调度新工作，而其他线程则决定休眠。

### 调度器在哪运行？

当任务阻塞时，我们需要调度器来选择另一个任务运行。
该代码使用什么堆栈运行？可以有一个专用的调度器任务，但我们认为，
如果我们允许调度器在最近阻塞的任务的上下文中运行，这将能减少开销。
这可以正常工作，但任务可以以奇怪的中间状态存在，
该状态被认为是未运行，但实际上正在运行调度器。
这意味着，我们可以将任务从调度器队列中拉出，以发现到我们根本不需要进行任务切换。

### 经典错误

在尝试使这项新功能正常工作时，我们遇到了几个异常困难的错误。
最具代表性的是一个在Windows上一个神秘挂起bug，竟然通过[反转一位][flipping a single bit]修复了。

另一个不错的例子是[异常处理属性（personality）丢失][missing exception handling personality]。
事后看来，这本来很简单，但被两个因素所困：
第一，故障模式导致内核中断我们的进程，但我们无法在调试器中拦截；
第二，故障是由一个看似不相关的改变导致的。
所有 Julia 的栈帧都有一个异常处理属性集（personality set），因此问题只能出现在任何 Julia 框架之外的运行时系统中，
这个范围很小，因为我们通常执行的是 Julia 代码。

## 展望

虽然这一里程碑令人兴奋，但还有很多工作要做。
目前的 alpha 版本引入了 `@spawn` 构造，但并没有被确定为最终设计。
以下是我们希望重点关注的一些方面，以进一步开发我们的线程功能：

* 任务切换的和 I/O 延迟的性能调优。
* 向标准库添加并行。许多常见操作（如排序和广播）现在可以在内部使用多线程。
* 考虑允许任务迁移。
* 在 Julia 级别提供更多原子操作。
* 在编译器中使用多线程。
* 提高并行循环和规约（reduction），具有更多的调度选项。
* 允许在运行时添加更多线程。
* 改进调试工具。
* 探索 API 扩展，例如取消点（cancel points）。
* 提供线程安全数据结构的标准库。
* 提供备用调度器。
* 探索与 [TAPIR][] 并行 IR 的集成（[此处][here]为一些早期工作）.


## 致谢

我们非常感谢 [Intel][] 和 [relationalAI][] 提供的资金支持，这使得开发这些新功能成为可能。

我们也感谢耐心地尝试此功能的人们，他们在开发中提交错误报告或PR，并激励我们继续前进。
如果您在使用 Julia 中的线程时遇到任何问题，请在[GitHub][]或我们的[论坛][Discourse]中告知我们!


[free lunch]: http://www.gotw.ca/publications/concurrency-ddj.htm
[Cilk]: http://supertech.csail.mit.edu/cilk/
[Intel Threading Building Blocks]: https://software.intel.com/en-us/intel-tbb/
[Go]: https://tour.golang.org/concurrency/1
[partr]: https://github.com/kpamnany/partr
[Juno IDE]: https://junolab.org/
[flipping a single bit]: https://github.com/JuliaLang/libuv/commit/26dbe5672c33fc885462c509fe2a9b36f35866fd
[missing exception handling personality]: https://github.com/JuliaLang/julia/pull/32570
[TAPIR]: http://supertech.csail.mit.edu/cilk/tapir/
[here]: https://github.com/JuliaLang/julia/pull/31086
[TBB]: https://software.intel.com/en-us/node/506304
[Intel]: https://www.intel.com/
[relationalAI]: https://relational.ai/
[GitHub]: https://github.com/JuliaLang/julia/issues
[Discourse]: https://discourse.julialang.org/
[downloads page]: /downloads/
[master branch]: https://github.com/JuliaLang/julia
