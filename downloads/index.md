

# Download Julia

If you like Julia, please consider starring us [on GitHub](https://github.com/JuliaLang/julia) and spreading the word!

~~~
<a class="github-button" href="https://github.com/JuliaLang/julia" data-size="large" data-show-count="true" aria-label="Star JuliaLang/julia on GitHub">Star</a>
~~~

~~~
<!--
      Containers: Downloads
 -->
 <div class="container-fluid alt-color packages">
   <br><br>
   <div class="row">
     <div class="col-lg-4 col-md-3 ecosystem language-features "><hr/></div>
     <div class="col-lg-4 col-md-6 ecosystem language-features section-heading">
       <h2 class="lead secondary-heading">
         Download
       </h2>
     </div>
     <div class="col-lg-4 col-md-3 ecosystem language-features"><hr/></div>
   </div>

   <p>
   <div class="col-12" style="text-align: center">
     <a id="DownloadButton" class="btn btn-lg btn-outline-primary" href="/learning/tryjulia">Try Julia In Your Browser</a>
   </div>
   <!-- <br><br> May want to add space-->

   <div class="col-12" style="text-align: center">
     <a id="HelpButton" href="/downloads/other/">[Help]</a>  <a href="/downloads/other/">Other Platforms</a>
   </div>
   </p>
   <br><br>
  </div>

<script>

  const stable_release = "1.5.3"
  const stable_release_short = "1.5"

  function getOS() {
    var userAgent = window.navigator.userAgent,
        platform = window.navigator.platform,
        macosPlatforms = ['Macintosh', 'MacIntel', 'MacPPC', 'Mac68K'],
        windowsPlatforms = ['Win32', 'Win64', 'Windows', 'WinCE'],
        iosPlatforms = ['iPhone', 'iPad', 'iPod'],
        os = null;

    if (macosPlatforms.indexOf(platform) !== -1) {
      console.log(platform)
      os = 'Mac OS';
      downloadlink = `https://julialang-s3.julialang.org/bin/mac/x64/${stable_release_short}/julia-${stable_release}-mac64.dmg`
      downloadmsg = `Download Julia v${stable_release} for macOS`
      helplink = "/downloads/platform/#macos"

    } else if (iosPlatforms.indexOf(platform) !== -1) {
      os = 'iOS';
      downloadlink = ""
      downloadmsg = `You need to be on a Desktop to download Julia v${stable_release}`
      helplink = "/downloads/other/"

    } else if (windowsPlatforms.indexOf(platform) !== -1) {
      if (platform == "Win32"){
        os = 'Windows 32bit';
        downloadlink = `https://julialang-s3.julialang.org/bin/winnt/x86/{{stable_release_short}}/julia-{{stable_release}}-win32.exe`
        downloadmsg = `Download Julia v${stable_release} for Windows 32bit`
        helplink = "/downloads/platform/#windows"

      }
      else if (platform == "Win64"){
        os = 'Windows 64bit';
        downloadlink = `https://julialang-s3.julialang.org/bin/winnt/x64/{{stable_release_short}}/julia-{{stable_release}}-win64.exe`
        downloadmsg = `Download Julia v${stable_release} for Windows 64bit`
        helplink = "/downloads/platform/#windows"

      } else {
        <!-- We should render the other downloads page -->
        console.log("TODO")
      }


    } else if (/Android/.test(userAgent)) {
      os = 'iOS';
      downloadlink = ""
      downloadmsg = `You need to be on a Desktop to download Julia v${stable_release}`
      helplink = "/downloads/other/"

    } else if (!os && /Linux/.test(platform)) {
      os = 'Linux';
    }

    return [os, downloadlink, downloadmsg, helplink];
  }

  let osDetails = getOS()
  let dbutton = document.querySelector("#DownloadButton")
  dbutton.innerHTML = osDetails[2]
  dbutton.href = osDetails[1]

  let hbutton = document.querySelector("#HelpButton")
  hbutton.href = osDetails[3]

</script>
~~~
