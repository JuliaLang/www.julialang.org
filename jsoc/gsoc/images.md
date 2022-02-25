
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

## Contributions to a Stereo Matching Package

**Difficulty:** Medium(175h)

When two images are taken of a scene with a calibrated stereo rig it is possible to construct a three-dimensional model of the scene provided that one can determine the coordinates of corresponding points in the two images. The task of determining the coordinates of corresponding points is frequently called *stereo matching* or *disparity estimation*. Numerous algorithms for this task have been proposed over the years and new ones continue to be developed.

This project will implement several stereo matching algorithms. Emphasis will be placed on *efficient* implementations which leverage all of Julia's features for writing fast code.

Example algorithms:

@@tight-list
  1. Bleyer, Michael, Christoph Rhemann, and Carsten Rother. "PatchMatch Stereo-Stereo Matching with Slanted Support Windows." Bmvc. Vol. 11. 2011.
  2. Hirschmuller, Heiko. "Accurate and efficient stereo processing by semi-global matching and mutual information." Computer Vision and Pattern Recognition, 2005. CVPR 2005. IEEE Computer Society Conference on. Vol. 2. IEEE, 2005.
  3. Gehrig, Stefan K., and Clemens Rabe. "Real-time semi-global matching on the CPU." Computer Vision and Pattern Recognition Workshops (CVPRW), 2010 IEEE Computer Society Conference on. IEEE, 2010.
@@

**Expected outputs:** A library of stereo matching algorithms with usage tutorials and documentation.

**Skills:** Experiences in JuliaImages are required. Familiarity with the algorithms are preferred.

**Mentors:** [Zygmunt Szpak](https://github.com/zygmuntszpak)

## Contributions to a Calibration Target package

**Difficulty:** Medium(175h)

Camera calibration involves determining a camera's intrinsic parameters from a series of images of a so-called "calibration target". Knowledge of the intrinsic parameters facilitates three-dimensional reconstruction from images or video. The most frequently used calibration target is a checkerboard pattern. A key step in camera calibration involves automatically detecting the checkerboard and identifying landmarks such as the corners of each checkerboard square.

This project will implement a recent automatic checkerboard detection and feature extraction algorithm.

Example algorithm:

@@tight-list
  1. Y. Yan, P. Yang, L. Yan, J. Wan, Y. Sun, and K. Tansey, “Automatic checkerboard detection for camera calibration using self-correlation,” Journal of Electronic Imaging, vol. 27, no. 03, p. 1, May 2018.
@@

**Expected outputs:** A checkeboard detection algorithm which can provide the necessary inputs to a camera calibration routine.

**Skills:** Experiences in JuliaImages are required. Familiarity with the algorithms are preferred.

**Mentors:** [Zygmunt Szpak](https://github.com/zygmuntszpak)

## Where to go for discussion and to find mentors

Interested contributors are encouraged to [open an discussion in Images.jl](https://github.com/JuliaImages/Images.jl/discussions/new) to
introduce themselves and discuss the detailed project ideas. To increase the chance of getting useful feedback, please provide detailed
plans and ideas (don't just copy the contents here).
