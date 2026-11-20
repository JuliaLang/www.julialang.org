// Getting started page: copy buttons, the startup.jl builder and the hero terminal.
(function () {
  function copyText(button, text) {
    var original = button.getAttribute('data-label') || button.textContent;
    button.setAttribute('data-label', original);
    var done = function (label) {
      button.textContent = label;
      button.classList.toggle('is-done', label === 'Copied');
      setTimeout(function () {
        button.textContent = original;
        button.classList.remove('is-done');
      }, 1800);
    };
    if (navigator.clipboard) {
      navigator.clipboard.writeText(text).then(function () { done('Copied'); }, function () { done('Press Ctrl+C'); });
    } else {
      done('Press Ctrl+C');
    }
  }

  document.addEventListener('click', function (e) {
    var button = e.target.closest('.gs-copy, .gs-pill');
    if (!button) return;
    var from = button.getAttribute('data-copy-from');
    copyText(button, from ? document.getElementById(from).textContent : button.getAttribute('data-copy'));
  });

  // Toolbelt: build the add line and startup.jl from the ticked tools.
  // Revise must load before the code it should track, so it always comes first.
  var order = ['Revise', 'DocBrowser', 'BenchmarkTools', 'Infiltrator'];
  var boxes = document.querySelectorAll('.gs-tool input');
  var addEl = document.getElementById('gs-belt-add');
  var startupEl = document.querySelector('#gs-startup code');

  function updateBelt() {
    var picked = [];
    boxes.forEach(function (box) { if (box.checked) picked.push(box.value); });
    var inOrder = order.filter(function (name) { return picked.indexOf(name) !== -1; });

    addEl.textContent = picked.length ? 'add ' + picked.join(' ') : '# pick a tool on the left';
    startupEl.textContent = inOrder.length
      ? 'if isinteractive()\n' + inOrder.map(function (name) { return '    using ' + name; }).join('\n') + '\nend'
      : '# nothing picked yet';

    if (window.hljs) {
      startupEl.removeAttribute('data-highlighted');
      startupEl.className = 'language-julia';
      window.hljs.highlightElement(startupEl);
    }
  }

  boxes.forEach(function (box) { box.addEventListener('change', updateBelt); });

  // Hero terminal: type out a few add lines in turn.
  var typer = document.getElementById('gs-typer');
  var reduced = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (typer && !reduced) {
    var lines = [
      'add CSV DataFrames',
      'add OrdinaryDiffEq',
      'add DocBrowser Revise',
      'add OhMyThreads',
      'add JuMP HiGHS',
      'add PkgTemplates Documenter Aqua',
      'add Plots Distributions'
    ];
    var line = 0, pos = lines[0].length, deleting = true;
    var tick = function () {
      if (deleting) {
        pos--;
        if (pos <= 4) { deleting = false; line = (line + 1) % lines.length; }
      } else {
        pos++;
      }
      typer.textContent = lines[line].slice(0, pos);
      var delay = deleting ? 28 : 55 + Math.random() * 60;
      if (!deleting && pos >= lines[line].length) { deleting = true; delay = 2200; }
      setTimeout(tick, delay);
    };
    setTimeout(tick, 2600);
  }
})();
