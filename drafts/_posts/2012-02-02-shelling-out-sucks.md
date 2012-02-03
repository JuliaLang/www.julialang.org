---
layout:     post
title:      Shelling Out Sucks
author:     <a href="http://karpinski.org/" target="_blank">Stefan Karpinski</a>
---

Calling external programs — a.k.a. "shelling out" — is error prone and inefficient in most programming languages.
This is true even of programming languages where being the glue between other processes is considered one of major the strengths:
Perl, Python, Ruby — even, to some extent, shells themselves.
Here are the three reasons why shelling out is problematic:

1. **Metacharacter brittleness.**
When variables are used to construct commands (which happens often), the code is almost always brittle:
if a variable contains any shell metacharacters, including spaces, the command will probably do something very different than what was intended — potentially something quite dangerous.
3. **Inefficiency and indirection.**
When shelling out, the main program forks and execs a shell process just so that shell can, in turn, fork and exec command a series of commands with their inputs and outputs appropriately connected.
Because of the intervening shell, the main parent process cannot be notified about the termination of subprocesses — it can only wait for the entire pipeline to finish and hope that the shell indicates what happened.
2. **Lack of error handling.**
Errors in shelled out commands don't automatically become exceptions in most languages.
This typically leads to code that fails silently when shelled out commands don't work.
Worse still, because of the indirection problem, there are many cases where the failure of a process in a spawned pipeline simply cannot be detected by the parent process at all, let alone handled appropriately.
