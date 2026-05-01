# ============================================================================
# Streamlined plot saving.
# ============================================================================

# Internal: named pixel-dimension presets for stern_save().
.stern_save_presets <- list(
  small   = c(width = 1200, height =  750),
  default = c(width = 1600, height = 1000),
  wide    = c(width = 2000, height = 1000),
  square  = c(width = 1200, height = 1200),
  social  = c(width = 1200, height =  630),
  poster  = c(width = 2400, height = 1500)
)

#' Save a ggplot with sensible defaults.
#'
#' A streamlined alternative to [ggplot2::ggsave()] that handles the
#' three common gotchas:
#'
#' 1. **Pixel dimensions, not inches.** You think "1600 px wide", not
#'    "5.33 inches wide at 300 dpi".
#' 2. **`showtext` DPI is auto-synced to the export DPI.** Without this,
#'    saving at 300 dpi while `showtext` is set up at screen DPI (96)
#'    renders text at ~32% of the correct size -- the classic "why did
#'    my titles shrink" bug.
#' 3. **Background defaults to the Stern cream**, so saved plots match
#'    the on-screen theme. Override with `bg = "white"` or `bg = NA`.
#'
#' Format is detected from the filename extension (`.png`, `.pdf`,
#' `.svg`, `.jpg`).
#'
#' @param plot A ggplot object.
#' @param filename Output file path. Format inferred from extension.
#' @param size Named preset for dimensions. One of `"small"`,
#'   `"default"`, `"wide"`, `"square"`, `"social"`, `"poster"`. See the
#'   *Size presets* section. Ignored if both `width` and `height` are
#'   supplied.
#' @param width,height Explicit dimensions in pixels. Override `size`.
#' @param dpi Resolution. Default 300 (print quality). Use 144 for
#'   web-only output to halve file size with no visible loss on
#'   non-retina displays.
#' @param bg Background color. Default [stern_bg_primary]. Pass
#'   `"white"` for a white background, `NA` for transparent.
#' @param ... Additional arguments forwarded to [ggplot2::ggsave()],
#'   e.g. `device = ragg::agg_png` if you want to force a specific
#'   graphics backend.
#'
#' @return Invisibly, the filename.
#'
#' @section Size presets:
#' \tabular{lll}{
#'   **Preset**  \tab **Pixels**     \tab **Use case** \cr
#'   `small`     \tab 1200 x 750     \tab Slack messages, blog post bodies \cr
#'   `default`   \tab 1600 x 1000    \tab Reports, decks, the everyday case \cr
#'   `wide`      \tab 2000 x 1000    \tab Wide editorial layouts \cr
#'   `square`    \tab 1200 x 1200    \tab Instagram, square cards \cr
#'   `social`    \tab 1200 x 630     \tab Twitter cards, og:image \cr
#'   `poster`    \tab 2400 x 1500    \tab High-resolution print \cr
#' }
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(stern)
#'
#' stern_setup_fonts()
#'
#' p <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
#'   geom_point(size = 3) +
#'   scale_color_stern_cat() +
#'   labs(title = "Fuel economy") +
#'   theme_stern()
#'
#' # Most common case -- just save it
#' stern_save(p, "fuel-economy.png")
#'
#' # Pick a different shape via preset
#' stern_save(p, "fuel-economy-wide.png", size = "wide")
#'
#' # Or specify dimensions in pixels
#' stern_save(p, "fuel-economy-square.png", width = 1080, height = 1080)
#'
#' # PDF for vector output (dpi only affects raster fallback)
#' stern_save(p, "fuel-economy.pdf")
#'
#' # White background instead of cream
#' stern_save(p, "fuel-economy-white.png", bg = "white")
#' }
#'
#' @export
stern_save <- function(plot,
                       filename,
                       size = "default",
                       width = NULL,
                       height = NULL,
                       dpi = 300,
                       bg = NULL,
                       ...) {

  # Resolve dimensions. Explicit width/height beat the preset.
  if (is.null(width) || is.null(height)) {
    if (!size %in% names(.stern_save_presets)) {
      stop(
        "Unknown size '", size, "'. ",
        "Pick one of: ", paste(shQuote(names(.stern_save_presets)),
                               collapse = ", "),
        ", or pass width and height explicitly (in pixels).",
        call. = FALSE
      )
    }
    dims <- .stern_save_presets[[size]]
    if (is.null(width))  width  <- dims[["width"]]
    if (is.null(height)) height <- dims[["height"]]
  }

  # ggsave wants inches; convert.
  width_in  <- width  / dpi
  height_in <- height / dpi

  # Sync showtext DPI to the export DPI so text scales correctly,
  # then restore the prior DPI on exit (whether or not ggsave throws).
  if (requireNamespace("showtext", quietly = TRUE)) {
    prev <- showtext::showtext_opts()
    showtext::showtext_opts(dpi = dpi)
    on.exit(showtext::showtext_opts(dpi = prev$dpi), add = TRUE)
  }

  # Default background matches the on-screen theme.
  if (is.null(bg)) bg <- stern_bg_primary

  ggplot2::ggsave(
    filename = filename,
    plot     = plot,
    width    = width_in,
    height   = height_in,
    units    = "in",
    dpi      = dpi,
    bg       = bg,
    ...
  )

  invisible(filename)
}
