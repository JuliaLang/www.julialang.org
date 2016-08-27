---
layout: feature
slug: fast
menu_title: Fast
category: feature
---

## Julia is _fast!_

<div class="u-flex u-hbox">
<span class="u-half-width">

Although Julia is a high level language which gives you freedom to create your own convenient abstractions, the language is designed such that the compiler can remove all the abstraction and produce very fast machine code.

</span>
<pre class="language-julia"><code>
  julia> @code_native (1+1im) + (1+3im)
    .text
  Filename: complex.jl
  Source line: 111
    pushq	%rbp
    movq	%rsp, %rbp
  Source line: 111
    movq	(%rdx), %rax
    movq	8(%rdx), %rcx
  Source line: 111
    addq	(%rsi), %rax
    addq	8(%rsi), %rcx
    movq	%rcx, 8(%rdi)
    movq	%rax, (%rdi)
    movq	%rdi, %rax
    popq	%rbp
    ret
</code></pre>
</div>
