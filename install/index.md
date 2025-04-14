@def title = "Download Julia"

# Installing Julia

The recommended way to install Julia is to install [`juliaup`](https://github.com/JuliaLang/juliaup) which is a small, self-contained binary that will automatically install the latest stable `julia` binary and help keep it up to date. It also supports installing and using different versions of Julia simultaneously.
~~~
<div id="windows-instructions" style="display: none;">
  Install <code>juliaup</code> from the <a href="https://www.microsoft.com/store/apps/9NJNWW8PVKMN">Microsoft Store</a> by running this in the command prompt:
  <pre><code class="language-plaintext cmdprompt-block">winget install --name Julia --id 9NJNWW8PVKMN -e -s msstore</code></pre>
  <div class="install-platform-note"><span id="platform-subnote-windows">It looks like you're using Windows. </span>For Linux and MacOS instructions <a onclick="showUNIX()" href="javascript:void(0);">click here</a></div>
</div>
<div id="unix-instructions" style="display: none;">
  Install <code>juliaup</code> by running this in your terminal:
  <pre><code class="language-plaintext bash-block">curl -fsSL https://install.julialang.org | sh</code></pre>
  <div class="install-platform-note"><span id="platform-subnote-unix">It looks like you're using a Unix-type system. </span>For Windows instructions <a onclick="showWindows()" href="javascript:void(0);">click here</a></div>
</div>
<script>
  function showWindows() {
    document.getElementById('windows-instructions').style.display = 'block';
    document.getElementById('unix-instructions').style.display = 'none';
  }
  function showUNIX() {
    document.getElementById('windows-instructions').style.display = 'none';
    document.getElementById('unix-instructions').style.display = 'block';
  }
  var isWindows = navigator.platform.indexOf('Win') > -1;
  if (isWindows) {
    document.getElementById('platform-subnote-unix').style.display = 'none';
    showWindows();
  } else {
    document.getElementById('platform-subnote-windows').style.display = 'none';
    showUNIX();
  }
</script>
~~~

This will install the latest stable version of Julia, which can be launched from a command-line by typing `julia` as well as the `juliaup` tool. To install different julia versions see `juliaup --help`.

Please star us [on GitHub](https://github.com/JuliaLang/julia). If you use Julia in your research, please [cite us](/research/). If possible, do consider [sponsoring](https://github.com/sponsors/julialang) us.

If you want to manually download and install specific Julia versions, see the [Downloads](/downloads/) page. You can also find out more details about [supported platforms](/downloads/#supported_platforms).

### IP Address Retention Policy
<!--
IF YOU'RE THINKING ABOUT REMOVING THIS NOTE, DON'T. ACCORDING TO OUR LAWYERS, THIS NEEDS TO BE HERE TO COMPLY WITH THE GDPR. YES, IT'S STUPID. I DON'T MAKE THE RULES.
-->
Julia comes with a built-in package manager which downloads and installs packages from the Internet. In doing so, it necessarily reveals your public [IP address](https://en.wikipedia.org/wiki/IP_address) to any server you connect to, and service providers may log your IP address. In Julia versions 1.5 and higher, by default the package manager connects to <https://pkg.julialang.org>, a free public service operated by the Julia project to serve open source package resources to Julia users. This service retains IP address logs for up to 31 days.

### Official domains

The following domains are official and used by open source Julia infrastructure for serving content and resources:

- `julialang.org` and all subdomains
- `julialang.net` and all subdomains

If you are using Julia behind a firewall that blocks access to these, you may have trouble downloading and installing Julia packages. If this is the case, please ask your sysadmin to add these domains to the firewall allow list. Traffic can be limited to HTTPS (TCP port 443).

