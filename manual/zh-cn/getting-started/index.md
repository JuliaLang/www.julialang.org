---
layout: manual
title:  Getting Started
---
<cn>
---
layout: manual
title:  Getting Started
---
</cn>
The latest version of Julia can be downloaded and installed by following the instructions on the [main GitHub page](https://github.com/JuliaLang/julia#readme).
The easiest way to learn and experiment with Julia is by starting an interactive session (also known as a read-eval-print loop or "repl"):
<cn>
最新的Julia版本可以通过[main GitHub page](https://github.com/JuliaLang/julia#readme)下载安装
打开一个交互式的Julia解释器(或者叫read-eval-print loop or "repl")是学习和体验Julia最简单的方法。
</cn>

    $ julia
                   _
       _       _ _(_)_     |
      (_)     | (_) (_)    |  A fresh approach to technical computing.
       _ _   _| |_  __ _   |
      | | | | | | |/ _` |  |  Version 0 (pre-release)
      | | |_| | | | (_| |  |  Commit 61847c5aa7 (2011-08-20 06:11:31)*
     _/ |\__'_|_|_|\__'_|  |
    |__/                   |

    julia> 1 + 2
    3

    julia> ans
    3

    julia> load("file.jl")

<cn>

    $ julia
                   _
       _       _ _(_)_     |
      (_)     | (_) (_)    |  A fresh approach to technical computing.
       _ _   _| |_  __ _   |
      | | | | | | |/ _` |  |  Version 0 (pre-release)
      | | |_| | | | (_| |  |  Commit 61847c5aa7 (2011-08-20 06:11:31)*
     _/ |\__'_|_|_|\__'_|  |
    |__/                   |

    julia> 1 + 2
    3

    julia> ans
    3

    julia> load("file.jl")

</cn>
To exit the interactive session, type `^D` — the control key together with the `d` key.
When run in interactive mode, `julia` displays a banner and prompts the user for input.
Once the user has entered a complete expression, such as `1 + 2`, and hits enter, the interactive session evaluates the expression and shows its value.
If an expression is entered into an interactive session with a trailing semicolon, its value is not shown.
The variable `ans` is bound to the value of the last evaluated expression whether it is shown or not.
The `load` function reads and evaluates the contents of the given file.
<cn>
通过键入'^D'-按住'Ctrl'的同时按住'D'，可以退出交互式Julia解释器。
当运行在交互模式下的时候，标语'julia'用来提示用户的输入。
一旦用户键入了一个完整的表达式，如'1+2'并键入了回车键，交互式解析器就会计算表达式的值并显示出来。
然而，当用户在交互式解释器里面的表达式的后面跟上分号，那么表达式的计算结果将不会显示出来。
'ans'变量存储的是上一次表达式计算的结果，无论其结果是否显示出来了。
'load'函数读取并执行"file.jl"里面的内容。
</cn>
To run code in a file non-interactively, you can give it as the first argument to the julia command:

    $ julia script.jl arg1 arg2...

As the example implies, the following command-line arguments to julia are taken as command-line arguments to the program `script.jl`.
There are various ways to run Julia code and provide options, reminiscent of those taken by the `perl` and `ruby` programs:

    julia [options] [program] [args...]
     -q --quiet               Quiet startup without banner
     -H --home=<dir>          Load files relative to <dir>
     -T --tab=<size>          Set REPL tab width to <size>

     -e --eval=<expr>         Evaluate <expr> and don't print
     -E --print=<expr>        Evaluate and print <expr>
     -P --post-boot=<expr>    Evaluate <expr> right after boot
     -L --load=file           Load <file> right after boot
     -b --bare                Bare: don't load default startup files
     -J --sysimage=file       Start up with the given system image file

     -p n                     Run n local processes

     -h --help                Print this message

<cn>
通过将文件名作为第一个参数传递给julia可以在非交互模式下执行代码：

    $ julia script.jl arg1 arg2...

如上例代码所示的，跟在julia后面的参数会传递给'script.jl'。
有多种方式可以运行Julia代码，还可以提供多种参数，可以回想下'perl'或'ruby'提供的选项：

    julia [options] [program] [args...]
     -q --quiet               不是用标语，安静的启动
     -H --home=<dir>          指定加载文件的相对目录 <dir>
     -T --tab=<size>          设置tab键大小为 <size>

     -e --eval=<expr>         计算 <expr> 不显示结果
     -E --print=<expr>        计算 <expr> 并显示结果
     -P --post-boot=<expr>    在启动后立即执行 <expr> 
     -L --load=file           启动后理解加载文件 <file> 
     -b --bare                Bare: 不加载预制的开始文件
     -J --sysimage=file       使用给定的系统镜像文件启动

     -p n                     运行 n 个本地进程

     -h --help                显示帮助信息

</cn>
## Example Code

At this point it is useful to take a look at some [Example Programs](../example-programs).

<cn>
## 示例代码

可以参照[Example Programs](../example-programs)。

</cn>
## Major Differences From MATLAB®

Julia's syntax is intended to be familiar to users of MATLAB®.
However, Julia is in no way a MATLAB® clone:
there are major syntactic and functional differences.
The following are the most significant differences that may trip up Julia users accustomed to MATLAB®:

- Arrays are indexed with square brackets, `A[i,j]`.
- Multiple values are returned and assigned with parentheses, `return (a, b)` and `(a, b) = f(x)`.
- Values are passed and assigned by reference. If a function modifies an array, the changes will be visible in the caller.
- Use n for nx1: The number of arguments to an array constructor equals the number of dimensions of the result.
In particular, `rand(n)` makes a 1-dimensional array.
- Concatenating scalars and arrays with the syntax `[x,y,z]` concatenates in the first dimension ("vertically").
For the second dimension ("horizontally"), use spaces as in `[x y z]`.
To construct block matrices (concatenating in the first two dimensions), the syntax `[a b; c d]` is used to avoid confusion.
- Colons `a:b` and `a:b:c` construct `Range` objects.
To construct a full vector, use `linspace`, or "concatenate" the range by enclosing it in brackets, `[a:b]`.
- Functions return values using the `return` keyword, instead of by listing their names in the function definition (see [The "return" Keyword](../functions#The+return+Keyword) for details).
- A file may contain any number of functions, and all definitions will be externally visible when the file is loaded.
- Reductions such as `sum`, `prod`, and `max` are performed over every element of an array when called with a single argument as in `sum(A)`.
- Functions such as `sort` that operate column-wise by default (`sort(A)` is equivalent to `sort(A,1)`) do not have special behavior for 1xN arrays; the argument is returned unmodified since it still performs `sort(A,1)`. To sort a 1xN matrix like a vector, use `sort(A,2)`.
- Parentheses must be used to call a function with zero arguments, as in `tic()` and `toc()`.
- Do not use commas to end statements. The results of statements are not automatically printed (except at the interactive prompt), and lines of code do not need to end with semicolons. The function `println` can be used to print a value followed by a newline.

<cn>
## 和MATLAB®主要的不同:

Julia的语法有意的迎合了MATLAB®用户的习惯。
然而Julia并不是MATLAB®的一个克隆版:
他们在语法和函数上有大量不同。
以下可能是熟悉MATLAB®使用的用户使用Julia会遇到的问题:

- 数组的索引是通过方括号索引的, `A[i,j]`。
- 多个返回值通过圆括号指定, `return (a, b)` 还有 `(a, b) = f(x)`.
- 值的传递采用引用的方式，如果一个函数修改了一个数组，那么调用该函数的复对象里面的数组将会被改变。
- 用n表示nx1:传递给构造函数的参数决定了返回值的纬度。典型的：'rand(n)'得到一个一维数组。
- 创建标量和数组使用语法`[x,y,z]` 第一维链接纵向。第二个维链接横向,像这样使用空格`[x y z]`。 创建空矩阵可以用(串联在第一个纬度), 使用`[a b; c d]`这个语法可以防止混乱。
- 冒号`a:b` 和 `a:b:c`构建了一个`Range`对象。使用`linspace`, 或者用方括号 `[a:b]`指明范围来传教一个完整的容器。
- 函数的返回值使用`return`关键字,代替了将他们的名字列在函数定义中(参见[The "return" Keyword](../functions#The+return+Keyword) for details).
- 一个文件可以包含任意多个函数，当文件被加载时，里面所有的函数都将可见。
- 当使用单一的参数调用`sum`, `prod`, and `max`如`sum(A)`将会在数组的每一个元素上其作用。
- 像`sort`等函数预制的是按列操作(`sort(A)` 定价于`sort(A,1)`)对1xN数组没有特殊行为;由于它表现的像`sort(A,1)`所以返回的参数不会被改变。 当排序一个1xN矩阵如容器时, 使用`sort(A,2)`。
- 当圆括号用于函数调用时不能有参数如 `tic()` and `toc()`。
- 不要在指令的后面用逗号。这样的话，指令的结果将不会自动显示(除非在交互式解析器里),同样每行也不需要分号结尾。函数`println`
</cn>
