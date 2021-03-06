% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tuning.R
\name{tuning}
\alias{tuning}
\title{Calculating Tuning Parameters}
\usage{
tuning(Y, X, K_mat, mode, lambda)
}
\arguments{
\item{Y}{(matrix, n*1) The vector of response variable.}

\item{X}{(matrix, n*d_fix) The fixed effect matrix.}

\item{K_mat}{(list of matrices) A nested list of kernel term matrices, 
corresponding to each kernel term specified in the formula for 
a base kernel function in kern_func_list.}

\item{mode}{(character) A character string indicating which tuning parameter
criteria is to be used.}

\item{lambda}{(numeric) A numeric string specifying the range of tuning 
parameter to be chosen. The lower limit of lambda must be above 0.}
}
\value{
\item{lambda0}{(numeric) The selected tuning parameter.}
}
\description{
Calculate tuning parameters based on given criteria.
}
\details{
There are seven tuning parameter selections here:

\bold{leave-one-out Cross Validation}

\deqn{\lambda_{n-CV}={argmin}_{\lambda \in
\Lambda}\;\Big\{log\;y^{\star
T}[I-diag(A_\lambda)-\frac{1}{n}I]^{-1}(I-A_\lambda)^2[I-diag(A_\lambda)-
\frac{1}{n}I]^{-1}y^\star \Big\}}

\bold{Akaike Information Criteria}

\deqn{\lambda_{AIC}={argmin}_{\lambda \in \Lambda}\Big\{log\;
y^{\star T}(I-A_\lambda)^2y^\star+\frac{2[tr(A_\lambda)+2]}{n}\Big\}}

\bold{Akaike Information Criteria (small-sample variant)}

\deqn{\lambda_{AICc}={argmin}_{\lambda \in \Lambda}\Big\{log\;
y^{\star
T}(I-A_\lambda)^2y^\star+\frac{2[tr(A_\lambda)+2]}{n-tr(A_\lambda)-3}\Big\}}

\bold{Bayesian Information Criteria}

\deqn{\lambda_{BIC}={argmin}_{\lambda \in \Lambda}\Big\{log\;
y^{\star T}(I-A_\lambda)^2y^\star+\frac{log(n)[tr(A_\lambda)+2]}{n}\Big\}}

\bold{Generalized Cross Validation}

\deqn{\lambda_{GCV}={argmin}_{\lambda \in \Lambda}\Big\{log\;
y^{\star
T}(I-A_\lambda)^2y^\star-2log[1-\frac{tr(A_\lambda)}{n}-\frac{1}{n}]_+\Big\}}

\bold{Generalized Cross Validation (small-sample variant)}

\deqn{\lambda_{GCVc}={argmin}_{\lambda \in \Lambda}\Big\{log\;
y^{\star
T}(I-A_\lambda)^2y^\star-2log[1-\frac{tr(A_\lambda)}{n}-\frac{2}{n}]_+\Big\}}

\bold{Generalized Maximum Profile Marginal Likelihood}

\deqn{\lambda_{GMPML}={argmin}_{\lambda \in \Lambda}\Big\{log\;
y^{\star T}(I-A_\lambda)y^\star-\frac{1}{n-1}log \mid I-A_\lambda \mid
\Big\}}
}
\references{
Philip S. Boonstra, Bhramar Mukherjee, and Jeremy M. G. Taylor.
A Small-Sample Choice of the Tuning Parameter in Ridge Regression. July
2015.

Trevor Hastie, Robert Tibshirani, and Jerome Friedman. The Elements of
Statistical Learning: Data Mining, Inference, and Prediction, Second
Edition. Springer Series in Statistics. Springer- Verlag, New York, 2
edition, 2009.

Hirotogu Akaike. Information Theory and an Extension of the Maximum
Likelihood Principle. In Selected Papers of Hirotugu Akaike, Springer
Series in Statistics, pages 199–213. Springer, New York, NY, 1998.

Clifford M. Hurvich and Chih-Ling Tsai. Regression and time series model
selection in small samples. June 1989.

Hurvich Clifford M., Simonoff Jeffrey S., and Tsai Chih-Ling. Smoothing
parameter selection in nonparametric regression using an improved Akaike
information criterion. January 2002.
}
\author{
Wenying Deng
}
