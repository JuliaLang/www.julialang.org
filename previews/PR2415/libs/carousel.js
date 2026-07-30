(function() {
  const slides = document.querySelectorAll('.carousel-slide');
  const dotsContainer = document.querySelector('.carousel-dots');

  if (slides.length === 0) return;

  let current = 0;
  const total = slides.length;

  // Create dots
  slides.forEach((_, i) => {
    const dot = document.createElement('button');
    dot.className = 'carousel-dot' + (i === 0 ? ' active' : '');
    dot.setAttribute('aria-label', `Go to slide ${i + 1}`);
    dot.addEventListener('click', () => goTo(i));
    dotsContainer.appendChild(dot);
  });

  const dots = document.querySelectorAll('.carousel-dot');

  function mod(n, m) {
    return ((n % m) + m) % m;
  }

  function goTo(index) {
    current = mod(index, total);
    const prevIndex = mod(current - 1, total);
    const nextIndex = mod(current + 1, total);

    dots.forEach((d, i) => d.classList.toggle('active', i === current));
    slides.forEach((s, i) => {
      s.classList.remove('active', 'prev', 'next');
      if (i === current) s.classList.add('active');
      else if (i === prevIndex) s.classList.add('prev');
      else if (i === nextIndex) s.classList.add('next');
    });
  }

  // Click on side slides to navigate
  slides.forEach((slide, i) => {
    slide.addEventListener('click', () => {
      if (slide.classList.contains('prev')) goTo(current - 1);
      else if (slide.classList.contains('next')) goTo(current + 1);
    });
  });

  // Arrow button navigation
  document.querySelector('.carousel-arrow-left').addEventListener('click', () => goTo(current - 1));
  document.querySelector('.carousel-arrow-right').addEventListener('click', () => goTo(current + 1));

  // Keyboard navigation
  document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowLeft') goTo(current - 1);
    if (e.key === 'ArrowRight') goTo(current + 1);
  });

  // Initialize
  goTo(0);
})();
