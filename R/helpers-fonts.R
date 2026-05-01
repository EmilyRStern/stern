# ============================================================================
# Font registration.
# ============================================================================

#' Register fonts used by `theme_stern()`.
#'
#' Registers Source Serif 4 (used for headlines and body copy) and Source
#' Sans 3 (used for axis labels, legends, captions, and UI) via Google
#' Fonts, and turns on `showtext` rendering for the current session.
#'
#' Call once at the start of any script or .Rmd that uses the theme.
#' Requires the optional packages `showtext` and `sysfonts`.
#'
#' @param dpi Numeric. Resolution for `showtext` rendering. Default 96.
#'   Bump to 150-300 for high-resolution exports via `ggsave()`.
#' @param bold_weight Numeric. The weight to use for `face = "bold"` text
#'   in the registered families. Default 600 ("semibold") for the
#'   editorial half-bold look that pairs with the Shiny CSS. Use 700 for
#'   true bold, 500 for medium.
#' @param regular_weight Numeric. The weight for `face = "plain"` (body)
#'   text. Default 400.
#'
#' @return Invisibly `TRUE` on success.
#'
#' @section Font weights:
#' Both Source Serif 4 and Source Sans 3 are variable fonts, so any
#' weight from 200 (extralight) to 900 (black) is available. Common
#' picks:
#' \tabular{ll}{
#'   400 \tab Regular -- body text \cr
#'   500 \tab Medium -- subtle emphasis \cr
#'   600 \tab Semibold -- editorial "half bold," default for `face = "bold"` \cr
#'   700 \tab Bold -- traditional heavy weight \cr
#' }
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(stern)
#'
#' stern_setup_fonts()                       # semibold for face = "bold"
#' stern_setup_fonts(bold_weight = 700)      # full bold
#' stern_setup_fonts(bold_weight = 500)      # even lighter "bold"
#'
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   labs(title = "Fuel economy", caption = "Source: mtcars") +
#'   theme_stern()
#' }
#'
#' @export
stern_setup_fonts <- function(dpi = 96,
                              bold_weight = 600,
                              regular_weight = 400) {

  if (!requireNamespace("showtext", quietly = TRUE)) {
    stop("Package 'showtext' is required. ",
         "Install with install.packages('showtext').",
         call. = FALSE)
  }
  if (!requireNamespace("sysfonts", quietly = TRUE)) {
    stop("Package 'sysfonts' is required. ",
         "Install with install.packages('sysfonts').",
         call. = FALSE)
  }

  sysfonts::font_add_google(
    name       = "Source Serif 4",
    family     = "stern_serif",
    regular.wt = regular_weight,
    bold.wt    = bold_weight
  )
  sysfonts::font_add_google(
    name       = "Source Sans 3",
    family     = "stern_sans",
    regular.wt = regular_weight,
    bold.wt    = bold_weight
  )

  showtext::showtext_auto()
  showtext::showtext_opts(dpi = dpi)

  invisible(TRUE)
}
