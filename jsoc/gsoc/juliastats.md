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
-   Generalize [TreatmentPanels.jl](https://github.com/nilshg/TreatmentPanels.jl) into an abstract interface
    for dealing with and manipulating panel data.
-   Integrate existing estimators provided by packages such as Econometrics.jl 
    into a single package for panel data estimation.


### References

-   [A Primer for Panel Data Analysis](http://web.pdx.edu/~crkl/ec510/pda_yaffee.pdf)
-   [Econometric Analysis of Cross Section and Panel Data](https://mitpress.mit.edu/books/econometric-analysis-cross-section-and-panel-data-second-edition) by Jeffrey Wooldridge


## Distributions.jl Expansion

Distributions.jl is a package providing basic probability distributions and associated functions. 

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
-   [Replace RMath RNGs.](https://github.com/JuliaStats/Distributions.jl/issues/294)

## HypothesisTesting.jl Expansion

HypothesisTesting.jl is a package that implements a range of hypothesis tests.

**Difficulty.** Medium. **Duration.** 350 hours

**Mentors.** [Sourish Das](https://www.cmi.ac.in/~sourish/), [Mousum Dutta](https://github.com/mousum-github)

### Prerequisites

-   Must be fluent in Julia.
-   A college-level introduction to probability covering topics such as
    probability density functions, moments and cumulants, and multivariate
    distributions.

### Your contribution

Improvements to Distributions.jl include:
-   Develop Breusch-Pagan test against heteroskedasticity
-   Develop Harvey-Collier Test for linearity
-   Develop Bartlet Rank Test for randomness
-   Develop an exact dynamic programming solution to Wilcoxon–Mann–Whitney (WMW) test 

### References

-   [bptest in R](https://search.r-project.org/CRAN/refmans/lmtest/html/bptest.html)
-   [randtests in R](https://cran.r-project.org/web/packages/randtests/randtests.pdf)
-   Alexander Marx, etal. (2016) “Exact Dynamic Programing Solution of the Wilcoxon–Mann–Whitney Test” 
    Genomics Proteomics Bioinformatics, 14, 55-61


## CRRao.jl

Implement consistent APIs for statistical modeling in Julia. 

**Difficulty.** Medium. **Duration.** 350 hours

### Description

Currently, the Julia statistics ecosystem is quite fragmented. There is 
value in having a consistent API for a wide variety of statistical models. 
The [CRRao.jl](https://github.com/xKDR/CRRao.jl) package offers this design.

**Mentors.** [Sourish Das](https://www.cmi.ac.in/~sourish/), [Ayush Patnaik](https://xkdr.org/author/ayush-patnaik)

### Prerequisites

-   Must be fluent in Julia.
-   Basic statistical inference covering topics such as maximum
    likelihood estimation, confidence intervals, and hypothesis testing.

### Your contribution

Participants will:

-   Help create, test, and document standard statistical APIs for Julia.
-   Integrate MixedModels.jl


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


**Mentors.** [Mousum Dutta](https://github.com/mousum-github), [Ayush Patnaik](https://xkdr.org/author/ayush-patnaik), [Carlos Parada](https://github.com/paradacarleton)

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
    
    
## Survey.jl
This package is used to study complex survey data. Examples of real-world surveys include official government surveys in areas like economics, health and agriculture; financial and commercial surveys. Social and behavioural scientists like political scientists, sociologists, psychologists, biologists and macroeconomists also analyse surveys in academic and theoretical settings. The prevalence of "big" survey datasets has exploded with the ease of administering surveys online. The project aims to use performance enhancements of Julia to create a fast package for modern "large" surveys. 

**Difficulty.** Easy-Hard. **Duration.** 175-350 hours

**Mentors.** [Ayush Patnaik](https://xkdr.org/author/ayush-patnaik)
### Prerequisites

-   Experience with at least one language for statistical computing (Julia, R, Python, SAS, Stata etc), and 
    willing to learn Julia before the start of projects.
-   Knowledge of basic statistical and probability concepts, preferably covered from academic course(s).
-   (Bonus) Any prior experience or coursework with survey analysis, using any software or tool.

### Your contribution

The project can be tailored around the background and interests of participants and depending on ability, several standalone mini-projects can be created. Participants can potentially work on:
-   Generalised variance estimation methods using taylor linearisation
-   Post-stratification, raking or calibration, GREG estimation and related methods.
-   Connect Survey.jl with [FreqTable.jl](https://github.com/nalimilan/FreqTables.jl) for contingency table analysis, or to survival analysis, or a machine learning library.
-   Improve support for multistage and Probability Proportional to Size (PPS) sampling with or without replacement.
-   Association tests (with contingency tables), Rao-Scott, likelihood ratio tests for glms, Cox models, loglinear models.
-   Handling missing data, imputation like [mitools](https://stat.ethz.ch/CRAN/web/packages/mitools/index.html).

### References

-   [Survey.jl](https://github.com/xKDR/Survey.jl) - see some issues, past PR's and milestone ideas
-   Julia discourse post asking for community suggestions [here](https://discourse.julialang.org/t/suggestions-for-the-design-of-survey-jl/86381/2)
-   JuliaCon Statistics Symposium [clip](https://youtu.be/RY7SSfyNl9o) for Survey
-   [Model Assisted Survey Sampling](https://d-nb.info/969712979/04) - Sarndal, Swensson, Wretman (1992)
-   [Complex Surveys: a guide to analysis using R](https://r-survey.r-forge.r-project.org/svybook/)
-   [Survey analysis in R](https://r-survey.r-forge.r-project.org/survey/) for high level topics than can be implemented for Julia
