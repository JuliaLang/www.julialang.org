
# JuliaImages Projects – Summer of Code

[JuliaImages](https://github.com/JuliaImages) (see the [documentation](https://juliaimages.github.io/latest/)) is a framework in Julia for multidimensional arrays, image processing, and computer vision (CV). It has an active development community and offers many features that unify CV and biomedical 3D/4D image processing, support big data, and promote interactive exploration.

Often the best ideas are the ones that candidate SoC students come up with on their own. We are happy to [discuss such ideas](https://github.com/JuliaImages/Images.jl/issues/new) and help you refine your proposal.  Below are some potential project ideas that might help spur some thoughts.  See the bottom of this page for information about mentors.

## Wide-ranging demos (easy)

For new or occasional users, JuliaImages would benefit from a large collection of complete worked examples organized by topic. While the current documentation contains many "mini-demos," they are scattered; an organized page would help users quickly find what they need. We have [set up a landing page](https://juliaimages.org/latest/democards/examples/), but many more demos are needed. [Scikit-image](https://scikit-image.org/docs/stable/auto_examples/) is one potential model.

This "project" might also be split among multiple students who contribute demos as part of their work in a focused area of JuliaImages.

Expected outcomes: a significant expansion of the number of democards.

## Benchmarking against other frameworks (medium)

JuliaImages provides high-quality implementations of many algorithms; however, as yet there is no set of benchmarks that compare our code against that of other image-processing frameworks.  Developing such benchmarks would allow us to advertise our strengths and/or identify opportunities for further improvement.  See also the OpenCV project below.

Expected outcomes: benchmarks for several performance-sensitive packages (e.g., ImageFiltering, ImageTransformations, ImageMorphology, ImageContrastAdjustment, ImageEdgeDetection, ImageFeatures, and/or ImageSegmentation) against frameworks like Scikit-image and OpenCV, and optionally others like ITK, ImageMagick, and Matlab/Octave. This task splits into at least two pieces: (1) developing frameworks for collecting the data, and (2) visualizing the results.  One should also be aware of the fact that differences in implementation (which may include [differences in quality](https://github.com/JuliaImages/Images.jl/pull/855)) may complicate the interpretation of some benchmarks.

## GPU support for many algorithms (medium)

JuliaImages supports many common algorithms, but targets only the CPU. With Julia now possessing [first-in-class support for GPUs](https://github.com/JuliaGPU), now is the time to provide GPU implementations of many of the same algorithms.

[KernelAbstractions](https://github.com/JuliaGPU/KernelAbstractions.jl) may make it easier to support both CPU and GPU with a common implementation.

Expected outcomes: fairly widespread GPU support for a single nontrivial package. [ImageFiltering](https://github.com/JuliaImages/ImageFiltering.jl) would be a good choice.

## Interactivity and visualization tools (open-ended)

Image processing often involves tight interaction between algorithms and visualization. While there are a number of older tools available, leveraging GLVisualize seems to hold the greatest promise. This project might implement a number of interactive tools for region-of-interest selection, annotation, measurement, and modification.  Software suites like OpenCV, ImageJ/Fiji, scikit-image, and Matlab might serve as inspiration.

## Integration of OpenCV and JuliaImages (hard)

OpenCV is one of the pre-eminent image-processing frameworks. During the summer of 2020, significant progress was made on a [Julia wrapper](https://docs.opencv.org/master/d8/da4/tutorial_julia.html). An important remaining task is to integrate the wrapper with [Julia's binary packaging system](https://docs.binarybuilder.org/stable/).

Expected outcomes: an OpenCV package that can be installed across all major platforms with `Pkg.add("OpenCV")`.

## Contributions to a Stereo Matching Package (medium)

When two images are taken of a scene with a calibrated stereo rig it is possible to construct a three-dimensional model of the scene provided that one can determine the coordinates of corresponding points in the two images. The task of determining the coordinates of corresponding points is frequently called *stereo matching* or *disparity estimation*. Numerous algorithms for this task have been proposed over the years and new ones continue to be developed.

This project will implement several stereo matching algorithms. Emphasis will be placed on *efficient* implementations which leverage all of Julia's features for writing fast code.

Example algorithms:

@@tight-list
  1. Bleyer, Michael, Christoph Rhemann, and Carsten Rother. "PatchMatch Stereo-Stereo Matching with Slanted Support Windows." Bmvc. Vol. 11. 2011.
  2. Hirschmuller, Heiko. "Accurate and efficient stereo processing by semi-global matching and mutual information." Computer Vision and Pattern Recognition, 2005. CVPR 2005. IEEE Computer Society Conference on. Vol. 2. IEEE, 2005.
  3. Gehrig, Stefan K., and Clemens Rabe. "Real-time semi-global matching on the CPU." Computer Vision and Pattern Recognition Workshops (CVPRW), 2010 IEEE Computer Society Conference on. IEEE, 2010.
@@

Expected outcomes: a library of stereo matching algorithms with usage tutorials and documentation.

## Contributions to a Calibration Target package (medium)
Camera calibration involves determining a camera's intrinsic parameters from a series of images of a so-called "calibration target". Knowledge of the intrinsic parameters facilitates three-dimensional reconstruction from images or video. The most frequently used calibration target is a checkerboard pattern. A key step in camera calibration involves automatically detecting the checkerboard and identifying landmarks such as the corners of each checkeboard square. 

This project will implement a recent automatic checkerboard detection and feature extraction algorithm. 

Example algorithm:

@@tight-list
  1. Y. Yan, P. Yang, L. Yan, J. Wan, Y. Sun, and K. Tansey, “Automatic checkerboard detection for camera calibration using self-correlation,” Journal of Electronic Imaging, vol. 27, no. 03, p. 1, May 2018.
@@

Expected outcomes: a checkeboard detection algorithm which can provide the necessary inputs to a camera calibration routine. 

### Where to go for discussion and to find mentors

Depending on the project, potential mentors include [Tim Holy](https://github.com/timholy) and [Zygmunt Szpak](https://github.com/zygmuntszpak) but may also involve other JuliaImages developers.  Interested students are encouraged to [open an issue in Images.jl](https://github.com/JuliaImages/Images.jl/issues/new) to introduce themselves and discuss project ideas.
