@def title = "Installing Julia"

~~~
<style>
  :root {
    --bg: #ffffff;
    --panel: #f6f7f9;
    --text: #111827;
    --muted: #7c7c7c;
    --border: #e5e7eb;
    --link: #1f6feb;
    --card: #ffffff;
    --card-inset: #ffffff;
    --shadow: 0 1px 0 rgba(17, 24, 39, 0.06);
    --card-shadow: 0 10px 30px rgba(17, 24, 39, 0.08);
  }

  /* Map the palette onto the site-wide dark theme (see _css/app.css). */
  [data-theme="dark"] {
    --bg: var(--dm-bg, #1a1a2e);
    --panel: var(--dm-bg-surface, #2a2a3e);
    --text: var(--dm-text, #e0e0e0);
    --muted: var(--dm-text-muted, #bbb);
    --border: var(--dm-border, #444);
    --link: var(--dm-link, #6ea8fe);
    --card: var(--dm-bg-surface, #2a2a3e);
    --card-inset: var(--dm-bg-elevated, #333);
    --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.45);
  }

  .section-grid { margin-top: 18px; }

  .lead-list {
    margin: 8px 0 14px 18px;
    padding: 0;
    color: var(--text);
  }
  .lead-list li { margin: 0 0 6px; }
  .lead-list li:last-child { margin-bottom: 0; }

  .muted { color: var(--muted); }

  .if-you {
    margin: 8px 0 0;
    color: var(--muted);
    font-weight: 650;
    font-size: 13px;
  }

  .kicker {
    display: inline-block;
    padding: 10px 14px;
    border: 1px solid var(--border);
    border-radius: 999px;
    background: linear-gradient(180deg, var(--panel) 0%, var(--card) 100%);
    color: var(--text);
    font-size: 18px;
    font-weight: 800;
    letter-spacing: -0.01em;
    text-transform: none;
  }

  .grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px;
    align-items: start;
  }

  @media (max-width: 860px) {
    .grid { grid-template-columns: 1fr; }
  }

  .card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 20px;
    box-shadow: var(--card-shadow);
  }

  .card h2 { margin: 10px 0 6px; font-size: 16px; color: var(--muted); }

  .card p {
    margin: 0 0 10px;
    color: var(--muted);
  }

  .card-head { display: flex; flex-direction: column; gap: 4px; }

  .version-block {
    margin-top: 12px;
    padding: 12px;
    border: 1px solid var(--border);
    border-radius: 12px;
    background: var(--card-inset);
    min-width: 0;
  }

  .version-grid {
    display: flex;
    gap: 14px;
    flex-wrap: nowrap;
  }

  .version-grid .version-block {
    flex: 1 1 0;
    margin-top: 12px;
  }

  .version-block h3 {
    margin: 0 0 10px;
    font-size: 14px;
    font-weight: 700;
    letter-spacing: 0.02em;
    <!-- text-transform: uppercase; -->
  }

  .os-icon {
    width: 18px;
    height: 18px;
    display: inline-block;
    flex: 0 0 auto;
  }

  .os-label {
    display: flex;
    align-items: center;
    gap: 8px;
    margin: 10px 0 6px;
    font-weight: 700;
    color: var(--text);
  }

  .code {
    margin: 10px 0 12px;
    padding: 10px 12px;
    border: 1px solid var(--border);
    border-radius: 10px;
    background: var(--card-inset);
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New",
      monospace;
    font-size: 13px;
    overflow-x: auto;
    white-space: nowrap;
  }

  .os-row {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 10px;
  }

  .os-row .os-icon {
    flex: 0 0 auto;
  }

  .os-row .os-name {
    font-weight: 600;
    min-width: 70px;
  }

  .os-row a {
    color: var(--link);
    text-decoration: none;
  }

  .os-row a:hover {
    text-decoration: underline;
  }

  .os-separator {
    margin: 12px 0 10px;
    font-size: 12px;
    font-weight: 600;
    color: var(--muted);
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  details {
    margin-top: 12px;
    padding: 12px;
    border: 1px solid var(--border);
    border-radius: 12px;
    background: var(--card-inset);
  }

  summary {
    cursor: pointer;
    font-weight: 700;
    font-size: 14px;
    letter-spacing: 0.02em;
    color: var(--link);
    list-style: none;
  }

  summary::-webkit-details-marker {
    display: none;
  }

  summary:hover {
    opacity: 0.8;
  }

  details p {
    margin: 10px 0 0;
    color: var(--muted);
  }
</style>

<div class="grid section-grid">
  <section class="card" aria-labelledby="for-users">
    <div class="card-head">
      <span class="kicker">For users</span>
      <h2 id="for-users">Standalone installer</h2>
      <p class="if-you">If you:</p>
      <ul class="lead-list">
        <li>use Julia code, but don't write it yourself</li>
        <li>
          and only need a single version of Julia<br />
          <span class="muted">(not sure which? ask the authors of the code you want to run)</span>
        </li>
        <li>and have no command-line knowledge</li>
      </ul>
    </div>

    <div class="version-grid" aria-label="Standalone installers by version">
      <div class="version-block" aria-label="Julia {{stable_release_short}} installers">
        <h3>Latest: Julia {{stable_release_short}}</h3>
        <div class="os-row" data-os="windows">
          <img class="os-icon" src="windows.png" alt="" aria-hidden="true" />
          <span class="os-name">Windows</span>
          <a href="https://julialang-s3.julialang.org/bin/winnt/x64/{{stable_release_short}}/julia-{{stable_release}}-win64.exe" title="Julia {{stable_release}} Windows x64 installer">
            <span>x64</span>
          </a>
          |
          <a href="https://julialang-s3.julialang.org/bin/winnt/x86/{{stable_release_short}}/julia-{{stable_release}}-win32.exe" title="Julia {{stable_release}} Windows x86 installer">
            <span>x86</span>
          </a>
        </div>
        <div class="os-row" data-os="macos">
          <img class="os-icon" src="macos.png" alt="" aria-hidden="true" />
          <span class="os-name">macOS</span>
          <a href="https://julialang-s3.julialang.org/bin/mac/aarch64/{{stable_release_short}}/julia-{{stable_release}}-macaarch64.dmg" title="Julia {{stable_release}} macOS Apple Silicon installer">
            <span>Apple</span>
          </a>
          |
          <a href="https://julialang-s3.julialang.org/bin/mac/x64/{{stable_release_short}}/julia-{{stable_release}}-mac64.dmg" title="Julia {{stable_release}} macOS Intel installer">
            <span>Intel</span>
          </a>
        </div>
        <div class="os-row" data-os="linux">
          <img class="os-icon" src="linux.png" alt="" aria-hidden="true" />
          <span class="os-name">Linux</span>
          <a href="https://julialang-s3.julialang.org/bin/linux/x64/{{stable_release_short}}/julia-{{stable_release}}-linux-x86_64.tar.gz" title="Julia {{stable_release}} Linux x64 tarball">
            <span>x64</span>
          </a>
          |
          <a href="https://julialang-s3.julialang.org/bin/linux/x86/{{stable_release_short}}/julia-{{stable_release}}-linux-i686.tar.gz" title="Julia {{stable_release}} Linux x86 tarball">
            <span>x86</span>
          </a>
          |
          <a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{stable_release_short}}/julia-{{stable_release}}-linux-aarch64.tar.gz" title="Julia {{stable_release}} Linux ARM tarball">
            <span>arm</span>
          </a>
        </div>
        <div class="os-separator">Other systems:</div>
        <div class="os-row">
          <a href="/downloads/manual-downloads/">All platforms &amp; architectures</a>
        </div>
      </div>

      <div class="version-block" aria-label="Julia {{lts_release_short}} installers">
        <h3>Long-term support: Julia {{lts_release_short}}</h3>
        <div class="os-row" data-os="windows">
          <img class="os-icon" src="windows.png" alt="" aria-hidden="true" />
          <span class="os-name">Windows</span>
          <a href="https://julialang-s3.julialang.org/bin/winnt/x64/{{lts_release_short}}/julia-{{lts_release}}-win64.exe" title="Julia {{lts_release}} Windows x64 installer">
            <span>x64</span>
          </a>
          |
          <a href="https://julialang-s3.julialang.org/bin/winnt/x86/{{lts_release_short}}/julia-{{lts_release}}-win32.exe" title="Julia {{lts_release}} Windows x86 installer">
            <span>x86</span>
          </a>
        </div>
        <div class="os-row" data-os="macos">
          <img class="os-icon" src="macos.png" alt="" aria-hidden="true" />
          <span class="os-name">macOS</span>
          <a href="https://julialang-s3.julialang.org/bin/mac/aarch64/{{lts_release_short}}/julia-{{lts_release}}-macaarch64.dmg" title="Julia {{lts_release}} macOS Apple Silicon installer">
            <span>Apple</span>
          </a>
          |
          <a href="https://julialang-s3.julialang.org/bin/mac/x64/{{lts_release_short}}/julia-{{lts_release}}-mac64.dmg" title="Julia {{lts_release}} macOS Intel installer">
            <span>Intel</span>
          </a>
        </div>
        <div class="os-row" data-os="linux">
          <img class="os-icon" src="linux.png" alt="" aria-hidden="true" />
          <span class="os-name">Linux</span>
          <a href="https://julialang-s3.julialang.org/bin/linux/x64/{{lts_release_short}}/julia-{{lts_release}}-linux-x86_64.tar.gz" title="Julia {{lts_release}} Linux x64 tarball">
            <span>x64</span>
          </a>
          |
          <a href="https://julialang-s3.julialang.org/bin/linux/x86/{{lts_release_short}}/julia-{{lts_release}}-linux-i686.tar.gz" title="Julia {{lts_release}} Linux x86 tarball">
            <span>x86</span>
          </a>
          |
          <a href="https://julialang-s3.julialang.org/bin/linux/aarch64/{{lts_release_short}}/julia-{{lts_release}}-linux-aarch64.tar.gz" title="Julia {{lts_release}} Linux ARM tarball">
            <span>arm</span>
          </a>
        </div>
        <div class="os-separator">Other systems:</div>
        <div class="os-row">
          <a href="/downloads/manual-downloads/">All platforms &amp; architectures</a>
        </div>
      </div>
    </div>

    <details>
      <summary>Other Julia versions</summary>
      <p>
        Need a different version? The
        <a href="/downloads/manual-downloads/">manual downloads</a> page lists the
        current stable and long-term support releases for every platform, and
        <a href="/downloads/oldreleases/">older releases</a> are archived separately.
        Development builds are on the
        <a href="/downloads/nightlies/">nightlies</a> page.
      </p>
    </details>
  </section>

  <section class="card" aria-labelledby="for-devs">
    <div class="card-head">
      <span class="kicker">For developers and researchers</span>
      <h2 id="for-devs">Use <code>juliaup</code></h2>
      <p class="if-you">If you:</p>
      <ul class="lead-list">
        <li>write or expect to write Julia code</li>
        <li>or need multiple versions available at once</li>
        <li>or have experience with the command line</li>
      </ul>
    </div>

    <p>Run in your terminal:</p>

    <div class="os-label">
      <img class="os-icon" src="linux.png" alt="" aria-hidden="true" />
      <img class="os-icon" src="macos.png" alt="" aria-hidden="true" />
      <span>Linux or macOS</span>
    </div>
    <div class="code">curl -fsSL https://install.julialang.org | sh</div>

    <div class="os-label">
      <img class="os-icon" src="windows.png" alt="" aria-hidden="true" />
      <span>Windows</span>
    </div>
    <div class="code">winget install --name Julia --id 9NJNWW8PVKMN -e -s msstore</div>

    <p>
      This will install the latest stable version of Julia, as well as the <code>juliaup</code> tool.<br>
      Start Julia from the command-line by typing <code>julia</code>.<br>
      See <a href="https://github.com/JuliaLang/juliaup"><code>juliaup</code> docs</a> for more details.
    </p>
  </section>
</div>

<script>
(function() {
  const platform = navigator.platform.toLowerCase();
  const ua = navigator.userAgent.toLowerCase();
  let detectedOS = 'linux';

  if (platform.includes('win') || ua.includes('windows')) {
    detectedOS = 'windows';
  } else if (platform.includes('mac') || ua.includes('mac')) {
    detectedOS = 'macos';
  }

  // Reorder OS rows: move detected OS to top with separator
  document.querySelectorAll('.version-block').forEach(block => {
    const rows = Array.from(block.querySelectorAll('.os-row[data-os]'));
    const separator = block.querySelector('.os-separator');
    const matchingRow = rows.find(row => row.getAttribute('data-os') === detectedOS);

    if (matchingRow && separator) {
      // Move matching row to the top
      const h3 = block.querySelector('h3');
      h3.insertAdjacentElement('afterend', matchingRow);

      // Move separator after the matching row
      matchingRow.insertAdjacentElement('afterend', separator);
    }
  });
})();
</script>

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
