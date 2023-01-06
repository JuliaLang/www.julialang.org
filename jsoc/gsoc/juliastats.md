# JuliaStats Projects – Summer of Code

[JuliaStats](https://github.com/JuliaStats) is an organization dedicated to providing high-quality packages for statistics in Julia.


## Panel data analysis

Implement panel analysis models and estimators in Julia.

**Difficulty.** Moderate. **Duration.** 350 hours

### Description

Panel data is an important kind of statistical data that deals with
observations of multiple units across time. Common examples of panel
data include economic statistics (where it is common to observe
figures for several countries over time). This combination of longitudinal 
and cross-sectional data can be powerful for extracting causal
structure from data.

**Mentors.** [Nils Gudat](https://github.com/nilshg), [José Bayoán Santiago Calderón](https://github.com/Nosferican), [Carlos Parada](https://github.com/ParadaCarleton/)

### Prerequisites

-   Must be fluent in at least one language for statistical computing, and 
    willing to learn Julia before the start of projects.
-   Knowledge of basic statistical inference covering topics such as maximum
    likelihood estimation, confidence intervals, and hypothesis testing. (Must
    know before applying.)
-   Basic familiarity with time series statistics (e.g. ARIMA models, autocorrelations) 
    or panel data. (Can be learned after applying.)


### Your contribution

Participants will:

-   Learn and build on past approaches and packages for panel data analysis,
    such as those in [Econometrics.jl](https://github.com/Nosferican/Econometrics.jl) 
    and [SynthControl.jl](https://github.com/nilshg/SynthControl.jl).
-   Generalize [TreatmentPanels.jl](https://github.com/nilshg/TreatmentPanels.jl) 
    and [TSFrames.jl](https://github.com/xKDR/TSFrames.jl) into an abstract interface
    for dealing with and manipulating panel data.
-   Integrate existing estimators provided by packages such as Econometrics.jl 
    into a single package for panel data estimation.


### References

-   [A Primer for Panel Data Analysis](http://web.pdx.edu/~crkl/ec510/pda_yaffee.pdf)
-   [Econometric Analysis of Cross Section and Panel Data](https://mitpress.mit.edu/books/econometric-analysis-cross-section-and-panel-data-second-edition) by Jeffrey Wooldridge


## Distributions.jl Expansion

Distributions.jl is a package providing basic 

**Difficulty.** Easy-Medium. **Duration.** 175-350 hours

### Prerequisites

-   Must be fluent in Julia.
-   A college-level introduction to probability covering topics such as
    probability density functions, moments and cumulants, and multivariate
    distributions.

### Your contribution

Possible improvements to Distributions.jl include:
-   New distribution families, such as elliptical distributions or
    distributions of order statistics.
-   Additional parametrizations and keyword constructors for current 
    distributions.
-   Extended support for distributions of transformed variables.


## CRRao.jl

Implement consistent APIs for statistical modeling in Julia. 

**Difficulty.** Medium. **Duration.** 350 hours

### Description

Currently, the Julia statistics ecosystem is quite fragmented. There is 
value in having a consistent API for a wide variety of statistical models. 
The [CRRao.jl](https://github.com/xKDR/CRRao.jl) package offers this design.

**Mentors.** [Sourish Das](https://www.cmi.ac.in/~sourish/), [Ayush Patnaik](https://github.com/ayushpatnaikgit)

### Prerequisites

-   Must be fluent in Julia.
-   Basic statistical inference covering topics such as maximum
    likelihood estimation, confidence intervals, and hypothesis testing.

### Your contribution

Participants will:

-   Help create, test, and document standard statistical APIs for Julia.


## JuliaStats Improvements 

General improvements to JuliaStats packages, depending on the interests 
of participants.

**Difficulty.** Easy-Hard. **Duration.** 175-350 hours.

### Description

JuliaStats provides many of the most popular packages in Julia, including:
-   StatsBase.jl for basic statistics (e.g. weights, sample statistics,
    moments). 
-   MixedModels.jl for random and mixed-effects linear models. 
-   GLM.jl for generalized linear models. 
All of these packages are critically important to the Julia statistics
community, and all could be improved.


**Mentors.** Mousum Dutta, [Chirag Anand](https://github.com/chiraganand), [Ayush Patnaik](https://github.com/ayushpatnaikgit), [Carlos Parada](https://github.com/paradacarleton)

### Prerequisites

-   Must be fluent in at least one language for statistical computing, and 
    willing to learn Julia before the start of projects.
-   Knowledge of basic statistical inference covering topics such as maximum
    likelihood estimation, confidence intervals, and hypothesis testing.


### Your contribution

Participants will:

-   Make JuliaStats better! This can include additional estimators,
    new features, performance improvements, or anything else you're
    interested in.
-   StatsBase.jl improvements could include support for cumulants,
    L-moments, or additional estimators.
-   Improved nonparametric density estimators, e.g. those in R's
    [Locfit](https://cran.r-project.org/web/packages/locfit/index.html).
