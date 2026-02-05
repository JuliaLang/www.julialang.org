@def title = "Installing Julia"

# Installing Julia

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
    --shadow: 0 1px 0 rgba(17, 24, 39, 0.06);
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
    background: linear-gradient(180deg, var(--panel) 0%, #ffffff 100%);
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
    box-shadow: 0 10px 30px rgba(17, 24, 39, 0.08);
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
    background: #fff;
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
    background: #fff;
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
    background: #fff;
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
      <div class="version-block" aria-label="Julia 1.12 installers">
        <h3>Latest: Julia 1.12</h3>
        <div class="os-row" data-os="windows">
          <img class="os-icon" src="windows.png" alt="" aria-hidden="true" />
          <span class="os-name">Windows</span>
          <a href="#" title="TODO: link to Julia 1.12 Windows x64 installer">
            <span>x64</span>
          </a>
          |
          <a href="#" title="TODO: link to Julia 1.12 Windows x86 installer">
            <span>x86</span>
          </a>
        </div>
        <div class="os-row" data-os="macos">
          <img class="os-icon" src="macos.png" alt="" aria-hidden="true" />
          <span class="os-name">macOS</span>
          <a href="#" title="TODO: link to Julia 1.12 macOS Apple Silicon installer">
            <span>Apple</span>
          </a>
          |
          <a href="#" title="TODO: link to Julia 1.12 macOS Intel installer">
            <span>Intel</span>
          </a>
        </div>
        <div class="os-row" data-os="linux">
          <img class="os-icon" src="linux.png" alt="" aria-hidden="true" />
          <span class="os-name">Linux</span>
          <a href="#" title="TODO: link to Julia 1.12 Linux x64 tarball">
            <span>x64</span>
          </a>
          |
          <a href="#" title="TODO: link to Julia 1.12 Linux x86 tarball">
            <span>x86</span>
          </a>
          |
          <a href="#" title="TODO: link to Julia 1.12 Linux arm tarball">
            <span>arm</span>
          </a>
        </div>
        <div class="os-separator">Other systems:</div>
      </div>

      <div class="version-block" aria-label="Julia 1.10 installers">
        <h3>Long-term support: Julia 1.10</h3>
        <div class="os-row" data-os="windows">
          <img class="os-icon" src="windows.png" alt="" aria-hidden="true" />
          <span class="os-name">Windows</span>
          <a href="#" title="TODO: link to Julia 1.10 Windows x64 installer">
            <span>x64</span>
          </a>
          |
          <a href="#" title="TODO: link to Julia 1.10 Windows x86 installer">
            <span>x86</span>
          </a>
        </div>
        <div class="os-row" data-os="macos">
          <img class="os-icon" src="macos.png" alt="" aria-hidden="true" />
          <span class="os-name">macOS</span>
          <a href="#" title="TODO: link to Julia 1.10 macOS Apple Silicon installer">
            <span>Apple</span>
          </a>
          |
          <a href="#" title="TODO: link to Julia 1.10 macOS Intel installer">
            <span>Intel</span>
          </a>
        </div>
        <div class="os-row" data-os="linux">
          <img class="os-icon" src="linux.png" alt="" aria-hidden="true" />
          <span class="os-name">Linux</span>
          <a href="#" title="TODO: link to Julia 1.10 Linux x64 tarball">
            <span>x64</span>
          </a>
          |
          <a href="#" title="TODO: link to Julia 1.10 Linux x86 tarball">
            <span>x86</span>
          </a>
          |
          <a href="#" title="TODO: link to Julia 1.10 Linux arm tarball">
            <span>arm</span>
          </a>
        </div>
        <div class="os-separator">Other systems:</div>
      </div>
    </div>

    <details>
      <summary>Other Julia versions</summary>
      <p>TODO: Add links to older Julia versions here.</p>
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
~~~

## Next steps

@@tight-list
* Join the [community](/community).
* Check out the [learning resources](/learning).
* Set up an [editor](/#editors).
* Do star us on [GitHub](https://github.com/JuliaLang/julia).
* If you use Julia in your research, please [cite us](/research/).
* Do consider [sponsoring](https://github.com/sponsors/julialang) us.
@@

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
