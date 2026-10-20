(function () {
  var STORAGE_KEY = 'julia-theme';
  var root = document.documentElement;

  // localStorage access throws when site data is blocked; treat that as
  // "no stored preference" so the rest of the script still runs.
  function getStored() {
    try { return localStorage.getItem(STORAGE_KEY); } catch (e) { return null; }
  }

  function setStored(theme) {
    try { localStorage.setItem(STORAGE_KEY, theme); } catch (e) {}
  }

  function getPreferredTheme() {
    var stored = getStored();
    if (stored === 'dark' || stored === 'light') return stored;
    // Fall back to OS preference
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }
    return 'light';
  }

  function applyTheme(theme) {
    root.setAttribute('data-theme', theme);
    updateLogo(theme === 'dark');
    updateThemedImages(theme === 'dark');
  }

  function changeFilePath(originalPath, newFileName) {
    var pathArray = originalPath.split('/');
    pathArray[pathArray.length - 1] = newFileName;
    return pathArray.join('/');
  }

  function updateLogo(isDark) {
    var julialogo = isDark ? 'logo-dark.svg' : 'logo.svg';
    var imgElements = document.getElementsByClassName('navbarjulialogo');
    for (var i = 0; i < imgElements.length; i++) {
      imgElements[i].src = changeFilePath(imgElements[i].src, julialogo);
    }
  }

  // Images with a data-src-dark attribute (e.g. the Ecosystem carousel) get
  // that file in dark mode and their original src otherwise.
  function updateThemedImages(isDark) {
    var imgElements = document.querySelectorAll('img[data-src-dark]');
    for (var i = 0; i < imgElements.length; i++) {
      var img = imgElements[i];
      if (!img.dataset.srcLight) img.dataset.srcLight = img.getAttribute('src');
      var wanted = isDark ? img.dataset.srcDark : img.dataset.srcLight;
      if (img.getAttribute('src') !== wanted) img.setAttribute('src', wanted);
    }
  }

  // Apply theme immediately to prevent flash
  applyTheme(getPreferredTheme());

  document.addEventListener('DOMContentLoaded', function () {
    // Re-apply after DOM is ready (ensures logo is updated)
    applyTheme(getPreferredTheme());

    var toggle = document.getElementById('dark-mode-toggle');
    if (toggle) {
      toggle.addEventListener('click', function () {
        var current = root.getAttribute('data-theme');
        var next = current === 'dark' ? 'light' : 'dark';
        setStored(next);
        toggle.classList.remove('spin');
        void toggle.offsetWidth;
        toggle.classList.add('spin');
        applyTheme(next);
        setTimeout(function () { toggle.classList.remove('spin'); }, 450);
      });
    }

    // Listen for OS preference changes (only applies if no stored preference)
    if (window.matchMedia) {
      window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function () {
        if (!getStored()) {
          applyTheme(getPreferredTheme());
        }
      });
    }

    // Watch for DarkReader extension changes
    var observer = new MutationObserver(function (mutations) {
      for (var i = 0; i < mutations.length; i++) {
        if (mutations[i].attributeName === 'data-darkreader-scheme') {
          if (!getStored()) {
            var isDarkReader = root.getAttribute('data-darkreader-scheme') === 'dark';
            applyTheme(isDarkReader ? 'dark' : getPreferredTheme());
          }
        }
      }
    });
    observer.observe(root, { attributes: true, childList: false, subtree: false });
  });
})();
