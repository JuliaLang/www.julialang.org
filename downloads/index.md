@def title = "Installing Julia"

# Installing Julia

~~~
<div id="windows-instructions" style="display: none;">
  Install Julia using the <a href="https://install.julialang.org/Julia.appinstaller">MSIX App Installer</a>. Alternatively, if you have access to the <a href="https://www.microsoft.com/store/apps/9NJNWW8PVKMN">Microsoft Store</a>, you can install Julia by running the following in the command prompt:<br><br>
  <pre><code class="language-plaintext cmdprompt-block">winget install --name Julia --id 9NJNWW8PVKMN -e -s masstore</code></pre>
  <div class="install-platform-note"><span id="platform-subnote-windows">It looks like you are using Windows. </span>
  For Linux and MacOS instructions <a onclick="showUNIX()" href="javascript:void(0);">click here</a>.</div>
</div>
<div id="unix-instructions" style="display: none;">
  Install Julia by running the following in your terminal:<br><br>
  <pre><code class="language-plaintext bash-block">curl -fsSL https://install.julialang.org | sh</code></pre>
  <div class="install-platform-note"><span id="platform-subnote-unix">It looks like you are using a Unix-type system. </span>
  For Windows instructions <a onclick="showWindows()" href="javascript:void(0);">click here</a>.</div>
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

This will install the latest stable version of Julia, as well as the `juliaup` tool. Start Julia from the command-line by typing `julia`.

## Next steps

Join the [community](/community). Check out the [learning resources](/learning). Do star us on [GitHub](https://github.com/JuliaLang/julia). If you use Julia in your research, please [cite us](/research/). If possible, do consider [sponsoring](https://github.com/sponsors/julialang) us.

## About juliaup

[`juliaup`](https://github.com/JuliaLang/juliaup) is the recommended way to install Julia. It automatically installs the latest stable `julia` binary and helps keep it up to date. It also supports installing and using different versions of Julia simultaneously. To install different Julia versions, see `juliaup --help`.

If you need to manually download and install specific Julia versions, see the [Manual Downloads](/downloads/manual-downloads/) page. Julia supports all the major operating systems, but specific versions and architectures have different [tiers of support](/downloads/support).

## Official domains

The following domains are official and used by open source Julia infrastructure for serving content and resources:

- `julialang.org` and all subdomains
- `julialang.net` and all subdomains

If you are using Julia behind a firewall that blocks access to these, you may have trouble downloading and installing Julia packages. If this is the case, please ask your sysadmin to add these domains to the firewall allow list. Traffic can be limited to HTTPS (TCP port 443).

### IP Address Retention Policy
<!--
IF YOU'RE THINKING ABOUT REMOVING THIS NOTE, DON'T. ACCORDING TO OUR LAWYERS, THIS NEEDS TO BE HERE TO COMPLY WITH THE GDPR.
-->
Julia comes with a built-in package manager which downloads and installs packages from the Internet. In doing so, it necessarily reveals your public [IP address](https://en.wikipedia.org/wiki/IP_address) to any server you connect to, and service providers may log your IP address. In Julia versions 1.5 and higher, by default the package manager connects to <https://pkg.julialang.org>, a free public service operated by the Julia project to serve open source package resources to Julia users. This service retains IP address logs for up to 31 days.
