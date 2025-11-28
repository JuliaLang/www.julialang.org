# Julia Website - Modern Redesign

A fresh, modern take on the Julia programming language website using Tailwind CSS.

## Files

- `index.html` - Main landing page with hero, features, ecosystem tabs, benchmarks, community, and tools
- `install.html` - Download page with OS detection and quick install commands
- `learn.html` - Learning resources including tutorials, courses, books, and videos

## Features

- **Modern Design**: Clean, minimal aesthetic with smooth animations and gradients
- **Responsive**: Mobile-first design that works on all screen sizes
- **Tailwind CSS**: Uses Tailwind CDN for styling (no build step required)
- **Interactive**: Ecosystem tabs, OS detection for installs, smooth scrolling
- **Fast**: Single-file pages with minimal dependencies

## Design Highlights

1. **Hero Section**: Eye-catching gradient text animation, code preview with syntax highlighting
2. **Feature Cards**: Hover effects with subtle transforms and shadows
3. **Ecosystem Tabs**: Interactive tabs showing different Julia domains (ML, Data Science, etc.)
4. **Benchmark Visualization**: Side-by-side comparison with the existing benchmark chart
5. **Community Section**: Quick links to Discourse, GitHub, Zulip, YouTube
6. **JuliaCon Banner**: Gradient card promoting the annual conference
7. **Dark Footer**: Professional footer with social links

## Color Palette

Uses the official Julia brand colors:
- Purple: `#9558B2`
- Red: `#CB3C33`
- Green: `#389826`
- Blue: `#4063D8`

## Usage

These files can be served as static HTML. They reference assets from the parent directory (`/assets/infra/`), so they're designed to work within the existing julialang.org structure.

To preview locally:
```bash
cd /path/to/www.julialang.org
python -m http.server 8000
# Then visit http://localhost:8000/modern/
```

## Notes

- Uses Tailwind CSS via CDN for zero build configuration
- Inter font from Google Fonts for modern typography
- All pages share consistent navigation and footer
- Links point to existing julialang.org pages where appropriate
