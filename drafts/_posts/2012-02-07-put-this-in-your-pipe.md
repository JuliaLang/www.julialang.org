---
layout: post
title:  Put This In Your Pipe
author: <a href="http://karpinski.org/">Stefan Karpinski</a>
manurl: https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages
---

[previous post]: /blog/2012/02/shelling-out-sucks/

[`pipe`]:  {{page.manurl}}/man2/pipe.2.html
[`dup2`]:  {{page.manurl}}/man2/dup2.2.html
[`fork`]:  {{page.manurl}}/man2/fork.2.html
[`close`]: {{page.manurl}}/man2/close.2.html
[`exec`]:  {{page.manurl}}/man2/execve.2.html

In a [previous post], I talked about why "shelling out" to spawn a pipeline of external programs via an intermediate shell is a common cause of bugs, security holes, unnecessary overhead, and silent failures.
But it's so convenient!
Why can't running pipelines of external programs be convenient *and* safe?
Well, there's no real reason, actually.
The shell itself manages to construct and execute pipelines quite well.
In principle, there's nothing stopping high-level languages from doing it at least as well as shells do — they just don't.
There are only two impediments:

- Some tricky low-level UNIX plumbing using the [`pipe`], [`dup2`], [`fork`], [`close`], and [`exec`] system calls
- The UX problem of designing an easy, flexible programming interface for commands and pipelines.

This post describes the system we designed and implemented for Julia, and how it avoids the major flaws of shelling out in other languages.
First, I'll present the Julia version of the previous post's example — counting the number of lines in a given directory containing the string "foo".
The fact that Julia provides complete, specific diagnostic error messages when pipelines fail turns out to reveal a surprising and subtle bug, lurking in what appears to be a perfectly innocuous UNIX pipeline.
After fixing this bug, we go into details of how Julia's external command execution and pipeline construction system actually works, and why it provides so much greater flexibility and safety than the traditional approach of using an intermediate shell to do all the heavy lifting.

## Simple Pipeline, Subtle Bug

Here's how you write the example of counting the number of lines in a directory containing the string "foo" in Julia:

    julia> dir="src";

    julia> int(chomp(readall(`find $dir -type f -print0` | `xargs -0 grep foo` | `wc -l`)))
    5

This looks suspiciously like the naïve shelling out example we started with in Ruby:

    `find #{dir} -type f -print0 | xargs -0 grep foo | wc -l`.to_i

However, it is susceptible to none of the same problems:

    julia> dir="source code";

    julia> int(chomp(readall(`find $dir -type f -print0` | `xargs -0 grep foo` | `wc -l`)))
    5

    julia> dir="nonexistent";

    julia> int(chomp(readall(`find $dir -type f -print0` | `xargs -0 grep foo` | `wc -l`)))
    find: `nonexistent': No such file or directory
    failed processes: `find nonexistent -type f -print0`, `xargs -0 grep foo`

    julia> dir="foo'; echo MALICIOUS ATTACK; echo '";

    julia> int(chomp(readall(`find $dir -type f -print0` | `xargs -0 grep foo` | `wc -l`)))
    find: `foo\'; echo MALICIOUS ATTACK; echo \'': No such file or directory
    failed processes: `find "foo'; echo MALICIOUS ATTACK; echo '" -type f -print0`, `xargs -0 grep foo`

The default, simplest-to-achieve behavior in Julia is:

- Not susceptible to any kind of metacharacter breakage
- Reliably detects all subprocess failures
- Automatically raises an exception if any subprocess fails
- Prints error messages including exactly which commands failed.

In the above examples, we can see that even when `dir` contains spaces or quotes, the expression still behaves exactly as intended — the value of `dir` is interpolated as a single argument to the `find` command.
When `dir` is not the name of a directory that exists, `find` fails — as it should — and this failure is detected and automatically converted into an informative exception, including the fully expanded command-lines that failed.

In the [previous post], it was observed that using the `pipefail` option for Bash allows detection of pipeline failures, like this one, that occur before the last process in the pipeline.
However, it only allows us to detect that at least one thing in the pipeline failed.
We still have to guess at what parts of the pipeline actually failed.
In the Julia example, on the other hand, there is no guessing required:
we can see that when a non-existent directory is given, both `find` and `xargs` fail.
While it is unsurprising that `find` fails in this case, it is unexpected that `xargs` also fails.
Why does `xargs` fail?

One possibility to check for is that the `xargs` program fails without input.
We can use Julia's `success` predicate to try it out:

    julia> success(`cat /dev/null` | `xargs true`)
    true

Ok, so `xargs` seems perfectly happy with no input.
Maybe grep doesn't like not getting any input?

    julia> success(`cat /dev/null` | `grep foo`)
    false

Aha! `grep` returns a non-zero status when it doesn't get any input.
Good to know.
It turns out that `grep` indicates whether it matched anything or not with its return status.
Most programs use their return status to indicate success or failure, but some, like `grep`, use it to indicate some other boolean condition — in this case "found something" versus "didn't find anything":

    julia> success(`echo foo` | `grep foo`)
    foo
    true

    julia> success(`echo bar` | `grep foo`)
    false

Now we know why `grep` is "failing" — and `xargs` too, since it returns a non-zero status if the program it runs returns non-zero.
This means that our Julia pipeline and the "responsible" Ruby version are both susceptible to bogus failures when we search an existing directory that happens not to contain the string "foo" anywhere:

    julia> dir="tmp";

    julia> int(chomp(readall(`find $dir -type f -print0` | `xargs -0 grep foo` | `wc -l`)))
    failed process: `xargs -0 grep foo`

Since `grep` indicates not finding anything using a non-zero return status, the `readall` function concludes that its pipeline failed and raises an error to that effect.
In this case, this default behavior is undesirable:
we want the expression to just return `0` without raising an error.
The simple fix in Julia is this:

    julia> dir="tmp";

    julia> int(chomp(readall(`find $dir -type f -print0` | ignorestatus(`xargs -0 grep foo`) | `wc -l`)))
    0

This works correctly in all cases.
Next I'll explain *how* all of this works, but for now it's enough to note that the detailed error message provided when our pipeline failed exposed a rather subtle bug that would inevitably cause problems if used in production code.
Without such detailed error reporting, this bug would have been *very* difficult to track down.

## Better Backticks

Julia borrows the backtick syntax for external commands form Perl and Ruby, both of which in turn got it from the shell.
Unlike these forerunners, however, in Julia backticks don't immediately run commands, nor do they necessarily indicate that you want to capture the output of the command.
Instead, backticks just construct an object representing a command:

    julia> `echo Hello`
    `echo Hello`

    julia> typeof(ans)
    Cmd

In order to actually run a command, you have to *do* something with a command object.
To run a command and capture its output into a string — what other languages do with backticks automatically — you can apply the `readall` function:

    julia> readall(`echo Hello`)
    "Hello\n"

To run a command without capturing its output, letting it just print to the same `stdout` stream as the main process — what the `system` function does when given a command as a string in other languages — use the `run` function:

    julia> run(`echo Hello`)
    Hello

The `"Hello\n"` after the `readall` command is a returned value, whereas the `Hello` after the `run` command is printed output.
(If your terminal supports color, these are colored differently so that you can easily distinguish them visually.)
Nothing is returned by the `run` command, but if something goes wrong, an exception is raised:

    julia> run(`false`)
    failed process: `false`

    julia> run(`notaprogram`)
    exec: No such file or directory
    failed process: `notaprogram`

As with `xargs`/`grep` above, this may not always be desirable.
In such cases, you can use `ignorestatus` to indicate that the command returning a non-zero value should not be considered an error:

    julia> run(ignorestatus(`false`))

    julia> run(ignorestatus(`notaprogram`))
    exec: No such file or directory
    failed process: `notaprogram`

In the latter case since the executable doesn't even exist, rather than just that it returned a non-zero status, an error is still raised in the parent process.
As we saw before, if you simply want to interpret the return-value of a program as true (zero) or false (non-zero), you can use the `success` function:

    julia> success(`true`)
    true

    julia> success(`false`)
    false

    julia> success(`perl -e 'exit 0'`)
    true

    julia> success(`perl -e 'exit 1'`)
    false

As you can see in the last example, you can use single quotes inside of backticks, just as you would when writing shell commands.
There is an important distinction, however.
Although Julia's backtick syntax intentionally mimics the shell as closely as possible, this string will never be passed to a shell for interpretation.
Instead, it is parsed in Julia code, using the same rules the shell uses to determine what the command and arguments are.
Command objects allow you to see what the program and arguments were determined to be by accessing the `.exec` field:

    julia> cmd = `perl -e 'print "Hello\n"'`
    `perl -e 'print "Hello\n"'`

    julia> cmd.exec
    ["perl", "-e", "print \"Hello\\n\""]

This field is a plain old array of strings.
You can alter it and manipulate it as you would any other array:

    julia> cmd.exec[1] = "ruby";

    julia> cmd
    `ruby -e 'print "Hello\n"'`

    julia> run(cmd)
    Hello

Once a command object has been run, you cannot run it again:

    julia> run(cmd)
    already run: `ruby -e 'print "Hello\n"'`

This is because command objects represent a single process invocation:
they store information like process ID and status — not yet run, running, stopped, exited with status, etc.

The purpose of the backtick notation in Julia is to provide a familiar, shell-like syntax for constructing objects representing parsed commands with arguments.
To that end, quotes and spaces work just as they do in the shell.
The real power of backtick syntax doesn't emerge, however, until we begin constructing commands programmatically.
Just as in the shell (and in Julia strings), you can interpolate values into commands using the dollar sign (`$`):

    julia> dir="src";

    julia> `find $dir -type f`.exec
    ["find", "src", "-type", "f"]

Unlike in the shell, however, Julia values interpolated into commands are interpolated as a single verbatim argument — no characters inside the value are interpreted as special after the value has been interpolated:

    julia> dir="two words";

    julia> `find $dir -type f`.exec
    ["find", "two words", "-type", "f"]

    julia> dir="foo'bar";

    julia> `find $dir -type f`.exec
    ["find", "foo'bar", "-type", "f"]

This works no matter what the contents of the interpolated value is, allowing simple interpolation of characters that are otherwise quite difficult to pass as parts of command-line arguments:

    julia> tab="\t";

    julia> cmd = `join -t$tab a.tsv b.tsv`;

    julia> cmd.exec
    ["join", "-t\t", "a.tsv", "b.tsv"]

    julia> run(cmd)
    foo     bar	    1
    baz	    qux	    2

Moreover, what comes after the `$` can actually be any valid Julia expression, not just a variable name:

    julia> run(`join -t$"\t" a.tsv b.tsv`)
    foo     bar	    1
    baz	    qux	    2

Even in the shell that's a rather difficult value to pass, requiring command interpolation and quotes:

    bash-3.2$ join -t"$(printf '\t')" a.tsv b.tsv
    foo	    bar	    1
    baz	    qux	    2

While interpolating values with spaces and other strange characters is great for non-brittle construction of commands, there was a reason why the shell split values on spaces in the first place:
to allow interpolation of multiple arguments.
Modern shells have first-class array types, but older shells simply used space-separation to achieve a poor man's array functionality.
Thus, by default, if you interpolate a value like "foo bar" into a command, it's treated as two separate words.
In languages with first-class array types, however, there's a much better option:
consistently interpolate single values as single arguments and interpolate arrays as multiple values.
This is precisely what Julia's backtick interpolation does:

    julia> dirs = ["foo", "bar", "baz"];

    julia> `find $dirs -type f`.exec
    ["find", "foo", "bar", "baz", "-type", "f"]

Cool, right?
And of course, no matter how strange the strings contained in an interpolated array are, they become verbatim arguments, without any interpretation.
Julia's backticks have one more trick up their sleeve.
We saw earlier (without really remarking on it) that you could interpolate single values into a larger argument:

    julia> x="bar";

    julia> `echo foo$x`.exec
    ["echo", "foobar"]

Well, what happens if `x` is an array?
Only one way to find out.

    julia> x=["bar", "baz"];

    julia> `echo foo$x`.exec
    ["echo", "foobar", "foobaz"]

That's right.
Julia does what the shell would do if you wrote `echo foo{bar,baz}`.
This works correctly for multiple values interpolated into the same shell word:

    julia> dir="/data"; names=["foo","bar"]; exts=["csv","tsv"];

    julia> `cat $dir/$names.$exts`
    `cat /data/foo.csv /data/foo.tsv /data/bar.csv /data/bar.tsv`

Julia's backtick syntax manages to make programmatic construction of commands both safer *and* more convenient than it is in any other system, including the shell.

## Advanced Plumbing
