---
layout: common
title: Answer
---
First, the "inner" function that gets spawned.  Note we provide the outputs as arguments, to pass information about the indices that should be processed.
    
    function nearestneighbor_darray{T}(X::Matrix{T},inn::DArray{Int,1,1},d2nn::DArray{T,1,1})
        indx = myindexes(inn)  # get "basepoint indices" assigned to this processor
        for iblock = 1:length(indx) # loop over blocks of contiguous indices
            thisblock = indx[iblock]
            for ipoint = thisblock  # loop over basepoints in this block
                inn[ipoint], d2nn[ipoint] = nnx(X,ipoint)
            end
        end
    end
    
Now, the "outer" function, the one called by the user:

    function nearestneighbor{T}(X::Matrix{T})
        d, N = size(X)
        inn = dzeros(Int,(N))  # allocate the storage for the results
        d2nn = dzeros(T,(N))
        println(inn.pmap)
        @sync begin
            for i = length(inn.pmap):-1:1  # reverse so don't block til end
                r = inn.dist[i]:inn.dist[i+1]-1
                @spawnat inn.pmap[i] nearestneighbor_darray(X,inn,d2nn)
            end
        end
        inn_ret = convert(Array,inn)
        d2nn_ret = convert(Array,d2nn)
        inn_ret, d2nn_ret
    end
