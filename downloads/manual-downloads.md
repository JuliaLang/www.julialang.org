@def title = "Manual Downloads"

# Manual Downloads

\note{Use juliaup for typical installations}{See the [installation instructions](/downloads/) on using `juliaup` to install the official Julia binaries. Users who are unable to use `juliaup` or require a specific, atypical setup may manually download and install the binaries from this page. If these binaries do not work for you, please [file an issue in the Julia project](https://github.com/JuliaLang/julia/issues).}

~~~
<h4 id=current_stable_release><a href="#current_stable_release">Current stable release: v{{stable_release}} ({{stable_release_date}})</a></h4>
~~~

[Release notes](https://github.com/JuliaLang/julia/blob/v{{stable_release}}/NEWS.md) | [GitHub tag](https://github.com/JuliaLang/julia/releases/tag/v{{stable_release}}) | [SHA256 checksums](https://julialang-s3.julialang.org/bin/checksums/julia-{{stable_release}}.sha256) | [MD5 checksums](https://julialang-s3.julialang.org/bin/checksums/julia-{{stable_release}}.md5)

@@row @@col-12
~~~
<table class="downloads table table-hover table-bordered">
  <tbody>
    <tr>
      <th> Platform</th>
      <th> 64-bit</th>
      <th> 32-bit</th>
    </tr>
    <tr>
      <td> Windows <a href="/downloads/platform/#windows">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/winnt/x64/{{stable_release_short}}/julia-{{stable_release}}-win64.exe">installer</a>, <a href="https://julialang-s3.julialang.org/bin/winnt/x64/{{stable_release_short}}/julia-{{stable_release}}-win64.zip">portable</a> </td>
      <td> <a href="https://julialang-s3.julialang.org/bin/winnt/x86/{{stable_release_short}}/julia-{{stable_release}}-win32.exe">installer</a>,  <a href="https://julialang-s3.julialang.org/bin/winnt/x86/{{stable_release_short}}/julia-{{stable_release}}-win32.zip">portable</a> </td> </td>
    </tr>
    <tr>
      <td> macOS (Apple Silicon) <a href="/downloads/platform/#macos">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/mac/aarch64/{{stable_release_short}}/julia-{{stable_release}}-macaarch64.dmg">.dmg</a>, <a href="https://julialang-s3.julialang.org/bin/mac/aarch64/{{stable_release_short}}/julia-{{stable_release}}-macaarch64.tar.gz">.tar.gz</a> </td>
      <td> </td>
    </tr>
    <tr>
      <td> macOS (Intel x86) <a href="/downloads/platform/#macos">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/mac/x64/{{stable_release_short}}/julia-{{stable_release}}-mac64.dmg">.dmg</a>, <a href="https://julialang-s3.julialang.org/bin/mac/x64/{{stable_release_short}}/julia-{{stable_release}}-mac64.tar.gz">.tar.gz</a> </td>
      <td> </td>
    </tr>
    <tr>
      <td> Generic Linux on x86 <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td>
        <a href="https://julialang-s3.julialang.org/bin/linux/x64/{{stable_release_short}}/julia-{{stable_release}}-linux-x86_64.tar.gz">glibc</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x64/{{stable_release_short}}/julia-{{stable_release}}-linux-x86_64.tar.gz.asc">GPG</a>)<!--,
        <a href="https://julialang-s3.julialang.org/bin/musl/x64/{{stable_release_short}}/julia-{{stable_release}}-musl-x86_64.tar.gz">musl</a><sup>[<a href=#musl-fn>1</a>]</sup>
        (<a href="https://julialang-s3.julialang.org/bin/musl/x64/{{stable_release_short}}/julia-{{stable_release}}-musl-x86_64.tar.gz.asc">GPG</a>)-->
      </td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/x86/{{stable_release_short}}/julia-{{stable_release}}-linux-i686.tar.gz">glibc</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x86/{{stable_release_short}}/julia-{{stable_release}}-linux-i686.tar.gz.asc">GPG</a>)
      </td>
    </tr>
    <tr>
      <td> Generic Linux on ARM <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{stable_release_short}}/julia-{{stable_release}}-linux-aarch64.tar.gz">.tar.gz</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{stable_release_short}}/julia-{{stable_release}}-linux-aarch64.tar.gz.asc">GPG</a>)
      </td>
      <td> <!-- <a href="https://julialang-s3.julialang.org/bin/linux/armv7l/{{stable_release_short}}/julia-{{stable_release}}-linux-armv7l.tar.gz">ARMv7-a hard float</a>
                                       (<a href="https://julialang-s3.julialang.org/bin/linux/armv7l/{{stable_release_short}}/julia-{{stable_release}}-linux-armv7l.tar.gz.asc">GPG</a>) -->
      </td>
      </td>
    </tr>
    <!--
    <tr>
      <td> Generic Linux on PowerPC <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{stable_release_short}}/julia-{{stable_release}}-linux-ppc64le.tar.gz">little endian</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{stable_release_short}}/julia-{{stable_release}}-linux-ppc64le.tar.gz.asc">GPG</a>)
      </td>
      <td>
      </td>
    </tr>
    -->
    <tr>
      <td> Generic FreeBSD on x86 <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/freebsd/x64/{{stable_release_short}}/julia-{{stable_release}}-freebsd-x86_64.tar.gz">.tar.gz</a>
        (<a href="https://julialang-s3.julialang.org/bin/freebsd/x64/{{stable_release_short}}/julia-{{stable_release}}-freebsd-x86_64.tar.gz.asc">GPG</a>)
      </td>
      <td> </td>
    </tr>
  </tbody>
</table>
<table>
  <tbody>
    <tr>
      <th> Source </th>
      <td> <a href="https://github.com/JuliaLang/julia/releases/download/v{{stable_release}}/julia-{{stable_release}}.tar.gz">Tarball</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v{{stable_release}}/julia-{{stable_release}}.tar.gz.asc">GPG</a>)
      </td>
      <td> <a href="https://github.com/JuliaLang/julia/releases/download/v{{stable_release}}/julia-{{stable_release}}-full.tar.gz">Tarball with dependencies</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v{{stable_release}}/julia-{{stable_release}}-full.tar.gz.asc">GPG</a>)
      </td>
      <td> <a href="https://github.com/JuliaLang/julia/tree/v{{stable_release}}">GitHub</a> </td>
    </tr>
  </tbody>
</table>
~~~
@@ @@

Almost everyone should be downloading and using the latest stable release of Julia.
Great care is taken not to break compatibility with older Julia versions, so older code should continue to work with the latest stable Julia release.
You should *only* be using the long-term support (LTS) version of Julia if you work at an organization where implementing or certifying upgrades is prohibitively expensive and there is no need for new language features or packages. See this description of ["Risk Personas"](https://julialang.org/blog/2019/08/release-process/#risk_tolerance_personas) for more detail on who should be using what versions of Julia based on their risk tolerance. See this blog post on [Julia's Release Process](https://julialang.org/blog/2019/08/release-process/) for more information on different kinds of releases.



~~~
<h4 id=long_term_support_release><a href="#long_term_support_release">Long-term support (LTS) release: v{{lts_release}} ({{lts_release_date}})</a></h4>
~~~

[Release notes](https://github.com/JuliaLang/julia/blob/v{{lts_release}}/NEWS.md) | [GitHub tag](https://github.com/JuliaLang/julia/releases/tag/v{{lts_release}}) | [SHA256 checksums](https://julialang-s3.julialang.org/bin/checksums/julia-{{lts_release}}.sha256) | [MD5 checksums](https://julialang-s3.julialang.org/bin/checksums/julia-{{lts_release}}.md5)

@@row @@col-12
~~~
<table class="downloads table table-hover table-bordered">
  <tbody>
    <tr>
      <th> Platform</th>
      <th> 64-bit</th>
      <th> 32-bit</th>
    </tr>
    <tr>
      <td> Windows <a href="/downloads/platform/#windows">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/winnt/x64/{{lts_release_short}}/julia-{{lts_release}}-win64.exe">installer</a>, <a href="https://julialang-s3.julialang.org/bin/winnt/x64/{{lts_release_short}}/julia-{{lts_release}}-win64.zip">portable</a> </td>
      <td> <a href="https://julialang-s3.julialang.org/bin/winnt/x86/{{lts_release_short}}/julia-{{lts_release}}-win32.exe">installer</a>,  <a href="https://julialang-s3.julialang.org/bin/winnt/x86/{{lts_release_short}}/julia-{{lts_release}}-win32.zip">portable</a> </td> </td>
    </tr>
    <tr>
      <td> macOS (Apple Silicon) <a href="/downloads/platform/#macos">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/mac/aarch64/{{lts_release_short}}/julia-{{lts_release}}-macaarch64.dmg">.dmg</a>, <a href="https://julialang-s3.julialang.org/bin/mac/aarch64/{{lts_release_short}}/julia-{{lts_release}}-macaarch64.tar.gz">.tar.gz</a> </td>
      <td> </td>
    </tr>
    <tr>
      <td> macOS (Intel x86) <a href="/downloads/platform/#macos">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/mac/x64/{{lts_release_short}}/julia-{{lts_release}}-mac64.dmg">.dmg</a>, <a href="https://julialang-s3.julialang.org/bin/mac/x64/{{lts_release_short}}/julia-{{lts_release}}-mac64.tar.gz">.tar.gz</a> </td></td>
      <td> </td>
    </tr>
    <tr>
      <td> Generic Linux on x86 <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td>
        <a href="https://julialang-s3.julialang.org/bin/linux/x64/{{lts_release_short}}/julia-{{lts_release}}-linux-x86_64.tar.gz">glibc</a>
          (<a href="https://julialang-s3.julialang.org/bin/linux/x64/{{lts_release_short}}/julia-{{lts_release}}-linux-x86_64.tar.gz.asc">GPG</a>),
        <a href="https://julialang-s3.julialang.org/bin/musl/x64/{{lts_release_short}}/julia-{{lts_release}}-musl-x86_64.tar.gz">musl</a><sup>[<a href=#musl-fn>1</a>]</sup>
        (<a href="https://julialang-s3.julialang.org/bin/musl/x64/{{lts_release_short}}/julia-{{lts_release}}-musl-x86_64.tar.gz.asc">GPG</a>)
      </td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/x86/{{lts_release_short}}/julia-{{lts_release}}-linux-i686.tar.gz">glibc</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x86/{{lts_release_short}}/julia-{{lts_release}}-linux-i686.tar.gz.asc">GPG</a>)
      </td>
    </tr>
    <tr>
      <td> Generic Linux on ARM <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{lts_release_short}}/julia-{{lts_release}}-linux-aarch64.tar.gz">.tar.gz</a>
          (<a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{lts_release_short}}/julia-{{lts_release}}-linux-aarch64.tar.gz.asc">GPG</a>)
      </td>
      <td> <!-- <a href="https://julialang-s3.julialang.org/bin/linux/armv7l/{{lts_release_short}}/julia-{{lts_release}}-linux-armv7l.tar.gz">ARMv7-a hard float</a>
          (<a href="https://julialang-s3.julialang.org/bin/linux/armv7l/{{lts_release_short}}/julia-{{lts_release}}-linux-armv7l.tar.gz.asc">GPG</a>) -->
      </td>
    </tr>
    <tr>
      <td> Generic Linux on PowerPC <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{lts_release_short}}/julia-{{lts_release}}-linux-ppc64le.tar.gz">little endian</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{lts_release_short}}/julia-{{lts_release}}-linux-ppc64le.tar.gz.asc">GPG</a>)
      </td>
      <td>
      </td>
    </tr>
    <tr>
      <td> Generic FreeBSD on x86 <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/freebsd/x64/{{lts_release_short}}/julia-{{lts_release}}-freebsd-x86_64.tar.gz">.tar.gz</a>
          (<a href="https://julialang-s3.julialang.org/bin/freebsd/x64/{{lts_release_short}}/julia-{{lts_release}}-freebsd-x86_64.tar.gz.asc">GPG</a>)
      </td>
      <td> </td>
    </tr>
  </tbody>
</table>
<table>
  <tbody>
    <tr>
      <th> Source </th>
      <td> <a href="https://github.com/JuliaLang/julia/releases/download/v{{lts_release}}/julia-{{lts_release}}.tar.gz">Tarball</a>
            (<a href="https://github.com/JuliaLang/julia/releases/download/v{{lts_release}}/julia-{{lts_release}}.tar.gz.asc">GPG</a>)
      </td>
      <td> <a href="https://github.com/JuliaLang/julia/releases/download/v{{lts_release}}/julia-{{lts_release}}-full.tar.gz">Tarball with dependencies</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v{{lts_release}}/julia-{{lts_release}}-full.tar.gz.asc">GPG</a>)
      </td>
      <td> <a href="https://github.com/JuliaLang/julia/tree/v{{lts_release}}">GitHub</a> </td>
    </tr>
  </tbody>
</table>
~~~
@@ @@

{{ifdef upcoming_release}}

~~~
<h3 id=upcoming_release><a href="#upcoming_release">Upcoming release: v{{upcoming_release}} ({{upcoming_release_date}})</a></h3>
~~~

We're currently testing a prerelease for Julia v{{upcoming_release_short}}, an upcoming minor release in the 1.x series of releases. We encourage developers and interested users to try it out and report any issues they encounter. As a prerelease, it should not be considered production-ready; it's intended to give users a chance to try out {{upcoming_release_short}} with their code before the full release.

[Release notes](https://github.com/JuliaLang/julia/blob/v{{upcoming_release}}/NEWS.md) | [GitHub tag](https://github.com/JuliaLang/julia/releases/tag/v{{upcoming_release}}) | [SHA256 checksums](https://julialang-s3.julialang.org/bin/checksums/julia-{{upcoming_release}}.sha256) | [MD5 checksums](https://julialang-s3.julialang.org/bin/checksums/julia-{{upcoming_release}}.md5)

@@row @@col-12
~~~
<table class="downloads table table-hover  table-bordered">
  <tbody>
    <tr>
      <th> Platform</th>
      <th> 64-bit</th>
      <th> 32-bit</th>
    </tr>
    <tr>
      <td> Windows <a href="/downloads/platform/#windows">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/winnt/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-win64.exe">installer</a>, <a href="https://julialang-s3.julialang.org/bin/winnt/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-win64.zip">portable</a> </td>
      <td> <a href="https://julialang-s3.julialang.org/bin/winnt/x86/{{upcoming_release_short}}/julia-{{upcoming_release}}-win32.exe">installer</a>,  <a href="https://julialang-s3.julialang.org/bin/winnt/x86/{{upcoming_release_short}}/julia-{{upcoming_release}}-win32.zip">portable</a> </td> </td>
    </tr>
    <tr>
      <td> macOS (Intel x86) <a href="/downloads/platform/#macos">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/mac/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-mac64.dmg">.dmg</a> </td>
      <td> </td>
    </tr>
    <tr>
      <td> macOS (Apple Silicon) <a href="/downloads/platform/#macos">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/mac/aarch64/{{upcoming_release_short}}/julia-{{upcoming_release}}-macaarch64.dmg">.dmg</a> </td>
      <td> </td>
    </tr>
    <tr>
      <td> Generic Linux on x86 <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td>
        <a href="https://julialang-s3.julialang.org/bin/linux/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-x86_64.tar.gz">glibc</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-x86_64.tar.gz.asc">GPG</a>)<!--,
        <a href="https://julialang-s3.julialang.org/bin/musl/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-musl-x86_64.tar.gz">musl</a><sup>[<a href=#musl-fn>1</a>]</sup>
        (<a href="https://julialang-s3.julialang.org/bin/musl/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-musl-x86_64.tar.gz.asc">GPG</a>)-->
      </td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/x86/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-i686.tar.gz">glibc</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x86/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-i686.tar.gz.asc">GPG</a>)
      </td>
    </tr>
    <tr>
      <td> Generic Linux on ARM <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-aarch64.tar.gz">AArch64</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-aarch64.tar.gz.asc">GPG</a>)
      </td>
      <td> <!-- <a href="https://julialang-s3.julialang.org/bin/linux/armv7l/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-armv7l.tar.gz">ARMv7-a hard float</a>
                                       (<a href="https://julialang-s3.julialang.org/bin/linux/armv7l/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-armv7l.tar.gz.asc">GPG</a>) -->
      </td>
      </td>
    </tr>
    <!--
    <tr>
      <td> Generic Linux on PowerPC <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-ppc64le.tar.gz">little endian</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-ppc64le.tar.gz.asc">GPG</a>)
      </td>
      <td>
      </td>
    </tr>
    -->
    <tr>
      <td> Generic FreeBSD on x86 <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/freebsd/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-freebsd-x86_64.tar.gz">.tar.gz</a>
        (<a href="https://julialang-s3.julialang.org/bin/freebsd/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-freebsd-x86_64.tar.gz.asc">GPG</a>)
      </td>
      <td> </td>
    </tr>
  </tbody>
</table>
<table>
  <tbody>
    <tr>
      <th> Source </th>
      <td> <a href="https://github.com/JuliaLang/julia/releases/download/v{{upcoming_release}}/julia-{{upcoming_release}}.tar.gz">Tarball</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v{{upcoming_release}}/julia-{{upcoming_release}}.tar.gz.asc">GPG</a>)
      </td>
      <td> <a href="https://github.com/JuliaLang/julia/releases/download/v{{upcoming_release}}/julia-{{upcoming_release}}-full.tar.gz">Tarball with dependencies</a>
        (<a href="https://github.com/JuliaLang/julia/releases/download/v{{upcoming_release}}/julia-{{upcoming_release}}-full.tar.gz.asc">GPG</a>)
      </td>
      <td> <a href="https://github.com/JuliaLang/julia/tree/v{{upcoming_release}}">GitHub</a> </td>
    </tr>
  </tbody>
</table>
~~~
@@ @@

{{end}} <!-- upcoming_release -->


\label{musl-fn}
~~~
<sup>[1]</sup>
~~~
Most Linux users should use the glibc binaries unless you know that your system uses musl as its libc.

## Supported platforms and tiers

Julia supports all the major operating systems, but specific versions and architectures have different [tiers of support](/downloads/support).

## Avoid external package managers

Please do not use Julia shipped by Linux or BSD package managers. Many Linux/BSD/Unix package managers ship broken and/or significantly out of date versions of Julia. Please use [`juliaup`](/downloads) or download the official binaries instead.

### Older Releases

Older releases of Julia for all platforms are available on the [Older releases page](/downloads/oldreleases/). Only the LTS and Stable releases are maintained.

### Nightly Builds

Builds of the current unstable development version of Julia are available on the [nightlies page](/downloads/nightlies/). While the name suggests that they are built every night, they are actually built after each commit to master. However, at times due to broken builds or CI infrastructure issues, nightlies may not be produced. These are intended as developer previews into the latest work and are not intended for normal use. Most users are advised to use the current stable release version of Julia.

### Download verification

All Julia binary releases are cryptographically secured using the traditional methods on each platform. macOS and Windows releases are codesigned with certificates that are verified by the operating system during installation. Linux and source tarballs are signed with GPG using [this key](/assets/juliareleases.asc).

### JSON release feed

The info above is also available as a [JSON file](https://julialang-s3.julialang.org/bin/versions.json) ([schema](https://julialang-s3.julialang.org/bin/versions-schema.json)). It may take up to two hours after the release of a new version for it to be included in the JSON file.
