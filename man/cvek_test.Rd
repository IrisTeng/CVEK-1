% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/interface.R
\name{cvek_test}
\alias{cvek_test}
\title{Conduct Hypothesis Testing}
\usage{
cvek_test(
  est_res,
  formula_test,
  kern_func_list,
  data,
  test = "boot",
  alt_kernel_type = "linear",
  B = 100,
  verbose = FALSE
)
}
\arguments{
\item{est_res}{(list) Estimation results returned by estimation() procedure.}

\item{formula_test}{(formula) A user-supplied formula indicating the alternative
effect to test. All terms in the alternative mode must be specified as kernel terms.}

\item{kern_func_list}{(list) A list of kernel functions in the kernel library}

\item{data}{(data.frame, n*d) A data.frame, list or environment (or object
coercible by as.data.frame to a data.frame), containing the variables in
formula. Neither a matrix nor an array will be accepted.}

\item{test}{(character) Type of hypothesis test to conduct.
Must be either 'asymp' or 'boot'.}

\item{alt_kernel_type}{(character) Type of alternative kernel effect to consider.
Must be either 'linear' or 'ensemble'}

\item{B}{(integer) A numeric value indicating times of resampling when test
= "boot".}

\item{verbose}{(logical) Whether to print additional messages.}
}
\value{
\item{pvalue}{(numeric) p-value of the test.}
}
\description{
Conduct hypothesis testing based on CVEK estimation result.
}
\details{
Conduct score tests comparing a fitted model and a more general alternative
model.

There are two tests available here:

\bold{Asymptotic Test}

This is based on the classical variance component test to construct a
testing procedure for the hypothesis about Gaussian process function.

\bold{Bootstrap Test}

When it comes to small sample size, we can use bootstrap test instead, which
can give valid tests with moderate sample sizes and requires similar
computational effort to a permutation test. In the case of bootstrap test, 
we can specify the form of the null derivative kernel (alt_kernel_type) to be 
linear or ensemble. The bootstrap test allows the null derivative 
kernel to be estimated adaptively from data using the same corresponding 
ensemble weights to better represent the alternative hypothesis space.
}
\keyword{internal}
