---
layout: default
title:  JuliaAudio Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

The [JuliaAudio](https://github.com/JuliaAudio) family of packages defines stream and buffer types useful for working with regularly-sampled signals, in particular digital audio. These packages provide functionality for offline audio processing of audio files, as well as online processing for signals from the sound card, network streams, or files larger than system memory.

## Software-Defined Radio

The types used in the [SampledSignals.jl](https://github.com/JuliaAudio/SampledSignals.jl) library are designed to work with any regularly-sampled signals. Often these are audio signals, but they work equally well for the high samplerate, complex-valued signals found in [software-defined radio](https://en.wikipedia.org/wiki/Software-defined_radio), or SDR. Currently SDR is commonly programmed in C with libraries like [GNURadio](https://www.gnuradio.org/), but Julia's high performance and DSP support make it a promising language to implement SDR algorithms.

**Recommended skills:** Basic DSP, access to SDR hardware

**Expected Results:** A new package for implementing SDR-related DSP, improved interoperability between SampledSignals.jl and DSP.jl

**Mentors:** [Spencer Russell](https://github.com/ssfrr)

## Improved Audio Feature Extraction

There are several good libraries like [librosa](https://librosa.github.io/)(python), [madmom](https://github.com/CPJKU/madmom)(python), and [essentia](http://essentia.upf.edu/documentation/)(C++) that are focused on extracting high-level features useful for speech and music processing. Currently Julia has some features implemented in [MusicProcessing.jl](https://github.com/jongwook/MusicProcessing.jl), along with benchmarks showing impressive performance, but the package is no longer maintained and not as full featured as its counterparts.

**Recommended skills:** Basic Audio DSP

**Expected Results:** An up-to-date and full-featured audio feature extraction package

**Mentors:** [Spencer Russell](https://github.com/ssfrr)

## Julia Music Toolkit

The [PortAudio.jl](https://github.com/JuliaAudio/PortAudio.jl) library provides low-latency access to sound card input and output, but often when working with processing or synthesis for music purposes a higher-level interface is useful. A system similar to [SuperCollider](https://supercollider.github.io/) or [Sonic Pi](http://sonic-pi.net/) could be implemented in Julia to do both sequencing and synthesis, which in most of these systems requires the synthesis to be implemented in C++ for efficiency and the sequencing and higher-level tasks in a more friendly language.
[The Functional Composition talk](https://www.youtube.com/watch?v=Mfsnlbd-4xQ) by Chris Ford is great inspiration for representing music theory in code.
See [here](https://in-thread.sonic-pi.net/t/use-of-erlang-in-sonic-pi/701) for some discussion of various timing and scheduling challenges that drove the Sonic Pi to a combination of Ruby, Erlang, and C++. In general Sam Aaron's work on representing time in a music system is well worth reading.

**Recommended skills:** Basic Audio DSP

**Expected Results:** A new package implementing high-level tools for music-making.

**Mentors:** [Spencer Russell](https://github.com/ssfrr)
