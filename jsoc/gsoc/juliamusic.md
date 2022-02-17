# Music data analysis - Summer of Code

[JuliaMusic](https://github.com/JuliaMusic) is an organization providing packages and functionalities that allow analyzing the properties of music performances. 

## MIDIfication of music from wave files

**Difficulty**: Medium.

**Length**: 350 hours.

It is easy to analyze timing and intensity fluctuations in music that is the form of MIDI data. 
This format is already digitilized, and packages such as MIDI.jl and MusicManipulations.jl allow for seamless data processing.
But arguably the most interesting kind of music to analyze is the live one.
Live music performances are recorded in wave formats. 
Some algorithms exist that can detect the "onsets" of music hits, 
but they are typically focused only on the timing information and hence forfeit detecting e.g., the intensity of the played note.
Plus, there are very few code implementations online for this problem, almost all of which are old and unmaintained.
We would like to implement an algorithm in MusicProcessing.jl that given a recording of a single instrument, it can
"MIDIfy" it, which means to digitalize it into the MIDI format.

**Recommended Skills**: Background in music, familiarity with digital signal processing.

**Expected results**: A well-tested, well-documented function `midify` in MusicProcessing.jl.

**Mentors**: [George Datseris](https://github.com/Datseris/).

