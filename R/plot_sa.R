utils::globalVariables(c(".", "sigma", "err"))
#' Plot the trend between the log fold-change and sigma, coloring significant hits
#'
#' @description
#' `r lifecycle::badge('experimental')`
#'
#' `plot_sa` returns a `ggplot` with a graphical representation between the log
#' fold-change and sigma.
#'
#' @param results Output generated by
#'   \code{baldur::\link[baldur:infer_data_and_decision_model]{infer_data_and_decision_model}}
#'
#' @param alpha Significance cut-off; used to draw a line indicating where
#'   significance starts
#' @param lfc LFC cut-off; used to draw lines for `abs(lfc)`, if `NULL` no lines
#'   are drawn
#'
#' @return `plot_sa` returns a `ggplot` object
#' @export
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 geom_hline
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 theme_bw
#' @importFrom ggplot2 facet_wrap
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 scale_y_continuous
#'
#' @examples
#' # Setup model matrix
#' design <- model.matrix(~ 0 + factor(rep(1:2, each = 3)))
#' colnames(design) <- paste0("ng", c(50, 100))
#'
#' yeast_norm <- yeast %>%
#' # Remove missing data
#'   tidyr::drop_na() %>%
#'   # Normalize data
#'   psrn('identifier') %>%
#'   # Add mean-variance trends
#'   calculate_mean_sd_trends(design)
#' # Fit the gamma regression
#' gam <- fit_gamma_regression(yeast_norm, sd ~ mean)
#' # Estimate each data point's uncertainty
#' unc <- estimate_uncertainty(gam, yeast_norm, "identifier", design)
#' yeast_norm <- gam %>%
#'    # Add hyper-priors for sigma
#'    estimate_gamma_hyperparameters(yeast_norm)
#' # Setup contrast matrix
#' contrast <- matrix(c(-1, 1), 2)
#' \donttest{
#' results <- yeast_norm %>%
#'   head() %>% # Just run a few for the example
#'   infer_data_and_decision_model(
#'     'identifier',
#'     design,
#'     contrast,
#'     unc,
#'     clusters = 1 # I highly recommend increasing the number of parallel workers/clusters
#'                  # this will greatly reduce the speed of running baldur
#'   )
#'   # Plot with alpha = 0.05
#'   plot_sa(results, alpha = 0.05)
#'   # Plot with alpha = 0.01 and show LFC = 1
#'   plot_sa(results, alpha = 0.01, 1)
#' }
plot_sa <- function(results, alpha = .05, lfc = NULL) {
  mx <- max(abs(results$lfc))
  rng <- c(-mx, mx)
  p <- results %>%
    ggplot2::ggplot(ggplot2::aes(sigma, lfc, color = err < alpha))
  if(!is.null(lfc)){
    p <- p +
      ggplot2::geom_hline(yintercept = -abs(lfc), color = 'green', linetype = 'dashed') +
      ggplot2::geom_hline(yintercept = abs(lfc), color = 'green', linetype = 'dashed')
  }
  p +
    ggplot2::geom_point(size = 1/2) +
    ggplot2::theme_bw() +
    ggplot2::facet_wrap(comparison~.) +
    ggplot2::scale_y_continuous(limits = rng) +
    ggplot2::labs(
      x = expression(sigma),
      y = expression(log[2](Fold~Change)),
      color = 'Significant?'
    )
}
