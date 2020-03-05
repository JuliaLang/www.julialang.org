
# JuliaImages Projects – Summer of Code

[JuliaImages](https://github.com/JuliaImages) (see the [documentation](http://juliaimages.github.io/latest/)) is a framework in Julia for multidimensional arrays, image processing, and computer vision (CV). It has an active development community and offers many features that unify CV and biomedical 3D/4D image processing, support big data, and promote interactive exploration.

Often the best ideas are the ones that candidate SoC students come up with on their own. We are happy to [discuss such ideas](https://github.com/JuliaImages/Images.jl/issues/new) and help you refine your proposal.  Below are some potential project ideas that might help spur some thoughts.

## Wide-ranging demos

For new or occasional users, JuliaImages would benefit from a large collection of complete worked examples organized by topic. While the current documentation contains many "mini-demos," they are scattered; an organized page would help users quickly find what they need. We have [set up a landing page](https://juliaimages.org/latest/democards/examples/), but many more demos are needed. [Scikit-image](http://scikit-image.org/docs/stable/auto_examples/) is one potential model.

This "project" might also be split among multiple students who contribute demos as part of their work in a focused area of JuliaImages.

## Benchmarking against other frameworks

JuliaImages provides high-quality implementations of many algorithms; however, as yet there is no set of benchmarks that compare our code against that of other image-processing frameworks.  Developing such benchmarks would allow us to advertise our strengths and/or identify opportunities for further improvement.  See also the OpenCV project below.

## GPU support for many algorithms

JuliaImages supports many common algorithms, but targets only the CPU. With Julia now possessing [first-in-class support for GPUs](https://github.com/JuliaGPU), now is the time to provide GPU implementations of many of the same algorithms.

## Interactivity and visualization tools

Image processing often involves tight interaction between algorithms and visualization. While there are a number of older tools available, leveraging GLVisualize seems to hold the greatest promise. This project might implement a number of interactive tools for region-of-interest selection, annotation, measurement, and modification.  Software suites like OpenCV, ImageJ/Fiji, scikit-image, and Matlab might serve as inspiration.

## Integration of OpenCV and JuliaImages

OpenCV is one of the pre-eminent image-processing frameworks, and there are two existing OpenCV wrappers: https://github.com/JuliaOpenCV and https://github.com/maxruby/OpenCV.jl. This project would update one of these for more recent versions of Julia and JuliaImages, improve interoperability with pure-Julia image processing, and make further refinements to code and documentation. [CxxWrap](https://github.com/JuliaInterop/CxxWrap.jl) or [Cxx](https://github.com/Keno/CXX.jl) are likely to be useful; prospective students may want to spend some time assessing the state of support for Julia 1.0.

## Contributions to a Stereo Matching Package

When two images are taken of a scene with a calibrated stereo rig it is possible to construct a three-dimensional model of the scene provided that one can determine the coordinates of corresponding points in the two images. The task of determining the coordinates of corresponding points is frequenly called *stereo matching* or *disparity estimation*. Numerous algorithms for this task have been proposed over the years and new ones continue to be developed.

This project will implement several stereo matching algorithms. Emphasis will be placed on *efficient* implementations which leverage all of Julia's features for writing fast code.

Example algorithms:

@@tight-list
  1. Bleyer, Michael, Christoph Rhemann, and Carsten Rother. "PatchMatch Stereo-Stereo Matching with Slanted Support Windows." Bmvc. Vol. 11. 2011.
  2. Hirschmuller, Heiko. "Accurate and efficient stereo processing by semi-global matching and mutual information." Computer Vision and Pattern Recognition, 2005. CVPR 2005. IEEE Computer Society Conference on. Vol. 2. IEEE, 2005.
  3. Gehrig, Stefan K., and Clemens Rabe. "Real-time semi-global matching on the CPU." Computer Vision and Pattern Recognition Workshops (CVPRW), 2010 IEEE Computer Society Conference on. IEEE, 2010.
@@

### Where to go for discussion and to find mentors

Depending on project, potential mentors include [Tim Holy](https://github.com/timholy) and [Zygmunt Szpak](https://github.com/zygmuntszpak) but may also involve other JuliaImages developers.  Interested students are encouraged to [open an issue in Images.jl](https://github.com/JuliaImages/Images.jl/issues/new) to introduce themselves and discuss project ideas.
