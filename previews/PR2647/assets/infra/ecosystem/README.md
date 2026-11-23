# Ecosystem carousel images

Images shown in the Ecosystem section of the landing page (`index.html`).

The four plot images (`sciml`, `optimization`, `viz`, `ml`, each with a `-dark`
version for dark mode) are rendered by `tools/ecosystem-images/render.jl` with
OrdinaryDiffEq, JuMP/HiGHS, Makie and Lux.

Three logos come from the projects themselves and the gears are drawn after the JuliaInterop logo. In dark mode the page inverts them with a hue rotation, which keeps their colours:

| File | Source | Licence |
|---|---|---|
| `autodiff.svg` | [Enzyme.jl `docs/src/assets/logo.svg`](https://github.com/EnzymeAD/Enzyme.jl/blob/main/docs/src/assets/logo.svg) | MIT |
| `gpu.webp` | [juliagpu.org `_assets/logo_crop.png`](https://github.com/JuliaGPU/juliagpu.org/blob/master/_assets/logo_crop.png) | MIT |
| `data.webp` | [DataFrames.jl `docs/src/assets/logo.png`](https://github.com/JuliaData/DataFrames.jl/blob/main/docs/src/assets/logo.png) | MIT |
| `apps.svg` | Interlocking gears after the [JuliaInterop logo](https://github.com/JuliaInterop), drawn by `tools/ecosystem-images/gears.py` | — |

Raster logos were converted to WebP with `cwebp`.
