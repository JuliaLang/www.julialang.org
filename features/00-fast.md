---
layout: feature
slug: fast
menu_title: Fast
category: feature
---

## Julia is _fast!_

<div class="u-flex u-hbox">
<div class="u-half-width">

<p>Julia was designed from the beginning to have certain features that are necessary for high performance: pervasive type inference, execution semantics that closely match the hardware capabilities, inlining, and macros. The standard library is carefully designed to allow type analysis.</p>

<p>Julia allows you to define your own types while removing the cost of the abstraction.</p>

</div>
<div class="u-half-width">
<pre class="language-julia"><code>
julia> immutable Cplx
         re::Int
         im::Int
       end

julia> Base.:+(a::Cplx, b::Cplx) =
           Cplxi(a.re+b.re, a.im+b.im)

julia> @code_native Cplxi(1,2) + Cplxi(3,4)
	.text
Filename: REPL[4]
	pushq	%rbp
	movq	%rsp, %rbp
Source line: 1
	movq	(%rdx), %rax
	movq	8(%rdx), %rcx
	addq	(%rsi), %rax
	addq	8(%rsi), %rcx
	movq	%rax, (%rdi)
	movq	%rcx, 8(%rdi)
	movq	%rdi, %rax
	popq	%rbp
	retq
	nop
</code></pre>
</div>
</div>
