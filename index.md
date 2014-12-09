---
layout: default
title:  The Julia Language
---

Julia is a high-level dynamic programming language designed to address the requirements of high-performance numerical and scientific computing while also being effective for general purpose programming. [Learn more](/about)

<div>
<div class="grid-left">
<h1>Features</h1>

<ul>
<li>Multiple dispatch and functional</li>
<li>Dynamic type system with optional types</li>
<li>High performance via JIT compilation</li>
<li>Built-in package manager</li>
<li>Lisp-like macros</li>
<li>Powerful shell-like capabilities</li>
<li>Coroutines: lightweight &ldquo;green&rdquo; threading</li>
<li>Efficient support for Unicode</li>
<li>Free and open source</li>
</ul>

</div>
<div class="grid-right">
<h1>Example</h1>

{% highlight julia %}
v = [1.0 1.0 0.0]
for i=1:4
    v *= [[cospi(1/4) -sinpi(1/4) 0],
          [sinpi(1/4)  cospi(1/4) 0],
          [0          0           1]]
    println("Rotated vector: $v")
end
v /= norm(v)
println("Normalized vector: $v")
{% endhighlight %}

<p><a href="http://www.juliabox.org/">Try Julia in your browser on JuliaBox!</a></p>
</div>
</div>
<p style="clear: both; padding-top: 2.5em; text-align: center">
    <iframe src="http://ghbtns.com/github-btn.html?user=JuliaLang&repo=julia&type=watch&count=true&size=large"
  allowtransparency="true" frameborder="0" scrolling="0" width="160" height="30"></iframe>
  <a href="https://twitter.com/JuliaLanguage" class="twitter-follow-button" data-show-count="true" data-size="large">Follow @JuliaLanguage</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
</p>
