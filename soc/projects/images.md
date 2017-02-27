---
layout: default
title:  JuliaImages Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

[JuliaImages](https://github.com/JuliaImages) has recently undergone a significant revamp, with many improvements in the core infrastructure, project organization, and documentation. For the future, a major push is on expanding the functionality. Please see the [documentation](http://juliaimages.github.io/latest/) for information about the current state; perhaps the [feature comparison matrix](http://juliaimages.github.io/latest/api_comparison.html) may be particularly useful for generating further ideas about possible ways to contribute.

## Interactivity and visualization tools

Image processing often involves tight interaction between algorithms and visualization. While there are a number of older tools available, leveraging GLVisualize seems to hold the greatest promise. This project might implement a number of interactive tools for region-of-interest selection, annotation, measurement, and modification.  Software suites like OpenCV, ImageJ/Fiji, scikit-image, and Matlab might serve as inspiration.

**Recommended skills:** Previous experience developing GUIs.

**Expected Results:** Building blocks for developing custom GUIs for interactive image processing and analysis.  Possible creation of an interactive "shell application" similar to ImageJ.

**Mentors:** [Simon Danisch](https://github.com/SimonDanisch), [Tim Holy](https://github.com/timholy/), and [Ron Rock](https://github.com/rsrock).

## Integration of OpenCV and JuliaImages

OpenCV is one of the pre-eminent image-processing frameworks, and there is an existing [OpenCV wrapper](https://github.com/maxruby/OpenCV.jl). This project would update it for more recent versions of Julia and JuliaImages, convert it into a module, improve interoperability with pure-Julia image processing, and make further refinements to code and documentation. In areas of overlap between pure-Julia and OpenCV functionality, one would also implement a set of benchmarks for performance comparisons.

**Recommended skills:** Previous experience using OpenCV in C++ or one of the bindings for other languages.

**Expected Results:** A rejuvinated OpenCV package that integrates more effectively into the ecosystem of JuliaImages.

**Mentors:** [Maximiliano Suster](https://github.com/maxruby) and [Tim Holy](https://github.com/timholy/).

## Image segmentation

Image segmentation is the process of dividing an image up into constituent objects. While imperfect, a number of well-tested [algorithms](https://en.wikipedia.org/wiki/Image_segmentation) have been developed for this task. This project would implement a number of these algorithms in pure Julia, building on existing packages and the framework in JuliaImages. This project would also develop a number of tutorials/demonstrations illustrating the methods.

**Recommended skills:** Strong mathematical background and the ability to read primary literature.

**Expected Results:** Implementation of additional algorithms for segmentation. Some contributions would be to existing or new packages in JuliaImages, others might leverage work in the wider Julia ecosystem. Documentation and tutorials would be hosted at the main JuliaImages site.

**Mentors:** [Anchit Navelkar](https://github.com/mronian) and [Tim Holy](https://github.com/timholy/).
