# Ecosystem carousel plot images

`render.jl` draws the four plot images shown in the Ecosystem carousel on the
landing page (`index.html`), each in a light and a dark version, and writes them
to `_assets/infra/ecosystem/`:

| Images | Slide | What they show |
|---|---|---|
| `sciml.webp`, `sciml-dark.webp` | Scientific machine learning | The Lorenz attractor, solved with OrdinaryDiffEq |
| `optimization.webp`, `optimization-dark.webp` | Optimization | A linear program solved with JuMP and HiGHS |
| `viz.webp`, `viz-dark.webp` | Visualization & notebooks | A Makie surface plot |
| `ml.webp`, `ml-dark.webp` | Machine learning | Decision boundary of a small Lux classifier |

The page swaps the dark versions in with the theme (`data-src-dark`, handled in
`_libs/detectdark.js`). `gears.py` draws `apps.svg`, the interlocking gears on the Apps slide (after the
JuliaInterop logo). The other three slides use the projects' logos, listed in
`_assets/infra/ecosystem/README.md`.

To regenerate (requires `cwebp`, e.g. `brew install webp`):

```sh
julia --project=tools/ecosystem-images -e 'using Pkg; Pkg.instantiate()'
julia --project=tools/ecosystem-images tools/ecosystem-images/render.jl
```

This folder is excluded from the Franklin build (`ignore` in `config.md`).
