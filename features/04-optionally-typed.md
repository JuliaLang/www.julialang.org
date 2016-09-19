---
layout: feature
slug: optionally-typed
menu_title: Optionally typed
category: feature
---

## Julia is optionally typed

Julia does not force you to declare types of variables and arguments as, say, C or C++ would do.

Using type annotations in function arguments actually *adds behavior*, leading to concise and flexible organization of code.

Julia does run aggressive type inference at compilation time when it knows the types of the input variables to a function. This lets it generate fast machine code that can often run at speeds similar to compiled C code.
