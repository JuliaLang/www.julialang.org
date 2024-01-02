
~~~
  <div class="main-download-instructions">
   <div class="main-download-instructions-inner">
    <h2 id="install_julia"> <a href="#install_julia">Install <img src="/assets/infra/logo.svg" class="inline-h2-julia-logo" alt="Julia"></img></h2></a>
    <div class="container pt-sm-2">
      <div class="row" id="windows-instructions" style="display: none;">
        Install Julia from the <a href="https://www.microsoft.com/store/apps/9NJNWW8PVKMN">Microsoft Store</a> by running this in the command prompt:
        <pre><code class="language-plaintext">winget install julia -s msstore</code></pre>
        <span class="install-platform-note"><span id="platform-subnote-windows">It looks like you're using Windows. </span>For Linux and MacOS instructions <a onclick="showOther()" href="javascript:void(0);">click here</a></span>
      </div>
      <div class="row" id="other-platforms-instructions" style="display: none;">
        Install Julia by running this in your terminal:
        <pre><code class="language-plaintext">curl -fsSL https://install.julialang.org | sh</code></pre>
        <span class="install-platform-note"><span id="platform-subnote-other">It looks like you're using a Unix-type system. </span>For Windows instructions <a onclick="showWindows()" href="javascript:void(0);">click here</a></span>
      </div>
      <br>
    </div>
    <script>
      function showWindows() {
        document.getElementById('windows-instructions').style.display = 'block';
        document.getElementById('other-platforms-instructions').style.display = 'none';
      }
      function showOther() {
        document.getElementById('windows-instructions').style.display = 'none';
        document.getElementById('other-platforms-instructions').style.display = 'block';
      }
      var isWindows = navigator.platform.indexOf('Win') > -1;
      if (isWindows) {
        document.getElementById('platform-subnote-other').style.display = 'none';
        showWindows();
      } else {
        document.getElementById('platform-subnote-windows').style.display = 'none';
        showOther();
      }
    </script>
~~~

Once installed `julia` will be available via the command line interface.

This recommended installation method is via the [Juliaup](https://github.com/JuliaLang/juliaup) installation manager, which will automatically install julia and help keep it up to date. The command `juliaup` is also installed. To install different julia versions see `juliaup --help`.

---

Please star us [on GitHub](https://github.com/JuliaLang/julia). If you use Julia in your research, please [cite us](https://julialang.org/research/). If possible, do consider [sponsoring](https://github.com/sponsors/julialang) us.

~~~
   </div>
  </div>
~~~

## Julia Version History

Note that all Julia versions are installable through [Juliaup](#install_julia).

~~~
<h3 id=current_stable_release><a href="#current_stable_release">Current stable release: v{{stable_release}} ({{stable_release_date}})</a></h3>
~~~

Checksums for this release are available in both [MD5](https://julialang-s3.julialang.org/bin/checksums/julia-{{stable_release}}.md5) and [SHA256](https://julialang-s3.julialang.org/bin/checksums/julia-{{stable_release}}.sha256) formats.

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
      <td> macOS x86 (Intel or Rosetta) <a href="/downloads/platform/#macos">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/mac/x64/{{stable_release_short}}/julia-{{stable_release}}-mac64.dmg">.dmg</a>, <a href="https://julialang-s3.julialang.org/bin/mac/x64/{{stable_release_short}}/julia-{{stable_release}}-mac64.tar.gz">.tar.gz</a> </td>
      <td> </td>
    </tr>
    <tr>
      <td> macOS (Apple Silicon) <a href="/downloads/platform/#macos">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/mac/aarch64/{{stable_release_short}}/julia-{{stable_release}}-macaarch64.dmg">.dmg</a>, <a href="https://julialang-s3.julialang.org/bin/mac/aarch64/{{stable_release_short}}/julia-{{stable_release}}-macaarch64.tar.gz">.tar.gz</a> </td>
      <td> </td>
    </tr>
    <tr>
      <td> Generic Linux on x86 <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td>
        <a href="https://julialang-s3.julialang.org/bin/linux/x64/{{stable_release_short}}/julia-{{stable_release}}-linux-x86_64.tar.gz">glibc</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x64/{{stable_release_short}}/julia-{{stable_release}}-linux-x86_64.tar.gz.asc">GPG</a>),
        <a href="https://julialang-s3.julialang.org/bin/musl/x64/{{stable_release_short}}/julia-{{stable_release}}-musl-x86_64.tar.gz">musl</a><sup>[<a href=#musl-fn>1</a>]</sup>
        (<a href="https://julialang-s3.julialang.org/bin/musl/x64/{{stable_release_short}}/julia-{{stable_release}}-musl-x86_64.tar.gz.asc">GPG</a>)
      </td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/x86/{{stable_release_short}}/julia-{{stable_release}}-linux-i686.tar.gz">glibc</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/x86/{{stable_release_short}}/julia-{{stable_release}}-linux-i686.tar.gz.asc">GPG</a>)
      </td>
    </tr>
    <tr>
      <td> Generic Linux on ARM <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{stable_release_short}}/julia-{{stable_release}}-linux-aarch64.tar.gz">AArch64</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{stable_release_short}}/julia-{{stable_release}}-linux-aarch64.tar.gz.asc">GPG</a>)
      </td>
      <td> <!-- <a href="https://julialang-s3.julialang.org/bin/linux/armv7l/{{stable_release_short}}/julia-{{stable_release}}-linux-armv7l.tar.gz">ARMv7-a hard float</a>
                                       (<a href="https://julialang-s3.julialang.org/bin/linux/armv7l/{{stable_release_short}}/julia-{{stable_release}}-linux-armv7l.tar.gz.asc">GPG</a>) -->
      </td>
      </td>
    </tr>
    <tr>
      <td> Generic Linux on PowerPC <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{stable_release_short}}/julia-{{stable_release}}-linux-ppc64le.tar.gz">little endian</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{stable_release_short}}/julia-{{stable_release}}-linux-ppc64le.tar.gz.asc">GPG</a>)
      </td>
      <td>
      </td>
    </tr>
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
<h3 id=long_term_support_release><a href="#long_term_support_release">Long-term support (LTS) release: v{{lts_release}} ({{lts_release_date}})</a></h3>
~~~

Checksums for this release are available in both, [MD5](https://julialang-s3.julialang.org/bin/checksums/julia-{{lts_release}}.md5) and [SHA256](https://julialang-s3.julialang.org/bin/checksums/julia-{{lts_release}}.sha256) formats.


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
      <td> macOS <a href="/downloads/platform/#macos">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/mac/x64/{{lts_release_short}}/julia-{{lts_release}}-mac64.dmg">.dmg</a> </td>
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
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{lts_release_short}}/julia-{{lts_release}}-linux-aarch64.tar.gz">AArch64</a>
          (<a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{lts_release_short}}/julia-{{lts_release}}-linux-aarch64.tar.gz.asc">GPG</a>)
      </td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/armv7l/{{lts_release_short}}/julia-{{lts_release}}-linux-armv7l.tar.gz">ARMv7-a hard float</a>
          (<a href="https://julialang-s3.julialang.org/bin/linux/armv7l/{{lts_release_short}}/julia-{{lts_release}}-linux-armv7l.tar.gz.asc">GPG</a>)
      </td>
    </tr>
    <!--
    <tr>
      <td> Generic Linux on PowerPC <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{lts_release_short}}/julia-{{lts_release}}-linux-ppc64le.tar.gz">little endian</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{lts_release_short}}/julia-{{lts_release}}-linux-ppc64le.tar.gz.asc">GPG</a>)
      </td>
      <td>
      </td>
    </tr>
    -->
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

 We're currently testing release candidates for Julia v{{upcoming_release_short}}, an upcoming minor release in the 1.x series of releases. We encourage developers and interested users to try it out and report any issues they encounter. As a prerelease, it should not be considered production-ready; it's intended to give users a chance to try out {{upcoming_release_short}} with their code before the full release.

Checksums for this release are available in both, [MD5](https://julialang-s3.julialang.org/bin/checksums/julia-{{upcoming_release}}.md5) and [SHA256](https://julialang-s3.julialang.org/bin/checksums/julia-{{upcoming_release}}.sha256) formats.

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
      <td> macOS x86 (Intel or Rosetta) <a href="/downloads/platform/#macos">[help]</a></td>
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
        (<a href="https://julialang-s3.julialang.org/bin/linux/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-x86_64.tar.gz.asc">GPG</a>),
        <a href="https://julialang-s3.julialang.org/bin/musl/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-musl-x86_64.tar.gz">musl</a><sup>[<a href=#musl-fn>1</a>]</sup>
        (<a href="https://julialang-s3.julialang.org/bin/musl/x64/{{upcoming_release_short}}/julia-{{upcoming_release}}-musl-x86_64.tar.gz.asc">GPG</a>)
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
    <tr>
      <td> Generic Linux on PowerPC <a href="/downloads/platform/#linux_and_freebsd">[help]</a></td>
      <td> <a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-ppc64le.tar.gz">little endian</a>
        (<a href="https://julialang-s3.julialang.org/bin/linux/ppc64le/{{upcoming_release_short}}/julia-{{upcoming_release}}-linux-ppc64le.tar.gz.asc">GPG</a>)
      </td>
      <td>
      </td>
    </tr>
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

### Older Releases

Older releases of Julia for all platforms are available on the [Older releases page](/downloads/oldreleases/). Only the LTS and Stable releases are maintained.

### Nightly Builds

Builds of the current unstable development version of Julia are available on the [nightlies page](/downloads/nightlies/). While the name suggests that they are built every night, they are actually built after each commit to master. However, at times due to broken builds or CI infrastructure issues, nightlies may not be produced. These are intended as developer previews into the latest work and are not intended for normal use. Most users are advised to use the current stable release version of Julia.

### Download verification

All Julia binary releases are cryptographically secured using the traditional methods on each platform. macOS and Windows releases are codesigned with certificates that are verified by the operating system during installation. Linux and source tarballs are signed with GPG using [this key](/assets/juliareleases.asc).

---

### Supported platforms

Different OSes and architectures have varying [tiers of support](/downloads/#support_tiers_for_the_latest_stable_release_of_julia). Please see [platform specific instructions](/downloads/platform/) for further installation instructions and if you have trouble installing Julia. If the official binaries do not work for you, please [file an issue in the Julia project](https://github.com/JuliaLang/julia/issues).


@@row @@col-12
~~~
<table class="downloads table table-hover ">
  <tbody>
    <tr>
      <th> Operating System </th>
      <th> OS Version </th>
      <th> Architecture </th>
      <th> Support Tier </th>
    </tr>
    <tr>
      <td rowspan="3"> macOS </td>
      <td> 10.10+ </td>
      <td> x86-64 (64-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> 11.4+ </td>
      <td> ARMv8 (64-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> 10.6+ </td>
      <td> i686 (32-bit) / x86-64 (64-bit) </td>
      <td> <font color="crimson">Tier 3</font> </td>
    </tr>
    <tr>
      <td rowspan="3"> Windows </td>
      <td rowspan="2"> 10+ </td>
      <td> x86-64 (64-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> i686 (32-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> CUDA 10.1</td>
      <td> <a href="https://juliagpu.org/cuda">Nvidia CUDA (64-bit)</a> </td>
      <td> <font color="green">Tier 1</font> </a> </td>
    </tr>
    <tr>
      <td rowspan="8"> Linux (Glibc) </td>
      <td rowspan="5"> 2.6.24+ </td>
      <td> x86-64 (64-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> i686 (32-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> ARMv8 (64-bit) </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td> ARMv7 (32-bit) </td>
      <td> <font color="crimson">Tier 3</font> </td>
    </tr>
    <tr>
      <td> PowerPC (64-bit)  </td>
      <td> <font color="crimson">Tier 3</font>  </td>
    </tr>
    <tr>
      <td> CUDA 10.1</td>
      <td> <a href="https://juliagpu.org/cuda">Nvidia CUDA (64-bit)</a> </td>
      <td> <font color="green">Tier 1</font> </a> </td>
    </tr>
    <tr>
      <td> ROCM </td>
      <td> <a href="https://juliagpu.org/rocm">AMD ROCM (64-bit)</a> </td>
      <td> <font color="crimson">Tier 3</font> </a> </td>
    </tr>
    <tr>
      <td> oneAPI </td>
      <td> <a href="https://juliagpu.org/oneapi">Intel oneAPI (64-bit)</a> </td>
      <td> <font color="crimson">Tier 3</font> </a> </td>
    </tr>
    <tr>
      <td rowspan="1"> Linux (Musl) </td>
      <td rowspan="1"> 2.6.39+ </td>
      <td> x86-64 (64-bit) </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td rowspan="2"> FreeBSD </td>
      <td rowspan="2"> 13.2+ </td>
      <td> x86-64 (64-bit) </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td> i686 (32-bit) </td>
      <td> <font color="crimson">Tier 3</font> </td>
    </tr>
  </tbody>
</table>
~~~
@@ @@

#### Support tiers for the latest stable release of Julia

@@row @@col-12
~~~
<ul>
<li> <font color="green">Tier 1</font>: Julia is guaranteed to build from source and pass all tests on these platforms when built with the default options. Official binaries are always available and CI is run on every commit to ensure support is actively maintained.
<li> <font color="orange">Tier 2</font>: Julia is guaranteed to build from source using the default build options, but may or may not pass all tests. Official binaries are available on a case-by-case basis.
<li> <font color="crimson">Tier 3</font>: Julia may or may not build. If it does, it is unlikely to pass tests. Binaries may be available in some cases. When they are, they should be considered experimental. Ongoing support is dependent on community efforts.
<li> Tier 4: Julia built at some point in the past, but is known not to build currently.
</ul>
~~~
@@ @@

### JSON release feed

The info above is also available as a [JSON file](https://julialang-s3.julialang.org/bin/versions.json) ([schema](https://julialang-s3.julialang.org/bin/versions-schema.json)). It may take up to two hours after the release of a new version for it to be included in the JSON file.

---

<!--
IF YOU'RE THINKING ABOUT REMOVING THIS NOTE, DON'T. ACCORDING TO OUR LAWYERS, THIS NEEDS TO BE HERE TO COMPLY WITH THE GDPR. YES, IT'S STUPID. I DON'T MAKE THE RULES.
-->

**Note:** Julia comes with a built-in package manager which downloads and installs packages from the Internet. In doing so, it necessarily reveals your public [IP address](https://en.wikipedia.org/wiki/IP_address) to any server you connect to, and service providers may log your IP address. In Julia versions 1.5 and higher, by default the package manager connects to <https://pkg.julialang.org>, a free public service operated by the Julia project to serve open source package resources to Julia users. This service retains IP address logs for up to 31 days.
