
@def title = "Julia Downloads (nightly binaries)"


# Nightly builds

These are bleeding-edge binaries of the latest version of Julia under
development, which you can use to get a preview of the latest work.
The nightly builds are for developer previews and not intended for
normal use. You can expect many packages not to work with this version.
Most users are advised to use the latest official release version of Julia.

Nightlies are updated asynchronously for each platform after each platforms testing passes.
The time the installers were updated can be seen by hovering over the links.

Nightly builds are also available through the `nightly` channel on `juliaup`.

~~~
<table class="downloads table table-hover table-bordered">
  <tbody>
  <tr>
      <th> Platform</th>
      <th> 64-bit</th>
      <th> 32-bit</th>
  </tr>
  <tr>
      <td> Windows </td>
      <td> <a href="https://julialangnightlies-s3.julialang.org/bin/winnt/x64/julia-latest-win64.exe">installer</a>, <a href="https://julialangnightlies-s3.julialang.org/bin/winnt/x64/julia-latest-win64.zip">portable</a> </td>
      <td> <a href="https://julialangnightlies-s3.julialang.org/bin/winnt/x86/julia-latest-win32.exe">installer</a>, <a href="https://julialangnightlies-s3.julialang.org/bin/winnt/x86/julia-latest-win32.zip">portable</a> </td>
  </tr>
  <tr>
      <td> macOS</td>
      <td> <a href="https://julialangnightlies-s3.julialang.org/bin/macos/x86_64/julia-latest-macos-x86_64.dmg">Intel</a>, <a href="https://julialangnightlies-s3.julialang.org/bin/macos/aarch64/julia-latest-macos-aarch64.dmg">Apple Silicon</a> </td>
      <td> </td>
  </tr>
  <tr>
      <td> Generic Linux on x86 </td>
      <td> <a href="https://julialangnightlies-s3.julialang.org/bin/linux/x86_64/julia-latest-linux-x86_64.tar.gz">.tar.gz</a> </td>
      <td> <a href="https://julialangnightlies-s3.julialang.org/bin/linux/i686/julia-latest-linux-i686.tar.gz">.tar.gz</a> </td>
  </tr>
  <tr>
      <td> Generic Linux on ARM </td>
      <td> <a href="https://julialangnightlies-s3.julialang.org/bin/linux/aarch64/julia-latest-linux-aarch64.tar.gz">.tar.gz</a> </td>
      <td> </td>
  </tr>
  <tr>
      <td> Generic FreeBSD on x86 </td>
      <td> <a href="https://julialangnightlies-s3.julialang.org/bin/freebsd/x64/julia-latest-freebsd-x86_64.tar.gz">.tar.gz</a> </td>
      <td> </td>
  </tr>
  </tbody>
</table>
<table>
  <tbody>
  <tr>
      <th> Source </th>
      <td> <a href="https://github.com/JuliaLang/julia">GitHub</a> </td>
  </tr>
  </tbody>
</table>

<script>
document.addEventListener("DOMContentLoaded", function () {
  // Get the table with class "downloads"
  var downloadsTable = document.querySelector(".downloads");

  // Check if the table is found
  if (downloadsTable) {
    // Get all the links in the table
    var links = downloadsTable.querySelectorAll("a");

    // Iterate through each link
    links.forEach(function (link) {
      // Get the href attribute of the link
      var href = link.getAttribute("href");

      if (href.startsWith("https://julialangnightlies-s3.julialang.org/")) {
        // Fetch the last-modified header of the link
        fetch(href, { method: "HEAD" })
          .then(function (response) {
            // Check if the last-modified header is present
            if (response.headers.has("last-modified")) {
              // Set the hint text to the last-modified value
              var lastModified = response.headers.get("last-modified");
              link.setAttribute("title", "Last Modified: " + lastModified);
            }
          })
          .catch(function (error) {
            console.error("Error fetching last-modified header for " + href + " :", error);
          });
      }
    });
  }
});
</script>

~~~
