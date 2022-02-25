
# JuliaImages Projects – Summer of Code

[JuliaImages](https://github.com/JuliaImages) (see the [documentation](https://juliaimages.github.io)) is a framework in Julia for multidimensional arrays, image processing, and computer vision (CV). It has an active development community and offers many features that unify CV and biomedical 3D/4D image processing, support big data, and promote interactive exploration.

Often the best ideas are the ones that candidate SoC contributors come up with on their own. We are happy to [discuss such ideas](https://github.com/JuliaImages/Images.jl/discussions/new?category=jsoc) and help you refine your proposal.  Below are some potential project ideas that might help spur some thoughts. In general, anything that is missing in JuliaImages, and worths three-months' development can be considered as potential GSoC ideas. See the bottom of this page for information about mentors.

## Benchmarking against other frameworks

**Difficulty:** Medium (175h)

JuliaImages provides high-quality implementations of many algorithms; however, as yet there is no set of benchmarks that compare our code against that of other image-processing frameworks.  Developing such benchmarks would allow us to advertise our strengths and/or identify opportunities for further improvement.  See also the OpenCV project below.

Benchmarks for several performance-sensitive packages (e.g., ImageFiltering, ImageTransformations, ImageMorphology, ImageContrastAdjustment, ImageEdgeDetection, ImageFeatures, and/or ImageSegmentation) against frameworks like Scikit-image and OpenCV, and optionally others like ITK, ImageMagick, and Matlab/Octave. See also the [image benchmarks](https://github.com/JuliaImages/image_benchmarks) repository.

This task splits into at least two pieces:

- developing frameworks for collecting the data, and
- visualizing the results.

One should also be aware of the fact that differences in implementation (which may include [differences in quality](https://github.com/JuliaImages/Images.jl/pull/855)) may complicate the interpretation of some benchmarks.

**Skills:** JuliaImages experiences is required. Some familiarities with other image processing frameworks is preferred.

**Mentors:** [Johnny Chen](https://github.com/johnnychen94)

## GPU support for many algorithms

**Difficulty:** Hard (350h)

JuliaImages supports many common algorithms, but targets only the CPU. With Julia now possessing [first-in-class support for GPUs](https://github.com/JuliaGPU), now is the time to provide GPU implementations of many of the same algorithms.

[KernelAbstractions](https://github.com/JuliaGPU/KernelAbstractions.jl) may make it easier to support both CPU and GPU with a common implementation.

Fairly widespread GPU support for a single nontrivial package. [ImageFiltering](https://github.com/JuliaImages/ImageFiltering.jl) would be a good choice.

**Skills:** Familiarity with CUDA programming in Julia, i.e., [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl) is required.

**Mentors:** [Johnny Chen](https://github.com/johnnychen94)

## Better ImageIO supports (open ended)

**Difficulty:** Medium(175h) or Hard(350h)

ImageIO is the default IO backend shipped with Images.jl. It already supports a lot of image formats, yet there still exists
some formats that are missing (e.g., GIF, JPEG 2000). Potential applicant needs to support new formats by either 1) wrapping available C libraries via
BinaryBuilder, or 2) re-implement the functionality with pure Julia. See also the EXIF project below.

**Skills:** Experiences with Julia is required. For library wrapping projects, experiences with cross-compiling in Linux system is required, and familiarity with the source language (e.g., C) is preferred. The difficulty almost totally depends on how the complicate the format is, and if there exists an easy-to-wrap C library.

**Mentors:** [Johnny Chen](https://github.com/johnnychen94), [Yupei Qi](https://github.com/Gnimuc) and [Ian Butterworth](https://github.com/IanButterworth)

## EXIF viewer

**Difficulty:** Medium(175h)

[Exchangeable image file format (EXIF)](https://en.wikipedia.org/wiki/Exif) is a widely used specification to store
camera information. Potential applicant needs to provide a package to support read/write EXIF data of image file.
This can be implemented in pure Julia, or wrapping the C package [libexif](https://github.com/libexif/libexif).

**Skills:** Similar to above ImageIO skills requirements.

**Mentors:** [Johnny Chen](https://github.com/johnnychen94) and [Yupei Qi](https://github.com/Gnimuc)

## Better QR Code support (open ended)

**Difficulty:** Medium(175h) or Hard(350h)

[QRCode.jl](https://github.com/jiegillet/QRCode.jl) is a legacy package that supports encoding data to QR code. Contributors are required
to revive this package to co-exist with the latest JuliaImages ecosystem, and also adding support to decode QR code into julia data. Decoding QR code can be potentially be challenging and students need to find out a satisfying solution from the literature.

**Skills:** Experiences in JuliaImages are required. The ability to read and understand the QR code specification.

**Mentors:** [Johnny Chen](https://github.com/johnnychen94)

## Where to go for discussion and to find mentors

Interested contributors are encouraged to [open an discussion in Images.jl](https://github.com/JuliaImages/Images.jl/discussions/new) to
introduce themselves and discuss the detailed project ideas. To increase the chance of getting useful feedback, please provide detailed
plans and ideas (don't just copy the contents here).
