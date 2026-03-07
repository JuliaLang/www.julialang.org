(function () {
  var STORAGE_KEY = 'julia-theme';
  var root = document.documentElement;

  // Cache original GitHub buttons for dynamic theme reloading
  var ghBtnCache = [];
  var observer = new MutationObserver(function (mutations) {
    for (var i = 0; i < mutations.length; i++) {
      var added = mutations[i].addedNodes;
      for (var j = 0; j < added.length; j++) {
        var node = added[j];
        if (node.nodeType === 1) {
          var btns = [];
          if (node.tagName === 'A' && node.className.indexOf('github-button') !== -1) {
            btns.push(node);
          } else if (node.querySelectorAll) {
            var found = node.querySelectorAll('a.github-button');
            for (var k = 0; k < found.length; k++) btns.push(found[k]);
          }
          for (var k = 0; k < btns.length; k++) {
            var btn = btns[k];
            // Wrap in a pristine container so we can safely reset its contents later
            if (btn.parentNode && btn.parentNode.className !== 'gh-btn-wrapper') {
              var wrapper = document.createElement('span');
              wrapper.className = 'gh-btn-wrapper';
              wrapper.style.display = 'inline-flex';
              btn.parentNode.insertBefore(wrapper, btn);
              wrapper.appendChild(btn);
              ghBtnCache.push({ wrapper: wrapper, html: btn.outerHTML });
            }
          }
        }
      }
    }
  });

  // Start observing early to catch buttons before buttons.js mutates them
  observer.observe(root, { childList: true, subtree: true });

  document.addEventListener('DOMContentLoaded', function() {
    observer.disconnect();
  });

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
    if (document.body) updateGithubButtons(theme);
  }

  function updateGithubButtons(theme) {
    if (!document.body) return;

    var scheme = theme === 'dark' ? 'dark' : 'light';
    var needsReload = false;

    // Handle cached buttons (post-render dynamic toggling)
    if (ghBtnCache.length > 0) {
      for (var i = 0; i < ghBtnCache.length; i++) {
        var cache = ghBtnCache[i];
        // Reset container to the original pristine anchor
        cache.wrapper.innerHTML = cache.html;
        var anchor = cache.wrapper.querySelector('a.github-button');
        if (anchor) {
          anchor.setAttribute('data-color-scheme', scheme);
          needsReload = true;
        }
      }
    } else {
      // Fallback for non-cached anchors (e.g. initial load before buttons.js runs)
      var anchors = document.querySelectorAll('a.github-button');
      for (var i = 0; i < anchors.length; i++) {
        anchors[i].setAttribute('data-color-scheme', scheme);
      }
    }

    if (needsReload) {
      var scriptId = 'github-buttons-script';
      var oldScript = document.getElementById(scriptId);
      if (oldScript) oldScript.remove();
      
      var newScript = document.createElement('script');
      newScript.id = scriptId;
      newScript.src = '/libs/buttons.js';
      newScript.async = true;
      document.body.appendChild(newScript);
    }
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
