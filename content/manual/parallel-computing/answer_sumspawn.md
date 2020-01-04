---
layout: common
title: Answer
---
Define the following function:

    function sumrange(r::Range1{Int})
        c::Int64 = 0
        for i = r
            c += i
        end
        c
    end


    julia> a = @spawnat 2 sumrange(1:500000); b = @spawnat 1 sumrange(500001:1000000); fetch(a)+fetch(b)
    500000500000

Note that on a 32-bit machine, you'll get the wrong answer unless you use `Int64`.
