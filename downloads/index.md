@def title = "Installing Julia"

~~~
<div class="container pt-sm-2">
  <div class="row">
    <div class="col-lg-4 col-md-3 language-features"><hr/></div>
    <div class="col-lg-4 col-md-6 language-features section-heading">
      <h2 class="lead secondary-heading">Install Julia</h2>
    </div>
    <div class="col-lg-4 col-md-3 language-features"><hr/></div>
  </div>
  <br>

  <div id="windows-instructions" style="display: none;">
    It appears that you are using Windows. Install Julia using the <a href="https://install.julialang.org/Julia.appinstaller">MSIX App Installer</a>. Alternatively, if you have access to the <a href="https://www.microsoft.com/store/apps/9NJNWW8PVKMN">Microsoft Store</a>, you can install Julia by running the following in the command prompt. In case you are not using Windows, please follow the <a href="#" onclick="showUNIX(); return false;">Linux and macOS instructions</a>.<br><br>
    <pre><code class="language-plaintext cmdprompt-block">winget install --name Julia --id 9NJNWW8PVKMN -e -s msstore</code></pre>
  </div>
  <div id="unix-instructions" style="display: none;">
    It appears that you are using macOS or Linux. Install Julia by running the following in your terminal. In case you are using Windows, please follow these <a href="#" onclick="showWindows(); return false;">instructions for Windows</a>.<br><br>
    <pre><code class="language-plaintext bash-block">curl -fsSL https://install.julialang.org | sh</code></pre>
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
      showWindows();
    } else {
      showUNIX();
    }
  </script>

  <p>This will install the latest stable version of Julia, as well as the <a href="https://github.com/JuliaLang/juliaup"><code>juliaup</code></a> tool. Start Julia from the command-line by typing <code>julia</code>. See <code>juliaup --help</code> for how to configure installed versions.</p>
  <p>If you prefer to use manual installation using a GUI-based installer, see the <a href="/downloads/manual-downloads/">Manual Downloads</a> page.</p>
  <br>
</div>

<div class="container-fluid alt-color packages">
  <br>
  <div class="container">
    <div class="row">
      <div class="col-lg-4 col-md-3 language-features"><hr/></div>
      <div class="col-lg-4 col-md-6 language-features section-heading">
        <h2 class="lead secondary-heading">Next Steps</h2>
      </div>
      <div class="col-lg-4 col-md-3 language-features"><hr/></div>
    </div>
    <br>
    <ul>
      <li>Join the <a href="/community">community</a>.</li>
      <li>Check out the <a href="/learning">learning resources</a>.</li>
      <li>Set up an <a href="/#editors">editor</a>.</li>
      <li>Do star us on <a href="https://github.com/JuliaLang/julia">GitHub</a>.</li>
      <li>If you use Julia in your research, please <a href="/research/">cite us</a>.</li>
      <li>Do consider <a href="https://github.com/sponsors/julialang">sponsoring</a> us.</li>
    </ul>
    <br>
  </div>
</div>

<div class="container pt-sm-2">
  <div class="row">
    <div class="col-lg-4 col-md-3 language-features"><hr/></div>
    <div class="col-lg-4 col-md-6 language-features section-heading">
      <h2 class="lead secondary-heading">Support Tiers</h2>
    </div>
    <div class="col-lg-4 col-md-3 language-features"><hr/></div>
  </div>
  <br>
  <p>Julia supports all the major operating systems, but specific versions and architectures have different <a href="/downloads/support">tiers of support</a>.</p>
  <br>
</div>

<div class="container-fluid alt-color packages">
  <br>
  <div class="container">
    <div class="row">
      <div class="col-lg-4 col-md-3 language-features"><hr/></div>
      <div class="col-lg-4 col-md-6 language-features section-heading">
        <h2 class="lead secondary-heading">Official Domains</h2>
      </div>
      <div class="col-lg-4 col-md-3 language-features"><hr/></div>
    </div>
    <br>
    <p>The following domains are official and used by open source Julia infrastructure for serving content and resources:</p>
    <ul>
      <li><code>julialang.org</code> and all subdomains</li>
      <li><code>julialang.net</code> and all subdomains</li>
    </ul>
    <p>If you are using Julia behind a firewall that blocks access to these, you may have trouble downloading and installing Julia packages. If this is the case, please ask your sysadmin to add these domains to the firewall allow list. Traffic can be limited to HTTPS (TCP port 443).</p>
    <br>
  </div>
</div>

<div class="container pt-sm-2">
  <div class="row">
    <div class="col-lg-4 col-md-3 language-features"><hr/></div>
    <div class="col-lg-4 col-md-6 language-features section-heading">
      <h2 class="lead secondary-heading">IP Address Retention Policy</h2>
    </div>
    <div class="col-lg-4 col-md-3 language-features"><hr/></div>
  </div>
  <br>
  <!--
  IF YOU'RE THINKING ABOUT REMOVING THIS NOTE, DON'T. ACCORDING TO OUR LAWYERS, THIS NEEDS TO BE HERE TO COMPLY WITH THE GDPR.
  -->
  <p>Julia comes with a built-in package manager which downloads and installs packages from the Internet. In doing so, it necessarily reveals your public <a href="https://en.wikipedia.org/wiki/IP_address">IP address</a> to any server you connect to, and service providers may log your IP address. In Julia versions 1.5 and higher, by default the package manager connects to <a href="https://pkg.julialang.org">https://pkg.julialang.org</a>, a free public service operated by the Julia project to serve open source package resources to Julia users. This service retains IP address logs for up to 31 days.</p>
  <br>
</div>
~~~
