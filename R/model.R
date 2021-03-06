#' Model cycling levels as a function of explanatory variables
#'
#' @param pcycle The proportion of trips by bike, e.g. 0.1, meaning 10%
#' @param weights The weights used in the model, typically the total number of people per OD pair
#'
#' @inheritParams uptake_pct_govtarget
#' @export
#' @examples
#' # l = get_pct_lines(region = "isle-of-wight")
#' # l = get_pct_lines(region = "cambridgeshire")
#' l = wight_lines_pct
#' pcycle = l$bicycle / l$all
#' pcycle_dutch = l$dutch_slc / l$all
#' m1 = model_pcycle_pct_2020(
#'   pcycle,
#'   distance = l$rf_dist_km,
#'   gradient = l$rf_avslope_perc - 0.78,
#'   weights = l$all
#'   )
#' m2 = model_pcycle_pct_2020(
#'   pcycle_dutch, distance = l$rf_dist_km,
#'   gradient = l$rf_avslope_perc - 0.78,
#'   weights = l$all
#' )
#' m3 = model_pcycle_pct_2020(
#'   pcycle_dutch, distance = l$rf_dist_km,
#'   gradient = l$rf_avslope_perc - 0.78,
#'   weights = rep(1, nrow(l))
#' )
#' m1
#' plot(l$rf_dist_km, pcycle, cex = l$all / 100, ylim = c(0, 0.5))
#' points(l$rf_dist_km, m1$fitted.values, col = "red")
#' points(l$rf_dist_km, m2$fitted.values, col = "blue")
#' points(l$rf_dist_km, pcycle_dutch, col = "green")
#' cor(l$dutch_slc, m2$fitted.values * l$all)^2 # 95% captured
#' # identical means:
#' mean(l$dutch_slc)
#' mean(m2$fitted.values * l$all)
#' pct_coefficients_2020 = c(
#'   alpha = -4.018 + 2.550,
#'   d1 = -0.6369 -0.08036,
#'   d2 = 1.988,
#'   d3 = 0.008775,
#'   h1 = -0.2555,
#'   i1 = 0.02006,
#'   i2 = -0.1234
#' )
#' pct_coefficients_2020
#' m2$coef
#' plot(pct_coefficients_2020, m2$coeff)
#' cor(pct_coefficients_2020, m2$coeff)^2
#' cor(pct_coefficients_2020, m3$coeff)^2 # explains 95%+ variability in params
model_pcycle_pct_2020 = function(pcycle, distance, gradient, weights) {
  pcycle[pcycle == 0] = 0.001 # 1/1000 is lowest level for logit link
  stats::glm(formula = pcycle ~
        distance + sqrt(distance) + I(distance^2) + gradient + distance*gradient + sqrt(distance) * gradient,
      family = "quasibinomial", weights = weights)
}
