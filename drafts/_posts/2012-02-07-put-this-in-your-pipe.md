---
layout: post
title:  Put This In Your Pipe
author: <a href="http://karpinski.org/">Stefan Karpinski</a>
---
[previous post]: /blog/2012/02/shelling-out-sucks/
[`pipe`]:   https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man2/pipe.2.html
[`dup2`]:   https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man2/dup2.2.html
[`fork`]:   https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man2/fork.2.html
[`close`]:  https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man2/close.2.html
[`exec`]:   https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man2/execve.2.html

In a [previous post], I talked about why "shelling out" to spawn a pipeline of external programs via an intermediate shell is a common cause of bugs, security holes, unnecessary overhead, and silent failures.
But it's so convenient!
Why can't running pipelines of external programs be both convenient *and* safe?
Well, there's no real reason, actually.
The shell itself manages to construct and execute pipelines quite well.
In principle, there's nothing stopping high-level languages from doing it at least as well as shells do — they just don't.
There are only two impediments:

- Some tricky low-level UNIX plumbing using the [`pipe`], [`dup2`], [`fork`], [`close`], and [`exec`] system calls
- The UX problem of designing an easy, flexible programming interface for commands and pipelines.

This post describes the system we designed and implemented for Julia, and how it avoids the major flaws of shelling out in other languages.
First, I'll present the Julia version of the previous post's example — counting the number of lines in a given directory containing the string "foo".
The complete, accurate diagnostic messages provided when pipelines fail turns out to reveal a surprising and subtle bug, lurking in what appears to be an innocuous UNIX pipeline.
After that, I'll go into details about how Julia's external command execution and pipeline construction system actually works, and why it provides so much greater flexibility and safety than the traditional approach of using an intermediate shell to do all the heavy lifting.

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

In the above examples, we can see that even when `dir` contains spaces or quotes the expression still behaves exactly as intended — the value of `dir` is interpolated as a single argument to the `find` command.
When `dir` is not the name of a directory that exists, `find` fails, as it should, and this failure is detected and automatically converted into an informative exception, including the expanded command-lines that failed.

In the [previous post], it was observed that using the `pipefail` option for Bash allows us to detect pipeline failures, like this one, that would go unnoticed by default.
However, it *only* allows us to detect that something in the pipeline failed, not exactly what failed.
While this seems like a trivial drawback, it can hide lurking problems.
In fact, there is just such a problem hidden here.
Note that the exception raised when Julia executes this pipeline for a non-existent directory name indicates not only that `find` fails, but also that `xargs` fails — yet `wc` doesn't.
It seems like both `xargs` and `wc` should succeed — they receive no input, but that shouldn't be a cause for failure.
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
It turns out that `grep` indicates whether it matched anything or not by its return status.
Most programs use their return status to indicate success or failure, but some, like `grep`, use it to indicate some other boolean condition — in this case "found something" versus "didn't find anything":

    julia> success(`echo foo` | `grep foo`)
    foo
    true

    julia> success(`echo bar` | `grep foo`)
    false

Now we know why `grep` is "failing".
This means that our original pipeline (and the "responsible" Ruby version) is susceptible to bogus failures in the case where we search a valid directory that happens not to contain the string "foo" anywhere:

    julia> dir="tmp";

    julia> int(chomp(readall(`find $dir -type f -print0` | `xargs -0 grep foo` | `wc -l`)))
    failed process: `xargs -0 grep foo`

Since `grep` indicates not matching anything with a non-zero return status, the `readall` function decides that its pipeline failed and raises an error.
In this case, this is undesirable:
we want the expression to just return `0` without raising an error.
The simple fix is this:

    julia> dir="tmp";

    julia> int(chomp(readall(`find $dir -type f -print0` | ignorestatus(`xargs -0 grep foo`) | `wc -l`)))                         
    0

This works correctly in all cases.
Next I'll explain *how* all of this works, but for now it's enough to note that the detailed error message provided when our pipeline failed exposed a rather subtle bug that would, if this code were used in production, have caused a very hard-to-track-down bug at some point in the future.
