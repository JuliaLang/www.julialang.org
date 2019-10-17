---
layout: post
title: 'Shell escaping: 2 truths and a lie'
author: <a href="http://github.com/vtjnash/">Jameson Nash</a>
---

[Put This In Your Pipe]:  {% post_url blog/2013-04-08-put-this-in-your-pipe %}
[`Distributed`]: https://docs.julialang.org/en/v1/stdlib/Distributed/#Distributed.WorkerConfig

# What is escaping?
{:.no_toc}

This is a very common task when manipulating any sort of data. But what is it?
And how do we know when we need it?

String escaping is the mechanism for avoiding whole classes of problems when
working with data exchange, including metacharacter breakage, command injection,
and rendering errors. In the networking world, it's also an aspect of framing
and stream decoding.

Sound complicated? It shouldn't be! It just requires careful understanding of
the list of decoders between the source and destination, and working backwards.

Subsequently, I'm going to just use the term "decoder" as the broadest class of
transformation. Note that while this could mean encryption, it also applies to
any other textual transform, including parsers and compressors. They don't even
need to be lossless--they just need to be deterministic.

For example, when passing arguments through a [shell](#posix-shell) to a
target program, the user needs to take various steps to ensure the string
arrives intact, and that the shell doesn't get confused by the presence of an
unexpected meta-character.

As explained in a much earlier post titled [Put This In Your Pipe], Julia tries
to help you avoid this by avoiding passing the data through the shell.

This ensures that variables spliced into the command with `$` are not further
processed, since the complete meta-character interpretation step already
occurred while parsing the Julia code.

But sometimes, this isn't possible.

For example, when launching [`Distributed`]() jobs with `exeflags`, we know the
arguments are going to be passed to `ssh` and then to the user's shell (usually
some variant on `sh`), before getting to the command line parser of Julia on the
target machine. This reveals one strategy for dealing with these though: define
an API that accepts raw strings and encodes them internally. But what if you are
in charge of writing that code? Well, that's the situation I found myself in.

However, as I was doing research into the proper steps for handling `powershell`
(also known as `pwsh`), I found that most resources fell short of explaining the
proper and necessary steps for handling arbitrary user input. Instead they
focused only on the ability for a programmer to write arbitrary code.
While also useful to know various alternatives, they would over-complicate the
matter for implementing it mechanically.

I feel it's important to note before jumping in that there are many possible
encodings which all will yield the same output. The purpose here is generally
to pick the strategy that will yield the most reasonable output with the fewest
rules.

# Strategy
{:.no_toc}

Now let's lay out our strategy. Remember that when I use the term "decoder", it
applies to any sort of transform to the input data.

1. Start with the input text. This may be one argument, or a whole list of them.
2. Identify the list of decoders that the text will need to pass through. This
   might not be the same for each argument, although it usually is.
3. Reverse that list (for each argument).
4. For each item in that list of decoders, apply the corresponding encoder from
   the list below.
5. Add any additional arguments required at this stage of the pipeline.

Be aware that some encoders may take the whole argument list at once (consider
`tar`), while others might only take one argument, but could output multiple
results (consider `zipsplit`). Thus some pipelines are impossible.

# Table of Contents:
{:.no_toc}

* TOC will be placed here
{:toc}

# String?

To encode "string" data, it typically requires knowing exactly which parser will be used.
Many cases have very similar parsers, so some are able to handle by selecting a
conservative superset.

For the Unicode strings itself, there are numerous encodings. Common ones
include UTF-8 and UTF-16. I will not cover specific here, as libraries to handle
these are readily available.

## Out-of-band

One elegant strategy for dealing with framing is simply to pass the delimiters
out-of-band. When calling a program on a Unix machine, the list of arguments
gets passed as an actual list (`char **argv`). This let's us use the identify
transform, and essentially just ignore it--the same is not true on Windows,
which we will cover later.

## C string

[`Base.escape_string`]: https://docs.julialang.org/en/v1/base/strings/#Base.unescape_string

General encoding of Unicode strings, such as for embedding into a C program
file, is implemented in the [`Base.escape_string`] function. This is implemented
as follows:

Backslashes and quotes (`\\` and `"`) are escaped with a backslash (`\\\\` and
`\\"`). Non-printable characters are escaped either with their standard C escape
codes, `"\\0"` for NUL (if unambiguous), unicode code point (`"\\u"` prefix) or
hex (`"\\x"` prefix).

## Julia string

[`repr`]: https://docs.julialang.org/en/v1/base/strings/#Base.repr-Tuple{Any}

Encoding Julia strings can be done by calling the [`repr`] function. This is
similar to other [Unicode string](#c-string), but also escapes the `$` character
with a backslack (`\\$`).

## Julia "raw" strings

In Julia, another option to represent strings is to use the so-called "raw
string" format. The description of this is fairly lengthy, but the textual
examples tend to be very straight-forward. It is also the same algorithm we'll
see later in [CommandLineToArgv](#commandlinetoargv). The algorithm is:

All quotation marks must be escaped, and any backslashes that precede them.
Only when a sequence of backslashes precedes a quote character. Thus, 2n
backslashes followed by a quote encodes n backslashes and the end of the literal
while 2n+1 backslashes followed by a quote encodes n backslashes followed by a
quote character. Anywhere else, each n backslashes simply encodes for n
backslashes.

# HTML

[`encodeURIComponent`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent
[`HTTP.escapeuri`]: https://juliaweb.github.io/HTTP.jl/stable/public_interface/#HTTP.URIs.escapeuri
[`Node.textContent=`]: https://developer.mozilla.org/en-US/docs/Web/API/Node/textContent
[`Element.setAttribute`]: https://developer.mozilla.org/en-US/docs/Web/API/Element/setAttribute
[`HTTP.escapehtml`]: https://juliaweb.github.io/HTTP.jl/stable/public_interface/#HTTP.Strings.escapehtml

The web is such an important factor in programming, I felt this was worth
including. I've put this under one label, but it's important to realize there
are actually more than 3 distinct cases here that must be handled.

 * URLs (URIs, parameter strings): the escape character here is `%`, and the
   special characters are all _bytes_ (UTF-8) except "A-Z a-z 0-9 - _ . ! ~ * '
   ( )". Each byte that is not one of those characters is replaced by `%xx`,
   where `xx` is the hex value of the byte being escaped. Ref JavaScript
   [`encodeURIComponent`] and Julia [`HTTP.escapeuri`].
 * HTML body: the escape character here is `&`, and the special characters are
   "< > &", with replacements "&lt; &gt; &amp;", respectively. Ref JavaScript
   [`Node.textContent=`] and Julia [`HTTP.escapeuri`].
 * HTML attributes: the escape character here is also `&`, but the special
   characters are `&` and either `'` or `"` (depending on the choice of
   surrounding delimiter). The escaped replacements for the latter two are
   `&#39;` and `&quot;`. Additionally, it may need to be wrapped in single or
   double quotes to escape white space. Since this uses the same escape
   character as HTML body, it is possible to write an encoder that will be valid
   for both. Alternatively, white-space (and any other characters) may be
   escaped instead by replacing it with `&#nnnn;` or `&#xhhhh;`, where `nnnn` is
   the decimal value of the code point (character, not byte like in URLs) or
   `hhhh` is the hex value. Ref JavaScript [`Element.setAttribute`].
 * JavaScript (JSON, JSONP): This can use same handling as [C
   string](#c-string), excluding malformed characters which would typically use
   the `\\xhhhh` form. As described above, is sufficient to only escape `\\` and
   `"` plus any control codes (characters below 0x20).

# Base64

If you have control over some parts of the decoding pipeline, a popular strategy
is to base64-encode the input string early. This can turn many future stages
(until the decode) into the identity function, reducing the risk of accidentally
hitting a buggy decoder or forgetting to handle a stage.

As with Unicode encoding, there are many libraries and other good resources on
this, so I will not go into further detail.

# RegEx

There are many special characters in regular expressions. One strategy would be
to enumerate all of these ("[({})]+.\*?\\" etc.) and escape them with a
backslash. An alternate strategy is to wrap the verbatim string in `\\Q`
(quoted) ... `\\E` (end). That only leaves one character pairing to escape,
`\\E`, for which the escape sequence is the replacement string is the five
characters `\\E\QE`.

# Unix derivatives

Unix programs tend to use a wide and diverse set of decoders. However, encoding
only requires picking the common subset that will be get consistent handling.

## Posix Shell

[`Base.shell_escape_posixly`]: https://github.com/JuliaLang/julia/blob/v1.2.0/base/shell.jl#L232
[`join`]: https://docs.julialang.org/en/v1/base/strings/#Base.join

The posix shell (`sh`) has spawned many numerous variants, such as `bash` (GNU
Bourne-Again SHell), `tcsh` (C shell), `busybox`, `ksh` (KornShell), and `zsh`
(Z shell), (you can find the list for your machine in `/etc/shells`).
Additionally, it's spawned clones in many languages, including Julia ("\`\`"
command literal syntax). These each have distinct and varied ways in which they
will interpret special characters, and different orderings to their
interpretation and expansion phases.

Fortunately, however, the goal of string escaping is to ensure all of those
complex and varied phases will be inactivate on our arguments. And further, they
all treat `'` as defining a raw string literal.

This gives a very simple, complete rule: wrap each argument in a pair of `'`'s,
and replace any internal `'`'s with the escape sequence `'\''`.

In Julia, this functionality is provided by the [`Base.shell_escape_posixly`]
function. It additionally implements some printing simplifications, such as
detecting when the `'` aren't necessary at all or could be substituted
preferentially for `"`. Those provide nicer output, but aren't required.

This is actually the combination of two steps in the pipeline:
 * Joining the arguments into a single string, by simply concatenating them
   with spaces (For example, by using [`join`]).
 * Encoding each argument separately, to hide any shell-metacharacters from
   later stages in the pipeline.
They are combined into one step for convenience since there's no loss of
generality to provide such an interface.

## Posix programs

In addition to the intermediate shell, it's necessary to consider how the target
application will parse the command line. This is not a step you may normally
think of being in the pipeline, but for stronger robustness, it may be
necessary to consider carefully[^1] these nuances.

 * The `PATH` variable, as used by `execvp` to find programs, uses `:` as the
   delimiter between entries. As such, you can't have a path with an embedded
   `:` in the search PATH as the decoder has no escape sequence for it.
 * Some programs (such as `find`) will output lists of file paths separated by
   white space. As such, you would get incorrect or ambiguous answers if a file
   name happened to contain white space. Some such programs define an alternate
   output mode intended for such uses that uses a nul character as a separate
   instead (which is not valid to appear in a file path). For `find`, this
   option is named `-print0`.
 * Most programs will interpret an argument starting with a `-` as giving a
   command line option rather than a value. For many programs, this means you
   should put a `--` in the argument list, to first terminate option parsing
   before giving the user argument. For example, `rm -- $filename`.

[^1] In fact, if there is a concern of adversarial input, it may be better to
entirely avoid passing the data to the external program in this way, since it
can be hard to realize all of the edge cases. Instead, you may want to consider
[Base64 encoding](#base64), passing the value in a [side channel](#out-of-band)
such as `stdin`, or using the builtin features of the current language instead
of a posix tool.

# Windows

On Windows, the situation is a bit different from on Unix. When transitioning
between these systems, it's important to be aware of this, because it impacts
how some of the stages in the pipeline operate.

In particular, the command line arrives at the target application as a single
string, and is then responsible for interpreting it. Unlike with `posix`, each
program is expected to implement their own shell and glob capabilities (if
relevant), since this interface means that the shell cannot do it.

So unlike in Unix, where we observe that the shell does significant
preprocessing of the input and turns the command input into a list of arguments
and then does further processing on that, on Windows we observe that the shell
only does some initial preprocessing to identify line breaks.

## CommandLineToArgv

This function is responsible for turning the command line string into a list of
arguments suitable for passing to the `main` function of a C program.
But it doesn't get used by every program (notable exceptions include
[`.Net`](#net) and [`Cmd`](#cmd-not-dos)).

This uses the same format as Julia "raw" strings described before:

> All quotation marks must be escaped, and any backslashes that precede them.
Only when a sequence of backslashes precedes a quote character. Thus, 2n
backslashes followed by a quote encodes n backslashes and the end of the literal
while 2n+1 backslashes followed by a quote encodes n backslashes followed by a
quote character. Anywhere else, each n backslashes simply encodes for n
backslashes.

todo: See also resources

## .Net

todo: I don't know what this really does, but here's what the documentation
says:

https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.processstartinfo.arguments?view=netframework-4.8#System_Diagnostics_ProcessStartInfo_Arguments

## Cmd (not DOS)

This one is actually quite simple, but won't fit into you mental model at all if
you try to understand this like it is a posix shell.

## Powershell and pwsh

### Powershell parser

### Powershell cmdlets

### Powershell -Command

### Powershell special rules

### Powershell special commands


# Other
(e.g. strategy for writing your own)


---

[^1]: footnote
