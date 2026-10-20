# Ecosystem tab images

`render.jl` draws the images shown in the Ecosystem tabs on the landing page
(`index.html`) and writes them to `_assets/infra/ecosystem-*.webp`:

| Image | Tab | What it shows |
|---|---|---|
| `ecosystem-data.webp` | Data Science & Visualization | A faceted AlgebraOfGraphics plot of a DataFrame |
| `ecosystem-general.webp` | General Purpose | Julia calling into other languages |
| `ecosystem-ml.webp` | Machine Learning | Decision boundary of a small Lux classifier |
| `ecosystem-sci.webp` | Scientific Computing | The Lorenz attractor, solved with OrdinaryDiffEq |
| `ecosystem-parallel.webp` | Parallel Computing | A Mandelbrot set computed with `Threads.@threads` |

To regenerate them (requires `cwebp`, e.g. `brew install webp`):

```sh
julia --project=tools/ecosystem-images -e 'using Pkg; Pkg.instantiate()'
julia --project=tools/ecosystem-images -t auto tools/ecosystem-images/render.jl
```

This folder is excluded from the Franklin build (`ignore` in `config.md`).
