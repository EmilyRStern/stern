# ============================================================================
# Render Test Charts
# ============================================================================
#'
#' Requires the optional packages `dplyr`, `tidyr`, `tibble`, and `sf`,
#' plus `showtext` and `sysfonts` for the fonts.
#'
#' @return Invisibly `NULL`.
#'
#' @examples
#' \dontrun{
#' library(stern)
#' stern_test()
#' }
#'
#' @export
stern_test <- function() {

  needed <- c("dplyr", "tidyr", "tibble", "sf", "scales",
              "showtext", "sysfonts")
  missing <- needed[!vapply(needed, requireNamespace,
                            logical(1), quietly = TRUE)]
  if (length(missing)) {
    stop(
      "stern_test() needs these optional packages: ",
      paste(shQuote(missing), collapse = ", "), ".\n",
      "Install with: install.packages(c(",
      paste(shQuote(missing), collapse = ", "), "))",
      call. = FALSE
    )
  }

  script <- system.file("examples", "test-stern-theme.R", package = "stern")
  if (!nzchar(script)) {
    stop(
      "test-stern-theme.R not found in installed package. ",
      "Try reinstalling with devtools::install().",
      call. = FALSE
    )
  }

  source(script, local = TRUE, echo = FALSE)
  invisible(NULL)
}


#' Launch the Shiny test app.
#'
#' Runs a small Shiny app that exercises every component styled by the
#' `stern` Shiny module: the `stern_app_shell()` layout, sidebar form
#' inputs, cards, `stern_stat_callout()` value boxes, tabs, a `DT` data
#' table, and `highcharter` charts wired up through `hc_theme_stern()`.
#' Use it after install to confirm the Shiny styling renders correctly.
#'
#' Requires the optional packages `shiny`, `bslib`, `htmltools`, `DT`,
#' `highcharter`, `dplyr`, and `tibble`, plus `showtext` and `sysfonts`
#' for the fonts.
#'
#' @return The return value of [shiny::runApp()] (invisibly). The app
#'   blocks the R session until the browser tab is closed or the user
#'   interrupts.
#'
#' @examples
#' \dontrun{
#' library(stern)
#' stern_test_shiny()
#' }
#'
#' @export
stern_test_shiny <- function() {

  needed <- c("shiny", "bslib", "htmltools", "DT", "highcharter",
              "dplyr", "tibble", "showtext", "sysfonts")
  missing <- needed[!vapply(needed, requireNamespace,
                            logical(1), quietly = TRUE)]
  if (length(missing)) {
    stop(
      "stern_test_shiny() needs these optional packages: ",
      paste(shQuote(missing), collapse = ", "), ".\n",
      "Install with: install.packages(c(",
      paste(shQuote(missing), collapse = ", "), "))",
      call. = FALSE
    )
  }

  script <- system.file("examples", "test-stern-shiny.R", package = "stern")
  if (!nzchar(script)) {
    stop(
      "test-stern-shiny.R not found in installed package. ",
      "Try reinstalling with devtools::install().",
      call. = FALSE
    )
  }

  shiny::runApp(script)
}
