(function () {
  var STORAGE_KEY = 'julia-theme';
  var root = document.documentElement;

  function getPreferredTheme() {
    var stored = localStorage.getItem(STORAGE_KEY);
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
        localStorage.setItem(STORAGE_KEY, next);
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
        if (!localStorage.getItem(STORAGE_KEY)) {
          applyTheme(getPreferredTheme());
        }
      });
    }

    // Watch for DarkReader extension changes
    var observer = new MutationObserver(function (mutations) {
      for (var i = 0; i < mutations.length; i++) {
        if (mutations[i].attributeName === 'data-darkreader-scheme') {
          if (!localStorage.getItem(STORAGE_KEY)) {
            var isDarkReader = root.getAttribute('data-darkreader-scheme') === 'dark';
            applyTheme(isDarkReader ? 'dark' : getPreferredTheme());
          }
        }
      }
    });
    observer.observe(root, { attributes: true, childList: false, subtree: false });
  });
})();
