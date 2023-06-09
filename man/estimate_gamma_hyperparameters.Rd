% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimate_priors.R
\name{estimate_gamma_hyperparameters}
\alias{estimate_gamma_hyperparameters}
\alias{estimate_gamma_hyperparameters.glm}
\alias{estimate_gamma_hyperparameters.lgmr}
\alias{estimate_beta}
\alias{estimate_beta.glm}
\alias{estimate_beta.lgmr}
\title{Estimate Gamma hyperparameters for sigma}
\usage{
estimate_gamma_hyperparameters(reg, data, ...)

\method{estimate_gamma_hyperparameters}{glm}(reg, data, ...)

\method{estimate_gamma_hyperparameters}{lgmr}(reg, data, id_col, ...)

estimate_beta(reg, mean, ...)

\method{estimate_beta}{glm}(reg, mean, alpha, ...)

\method{estimate_beta}{lgmr}(reg, mean, m, s, ...)
}
\arguments{
\item{reg}{A \code{glm} Gamma regression or a \code{lgmr} object}

\item{data}{A \code{tibble} or \code{data.frame} to add gamma priors to}

\item{...}{Currently not in use}

\item{id_col}{A character for the name of the column containing the
name of the features in data (e.g., peptides, proteins, etc.)}

\item{mean}{The mean value of the peptide}

\item{alpha}{The alpha parameter of the peptide}

\item{m}{The mean of the means}

\item{s}{The sd of the means}
}
\value{
\code{estimate_gamma_hyperparameters} returns a \code{tibble} or \code{data.frame}
with the alpha,beta hyperparameters estimates as new columns.

\code{estimate_beta} returns estimates of the beta parameter(s)
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

Estimates the hyperparameters for the Bayesian data and decision
model. \code{estimate_gamma_hyperparameters} is a wrapper that adds new columns
to the data (one for alpha and one for betas). Note that for \code{lgmr}
objects, the \code{estimate_beta} function assumes that the data is ordered as
when the model was fitted. If this is not the case, theta's will be
incorrectly matched with peptides---resulting in wrong estimates of beta
parameters. On the other hand, \code{estimate_gamma_hyperparameters} will
temporarily sort the data as when fitted and the sort it back as it
was input to the function.
}
\examples{
# Setup model matrix
design <- model.matrix(~ 0 + factor(rep(1:2, each = 3)))
colnames(design) <- paste0("ng", c(50, 100))

# Normalize data
yeast_norm <- yeast \%>\%
    psrn("identifier") \%>\%
    # Get mean-variance trends
    calculate_mean_sd_trends(design)

# Fit gamma regression (could also have been a lgmr model)
gam_reg <- fit_gamma_regression(yeast_norm, sd ~ mean)

# Estimate priors
gam_reg \%>\%
    estimate_gamma_hyperparameters(yeast_norm)

# Can also explicitly estimate the beta parameters
# Note this is order sensitive.
estimate_beta(gam_reg, yeast_norm$mean, 1/summary(gam_reg)$dispersion)
}
