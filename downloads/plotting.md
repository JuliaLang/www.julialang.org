---
layout: default
title:  Plotting in Julia
---

# Plotting in Julia

Plotting in Julia is available through external packages.

## PyPlot

[PyPlot](https://github.com/stevengj/PyPlot.jl) uses the Julia PyCall
package to call Python's matplotlib directly from Julia with little or
no overhead (arrays are passed without making a copy). Make sure that
Python and MatPlotlib are correctly installed. Installation of
PyPlot.jl and example usage are as follows:

{% highlight julia %}
Pkg.add("PyPlot")
using PyPlot
x = linspace(0,2*pi,1000); y = sin(3*x + 4*cos(2*x))
plot(x, y, color="red", linewidth=2.0, linestyle="--")
{% endhighlight %}

## Gadfly

Gadfly is an implementation of a
[Wickham-Wilkinson](http://www.cs.uic.edu/%7Ewilkinson/TheGrammarOfGraphics/GOG.html)
style grammar of graphics in Julia. Add the Gadfly package to your
Julia installation with the following command on the Julia prompt:

{% highlight julia %}
Pkg.add("Gadfly")
using Gadfly
draw(SVG("output.svg", 6inch, 3inch), plot([sin, cos], 0, 25))
{% endhighlight %}

Gadfly's interface will be familiar to users of R's
[ggplot2](http://ggplot2.org) package. See
[examples](https://github.com/dcjones/Gadfly.jl/tree/master/doc) and
documentation on the [Gadfly](https://github.com/dcjones/Gadfly.jl)
homepage.
