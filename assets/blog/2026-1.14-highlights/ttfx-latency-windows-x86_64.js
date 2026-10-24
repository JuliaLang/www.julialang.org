// Data for the latency chart in the Julia 1.14 highlights post, written by ttfx_latency.jl.
// Per build: [precompile, load, first call (cold), first call (warm)] in seconds, the geometric
// mean over the TTFX tasks that work on all builds.
// TODO: placeholder numbers.
(window.TTFX_LATENCY = window.TTFX_LATENCY || {})["Windows (x86-64)"] = {
"tasks":38,"cpu":"TODO",
"std":{"1.10":[13.92,0.69,0.98,0.98],"1.13":[12.21,0.54,0.81,0.81],"1.14":[10.79,0.49,0.75,0.27]},
"opt":{"1.14":[9.28,0.46,0.63,0.23]}};
