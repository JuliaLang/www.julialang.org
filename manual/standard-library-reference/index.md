---
layout: manual
title:  Standard Library Reference
---

## Getting Around

`exit([code])` — Quit (or control-D at the prompt). The default exit code is zero, indicating that the processes completed successfully.

`whos()` — Print information about global user-defined variables.

`edit("file"[, line])` — Edit a file optionally providing a line number to edit at. Returns to the julia prompt when you quit the editor. If the file name ends in ".jl" it is reloaded when the editor closes the file.

`edit(function[, types])` — Edit the definition of a function, optionally specifying a tuple of types to indicate which method to edit. When the editor exits, the source file containing the definition is reloaded.

`load("file")` — Evaluate the contents of a source file

## All Objects

`is(x, y)` — Determine whether `x` and `y` refer to the same object in memory.

`isa(x, type)` — Determine whether `x` is of the given type.

`isequal(x, y)` — True if and only if `x` and `y` have the same contents.
Loosely speaking, this means `x` and `y` would look the same when printed.

`isless(x, y)` — Test whether `x` is less than `y`. Provides a total order consistent with `isequal`. Values that are normally unordered, such as `NaN`, are ordered in an arbitrary but consistent fashion. This is the default comparison used by `sort`. Non-numeric types that can be ordered should implement this function.

`typeof(x)` — Get the concrete type of `x`.

`tuple(xs...)` — Construct a tuple of the given objects.

`ntuple(n, f::Function)` — Create a tuple of length `n`, computing each element as `f(i)`, where `i` is the index of the element.

`uid(x)` — Get a unique integer id for `x`. `uid(x)==uid(y)` if and only if `is(x,y)`.

`hash(x)` — Compute an integer hash code such that `isequal(x,y)` implies `hash(x)==hash(y)`.

`finalizer(x, function)` — Register a function to be called on `x` when there are no program-accessible references to `x`. The behavior of this function is unpredictable if `x` is of a bits type.

`copy(x)` — Create a deep copy of `x`:
i.e. `copy` is called recursively on all constituent parts of `x`.
If a user-defined type should be recursively copied, a `copy` method should be defined for it which implements deep copying of an instance.

`convert(type, x)` — Try to convert `x` to the given type.

`promote(xs...)` — Convert all arguments to their common promotion type (if any), and return them all (as a tuple).

## Types

`subtype(type1, type2)` — True if and only if all values of `type1` are also of `type2`. Can also be written using the `<:` infix operator as `type1 <: type2`.

`typemin(type)` — The lowest value representable by the given (real) numeric type.

`typemax(type)` — The highest value representable by the given (real) numeric type.

`realmin(type)` — The smallest in absolute value non-denormal value representable by the given floating-point type

`realmax(type)` — The highest finite value representable by the given floating-point type

`sizeof(type)` — Size, in bytes, of the canonical binary representation of the given type, if any.

`eps([type])` — The distance between 1.0 and the next largest representable floating-point value of `type`. The only types that are sensible arguments are `Float32` and `Float64`. If `type` is omitted, then `eps(Float64)` is returned.

`eps(x)` — The distance between `x` and the next largest representable floating-point value of the same type as `x`.

`promote_type(type1, type2)` — Determine a type big enough to hold values of each argument type without loss, whenever possible. In some cases, where no type exists which to which both types can be promoted losslessly, some loss is tolerated; for example, `promote_type(Int64,Float64)` returns `Float64` even though strictly, not all `Int64` values can be represented exactly as `Float64` values.

## Generic Functions

`method_exists(f, tuple)` — Determine whether the given generic function has a method matching the given tuple of argument types.

`applicable(f, args...)` — Determine whether the given generic function has a method applicable to the given arguments.

`invoke(f, (types...), args...)` — Invoke a method for the given generic function matching the specified types (as a tuple), on the specified arguments. The arguments must be compatible with the specified types. This allows invoking a method other than the most specific matching method, which is useful when the behavior of a more general definition is explicitly needed (often as part of the implementation of a more specific method of the same function).

## Iteration

Sequential iteration is implemented by the methods `start`, `done`, and `next`.
The general `for` loop:

    for i = I
      # body
    end

is translated to:

    state = start(I)
    while !done(I, state)
      (i, state) = next(I, state)
      # body
    end

The `state` object may be anything, and should be chosen appropriately for each iterable type.

`start(iter)` — Get initial iteration state for an iterable object

`done(iter, state)` — Test whether we are done iterating

`(item, state) = next(iter, state)` — For a given iterable object and iteration state, return the current item and the next iteration state

Fully implemented by: `Range`, `Range1`, `NDRange`, `Tuple`, `Real`, `AbstractArray`, `IntSet`, `IdTable`, `HashTable`, `WeakKeyHashTable`, `LineIterator`, `String`, `Set`, `Task`.

## General Collections

`isempty(collection)` — Determine whether a collection is empty (has no elements).

`numel(collection)` — Return the number of elements in a collection.

`length(collection)` — For ordered, indexable collections, the maximum index `i` for which `ref(collection, i)` is valid.

Fully implemented by: `Range`, `Range1`, `Tuple`, `Number`, `AbstractArray`, `IntSet`, `HashTable`, `WeakKeyHashTable`, `String`, `Set`.

Partially implemented by: `FDSet`.

## Iterable Collections

`contains(itr, x)` — Determine whether a collection contains the given value, `x`.

`reduce(op, v0, itr)` — Reduce the given collection with the given operator, i.e. accumulate `v = op(v,elt)` for each element, where `v` starts as `v0`. Reductions for certain commonly-used operators are available in a more convenient 1-argument form: `max(itr)`, `min(itr)`, `sum(itr)`, `prod(itr)`, `any(itr)`, `all(itr)`.

`max(itr)` — Determine maximum element in a collection

`min(itr)` — Determine minimum element in a collection

`sum(itr)` — Sum elements of a collection

`prod(itr)` — Multiply elements of a collection

`any(itr)` — Test whether any elements of a boolean collection are true

`all(itr)` — Test whether all elements of a boolean collection are true

`count(itr)` — Count the number of boolean elements in `itr` which are `true` rather than `false`.

`countp(p, itr)` — Count the number of elements in `itr` for which predicate `p` is true.

`anyp(p, itr)` — Determine whether any element of `itr` satisfies the given predicate.

`allp(p, itr)` — Determine whether all elements of `itr` satisfy the given predicate.

`map(f, c)` — Transform collection `c` by applying `f` to each element

## Indexable Collections

`ref(collection, key...)`, also called by the syntax `collection[key...]` — Retrieve the value(s) stored at the given key or index within a collection.

`assign(collection, value, key...)`, also called by the syntax `collection[key...] = value` — Store the given value at the given key or index within a collection.

Fully implemented by: `Array`, `DArray`, `AbstractArray`, `SubArray`, `IdTable`, `HashTable`, `WeakKeyHashTable`, `String`.

Partially implemented by: `Range`, `Range1`, `Tuple`.

## Associative Collections

`has(collection, key)` — Determine whether a collection has a mapping for a given key.

`get(collection, key, default)` — Return the value stored for the given key, or the given default value if no
mapping for the key is present.

`del(collection, key)` — Delete the mapping for the given key in a collection.

`del_all(collection)` — Delete all keys from a collection.

Fully implemented by: `IdTable`, `HashTable`, `WeakKeyHashTable`.

Partially implemented by: `IntSet`, `Set`, `EnvHash`, `FDSet`, `Array`.

## Set-Like Collections

`add(collection, key)` — Add an element to a set-like collection.

`intset(i...)` — Construct an `IntSet` of the given integers.

`IntSet(n)` — Construct a set for holding integers up to `n` (larger integers may also be added later).

`choose(s)` — Pick an element of a set

`union(s1,s2)` — Construct the union of two sets

Fully implemented by: `IntSet`, `Set`, `FDSet`.

## Dequeues

`push(collection, item)` — Insert an item at the end of a collection.

`pop(collection)` — Remove the last item in a collection and return it.

`enq(collection, item)` — Insert an item at the beginning of a collection.

`insert(collection, index, item)` — Insert an item at the given index.

`del(collection, index)` — Remove the item at the given index.

`grow(collection, n)` — Add uninitialized space for `n` elements at the end of a collection.

`append!(collection, items)` — Add the elements of `items` to the end of a collection.

Fully implemented by: `Vector` (aka 1-d `Array`).

## Strings

`strlen(s)` — The number of characters in string `s`.

`length(s)` — The last valid index for string `s`. Indexes are byte offsets and not character numbers.

`chars(string)` — Return an array of the characters in `string`.

`strcat(strs...)` — Concatenate strings.

`string(char...)` — Create a string with the given characters.

`string(x)` — Create a string from any value using the `show` function.

`cstring(::Ptr{Uint8})` — Create a string from the address of a C (0-terminated) string.

`cstring(s)` — Convert a string to a contiguous byte array representation appropriate for passing it to C functions.

`ASCIIString(::Array{Uint8,1})` — Create an ASCII string from a byte array.

`UTF8String(::Array{Uint8,1})` — Create a UTF-8 string from a byte array.

`strchr(string, char[, i])` — Return the index of `char` in `string`, giving an error if not found. The third argument optionally specifies a starting index.

`lpad(string, n, p)` — Make a string at least `n` characters long by padding on the left with copies of `p`.

`rpad(string, n, p)` — Make a string at least `n` characters long by padding on the right with copies of `p`.

`split(string, char, include_empty)` — Return an array of strings by splitting the given string on occurrences of the given character delimiter. The second argument may also be a set of character delimiters to use. The third argument specifies whether empty fields should be included.

`join(strings, delim)` — Join an array of strings into a single string, inserting the given delimiter between adjacent strings.

`chop(string)` — Remove the last character from a string

`chomp(string)` — Remove a trailing newline from a string

`ind2chr(string, i)` — Convert a byte index to a character index

`chr2ind(string, i)` — Convert a character index to a byte index

## I/O

`stdout_stream` — Global variable referring to the standard out stream.

`stderr_stream` — Global variable referring to the standard error stream.

`stdin_stream` — Global variable referring to the standard input stream.

`open(file_name[, read, write, create, truncate, append])` — Open a file in a mode specified by five boolean arguments. The default is to open files for reading only. Returns a stream for accessing the file.

`open(file_name[, mode])` - Alternate syntax for open, where a string-based mode specifier is used instead of the five booleans. The values of `mode` correspond to those from `fopen(3)` or Perl `open`, and are equivalent to setting the following boolean groups:

<table>
<tr><td>"r"</td><td>read</td></tr>
<tr><td>"r+"</td><td>read, write</td></tr>
<tr><td>"w"</td><td>write, create, truncate</td></tr>
<tr><td>"w+"</td><td>read, write, create, truncate</td></tr>
<tr><td>"a"</td><td>write, create, append</td></tr>
<tr><td>"a+"</td><td>read, write, create, append</td></tr>
</table>

`memio([size])` — Create an in-memory I/O stream, optionally specifying how much initial space is needed.

`fdio(descriptor[, own])` — Create an `IOStream` object from an integer file descriptor. If `own` is true, closing this object will close the underlying descriptor. By default, an `IOStream` is closed when it is garbage collected.

`flush(stream)` — Commit all currently buffered writes to the given stream.

`close(stream)` — Close an I/O stream. Performs a `flush` first.

`with_output_stream(stream, f::Function, args...)` — Call `f(args...)` with the current output stream set to the given object. This is typically used to redirect the output of `print` and `show`.

`write(stream, x)` — Write the canonical binary representation of a value to the given stream.

`read(stream, type)` — Read a value of the given type from a stream, in canonical binary representation.

`read(stream, type, dims)` — Read a series of values of the given type from a stream, in canonical binary representation. `dims` is either a tuple or a series of integer arguments specifying the size of `Array` to return.

`position(s)` — Get the current position of a stream.

`seek(s, pos)` — Seek a stream to the given position.

`skip(s, offset)` — Seek a stream relative to the current position.

`current_output_stream()` — Obtain the current default output stream (used by `print` and other output functions).

`set_current_output_stream(s)` — Set the current output stream.

## Text I/O

`show(x)` — Write an informative text representation of a value to the current output stream.

`print(x)` — Write (to the current output stream) a canonical (un-decorated) text representation of a value if there is one, otherwise call `show`.

`println(x)` — Print (using `print`) `x` followed by a newline

`showall(x)` — Show x, printing all elements of arrays

`dump(x)` — Write a thorough text representation of a value to the current output stream.

`readall(stream)` — Read the entire contents of an I/O stream as a string.

`readline(stream)` — Read a single line of text, including a trailing newline character (if one is reached before the end of the input).

`readuntil(stream, delim)` — Read a string, up to and including the given delimiter byte.

`readlines(stream)` — Read all lines as an array.

`LineIterator(stream)` — Create an iterable object that will yield each line from a stream.

`each_line(stream or command)` — Construct an iterator to read each line from a stream or from a shell command object

`dlmread(filename, delim::Char)` — Read a matrix from a text file where each line gives one row, with elements separated by the given delimeter. If all data is numeric, the result will be a numeric array. If some elements cannot be parsed as numbers, a cell array of numbers and strings is returned.

`dlmread(filename, delim::Char, T::Type)` — Read a matrix from a text file with a given element type. If `T` is a numeric type, the result is an array of that type, with any non-numeric elements as `NaN` for floating-point types, or zero. Other useful values of `T` include `ASCIIString`, `String`, and `Any`.

`dlmwrite(filename, array, delim::Char)` — Write an array to a text file using the given delimeter (defaults to comma).

`csvread(filename[, T::Type])` — Equivalent to `dlmread` with `delim` set to comma.

`csvwrite(filename, array)` — Equivalent to `dlmwrite` with `delim` set to comma.

## Standard Numeric Types

`Bool`
`Int8`
`Uint8`
`Int16`
`Uint16`
`Int32`
`Uint32`
`Int64`
`Uint64`
`Float32`
`Float64`
`Complex64`
`Complex128`

## Mathematical Functions

`-` — Unary minus

`+`
`-`
`*`
`.*`
`/`
`./`
`\`
`.\`
`^`
`.^`

`div` — Integer truncating division

`fld` — Integer floor division

`mod`
`%`

`//` — Rational division

`<<`
`>>`
`>>>`

`==`
`!=`
`<`
`<=`
`>`
`>=`

`!` — Boolean not

`~` — Boolean or bitwise not

`&` — Bitwise and

`|` — Bitwise or

`$` — Bitwise exclusive or

`sin`
`cos`
`tan`
`sinh`
`cosh`
`tanh`
`asin`
`acos`
`atan`
`atan2`
`sec`
`csc`
`cot`
`asec`
`acsc`
`acot`
`sech`
`csch`
`coth`
`acosh`
`asinh`
`atanh`
`asech`
`acsch`
`acoth`
`sinc`
`cosc`
`hypot`
`log`
`log2`
`log10`

`log1p(x)` — Accurate natural logarithm of `1+x`

`logb`
`ilogb`
`exp`

`expm1(x)` — Accurately compute `exp(x)-1`

`exp2`
`ldexp`
`ceil`
`floor`
`trunc`
`round`
`iceil`
`ifloor`
`itrunc`
`iround`
`ipart`
`fpart`
`min`
`max`
`clamp`
`abs`

`abs2(x)` — Squared absolute value of `x`

`copysign`
`sign`
`signbit`
`pow`
`sqrt`
`cbrt`
`erf`
`erfc`
`gamma`
`lgamma`
`lfact`
`besselj0`
`besselj1`
`bessely0`
`bessely1`
`real`
`imag`
`conj`
`angle`
`cis(theta)`

`binomial(n,k)` — Number of ways to choose `k` out of `n` items

`factorial(n)` — Factorial of n

`factorial(n,k)` — Compute `factorial(n)/factorial(k)`

`gcd(x,y)` — Greatest common divisor

`lcm(x,y)` — Least common multiple

`nextpow2(n)` — Next power of two not less than `n`

`powermod(x, p, m)` — Compute `mod(x^p, m)`

## Data Formats

`bin(n[, pad])` — Convert an integer to a binary string, optionally specifying a number of digits to pad to.

`hex(n[, pad])` — Convert an integer to a hexadecimal string, optionally specifying a number of digits to pad to.

`dec(n[, pad])` — Convert an integer to a decimal string, optionally specifying a number of digits to pad to.

`oct(n[, pad])` — Convert an integer to an octal string, optionally specifying a number of digits to pad to.

`int2str(n, base[, pad])` — Convert an integer to a string in the given base, optionally specifying a number of digits to pad to.

`parse_int(type, str, base)` — Parse a string as an integer in the given base, yielding a number of the specified type.

`bool(x)` — Convert a number or numeric array to boolean

`int8(x)` — Convert a number or array to `Int8` data type

`int16(x)` — Convert a number or array to `Int16` data type

`int32(x)` — Convert a number or array to `Int32` data type

`int64(x)` — Convert a number or array to `Int64` data type

`uint8(x)` — Convert a number or array to `Uint8` data type

`uint16(x)` — Convert a number or array to `Uint16` data type

`uint32(x)` — Convert a number or array to `Uint32` data type

`uint64(x)` — Convert a number or array to `Uint64` data type

`float32(x)` — Convert a number or array to `Float32` data type

`float64(x)` — Convert a number or array to `Float64` data type

`char(x)` — Convert a number or array to `Char` data type

`safe_char(x)` — Convert to `Char`, checking for invalid code points

`complex(r,i)` — Convert real numbers or arrays to complex

`iscomplex(x)` — Test whether a number or array is of a complex type

`isreal(x)` — Test whether a number or array is of a real type

`bswap(n)` — Byte-swap an integer

`num2hex(f)` — Get a hexadecimal string of the binary representation of a floating point number

`hex2num(str)` — Convert a hexadecimal string to the floating point number it represents

## Numbers

`one(x)` — Get the multiplicative identity element for the type of x (x can also specify the type itself). For matrices, returns an identity matrix of the appropriate size and type.

`zero(x)` — Get the additive identity element for the type of x (x can also specify the type itself).

`pi` — The constant pi

`isdenormal(f)` — Test whether a floating point number is denormal

`isfinite(f)` — Test whether a number is finite

`isnan(f)` — Test whether a floating point number is not a number (NaN)

`nextfloat(f)` — Get the next floating point number in lexicographic order

`prevfloat(f)` — Get the previous floating point number in lexicographic order

`integer_valued(x)` — Test whether `x` is numerically equal to some integer

`real_valued(x)` — Test whether `x` is numerically equal to some real number

`exponent(f)` — Get the exponent of a floating-point number

`mantissa(f)` — Get the mantissa of a floating-point number

## Random Numbers

Random numbers are generated in Julia by calling functions from the [Mersenne Twister library](http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/#dSFMT)

`rand` — Generate a `Float64` random number in (0,1)

`randf` — Generate a `Float32` random number in (0,1)

`randi(Int32|Uint32|Int64|Uint64)` — Generate a random integer of the given type

`randi(n)` — Generate a random integer from 1 to `n` inclusive

`randi(n, dims...)` — Generate an array of random integers from 1 to `n` inclusive

`randi((a,b))` — Generate a random integer in the interval from `a` to `b` inclusive. The argument is a tuple.

`randi((a,b), dims...)` — Generate an array of random integers in the interval from `a` to `b` inclusive. The first argument is a tuple.

`randbit` — Generate `1` or `0` at random

`randbool` — Generate a random boolean value

`randn` — Generate a normally-distributed random number with mean 0 and standard deviation 1

`randg(a)` — Generate a sample from the gamma distribution with shape parameter `a`

`randchi2(n)` — Generate a sample from the chi-squared distribution with `n` degrees of freedom (also available as `chi2rnd`)

`randexp` — Generate samples from the exponential distribution

`srand` — Seed the RNG

## Arrays

### Basic functions

`ndims(A)` — Returns the number of dimensions of A

`size(A)` — Returns a tuple containing the dimensions of A

`eltype(A)` — Returns the type of the elements contained in A

`numel(A)` — Returns the number of elements in A

`length(A)` — Returns the number of elements in A (note that this differs from Matlab where `length(A)` is the largest dimension of `A`)

`nnz(A)` — Counts the number of nonzero values in A

`stride(A, k)` — Returns the size of the stride along dimension k

`strides(A)` — Returns a tuple of the linear index distances between adjacent elements in each dimension

### Constructors

`Array(type, dims)` — Construct an uninitialized dense array. `dims` may be a tuple or a series of integer arguments.

`cell(dims)` Construct an uninitialized cell array (heterogeneous array). `dims` can be either a tuple or a series of integer arguments.

`zeros(type, dims)` — Create an array of all zeros of specified type

`ones(type, dims)` — Create an array of all ones of specified type

`trues(dims)` — Create a Bool array with all values set to true

`falses(dims)` — Create a Bool array with all values set to false

`fill(v, dims)` — Create an array filled with `v`

`fill!(A, x)` — Fill array `A` with value `x`

`reshape(A, dims)` — Create an array with the same data as the given array, but with different dimensions. An implementation for a particular type of array may choose whether the data is copied or shared.

`copy(A)` — Create a copy of `A`

`similar(array, element_type, dims)` Create an uninitialized array of the same type as the given array, but with the specified element type and dimensions. The second and third arguments are both optional. The `dims` argument may be a tuple or a series of integer arguments.

`empty(type)` — Construct an empty array of the given element type

`reinterpret(type, A)` — Construct an array with the same binary data as the given array, but with the specified element type

`rand(dims)` — Create a random array with Float64 random values in (0,1)

`randf(dims)` — Create a random array with Float32 random values in (0,1)

`randn(dims)` — Create a random array with Float64 normally-distributed random values with a mean of 0 and standard deviation of 1

`eye(n)` — n-by-n identity matrix

`eye(m, n)` — m-by-n identity matrix

`linspace(start, stop, n)` — Construct a vector of `n` linearly-spaced elements from `start` to `stop`.

### Mathematical operators and functions

All mathematical operations and functions are supported for arrays

### Indexing, Assignment, and Concatenation

`ref(A, ind)` — Returns a subset of `A` as specified by `ind`, which may be an `Int`, a `Range`, or a `Vector`.

`sub(A, ind)` — Returns a SubArray, which stores the input `A` and `ind` rather than computing the result immediately. Calling `ref` on a SubArray computes the indices on the fly.

`slicedim(A, d, i)` — Return all the data of `A` where the index for dimension `d` equals `i`. Equivalent to `A[:,:,...,i,:,:,...]` where `i` is in position `d`.

`assign(A, X, ind)` — Store an input array `X` within some subset of `A` as specified by `ind`.

`cat(dim, A...)` — Concatenate the input arrays along the specified dimension

`vcat(A...)` — Concatenate along dimension 1

`hcat(A...)` — Concatenate along dimension 2

`hvcat` — Horizontal and vertical concatenation in one call

`flipdim(A, d)` — Reverse `A` in dimension `d`.

`flipud(A)` — Equivalent to `flipdim(A,1)`.

`fliplr(A)` — Equivalent to `flipdim(A,2)`.

`circshift(A,shifts)` — Circularly shift the data in an array. The second argument is a vector giving the amount to shift in each dimension.

`find(A)` — Return a vector of the linear indexes of the non-zeros in `A`.

`findn(A)` — Return a vector of indexes for each dimension giving the locations of the non-zeros in `A`.

`permute(A,perm)` — Permute the dimensions of array `A`. `perm` is a vector specifying a permutation of length `ndims(A)`. This is a generalization of transpose for multi-dimensional arrays. Transpose is equivalent to `permute(A,[2,1])`.

`ipermute(A,perm)` — Like `permute`, except the inverse of the given permutation is applied.

`squeeze(A)` — Remove singleton dimensions from the shape of array `A`

## Linear Algebra

Linear algebra functions in Julia are largely implemented by calling functions from [LAPACK](http://www.netlib.org/lapack/).

`*` — Matrix multiplication

`\` — Matrix division using a polyalgorithm. For input matrices `A` and `B`, the result `X` is such that `A*X == B`. For rectangular `A`, QR factorization is used. For triangular `A`, a triangular solve is performed. For square `A`, Cholesky factorization is tried if the input is symmetric with a heavy diagonal. LU factorization is used in case Cholesky factorization fails or for general square inputs.

`dot` — Compute the dot product

`cross` — Compute the cross product of two 3-vectors

`norm` — Compute the norm of a `Vector` or a `Matrix`

`(R, p) = chol(A)` — Compute Cholesky factorization

`(L, U, p) = lu(A)` — Compute LU factorization

`(Q, R, p) = qr(A)` — Compute QR factorization

`(D, V) = eig(A)` — Compute eigenvalues and eigenvectors of A

`(U, S, V) = svd(A)` — Compute the SVD of A

`triu(M)` — Upper triangle of a matrix

`tril(M)` — Lower triangle of a matrix

`diag(M)` — The diagonal of a matrix, as a vector

`diagm(v)` — Construct a diagonal matrix from a vector

`rank(M)` — Compute the rank of a matrix

`cond(M)` — Matrix condition number

`trace(M)` — Matrix trace

`det(M)` — Matrix determinant

`inv(M)` — Matrix inverse, or generalized `1/M`

`repmat(A, n, m)` — Construct a matrix by repeating the given matrix `n` times in dimension 1 and `m` times in dimension 2.

`kron(A, B)` — Kronecker tensor product of two vectors or two matrices.

`linreg(x, y)` — Determine parameters `[a, b]` that minimize the squared error between `y` and `a+b*x`.

`linreg(x, y, w)` — Weighted least-squares linear regression

## Sorting

`sort(v)` — Sort a vector in ascending order, according to `isless`.

`sort!(v)` — In-place sort

`sortr(v)` — Sort a vector in descending order

`sortr!(v)` — In-place descending-order sort

`sort(a, dim)` — Sort an array along the given dimension

`sort(lessthan, a[, dim])` — Sort with a custom comparison function

`(s,p) = sortperm(v)` — Sort a vector in ascending order, also constructing the permutation that sorts the vector

`issorted(v)` — Test whether a vector is in ascending sorted order

`nthperm(v, k)` — Compute the kth lexicographic permutation of a vector

`nthperm!(v, k)` — In-place version of `nthperm`

`randperm(n)` — Construct a random permutation of the given length

`randcycle(n)` — Construct a random cyclic permutation of the given length

`shuffle(v)` — Randomly rearrange the elements of a vector

`shuffle!(v)` — In-place version of `shuffle`

`reverse(v)` — Reverse vector `v`

`reverse!(v)` — Reverse vector `v` in-place

## Signal Processing

FFT functions in Julia are largely implemented by calling functions from [FFTW](http://www.fftw.org)

`fft(A, dim)` — One dimensional FFT if input is a `Vector`. For n-d cases, compute fft of vectors along dimension `dim`

`fft2` — 2d FFT

`fft3` — 3d FFT

`fftn` — N-d FFT

`ifft(A, dim)` — Inverse FFT. Same arguments as `fft`

`ifft2` — Inverse 2d FFT

`ifft3` — Inverse 3d FFT

`ifftn` — Inverse N-d FFT

`fftshift(x)` — Swap the first and second halves of each dimension of `x`.

`fftshift(x,dim)` — Swap the first and second halves of the given dimension of array `x`.

`ifftshift(x[, dim])` — Undoes the effect of `fftshift`.

`filt(b,a,x)` — Apply filter described by vectors `a` and `b` to vector `x`.

`deconv(b,a)` — Construct vector `c` such that `b = conv(a,c) + r`. Equivalent to polynomial division.

`conv(u,v)` — Convolution of two vectors. Uses FFT algorithm.

`xcorr(u,v)` — Compute the cross-correlation of two vectors.

## Parallel Computing

`addprocs_local(n)` — Add processes on the local machine. Can be used to take advantage of multiple cores.

`addprocs_ssh({"host1","host2",...})` — Add processes on remote machines via SSH. Requires julia to be installed in the same location on each node, or to be available via a shared file system.

`addprocs_sge(n)` — Add processes via the Sun/Oracle Grid Engine batch queue, using `qsub`.

`nprocs()` — Get the number of available processors

`myid()` — Get the id of the current processor

`remote_call(id, func, args...)` — Call a function asynchronously on the given arguments on the specified processor. Returns a `RemoteRef`.

`wait(RemoteRef)` — Wait for a value to become available for the specified remote reference.

`fetch(RemoteRef)` — Wait for and get the value of a remote reference.

`remote_call_wait(id, func, args...)` — Perform `wait(remote_call(...))` in one message.

`remote_call_fetch(id, func, args...)` — Perform `fetch(remote_call(...))` in one message.

`put(RemoteRef, value)` — Store a value to a remote reference. Implements "shared queue of length 1" semantics: if a value is already present, blocks until the value is removed with `take`.

`take(RemoteRef)` — Fetch the value of a remote reference, removing it so that the reference is empty again.

`RemoteRef()` — Make an uninitialized remote reference on the local machine.

`RemoteRef(n)` — Make an uninitialized remote reference on processor `n`.

## Distributed Arrays

`darray(init, type, dims[, distdim, procs, dist])` — Construct a distributed array. `init` is a function of three arguments that will run on each processor, and should return an `Array` holding the local data for the current processor. Its arguments are `(T,d,da)` where `T` is the element type, `d` is the dimensions of the needed local piece, and `da` is the new `DArray` being constructed (though, of course, it is not fully initialized). `type` is the element type. `dims` is the dimensions of the entire `DArray`. `distdim` is the dimension to distribute in. `procs` is a vector of processor ids to use. `dist` is a vector giving the first index of each contiguous distributed piece, such that the nth piece consists of indexes `dist[n]` through `dist[n+1]-1`. If you have a vector `v` of the sizes of the pieces, `dist` can be computed as `cumsum([1,v])`. Fortunately, all arguments after `dims` are optional.

`darray(f, A)` — Transform `DArray` `A` to another of the same type and distribution by applying function `f` to each block of `A`.

`dzeros([type, ]dims, ...)` — Construct a distrbuted array of zeros. Trailing arguments are the same as those accepted by `darray`.

`dones([type, ]dims, ...)` — Construct a distrbuted array of ones. Trailing arguments are the same as those accepted by `darray`.

`dfill(x, dims, ...)` — Construct a distrbuted array filled with value `x`. Trailing arguments are the same as those accepted by `darray`.

`drand(dims, ...)` — Construct a distrbuted uniform random array. Trailing arguments are the same as those accepted by `darray`.

`drandn(dims, ...)` — Construct a distrbuted normal random array. Trailing arguments are the same as those accepted by `darray`.

`dcell(dims, ...)` — Construct a distrbuted cell array. Trailing arguments are the same as those accepted by `darray`.

`distribute(a[, distdim])` — Convert a local array to distributed

`localize(d)` — Get the local piece of a distributed array

`changedist(d, distdim)` — Change the distributed dimension of a `DArray`

`myindexes(d)` — A tuple describing the indexes owned by the local processor

`owner(d, i)` — Get the id of the processor holding index `i` in the distributed dimension

`procs(d)` — Get the vector of processors storing pieces of `d`

`distdim(d)` — Get the distributed dimension of `d`

## System

`system("command")` — Run a shell command.

`gethostname()` — Get the local machine's host name.

`getipaddr()` — Get the IP address of the local machine, as a string of the form "x.x.x.x".

`getcwd()` — Get the current working directory.

`setcwd("dir")` — Set the current working directory. Returns the new current directory.

`getpid()` — Get julia's process ID.

`time()` — Get the time in seconds since the epoch, with fairly high resolution.

`tic()` — Set a timer to be read by the next call to `toc` or `toq`. The macro call `@time expr` can also be used to time evaluation.

`toc()` — Print and return the time elapsed since the last `tic`

`toq()` — Return, but do not print, the time elapsed since the last `tic`

`EnvHash()` — A singleton of this type, `ENV`, provides a hash table interface to environment variables.

`dlopen(libfile)` — Load a shared library, returning an opaque handle

`dlsym(handle, sym)` — Look up a symbol from a shared library handle

## Errors

`error(message)` — Raise an error with the given message

`throw(e)` — Throw an object as an exception

`errno()` — Get the value of the C library's `errno`

`strerror(n)` — Convert a system call error code to a descriptive string

`assert(cond)` — Raise an error if `cond` is false. Also available as the macro `@assert expr`.

## Tasks

`Task(func)` — Create a `Task` (i.e. thread, or coroutine) to execute the given function. The task exits when this function returns.

`yieldto(task, args...)` — Switch to the given task. The first time a task is switched to, the task's function is called with `args`. On subsequent switches, `args` are returned from the task's last call to `yieldto`.

`current_task()` — Get the currently running Task.

`istaskdone(task)` — Tell whether a task has exited.

`consume(task)` — Receive the next value passed to `produce` by the specified task.

`produce(value)` — Send the given value to the last `consume` call, switching to the consumer task.

`make_scheduled(task)` — Register a task with the main event loop, so it will automatically run when possible.

`yield()` — For scheduled tasks, switch back to the scheduler to allow another scheduled task to run.

`task_exit([value])` — For scheduled tasks, tell the scheduler to stop running the current task, exiting with the given value.

`wait(task)` — Repeatedly yield to a task until it exits.

`tls(symbol)` — Look up the value of a symbol in the current task's task-local storage.

`tls(symbol, value)` — Assign a value to a symbol in the current task's task-local storage.
