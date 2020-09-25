+++
authors = "Keno Fischer"
published = "2 May 2020"
title = "Julia 1.5 Feature Preview: Time Traveling (Linux) Bug Reporting"
rss = """Julia 1.5 is gaining a cool new bug reporting capability, leveraging mozilla's rr project to automatically create fully-reproducible bug reports"""
meta = [
    ("property", "og:video", "https://julialang.org/assets/blog/2020-05-02-rr/preview.mp4"),
		("name", "twitter:player", "https://www.youtube.com/embed/JO6Jvad3XRU"),
		("name", "twitter:player:width", "960"),
		("name", "twitter:player:height", "720")
		]
+++

<!-- @tlienart -- leave this here for now -->
@def rss_pubdate = Date(2020, 5, 2)

~~~
  <link rel="stylesheet" type="text/css" href="/assets/blog/2020-05-02-rr/asciinema-player.css" />
  <script src="/assets/blog/2020-05-02-rr/asciinema-player.js"></script>
  <style>
    @keyframes journey {
      from {
        transform: scale(1)
      }
      10% {
        transform: translate(-5%,-14%) scale(0.1) rotateZ(30deg);
      }
      20% {
        transform: translate(-10%,-25%) scale(0.1) rotateZ(30deg);
      }
      30% {
        transform: translate(-5%,-30%) scale(0.1) rotateZ(30deg);
      }
      40% {
        transform: translate(-5%,-30%) scale(0.05) rotateZ(30deg);
      }
      55% {
        transform: translate(-5%,-30%) scale(0.05) rotateZ(30deg);
      }
      60% {
        transform: translate(-5%,-35%) scale(0.05) rotateZ(30deg);
      }
      90% {
        transform: translate(8%,-25%) scale(0.1) rotateZ(30deg) rotateX(140deg);
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
      width: 629px;
      height: 282px;
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
                    speed="2"
                    theme="asciinema"
                    title="Recording"
                    src="/assets/blog/2020-05-02-rr/record.cast">
  </asciinema-player>
  <asciinema-player author="Keno Fischer"
                    cols="100"
                    id="replay_player"
                    class="hidden"
                    rows="40"
                    speed="1.5"
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
bug reports every day. As the developers of the language, we try our best to
be as responsive as possible and to triage, investigate and fix any bugs as
quickly as possible. For some bugs, this is easy. If the bug report is well
written and the problem is evident, getting it fixed is usually a quick affair.
However, for a large number of reports, this is not as easy. There are several
common reasons why bugs may go unaddressed for extended periods of time, for
example:

1) The bug may not reproduce deterministically, or may only reproduce on the
   reporter's machine (sometimes known as a [Heisenbug](https://en.wikipedia.org/wiki/Heisenbug)).
2) The bug report may be incomplete in specifying the environment in which the bug occurs,
   making it hard to reproduce.
3) The bug reporter may have seen the bug once, but not been entirely sure what
   caused it making it hard to give a reproducer and making the bug report
   largely unactionable.
4) The bug may occur only in a large project that is hard to set up.
5) The bug may require specialized expertise to diagnose (e.g. a missing GC root).
   Usually, the time of such experts is in high demand, making the time commitment
   required to reproduce and investigate such bugs prohibitive.

In addition, there are the bugs that never get filed, because the user may
feel the effort to write a high-quality bug report is too high. Such
experiences are frustrating both for the users encountering them and for us.
We often don't learn about these experiences and sometimes only hear about them years later.
Somebody may have given up on their project in Julia because they
encountered some crashing problem that they didn't feel qualified to reduce into
a concise bug report and subsequently gave up on using Julia for their project.
Lastly, we don't want or expect our users to be expert bug reporters. They are
often working scientists who are good programmers, but may not have any
background in software engineering. These are some of our most valuable users,
and we want to make sure their bugs are addressed.

In the past, for users who did encounter particularly difficult problems, we have for
a long time had one answer: If you can reproduce it on a linux
machine and get us a trace from the `rr` tool <https://rr-project.org/>, we can
probably get it fixed for you very rapidly. For the uninitiated, `rr` is a Linux
debugging tool originally developed at Mozilla by Robert O'Callahan and others. It is a tool
known as a "time traveling debugger" or "reverse execution engine". Essentially,
`rr` splits reproducing bugs into two phases: "record" and a "replay". The record
phase is performed by the bug reporter. During this phase, `rr` creates a perfect
record of the execution, including the *bitwise exact* memory and register state
after every instruction. This trace can then be analyzed during the replay
phase (which can be performed by a different developer on a different machine).
Capabilities like these have long been imagined in academia, but are extremely
hard to achieve in a way that does not introduce large overheads or distort
regular execution. `rr` is the first such tool that (in our experience) is
performant enough to be used in the regular course of development. It is worth
discussing how this is achieved (and what limitations the approach has), but
first let's take the capabilities for granted and take a look at the workflow
it enables.

In Julia 1.5, which will be released in a few weeks,
there is now a new command line flag `--bug-report=rr` that will
automatically create and upload an `rr` recording. An example usage is shown
in the animation at the start of this post (which just creates a deliberate
crash by unsafely dereferencing a bad pointer). However to summarize:

1. The bug reporter passes `--bug-report=rr` to her julia instance and
   reproduces whatever bug she is attempting to reproduce.

2. Once julia exits or crashes, the bug reporter is prompted to authorize an
   upload by clicking on a link (GitHub-based authentication is used for abuse
   protection). She then gets back a link to include when filing a bug report
   against julia or some other package.

3. Any developer can use the link to obtain the recording and analyze it on
   their own machine.

In addition to this manual mechanism, we are also switching our linux CI systems
to automatically create `rr` traces of any execution. This way, if a CI run fails,
we are guaranteed to be able to debug it.

If a bug report includes a link to an `rr` trace, in theory no further reproduction
instructions are required. The `rr` trace is guaranteed to perfectly capture
the environment the bug was reproduced in. Of course, if the bug is something non-obvious like
unexpected behavior, some comments on what the expected behavior was may
still be helpful.
Having perfect reproducibility almost immediately knocks
out all the common problems I started this post with. "Works for me" is no
longer an available answer. If it's in the trace, it broke on somebody's machine
and can be debugged. "Heisenbug"s are no longer an issue. If it was captured
once in `rr`, it can always be debugged. It even solves the busy-expert problem,
as it allows non-experts to help out with triage. If such a report does not
contain an `rr` trace, any developer, and in particular non-experts, can attempt to
reproduce the bug and create a trace. Even if the expert is still required to do
the final diagnosis, doing so from an `rr` trace is orders of magnitude faster
than from a plain bug report.

# Chronomancy for dummies

A computer is fundamentally a deterministic machine. Given equivalent
states as inputs, most instructions will produce a deterministic state
as output. So where do all the subtle execution differences come from that
produce diverging executions and prevent bugs from reproducing? Well, the
complete answer is complicated and has lots of details, but is roughly split
up into:

1) The size of the input state. Naively this state encompasses at least your entire hard drive and
    memory. That's at least $2^{2^\text{large}}$ bits of state right there each of which
    could potentially cause a difference in execution. You really want to figure
    out what state is relevant, since $2^{2^\text{large}}$ is probably too many bits to send
    somebody.

2) Any input or other asynchronous events. This can mean user input, or
    data from the network (via the NICs) or other devices. It also means things like
    the timing of interrupts.

3) Execution ordering and data races in multi-threaded executions.

4) Direct observation of non-deterministic hardware effects (i.e. the "most" qualifier above).
   This includes instructions that are deliberately non-deterministic, such as RDRAND,
   which generates a random number. It also includes observable, but undesirable effects of hardware state
   (e.g. timing side channels from cache or branch predictor state).

However, in theory, if a tool was able to capture 100% of the relevant state
from these categories, it could repeatedly generate exactly the same memory image.
This is not a novel idea, but the devil is in the detail. Discussing these details
is beyond the scope of this particular post, but here is a taste: For an asynchronous event, how
do we define "when" this event happened with respect to the rest of the execution.
I.e. what is the correct notion of time?
Real time doesn't work because instruction issue frequency isn't constant (in addition
to all the usual issues of dealing with time). Probably the most convenient thing
to use would be the number of retired instructions, but there are some challenges
here depending on the hardware (which will be discussed a bit in the hardware section
below).

To summarize, for some input state $\mathcal{S_{i}}$,
the output state $\mathcal{S_{i+1}}$ is determined by some pure, deterministic
function $\mathcal{I}_{ip(\mathcal{S}_i)}$, corresponding to the instruction to be
executed at time $i$, or some asynchronous event $\mathcal{A}_i$

$$ \mathcal{S}_{i+1} = \begin{cases}
    \mathcal{A}_i(S_{i}) & \text{if an asynchronous event occurred at time $i$} \\
    \mathcal{I}_{\text{ip}(\mathcal{S}_i)} & \text{otherwise}
\end{cases} $$

Did that help? No? oh. Well, it made me feel better about my physics degree and
also I've been told it's not research until it has at least one equation in it,
so there you go. Also, people worked really hard to get the equation rendering working,
on this blog, so I better use it. Anyway, where were we?

Ah yes - how does `rr` do what it does? One of the key tricks it uses is to re-use
an abstraction boundary that already exists: That between the application and the
underlying operating system (or more specifically the Linux kernel). Exploiting
this abstraction boundary as a determinism boundary (that is relying on determinism
to apply any changes made internal to the application, but explicitly recording
any changes made by the kernel) has a lot of advantages.
For one, the kernel isolates a lot of state. If a
part of the disk state (e.g. a file) wasn't requested through the kernel, you
can be guaranteed that it didn't affect the process state (assuming the kernel
works correctly of course). It abstracts over hardware details and provides
a uniform interface to resources like the network. It also isolates processes
from another, so if there is one process of interest (e.g. julia) only the
activity relevant to it has to be recovered.

That said, this scheme also introduces some complications. In order to function, `rr` must
have an extremely precise model of the operation of the kernel and the ways
in which it interacts with userspace. The Linux developers work hard to attempt
to keep this interface stable, but few applications put as stringent a constraint on that promise as
`rr` does. Sometimes even a single bit difference in kernel behavior can be problematic!

If these details interest you, I recommend reading Robert's
[technical report](https://arxiv.org/abs/1610.02144) for a deeper overview of
some of `rr`'s design points (though even that only scratches the surface).

One final thought for this section is the origin of the term "time-traveling"
debugger. It stems from the mode of analysis that a system like this enables.
In a traditional debugger, it is possible to execute one instruction at a time,
and step from memory state to memory state in the forwards direction. Systems
like `rr` allow the opposite during replay: step backwards through the state of
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
Recording multiple threads or processes that share memory (as opposed to
using kernel-based message passing) is harder. By default `rr`
serializes (i.e. runs one after the other rather than in parallel)
execution of such tasks. In general, this is
required for correctness, since it is not possible to observe and record the
interleaving of memory operations to shared memory spaces. As a result,
shared-memory applications will likely incur overhead linear in the number of
concurrent threads. It is thus a good idea to try and reproduce any issues at low core count.
There is some interesting academic thinking on high efficiency, parallel recording
of shared memory applications, but nothing even close to being production ready.

With that caveat in mind, here are some real benchmark numbers of overhead for
the julia test suite (as seen on CI). The test suite mostly uses message-passing based
parallelism for running multiple tests in parallel. Only the `threads` test
incurs the shared memory overhead penalty. Below, we plot the overhead of
recording for each test in the julia test suite. Over the entire test suite, the mean
overhead was 50% (i.e. on average a recorded test took 50% longer than a non-
recorded test, say 3s rather than 2s). As expected, the `threads` test is the
worst offender with about 600% overhead. However, a lot of the computational
benchmarks (e.g. in LinearAlgebra or SparseArrays) show very little overhead.
This is expected, because these tests spend a lot of time in user space, which
does not require any data to be recorded.

![overhead](/assets/blog/2020-05-02-rr/data/overhead.svg)

You might wonder why some tests ran faster under rr. I have not investigated
this in detail, but I believe it to be a measurement artifact. The runtime of
tests can depend on what code previously ran on the same worker (since common
code results are cached) and since work is assigned greedily to workers, a change
in the schedule can sometimes result in tests running on a worker that has
already cached some of the work that would have otherwise been necessary to
run the test. Additionally, and fortunately for us, while the mean slow down
is 50% on a test-by-test basis, the overall runtime of the test suite is dominated
by the low-overhead purely computations tests, plus a separate run of the `threads`
test. As a result the increase in total time from running the test suite under
rr is attributable almost entirely to the `threads` test alone.
Surprisingly too, the traces may often be quite small!
The total compressed size of a trace for a full run of the test suite (about
30 minutes on 10 cores) is about three gigabytes. As a point of comparison
this is significantly smaller than a even full-memory coredump would be at the end
of the test suite run (around 10GB or so, though probably decently well compressible
with standard techniques). From the trace, we can not
only reproduce such a core-dump, but every single of the trillions
of intermediate states!

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
    It may be possible to compensate for this in software, but the inaccuracies
    are ill-understood. Help in investigation is welcome ([issue](https://github.com/mozilla/rr/issues/2034)).

- For AArch64, ll/sc-based atomics introduce additional problems, since various
    external factors (interrupts, descheduling, etc.) can be observed as sc aborts.
    With proper hardware support, this would be possible to work around, but such
    hardware support appeared to be inaccurate on older generation AArch64 chips
    and has been removed on recent generation ones. That said, AArch64
    microarchitectures are varied and as evidenced by the x86_64 experience, the
    the quality of implementation of the relevant hardware support can vary quite
    a bit by microarchitecture. Investigation of the hardware
    capabilities of various AArch64 microarchitectures would be very welcome
    ([issue](https://github.com/mozilla/rr/issues/1373)).

- We have looked into `rr` on POWER9, which is found in several large supercomputers
    that run julia jobs. POWER9 has similar issues to AArch64 since it is also an
    ll/sc architecture, as well as supporting hardware transactional memory. In theory,
    we believe the hardware exists to compensate for these issues, but preliminary
    investigation suggests the hardware is not accurate enough to support `rr`. That
    said, I understand there's active discussions with IBM to determine whether this
    analysis is correct.

One additional point of complication, in our experience, is that it is quite common for
hypervisors (such as those used by cloud vendors) to disable the CPU capabilities
required by `rr`, rendering it incapable of functioning inside virtual machines.
`rr` appears works fine on the latest generation of Amazon AWS machines
(above a certain size), but not on Google GCP or Microsoft Azure.

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
than open source ones (the Linux kernel review process tends to filter out
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
likely numbers in the hundreds of thousands. That isn't super large by hardware
vendor standards, but it isn't trivially small either. If any hardware vendor
is interested in making this work, we'd be happy to talk to you (and as I
mentioned, some of this is already in progress).

# A word on privacy

By its nature, an `rr` trace will contain any file touched by the process during
its lifetime. In particular, this may contain things like your julia history,
your process environment (including any secrets you may be automatically adding
to it from bashrc or similar), any configuration files for your system,
any secrets entered or read (i.e. make
sure to use ssh-agent if your reproducer involves using SSH for authentication),
any private code you may be using, etc. We are investigating building tooling
to help understand what's in the trace and anonymize parts of the trace that are
potentially sensitive, but do not otherwise affect the trace.
For the moment, we disable reading the history by default when creating an
rr trace (using the history can be explicitly opted into when necessary
for reproduction). Nevertheless, please make sure to have the system
administrator's permission before using the `--bug-report` feature. If you are
not sure, we recommend creating the reproducer in a sanitized, isolated
environment (e.g. a docker container). Alternatively, while the `--bug-report`
option creates a public upload by default, if you are user that has access to
professional Julia support (e.g. through your employer, supercomputing center
or similar), you may be able to request a mechanism to share traces generated
through this feature privately.

# Future outlook

Being able to replay the traces is only the beginning. I like to say that
with `rr`, debugging becomes a data analysis problem, since the answer to
any question you could possibly ask about the program is already contained in the trace,
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
