# ============================================================================
# Text-on-fill legibility helpers.
#
# When labels sit on top of a sequential or diverging fill, dark text gets
# lost on the dark end of the scale. These two helpers compute a
# per-cell text color that flips to cream on dark fills.
# ============================================================================

#' Pick text color based on a sequential fill value.
#'
#' Returns dark text for light fills and cream text for dark fills, with
#' a threshold at the midpoint of `values` by default. Use inside
#' `geom_text()` to label heatmap or tile cells without losing labels on
#' the dark end of the ramp.
#'
#' Pair with `ggplot2::scale_color_identity()` so ggplot uses the colors
#' as-is.
#'
#' @param values Numeric vector -- the fill values underneath the labels.
#' @param threshold Numeric. The cutoff above which text flips to cream.
#'   Defaults to the midpoint of `values`. Override when your scale is
#'   asymmetric (e.g. fill values 0-100 but most data is 60-95).
#'
#' @return A character vector of hex colors, same length as `values`.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' ggplot(df, aes(x, y, fill = score)) +
#'   geom_tile() +
#'   geom_text(
#'     aes(label = score, color = stern_text_on_seq(score)),
#'     family = "stern_sans"
#'   ) +
#'   scale_fill_stern_seq() +
#'   scale_color_identity()
#' }
#'
#' @export
stern_text_on_seq <- function(values, threshold = NULL) {
  if (is.null(threshold)) {
    threshold <- mean(range(values, na.rm = TRUE))
  }
  ifelse(values > threshold, stern_bg_primary, stern_text_body)
}

#' Pick text color based on a diverging fill value.
#'
#' Both ends of the diverging scale are dark, so text needs to flip to
#' cream on both sides while staying dark in the middle.
#'
#' @param values Numeric vector -- the fill values underneath the labels.
#' @param midpoint Numeric. The neutral midpoint. Default 0.
#' @param flip_distance Numeric. How far from the midpoint before text
#'   flips to cream. Defaults to half the maximum absolute deviation,
#'   which puts the flip at roughly the boundary between the cream-neutral
#'   band and the first colored band.
#'
#' @return A character vector of hex colors.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' ggplot(df, aes(x, y, fill = pct_change)) +
#'   geom_tile() +
#'   geom_text(
#'     aes(label = pct_change, color = stern_text_on_div(pct_change)),
#'     family = "stern_sans"
#'   ) +
#'   scale_fill_stern_div(midpoint = 0) +
#'   scale_color_identity()
#' }
#'
#' @export
stern_text_on_div <- function(values, midpoint = 0, flip_distance = NULL) {
  if (is.null(flip_distance)) {
    flip_distance <- max(abs(values - midpoint), na.rm = TRUE) / 2
  }
  ifelse(abs(values - midpoint) > flip_distance,
         stern_bg_primary,
         stern_text_body)
}
