// Data for the latency chart in the Julia 1.14 highlights post, written by ttfx_latency.jl.
// Per build: [precompile, load, first call (cold), first call (warm)] in seconds, the geometric
// mean over the TTFX tasks that work on all builds.
// TODO: placeholder numbers.
(window.TTFX_LATENCY = window.TTFX_LATENCY || {})["Linux (x86-64)"] = {
"tasks":38,"cpu":"TODO",
"std":{"1.10":[9.8,0.42,0.81,0.79],"1.13":[8.6,0.33,0.67,0.65],"1.14":[7.6,0.3,0.62,0.22]},
"opt":{"1.14":[6.54,0.28,0.52,0.18]}};
