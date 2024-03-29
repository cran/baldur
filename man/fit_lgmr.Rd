% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit_lgmr.R
\name{fit_lgmr}
\alias{fit_lgmr}
\alias{print.lgmr}
\alias{coef.lgmr}
\title{Fit Latent Gamma Mixture Regression}
\usage{
fit_lgmr(
  data,
  id_col,
  model = lgmr_model,
  iter = 6000,
  warmup = 1500,
  chains = 5,
  cores = 1,
  return_stanfit = FALSE,
  simplify = FALSE,
  ...
)

\method{print}{lgmr}(
  x,
  simplify = x$simplify,
  pars = c("auxiliary", "coefficients"),
  digits = 3,
  ...
)

\method{coef}{lgmr}(object, simplify = FALSE, pars = c("coefficients", "auxiliary"), ...)
}
\arguments{
\item{data}{A \code{data.frame} with mean-variance trends to use in the fitting.
The columns need to have the following hard-coded names: \code{mean} and \code{sd}.}

\item{id_col}{A character for the name of the column containing the name of
the features in data (e.g., peptides, proteins, etc.). Has to be a unique
identifier for each feature.}

\item{model}{Defaults to \link{lgmr_model} (see it for details on the model), can
also be an user supplied \code{\link[=stan_model]{stan_model()}}}

\item{iter}{Total number of samples to draw}

\item{warmup}{Number of warm-up samples to draw}

\item{chains}{Number of chains to run}

\item{cores}{Number of cores to use per chain}

\item{return_stanfit}{Should the \code{stanfit} object be returned with the model?}

\item{simplify}{Should only the mean estimates of the posterior be returned?}

\item{...}{Additional arguments to \code{rstan}'s \link[rstan:stanmodel-method-sampling]{sampling}.
Does nothing for \code{print} or \code{coef} only for \code{fit_lgmr}.}

\item{x, object}{An \code{lgmr} model.}

\item{pars}{If you want to print/extract the regression coefficients, theta, auxiliary (alpha and NRMSE), or all}

\item{digits}{Number of digits to print}
}
\value{
A fitted \code{lgmr} model.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

See \link{lgmr_model} for model details.
}
\examples{
# Define design matrix
design <- model.matrix(~ 0 + factor(rep(1:2, each = 3)))
colnames(design) <- paste0("ng", c(50, 100))

\donttest{
# Normalize data, calculate M-V trend, and fit LGMR model
yeast_lgmr <- yeast \%>\%
    # Remove missing values
    tidyr::drop_na() \%>\%
    # Normalize
    psrn("identifier") \%>\%
    # Add the mean-variance trends
    calculate_mean_sd_trends(design) \%>\%
    # Fit the model
    fit_lgmr("identifier")
# Print everything except thetas
print(yeast_lgmr, pars = c("coefficients", "auxiliary"))
# Extract the mean of the model parameters posterior
yeast_lgmr_pars <- coef(yeast_lgmr, pars = 'all', simplify = TRUE)

}
}
