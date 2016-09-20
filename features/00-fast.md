---
layout: feature
slug: fast
menu_title: Fast
category: feature
---

## Julia is _fast!_

<div class="u-flex u-hbox">
  <div class="u-half-width">Julia was designed from the beginning to have certain features that are necessary for high performance: pervasive type inference, execution semantics that closely match the hardware capabilities, inlining, and macros. The standard library is carefully designed to allow type analysis.</div>
<a href="/benchmarks/">
 <img class="benchmark-plot" src="benchmark-preview.svg" title="Click on the plot for more detail">
</a>
</div>

<div class="u-flex u-hbox">
  <div class="u-half-width">
    <div class="u-vskip-3"></div>
    <pre class="language-julia"><code>julia> immutable Cplx
         re::Int
         im::Int
       end

julia> Base.:+(a::Cplx, b::Cplx) =
           Cplxi(a.re+b.re, a.im+b.im)

julia> @code_native Cplxi(1,2) + Cplxi(3,4)
       .text
Filename: REPL[4]
       pushq   %rbp
       movq    %rsp, %rbp
Source line: 1
       movq    (%rdx), %rax
       movq    8(%rdx), %rcx
       addq    (%rsi), %rax
       addq    8(%rsi), %rcx
       movq    %rax, (%rdi)
       movq    %rcx, 8(%rdi)
       movq    %rdi, %rax
       popq    %rbp
       retq
       nop
    </code></pre>
  </div>
  <div>
    <h3>Julia removes cruft</h3>
  <p>While Julia allows you to create rich higher-level abstractions, it works hard to remove the abstractions and compiling to fast machine code when the time comes to run your code.</p>

<p>It has powerful tools to help you see if your program is performing at its best. The <code>@code_native</code> macro, for example, lets you see the assembly code that will be executed when you run an expression.</p>
  </div>
</div>
