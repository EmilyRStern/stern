# ============================================================================
# Shiny / bslib theming for the Stern visual language.
#
# The Shiny module depends on optional packages -- bslib, htmltools, shiny.
# These are listed in Suggests, so each function checks for them at call
# time and surfaces a clear install message if missing.
# ============================================================================

# ---------- Internal: Suggests guards ---------------------------------------

stern_require <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(
      "Package '", pkg, "' is required for this function. ",
      "Install with install.packages('", pkg, "').",
      call. = FALSE
    )
  }
}

# ---------- bs_theme --------------------------------------------------------

#' Stern bslib theme.
#'
#' Returns a `bs_theme` object configured with the Stern color tokens and
#' typography, plus custom CSS rules for cards, sidebars, value boxes,
#' form inputs, navbars, tabs, and DT tables.
#'
#' Requires the optional package `bslib`.
#'
#' @param base_size CSS base font size. Default `"16px"`.
#' @param font_scale Numeric. Bootstrap font scale multiplier. Default 1.0.
#'
#' @return A `bs_theme` object suitable for passing to
#'   `bslib::page_sidebar()`, `bslib::page_navbar()`, etc.
#'
#' @examples
#' \dontrun{
#' library(shiny)
#' library(bslib)
#'
#' ui <- page_sidebar(
#'   theme = stern_bs_theme(),
#'   title = "Dashboard",
#'   sidebar = sidebar(...),
#'   ...
#' )
#' }
#'
#' @export
stern_bs_theme <- function(base_size = "16px", font_scale = 1.0) {

  stern_require("bslib")

  bslib::bs_theme(
    version      = 5,
    bg           = stern_bg_primary,
    fg           = stern_text_primary,
    primary      = stern_palette[["olive"]],
    secondary    = stern_palette[["navy"]],
    success      = stern_palette[["olive"]],
    info         = stern_palette[["navy"]],
    warning      = stern_palette[["mustard"]],
    danger       = stern_palette[["rust"]],
    base_font    = bslib::font_google("Source Serif 4"),
    heading_font = bslib::font_google("Source Serif 4"),
    code_font    = bslib::font_google("Source Code Pro"),
    font_scale   = font_scale,
    "body-bg"            = stern_bg_primary,
    "body-color"         = stern_text_body,
    "border-color"       = stern_border,
    "border-radius"      = "0",
    "border-radius-sm"   = "0",
    "border-radius-lg"   = "0",
    "card-border-radius" = "0",
    "card-cap-bg"        = stern_bg_secondary,
    bootswatch           = NULL
  ) |>
    bslib::bs_add_rules(stern_custom_css(base_size = base_size))
}

# ---------- Custom CSS ------------------------------------------------------

#' Custom CSS rules layered on top of the bs_theme.
#'
#' Returns a single string of CSS. Used internally by [stern_bs_theme()],
#' but exposed in case you want to inject the rules into a non-bslib
#' context (e.g. an `htmltools::tagList()` with `tags$style()`).
#'
#' @param base_size CSS base font size. Default `"16px"`.
#'
#' @return A character scalar of CSS.
#'
#' @export
stern_custom_css <- function(base_size = "16px") {

  bg     <- stern_bg_primary
  bg2    <- stern_bg_secondary
  surf   <- stern_bg_surface
  txt    <- stern_text_primary
  body   <- stern_text_body
  muted  <- stern_text_muted
  brd    <- stern_border
  brd_s  <- stern_border_soft
  olive  <- stern_palette[["olive"]]
  navy   <- stern_palette[["navy"]]
  must   <- stern_palette[["mustard"]]
  rust   <- stern_palette[["rust"]]

  paste0("
/* ============================================================
   STERN THEME -- custom Shiny / bslib rules
   ============================================================ */

/* ---- Body & page ---- */
body {
  background-color: ", bg, ";
  color: ", body, ";
  font-family: 'Source Serif 4', Georgia, serif;
  font-size: ", base_size, ";
}

/* ---- Headings ---- */
h1, h2, h3, h4, h5, h6,
.h1, .h2, .h3, .h4, .h5, .h6 {
  font-family: 'Source Serif 4', Georgia, serif;
  color: ", txt, ";
  font-weight: 600;
}

/* ---- Cards ---- */
.card {
  background-color: ", bg, ";
  border: 1px solid ", brd, ";
  border-radius: 0;
  box-shadow: none;
}
.card-header {
  background-color: ", bg2, ";
  border-bottom: 1px solid ", brd, ";
  border-radius: 0;
  font-family: 'Source Sans 3', sans-serif;
  font-size: 0.78rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: ", muted, ";
  font-weight: 600;
  padding: 10px 14px;
}
.card-body {
  padding: 16px 18px;
}
.card-footer {
  background-color: ", bg2, ";
  border-top: 1px solid ", brd, ";
  border-radius: 0;
  font-family: 'Source Sans 3', sans-serif;
  font-size: 0.72rem;
  color: ", muted, ";
  padding: 8px 14px;
}

/* ---- Sidebar ---- */
.bslib-sidebar-layout > .sidebar,
.sidebar {
  background-color: ", bg2, " !important;
  border-right: 1px solid ", brd, " !important;
}
.sidebar-content,
.bslib-sidebar-layout > .sidebar > .sidebar-content {
  padding: 16px 14px;
}

/* ---- Navbar ---- */
.navbar {
  background-color: ", bg, " !important;
  border-bottom: 1px solid ", brd, ";
  padding: 12px 18px;
}
.navbar-brand {
  font-family: 'Source Serif 4', serif !important;
  font-weight: 600 !important;
  color: ", muted, " !important;
  font-size: 1.05rem !important;
}
.navbar-nav .nav-link {
  font-family: 'Source Sans 3', sans-serif !important;
  font-size: 0.82rem !important;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: ", muted, " !important;
  font-weight: 600 !important;
}
.navbar-nav .nav-link.active,
.navbar-nav .nav-link:hover {
  color: ", txt, " !important;
}

/* ---- Tabs ---- */
.nav-tabs {
  border-bottom: 1px solid ", brd, ";
}
.nav-tabs .nav-link {
  font-family: 'Source Sans 3', sans-serif;
  font-size: 0.78rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: ", muted, ";
  border: none;
  border-bottom: 2px solid transparent;
  background-color: transparent;
  border-radius: 0;
  padding: 8px 14px;
  font-weight: 600;
}
.nav-tabs .nav-link:hover {
  color: ", body, ";
  background-color: transparent;
  border-bottom-color: ", brd, ";
}
.nav-tabs .nav-link.active {
  color: ", txt, ";
  background-color: transparent;
  border-bottom-color: ", olive, ";
}

/* ---- Pills (e.g. nav_panel buttons) ---- */
.nav-pills .nav-link {
  font-family: 'Source Sans 3', sans-serif;
  font-size: 0.82rem;
  color: ", body, ";
  border-radius: 0;
  background-color: transparent;
  border: 1px solid transparent;
}
.nav-pills .nav-link.active {
  background-color: ", olive, ";
  color: ", bg, " !important;
}

/* ---- Form inputs ---- */
label, .form-label, .control-label {
  font-family: 'Source Sans 3', sans-serif;
  font-size: 0.72rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: ", muted, ";
  font-weight: 600;
  margin-bottom: 4px;
}
.form-control,
.form-select,
.selectize-input,
input[type='text'],
input[type='number'],
input[type='date'] {
  background-color: ", surf, ";
  border: 1px solid ", brd, ";
  border-radius: 0 !important;
  color: ", txt, ";
  font-family: 'Source Serif 4', serif;
  font-size: 0.92rem;
}
.form-control:focus,
.form-select:focus,
.selectize-input.focus,
.selectize-input.input-active {
  border-color: ", olive, ";
  box-shadow: 0 0 0 2px ", brd_s, ";
  outline: none;
}
.selectize-dropdown {
  border: 1px solid ", brd, " !important;
  border-radius: 0 !important;
  font-family: 'Source Serif 4', serif;
}
.selectize-dropdown .active {
  background-color: ", bg2, ";
  color: ", txt, ";
}

/* ---- Sliders (shiny sliderInput uses jQuery UI ionRangeSlider) ---- */
.irs--shiny .irs-bar,
.irs--shiny .irs-from,
.irs--shiny .irs-to,
.irs--shiny .irs-single {
  background-color: ", olive, " !important;
  border-top-color: ", olive, " !important;
  border-bottom-color: ", olive, " !important;
}
.irs--shiny .irs-handle {
  background-color: ", olive, " !important;
  border: 1px solid ", olive, " !important;
  border-radius: 0 !important;
  box-shadow: none !important;
}
.irs--shiny .irs-line {
  background: ", brd_s, " !important;
}
.irs--shiny .irs-grid-text,
.irs--shiny .irs-min,
.irs--shiny .irs-max {
  color: ", muted, " !important;
  font-family: 'Source Sans 3', sans-serif !important;
  font-size: 0.7rem !important;
}

/* ---- Buttons ---- */
.btn {
  font-family: 'Source Sans 3', sans-serif;
  font-size: 0.82rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  border-radius: 0 !important;
  font-weight: 600;
  padding: 8px 16px;
}
.btn-primary {
  background-color: ", olive, ";
  border-color: ", olive, ";
  color: ", bg, ";
}
.btn-primary:hover,
.btn-primary:focus {
  background-color: ", txt, ";
  border-color: ", txt, ";
}
.btn-secondary {
  background-color: ", bg, ";
  border-color: ", brd, ";
  color: ", body, ";
}
.btn-secondary:hover {
  background-color: ", bg2, ";
  border-color: ", olive, ";
  color: ", txt, ";
}

/* ---- Value boxes ----
   Override bslib's default fill behavior: use cream backgrounds with a
   colored left border instead of white-text-on-color. That matches the
   stat-callout pattern from the design system. */
.bslib-value-box {
  background-color: ", bg, " !important;
  border: 1px solid ", brd, ";
  border-left-width: 3px;
  border-radius: 0 !important;
  color: ", txt, " !important;
}
.bslib-value-box .value-box-title {
  font-family: 'Source Sans 3', sans-serif !important;
  font-size: 0.7rem !important;
  text-transform: uppercase !important;
  letter-spacing: 0.1em !important;
  color: ", muted, " !important;
  font-weight: 600 !important;
}
.bslib-value-box .value-box-value {
  font-family: 'Source Serif 4', serif !important;
  font-size: 1.9rem !important;
  font-weight: 600 !important;
  color: ", txt, " !important;
  font-feature-settings: 'tnum' 1, 'lnum' 1 !important;
  line-height: 1 !important;
  margin-top: 2px;
}
.bslib-value-box .value-box-showcase {
  background-color: transparent !important;
  color: ", muted, " !important;
}

/* ---- DT (DataTables) ---- */
table.dataTable {
  font-family: 'Source Serif 4', serif !important;
  font-size: 0.88rem !important;
  border-collapse: collapse !important;
  background-color: ", surf, " !important;
}
table.dataTable thead th,
table.dataTable thead td {
  background-color: ", bg2, " !important;
  border-bottom: 1px solid ", brd, " !important;
  font-family: 'Source Sans 3', sans-serif !important;
  font-size: 0.7rem !important;
  text-transform: uppercase !important;
  letter-spacing: 0.06em !important;
  color: ", muted, " !important;
  font-weight: 600 !important;
  padding: 8px 12px !important;
}
table.dataTable tbody tr:hover {
  background-color: ", bg2, " !important;
}
table.dataTable tbody td {
  border-bottom: 1px solid ", brd_s, " !important;
  padding: 8px 12px !important;
  color: ", body, ";
}
.dataTables_wrapper .dataTables_filter input,
.dataTables_wrapper .dataTables_length select {
  border: 1px solid ", brd, " !important;
  border-radius: 0 !important;
  background-color: ", surf, " !important;
  font-family: 'Source Serif 4', serif !important;
  padding: 4px 8px !important;
}
.dataTables_wrapper .dataTables_info,
.dataTables_wrapper .dataTables_paginate .paginate_button {
  font-family: 'Source Sans 3', sans-serif !important;
  font-size: 0.78rem !important;
  color: ", muted, " !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button.current,
.dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
  background: ", olive, " !important;
  color: ", bg, " !important;
  border: 1px solid ", olive, " !important;
}

/* ---- Tooltips & popovers ---- */
.tooltip-inner,
.popover {
  background-color: ", txt, " !important;
  color: ", bg, " !important;
  border-radius: 0 !important;
  font-family: 'Source Sans 3', sans-serif !important;
  font-size: 0.78rem !important;
}

/* ---- Misc ---- */
hr { border-top: 1px solid ", brd, "; }
code, pre {
  background-color: ", bg2, ";
  border: 1px solid ", brd, ";
  border-radius: 0;
  color: ", body, ";
  font-family: 'Source Code Pro', monospace;
}
")
}

# ---------- App shell -------------------------------------------------------

#' Stern app shell -- sensible defaults for `page_sidebar()`.
#'
#' A thin wrapper around `bslib::page_sidebar()` that applies the Stern
#' theme by default. Pass any args you'd normally pass to `page_sidebar()`.
#'
#' Requires the optional package `bslib`.
#'
#' @param ... Passed to `bslib::page_sidebar()`.
#' @param theme A `bs_theme` object. Defaults to [stern_bs_theme()].
#'
#' @return A Shiny UI object.
#'
#' @export
stern_app_shell <- function(..., theme = stern_bs_theme()) {
  stern_require("bslib")
  bslib::page_sidebar(theme = theme, ...)
}

# ---------- Stat callout component ------------------------------------------

#' Stat callout -- bordered statistic card from the design system.
#'
#' A standalone alternative to `bslib::value_box()` that renders the
#' design system's stat callout pattern: cream background, colored
#' left border, label / value / context stacked.
#'
#' Requires the optional package `htmltools`.
#'
#' @param label Short uppercase label (e.g. `"Total enrolled"`).
#' @param value The big number (e.g. `"2,408"` or `"+20%"`).
#' @param context Optional supporting text below the value.
#' @param accent Color for the left border. Pass a hex string or one
#'   of the categorical color names: `"olive"`, `"navy"`, `"mustard"`,
#'   `"rust"`, `"walnut"`, `"sage"`. Default `"olive"`.
#'
#' @return An `htmltools::tag` object.
#'
#' @examples
#' \dontrun{
#' stern_stat_callout(
#'   label   = "Total enrolled",
#'   value   = "2,408",
#'   context = "Up 12% from last cohort",
#'   accent  = "mustard"
#' )
#' }
#'
#' @export
stern_stat_callout <- function(label, value, context = NULL,
                               accent = "olive") {

  stern_require("htmltools")

  accent_color <- if (accent %in% names(stern_palette)) {
    stern_palette[[accent]]
  } else {
    accent
  }

  htmltools::div(
    style = paste0(
      "border-left: 3px solid ", accent_color, ";",
      "border-top: 1px solid ", stern_border, ";",
      "border-right: 1px solid ", stern_border, ";",
      "border-bottom: 1px solid ", stern_border, ";",
      "padding: 14px 16px;",
      "background-color: ", stern_bg_primary, ";"
    ),
    htmltools::div(
      style = paste0(
        "font-family: 'Source Sans 3', sans-serif;",
        "font-size: 0.7rem;",
        "text-transform: uppercase;",
        "letter-spacing: 0.1em;",
        "color: ", stern_text_muted, ";",
        "font-weight: 600;",
        "margin-bottom: 4px;"
      ),
      label
    ),
    htmltools::div(
      style = paste0(
        "font-family: 'Source Serif 4', serif;",
        "font-size: 1.9rem;",
        "font-weight: 600;",
        "color: ", stern_text_primary, ";",
        "font-feature-settings: 'tnum' 1, 'lnum' 1;",
        "line-height: 1;"
      ),
      value
    ),
    if (!is.null(context)) {
      htmltools::div(
        style = paste0(
          "font-family: 'Source Serif 4', serif;",
          "font-size: 0.78rem;",
          "color: ", stern_text_body, ";",
          "margin-top: 4px;"
        ),
        context
      )
    }
  )
}

# ---------- value_box() accent helper ---------------------------------------

#' Apply a Stern accent color to a `bslib::value_box()`.
#'
#' Sets the left border color of a value_box to one of the palette colors.
#' Works around bslib's default behavior of using `theme = "primary"` etc.,
#' which would create filled-color backgrounds. Pass the result of this
#' to a value_box's `style` argument.
#'
#' @param accent One of `"olive"`, `"navy"`, `"mustard"`, `"rust"`,
#'   `"walnut"`, `"sage"`, or a hex string.
#'
#' @return A character string of inline CSS for the `style` argument of
#'   `value_box()`.
#'
#' @examples
#' \dontrun{
#' bslib::value_box(
#'   title = "Total",
#'   value = "2,408",
#'   style = stern_value_box_palette("mustard")
#' )
#' }
#'
#' @export
stern_value_box_palette <- function(accent = "olive") {
  accent_color <- if (accent %in% names(stern_palette)) {
    stern_palette[[accent]]
  } else {
    accent
  }
  paste0("border-left-color: ", accent_color, " !important;",
         "border-left-width: 3px !important;")
}
