
# Pythia – Summer of Code
## Machine Learning Time Series Regression

[Pythia](https://github.com/ababii/Pythia.jl) is a package for scalable machine learning time series forecasting and nowcasting in Julia.

The project mentor is [Andrii Babii](https://ababii.bitbucket.io/).

## Machine learning for nowcasting and forecasting

This project involves developing scalable machine learning time series regressions for nowcasting and forecasting. Nowcasting in economics is the prediction of the present, the very near future, and the very recent past state of an economic indicator. The term is a contraction of "now" and "forecasting" and originates in meteorology. In this project, we would like to introduce scalable high-dimensional methods for nowcasting and forecasting that demonstrated the empirical success recently. The project involves coding methods, documentation, visualization, and real-data examples.

**Recommended skills:** Graduate-level knowledge of time series analysis, machine learning, and optimization is helpful.

**Expected output:** Building mixed-frequency data methods (MIDAS) based on the sparse-group LASSO, visualization, AIC/BIC and time series cross-validation tuning, forecast evaluation, pooled and fixed effects panel data regressions, HAC-based inference for sparse-group LASSO, high-dimensional Granger causality tests.

**References:** Simon, N., J. Friedman, T. Hastie, and R. Tibshirani (2013): “A sparse-group LASSO,” Journal of Computational and Graphical Statistics, 22(2), 231–245.

Hastie, T., Tibshirani, R., & Wainwright, M. (2015): Statistical learning with sparsity: the lasso and generalizations, CRC Press.

Friedman, J.H., Hastie, T., Tibshirani, R. (2001): "The Elements of Statistical Learning: Data Mining, Inference, and Prediction", Springer Verlag.

Bok, B., D. Caratelli, D. Giannone, A. M. Sbordone, and A. Tambalotti (2018): “Macroeconomic nowcasting and forecasting with big data,” Annual Review of Economics, 10, 615–643.

Babii, A., E. Ghysels, and J. Striaukas (2020): “Machine learning time series regressions with an application to nowcasting,” arXiv preprint arXiv:2005.14057.



## Time series forecasting at scales

Modern business applications often involve forecasting hundreds of thousands of time series. Producing such a gigantic number of reliable and high-quality forecasts is computationally challenging. This project involves developing automated data-driven and scalable time series forecasting methods. The project involves coding methods, documentation, visualization, and real-data examples for forecasting the intermittent demand.

**Recommended skills:** Graduate-level knowledge of time series analysis is helpful.

**Expected output:** forecasting intermittent demand (Croston, adjusted Croston, INARMA), scalable seasonal ARIMA with covariates, loss-based forecasting (gradient boosting), unsupervised time series clustering, forecast combinations, unit root tests (ADF, KPSS).

**References:** Gourierous C.  and Monfort A.  (1997): "Time Series and Dynamic Models", Cambridge University Press.

Hyndman RJ, Koehler AB, Ord JK and Snyder RD (2008): "Forecasting with Exponential Smoothing: The State Space Approach", Springer: Berlin.

Elliott, G., Timmermann, A. (2016): "Economic Forecasting:, Princeton University Press.

Taylor, S. J., Letham, B. (2018). "Forecasting at scale", The American Statistician, 72(1), 37-45.

Babii, A., E. Ghysels, and J. Striaukas (2020): “Binary Choice with Asymmetric Loss in a Data-Rich Environment: Theory and an Application to Racial Justice,” arXiv preprint arXiv:2010.08463.


