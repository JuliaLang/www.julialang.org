# Pythia – Summer of Code
## Machine Learning Time Series Regression

[Pythia](https://github.com/ababii/Pythia.jl) is a package for scalable machine learning time series forecasting and nowcasting in Julia.

The project mentors are [Andrii Babii](https://ababii.github.io/) and [Sebastian Vollmer](https://www.turing.ac.uk/people/researchers/sebastian-vollmer/).

## Machine learning for nowcasting and forecasting

This project involves developing scalable machine learning time series regressions for nowcasting and forecasting. Nowcasting in economics is the prediction of the present, the very near future, and the very recent past state of an economic indicator. The term is a contraction of "now" and "forecasting" and originates in meteorology. 

The objective of this project is to introduce scalable regression-based nowcasting and forecasting methodologies that demonstrated the empirical success in data-rich environment recently. Examples of existing popular packages for regression-based nowcasting on other platforms include the "MIDAS Matlab Toolbox", as well as the 'midasr' and 'midasml' packages in R. The starting point for this project is porting the 'midasml' package from R to Julia. Currently Pythia has the sparse-group LASSO regression functionality for forecasting. 

The following functions are of interest: in-sample and out-of sample forecasts/nowcasts, regularized MIDAS with Legendre polynomials, visualization of nowcasts, AIC/BIC and time series cross-validation tuning, forecast evaluation, pooled and fixed effects panel data regressions for forecasting and nowcasting, HAC-based inference for sparse-group LASSO, high-dimensional Granger causality tests. Other widely used existing functions from R/Python/Matlab are also of interest.

**Recommended skills:** Graduate-level knowledge of time series analysis, machine learning, and optimization is helpful.

**Expected output:** The contributor is expected to produce code, documentation, visualization, and real-data examples.

**References:** Contact project mentors for references.

## Time series forecasting at scales

Modern business applications often involve forecasting hundreds of thousands of time series. Producing such a gigantic number of reliable and high-quality forecasts is computationally challenging, which limits the scope of potential methods that can be used in practice, see, e.g., the 'forecast', 'fable', or 'prophet' packages in R. Currently, Julia lacks the scalable time series forecasting functionality and this project aims to develop the automated data-driven and scalable time series forecasting methods. 

The following  functionality is of interest: forecasting intermittent demand (Croston, adjusted Croston, INARMA), scalable seasonal ARIMA with covariates, loss-based forecasting (gradient boosting), unsupervised time series clustering, forecast combinations, unit root tests (ADF, KPSS). Other widely used existing functions from R/Python/Matlab are also of interest.

**Recommended skills:** Graduate-level knowledge of time series analysis is helpful.

**Expected output:** The contributor is expected to produce code, documentation, visualization, and real-data examples.

**References:** Contact project mentors for references.
