---
layout: common
title: Answer
---
`isless(x,y)` uses the following rules:

- If both `x` and `y` are non-`NaN`, `isless(x,y)` is equivalent to `x < y` (exception: `isless` distinguishes `-0.0` from `+0.0`)
- `NaN` comes after all other numbers, including `Inf`

`<` follows IEEE 754 standards, whereas `isless` operates more directly on the bit representation.  If you're curious, you can find the definitions of all these functions in the `float.jl` file.