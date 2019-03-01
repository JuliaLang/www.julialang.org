---
layout: post
title: 在 Julia 自訂原始型別（primitive type）
author: 鄭景文（Peter Cheng）, 杜岳華（Yueh-Hua Tu）
---

Julia 提供了一些 APIs 讓我們能夠在 Julia 內自訂原始型別（primitive types），然而當你打開[原始型別的官方文件](https://docs.julialang.org/en/v1/manual/types/#Primitive-Types-1)時，你會發現你仍然不知道要怎麼在你的程式中去使用自訂的原始型別，所以這邊寫了一個簡單的文件教你如何去自訂原始型別。


## 簡介

一開始你需要先透過關鍵字 `primitive type` 來宣告，他會需要提供這個型別的名稱以及他所需要的位元數。

    primitive type «name» «bits» end
    primitive type «name» <: «supertype» «bits» end

目前 Julia 只支援位元大小是 8 的倍數的原始型別，所以像是 `Bool` 只需要一個 01 但你還是需要宣告他成 8 個位元，像這樣:

```julia
    primitive type Bool <: Integer 8 end
```

到這邊就幾乎是官方文件上所有的東西，接下來我們將會用一個簡單的例子來介紹自訂原始型別。


## 問題

在我們宣告了我們自己的原始型別之後，比如像這樣:

```julia
    primitive type A 72 end
```

但你很快就會發現你不知道該怎麼建立一個 `A` 的新物件，因為 Julia 並沒有提供自訂的原始型別的預設建構子，並且如果你繼續思考你會發現你也不知道要如何操作這些自訂的物件，就算你只是想做個 bitwise 加法也沒辦法，因為 `+` 沒有我們 `A` 的方法（method）。

那我們能怎麼辦？實際上，Julia 的確有函數來讓我們做這些操作，但大多數的這些函數都是從 Julia 的 C++ 原始碼生成或是從 LLVM 接出來的，所以在我們開始之前我們需要先簡單看一下在 `Core.Intrinsics` 的這些函數。


## Core.Intrinsics

就如同上面提到大多數的函數都在 `Core.Intrinsics` 底下，我們會簡單介紹我們會用到的函數，如果你熟悉 LLVM Intrinsics，你也會比較習慣這些函數，(我們不會提到使用浮點數的部分) 

1.  建立型別
    
    1.  `Core.Intrinsics.bitcase(type, value)`
    
        `bitcase` 告訴 LLVM 從 `value` 建立一個新的同樣大小與數值的物件並標成 `type`，`value` 的型別的位元數必須跟 `type` 一樣。
    
    2.  `Core.Intrinsics.trunc_int(type, value)`
    
        `trunc_int`會將一個較大位元大小的 `value` 截成 `type` 的大小並標成 `type`。
    
    3.  `Core.Intrinsics.sext_int(type, value)`
    
        `sext_int` 會叫一個較小位元大小的 `value`  做符號延伸（sign extension）成 `type` 的大小並標成 `type`。
    
    4.  `Core.Intrinsics.zext_int(type, value)`
    
        `zext_int` 會叫一個較小位元大小的 `value`  在高位補 0 成 `type` 的大小並標成 `type`。

2.  數學運算
    1.  `Core.Intrinsics.add_int(value1, value2)`
    
        計算 `value1 + value2`。
    
    2.  `Core.Intrinsics.sub_int(value1, value2)`
    
        計算 `value1 - value2`。
    
    3.  `Core.Intrinsics.mul_int(value1, value2)`
    
        計算 `value1 * value2`。
    
在 [Core.Intrinsics 參考文獻](#reference) 有更多函數定義。 

現在我們有基本需要的函數，就可以開始定義方法了。


## 定義方法

要定義一個自訂原始型別的建構子，我們需要從一個已有的原始型別轉換過來，

比如說: 

```julia
import Base: +
primitive type A 72 end
```

底下我們定義了一個 `A` 的建構子，我們將 `Int64` 延伸成 72 位元並轉成 `A`。

```julia
A(x::Int64) = Core.Intrinsics.zext_int(A, x)
```

將 `Int128` 截成 72 位元並標成型別 `A`。

```julia
A(x::Int128) = Core.Intrinsics.trunc_int(A, x)
```

重載 `Base.+` 來定義 `A` 的加法

```julia
+(x::A, y::A) = Core.Intrinsics.add_int(x, y)
```

最後，原始型別 `A` 的用法就會看起來像這樣：

```julia
a1 = A(3) #建立 A 的物件
a2 = A(12345678901234567890)

a1 + a2 # 將 a1 a2 的值加起來
```


## Q&A

Q. 自訂原始型別有什麼好處? 為什麼不直接對內建的原始型別定個型別包起來或是做別稱?
A. 
第一個是如果你要分派（dispatch）在那個型別，那做別稱就不一定可行，因為他們實際上還是同一個。 

第二個是自訂型別包起來就會需要額外的時間解開，且 Julia 編譯器就不一定能去最佳化這段程式碼，比較上面自訂的 `A` 跑 `@code_llvm a1 + a2` 跟包起來的結果就會知道差異。

最後是自訂 原始型別 可以自訂型別的位元數並交給 LLVM 去變魔術。

Q. 我可以在哪裡找到更多資訊?
A. 你可以在 [LLVM reference](https://llvm.org/docs/LangRef.html) 找到 LLVM Intrinsics 的部分，從 [Intrinsics 的 Julia c++ source code](https://github.com/JuliaLang/julia/blob/80516ca20297a67b996caa08c38786332379b6a5/src/intrinsics.cpp#L853-L1241) 找到 `Core.Intrinsics` 的部分以及在 [header file](https://github.com/JuliaLang/julia/blob/v1.1.0/src/intrinsics.h) 找到關於這些函數的參數需求， [codegen](https://github.com/JuliaLang/julia/blob/v1.1.0/src/codegen.cpp) 跟 [ccall](https://github.com/JuliaLang/julia/blob/v1.1.0/src/ccall.cpp) 有更多的細節，最後是在[Julia 的測試](https://github.com/JuliaLang/julia/blob/v1.1.0/test/intrinsics.jl) 以及 [內建原始型別](https://github.com/JuliaLang/julia/blob/v1.1.0/base/boot.jl) 有 Julia code 的程式範例。


## Bitboard 範例
[bitboard](https://en.wikipedia.org/wiki/Bitboard) 是一種將棋盤遊戲的盤面存成二進位表示的方法，舉例來說我們想將一個 [2048 遊戲](https://en.wikipedia.org/wiki/2048_(video_game)) 存成 bitboard，我們可以這樣做:

```julia
using Core.Intrinsics
using Base.Printf: @printf
import Base: show

abstract type AbstractBoard end
primitive type BitBoard64 <: AbstractBoard 64 end
primitive type BitBoard128 <: AbstractBoard 128 end

const BitBoard = BitBoard64

function Base.show(io::IO, t::AbstractBoard)
    println(io,"+------------------------+")
    for i in 0:3
        @printf "|%6d%6d%6d%6d|\n" (t(i,0), t(i,1), t(i,2), t(i,3))...
    end
    println(io,"+------------------------+")
end

BitBoard64() = bitcast(BitBoard64, 0)
BitBoard64(x::Int) = bitcast(BitBoard64, x)
BitBoard64(x::UInt) = bitcast(BitBoard64, x)

BitBoard128() = zext_int(BitBoard128, 0)
BitBoard128(x::Int) = zext_int(BitBoard128, x)
BitBoard128(x::UInt) = zext_int(BitBoard128, x)
BitBoard128(x::UInt128) = bitcast(BitBoard128, x)
BitBoard128(x::Int128) = bitcast(BitBoard128, x)

(b::BitBoard64)(i::Int) = bitcast(Int, lshr_int(b, 4 * (15 - i))) & Int(0xf)
(b::BitBoard64)(i::Int, j::Int) = b(4i + j)

(b::BitBoard128)(i::Int) = trunc_int(Int, lshr_int(b, 8 * (15 - i))) & Int(0xff)
(b::BitBoard128)(i::Int, j::Int) = b(4i + j)

function Base.transpose(x::BitBoard64)
    t = and_int(xor_int(x, lshr_int(x, 12)), BitBoard64(0x0000f0f00000f0f0))
    x = xor_int(x, xor_int(t, shl_int(t, 12)))
    t = and_int(xor_int(x, lshr_int(x, 24)), BitBoard64(0x00000000ff00ff00))
    x = xor_int(x, xor_int(t, shl_int(t, 24)))
    x
end

function reflect_vertical(x::BitBoard64)
    t = and_int(xor_int(x, lshr_int(x, 32)), BitBoard64(0x00000000ffffffff))
    x = xor_int(x, xor_int(t, shl_int(t, 32)))
    t = and_int(xor_int(x, lshr_int(x, 16)), BitBoard64(0x0000ffff0000ffff))
    x = xor_int(x, xor_int(t, shl_int(t, 16)))
    x
end

function reflect_horizontal(x::BitBoard64)
    t = and_int(xor_int(x, lshr_int(x, 8)), BitBoard64(0x00ff00ff00ff00ff))
    x = xor_int(x, xor_int(t, shl_int(t, 8)))
    t = and_int(xor_int(x, lshr_int(x, 4)), BitBoard64(0x0f0f0f0f0f0f0f0f))
    x = xor_int(x, xor_int(t, shl_int(t, 4)))
    x
end

function Base.transpose(x::BitBoard128)
    t = and_int(xor_int(x, lshr_int(x, 24)), BitBoard128(0x00000000ff00ff0000000000ff00ff00))
    x = xor_int(x, xor_int(t, shl_int(t, 24)))
    t = and_int(xor_int(x, lshr_int(x, 48)), BitBoard128(0x0000000000000000ffff0000ffff0000))
    x = xor_int(x, xor_int(t, shl_int(t, 48)))
    x
end

function reflect_vertical(x::BitBoard128)
    t = and_int(xor_int(x, lshr_int(x, 64)), BitBoard128(0x0000000000000000ffffffffffffffff))
    x = xor_int(x, xor_int(t, shl_int(t, 64)))
    t = and_int(xor_int(x, lshr_int(x, 32)), BitBoard128(0x00000000ffffffff00000000ffffffff))
    x = xor_int(x, xor_int(t, shl_int(t, 32)))
    x
end

function reflect_horizontal(x::BitBoard128)
    t = and_int(xor_int(x, lshr_int(x, 16)), BitBoard128(0x0000ffff0000ffff0000ffff0000ffff))
    x = xor_int(x, xor_int(t, shl_int(t, 16)))
    t = and_int(xor_int(x, lshr_int(x, 8)), BitBoard128(0x00ff00ff00ff00ff00ff00ff00ff00ff))
    x = xor_int(x, xor_int(t, shl_int(t, 8)))
    x
end

function rotate_right(b::AbstractBoard)
    b = transpose(b)
    b = reflect_horizontal(b)
    b
end

function rotate_left(b::AbstractBoard)
    b = transpose(b)
    b = reflect_vertical(b)
    b
end

GetRow(t::BitBoard128, r::Int)::UInt32 = and_int(trunc_int(UInt32, lshr_int(t, 32 * (3 - r))), 0xffffffff)
GetRow(t::BitBoard64, r::Int)::UInt16 = and_int(trunc_int(UInt16, lshr_int(t, 16 * (3 - r))), 0xffff)

function empty(b::AbstractBoard)::Vector{Int}
    a = Vector{Int}()
    for i in 0:15
        if b(i) == 0
            push!(a, i)
        end
    end
    return a
end
```


<a id="reference"></a>

## Core.Intrinsics 參考文獻

一些 `Core.Intrinsics` 函數的參考文件。
1.  建立型別
    
    1.  `Core.Intrinsics.bitcase(type, value)`
    
        `bitcase` 告訴 LLVM 從 `value` 建立一個新的同樣大小與數值的物件並標成 `type`，`value` 的型別的位元數必須跟 `type` 一樣。
    
    2.  `Core.Intrinsics.trunc_int(type, value)`
    
        `trunc_int`會將一個較大位元大小的 `value` 截成 `type` 的大小並標成 `type`。
    
    3.  `Core.Intrinsics.sext_int(type, value)`
    
        `sext_int` 會叫一個較小位元大小的 `value`  做符號延伸（sign extension）成 `type` 的大小並標成 `type`。
    
    4.  `Core.Intrinsics.zext_int(type, value)`
    
        `sext_int` 會叫一個較小位元大小的 `value`  做符號延伸（sign extension）成 `type` 的大小並標成 `type`。

2.  數學運算
    1.  `Core.Intrinsics.neg_int(value)`

        `value` 數值的負數值.
    
    2.  `Core.Intrinsics.add_int(value1, value2)`
    
        計算 `value1 + value2`.
    
    3.  `Core.Intrinsics.sub_int(value1, value2)`
    
        計算 `value1 - value2`.
    
    4.  `Core.Intrinsics.mul_int(value1, value2)`
    
        計算 `value1 * value2`.
    
    5.  `Core.Intrinsics.sdiv_int(value1, value2)`
    
        計算有號數商數。
    
    6.  `Core.Intrinsics.udiv_int(value1, value2)`
    
        計算無好數商數。

    7.  `Core.Intrinsics.srem_int(value1, value2)`

        計算有號數餘數。
    
    8.  `Core.Intrinsics.urem_int(value1, value2)`
    
        計算無號數餘數。
    
    9.  `Core.Intrinsics.checked_*_int(value1, value2)`
    
        計算運算同時檢查有無溢位。回傳一個結果值以及表示是否溢位的布林值。

3.  邏輯運算
    1.  `Core.Intrinsics.bswap_int(value)`

        將 `value` 的高位位元組及低位位元組對調。
    
    2.  `Core.Intrinsics.not_int(value)`
    
        計算位元非。
    
    3.  `Core.Intrinsics.eq_int(value1, value2)`
    
        計算 `value1 == value2`.
    
    4.  `Core.Intrinsics.ne_int(value1, value2)`
    
        計算 `value1 != value2`.
    
    5.  `Core.Intrinsics.slt_int(value1, value2)`
    
        計算有號數小於。
    
    6.  `Core.Intrinsics.ult_int(value1, value2)`
    
        計算無號數小於。
    
    7.  `Core.Intrinsics.sle_int(value1, value2)`
    
        計算有號數小於等於。
    
    8.  `Core.Intrinsics.ule_int(value1, value2)`
    
        計算無號數小於等於。
    
    9.  `Core.Intrinsics.and_int(value1, value2)`
    
        計算位元且。
    
    10. `Core.Intrinsics.or_int(value1, value2)`
    
        計算位元或。
    
    11. `Core.Intrinsics.xor_int(value1, value2)`

        計算位元互斥或。
    
    12. `Core.Intrinsics.shl_int(value)`

        計算位元左位移。
    
    13. `Core.Intrinsics.lshr_int(value)`
    
        計算位元邏輯右位移。
    
    14. `Core.Intrinsics.ashr_int(value)`
    
        計算位元算數右位移。
    
    15. `Core.Intrinsics.ctpop_int(value)`
    
        計算 `value` 裡的 1 的數量。
    
    16. `Core.Intrinsics.ctlz_int(value)`
    
        計算 `value` 裡的前導 0 （leading zeros）的數量。
    
    17. `Core.Intrinsics.cttz_int(value)`
    
        計算 `value` 裡的尾隨 0 （trailing zeros）的數量。
    
    18. `Core.Intrinsics.flipsign_int(value1, value2)`
    
        計算 `value2 >= 0 ? value1 : -value1` 。

