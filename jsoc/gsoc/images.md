
# JuliaImages Projects – Summer of Code

\toc

[JuliaImages](https://github.com/JuliaImages) (see the [documentation](https://juliaimages.github.io)) is a framework in Julia for multidimensional arrays, image processing, and computer vision (CV). It has an active development community and offers many features that unify CV and biomedical 3D/4D image processing, support big data, and promote interactive exploration.

Often the best ideas are the ones that candidate SoC contributors come up with on their own. We are happy to [discuss such ideas](https://github.com/JuliaImages/Images.jl/discussions/new?category=jsoc) and help you refine your proposal.  Below are some potential project ideas that might help spur some thoughts. In general, anything that is missing in JuliaImages, and worths three-months' development can be considered as potential GSoC ideas. See the bottom of this page for information about mentors.

## Benchmarking against other frameworks

**Difficulty:** Medium (175h) (High priority)

JuliaImages provides high-quality implementations of many algorithms; however, as yet there is no set of benchmarks that compare our code against that of other image-processing frameworks.  Developing such benchmarks would allow us to advertise our strengths and/or identify opportunities for further improvement.  See also the OpenCV project below.

Benchmarks for several performance-sensitive packages (e.g., ImageFiltering, ImageTransformations, ImageMorphology, ImageContrastAdjustment, ImageEdgeDetection, ImageFeatures, and/or ImageSegmentation) against frameworks like Scikit-image and OpenCV, and optionally others like ITK, ImageMagick, and Matlab/Octave. See also the [image benchmarks](https://github.com/JuliaImages/image_benchmarks) repository.

This task splits into at least two pieces:

- developing frameworks for collecting the data, and
- visualizing the results.

One should also be aware of the fact that differences in implementation (which may include [differences in quality](https://github.com/JuliaImages/Images.jl/pull/855)) may complicate the interpretation of some benchmarks.

**Skills:** JuliaImages experiences is required. Some familiarities with other image processing frameworks is preferred.

**Mentors:** [Tim Holy](https://github.com/timholy)

## Where to go for discussion and to find mentors

Interested contributors are encouraged to [open an discussion in Images.jl](https://github.com/JuliaImages/Images.jl/discussions/new) to
introduce themselves and discuss the detailed project ideas. To increase the chance of getting useful feedback, please provide detailed
plans and ideas (don't just copy the contents here).
