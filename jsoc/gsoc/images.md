
# JuliaImages Projects – Summer of Code

[JuliaImages](https://github.com/JuliaImages) (see the [documentation](https://juliaimages.github.io)) is a framework in Julia for multidimensional arrays, image processing, and computer vision (CV). It has an active development community and offers many features that unify CV and biomedical 3D/4D image processing, support big data, and promote interactive exploration.

Often the best ideas are the ones that candidate SoC students come up with on their own. We are happy to [discuss such ideas](https://github.com/JuliaImages/Images.jl/issues/new) and help you refine your proposal.  Below are some potential project ideas that might help spur some thoughts.  See the bottom of this page for information about mentors.

## Wide-ranging demos (easy)

### Description

For new or occasional users, JuliaImages would benefit from a large collection of complete worked examples organized by topic. While the current documentation contains many "mini-demos," they are scattered; an organized page would help users quickly find what they need. We have [set up a landing page](https://juliaimages.org/latest/examples/), but many more demos are needed. [Scikit-image](https://scikit-image.org/docs/stable/auto_examples/) is one potential model.

Notes:

- This "project" might also be split among multiple students who contribute demos as part of their work in a focused area of JuliaImages.
- Each demo is a mini blog that includes the usage, explanations and (optional) best practices. A direct copy from the function references is not allowed.
- Copy or modify from existing open-source projects should meet their license requirements.

### Skills

The applicant should be familiar with JuliaImages, and should be able to write good technical blogs in English.

### Expected outcomes

- A significant expansion of the number of democards with detailed explanations.
- (Preferred) adding more missing functionalities to JuliaImages ecosystem.
- (Optional) improve [DemoCards.jl](https://github.com/johnnychen94/DemoCards.jl), which is the build tool for the demos.

### Mentors

[Johnny Chen](https://github.com/johnnychen94) and [Tim Holy](https://github.com/timholy)

## Benchmarking against other frameworks (medium)

### Description

JuliaImages provides high-quality implementations of many algorithms; however, as yet there is no set of benchmarks that compare our code against that of other image-processing frameworks.  Developing such benchmarks would allow us to advertise our strengths and/or identify opportunities for further improvement.  See also the OpenCV project below.

### Skills

JuliaImages experiences is required. Some familiarities with other image processing frameworks is preferred.

### Expected outcomes

Benchmarks for several performance-sensitive packages (e.g., ImageFiltering, ImageTransformations, ImageMorphology, ImageContrastAdjustment, ImageEdgeDetection, ImageFeatures, and/or ImageSegmentation) against frameworks like Scikit-image and OpenCV, and optionally others like ITK, ImageMagick, and Matlab/Octave.

This task splits into at least two pieces:

- developing frameworks for collecting the data, and
- visualizing the results.

One should also be aware of the fact that differences in implementation (which may include [differences in quality](https://github.com/JuliaImages/Images.jl/pull/855)) may complicate the interpretation of some benchmarks.

### Mentors

[Tim Holy](https://github.com/timholy) and [Johnny Chen](https://github.com/johnnychen94)

## GPU support for many algorithms (hard)

### Description

JuliaImages supports many common algorithms, but targets only the CPU. With Julia now possessing [first-in-class support for GPUs](https://github.com/JuliaGPU), now is the time to provide GPU implementations of many of the same algorithms.

[KernelAbstractions](https://github.com/JuliaGPU/KernelAbstractions.jl) may make it easier to support both CPU and GPU with a common implementation.

### Skills

Familiarity with CUDA programming in Julia, i.e., [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl) is required.

### Expected outcomes

Fairly widespread GPU support for a single nontrivial package. [ImageFiltering](https://github.com/JuliaImages/ImageFiltering.jl) would be a good choice.

### Mentors

[Tim Holy](https://github.com/timholy) and [Johnny Chen](https://github.com/johnnychen94)

## Better ImageMagick supports (medium)

### Description

ImageMagick is a widely used low-level image io and processing library, it also has its Julia frontend [ImageMagick.jl](https://github.com/JuliaIO/ImageMagick.jl), which is used widely in the entire Julia ecosystem. However, ImageMagick.jl project is not under active maintenance; it lacks of the necessary documentation and has few test coverage. The potential applicant needs to revisit and upgrade
the ImageMagick.jl codebase to enhance the ImageMagick.jl package.

### Skills

Experiences with Linux cross-compiling, C and Julia is required. Familiarity with ImageMagick library is preferred.

### Expected outcomes

- fix legacy ImageMagick.jl issues
- improve the reliability
- add a complete reference documentation for ImageMagick.jl
- (Optional) port more ImageMagick features to ImageMagick.jl

### Mentors

[Tim Holy](https://github.com/timholy) and [Johnny Chen](https://github.com/johnnychen94)

## Better ImageIO supports (medium)

### Description

Besides the gigantic ImageMagick library, Julia also provides a lighter [ImageIO](https://github.com/JuliaIO/ImageIO.jl) package
for PNG, TIFF and Netpbm image formats. However, there are more widely-used image formats (e.g., JPEG, GIF) that are not supported
by ImageIO yet. Potential applicant needs to support the IO of new image format by either 1) wrapping available C libraries via
BinaryBuilder, or 2) re-implement the functionality with pure Julia.

### Skills

Experiences with Julia is required. For library wrapping projects, experiences with cross-compiling in Linux system is required, and familiarity with the source language (e.g., C) is preferred.

### Expected Outcomes

Add at least one image format support.

### Mentors

[Ian Butterworth](https://github.com/IanButterworth), [Johnny Chen](https://github.com/johnnychen94) and [Tim Holy](https://github.com/timholy)

## Interactivity and visualization tools (open-ended)

### Description

Image processing often involves tight interaction between algorithms and visualization. While there are a number of older tools available, leveraging GLVisualize seems to hold the greatest promise. This project might implement a number of interactive tools for region-of-interest selection, annotation, measurement, and modification.  Software suites like OpenCV, ImageJ/Fiji, scikit-image, and Matlab might serve as inspiration.

JuliaImages also provides several non-GUI visualization tools, e.g., [ImageDraw.jl](https://github.com/JuliaImages/ImageDraw.jl),
[ImageInTerminal.jl](https://github.com/JuliaImages/ImageInTerminal.jl), [ImageShow.jl](https://github.com/JuliaImages/ImageShow.jl)
and [MosaicViews.jl](https://github.com/JuliaArrays/MosaicViews.jl). Improving these packages are also good project ideas.

### Skills

For [ImageViews.jl](https://github.com/JuliaImages/ImageView.jl) and similar GUI projects, familiarity with GUI programming is
required. For non-GUI projects, familiarity with Julia array interfaces are preferred.

### Mentors

[Tim Holy](https://github.com/timholy). For non-GUI projects, [Johnny Chen](https://github.com/johnnychen94) is also available.

## Integration of OpenCV and JuliaImages (hard)

### Description

OpenCV is one of the pre-eminent image-processing frameworks. During the summer of 2020, significant progress was made on a [Julia wrapper](https://docs.opencv.org/master/d8/da4/tutorial_julia.html). An important remaining task is to integrate the wrapper with [Julia's binary packaging system](https://docs.binarybuilder.org/stable/).

### Skills

C++ experiences are required. Some familiarity with the Julia and [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl)
and [CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl) are preferred.

### Expected outcomes

An OpenCV package that can be installed across all major platforms with `Pkg.add("OpenCV")`.

### Mentors

[Tim Holy](https://github.com/timholy)

## Contributions to a Stereo Matching Package (medium)

### Description

When two images are taken of a scene with a calibrated stereo rig it is possible to construct a three-dimensional model of the scene provided that one can determine the coordinates of corresponding points in the two images. The task of determining the coordinates of corresponding points is frequently called *stereo matching* or *disparity estimation*. Numerous algorithms for this task have been proposed over the years and new ones continue to be developed.

This project will implement several stereo matching algorithms. Emphasis will be placed on *efficient* implementations which leverage all of Julia's features for writing fast code.

Example algorithms:

@@tight-list
  1. Bleyer, Michael, Christoph Rhemann, and Carsten Rother. "PatchMatch Stereo-Stereo Matching with Slanted Support Windows." Bmvc. Vol. 11. 2011.
  2. Hirschmuller, Heiko. "Accurate and efficient stereo processing by semi-global matching and mutual information." Computer Vision and Pattern Recognition, 2005. CVPR 2005. IEEE Computer Society Conference on. Vol. 2. IEEE, 2005.
  3. Gehrig, Stefan K., and Clemens Rabe. "Real-time semi-global matching on the CPU." Computer Vision and Pattern Recognition Workshops (CVPRW), 2010 IEEE Computer Society Conference on. IEEE, 2010.
@@

### Skills

Experiences in JuliaImages are required. Familiarity with the algorithms are preferred.

### Expected outcomes

A library of stereo matching algorithms with usage tutorials and documentation.

### Mentors

[Zygmunt Szpak](https://github.com/zygmuntszpak)

## Contributions to a Calibration Target package (medium)

### Description

Camera calibration involves determining a camera's intrinsic parameters from a series of images of a so-called "calibration target". Knowledge of the intrinsic parameters facilitates three-dimensional reconstruction from images or video. The most frequently used calibration target is a checkerboard pattern. A key step in camera calibration involves automatically detecting the checkerboard and identifying landmarks such as the corners of each checkerboard square.

This project will implement a recent automatic checkerboard detection and feature extraction algorithm.

Example algorithm:

@@tight-list
  1. Y. Yan, P. Yang, L. Yan, J. Wan, Y. Sun, and K. Tansey, “Automatic checkerboard detection for camera calibration using self-correlation,” Journal of Electronic Imaging, vol. 27, no. 03, p. 1, May 2018.
@@


### Skills

Experiences in JuliaImages are required. Familiarity with the algorithms are preferred.

### Expected outcomes

A checkeboard detection algorithm which can provide the necessary inputs to a camera calibration routine.

### Mentors

[Zygmunt Szpak](https://github.com/zygmuntszpak)

### Where to go for discussion and to find mentors

Interested students are encouraged to [open an discussion in Images.jl](https://github.com/JuliaImages/Images.jl/discussions/new) to
introduce themselves and discuss the detailed project ideas. To increase the chance of getting useful feedback, please provide detailed
plans and ideas (don't just copy the contents here).
