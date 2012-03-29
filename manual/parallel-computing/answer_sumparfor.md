---
layout: common
title: Answer
---
Define the following function:

    function sumrange_par(r::Range1{Int})
        c::Int64 = 0
        c = @parallel (+) for i = r
            convert(Int64,i)
        end
        c
    end

Then from the command line execute

    julia> sumrange_par(1:1000000)
    500000500000

The `convert` step is necessary only on a 32-bit machine.
