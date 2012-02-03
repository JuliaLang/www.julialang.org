---
layout: post
title:  Shelling Out Sucks
author: <a href="http://karpinski.org/">Stefan Karpinski</a>
---

Calling external programs — a.k.a. "shelling out" — is error prone and inefficient in most programming languages.
This is true even in programming languages that pride themselves on be good for gluing various programs and systems together:
Perl, Python, Ruby — even, to some extent, shells themselves.
Here are the three reasons why shelling out is problematic:

1. *[Metacharacter brittleness.](#Metacharacter+brittleness)*
When variables are used to construct commands (which happens often), the code is almost always brittle:
if a variable contains any shell metacharacters, including spaces, the command will probably do something very different than what was intended — potentially something quite dangerous.
3. *[Indirection and inefficiency.](#Indirection+and+inefficiency)*
When shelling out, the main program forks and execs a shell process just so that shell can, in turn, fork and exec command a series of commands with their inputs and outputs appropriately connected.
Because of the intervening shell, the main parent process cannot be directly notified about the termination of subprocesses — it can only wait for the entire pipeline to finish and hope that the shell indicates what happened.
<!-- Also, forking and execing a shell just so that it can fork and exec other programs is kind of inefficient:
the parent program is perfectly capable of forking and execing them itself;
it's just a hassle. -->
2. *[Lack of error handling.](#Lack+of+error+handling)*
Errors in shelled out commands don't automatically become exceptions in most languages.
This typically leads to code that fails silently when shelled out commands don't work.
Worse still, because of the indirection problem, there are many cases where the failure of a process in a spawned pipeline simply cannot be detected by the parent process at all, let alone handled appropriately.

In the rest of this post, we'll go over examples demonstrating each of these problems.
At the end, I'll present how I think programming languages *should* deal with these issues better — which is [how Julia does it](https://github.com/JuliaLang/julia/wiki/Running-External-Programs).
I'll use [Bash] and [Ruby] for examples, but I could just as easily pick on [Python], [Perl], other [UNIX shells](http://en.wikipedia.org/wiki/Unix_shell), and any number of other programming languages.

## Metacharacter brittleness

Suppose you want to count the number of lines in all the files in a directory tree containing the word "foo".
One natural UNIXy way to do this is using the following shell pipeline:

    find $dir -type f | xargs grep foo | wc -l

Here the variable `$dir` is presumed to contain the path to the directory in which files should be looked for.
This works fine if `$dir` is something simple like `"src"`.
But what if `$dir` were something like `"source code"` instead, containing a space?
Although file names with spaces were traditionally uncommon on UNIX systems, with the advent of systems like [OS X], that is no longer the case.
Let's try it:

    bash-3.2$ mkdir "source code"
    bash-3.2$ echo foo > "source code"/test.txt
    bash-3.2$ dir="source code"
    bash-3.2$ find $dir -type f | xargs grep foo | wc -l
    find: `source': No such file or directory
    find: `code': No such file or directory
    0

Oops. Because space separates arguments in the shell, `bash` looks for directories named `"source"` and `"code"` rather than in a single directory named `"source code"`.
Bash provides a fix:
if we write `"$dir"` instead of just `$dir`, the shell knows to interpolate the variable as a single word instead of splitting it on whitespace:

    bash-3.2$ find "$dir" -type f | xargs grep foo | wc -l
    grep: source: No such file or directory
    grep: code/test.txt: No such file or directory
    0

A similar but distinct error: here the trouble is that `xargs` splits its input on whitespace when determining what arguments to pass to `grep`.
We can work around this using the `-print0` and `-0` options for `find` and `xargs`:

    bash-3.2$ find "$dir" -type f -print0 | xargs -0 grep foo | wc -l
    1

Finally! It works. But what a hassle.

Now suppose we're writing a Ruby script and we want to do the same thing.
One option is to write code that reads the contents of a given directory, finds all the files, opens them and iterates through them looking for the string `"foo"`.
However, that's a lot of work and it's going to be much slower than just letting `find` and `grep` do all the work since they're written in C and are very good at what they do.
The typical way to do this would be something like this:

    `find #{dir} -type f | xargs grep foo | wc -l`.to_i

Of course, this breaks just like our original Bash solution, when the value of `dir` has a space in it:

    irb(main):003:0> `find #{dir} -type f | xargs grep foo | wc -l`.to_i
    find: `source': No such file or directory
    find: `code': No such file or directory
    => 0

But let's just go ahead and fix all that since we've already done it once:

    irb(main):001:0> dir="source code"
    => "source code"
    irb(main):002:0> `find "#{dir}" -type f -print0  | xargs -0 grep foo | wc -l`.to_i
    => 1

Excellent.
So what's the problem?
This solution addresses the problem of file names with spaces in them, but it is still brittle with respect to any other shell metacharacters.
What if a file name has double quote character in it?
Let's try it.
First, create a weirdly name directory:

    bash-3.2$ mkdir 'foo"bar'
    bash-3.2$ echo foo > 'foo"bar'/test.txt
    bash-3.2$ ls -ld foo*bar
    drwxr-xr-x 3 stefan staff 102 Feb  3 16:17 foo"bar/

That is an admittedly strange name, but it's a perfectly legal UNIX file name.
Now back to Ruby:

    irb(main):002:0> `find "#{dir}" -type f -print0  | xargs -0 grep foo | wc -l`.to_i
    sh: -c: line 0: unexpected EOF while looking for matching `"'
    sh: -c: line 1: syntax error: unexpected end of file
    => 0

Doh.


[Bash]:     http://www.gnu.org/software/bash/
[Perl]:     http://www.perl.org/
[Python]:   http://python.org/
[Ruby]:     http://www.ruby-lang.org/
[OS X]:     http://en.wikipedia.org/wiki/Mac_OS_X
