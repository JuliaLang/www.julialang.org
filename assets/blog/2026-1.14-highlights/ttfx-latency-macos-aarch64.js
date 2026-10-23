// Data for the latency chart in the Julia 1.14 highlights post, written by ttfx_latency.jl.
// Per build: [precompile, load, first call (cold), first call (warm)] in seconds, the geometric
// mean over the TTFX tasks that work on all builds.
// TODO: placeholder numbers.
(window.TTFX_LATENCY = window.TTFX_LATENCY || {})["macOS (Apple silicon)"] = {
"tasks":38,"cpu":"TODO",
"std":{"1.10":[6.66,0.3,0.6,0.58],"1.13":[5.85,0.24,0.5,0.47],"1.14":[5.17,0.22,0.46,0.16]},
"opt":{"1.14":[4.44,0.2,0.39,0.13]}};
