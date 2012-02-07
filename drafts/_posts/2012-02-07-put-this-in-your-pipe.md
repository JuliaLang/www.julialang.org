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
Why can't I running pipelines of external programs and have it be both convenient and safe?
Well, there's no real reason, actually.
The shell itself manages to do so quite well, in fact.
There's no reason that a high-level language can't do it at least as well as a shell can — they just don't.
The only impediment is some tricky low-level UNIX plumbing using the [`pipe`], [`dup2`], [`fork`], [`close`], and [`exec`] system calls, and the much harder problem of designing and implementing an easy, flexible programming interface.
This post describes the system we designed and implemented for Julia, including a variety of examples.

