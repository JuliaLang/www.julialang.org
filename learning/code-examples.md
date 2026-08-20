# Code examples

[Check out the benchmark page to learn more about Julia's performance versus other languages](/benchmarks/)

In this example, we will play around with the Mandelbrotset which can be programmed in Julia using the below code. You can press "Run" below to see the output and feel free to try your own examples in [this empty REPL](https://julialang.org/learning/tryjulia/):

```Julia
function mandelbrot(a)
    z = 0
    for i=1:50
        z = z^2 + a
    end
    return z
end

for y=1.0:-0.05:-1.0
    for x=-2.0:0.0315:0.5
        abs(mandelbrot(complex(x, y))) < 2 ? print("*") : print(" ")
    end
    println()
end

# Taken from: https://rosettacode.org/wiki/Mandelbrot_set#Julia
```

~~~
<iframe height="700px" width="100%" src="https://repl.it/@logankilpatrick/Mandelbrotset?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>
~~~
