# Ecosystem carousel images

Images shown in the Ecosystem section of the landing page (`index.html`).

The four plot images (`sciml`, `optimization`, `viz`, `ml`, each with a `-dark`
version for dark mode) are rendered by `tools/ecosystem-images/render.jl` with
OrdinaryDiffEq, JuMP/HiGHS, Makie and Lux.

The four logos come from the projects' own repositories, under their licences:

| File | Source | Licence |
|---|---|---|
| `autodiff.svg` | [Enzyme.jl `docs/src/assets/logo.svg`](https://github.com/EnzymeAD/Enzyme.jl/blob/main/docs/src/assets/logo.svg) | MIT |
| `gpu.webp` | [juliagpu.org `_assets/logo_crop.png`](https://github.com/JuliaGPU/juliagpu.org/blob/master/_assets/logo_crop.png) | JuliaGPU site asset |
| `data.webp` | [DataFrames.jl `docs/src/assets/logo.png`](https://github.com/JuliaData/DataFrames.jl/blob/main/docs/src/assets/logo.png) | MIT |
| `apps.svg` | [PythonCall.jl `docs/src/assets/logo.svg`](https://github.com/JuliaPy/PythonCall.jl/blob/main/docs/src/assets/logo.svg) | MIT |

Raster logos were converted to WebP with `cwebp`.
