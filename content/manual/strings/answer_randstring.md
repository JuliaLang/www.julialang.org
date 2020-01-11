---
layout: common
title: Answer
---
    function randstring(len::Int)
        const cset = char([0x30:0x39,0x41:0x5a,0x61:0x7a])
	const strset = convert(ASCIIString,strcat(cset...))
        index = int(ceil(strlen(strset)*rand(len)))
        s = strset[index]
        return s
    end
