% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/weakly_informative.R
\name{weakly_informative}
\alias{weakly_informative}
\title{Baldur's weakly informative prior for the mean in conditions}
\value{
A \code{stanmodel} that can be used in \link{infer_data_and_decision_model}.
}
\description{
Here we will model the mean of the prior with a weakly
informative (WI) prior. We will assume that, in essence, nothing is know
about the mean. As such, for the WI prior, we use a normal prior on
\eqn{\boldsymbol{\mu}_0} centered at zero and with a very large variance.
\deqn{\boldsymbol{\mu}_0\sim\mathcal{N}(0,100)}
}
\section{Code}{
 The \code{Stan} code for this model is given by:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{weakly_informative
S4 class stanmodel 'weakly_informative' coded as follows:
data \{
  int<lower=0> N;     // number of data items
  int<lower=0> K;     // number of conditions
  int C;              // number of comparisons to perform
  matrix[N, K] x;     // design matrix
  vector[N] y;        // data
  matrix[K, C] c;     // contrast matrix
  real alpha;         // alpha prior for gamma
  real beta;          // beta prior for gamma
  vector[N] u;        // uncertainty
\}
transformed data\{
  vector[K] n_k;      // per condition measurements
  row_vector[C] n_c;  // per comparison measurements
  matrix[K, C] abs_c; // abs of C for n_c calculation
  for (i in 1:K) \{
    for (j in 1:C) \{
      abs_c[i, j] = abs(c[i, j]);
    \}
  \}
  for (i in 1:K) \{
    n_k[i] = 1/sum(x[,i]);
  \}
  n_c = n_k' * abs_c;
  n_c = sqrt(n_c);
\}
parameters \{
  vector[K] mu;           // coefficients for predictors
  real<lower=0> sigma;    // error scale
  array[C] real y_diff;   // difference in coefficients
  vector[K] eta;          // Error in mean
  vector[K] prior_mu_not; // Estimation error
\}
transformed parameters\{
  row_vector[C] mu_diff = mu' * c;        // differences in means
  vector[C] sigma_lfc = sigma * n_c';     // variance of y_diff
\}
model \{
  sigma        ~ gamma(alpha, beta);                      // variance
  eta          ~ normal(0, 1);                            // NCP auxilary variable
  prior_mu_not ~ normal(0, 10);                           // prior mean
  mu           ~ normal(prior_mu_not + sigma*eta, sigma); // mean
  y            ~ normal(x * mu, sigma*u);                 // data model
  y_diff       ~ normal(mu_diff, sigma_lfc);              // difference statistic
\} 
}\if{html}{\out{</div>}}
}

