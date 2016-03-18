---
layout: post
title:  Put This In Your Pipe
author: <a href="http://karpinski.org/">Stefan Karpinski</a>
manurl: https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages
---

[previous post]: /blog/2012/03/shelling-out-sucks/

[`pipe`]:  {{page.manurl}}/man2/pipe.2.html
[`dup2`]:  {{page.manurl}}/man2/dup2.2.html
[`fork`]:  {{page.manurl}}/man2/fork.2.html
[`close`]: {{page.manurl}}/man2/close.2.html
[`exec`]:  {{page.manurl}}/man2/execve.2.html

In a [previous post](http://julialang.org/blog/2012/03/shelling-out-sucks), I talked about why "shelling out" to spawn a pipeline of external programs via an intermediate shell is a common cause of bugs, security holes, unnecessary overhead, and silent failures.
But it's so convenient!
Why can't running pipelines of external programs be convenient *and* safe?
Well, there's no real reason, actually.
The shell itself manages to construct and execute pipelines quite well.
In principle, there's nothing stopping high-level languages from doing it at least as well as shells do – the common ones just don't by default, instead requiring users to make the extra effort to use external programs safely and correctly.
There are two major impediments:

- Some moderately tricky low-level UNIX plumbing using the [`pipe`], [`dup2`], [`fork`], [`close`], and [`exec`] system calls;
- The UX problem of designing an easy, flexible programming interface for commands and pipelines.

This post describes the system we designed and implemented for Julia, and how it avoids the major flaws of shelling out in other languages.
First, I'll present the Julia version of the previous post's example – counting the number of lines in a given directory containing the string "foo".
The fact that Julia provides complete, specific diagnostic error messages when pipelines fail turns out to reveal a surprising and subtle bug, lurking in what appears to be a perfectly innocuous UNIX pipeline.
After fixing this bug, we go into details of how Julia's external command execution and pipeline construction system actually works, and why it provides greater flexibility and safety than the traditional approach of using an intermediate shell to do all the heavy lifting.

## Simple Pipeline, Subtle Bug

Here's how you write the example of counting the number of lines in a directory containing the string "foo" in Julia
(you can follow along at home if you have Julia installed from source by changing directories into the Julia source directory and doing `cp -a src "source code"; mkdir tmp` and then firing up the Julia repl):

    julia> dir = "src";

    julia> int(readchomp(`find $dir -type f -print0` |> `xargs -0 grep foo` |> `wc -l`))
    5

This Julia command looks suspiciously similar to the naïve Ruby version we started with in the previous post:

    `find #{dir} -type f -print0 | xargs -0 grep foo | wc -l`.to_i

However, it isn't susceptible to the same problems:

    julia> dir = "source code";

    julia> int(readchomp(`find $dir -type f -print0` |> `xargs -0 grep foo` |> `wc -l`))
    5

    julia> dir = "nonexistent";

    julia> int(readchomp(`find $dir -type f -print0` |> `xargs -0 grep foo` |> `wc -l`))
    find: `nonexistent': No such file or directory
    ERROR: failed processes:
      Process(`find nonexistent -type f -print0`, ProcessExited(1)) [1]
      Process(`xargs -0 grep foo`, ProcessExited(123)) [123]
     in pipeline_error at process.jl:412
     in readall at process.jl:365
     in readchomp at io.jl:172

    julia> dir = "foo'; echo MALICIOUS ATTACK; echo '";

    julia> int(readchomp(`find $dir -type f -print0` |> `xargs -0 grep foo` |> `wc -l`))
    find: `foo\'; echo MALICIOUS ATTACK; echo \'': No such file or directory
    ERROR: failed processes:
      Process(`find "foo'; echo MALICIOUS ATTACK; echo '" -type f -print0`, ProcessExited(1)) [1]
      Process(`xargs -0 grep foo`, ProcessExited(123)) [123]
     in pipeline_error at process.jl:412
     in readall at process.jl:365
     in readchomp at io.jl:172

The default, simplest-to-achieve behavior in Julia is:

- not susceptible to any kind of metacharacter breakage,
- reliably detects all subprocess failures,
- automatically raises an exception if any subprocess fails,
- prints error messages including exactly which commands failed.

In the above examples, we can see that even when `dir` contains spaces or quotes, the expression still behaves exactly as intended – the value of `dir` is interpolated as a single argument to the `find` command.
When `dir` is not the name of a directory that exists, `find` fails – as it should – and this failure is detected and automatically converted into an informative exception, including the fully expanded command-lines that failed.

In the previous post, we observed that using the `pipefail` option for Bash allows detection of pipeline failures, like this one, occurring before the last process in the pipeline.
However, it only allows us to detect that at least one thing in the pipeline failed.
We still have to guess at what parts of the pipeline actually failed.
In the Julia example, on the other hand, there is no guessing required:
when a non-existent directory is given, we can see that both `find` and `xargs` fail.
While it is unsurprising that `find` fails in this case, it is unexpected that `xargs` also fails.
Why *does* `xargs` fail?

One possibility to check for is that the `xargs` program fails with no input.
We can use Julia's `success` predicate to try it out:

    julia> success(`cat /dev/null` |> `xargs true`)
    true

Ok, so `xargs` seems perfectly happy with no input.
Maybe grep doesn't like not getting any input?

    julia> success(`cat /dev/null` |> `grep foo`)
    false

Aha! `grep` returns a non-zero status when it doesn't get any input.
Good to know.
It turns out that `grep` indicates whether it matched anything or not with its return status.
Most programs use their return status to indicate success or failure, but some, like `grep`, use it to indicate some other boolean condition – in this case "found something" versus "didn't find anything":

    julia> success(`echo foo` |> `grep foo`)
    true

    julia> success(`echo bar` |> `grep foo`)
    false

Now we know why `grep` is "failing" – and `xargs` too, since it returns a non-zero status if the program it runs returns non-zero.
This means that our Julia pipeline and the "responsible" Ruby version are both susceptible to bogus failures when we search an existing directory that happens not to contain the string "foo" anywhere:

    julia> dir = "tmp";

    julia> int(readchomp(`find $dir -type f -print0` |> `xargs -0 grep foo` |> `wc -l`))
    ERROR: failed process: Process(`xargs -0 grep foo`, ProcessExited(123)) [123]
     in error at error.jl:22
     in pipeline_error at process.jl:394
     in pipeline_error at process.jl:407
     in readall at process.jl:365
     in readchomp at io.jl:172

Since `grep` indicates not finding anything using a non-zero return status, the `readall` function concludes that its pipeline failed and raises an error to that effect.
In this case, this default behavior is undesirable:
we want the expression to just return `0` without raising an error.
The simple fix in Julia is this:

    julia> dir = "tmp";

    julia> int(readchomp(`find $dir -type f -print0` |> ignorestatus(`xargs -0 grep foo`) |> `wc -l`))
    0

This works correctly in all cases.
Next I'll explain *how* all of this works, but for now it's enough to note that the detailed error message provided when our pipeline failed exposed a rather subtle bug that would eventually cause subtle and hard-to-debug problems when used in production.
Without such detailed error reporting, this bug would be pretty difficult to track down.

## Do-Nothing Backticks

Julia borrows the backtick syntax for external commands form Perl and Ruby, both of which in turn got it from the shell.
Unlike in these predecessors, however, in Julia backticks don't immediately run commands, nor do they necessarily indicate that you want to capture the output of the command.
Instead, backticks just construct an object representing a command:

    julia> `echo Hello`
    `echo Hello`

    julia> typeof(ans)
    Cmd

(In the Julia repl, `ans` is automatically bound to the value of the last evaluated input.)
In order to actually run a command, you have to *do* something with a command object.
To run a command and capture its output into a string – what other languages do with backticks automatically – you can apply the `readall` function:

    julia> readall(`echo Hello`)
    "Hello\n"

Since it's very common to want to discard the trailing line break at the end of a command's output, Julia provides the `readchomp(x)` command which is equivalent to writing `chomp(readall(x))`:

    julia> readchomp(`echo Hello`)
    "Hello"

To run a command without capturing its output, letting it just print to the same `stdout` stream as the main process – i.e. what the `system` function does when given a command as a string in other languages – use the `run` function:

    julia> run(`echo Hello`)
    Hello

The `"Hello\n"` after the `readall` command is a returned value, whereas the `Hello` after the `run` command is printed output.
(If your terminal supports color, these are colored differently so that you can easily distinguish them visually.)
Nothing is returned by the `run` command, but if something goes wrong, an exception is raised:

    julia> run(`false`)
    ERROR: failed process: Process(`false`, ProcessExited(1)) [1]
     in error at error.jl:22
     in pipeline_error at process.jl:394
     in run at process.jl:384

    julia> run(`notaprogram`)
    execvp(): No such file or directory
    ERROR: failed process: Process(`notaprogram`, ProcessExited(-1)) [-1]
     in error at error.jl:22
     in pipeline_error at process.jl:394
     in run at process.jl:384

As with `xargs` and `grep` above, this may not always be desirable.
In such cases, you can use `ignorestatus` to indicate that the command returning a non-zero value should not be considered an error:

    julia> run(ignorestatus(`false`))

    julia> run(ignorestatus(`notaprogram`))
    execvp(): No such file or directory
    ERROR: failed process: Process(`notaprogram`, ProcessExited(-1)) [-1]
     in error at error.jl:22
     in pipeline_error at process.jl:394
     in run at process.jl:384

In the latter case, an error is still raised in the parent process since the problem is that the executable doesn't even exist, rather than merely that it ran and returned a non-zero status.


Although Julia's backtick syntax intentionally mimics the shell as closely as possible, there is an important distinction:
the command string is never passed to a shell to be interpreted and executed;
instead it is parsed in Julia code, using the same rules the shell uses to determine what the command and arguments are.
Command objects allow you to see what the program and arguments were determined to be by accessing the `.exec` field:

    julia> cmd = `perl -e 'print "Hello\n"'`
    `perl -e 'print "Hello\n"'`

    julia> cmd.exec
    3-element Union(UTF8String,ASCIIString) Array:
     "perl"
     "-e"
     "print \"Hello\\n\""

This field is a plain old array of strings that can be manipulated like any other Julia array.

## Constructing Commands

The purpose of the backtick notation in Julia is to provide a familiar, shell-like syntax for making objects representing commands with arguments.
To that end, quotes and spaces work just as they do in the shell.
The real power of backtick syntax doesn't emerge, however, until we begin constructing commands programmatically.
Just as in the shell (and in Julia strings), you can interpolate values into commands using the dollar sign (`$`):

    julia> dir = "src";

    julia> `find $dir -type f`.exec
    4-element Union(UTF8String,ASCIIString) Array:
     "find"
     "src"
     "-type"
     "f"

Unlike in the shell, however, Julia values interpolated into commands are interpolated as a single verbatim argument – no characters inside the value are interpreted as special after the value has been interpolated:

    julia> dir = "two words";

    julia> `find $dir -type f`.exec
    4-element Union(UTF8String,ASCIIString) Array:
     "find"
     "two words"
     "-type"
     "f"

    julia> dir = "foo'bar";

    julia> `find $dir -type f`.exec
    4-element Union(UTF8String,ASCIIString) Array:
     "find"
     "foo'bar"
     "-type"
     "f"

This works no matter what the contents of the interpolated value is, allowing simple interpolation of characters that are quite difficult to pass as parts of command-line arguments even in the shell (for the following examples, `tmp/a.tsv` and `tmp/b.tsv` can be created in the shell with `echo -e "foo\tbar\nbaz\tqux" > tmp/a.tsv; echo -e "foo\t1\nbaz\t2" > tmp/b.tsv`):

    julia> tab = "\t";

    julia> cmd = `join -t$tab tmp/a.tsv tmp/b.tsv`;

    julia> cmd.exec
    4-element Union(UTF8String,ASCIIString) Array:
     "join"
     "-t\t"
     "tmp/a.tsv"
     "tmp/b.tsv"

    julia> run(cmd)
    foo     bar     1
    baz     qux     2

Moreover, what comes after the `$` can actually be any valid Julia expression, not just a variable name:

    julia> `join -t$"\t" tmp/a.tsv tmp/b.tsv`.exec
    4-element Union(UTF8String,ASCIIString) Array:
     "join"
     "-t\t"
     "a.tsv"
     "b.tsv"

A tab character is somewhat harder to pass in the shell, requiring command interpolation and some tricky quoting:

    bash-3.2$ join -t"$(printf '\t')" tmp/a.tsv tmp/b.tsv
    foo	    bar	    1
    baz	    qux	    2

While interpolating values with spaces and other strange characters is great for non-brittle construction of commands, there was a reason why the shell split values on spaces in the first place:
to allow interpolation of multiple arguments.
Most modern shells have first-class array types, but older shells used space-separation to simulate arrays.
Thus, if you interpolate a value like "foo bar" into a command in the shell, it's treated as two separate words by default.
In languages with first-class array types, however, there's a much better option:
consistently interpolate single values as single arguments and interpolate arrays as multiple values.
This is precisely what Julia's backtick interpolation does:

    julia> dirs = ["foo", "bar", "baz"];

    julia> `find $dirs -type f`.exec
    6-element Union(UTF8String,ASCIIString) Array:
     "find"
     "foo"
     "bar"
     "baz"
     "-type"
     "f"

And of course, no matter how strange the strings contained in an interpolated array are, they become verbatim arguments, without any shell interpretation.
Julia's backticks have one more fancy trick up their sleeve.
We saw earlier (without really remarking on it) that you could interpolate single values into a larger argument:

    julia> x = "bar";

    julia> `echo foo$x`
    `echo foobar`

What happens if `x` is an array?
Only one way to find out:

    julia> x = ["bar", "baz"];

    julia> `echo foo$x`
    `echo foobar foobaz`

Julia does what the shell would do if you wrote `echo foo{bar,baz}`.
This even works correctly for multiple values interpolated into the same shell word:

    julia> dir = "/data"; names = ["foo","bar"]; exts=["csv","tsv"];

    julia> `cat $dir/$names.$exts`
    `cat /data/foo.csv /data/foo.tsv /data/bar.csv /data/bar.tsv`

This is the same Cartesian product expansion that the shell does if multiple `{...}` expressions are used in the same word.

## Further Reading

You can read more in Julia's [online manual](http://docs.julialang.org/en/release-0.1/manual/running-external-programs/), including how to construct complex pipelines, and how shell-compatible quoting and interpolation rules in Julia's backtick syntax make it both simple and safe to cut-and-paste shell commands into Julia code.
The whole system is designed on the principle that the easiest thing to do should also be the right thing.
The end result is that starting and interacting with external processes in Julia is both convenient and safe.
