# MedPipe3D Projects 

MedPipe3D.jl together with MedEye3D.jl MedEval3D.jl and currently in development MedImage.jl is a set of libraries created to provide essential tools for 3D medical imaging to the Julia language exosystem. Recently all of the projects migrated also to the JuliaHealth organization to improve package visibility and promote interoperability.


## Potential Projects

### Project 1: Adding functionalities to medical imaging visualizations

**Description:** 
MedEye3D is a package that supports the display of medical imaging data. It includes multiple functionalities specific to this use case like automatic windowing to display soft tissues and lungs.... Display that takes into account voxel spacing, support of overlaying display for multimodal imaging, and more. All with high performance powered by OpenGL and Rocket.jl. Still, a lot of further improvements are possible and are described in the Potential Outcomes section. 

- **Mentor:** Jakub Mitura [email: jakub.mitura14@gmail.com]

- **Difficulty**: Hard

- **Duration**: 350 hours

- **Suggested Skills and Background**: 
  - Experience with Julia
  - Basic familiarity with computer graphics preferably OpenGL 
  - Some experience with 3d volumetric data with spatial metadata (or a willingness to learn!)

- **Potential Outcomes:** 
Although MedEye3D already supports displaying medical images, there are still some functionalities that will be useful:
1) Developing support for multiple image viewing with indicators for image registration like display of the borders, and display lines connecting points.
2) Automatic correct windowing for MRI.
3) Support of display for supervoxels (sv). Show borders of sv; indicate whether the gradient of the image is in agreement with sv borders.
4) Improve startup time.
5) Simplify basic usage by providing high-level functions.



### Project 2: Adding dataset-wide functions and integrations of augmentations

**Description:** 
MedPipe3D was created as a package that improves integration between other parts of the small ecosystem (MedEye3D, MedEval3D, and MedImage). Currently, because of changes in other packages, it needs to be expanded and adapted so it can be a basis for a fully functional medical imaging pipeline.

- **Mentor:** Jakub Mitura [email: jakub.mitura14@gmail.com]

- **Difficulty**: Medium

- **Duration**: 175 hours

- **Suggested Skills and Background**: 
  - Experience with Julia
  - Familiarity with some of the following Julia packages would be a strong asset: 
    - MedEye3D.jl 
    - MedEval3D.jl


- **Potential Outcomes:** 
1) Integrate augmentations like rotations recalling gamma etc.
2) Enable invertible augmentations and support test time augmentations.
3) Add patch-based data loading with probabilistic oversampling.
4) Calculate median and mean spacing and enable applying resampling to the median or mean spacing of the dataset.
5) Add basic post-processing like the largest connected component analysis.
6) Set all hyperparameters (of augmentation; size of a patch, threshold for getting binary mask from probabilities) in a struct or dictionary to enable hyperparameter tuning.
7) Enable automated display of the algorithm output in the validation epoch, including saving such outputs to persistent storage.

This set of changes although time-consuming to implement should not pose a significant issue to anybody with experience with the Julia programming language. However, implementing those will be a huge step in making Julia language a good alternative to Python in developing end-to-end medical imaging segmentation algorithms.

### Project 3: Adding loss function and advanced metric

**Description:** 
MedEval3D is the library with a set of high-performance 3D segmentation metrics. These are crucial for establishing the performance of the 3d segmentation algorithms.

- **Mentor:** Jakub Mitura [email: jakub.mitura14@gmail.com]

- **Difficulty**: Medium

- **Duration**: 175 hours

- **Suggested Skills and Background**: 
  - Experience with Julia


- **Potential Outcomes:** 
1) Implementation of popular loss functions like focal loss dice cross entropy loss etc.
2) Add compound losses like Dice with TOPK 
3) Integration of per voxel Hausdorff distance (The author of the library had created also a cuda c++ algorithm that is 200 times faster than monai and want to integrate it to MedEval3D )
4) Develop tests for the implementation of differentiable distance-based loss (Hausdorff distance or optimal transport) that will check for stability of the differentiation and whether both distance and overlap will impact the value of loss in a desired manner. The actual algorithm will be developed later by the package author.

Those changes will add further flexibility to model development, and make model diagnostics and debugging more intuitive.
