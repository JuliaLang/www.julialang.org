// Carousels on the landing page. Each one is a `.carousel-root` containing the
// slides (`.carousel-slide`), optional arrows (`.carousel-arrow-left/right`),
// and either dots (`.carousel-dots`) or labelled buttons (`.carousel-labels`,
// built from each slide's `data-label`). Several can coexist on one page.
(function() {
  function mod(n, m) {
    return ((n % m) + m) % m;
  }

  function initCarousel(root) {
    const slides = root.querySelectorAll('.carousel-slide');
    const total = slides.length;
    if (total === 0) return;

    let current = 0;
    const buttons = [];

    // Navigation: dots, or labelled buttons when the slides carry data-label
    const dotsContainer = root.querySelector('.carousel-dots');
    const labelsContainer = root.querySelector('.carousel-labels');
    slides.forEach((slide, i) => {
      if (labelsContainer) {
        const button = document.createElement('button');
        button.className = 'carousel-label';
        button.textContent = slide.dataset.label || `Slide ${i + 1}`;
        button.addEventListener('click', () => goTo(i));
        labelsContainer.appendChild(button);
        buttons.push(button);
      } else if (dotsContainer) {
        const dot = document.createElement('button');
        dot.className = 'carousel-dot';
        dot.setAttribute('aria-label', `Go to slide ${i + 1}`);
        dot.addEventListener('click', () => goTo(i));
        dotsContainer.appendChild(dot);
        buttons.push(dot);
      }
    });

    function goTo(index) {
      current = mod(index, total);
      const prevIndex = mod(current - 1, total);
      const nextIndex = mod(current + 1, total);

      buttons.forEach((b, i) => {
        b.classList.toggle('active', i === current);
        b.setAttribute('aria-current', i === current ? 'true' : 'false');
      });
      slides.forEach((s, i) => {
        s.classList.remove('active', 'prev', 'next');
        if (i === current) s.classList.add('active');
        else if (i === prevIndex) s.classList.add('prev');
        else if (i === nextIndex) s.classList.add('next');
      });
    }

    // Click on side slides to navigate
    slides.forEach((slide) => {
      slide.addEventListener('click', () => {
        if (slide.classList.contains('prev')) goTo(current - 1);
        else if (slide.classList.contains('next')) goTo(current + 1);
      });
    });

    // Arrow button navigation (with null checks for carousels without arrows)
    const leftArrow = root.querySelector('.carousel-arrow-left');
    const rightArrow = root.querySelector('.carousel-arrow-right');
    if (leftArrow) leftArrow.addEventListener('click', () => goTo(current - 1));
    if (rightArrow) rightArrow.addEventListener('click', () => goTo(current + 1));

    goTo(0);
    return { root, goTo: (delta) => goTo(current + delta) };
  }

  const carousels = Array.from(document.querySelectorAll('.carousel-root'))
    .map(initCarousel)
    .filter(Boolean);
  if (carousels.length === 0) return;

  // Keyboard navigation: arrow keys move the carousel closest to the middle of
  // the viewport, so that two carousels on one page don't both react.
  document.addEventListener('keydown', (e) => {
    if (e.key !== 'ArrowLeft' && e.key !== 'ArrowRight') return;
    if (e.target.matches('input, textarea, select')) return;
    const middle = window.innerHeight / 2;
    let best = null;
    let bestDistance = Infinity;
    for (const c of carousels) {
      const rect = c.root.getBoundingClientRect();
      if (rect.bottom < 0 || rect.top > window.innerHeight) continue;
      const distance = Math.abs((rect.top + rect.bottom) / 2 - middle);
      if (distance < bestDistance) { best = c; bestDistance = distance; }
    }
    if (best) best.goTo(e.key === 'ArrowLeft' ? -1 : 1);
  });
})();
