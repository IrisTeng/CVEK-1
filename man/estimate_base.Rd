% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimation.R
\name{estimate_base}
\alias{estimate_base}
\title{Estimating Projection Matrices}
\usage{
estimate_base(Y, X, K_list, mode, lambda, ...)
}
\arguments{
\item{Y}{(matrix, n*1) The vector of response variable.}

\item{X}{(matrix, n*d_fix) The fixed effect matrix.}

\item{K_list}{(list of matrices) A nested list of kernel term matrices. 
The first level corresponds to each base kernel function in kern_func_list, 
the second level corresponds to each kernel term specified in the formula.}

\item{mode}{(character) A character string indicating which tuning parameter
criteria is to be used.}

\item{lambda}{(numeric) A numeric string specifying the range of tuning 
parameter to be chosen. The lower limit of lambda must be above 0.}

\item{...}{Additional parameters to pass to estimate_ridge.}
}
\value{
\item{A_hat}{(list of length K) A list of projection matrices for
each kernel in the kernel library.}

\item{P_K_hat}{(list of length K) A list of projection matrices to kernel
space for each kernel in the kernel library.}

\item{beta_list}{(list of length K) A list of fixed effect estimators for
each kernel in the kernel library.}

\item{alpha_list}{(list of length K) A list of kernel effect estimates for
each kernel in the kernel library.}

\item{kern_term_list}{(list of length K) A list of kernel effects for
each kernel in the kernel library.}

\item{A_proc_list}{(list of length K) A list of projection matrices for
each kernel in the kernel library.}

\item{lambda_list}{(list of length K) A list of selected tuning parameters for
each kernel in the kernel library.}

\item{error_mat}{(matrix, n*K) A n\*K matrix indicating errors.}
}
\description{
Calculate the estimated projection matrices for every kernels in the kernel
library.
}
\details{
For a given mode, this function returns a list of projection matrices for
every kernel in the kernel library and a n*K matrix indicating errors.
}
\references{
Jeremiah Zhe Liu and Brent Coull. Robust Hypothesis Test for
Nonlinear Effect with Gaussian Processes. October 2017.
}
\author{
Wenying Deng
}
\keyword{internal}
