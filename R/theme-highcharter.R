# ============================================================================
# Highcharter theming for the Stern visual language.
#
# Depends on the optional package `highcharter`. The package is listed in
# Suggests, so each function checks for it at call time and surfaces a
# clear install message if missing.
# ============================================================================

#' Stern Highcharts theme.
#'
#' Returns a Highcharts theme object (created via `highcharter::hc_theme()`)
#' that matches the static [theme_stern()] for ggplot2. Pass to a
#' Highchart object with `highcharter::hc_add_theme()`.
#'
#' Requires the optional package `highcharter`.
#'
#' @return A Highcharts theme object.
#'
#' @section Implementation note:
#' The `fontFamily` values intentionally use unquoted family names.
#' Highcharter's htmlwidget binding inspects each `style.fontFamily`
#' string and auto-inserts a Google Fonts `<link>` tag plus a jQuery
#' selector that quotes the URL with single quotes. If the family name
#' itself contains single quotes (e.g. `"'Source Sans 3'"`), the
#' generated selector ends up with nested unescaped quotes and Sizzle
#' throws "Syntax error, unrecognized expression", which silently kills
#' the chart render. CSS happily accepts multi-word family names without
#' quotes, so we drop them.
#'
#' @examples
#' \dontrun{
#' library(highcharter)
#'
#' highchart() |>
#'   hc_chart(type = "column") |>
#'   hc_xAxis(categories = month.abb) |>
#'   hc_add_series(name = "Series A", data = c(48, 52, 55, 50, 58)) |>
#'   hc_add_theme(hc_theme_stern())
#' }
#'
#' @export
hc_theme_stern <- function() {

  stern_require("highcharter")

  highcharter::hc_theme(
    colors = unname(stern_palette),

    chart = list(
      backgroundColor = stern_bg_primary,
      style = list(
        fontFamily = "Source Sans 3, sans-serif",
        color      = stern_text_body
      ),
      plotBackgroundColor = stern_bg_surface,
      plotBorderColor    = stern_border,
      plotBorderWidth    = 0.5
    ),

    title = list(
      style = list(
        fontFamily = "Source Serif 4, Georgia, serif",
        fontSize   = "16px",
        fontWeight = "600",
        color      = stern_text_primary
      ),
      align = "left",
      margin = 4
    ),
    subtitle = list(
      style = list(
        fontFamily = "Source Serif 4, Georgia, serif",
        fontSize   = "13px",
        color      = stern_text_body
      ),
      align = "left"
    ),

    xAxis = list(
      lineColor       = stern_border,
      tickColor       = stern_border,
      gridLineColor   = stern_border_soft,
      gridLineWidth   = 0,
      labels = list(
        style = list(
          fontFamily = "Source Sans 3, sans-serif",
          fontSize   = "11px",
          color      = stern_text_body
        )
      ),
      title = list(
        style = list(
          fontFamily = "Source Sans 3, sans-serif",
          fontSize   = "11px",
          color      = stern_text_muted
        )
      )
    ),

    yAxis = list(
      lineColor       = stern_border,
      tickColor       = stern_border,
      gridLineColor   = stern_border_soft,
      gridLineWidth   = 0.5,
      labels = list(
        style = list(
          fontFamily = "Source Sans 3, sans-serif",
          fontSize   = "11px",
          color      = stern_text_body
        )
      ),
      title = list(
        style = list(
          fontFamily = "Source Sans 3, sans-serif",
          fontSize   = "11px",
          color      = stern_text_muted
        )
      )
    ),

    legend = list(
      align          = "left",
      verticalAlign  = "top",
      itemStyle = list(
        fontFamily = "Source Sans 3, sans-serif",
        fontSize   = "11px",
        color      = stern_text_body,
        fontWeight = "normal"
      ),
      itemHoverStyle = list(color = stern_text_primary)
    ),

    tooltip = list(
      backgroundColor = stern_text_primary,
      borderColor     = stern_text_primary,
      borderRadius    = 0,
      style = list(
        fontFamily = "Source Sans 3, sans-serif",
        fontSize   = "12px",
        color      = stern_bg_primary
      )
    ),

    credits = list(
      style = list(
        fontFamily = "Source Sans 3, sans-serif",
        fontSize   = "10px",
        color      = stern_text_muted
      )
    ),

    plotOptions = list(
      series = list(
        marker = list(lineColor = stern_bg_primary)
      ),
      column = list(
        borderWidth = 0,
        groupPadding = 0.1
      ),
      bar = list(
        borderWidth = 0,
        groupPadding = 0.1
      ),
      line = list(
        lineWidth = 2.2,
        marker = list(enabled = TRUE, radius = 3)
      ),
      area = list(
        fillOpacity = 0.7
      )
    )
  )
}

# ---------- Palette helpers -----------------------------------------------

#' Apply Stern categorical palette to a Highchart object.
#'
#' Sets the `colors` option to the categorical scale in use order. Use
#' when you want explicit control independent of [hc_theme_stern()].
#'
#' Requires the optional package `highcharter`.
#'
#' @param hc A Highchart object.
#'
#' @return The Highchart object, with palette applied.
#'
#' @export
hc_stern_cat <- function(hc) {
  stern_require("highcharter")
  highcharter::hc_colors(hc, unname(stern_palette))
}

#' Apply Stern sequential palette to a Highchart object.
#'
#' For ordered series -- pass to charts where category order is meaningful
#' (e.g. quintiles, time bins).
#'
#' Requires the optional package `highcharter`.
#'
#' @param hc A Highchart object.
#' @param reverse Logical. If `TRUE`, dark olive maps to first series and
#'   light to last. Default `FALSE`.
#'
#' @return The Highchart object, with palette applied.
#'
#' @export
hc_stern_seq <- function(hc, reverse = FALSE) {
  stern_require("highcharter")
  cols <- if (reverse) rev(stern_seq) else stern_seq
  highcharter::hc_colors(hc, cols)
}

#' Apply Stern diverging palette to a Highchart object.
#'
#' For series where order spans a meaningful midpoint.
#'
#' Requires the optional package `highcharter`.
#'
#' @param hc A Highchart object.
#' @param reverse Logical. If `TRUE`, navy maps to first series and olive
#'   to last. Default `FALSE`.
#'
#' @return The Highchart object, with palette applied.
#'
#' @export
hc_stern_div <- function(hc, reverse = FALSE) {
  stern_require("highcharter")
  cols <- if (reverse) rev(stern_div) else stern_div
  highcharter::hc_colors(hc, cols)
}

# ---------- Color stops for heatmaps & choropleths ------------------------

#' Sequential color stops for `hc_colorAxis()`.
#'
#' Use when you have a continuous fill (heatmap, treemap, choropleth) and
#' need to pass `stops` to `highcharter::hc_colorAxis()`.
#'
#' @return A list of `(position, color)` pairs.
#'
#' @examples
#' \dontrun{
#' library(highcharter)
#'
#' hchart(my_data, "heatmap", hcaes(x = x, y = y, value = z)) |>
#'   hc_colorAxis(stops = hc_stern_seq_stops()) |>
#'   hc_add_theme(hc_theme_stern())
#' }
#'
#' @export
hc_stern_seq_stops <- function() {
  positions <- seq(0, 1, length.out = length(stern_seq))
  Map(list, positions, stern_seq)
}

#' Diverging color stops for `hc_colorAxis()`.
#'
#' Use when you have a continuous fill that spans a meaningful midpoint
#' (e.g. percent change, deviation from average).
#'
#' @return A list of `(position, color)` pairs.
#'
#' @export
hc_stern_div_stops <- function() {
  positions <- seq(0, 1, length.out = length(stern_div))
  Map(list, positions, stern_div)
}
