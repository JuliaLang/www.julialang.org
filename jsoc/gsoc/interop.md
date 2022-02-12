# Language interoperability – Summer of Code

## C++

### CxxWrap STL

The [CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl) package provides a way to load compiled C++ code into Julia. It exposes a small fraction of the C++ standard library to Julia, but many more functions and containers (e.g. `std::map`) still need to be exposed. The objective of this project is to improve C++ standard library coverage.

#### Expected outcome

1. Add missing STL container types (easy)
2. Add support for STL algorithms (intermediate)
3. Investigate improvement of compile times and selection of included types (advanced)

**Recommended Skills**: Familiarity with both Julia and C++

**Duration: 175h, expected difficulty: hard**

**Mentor**: [Bart Janssens](https://github.com/barche)
