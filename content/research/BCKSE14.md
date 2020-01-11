---
type: "inproceedings"
title: "Array operators using multiple dispatch: a design methodology for array implementations in dynamic languages"
authors:
- Jeff Bezanson
- Jiahao Chen
- Stefan Karpinski
- Viral Shah
- Alan Edelman
year: "2014"
pages: 56--61
booktitle: "ARRAY'14 Proceedings of ACM SIGPLAN International Workshop on Libraries, Languages, and Compilers for Array Programming"
publisher: "ACM"
address: "New York, {NY}, {USA}"
doi: "10.1145/2627373.2627383"
---
Arrays are such a rich and fundamental data type that they tend to be built into a language, either in the compiler or in a large low-level library. Defining this functionality at the user level instead provides greater flexibility for application domains not envisioned by the language designer. Only a few languages, such as C++ and Haskell, provide the necessary power to define n-dimensional arrays, but these systems rely on compile-time abstraction, sacrificing some flexibility. In contrast, dynamic languages make it straightforward for the user to define any behavior they might want, but at the possible expense of performance.
As part of the Julia language project, we have developed an approach that yields a novel trade-off between flexibility and compile-time analysis. The core abstraction we use is multiple dispatch. We have come to believe that while multiple dispatch has not been especially popular in most kinds of programming, technical computing is its killer application. By expressing key functions such as array indexing using multi-method signatures, a surprising range of behaviors can be obtained, in a way that is both relatively easy to write and amenable to compiler analysis. The compact factoring of concerns provided by these methods makes it easier for user-defined types to behave consistently with types in the standard library.