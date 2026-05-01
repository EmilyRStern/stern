# ============================================================================
# ggplot2 theme functions.
# ============================================================================

#' Stern theme for ggplot2.
#'
#' Editorial civic-data styling: cream background, white plot panel, soft
#' tan gridlines, Source Serif 4 headlines, Source Sans 3 labels and axes.
#'
#' Call [stern_setup_fonts()] once before plotting so the typefaces are
#' available.
#'
#' @param base_size Numeric. Base font size in points. Default 12.
#' @param panel_bg Character. Plot panel background. Default white
#'   ([stern_bg_surface]). Pass [stern_bg_primary] for a "no panel" look
#'   that merges into the page -- rare; most charts want the white panel
#'   for contrast against the cream page.
#' @param legend Character. Legend position. One of `"bottom"` (default),
#'   `"top"`, `"left"`, `"right"`, or `"none"`. Also accepts a numeric
#'   `c(x, y)` for an inset legend.
#'
#' @return A `ggplot2::theme` object.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' stern_setup_fonts()
#'
#' ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#'   geom_point(size = 3) +
#'   scale_color_stern_cat() +
#'   labs(
#'     title    = "Heavier cars use more fuel",
#'     subtitle = "Weight vs. mpg in the mtcars dataset",
#'     caption  = "Source: 1974 Motor Trend"
#'   ) +
#'   theme_stern()
#'
#' # Move the legend (or hide it) per chart
#' last_plot() + theme_stern(legend = "right")
#' last_plot() + theme_stern(legend = "none")
#' }
#'
#' @importFrom ggplot2 %+replace% theme theme_minimal
#' @importFrom ggplot2 element_rect element_line element_blank element_text
#' @importFrom ggplot2 margin
#' @export
theme_stern <- function(base_size = 14,
                        panel_bg = stern_bg_surface,
                        legend = "bottom") {

  ggplot2::theme_minimal(base_size = base_size) %+replace%
  ggplot2::theme(

    # Plot frame
    plot.background = ggplot2::element_rect(
      fill = stern_bg_primary, color = NA
    ),
    panel.background = ggplot2::element_rect(
      fill = panel_bg, color = NA
    ),
    panel.border = ggplot2::element_rect(
      fill = NA, color = stern_border, linewidth = 0.4
    ),

    # Gridlines -- soft, only major, only horizontal by default
    panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(
      color = stern_border_soft, linewidth = 0.3
    ),
    panel.grid.minor   = ggplot2::element_blank(),

    # Title / subtitle / caption
    plot.title = ggplot2::element_text(
      family = "stern_sans",
      face   = "bold", 
      size   = base_size * 1.35,
      color  = stern_text_primary,
      hjust  = 0,
      margin = ggplot2::margin(b = 4)
    ),
    plot.subtitle = ggplot2::element_text(
      family = "stern_serif",
      size   = base_size * 0.95,
      color  = stern_text_muted,
      hjust  = 0,
      margin = ggplot2::margin(b = 14)
    ),
    plot.caption = ggplot2::element_text(
      family = "stern_sans",
      size   = base_size * 0.72,
      color  = stern_text_muted,
      hjust  = 0,
      margin = ggplot2::margin(t = 10)
    ),
    plot.caption.position = "plot",
    plot.title.position   = "plot",

    # Axes
    axis.title.x = ggplot2::element_text(
      family = "stern_sans",
      size   = base_size * 0.85,
      color  = stern_text_muted,
      margin = ggplot2::margin(t = 8)
    ),
    axis.title.y = ggplot2::element_text(
      family = "stern_sans",
      size   = base_size * 0.85,
      color  = stern_text_muted,
      angle  = 90,
      margin = ggplot2::margin(r = 8)
    ),
    axis.text = ggplot2::element_text(
      family = "stern_sans",
      size   = base_size * 0.9,
      color  = stern_text_body
    ),
    axis.ticks = ggplot2::element_line(
      color = stern_border, linewidth = 0.3
    ),
    axis.line  = ggplot2::element_blank(),

    # Legend
    legend.background = ggplot2::element_rect(
      fill = stern_bg_primary, color = NA
    ),
    legend.key = ggplot2::element_rect(
      fill = stern_bg_primary, color = NA
    ),
    legend.title = ggplot2::element_text(
      family = "stern_serif",
      size   = base_size * 0.85,
      color  = stern_text_body,
      face   = "plain"
    ),
    legend.text = ggplot2::element_text(
      family = "stern_serif",
      size   = base_size * 0.85,
      color  = stern_text_body
    ),
    legend.position = legend,
    legend.justification = if (identical(legend, "bottom")) "center" else "left",
    legend.margin   = ggplot2::margin(t = 6, b = 6),

    # Facet strips
    strip.background = ggplot2::element_rect(
      fill = stern_bg_secondary, color = stern_border
    ),
    strip.text = ggplot2::element_text(
      family = "stern_sans",
      size   = base_size * 0.85,
      color  = stern_text_primary,
      face   = "bold",
      margin = ggplot2::margin(t = 4, b = 4)
    ),

    # Plot margins
    plot.margin = ggplot2::margin(16, 16, 14, 16),

    complete = TRUE
  )
}

#' Stern theme variant -- vertical gridlines.
#'
#' Same as [theme_stern()] but with vertical gridlines instead of
#' horizontal. Use for horizontal bar charts and dot plots where the
#' value axis runs left-to-right.
#'
#' @param base_size Numeric. Base font size in points. Default 12.
#' @param legend Character. Legend position. See [theme_stern()].
#'
#' @return A `ggplot2::theme` object.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' stern_setup_fonts()
#'
#' ggplot(mtcars, aes(mpg, reorder(rownames(mtcars), mpg))) +
#'   geom_col(fill = stern_palette[["olive"]]) +
#'   theme_stern_vertical()
#' }
#'
#' @export
theme_stern_vertical <- function(base_size = 14, legend = "bottom") {
  theme_stern(base_size = base_size, legend = legend) %+replace%
  ggplot2::theme(
    panel.grid.major.y = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_line(
      color = stern_border_soft, linewidth = 0.3
    )
  )
}

#' Stern theme variant -- for maps and spatial visualizations.
#'
#' Same as [theme_stern()] but with no gridlines, no panel border, and no
#' axis ticks or labels. Use for choropleths and other spatial plots.
#'
#' @param base_size Numeric. Base font size in points. Default 12.
#' @param legend Character. Legend position. See [theme_stern()].
#'
#' @return A `ggplot2::theme` object.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(sf)
#' stern_setup_fonts()
#'
#' ggplot(my_sf_data) +
#'   geom_sf(aes(fill = value), color = stern_border) +
#'   scale_fill_stern_seq() +
#'   theme_stern_map()
#' }
#'
#' @export
theme_stern_map <- function(base_size = 14, legend = "bottom") {
  theme_stern(base_size = base_size, legend = legend) %+replace%
  ggplot2::theme(
    panel.grid       = ggplot2::element_blank(),
    panel.border     = ggplot2::element_blank(),
    panel.background = ggplot2::element_rect(
      fill = stern_bg_primary, color = NA
    ),
    axis.text  = ggplot2::element_blank(),
    axis.title = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank()
  )
}
