

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
   <div class="col-12" style="text-align: center; width: 100%;">
     <a id="DownloadButton" class="btn btn-success btn-lg" href="/downloads/other/" style="font-size: 25px">See all downloads</a>
   </div>
   <!-- <br><br> May want to add space-->

   <div class="col-12" style="text-align: center; font-size: 20px">
     <a id="HelpButton" href="/downloads/other/">[Help]</a>  | <a href="/downloads/other/">Other Platforms</a> | <a href="https://docs.julialang.org/en/v1/NEWS/">Release Notes</a>
   </div>
   <div class="col-12" style="text-align: center; font-size: 15px">
     <a href="/downloads/nightlies/">"Nightly" builds</a>  | <a class="md5" href="">MD5</a> or <a class="sha256" href="">SHA256</a> Checksums
   </div>
   </p>
   <br><br>
  </div>

  <!--
        Containers: Why Julia?
   -->
   <div class="container pt-sm-2" style="font-size: 20px">
     <div class="row">
       <div class="col-lg-4 col-md-3 language-features "><hr/></div>
       <div class="col-lg-4 col-md-6 language-features section-heading">
         <h2 class="lead secondary-heading">
            Why Julia?
         </h2>
       </div>
       <div class="col-lg-4 col-md-3 language-features"><hr/></div>
      </div>
      <p>
       Julia is a fresh approach to technical computing. Built for speed, reproducibility, and ease of use. See what Julia users are saying on twitter with <a class="link extra-link" href="https://twitter.com/search?q=%23JuliaLang&src=typed_query" target="_blank" style="font-size: 20px">#JuliaLang</a>.
      </p>
     <br>
     </div>

  </div>

<script>
  window.addEventListener('DOMContentLoaded', (event) => {
    const stable_release = "1.5.3";
    const stable_release_short = "1.5";

    function getOS() {
      var userAgent = window.navigator.userAgent,
          platform = window.navigator.platform,
          macosPlatforms = ['Macintosh', 'MacIntel', 'MacPPC', 'Mac68K'],
          windowsPlatforms = ['Win32', 'Win64', 'Windows', 'WinCE'],
          iosPlatforms = ['iPhone', 'iPad', 'iPod'],
          os = null;

      if (macosPlatforms.indexOf(platform) !== -1) {
        os = 'Mac OS';
        downloadlink = `https://julialang-s3.julialang.org/bin/mac/x64/${stable_release_short}/julia-${stable_release}-mac64.dmg`;
        downloadmsg = `Download Julia v${stable_release} for macOS`;
        helplink = "/downloads/platform/#macos";

      } else if (iosPlatforms.indexOf(platform) !== -1) {
        os = 'iOS';
        downloadlink = "/downloads/other/";
        downloadmsg = "See all downloads";
        helplink = "/downloads/other/";

      } else if (windowsPlatforms.indexOf(platform) !== -1) {
        if (platform == "Win32"){
          os = 'Windows 32bit';
          downloadlink = `https://julialang-s3.julialang.org/bin/winnt/x86/{{stable_release_short}}/julia-{{stable_release}}-win32.exe`;
          downloadmsg = `Download Julia v${stable_release} for Windows 32bit`;
          helplink = "/downloads/platform/#windows";

        }
        else if (platform == "Win64"){
          os = 'Windows 64bit';
          downloadlink = `https://julialang-s3.julialang.org/bin/winnt/x64/{{stable_release_short}}/julia-{{stable_release}}-win64.exe`;
          downloadmsg = `Download Julia v${stable_release} for Windows 64bit`;
          helplink = "/downloads/platform/#windows";

        } else {
          window.location.replace('/downloads/other/');
        }


      } else if (/Android/.test(userAgent)) {
        os = 'Android';
        downloadlink = "/downloads/other/";
        downloadmsg = "See all downloads";
        helplink = "/downloads/other/";

      } else if (!os && /Linux/.test(platform)) {
        console.log("Your current platform has been detected as: ");
        console.log(platform);
        os = 'Linux';
        <!-- window.location.replace('/downloads/other/'); -->
      }

      console.log("Your current platform has been detected as: ");
      console.log(platform);

      return [os, downloadlink, downloadmsg, helplink];
    }

    let osDetails = getOS();
    let dbutton = document.querySelector("#DownloadButton");
    dbutton.innerHTML = osDetails[2];
    dbutton.href = osDetails[1];

    let hbutton = document.querySelector("#HelpButton");
    hbutton.href = osDetails[3];

    let checksumMD5 = document.querySelector(".md5");
    checksumMD5.href = `https://julialang-s3.julialang.org/bin/checksums/julia-${stable_release}.md5`;

    let checksumSHA256 = document.querySelector(".sha256");
    checksumSHA256.href = `https://julialang-s3.julialang.org/bin/checksums/julia-${stable_release}.sha256`;
  });


</script>
~~~
