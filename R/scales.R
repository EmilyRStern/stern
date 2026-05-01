# ============================================================================
# ggplot2 color and fill scales for the Stern visual language.
#
# Three families: categorical, sequential, diverging. Each comes in
# `scale_color_*` and `scale_fill_*` flavors. Sequential additionally has
# discrete-binned variants (`*_seq_d()`) for ordered categorical data.
# ============================================================================

# ---------- Categorical -----------------------------------------------------

#' Stern categorical color scale.
#'
#' Maps a discrete aesthetic to the categorical palette in priority order
#' (olive, navy, mustard, rust, walnut, sage). See [stern_palette].
#'
#' @param ... Passed to the underlying `ggplot2::scale_color_manual()`.
#' @param order Optional integer vector to reorder the palette. For
#'   example, `order = c(2, 1, 3)` to put navy first.
#'
#' @return A ggplot2 scale.
#'
#' @examples
#' \dontrun{
#' ggplot(diamonds, aes(carat, price, color = cut)) +
#'   geom_point(alpha = 0.4) +
#'   scale_color_stern_cat() +
#'   theme_stern()
#' }
#'
#' @importFrom ggplot2 scale_color_manual
#' @export
scale_color_stern_cat <- function(..., order = NULL) {
  vals <- unname(stern_palette)
  if (!is.null(order)) vals <- vals[order]
  ggplot2::scale_color_manual(values = vals, ...)
}

#' @rdname scale_color_stern_cat
#' @importFrom ggplot2 scale_fill_manual
#' @export
scale_fill_stern_cat <- function(..., order = NULL) {
  vals <- unname(stern_palette)
  if (!is.null(order)) vals <- vals[order]
  ggplot2::scale_fill_manual(values = vals, ...)
}

# ---------- Sequential (continuous) -----------------------------------------

#' Stern sequential color scale (continuous).
#'
#' Single-hue olive ramp interpolated through five anchor colors
#' (see [stern_seq]).
#'
#' @param ... Passed to the underlying ggplot2 scale.
#' @param reverse Logical. If `TRUE`, dark olive maps to low values and
#'   light to high. Default `FALSE`.
#'
#' @return A ggplot2 scale.
#'
#' @examples
#' \dontrun{
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_raster() +
#'   scale_fill_stern_seq() +
#'   theme_stern()
#' }
#'
#' @importFrom ggplot2 scale_color_gradientn
#' @export
scale_color_stern_seq <- function(..., reverse = FALSE) {
  cols <- if (reverse) rev(stern_seq) else stern_seq
  ggplot2::scale_color_gradientn(colors = cols, ...)
}

#' @rdname scale_color_stern_seq
#' @importFrom ggplot2 scale_fill_gradientn
#' @export
scale_fill_stern_seq <- function(..., reverse = FALSE) {
  cols <- if (reverse) rev(stern_seq) else stern_seq
  ggplot2::scale_fill_gradientn(colors = cols, ...)
}

# ---------- Sequential (discrete-binned) ------------------------------------

#' Stern sequential color scale (discrete).
#'
#' Discrete-binned variant of the sequential ramp, for use with
#' categorical data that has natural ordering (e.g. quintiles, Likert).
#' Maps to the same five colors as the continuous version, but treats
#' them as fixed categories.
#'
#' @param ... Passed to the underlying `ggplot2::scale_color_manual()`.
#' @param reverse Logical. If `TRUE`, reverse the order. Default `FALSE`.
#'
#' @return A ggplot2 scale.
#'
#' @importFrom ggplot2 scale_color_manual
#' @export
scale_color_stern_seq_d <- function(..., reverse = FALSE) {
  cols <- if (reverse) rev(stern_seq) else stern_seq
  ggplot2::scale_color_manual(values = cols, ...)
}

#' @rdname scale_color_stern_seq_d
#' @importFrom ggplot2 scale_fill_manual
#' @export
scale_fill_stern_seq_d <- function(..., reverse = FALSE) {
  cols <- if (reverse) rev(stern_seq) else stern_seq
  ggplot2::scale_fill_manual(values = cols, ...)
}

# ---------- Diverging -------------------------------------------------------

#' Stern diverging color scale.
#'
#' Olive <-> navy ramp with a warm cream midpoint (see [stern_div]). Pass
#' `midpoint =` to set where neutral falls in your data.
#'
#' Pass `reverse = TRUE` when "up" means "bad" for the metric (e.g.
#' crime, eviction) -- the convention is that olive should always read as
#' positive in the metric being shown.
#'
#' @param ... Passed to the underlying ggplot2 scale.
#' @param midpoint Numeric. The data value mapped to the neutral midpoint.
#'   Default 0. Pass the chart's true midpoint (e.g. citywide average).
#' @param limits Numeric vector of length 2. Force symmetric limits if
#'   needed. Default `NULL` (auto-computed).
#' @param reverse Logical. If `TRUE`, navy maps to positive and olive to
#'   negative. Default `FALSE`.
#'
#' @return A ggplot2 scale.
#'
#' @examples
#' \dontrun{
#' df <- data.frame(
#'   x = letters[1:10],
#'   pct_change = c(-12, -8, -3, -1, 0, 2, 4, 6, 9, 14)
#' )
#' ggplot(df, aes(x, pct_change, fill = pct_change)) +
#'   geom_col() +
#'   scale_fill_stern_div(midpoint = 0) +
#'   theme_stern()
#' }
#'
#' @importFrom ggplot2 scale_color_gradientn
#' @importFrom scales rescale
#' @export
scale_color_stern_div <- function(..., midpoint = 0, limits = NULL,
                                  reverse = FALSE) {
  cols <- if (reverse) rev(stern_div) else stern_div
  ggplot2::scale_color_gradientn(
    colors = cols,
    values = scales::rescale(c(-3, -2, -1, 0, 1, 2, 3)),
    rescaler = function(x, to = c(0, 1), from = NULL) {
      m <- midpoint
      x_max <- max(abs(x - m), na.rm = TRUE)
      scales::rescale(x, to = to, from = c(m - x_max, m + x_max))
    },
    limits = limits,
    ...
  )
}

#' @rdname scale_color_stern_div
#' @importFrom ggplot2 scale_fill_gradientn
#' @importFrom scales rescale
#' @export
scale_fill_stern_div <- function(..., midpoint = 0, limits = NULL,
                                 reverse = FALSE) {
  cols <- if (reverse) rev(stern_div) else stern_div
  ggplot2::scale_fill_gradientn(
    colors = cols,
    values = scales::rescale(c(-3, -2, -1, 0, 1, 2, 3)),
    rescaler = function(x, to = c(0, 1), from = NULL) {
      m <- midpoint
      x_max <- max(abs(x - m), na.rm = TRUE)
      scales::rescale(x, to = to, from = c(m - x_max, m + x_max))
    },
    limits = limits,
    ...
  )
}
