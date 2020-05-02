@def authors = "Keno Fischer"
@def published = "2 May 2020"
@def title = "Coming in Julia 1.5: Time Traveling (Linux) Bug Reporting"
@def rss_pubdate = Date(2020, 5, 2)
@def rss = """Julia 1.5 is gaining a cool new bug reporting capability, leveraging mozilla's rr project to automatically create fully-reproducible bug reports"""

~~~
  <link rel="stylesheet" type="text/css" href="/assets/blog/2020-05-02-rr/asciinema-player.css" />
  <script src="/assets/blog/2020-05-02-rr/asciinema-player.js"></script>
  <style>
    @keyframes journey {
      from {
        transform: scale(1)
      }
      10% {
        transform: translate(-10%,10%) scale(0.1) rotateZ(30deg);
      }
      20% {
        transform: translate(-20%,-5%) scale(0.1) rotateZ(30deg);
      }
      30% {
        transform: translate(-10%,-20%) scale(0.1) rotateZ(30deg);
      }
      40% {
        transform: translate(-10%,-18%) scale(0.05) rotateZ(30deg);
      }
      55% {
        transform: translate(-10%,-18%) scale(0.05) rotateZ(30deg);
      }
      60% {
        transform: translate(-10%,-25%) scale(0.05) rotateZ(30deg);
      }
      90% {
        transform: translate(10%,-25%) scale(0.1) rotateZ(30deg) rotateX(140deg);
      }
    }
    @keyframes fadeIn {
      10% {
        opacity:1;
      }
      90% {
        opacity:1;
      }
    }
    #player_main {
      position: absolute;
      left: 0;
      right: 0;
      margin: auto;
      z-index: 1;
    }
    #after_animation {
     margin-top: 700px;
    }
    #player_main.animated {
      animation-name: journey;
      animation-delay: 2s;
      animation-duration: 10s;
    }
    #arch_diagram {
      position: absolute;
      left: 0;
      right: 0;
      margin: auto;
      z-index: 0;
      opacity: 0;
    }
    #arch_diagram.animated {
      animation-name: fadeIn;
      animation-delay: 2s;
      animation-duration: 10s;
    }
    .hidden {
      display: none;
    }
    .control-bar {
      display: none;
    }
    #animation {
        height: 700px;
    }
    .container li > p { margin-bottom: 0 }
  </style>
  <div id="animation">
  <div id="player_main">
  <asciinema-player author="Keno Fischer"
                    cols="100"
                    id="record_player"
                    rows="40"
                    speed="1"
                    theme="asciinema"
                    title="Recording"
                    src="/assets/blog/2020-05-02-rr/record.cast">
  </asciinema-player>
  <asciinema-player author="Keno Fischer"
                    cols="100"
                    id="replay_player"
                    class="hidden"
                    rows="40"
                    speed="1"
                    theme="asciinema"
                    title="Recording"
                    src="/assets/blog/2020-05-02-rr/replay.cast">
  </asciinema-player>
  </div>
  <image id="arch_diagram" src="/assets/blog/2020-05-02-rr/arch.svg"/>
  </div>
  <script>
    document.getElementById('record_player').addEventListener('ended', function(e) {
      document.getElementById('player_main').classList.add("animated");
      document.getElementById('arch_diagram').classList.add("animated");
      document.getElementById('player_main').addEventListener('animationend', () => {
        document.getElementById('record_player').classList.add("hidden");
        document.getElementById('replay_player').classList.remove("hidden");
        document.getElementById('replay_player').play();
      });
    });
  </script>
~~~

The Julia project, like any large open source project, gets a large number of
bug reports everyday. As the developers of the language, we try our best to
be as responsive as possible and to triage, investigate and fix any bugs as
quickly as possible. For some bugs, this is easy. If the bug report is well
written and the problem is evident, getting it fixed is usually a quick affair.
However, for a large number of issues, this is not as easy. There are several
common reasons why bugs may go unaddressed for extended periods of time, for
example:

1) The bug may not reproduce deterministically, or maybe only reproduces on the
   reporter's machine (sometimes known as a [Heisenbug](https://en.wikipedia.org/wiki/Heisenbug)).
2) The bug report may be incomplete as to the environment in which the bug occurs,
   making it hard to reproduce.
3) The bug reporter may have seen the bug once, but not been entirely sure what
   caused it making it hard to give a reproducer and making the bug report
   largely unactionable.
4) The bug may occur only in a large project that is hard to set up.
5) The bug may require specialized expertise to diagnose (e.g. a missing GC root),
   but the time commitment to reproduce it is too large for those who have the
   requisite expertise, since their time is in high demand.

In addition, there are the bugs that never get filed, because the user may
feel the effort to write a high-quality bug report is too high, since their
specific setup would be too complicated to describe and reproduce. Such
experiences are frustrating both for the users encountering them and for us,
because we don't learn about them and sometimes only hear about it years later,
when we get told that somebody gave up on their project in Julia because they
encountered some crashing problem that they didn't feel qualified to reduce into
a concise bug report and subsequently gave up on using Julia for their project.
Lastly, we don't want or expect our users to be expert bug reporters. They are
often working scientists who are good programmers, but may not have any
background in software engineering. These are some of our most valuable users,
and we want to make sure their bugs are addressed.

For users who did encounter such particularly difficult problems, we have for
a long time had one particular answer: If you can reproduce it on a linux
machine and get us a trace from the `rr` tool <https://rr-project.org/>, we can
probably get it fixed for you very rapidly. For the uninitiated, `rr` is a Linux
debugging tool originally written by Robert O'Callahan at Mozilla. It is a tool
known as a "time traveling debugger" or "reverse execution engine". Essentially,
`rr` splits reproducing bugs into a "record" and a "replay" phase. The record
phase is performed by the bug reporter. During this phase, `rr` creates a perfect
record of the execution, including the *bitwise exact* memory and register state
after every instruction. This trace can then be analyzed during the replay
phase (which can be performed by a different developer on a different machine).
Capabilities like these have long been imagined in academia, but it is extremely
hard to achieve in a way that does not introduce large overheads or distort
regular execution. `rr` is that first such tool that (in our experience) is
performant enough to be used in the regular course of development. It is worth
discussing how this is achieved (and what limitations the approach has), but
first let's take the capabilities for granted and take a look at the workflow
it enables.

In Julia 1.5, there is now a new command line flag `--bug-report=rr` that will
automatically create and upload an `rr` recording. An example usage is shown
in the animation at the start of this post (which just creates a deliberate
crash by unsafely dereferencing a bad pointer). However to summarize:

1. The bug reporter passes `--bug-report=rr` to her julia instance and
   reproduces whatever bug they are attempting to reproduce.

2. Once julia exits or crashes, the bug reporter is prompted to authorize an
   upload by clicking on a link (GitHub-based authentication is used for abuse
   protection). She then gets back a link to include when filing a bug report
   against julia or some other package.

3. Any developer can use the link to obtain the recording and analyze it on
   their own machine.

In addition to this manual mechanism, we are also switching our linux CI systems
to automatically create `rr` traces of any execution. That way, if a CI run fails,
we are guaranteed to be able to debug it.

If a bug report includes a link to an `rr` trace, no further reproduction
instructions are required (if the bug is something non-obvious like
unexpected behavior, some comments on what the expected behavior was may
still be helpful), since the `rr` trace is guaranteed to perfectly capture
the environment the bug was reproduced in. This almost immediately knocks
out all the common problems I started this post with. "Works for me" is no
longer an available answer. If it's in the trace, it broke on somebody's machine
and can be debugged. "Heisenbug"s are no longer an issue. If it was captured
once in `rr`, it can always be debugged. It even solves the busy-expert problem,
as it allows non-experts to help out with triage. If such a report does not
contain an `rr` trace, any developer, and in particular non-experts can attempt to
reproduce the bug and create one. Even if the expert is still required to do
the final diagnosis, doing so from an `rr` trace is orders of magnitude faster
than from a plain bug report.

# Chronomancy for dummies

A computer is fundamentally a deterministic machine. Given equivalent
states as inputs, most instructions will produce a deterministic state
as output. So where do all the subtle execution differences comes from that
produce diverging executions and prevent bugs from reproducing? Well, the
complete answer is complicated and has lots of details, but is roughly split
up into:

1) The input state is large. Probably the state of your entire hard drive and
    memory. That's at least `2^2^large` bits of state right there each of which
    could potentially cause a difference in execution. You really want to figure
    out what state is relevant, since `2^2^large` is probably too many bits to send
    somebody.

2) Any input or other asynchronous events. This can mean user input, or
    data from the network (via the NICs) or other devices. It also means things like
    the timing of interrupts.

3) Execution ordering and data races in multi-threaded executions.

However, in theory if a tool was able to capture 100% of the relevant state
from these categories, it could repeated generate exactly the same memory image.
This is not a novel idea, but the devil is in the detail. As already mentioned,
just capturing everything is probably too large, if at all possible (e.g. how
do you capture interrupt timing - how do you even talk about time in this setting?).

In other words, for some input state $\mathcal{S_{i}}$,
the output state $\mathcal{S_{i+1}}$ is determined by some pure, deterministic
function $\mathcal{I}_{ip(\mathcal{S}_i)}$, corresponding to the instruction to be
executed at time $i$, or some asynchronous event $\mathcal{A}_i$

$$ \mathcal{S}_{i+1} = \begin{cases}
    \mathcal{A}_i(S_{i}) & \text{if an asynchronous even occured at time $i$} \\
    \mathcal{I}_{\text{ip}(\mathcal{S}_i)} & \text{otherwise}
\end{cases} $$

Did that help? No? oh. Well, it made me feel better about my physics degree and
also I've been told it's not research until it has at least one equation in it,
so there you go. Also, people worked really hard to get the equation rendering working,
on this blog, so I better use it. Anyway, where were we?

Ah yes, `rr` works by treating the kernel/userspace boundary as the determinism boundary.
This has a lot of advantages. For one, the kernel isolates a lot of state. If a
part of the disk state (e.g. a file) wasn't requested through the kernel, you
can be guaranteed that it didn't affect the process state (assuming the kernel
works correctly of course). It abstracts over hardware details and provides
a uniform interface to resources like the network. It also isolates processes
from another, so if there is one process of interest (e.g. julia) only the
activity relevant to it has to be recovered.

Of course, there are some drawbacks as well. In order to function `rr` has to
have an extremely precise model of the operation of the kernel and the ways
in which it interacts with userspace. On Linux this interface is supposedly
stable, but few applications put as stringent a constraint on that promise as
`rr` does (e.g. even a single bit difference can be problematic).

The details here are quite involved, and I recommend reading Robert's
[technical report](https://arxiv.org/abs/1610.02144) for a deeper overview of
some of `rr`'s design points (though even that only scratches the surface).

One final thought for this section is the origin of the term "time-traveling"
debugger. It stems from the mode of analysis that a system like this enables.
In a traditional debugger, it is possible to execute one instruction at a time,
and step from memory state to memory state in the forwards direction. Systems
like `rr` allow the opposite during replay: Step backwards through the state of
the system. Under the hood this is accomplished by playing forward from the
beginning (or more likely some intermediate checkpoint created for performance
reasons), until the previous state is reached. However, to the end user, the
illusion of going backwards in time is presented and an extremely useful mental
model for debugging.

# Performance considerations

While the previous section described the operating principle of `rr`, it does
not do justice to the reason why `rr` works so well. That reason is simple:
performance. Overhead for recording of single threaded processes
is generally below 2x, most often between 2% and 50% (lower for purely
numerical calculations, higher for workloads that interact with the OS).
Recording multi-threaded processes is tougher. By default `rr` serializes
execution of tasks that access the same shared memory. In generality this is
required for correctness, since it is not possible to observe and record the
interleaving of memory operations to shared memory spaces. However, there is
hope. If the multi-threaded program is well-behaved (or mostly well-behaved)
in that communication happens by message passing rather than shared memory, or
if accesses to shared memory are explicitly synchronized in a recordable fashion,
multi-threaded recording becomes possible. `rr` currently supports the former,
if the messages are passed via operating system pipes. We are interested in
techniques for the latter and there is some interesting academic work in this
direction, but nothing close to production ready. A complete solution would
probably combine compiler-based analysis of safe regions with dynamic
enforcement of safety for regions where this cannot be proven by the compiler.
However, that is for future work. For the moment, recording multi-threaded,
shared-memory applications will likely incur overhead linear in the number of
threads. It is thus a good idea to try and reproduce any issues at low core count.

With that caveat in mind. Here is some real benchmark numbers of overhead for
the julia test suite. The tests suite mostly uses message-passing based
parallelism for running multiple tests in parallel. Only the `threads` test
incurs the shared memory overhead penalty. Here are the measurements:

[data]

The total compressed size of a trace for a full run of the test suite (about
30 minutes on 10 cores) is about three gigabytes.

# Hardware and Software limitations

As was already mentioned, `rr` currently only works on Linux. However, there
are more restrictions. At the moment only x86 chips with Intel microarchitecture
are supported. `rr` relies on hardware performance counters to establish a
precise and accurate notion of time for asynchronous events. If these hardware
counters are not available or not precise enough, recording using `rr` will not
work. We and others have investigated whether it would be possible to port rr
to other architectures. To the best of my knowledge, the current thinking on
this is as follows:

- For x86_64 with AMD Ryzen microarchitecture, it seems potentially possible, but the
    AMD performance counters are less accurate than those found on Intel chips.
    It may be possible to compensate for this in software, but the in-accuracies
    are ill-understood. Help in investigation is welcome ([issue](https://github.com/mozilla/rr/issues/2034)).

- For Aarch64, ll/sc-based atomics introduce additional problems, since various
    external factors (interrupts, descheduling, etc.) can be observed as sc aborts.
    With proper hardware support, this would be possible to work around, but such
    hardware support appeared to be too in-accurate on older generation Aarch64 chips
    and have been removed on recent generation ones. That said, Aarch64
    microarchitectures are varied and as evidenced by the x86_64 experience, these
    things can vary quite a bit by microarchitecture. Investigation of the hardware
    capabilities of various Aarch64 microarchitectures would be very welcome
    ([issue](https://github.com/mozilla/rr/issues/1373)).

- We have looked into rr on POWER9, which is found in several large supercomputers
    that run julia jobs. POWER9 has similar issues to Aarch64 since it is also an
    ll/sc architecture, as well as supporting hardware transactional memory. In theory,
    we believe the hardware exists to compensate for these issues, but preliminary
    investigation suggests the hardware is not accurate enough to support `rr`. That
    said, I understand there's active discussions with IBM to determine whether this
    analysis is correct.

One additional point of complication, is that it is quite easy for hypervisors
(such as those used by cloud vendors) to interfere with the CPU capabilities
required by `rr`. My understanding is that `rr` works fine on the latest generation
of AWS machines, but not on GCP or Azure.

Lastly, we shouldn't fail to mention GPUs. GPUs are heavily utilized by Julia
users, but are currently not supported by `rr`. Changing this is tricky. GPUs
often allow direct memory access between the device and the userspace program
being recorded. If the interface to the GPU is known, this can definitely be
mitigated, potentially at some performance cost, e.g. by double buffering. For
GPUs with open source drivers, e.g. AMDGPU, there is active community interest
in building such a solution. It is not an easy task, but I think it has a
decent chance of succeeding, since open source drivers allow insight into exactly
how the GPU works and when it will modify process memory. GPUs with proprietary
drivers are a lot harder. For one, their interface to userspace is not necessarily
known. Additionally, proprietary drivers tend to be a lot less well behaved
than open source ones (the linux kernel review process tends to filter out
the most egregious behavior). For example, proprietary drivers have been
observed to use the userspace stack for scratch space. For those GPUs in use
by a large number of Julia users, we hope to work with the relevant vendors to
bring this capability to their platforms, but it may be a long road.

In summary, these new capabilities are currently only supported on Intel x86_64
chips. However, this is a bit of a chicken-and-egg problem. The hardware
requirements are non-trivial, but not egregious. If the hardware vendors cared
about this problem, they could definitely build hardware that enabled `rr` to work
(and if they really cared, they could build hardware assist features to make
`rr` much faster), but without a significant user base of such features they
have little incentive to care. I'm hoping that by rolling out these capabilities
widely, these incentives will start presenting themselves. Judging from the size
of the community and discounting for those that use unsupported hardware or
operating system, the number of users for whom this feature will be available
like numbers in the hundreds of thousands. That isn't super large, by hardware
vendor standards, but it isn't trivially small either. If any hardware vendor
is interested in making this work, we'd be happy to talk to you (and as I
mentioned, some of this is already in progress).

# A word on privacy

By its nature, an `rr` trace will contain any file touched by the process during
its lifetime. In particular, this may contain things like your julia history,
configuration files for your system, any secrets entered or read (i.e. make
sure to use ssh-agent if your reproducer involves using SSH for authentication),
any private code you may be using, etc. We are investigating building tooling
to help understand what's in the trace and anonymize parts of the trace that are
potentially sensitive, but do not have long-ranging effects in the trace. We
will also likely be disabling history by default if the `--bug-report` command
line flag is passed. Nevertheless, please make sure to have the system
administrator's permission before using the `--bug-report` feature. If you are
not sure, we recommend creating the reproducer in a sanitized, isolated
environment (e.g. a docker container). Alternatively, while the `--bug-report`
option creates a public upload by default, if you are user that has access to
professional Julia support (e.g. through your employer, supercomputing center
or similar), you may be able to request a mechanism to share traces generated
through this feature privately.

# Future outlook

Being able to replay the traces is only the beginning. I like to say that
with `rr`, debugging becomes a data analysis problem, since any question
you could possibly ask about the program is already contained in the data,
it just becomes a question of extracting the answer. By default, `rr` drops
you into GDB, but GDB is unlikely to be the correct frontend for such analysis.
`rr`'s original author Robert O'Callahan now has a startup working on a
next-generation frontend over at <https://pernos.co/> (no affiliation, but his work
made much of this possible, so a plug is the least I can do here). That said,
Julia itself tends to be a pretty good tool for data analysis and I have some
ideas what such a frontend may look like (notebook style, with the ability to
generate plots over the 2d time x space state of the recording). There's lots of
cool things that can be done. To name just a few: Checking assertions after the
fact, validating GC rooting accuracy after the fact, performance analysis,
super precise coverage testing, etc. In fact, having the recording enables
some analysis techniques that would be prohibitively expensive to do in real
time, but that is a topic for another time.

## Conflict of Interest disclaimer / Funding Acknowledgement

Essentially all of the companies mentioned in this blog post have in the past provided
financial or other support to the Julia project. In particular, Intel and IBM
have in the past supported the Julia project financially to improve support
for their respective architectures. Amazon, Google and Microsoft have provided
cloud computing credits as well. Intel, Google, and Microsoft have also previously
sponsored JuliaCon.

This work was primarily funded by my employer, Julia Computing. Part of Julia
Computing's open source work is funded by external grants. As such, part of this
work was funded under a grant from the Moore Foundation, which is gratefully
acknowledged.

Part of this work was funded under a contract from Intel to improve the stability
of multi-threading in Julia on Intel platforms. Additionally, where hardware bugs
were encountered during this work, they were reported to the relevant vendor under
existing funded contracts.

Further, Julia Computing has [previously announced](https://juliacomputing.com/blog/2019/02/13/JuliaTeam-Vision.html)
that `rr` integration will likely be available in future commercial offerings.
This is a separate piece of work and not a Julia Computing product. If you
are interested in using these capabilities with a Julia Computing product,
or under your Julia Computing support agreement, please contact your support
representative.

Lastly, your author discloses his self-interest. He spends too much time
trying to get bug reports to reproduce under `rr` so they can be fixed, so if y'all
would do that for me, that'd be swell.
