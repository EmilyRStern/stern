# ============================================================================
# Color tokens for the Stern visual language.
#
# All tokens are exported so collaborators can pull them directly when
# building custom annotations, callouts, or non-ggplot visualizations.
# ============================================================================

# ---------- Backgrounds & neutrals ------------------------------------------

#' Page background (brighter cream).
#'
#' Used as the plot background and the Shiny page background. Pairs with
#' [stern_bg_surface] (white) for the plot panel.
#'
#' @format A character scalar -- `"#FBF8F1"`.
#' @export
stern_bg_primary <- "#FBF8F1"

#' Secondary background (warmer cream).
#'
#' Used for sidebars, card headers/footers, and facet strip backgrounds --
#' anywhere you want a subtle separation from the page background.
#'
#' @format A character scalar -- `"#F2EDDF"`.
#' @export
stern_bg_secondary <- "#F2EDDF"

#' Plot panel background (white).
#'
#' Used as the panel background inside [theme_stern()] for contrast against
#' the cream page. Most charts want this; pass [stern_bg_primary] to
#' [theme_stern()] instead for a no-panel "merged into page" look.
#'
#' @format A character scalar -- `"#FFFFFF"`.
#' @export
stern_bg_surface <- "#FFFFFF"

# ---------- Text ------------------------------------------------------------

#' Primary text color (near-black olive).
#'
#' Headlines, key labels, value-box numerals.
#'
#' @format A character scalar -- `"#2B2A1F"`.
#' @export
stern_text_primary <- "#2B2A1F"

#' Body text color.
#'
#' Body copy, axis labels, tick labels.
#'
#' @format A character scalar -- `"#4A4632"`.
#' @export
stern_text_body <- "#4A4632"

#' Muted text color.
#'
#' Captions, source notes, axis titles, supporting metadata.
#'
#' @format A character scalar -- `"#6E6A55"`.
#' @export
stern_text_muted <- "#6E6A55"

# ---------- Borders ---------------------------------------------------------

#' Standard border color.
#'
#' Panel borders, axis lines, card and table borders.
#'
#' @format A character scalar -- `"#C9C0A4"`.
#' @export
stern_border <- "#C9C0A4"

#' Soft border color.
#'
#' Gridlines and de-emphasized rules.
#'
#' @format A character scalar -- `"#E5DEC2"`.
#' @export
stern_border_soft <- "#E5DEC2"

# ---------- Categorical palette ---------------------------------------------

#' Stern categorical palette.
#'
#' Six earthy hues in priority/use order. Position 1 is your default first
#' category. Position 3 (mustard) is also the canonical "highlight the
#' focal point" color when used outside the categorical scale.
#'
#' @format A named character vector with 6 elements:
#' \describe{
#'   \item{olive}{`"#5A6B3A"`}
#'   \item{navy}{`"#2A3A5C"`}
#'   \item{mustard}{`"#C99B2A"`}
#'   \item{rust}{`"#B5623C"`}
#'   \item{walnut}{`"#6E5938"`}
#'   \item{sage}{`"#8A9572"`}
#' }
#' @export
stern_palette <- c(
  olive   = "#5A6B3A",
  navy    = "#2A3A5C",
  mustard = "#C99B2A",
  rust    = "#B5623C",
  walnut  = "#6E5938",
  sage    = "#8A9572"
)

# ---------- Sequential ramp -------------------------------------------------

#' Sequential olive color ramp.
#'
#' Five-step single-hue ramp from light to dark olive. Used by
#' [scale_color_stern_seq()] / [scale_fill_stern_seq()] for continuous data,
#' and by `*_seq_d()` for discrete-binned data (e.g. quintiles, Likert
#' scales).
#'
#' @format A character vector of 5 hex colors, low to high.
#' @export
stern_seq <- c("#EFEDD9", "#C9CDA3", "#9BA66E", "#6B8045", "#3F4D26")

# ---------- Diverging ramp --------------------------------------------------

#' Diverging olive <-> navy color ramp.
#'
#' Seven-step diverging ramp with a warm cream midpoint. Used by
#' [scale_color_stern_div()] / [scale_fill_stern_div()].
#'
#' Pass `reverse = TRUE` to the scale function when "up" means "bad" for a
#' metric (e.g. crime, eviction) -- the convention is that olive should
#' read as positive in the metric being shown.
#'
#' @format A character vector of 7 hex colors. Position 1 is darkest olive,
#'   position 4 is the cream midpoint, position 7 is darkest navy.
#' @export
stern_div <- c("#3F4D26", "#6B8045", "#9BA66E", "#D9D6BA",
               "#A8B5CC", "#4F6285", "#1E2D44")
