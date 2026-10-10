// Group each h2 in a blog post with the content that follows it, so alternate
// sections can be tinted (see "Blog posts: banded sections" in _css/app.css).
// The table of contents, when present, is the first band.
(function () {
  var main = document.querySelector(".blog-title ~ .container.main");
  if (!main) return;
  var sec = null;
  Array.prototype.slice.call(main.childNodes).forEach(function (n) {
    if (n.nodeType === 1 && (n.tagName === "H2" || n.classList.contains("franklin-toc"))) {
      sec = document.createElement("section");
      sec.className = "blog-section";
      main.insertBefore(sec, n);
    }
    if (sec) sec.appendChild(n);
  });
})();
