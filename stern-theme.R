# ============================================================================
# stern-theme.R
# ----------------------------------------------------------------------------
# A ggplot2 theme + color scales for Emily Stern's civic-data visual language.
#
# Usage:
#   source("stern-theme.R")
#   stern_setup_fonts()                   # call once at start of script/Rmd
#
#   ggplot(data, aes(x, y, color = group)) +
#     geom_line() +
#     scale_color_stern_cat() +
#     labs(title = "Headline", caption = "Source: Agency, Year") +
#     theme_stern()
#
# Functions:
#   theme_stern()                         ggplot2 theme
#   stern_setup_fonts()                   register Google fonts via showtext
#   scale_color_stern_cat()               categorical color
#   scale_fill_stern_cat()                categorical fill
#   scale_color_stern_seq()               sequential olive (continuous)
#   scale_fill_stern_seq()                sequential olive (continuous)
#   scale_color_stern_seq_d()             sequential olive (5 discrete bins)
#   scale_fill_stern_seq_d()              sequential olive (5 discrete bins)
#   scale_color_stern_div()               diverging olive↔navy (continuous)
#   scale_fill_stern_div()                diverging olive↔navy (continuous)
#
# Color tokens are exposed as named vectors:
#   stern_palette                         (named vector, all categorical colors)
#   stern_seq                             (5-step olive sequential)
#   stern_div                             (7-step olive↔navy diverging)
# ============================================================================

# ---------- COLOR TOKENS ----------------------------------------------------

# Backgrounds & neutrals
stern_bg_primary   <- "#FBF8F1"  # brighter cream — page background
stern_bg_secondary <- "#F2EDDF"  # panels, sidebars
stern_bg_surface   <- "#FFFFFF"  # plot panel background only

stern_text_primary <- "#2B2A1F"  # headlines, key labels
stern_text_body    <- "#4A4632"  # body copy, axis labels
stern_text_muted   <- "#6E6A55"  # captions, sources, axis titles

stern_border       <- "#C9C0A4"  # standard borders, axis lines
stern_border_soft  <- "#E5DEC2"  # soft borders, gridlines

# Categorical palette (in use order)
stern_palette <- c(
  olive   = "#5A6B3A",
  navy    = "#2A3A5C",
  mustard = "#C99B2A",
  rust    = "#B5623C",
  walnut  = "#6E5938",
  sage    = "#8A9572"
)

# Sequential olive (low → high)
stern_seq <- c("#EFEDD9", "#C9CDA3", "#9BA66E", "#6B8045", "#3F4D26")

# Diverging olive ↔ navy
stern_div <- c("#3F4D26", "#6B8045", "#9BA66E", "#D9D6BA",
               "#A8B5CC", "#4F6285", "#1E2D44")

# ---------- FONT SETUP ------------------------------------------------------

#' Register fonts used by theme_stern().
#'
#' Call this once at the start of any script or .Rmd that uses the theme.
#' Requires the `showtext` and `sysfonts` packages.
#'
#' @param dpi Numeric. Resolution for showtext rendering. Default 96.
stern_setup_fonts <- function(dpi = 96) {
  if (!requireNamespace("showtext", quietly = TRUE)) {
    stop("Package 'showtext' is required. Install with install.packages('showtext').")
  }
  if (!requireNamespace("sysfonts", quietly = TRUE)) {
    stop("Package 'sysfonts' is required. Install with install.packages('sysfonts').")
  }

  sysfonts::font_add_google("Source Serif 4", "stern_serif")
  sysfonts::font_add_google("Source Sans 3",  "stern_sans")

  showtext::showtext_auto()
  showtext::showtext_opts(dpi = dpi)

  invisible(TRUE)
}

# ---------- THEME -----------------------------------------------------------

#' Stern theme for ggplot2.
#'
#' Editorial civic-data styling: cream background, white plot panel, soft
#' tan gridlines, Source Serif 4 headlines, Source Sans 3 labels and axes.
#'
#' @param base_size Numeric. Base font size in points. Default 11.
#' @param panel_bg Character. Plot panel background. Default white.
#'   Pass `stern_bg_primary` for "no panel" charts (rare — most charts want
#'   the white panel for contrast against the cream page).
#'
#' @return A ggplot2 theme object.
theme_stern <- function(base_size = 11, panel_bg = stern_bg_surface) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required.")
  }

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

    # Gridlines — soft, only major, only horizontal by default
    panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(
      color = stern_border_soft, linewidth = 0.3
    ),
    panel.grid.minor   = ggplot2::element_blank(),

    # Title / subtitle / caption
    plot.title = ggplot2::element_text(
      family = "stern_serif",
      size   = base_size * 1.35,
      face   = "bold",
      color  = stern_text_primary,
      hjust  = 0,
      margin = ggplot2::margin(b = 4)
    ),
    plot.subtitle = ggplot2::element_text(
      family = "stern_serif",
      size   = base_size * 0.95,
      color  = stern_text_body,
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
      size   = base_size * 0.78,
      color  = stern_text_muted,
      margin = ggplot2::margin(t = 8)
    ),
    axis.title.y = ggplot2::element_text(
      family = "stern_sans",
      size   = base_size * 0.78,
      color  = stern_text_muted,
      angle  = 90,
      margin = ggplot2::margin(r = 8)
    ),
    axis.text = ggplot2::element_text(
      family = "stern_sans",
      size   = base_size * 0.78,
      color  = stern_text_body
    ),
    axis.ticks   = ggplot2::element_line(color = stern_border, linewidth = 0.3),
    axis.line    = ggplot2::element_blank(),

    # Legend
    legend.background = ggplot2::element_rect(
      fill = stern_bg_primary, color = NA
    ),
    legend.key = ggplot2::element_rect(
      fill = stern_bg_primary, color = NA
    ),
    legend.title = ggplot2::element_text(
      family = "stern_sans",
      size   = base_size * 0.78,
      color  = stern_text_muted,
      face   = "plain"
    ),
    legend.text = ggplot2::element_text(
      family = "stern_sans",
      size   = base_size * 0.78,
      color  = stern_text_body
    ),
    legend.position = "top",
    legend.justification = "left",
    legend.margin   = ggplot2::margin(b = 6),

    # Facet strips
    strip.background = ggplot2::element_rect(
      fill = stern_bg_secondary, color = stern_border
    ),
    strip.text = ggplot2::element_text(
      family = "stern_sans",
      size   = base_size * 0.78,
      color  = stern_text_primary,
      face   = "bold",
      margin = ggplot2::margin(t = 4, b = 4)
    ),

    # Plot margins
    plot.margin = ggplot2::margin(16, 16, 14, 16),

    complete = TRUE
  )
}

# ---------- SCALE FUNCTIONS -------------------------------------------------

# CATEGORICAL ----------------------------------------------------------------

#' Stern categorical color scale (in use order: olive, navy, mustard, rust,
#' walnut, sage). Use `scale_color_stern_cat()` for color, `scale_fill_stern_cat()`
#' for fill.
#'
#' @param ... Passed to the underlying ggplot2 scale.
#' @param order Optional integer vector to reorder the palette (e.g. `c(2,1,3)`
#'   to put navy first).
scale_color_stern_cat <- function(..., order = NULL) {
  vals <- unname(stern_palette)
  if (!is.null(order)) vals <- vals[order]
  ggplot2::scale_color_manual(values = vals, ...)
}

scale_fill_stern_cat <- function(..., order = NULL) {
  vals <- unname(stern_palette)
  if (!is.null(order)) vals <- vals[order]
  ggplot2::scale_fill_manual(values = vals, ...)
}

# SEQUENTIAL -----------------------------------------------------------------

#' Stern sequential color scale (single-hue olive, low → high).
#' Continuous version interpolates between five anchor colors.
scale_color_stern_seq <- function(..., reverse = FALSE) {
  cols <- if (reverse) rev(stern_seq) else stern_seq
  ggplot2::scale_color_gradientn(colors = cols, ...)
}

scale_fill_stern_seq <- function(..., reverse = FALSE) {
  cols <- if (reverse) rev(stern_seq) else stern_seq
  ggplot2::scale_fill_gradientn(colors = cols, ...)
}

#' Discrete (binned) version of the sequential scale, for use with categorical
#' data that has natural ordering (e.g. quintiles, Likert).
scale_color_stern_seq_d <- function(..., reverse = FALSE) {
  cols <- if (reverse) rev(stern_seq) else stern_seq
  ggplot2::scale_color_manual(values = cols, ...)
}

scale_fill_stern_seq_d <- function(..., reverse = FALSE) {
  cols <- if (reverse) rev(stern_seq) else stern_seq
  ggplot2::scale_fill_manual(values = cols, ...)
}

# DIVERGING ------------------------------------------------------------------

#' Stern diverging color scale (olive ↔ navy with cream midpoint).
#'
#' @param midpoint Numeric. The data value mapped to the neutral midpoint.
#'   Default 0. Pass the chart's true midpoint (e.g. citywide average).
#' @param limits Numeric vector of length 2. Force symmetric limits if needed.
#' @param reverse Logical. If TRUE, navy becomes negative and olive positive.
#'   Use when "up" is bad for the metric being shown (e.g. crime, eviction).
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

# ---------- CONVENIENCE: THEME VARIANTS -------------------------------------

#' Variant: theme with vertical gridlines instead of horizontal.
#' Use for horizontal bar charts and dot plots.
theme_stern_vertical <- function(base_size = 11) {
  theme_stern(base_size = base_size) %+replace%
  ggplot2::theme(
    panel.grid.major.y = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_line(
      color = stern_border_soft, linewidth = 0.3
    )
  )
}

#' Variant: theme with no gridlines and no panel border.
#' Use for maps, choropleths, spatial visualizations.
theme_stern_map <- function(base_size = 11) {
  theme_stern(base_size = base_size) %+replace%
  ggplot2::theme(
    panel.grid       = ggplot2::element_blank(),
    panel.border     = ggplot2::element_blank(),
    panel.background = ggplot2::element_rect(fill = stern_bg_primary, color = NA),
    axis.text        = ggplot2::element_blank(),
    axis.title       = ggplot2::element_blank(),
    axis.ticks       = ggplot2::element_blank()
  )
}

# ---------- INFO ------------------------------------------------------------

# Print palette info when the file is sourced
if (interactive()) {
  message("Stern theme loaded.")
  message("  - Call stern_setup_fonts() once before plotting.")
  message("  - Categorical: scale_color_stern_cat() / scale_fill_stern_cat()")
  message("  - Sequential:  scale_color_stern_seq() / scale_fill_stern_seq()")
  message("  - Diverging:   scale_color_stern_div() / scale_fill_stern_div()")
  message("  - Theme:       theme_stern() + theme_stern_vertical() / theme_stern_map()")
}
