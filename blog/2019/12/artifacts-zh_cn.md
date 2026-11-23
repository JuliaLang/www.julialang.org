@def rss_pubdate = Date(2019, 12, 18)
@def rss = """为 Julia 包设计的可靠、可复现的二进制工件系统 """
@def published = "18 December 2019"
@def title = "为 Julia 包设计的可靠、可复现的二进制工件系统"
@def authors = """Elliot Saba, Stefan Karpinski, Kristoffer Carlsson"""  
@def hascode = true

在过去的几个月里，我们在持续迭代和完善一个 Julia 1.3+ 中 `Pkg` 的设计方案，它用来处理不是 Julia 包的二进制对象。这项工作当初的动机是改善用 [`BinaryBuilder.jl`](https://github.com/JuliaPackaging/BinaryBuilder.jl) 构建的二进制文件的安装体验，不过工件（artifacts）子系统更加通用，适用于所有的 Julia 包。

## Pkg 工件

工件的大致方案描述在 [`Pkg.jl#1234`](https://github.com/JuliaLang/Pkg.jl/issues/1234)，其文档已经写进了 [Pkg.jl 的最新文档](https://julialang.github.io/Pkg.jl/dev/artifacts/)。它提供了一种把数据容器与 Julia 项目和包关联在一起的便利机制。引用工件的方式是使用它的内容散列值，或者在 `Artifacts.toml` 内记载的绑定到散列值的名字。`Artifacts.toml` 的一个例子如下所示：

```TOML
[socrates]
git-tree-sha1 = "43563e7631a7eafae1f9f8d9d332e3de44ad7239"
lazy = true

    [[socrates.download]]
    url = "https://github.com/staticfloat/small_bin/raw/master/jsocrates.tar.gz"
    sha256 = "e65d2f13f2085f2c279830e863292312a72930fee5ba3c792b14c33ce5c5cc58"

    [[socrates.download]]
    url = "https://github.com/staticfloat/small_bin/raw/master/jsocrates.tar.bz2"
    sha256 = "13fc17b97be41763b02cbb80e9d048302cec3bd3d446c2ed6e8210bddcd3ac76"

[[c_simple]]
arch = "x86_64"
git-tree-sha1 = "4bdf4556050cb55b67b211d4e78009aaec378cbc"
libc = "musl"
os = "linux"

    [[c_simple.download]]
    sha256 = "411d6befd49942826ea1e59041bddf7dbb72fb871bb03165bf4e164b13ab5130"
    url = "https://github.com/JuliaBinaryWrappers/c_simple_jll.jl/releases/download/c_simple+v1.2.3+0/c_simple.v1.2.3.x86_64-linux-musl.tar.gz"

[[c_simple]]
arch = "x86_64"
git-tree-sha1 = "51264dbc770cd38aeb15f93536c29dc38c727e4c"
os = "macos"

    [[c_simple.download]]
    sha256 = "6c17d9e1dc95ba86ec7462637824afe7a25b8509cc51453f0eb86eda03ed4dc3"
    url = "https://github.com/JuliaBinaryWrappers/c_simple_jll.jl/releases/download/c_simple+v1.2.3+0/c_simple.v1.2.3.x86_64-apple-darwin14.tar.gz"

[processed_output]
git-tree-sha1 = "1c223e66f1a8e0fae1f9fcb9d3f2e3ce48a82200"
```

此 `Artifacts.toml` 文件绑定了三个工件：一个叫 `socrates`，一个叫 `c_simple`，还有一个叫 `processed_output`。对于一个工件来说唯一必需的信息就是它的 `git-tree-sha1`。因为查找工件的唯一方式是通过内容散列值，`Artifacts.toml` 的作用是提供这些工件的元数据，比如给内容散列值绑定一个人类可读的名字、提供这些工件可以从哪里下载的信息，甚至给多条散列值绑定同一个名字，然后用操作系统、libgfortran 版本之类的平台相关约束条件作为键来区分。

## 工件的类型和属性

在上述例子中，`socrates` 是有多个下载位置的、平台无关的工件的示例。 下载安装 `socrate` 时会按顺序逐个尝试这些 URL，直到有一个成功为止。`socrates` 工件的 `lazy`（惰性）标记表示它不会在所在包的 `Pkg.add()` 时刻被自动下载，而是在包第一次尝试使用它时按需下载。`BinaryBuilder.jl` 作为一个应用惰性工件的现实例子，它利用[大量的惰性工件](https://github.com/JuliaPackaging/BinaryBuilder.jl/blob/85cc4e26ff2442fc71912e68767122346f5610d9/Artifacts.toml)来对应大量的语言和平台系统，会按需下载类似 `RustToolchain-aarch64-linux-musl.v1.18.3.x86_64-linux-gnu.squashfs` 这样的工件。

`c_simple` 是一个平台相关的工件示例。每个 `c_simple` 条目都含有一些键，让调用工件的包能根据宿主机器的细节选择合适的下载文件。注意，每个工件都有 `git-tree-sha1`，每个工件的下载条目都有 `sha256`。这是为了在解压缩之前确保下载到的 tar 压缩包是安全的，以及在解压缩之后确保目录树整体的散列值相同[^1]。

`processed_output` 工件不包含 `download` 一节，因此无法被安装。这样的工件可能是此前运行的代码的产物：代码在项目内生成新的工件，并把产物的散列值与一个名字绑定。这样不仅可以很容易地引用这个工件，而且可以确保工件之后不会被 Pkg 的垃圾回收器收集。

## 使用工件

工件可以通过 `Pkg.Artifacts` 命名空间暴露的方便的 API 来操作。举个例子，假设我们在写一个需要加载[鸢尾花（iris）机器学习数据集](https://archive.ics.uci.edu/ml/datasets/iris)的包，尽管我们可以在 build 步骤时把数据集下载到包目录里，很多包现在也是这么干的，但这有一些明显的缺点。首先，这么做会修改包目录，让包的安装过程带有状态，而这是我们希望避免的。未来我们想达到的目标是包安装后完全只读，不能修改自身。其次，下载到的数据没有在不同版本的包之间共享。如果我们为多个项目装了三个不同版本的包，那么即使这些版本的数据在二进制层面上一模一样，我们也需要存储三份副本。不仅如此，每次升级或者降级包的时候，除非我们做了一些机智（但容易玩脱）的处理，这些数据必须重新下载。有了工件的支持后，我们只需要检查 `iris` 工件在硬盘上是否存在，当不存在时再下载安装，然后可以把下载到的结果绑定到 `Artifacts.toml` 文件里：

```julia
using Pkg.Artifacts

# 这是我们要操作的 Artifacts.toml 文件的路径
artifacts_toml = joinpath(@__DIR__, "Artifacts.toml")

# 查询 `Artifacts.toml` 文件获得名称“iris”绑定的散列值
# （如果不存在这个绑定，返回 `nothing`）
iris_hash = artifact_hash("iris", artifacts_toml)

# 如果名称没有找到，或者它绑定的散列值对应的工件不存在，就创建它！
if iris_hash == nothing || !artifact_exists(iris_hash)
    # 一旦创建工件完成，create_artifact() 返回工件目录的内容散列值
    iris_hash = create_artifact() do artifact_dir
        # 我们简单地通过往新工件目录里下载几个文件来创建工件
        iris_url_base = "https://archive.ics.uci.edu/ml/machine-learning-databases/iris"
        download("$(iris_url_base)/iris.data", joinpath(artifact_dir, "iris.csv"))
        download("$(iris_url_base)/bezdekIris.data", joinpath(artifact_dir, "bezdekIris.csv"))
        download("$(iris_url_base)/iris.names", joinpath(artifact_dir, "iris.names"))
    end

    # 现在在 `Artifacts.toml` 文件里绑定这个散列值。`force = true` 意为如果它已经存在，
    # 就用新的内容散列值覆盖它。除非源文件变化，否则我们认为内容散列值不会变化，
    # 因此这应该不会导致不必要的版本控制变动。
    bind_artifact!(artifacts_toml, "iris", iris_hash)
end

# 获取 iris 数据集的路径，要么是新建的，要么是之前生成的。
# 这应该是类似 `~/.julia/artifacts/dbd04e28be047a54fbe9bf67e934be5b5e0d357a` 的东西
iris_dataset_path = artifact_path(iris_hash)
```

对于使用之前绑定过的工件这一特殊场景，我们有简写记法 `artifact"名称"`，它会自动在当前包里的 `Artifacts.toml` 中用名称来搜索指定的工件，如果没有安装则现场安装，然后返回这个工件的路径。

## 工件的生命周期

所有工件都会安装到全局 Julia 包仓库的 `artifacts` 目录内，通常位于 `~/.julia/artifacts` 内，以内容散列值为键。虽然工件设计为兼容 Julia 的多仓库层级系统，并为想要使用特定本地版本的库的系统管理员提供了一种[覆写工件位置的机制](https://julialang.github.io/Pkg.jl/dev/artifacts/#Overriding-artifact-locations-1)，但通常来说我们发现把二进制工件安装到像这样的由用户拥有的单一位置，对普通用户来说很合适。这些工件安装后会一直留在硬盘里，直到 `Pkg.gc()` 清理掉至少一个月没有用过的包和工件。当某个版本号/内容散列值没有被任何硬盘上的 `Manifest.toml` 或 `Artifacts.toml` 引用时，垃圾回收器认为其对应的包/工件是未使用的。垃圾回收器会遍历每个被 Julia 加载过的 `Manifest.toml` 和 `Artifacts.toml` 文件，然后把所有可达的工件和包标记为使用了的。之后，所有未被标记的工件和包版本会被标记为未使用的，持续一个月被记为未使用的话就会被自动删除。

一个月的延时可以通过设置 `collect_delay` 关键字参数来调小，比如 `Pkg.gc(;collect_delay=Hour(1))`（记得要导入 [`Dates`](https://docs.julialang.org/en/v1/stdlib/Dates/) 标准库来获得 `Hour` 之类的时间函数！）可以移除所有一小时以上未使用的工件。很长的宽限期应该能消除大部分用户在更改包版本或者切换项目后重新安装包时需要重新下载同一个大二进制包的困惑。

# BinaryBuilder.jl

你也许会猜到 `BinaryBuilder.jl` 知道如何生成 `Artifacts.toml` 文件（[示例](https://github.com/JuliaBinaryWrappers/c_simple_jll.jl/blob/master/Artifacts.toml)），但这不是唯一的变化。我们对当前这种需要手动表达包内 `deps/build.jl` 里所有依赖关系的“最佳实践”已经很厌烦了。迄今为止，还没有一个简单明了的方法来递归地安装二进制依赖，用户不得不采用类似把所有二进制依赖都嵌入 `build.jl` 的策略。虽然这样管用，但实在是太笨重了。好在我们已经有了一个能够处理递归依赖的包管理器，然后就能搞出一个简单的解决方案：让 `BinaryBuilder.jl` 生成一个用来包装产物的 Julia 包，作为输出的一部分。这样我们就可以表达二进制依赖的有向无环图，也有了让处理库和可执行文件更简单的 Julia 样板包装代码。我们把这些自动生成的包叫做 JLL 包。

## Julia 库 (JLL) 包

BinaryBuilder 自动生成的包就是普通的 Julia 包，值得注意的是它含有 `Artifacts.toml` 文件，可以下载之前由 `BinaryBuilder` 构建并上传到代码仓库 GitHub release 的各种二进制工件的合适版本。这些自动生成的包称为“Julia 库包”，简称 JLL。BinaryBuilder 会尝试把所有包上传到 `JuliaBinaryWrappers/$(包名)_jll.jl`，当然这是可配置的。一个示例包[在这里](https://github.com/JuliaBinaryWrappers/c_simple_jll.jl)，最有趣的部分就是这些自动生成的包所暴露的新 API。

JLL 包里面的代码绑定是根据生成这个包的 `build_tarballs.jl` 文件里的 `Products`（产物）生成的。为了方便演示，假设有如下的产物定义：

```julia
products = [
    FileProduct("src/data.txt", :data_txt),
    LibraryProduct("libdataproc", :libdataproc),
    ExecutableProduct("mungify", :mungify_exe)
]
```

有了这些产物的定义，JLL包就会导出 `data_txt`、`libdataproc` 和 `mungify_exe` 这三个符号。`FileProduct` 导出的变量是字符串，指向这个文件在硬盘上的位置；`LibraryProduct` 变量是对应这个链接库的 `SONAME` 的字符串（链接库会在这个包所在模块的 `__init__()` 方法里被 `dlopen()` 加载，所以可以像平常那样 `ccall()` 调用）；`ExecutableProduct` 变量导出的是函数，调用它就会设置合适的环境变量，比如 `PATH` 和 `LD_LIBRARY_PATH`，这对于嵌套依赖来说很有必要，比如 `ffmpeg` 在视频编码时调用 `x264` 程序。举个例子：

```julia
using c_simple_jll

# 对于文件产物，可以直接访问它的文件位置：
data_lines = open(data_txt, "r") do io
    readlines(io)
end

# 对于库产物，可以直接在 `ccall()` 调用里使用导出的变量：
num_chars = ccall((libdataproc, :count_characters), Cint, (Cstring, Cint), data_lines[1], length(data_lines[1]))

# 对于可执行文件产物，导出的是一个可以调用的函数：
mungify_exe() do mungify_exe_path
    run(`$mungify_exe_path $num_chars`)
end
```

这个新系统的巨大优势之一就是可以完美运行那些必须链接到其他依赖项里的库的程序，以及调用其他依赖项里的程序的程序。这是因为包装它们的 JLL 包自动设置了合适的环境变量。

## 对 `build_tarballs.jl` 的变更

对于那些二进制构建老手来说，构建二进制的过程并没有多少变化。第一个变化就是清理掉了一些比较尴尬的产物 API：之前你需要提供闭包来柯里化一个 `prefix` 给你的产物，但现在不用了。明确地说，之前你可能会这么写：

```julia
products(prefix) = [
    LibraryProduct(prefix, "libglib", :libglib)
]
```

而现在你只需要写：
```julia
products = [
    LibraryProduct("libglib", :libglib)
]
```

第二个变化就是 `build.jl` 文件不直接用链接来引用依赖项了，改为使用要安装的 JLL 包的名字（或者再加上版本号），然后它（以及所有递归依赖项）就会被安装，然后符号链接到 `${prefix}`，就和之前一样。明确地说，之前你可能会这么写：

```julia
dependencies = [
    "https://github.com/JuliaBinaryWrappers/c_simple_jll.jl/releases/download/c_simple%2Bv1.2.3%2B7/build_c_simple.v1.2.3.jl",
]
```

而现在你只需要写：
```julia
dependencies = [
    "c_simple_jll",
]
```

如果你想指定某个二进制依赖的具体版本号，可以提供一个完整的 [`PackageSpec`](https://julialang.github.io/Pkg.jl/dev/api/#Pkg.PackageSpec)，如下所示：

```julia
dependencies = [
    Pkg.Types.PackageSpec(;name="c_simple_jll", version=v"1.2.3"),
]
```

因为 JLL 包会像其他公共包一样注册，所以安装这些构建依赖项的过程很简单：查询注册表，克隆最新版本的 JLL 包，检查它的 `Artifacts.toml` 文件，然后把合适的工件解压到构建前缀（prefix）目录。更棒的是，这些构建依赖项会被自动记录为生成的新 JLL 包的依赖项。

## Yggdrasil，构建清单的集合

之前，我们鼓励每个用户创建自己的“构建仓库”，让 Travis CI 来构建各种依赖项的二进制文件。这让设置过程变得比我们理想中的要繁琐，并且人们也很难搞清楚到底有没有人给某个特定依赖做了构建清单（recipe）。为了解决这两个问题，我们现在有了一个社区的构建树[^2]，位于 [`JuliaPackaging/Yggdrasil`](https://github.com/JuliaPackaging/Yggdrasil)。`BinaryBuilder.jl` 向导的使用者通常会给 `Yggdrasil` 提交一个拉取请求，很多已有的构建清单也可以在里面找到。

# 更新你的包

要更新你的包以使用这些新功能，首先用最新版本的 `BinaryBuilder` 来构建，然后把自动生成的 JLL 包作为依赖加到你的项目和包里，使用新 API 来配合 `ccall()` 和 `run()` 来运行二进制代码，最后就可以愉快地删掉你的 `deps/build.jl` 文件了。全局可变状态都被干掉了。

## 不仅仅是 JLL 包

JLL 包除了本职工作之外能做到更多的事，来看一个 [`Gtk.jl` 里的例子](https://github.com/staticfloat/Gtk.jl/blob/e500dcadaa8bf3571d27b0ac7cd92ef00febcb1f/src/Gtk.jl#L82-L111)：

```julia
mutable_artifacts_toml = joinpath(dirname(@__DIR__), "MutableArtifacts.toml")
loaders_cache_name = "gdk-pixbuf-loaders-cache"
loaders_cache_hash = artifact_hash(loaders_cache_name, mutable_artifacts_toml)
if loaders_cache_hash === nothing
    # 运行 gdk-pixbuf-query-loaders，捕获输出
    loader_cache_contents = gdk_pixbuf_query_loaders() do gpql
        withenv("GDK_PIXBUF_MODULEDIR" => gdk_pixbuf_loaders_dir) do
            return String(read(`$gpql`))
        end
    end

    # 把缓存写入新工件文件
    loaders_cache_hash = create_artifact() do art_dir
        open(joinpath(art_dir, "loaders.cache"), "w") do io
            write(io, loader_cache_contents)
        end
    end
    bind_artifact!(mutable_artifacts_toml,
        loaders_cache_name,
        loaders_cache_hash;
        force=true
    )
end

# 将 gdk 指向我们缓存好的加载器
ENV["GDK_PIXBUF_MODULE_FILE"] = joinpath(artifact_path(loaders_cache_hash), "loaders.cache")
ENV["GDK_PIXBUF_MODULEDIR"] = gdk_pixbuf_loaders_dir
```

在 `Gtk` 的 `__init__()` 方法内，它会检查是否已经有生成了的 `gdk-pixbuf` 的本地缓存。这个缓存是特定于机器的，必须在模块第一次运行的时候生成。要做到这件事，需要调用一个来自 `gdk_pixbuf_jll` 包里的二进制程序，这通过使用 JLL 包导出的 `gdk_pixbuf_query_loaders` 实现。我们可以把运行结果写入新的工件并将其和 `MutableArtifacts.toml` 文件（一个任意取名的被 `.gitignore` 忽略的文件）绑定，从而动态把二进制对象缓存到与包的其他部分隔离的位置。然后，这个位置会通过环境变量告知 Gtk。我们希望未来的 Pkg 发行版本将要引入的[明确生命周期的缓存](https://github.com/JuliaLang/Pkg.jl/issues/796#issuecomment-523154714)能进一步改善这个体验。

# 可复现性至关重要

总而言之，我们希望这些新的能力能帮助你写出更多可靠的 Julia 包。该系统工作在优秀的 Julia 包管理系统之上，受益于清单（manifest）带来的可复现性和包解析器带来的兼容性检查能力。这意味着如果你过了六个月之后再回来看一个项目，将其实例化（instantiate）不仅能安装和之前一样的 Julia 源代码，而且能原封不动地获取到当初它使用的链接库版本。这是朝着真正地控制承载我们的应用与系统的整个计算平台的目标迈出的重大一步，我们期待着你作为社区的一员，基于这些令人激动的能力构建出令人惊叹的项目。

---

[^1]: 译者注：计算目录树散列值的方式由 `Pkg.GitTools.tree_hash()` 方法实现，该方法目前依赖一些 POSIX 系统调用来获取文件系统权限，在 Windows 操作系统上无法正确计算散列值，因此 Windows 平台下并不会校验 `git-tree-sha1`，但仍然会校验 tar 压缩包的散列值。

[^2]: 译者注：Yggdrasil 即北欧神话中的世界之树。
