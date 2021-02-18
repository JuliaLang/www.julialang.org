@def rss_pubdate = Date(2018, 8, 13)
@def rss = """ GSoC 2018: Adding Newer Features and Speeding up Convolutions in Flux | Over the summer I have been working at improving the Computer Vision capabilities of Flux. My specific line of work was to __add newer models to the Flux model-zoo__, __implement some new features__ and also __improve the speed of the previous layers__. Specifically, I achieved a __18-fold__ speed up... """
@def published = "13 August 2018"
@def title = "GSoC 2018: Adding Newer Features and Speeding up Convolutions in Flux"
@def authors = """<a href="https://github.com/avik-pal/">Avik Pal</a>"""  
@def hascode = true

Over the summer I have been working at improving the Computer Vision capabilities of Flux. My specific line of work was to __add newer models to the Flux model-zoo__, __implement some new features__ and also __improve the speed of the previous layers__. Specifically, I achieved a __18-fold__ speed up for the __Convolutions__ and around __3-fold__ for __BatchNorm__.

## A Short Summary of my work during GSoC 2018

I am listing all the essential PRs I had made during this project. Some of them are merged, some are unmerged, and some are even a work in progress. We discuss only major PRs, leaving out bug fixes and small patches. So here they are

1. [Flux.jl](https://github.com/FluxML/Flux.jl)
    * [Adds support for a more efficient CUDNN Binding for Convolutions](https://github.com/FluxML/Flux.jl/pull/335)
    * [Implements a wrapper for CUDNN BatchNorm and hooks it up with Flux](https://github.com/FluxML/Flux.jl/pull/294)
    * [Allows Flux to support Depthwise Convolutions in CPU](https://github.com/FluxML/Flux.jl/pull/279)
2. [CuArrays.jl](https://github.com/JuliaGPU/CuArrays.jl)
    * [Provide support for allocating workspace in CUDNN Convolutions](https://github.com/JuliaGPU/CuArrays.jl/pull/96)
    * [Adds wrappers for CUDNN Activation Functions and some functions for efficient Convolutions](https://github.com/JuliaGPU/CuArrays.jl/pull/100)
3. [Metalhead.jl](https://github.com/FluxML/Metalhead.jl)
    * [Fix the API of the newly added models](https://github.com/FluxML/Metalhead.jl/pull/10)
    * [Improve the accuracy of the models in Metalhead](https://github.com/FluxML/Metalhead.jl/pull/14)
    * [Add new models to Metalhead](https://github.com/FluxML/Metalhead.jl/pull/17)
4. [NNlib.jl](https://github.com/FluxML/NNlib.jl)
    * [Add the support of Pure Julia Depthwise Convolutions and their Gradients](https://github.com/FluxML/NNlib.jl/pull/42)
5. [model-zoo](https://github.com/FluxML/model-zoo)
    * [Add the VGG models to model-zoo](https://github.com/FluxML/model-zoo/pull/33)
    * [Showcase the use of Residual Networks as a Scene Classifier](https://github.com/FluxML/model-zoo/pull/44)
    * [Put popular Imagenet Winning models like Inception Nets into model-zoo](https://github.com/FluxML/model-zoo/pull/45)

The following new packages were developed during the course of this project.

1. [FastStyleTransfer.jl](https://github.com/avik-pal/FastStyleTransfer.jl)
2. [MURA.jl](https://github.com/avik-pal/MURA.jl)
3. [DeepLearningBenchmarks](https://github.com/avik-pal/DeepLearningBenchmarks)
4. [CNNVisualize.jl](https://github.com/avik-pal/CNNVisualize.jl)
5. [DeepDream.jl](https://github.com/avik-pal/DeepDream.jl)

# A Walkthrough of the Pull Requests

Let's go through these changes one by one.

### Add a wrapper for CUDNN BatchNorm

Flux currently lacks a dedicated GPU Kernel for BatchNorm. BatchNorm is one of the most important layers of Neural Networks, and they speed up training by dealing with the internal mean covariance shift. Until now we were using the Flux CPU code for BatchNorm (which obviously will be slow). So this PR aims to solve this problem by wrapping the CUDNN Batchnorm Layer and integrating it with the Flux AD. Some highlights of the speed (and memory consumption) improvements are `1.860 s (1367 allocations: 50.92 KiB)` -> `2.782 ms (276 allocations: 10.38 KiB)`. I am benchmarking the __total time (forward + backward)__ of __BatchNorm(100)__ for a __224 * 224 * 100 * 10__ sized array. This PR is yet to be merged. It needs to be updated to Julia 1.0 (which is supported by the Flux master) before merging.

### Speed up the CUDA Convolutions in Flux

I performed benchmarks between Flux and Pytorch (read on to know more about that). We went on profile the neural networks and found some issues in Flux Conv Layer. The major bottleneck was in the `broadcasted bias addition` that we were performing. So instead of using the `broadcasted bias addition` we use `cudnnAddTensor` for CUDNN Version prior to 7.1. For anything above 7.1, we shift to using `cudnnConvolutionBiasActivationForward` with the activation always being `identity` and finally dispatch over the other activations. The major improvements to speed using this update reflects in the `DeepLearningBenchmarks` repo. Also, this PR depends on a CuArrays PR, so it cannot be merged until the CuArrays has been merged. Also, it requires updates to be able to adapt to Julia 1.0.

### Native Julia Depthwise Convolutions in Flux and NNlib

Depthwise Separable Convolutions are vital for Mobile Applications of Deep Neural Networks. MobileNets and Xception Net make direct use of this form of Convolution. So it is quite essential for a deep learning library to support such convolutions out of the box. Firstly this involved implementing the CPU version of the code in NNlib. Then we just need to the hook up the depthwise convolution into the Flux AD. Out of box support also allow some of the _to be_ added models in __Metalhead.jl__ and __model-zoo__ to be easily defined. As a part of some future work on this topic, there needs to be a CUDNN binding for this algorithm.

### Adding support for more CUDNN Convolution Algorithms

There are a variety of Convolution Algorithms around. All these use the properties of the `input tensor`, and the `filter tensor` and have very specialized routines developed for efficient convolutions. Thankfully CUDNN has these specially developed convolution routines built into it. So we need to integrate it directly into `CuArrays` and expose its API for use from other packages like `Flux`. The wrappers for a simple convolution operation was pre-written in CuArrays. So we only need to create the wrappers for `workspace allocation`. This PR adds the necessary wrappers and changes the convolution function definitions to expose the API for `algorithm change`. So for the end user, the only change would be to change the keyword argument `algo`.

### Add wrappers for more Convolution and Activation Functions

When benchmarking the Flux Convolution Code, we figured out some of the major bottlenecks that were coming out of the `Backward Pass for Convolution Bias`. Hence the natural choice was to wrap the CUDNN Function which efficiently calculates the Gradient for Bias. Also, we were able to wrap a function for applying `activation` and `adding bias` at the same time. To use this function, `cudnnConvolutionBiasActivationFunction` we needed to wrap the Activation Forward and Backward Pass functions. Now lets see what kind of speed improvements we achieved with this update.

~~~
<p align = "center">
    <img src = "/assets/blog/2018-08-13-GSoC-Flux-Computer-Vision/flux_internal_benchmarks.png" width="750">
</p>
~~~

### Fixing the API of new Metalhead models

Some models like GoogleNet and Resnet were added to Metalhead recently (special thanks to __Ayush Shridhar [@ayush1999]__ for his work on __ONNX.jl__). However, this code is __generated automatically__ and not necessarily human readable. Moreover, the only thing we could do we these models was to perform predictions. We can't use it for something like feature extraction. So we ported some of my models from the model-zoo and manually load the weights into it. For more detailed usage of Metalhead go [here](https://avik-pal.github.io/blog/2018/07/Computer_Vision_using_Metalhead/).

### Improve the accuracy of Metalhead models

The accuracy of the existing loaded models into Flux was pretty bad. We had already tried out a variety of preprocessing steps but mostly of no use. After some trial and errors, we were able to figure out the primary reason. We were using the weights for __Cross Correlation Operation__ in place of a __Convolution Operation__. For now, this is fixed by manually flipping the weights before loading them. As a long-term solution, we are exposing the parameter to choose between __convolution__ and __cross-correlation__ in `NNlib` and eventually in `Flux`.

### Add bleeding edge Computer Vision models in Metalhead

This part of the project is still in its infancy. Most of the work for this is done (but it is mainly scattered in model-zoo). The model zoo is  essentially is targeted to allow users to import all sorts of models in their code. The models might be untrained (which most of the models are currently are). So the primary motivation is that if we want to train a `ResNeXt` model, we don't have to redefine something which has already been done by someone. We should be able to load the model without any effort.

```julia
model = VGG19() # This fetches an untrained VGG19 model
model_trained = trained(VGG19)
    # Get the trained VGG19 model. This is the same as previously calling VGG19()
trained(VGG11)
    # We get an error as we don't currently have a trained VGG11 model but VGG11() works fine
```

# Brief Description of the Packages

### DeepDream.jl

This package provides a simple API to generate [dreams](https://en.wikipedia.org/wiki/DeepDream) on the desired image. You need to provide the image, choose what type of dream you want and which model to use. This package relies on Flux and Metalhead for its trained models.

~~~
<p align = "center">
    <img src = "/assets/blog/2018-08-13-GSoC-Flux-Computer-Vision/deepdream.jpg" width="750" height="750">
</p>
~~~

The above image was generated using `guided deepdream`.

### CNNVisualize.jl

Over the years several visualization algorithms have been developed to understand the functioning of neural networks. This package aims to implement such algorithms. Most of these, are going to work out of the box for Metalhead. This is currently a work in progress package, however, most of it is complete.

Here's a small demo of the package

~~~
<script src="https://gist.github.com/avik-pal/7bea8a2f004268963dae431776215746.js"></script>
~~~

### FastStyleTransfer.jl

This is the implementation of the paper __[Perceptual Losses for Real-Time Style Transfer and Super-Resolution](https://arxiv.org/pdf/1603.08155)__. There are some obvious deviations from the paper. We used the best layer implementations that were currently available in Flux. As for the exact architecture it is still in developement. We provide three pre-trained models with this package. The API has been kept as simple as possible.

Below is a small example of style transfer on MonaLisa

~~~
<p align = "center">
    <img src = "/assets/blog/2018-08-13-GSoC-Flux-Computer-Vision/styletransfer.jpg" width="750">
</p>
~~~

# Overview of the Work done in GSoC 2018

As you can see from the above PR descriptions a lot of my work has been around benchmarking Flux models and making speed ups wherever possible. The initial part of my job was to add some new computer vision models to the Flux model-zoo. So we added models like `VGGNets`, `ResNets`, `DenseNets`, etc. to the Flux model-zoo. Also, we were able to port some of these models to the `Metalhead` package which is specially designed to address Computer Vision problems. After lots of experimentation and help from some people of the JuliaLang community, we were able to fix some of the accuracy problems we were encountering. Next, we went on to develop a package to perform FastStyleTransfer. It allows users to easily `train` their models and also `stylize` images with great ease. We was also able to train some of the densenet models and recreate the results of the MURA paper.

Next up was to perform benchmarks for the current implementations in Flux and solve the bottlenecks wherever possible. So we wrote the benchmarking scripts for Flux and Pytorch and performed heads on comparison between them. For the first time, it turned out that Pytorch is much faster than Flux. However, we were able to find the reason for this slow speed. Turned out it was because of the lack of a specialized kernel for broadcasted addition and its backward pass. So the immediate solution was to `wrap some of the CUDNN Functions` and integrate them with Flux. Doing this actually brings down the time taken by those layers a lot. Currently, we are at-par with Pytorch wrt the time for each of the individual layers.

# Experience at JuliaCON

I was able to attend JuliaCon 2018 in London. Thanks to __The Julia Project__ and __NumFOCUS__ for funding this trip. I got the opportunity to present a [poster](https://home.iitk.ac.in/~avikpal/JuliaCon%20Poster.pdf) on the work I had done during my GSoC. It was the first conference I was attending, so it was indeed quite a unique experience. I was able to share my work with other people and even got some valuable advice regarding it. Also, I discovered some new cool open-sourced projects that I would like to contribute to in the future. Finally, it's always a pleasure to meet the people I have been interacting with in Slack.

# Why use Julia and Flux for Deep Learning?

There is a [brilliant post](/blog/2017/12/ml-pl/) on how Julia can play its part as a Language for Machine Learning. That post summarizes the reasons from the viewpoint of people highly experienced in the field of Machine Learning. Here I shall be presenting the reasons from a layman's point of view.

Just think about implementing a standard Computer Vision model in one of the popular frameworks, like Pytorch or Tensorflow. It's pretty simple, right? Just call the necessary layers using their API, and you're done. Now imagine having to define something that is not present in their standard library. You need to first write your custom layer (both forward and backward passes, in case you are wondering) in C++ and if that was not hard enough you go about to define the GPU Kernel for that code in CUDA C. Now you integrate this layer (obviously in Python) with Pytorch or Tensorflow as per their particular API. And good luck debugging the SegFaults that you get.

Now let's see how you do that in Flux. You start by writing the layer in Julia and its CUDA GPU version using __CUDAnative__ (cheers to __Tim Besand [@maleadt]__ for his excellent work). As for integration into the Flux AD you simply use the `@grad` macro. It's that simple!

One complaint you might be having is the unavailability of a lot of trained models. However, thanks to __ONNX.jl__ and __Keras.jl__ the problem is more or less resolved. Both of these are the work of __Ayush Shridhar__. Using these you can use models trained using Pytorch or CNTK, as long as they are stored in ONNX format. Also, now you have a wide range of Reinforcement Learning Models like __AlphaGo.jl__ (by __Tejan Karmali__) written using Flux besides the Computer Vision models in __model-zoo__ and __Metalhead.jl__.

# Future Works for the Project

This Project has deviated highly from what I had initially proposed but its mostly for good. The things implemented as a part of this project should surely help in the faster training of Deep Neural Networks in Flux and also help create more complicated models using Flux. That being said an exciting thing for the future of this Project would be to complete the addition of __Object Classification models__ in Metalhead as proposed in this [issue](https://github.com/FluxML/Metalhead.jl/issues/16). Another interesting thing to have would be some __Object Detection__ models built using Flux in one place. Also, we should continue to solve the current bottlenecks that are left to be addressed. We should keep adding the benchmarks to [DeepLearningBenchmarks](https://github.com/avik-pal/DeepLearningBenchmarks) which is vital for the identification of bottlenecks.

# Acknowledgements

Firstly, I should thank __Google__ for organizing Google Summer of Code which gave me this excellent opportunity to work with the Open Source Community. Also, I thank __NumFOCUS__ and __JuliaLang__ for selecting me to work on this project. Next, I would thank my mentors __Viral Shah__ and __Mine Innes__ for their constant support and guiding me through my project. Finally, let me thank the brilliant __JuliaLang Community__ for clearing my doubts and being an excellent source for learning.


~~~
<p align = "center">
    <img src = "/assets/blog/2018-08-13-GSoC-Flux-Computer-Vision/gsoc_logo.png" width="700">
</p>
~~~
