#' Estimating Ensemble Kernel Matrices
#' 
#' Give the ensemble projection matrix and weights of the kernels in the
#' library.
#' 
#' There are three ensemble strategies available here:
#' 
#' \bold{Empirical Risk Minimization (Stacking)}
#' 
#' After obtaining the estimated errors \eqn{\{\hat{\epsilon}_d\}_{d=1}^D}, we
#' estimate the ensemble weights \eqn{u=\{u_d\}_{d=1}^D} such that it minimizes
#' the overall error \deqn{\hat{u}={argmin}_{u \in \Delta}\parallel
#' \sum_{d=1}^Du_d\hat{\epsilon}_d\parallel^2 \quad where\; \Delta=\{u | u \geq
#' 0, \parallel u \parallel_1=1\}} Then produce the final ensemble prediction:
#' \deqn{\hat{h}=\sum_{d=1}^D \hat{u}_d h_d=\sum_{d=1}^D \hat{u}_d
#' A_{d,\hat{\lambda}_d}y=\hat{A}y} where \eqn{\hat{A}=\sum_{d=1}^D \hat{u}_d
#' A_{d,\hat{\lambda}_d}} is the ensemble matrix.
#' 
#' \bold{Simple Averaging}
#' 
#' Motivated by existing literature in omnibus kernel, we propose another way
#' to obtain the ensemble matrix by simply choosing unsupervised weights
#' \eqn{u_d=1/D} for \eqn{d=1,2,...D}.
#' 
#' \bold{Exponential Weighting}
#' 
#' Additionally, another scholar gives a new strategy to calculate weights
#' based on the estimated errors \eqn{\{\hat{\epsilon}_d\}_{d=1}^D}.
#' \deqn{u_d(\beta)=\frac{exp(-\parallel \hat{\epsilon}_d
#' \parallel_2^2/\beta)}{\sum_{d=1}^Dexp(-\parallel \hat{\epsilon}_d
#' \parallel_2^2/\beta)}}
#' 
#' @param strategy (character) A character string indicating which ensemble
#' strategy is to be used.
#' @param beta_exp (numeric/character) A numeric value specifying the parameter
#' when strategy = "exp" \code{\link{ensemble_exp}}.
#' @param error_mat (matrix, n*K) A n\*K matrix indicating errors.
#' @param A_hat (list of length K) A list of projection matrices to kernel space 
#' for each kernel in the kernel library.
#' @return \item{A_est}{(matrix, n*n) The ensemble projection matrix.}
#' 
#' \item{u_hat}{(vector of length K) A vector of weights of the kernels in the
#' library.}
#' @author Wenying Deng
#' @seealso mode: \code{\link{tuning}}
#' @references Jeremiah Zhe Liu and Brent Coull. Robust Hypothesis Test for
#' Nonlinear Effect with Gaussian Processes. October 2017.
#' 
#' Xiang Zhan, Anna Plantinga, Ni Zhao, and Michael C. Wu. A fast small-sample
#' kernel independence test for microbiome community-level association
#' analysis. December 2017.
#' 
#' Arnak S. Dalalyan and Alexandre B. Tsybakov. Aggregation by Exponential
#' Weighting and Sharp Oracle Inequalities. In Learning Theory, Lecture Notes
#' in Computer Science, pages 97– 111. Springer, Berlin, Heidelberg, June 2007.
#' 
#' @export ensemble
ensemble <-
  function(strategy, beta_exp, error_mat, A_hat) {
    
    strategy <- match.arg(strategy, c("avg", "exp", "stack"))
    func_name <- paste0("ensemble_", strategy)
    
    do.call(func_name, list(beta_exp = beta_exp,
                            error_mat = error_mat, 
                            A_hat = A_hat))
  }





#' Estimating Ensemble Kernel Matrices Using Stack
#' 
#' Give the ensemble projection matrix and weights of the kernels in the
#' library using stacking.
#' 
#' \bold{Empirical Risk Minimization (Stacking)}
#' 
#' After obtaining the estimated errors \eqn{\{\hat{\epsilon}_d\}_{d=1}^D}, we
#' estimate the ensemble weights \eqn{u=\{u_d\}_{d=1}^D} such that it minimizes
#' the overall error \deqn{\hat{u}={argmin}_{u \in \Delta}\parallel
#' \sum_{d=1}^Du_d\hat{\epsilon}_d\parallel^2 \quad where\; \Delta=\{u | u \geq
#' 0, \parallel u \parallel_1=1\}} Then produce the final ensemble prediction:
#' \deqn{\hat{h}=\sum_{d=1}^D \hat{u}_d h_d=\sum_{d=1}^D \hat{u}_d
#' A_{d,\hat{\lambda}_d}y=\hat{A}y} where \eqn{\hat{A}=\sum_{d=1}^D \hat{u}_d
#' A_{d,\hat{\lambda}_d}} is the ensemble matrix.
#' 
#' @param beta_exp (numeric/character) A numeric value specifying the parameter
#' when strategy = "exp" \code{\link{ensemble_exp}}.
#' @param error_mat (matrix, n*K) A n\*K matrix indicating errors.
#' @param A_hat (list of length K) A list of projection matrices to kernel space 
#' for each kernel in the kernel library.
#' @return \item{A_est}{(matrix, n*n) The ensemble projection matrix.}
#' 
#' \item{u_hat}{(vector of length K) A vector of weights of the kernels in the
#' library.}
#' @author Wenying Deng
#' @seealso mode: \code{\link{tuning}}
#' @references Jeremiah Zhe Liu and Brent Coull. Robust Hypothesis Test for
#' Nonlinear Effect with Gaussian Processes. October 2017.
#' 
#' Xiang Zhan, Anna Plantinga, Ni Zhao, and Michael C. Wu. A fast small-sample
#' kernel inde- pendence test for microbiome community-level association
#' analysis. December 2017.
#' 
#' Arnak S. Dalalyan and Alexandre B. Tsybakov. Aggregation by Exponential
#' Weighting and Sharp Oracle Inequalities. In Learning Theory, Lecture Notes
#' in Computer Science, pages 97– 111. Springer, Berlin, Heidelberg, June 2007.
ensemble_stack <- 
  function(beta_exp, error_mat, A_hat) {
    
    n <- nrow(error_mat)
    kern_size <- ncol(error_mat)
    A <- error_mat
    B <- rep(0, n)
    E <- rep(1, kern_size)
    F <- 1
    G <- diag(kern_size)
    H <- rep(0, kern_size)
    u_hat <- lsei(A, B, E = E, F = F, G = G, H = H)$X
    A_est <- u_hat[1] * A_hat[[1]]
    if (kern_size != 1) {
      for (d in 2:kern_size) {
        A_est <- A_est + u_hat[d] * A_hat[[d]]
      }
    }
    
    list(A_est = A_est, u_hat = u_hat)
  }




#' Estimating Ensemble Kernel Matrices Using AVG
#' 
#' Give the ensemble projection matrix and weights of the kernels in the
#' library using simple averaging.
#' 
#' \bold{Simple Averaging}
#' 
#' Motivated by existing literature in omnibus kernel, we propose another way
#' to obtain the ensemble matrix by simply choosing unsupervised weights
#' \eqn{u_d=1/D} for \eqn{d=1,2,...D}.
#' 
#' @param beta_exp (numeric/character) A numeric value specifying the parameter
#' when strategy = "exp" \code{\link{ensemble_exp}}.
#' @param error_mat (matrix, n*K) A n\*K matrix indicating errors.
#' @param A_hat (list of length K) A list of projection matrices to kernel space 
#' for each kernel in the kernel library.
#' @return \item{A_est}{(matrix, n*n) The ensemble projection matrix.}
#' 
#' \item{u_hat}{(vector of length K) A vector of weights of the kernels in the
#' library.}
#' @author Wenying Deng
#' @seealso mode: \code{\link{tuning}}
#' @references Jeremiah Zhe Liu and Brent Coull. Robust Hypothesis Test for
#' Nonlinear Effect with Gaussian Processes. October 2017.
#' 
#' Xiang Zhan, Anna Plantinga, Ni Zhao, and Michael C. Wu. A fast small-sample
#' kernel inde- pendence test for microbiome community-level association
#' analysis. December 2017.
#' 
#' Arnak S. Dalalyan and Alexandre B. Tsybakov. Aggregation by Exponential
#' Weighting and Sharp Oracle Inequalities. In Learning Theory, Lecture Notes
#' in Computer Science, pages 97– 111. Springer, Berlin, Heidelberg, June 2007.
ensemble_avg <- 
  function(beta_exp, error_mat, A_hat) {
    
    n <- nrow(error_mat)
    kern_size <- ncol(error_mat)
    u_hat <- rep(1 / kern_size, kern_size)
    A_est <- (1 / kern_size) * A_hat[[1]]
    if (kern_size != 1) {
      for (d in 2:kern_size) {
        A_est <- A_est + (1 / kern_size) * A_hat[[d]]
      }
    }
    
    list(A_est = A_est, u_hat = u_hat)
  }





#' Estimating Ensemble Kernel Matrices Using EXP
#' 
#' Give the ensemble projection matrix and weights of the kernels in the
#' library using exponential weighting.
#' 
#' \bold{Exponential Weighting}
#' 
#' Additionally, another scholar gives a new strategy to calculate weights
#' based on the estimated errors \eqn{\{\hat{\epsilon}_d\}_{d=1}^D}.
#' \deqn{u_d(\beta)=\frac{exp(-\parallel \hat{\epsilon}_d
#' \parallel_2^2/\beta)}{\sum_{d=1}^Dexp(-\parallel \hat{\epsilon}_d
#' \parallel_2^2/\beta)}}
#' 
#' \bold{beta_exp}
#' 
#' The value of beta_exp can be "min"=\eqn{min\{RSS\}_{d=1}^D/10},
#' "med"=\eqn{median\{RSS\}_{d=1}^D}, "max"=\eqn{max\{RSS\}_{d=1}^D*2} and any
#' other positive numeric number, where \eqn{\{RSS\} _{d=1}^D} are the set of
#' residual sum of squares of \eqn{D} base kernels.
#' 
#' @param beta_exp (numeric/character) A numeric value specifying the parameter
#' when strategy = "exp". See Details.
#' @param error_mat (matrix, n*K) A n\*K matrix indicating errors.
#' @param A_hat (list of length K) A list of projection matrices to kernel space 
#' for each kernel in the kernel library.
#' @return \item{A_est}{(matrix, n*n) The ensemble projection matrix.}
#' 
#' \item{u_hat}{(vector of length K) A vector of weights of the kernels in the
#' library.}
#' @author Wenying Deng
#' @seealso mode: \code{\link{tuning}}
#' @references Jeremiah Zhe Liu and Brent Coull. Robust Hypothesis Test for
#' Nonlinear Effect with Gaussian Processes. October 2017.
#' 
#' Xiang Zhan, Anna Plantinga, Ni Zhao, and Michael C. Wu. A fast small-sample
#' kernel inde- pendence test for microbiome community-level association
#' analysis. December 2017.
#' 
#' Arnak S. Dalalyan and Alexandre B. Tsybakov. Aggregation by Exponential
#' Weighting and Sharp Oracle Inequalities. In Learning Theory, Lecture Notes
#' in Computer Science, pages 97– 111. Springer, Berlin, Heidelberg, June 2007.
ensemble_exp <- 
  function(beta_exp, error_mat, A_hat) {
    
    n <- nrow(error_mat)
    kern_size <- ncol(error_mat)
    A <- error_mat
    if (beta_exp == "med") {
      beta_exp <- median(apply(A, 2, function(x) sum(x ^ 2)))
    } else if (beta_exp == "min") {
      beta_exp <- min(apply(A, 2, function(x) sum(x ^ 2))) / 10
    } else if (beta_exp == "max") {
      beta_exp <- max(apply(A, 2, function(x) sum(x ^ 2))) * 2
    }
    beta <- as.numeric(beta_exp)
    u_hat <- apply(A, 2, function(x) {
      exp(sum(-x ^ 2 / beta))
    })
    u_hat <- u_hat / sum(u_hat)
    A_est <- u_hat[1] * A_hat[[1]]
    if (kern_size != 1) {
      for (d in 2:kern_size) {
        A_est <- A_est + u_hat[d] * A_hat[[d]]
      }
    }
    
    list(A_est = A_est, u_hat = u_hat)
  }
