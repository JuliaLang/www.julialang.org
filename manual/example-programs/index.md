---
layout: manual
title:  Example Programs
---

## Generate All Permutations with Coroutines

```
##!/usr/bin/env julia

macro task(ex); :(Task(()->$ex)); end

copy_swap(v,i,j) = (w=copy(v); (w[i],w[j])=(w[j],w[i]); w)

function produce_perms(v,i)
  if length(v) < i
    produce(v)
  else
    for j = i:length(v)
      produce_perms(copy_swap(v,i,j), i+1)
    end
  end
end

for perm = @task produce_perms([1,2,3,4],1)
  println(perm)
end
```

## Split a string into an array of tokens

```
function split(s::String, delims)
    i = 1
    strs = {}
    len = length(s)
    while true
        tokstart = tokend = i
        while !done(s,i)
            (c,i) = next(s,i)
            if contains(delims, c)
                break
            end
            tokend = i
        end
        tok = s[tokstart:(tokend-1)]
        push(strs, tok)
        if !((i <= len) || (i==len+1 && tokend!=i))
            break
        end
    end
    strs
end
```

## Load a matrix in text file format

```
function load_ascii_array(filename::String, nr, nc)
    f = open(filename)
    a = Array(Float64, nr, nc)
    for i=1:nr
        row = split(readline(f), (' ','\t'), false)
        for j=1:nc
            a[i,j] = float64(row[j])
        end
    end
    a
end
```

## Count the lines in a text file using the external `wc` program

```
count_lines(fname::String) = int(split(readall(`wc -l $fname`),' ')[1])
```

## Generalized GCD

```
## return (gcd(a,b),x,y) such that ax+by == gcd(a,b)
function gcdx(a, b)
    if b == 0
        (a, 1, 0)
    else
        m = rem(a, b)
        k = div((a-m), b)
        (g, x, y) = gcdx(b, m)
        (g, y, x-k*y)
    end
end
```
