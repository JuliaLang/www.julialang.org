---
layout: default
title:  Julia Downloads
---

# Current Release (v0.3.11)

We provide three ways for you to run Julia:

* In the terminal using the built-in Julia command line.
* The [Juno](http://www.junolab.org) integrated development environment (IDE).
* In the browser on [JuliaBox.org](https://www.juliabox.org) with IJulia notebooks. No installation is required -- just point your browser there, login and start computing.

Plotting capabilities are provided by external packages such as
[PyPlot.jl](https://github.com/stevengj/PyPlot.jl) and
[Gadfly.jl](http://gadflyjl.org). You can also do much more with
[Compose.jl](http://composejl.org), a vector graphics library for
Julia. Look at the [plotting instructions](plotting.html) to install a
plotting package. If you are using JuliaBox, all these plotting
packages are pre-installed.

## Julia (command line version)
<table class="downloads"><tbody>
<tr>
    <th> Windows Self-Extracting Archive (.exe) </th>
    <td> <a href="https://s3.amazonaws.com/julialang/bin/winnt/x86/0.3/julia-0.3.11-win32.exe">32-bit</a> </td>
    <td> <a href="https://s3.amazonaws.com/julialang/bin/winnt/x64/0.3/julia-0.3.11-win64.exe">64-bit</a> </td>
</tr>
<tr>
    <th> Mac OS X Package (.dmg) </th>
    <td colspan="2"> <a href="https://s3.amazonaws.com/julialang/bin/osx/x64/0.3/julia-0.3.11-osx10.7+.dmg">10.7+ 64-bit</a> </td>
</tr>
<tr>
    <th> Ubuntu packages (.deb) </th>
    <td colspan="2"> <a href="https://launchpad.net/~staticfloat/+archive/juliareleases">32/64-bit</a> </td>
</tr>
<tr>
    <th> Fedora/RHEL/CentOS/SL packages (.rpm) </th>
    <td colspan="2"> <a href="https://copr.fedoraproject.org/coprs/nalimilan/julia/">32/64-bit</a> </td>
</tr>
<tr>
    <th> Generic Linux binaries </th>
    <td> <a href="https://julialang.s3.amazonaws.com/bin/linux/x86/0.3/julia-0.3.11-linux-i686.tar.gz">32-bit</a> </td>
    <td> <a href="https://julialang.s3.amazonaws.com/bin/linux/x64/0.3/julia-0.3.11-linux-x86_64.tar.gz">64-bit</a> </td>
</tr>
<tr>
    <th> Source </th>
    <td> <a href="https://github.com/JuliaLang/julia/releases/download/v0.3.11/julia-0.3.11_483dbf5279.tar.gz">Tarball</a> </td>
    <td> <a href="https://github.com/JuliaLang/julia/tree/release-0.3">Github</a> </td>
</tr>
<tr>
    <th> Old releases (not maintained) </th>
    <td colspan="2" ><a href="http://julialang.org/downloads/oldreleases.html">link</a> </td>
</tr>
</tbody></table>

Please see [platform](platform.html) specific instructions if you have
trouble installing Julia.  Checksums for this release are available in both [MD5](https://s3.amazonaws.com/julialang/bin/checksums/julia-0.3.11.md5) and [SHA256](https://s3.amazonaws.com/julialang/bin/checksums/julia-0.3.11.sha256) format.

If the provided download files do not work for you, please [file an
issue in the Julia project](https://github.com/JuliaLang/julia/issues). It is strongly
recommended that you download the v0.3.x binaries to try out Julia,
unless you are working with code that was developed specifically for a
previous release.

## Julia + Juno IDE bundles

Julia works very well when used through the Terminal or Command Prompt interface,
but if you're looking for more IDE-like features (such as integrated code editing
and evaluation) we recommend [Juno](http://junolab.org).

See also the [Juno Documentation](http://junolab.org/docs/) for more
information, or the [discussion forum](http://discuss.junolab.org/)
for questions and help.

<table class="downloads"><tbody>
<tr>
  <th> Windows (7+) </th>
  <td> <a href="https://junolab.s3.amazonaws.com/release/1.0.2/juno-windows-x32.zip">32-bit</a> </td>
  <td> <a href="https://junolab.s3.amazonaws.com/release/1.0.2/juno-windows-x64.zip">64-bit</a> </td>
</tr>
<tr>
  <th> Mac OS X (10.8+)</th>
  <td colspan="2"> <a href="https://junolab.s3.amazonaws.com/release/1.0.2/juno-mac-x64.dmg">64-bit</a> </td>
</tr>
<tr>
  <th> Linux </th>
  <td> <a href="https://junolab.s3.amazonaws.com/release/1.0.2/juno-linux-x32.zip">32-bit</a> </td>
  <td> <a href="https://junolab.s3.amazonaws.com/release/1.0.2/juno-linux-x64.zip">64-bit</a> </td>
</tr>
</tbody></table>

Usage is as simple as downloading the bundle, extracting it and double-clicking
the Juno executable or app.

---

# Nightly builds

These are bleeding-edge binaries of the latest version of Julia under
development, which you can use to get a preview of the latest work.  However,
because Julia is under heavy development, you may be unlucky and get a
build with a serious bug, or one which breaks existing packages.  Most users
are advised to use the latest official release version of Julia, above.

<table class="downloads"><tbody>
<tr>
    <th> Windows Self-Extracting Archive (.exe) </th>
    <td> <a href="https://status.julialang.org/download/win32">32-bit</a> </td>
    <td> <a href="https://status.julialang.org/download/win64">64-bit</a> </td>
</tr>
<tr>
    <th> Mac OS X Package (.dmg) </th>
    <td colspan="2"> <a href="https://status.julialang.org/download/osx10.7+">10.7+ 64-bit</a> </td>
</tr>
<tr>
    <th> Ubuntu packages (.deb) </th>
    <td colspan="2"> <a href="https://launchpad.net/~staticfloat/+archive/julianightlies">32/64-bit</a> </td>
</tr>
<tr>
    <th> Fedora/RHEL/CentOS/SL packages (.rpm) </th>
    <td colspan="2"> <a href="https://copr.fedoraproject.org/coprs/nalimilan/julia-nightlies/">32/64-bit</a> </td>
</tr>
<tr>
    <th> Generic Linux binaries </th>
    <td> <a href="https://status.julialang.org/download/linux-i686">32-bit</a> </td>
    <td> <a href="https://status.julialang.org/download/linux-x86_64">64-bit</a> </td>
</tr>
<tr>
    <th> Source </th>
    <td colspan="2"> <a href="https://github.com/JuliaLang/julia">GitHub</a> </td>
</tr>
</tbody></table>
