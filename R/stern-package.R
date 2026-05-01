#' stern: editorial design system and reporting helpers for civic-data work
#'
#' A coordinated visual language for public-interest data work, plus a
#' growing set of reporting helpers. This first release covers the visual
#' language: ggplot2 themes, color scales, Shiny components, and a
#' Highcharter theme. Future releases will add reporting modules
#' (project intros, summary panels, report scaffolding).
#'
#' # Modules
#'
#' * **ggplot2** -- [theme_stern()], [theme_stern_vertical()],
#'   [theme_stern_map()], the `scale_color_stern_*` /
#'   `scale_fill_stern_*` family, plus [stern_text_on_seq()] and
#'   [stern_text_on_div()] for text-on-fill contrast.
#' * **Shiny** -- [stern_bs_theme()], [stern_app_shell()],
#'   [stern_stat_callout()], [stern_value_box_palette()].
#' * **Highcharter** -- [hc_theme_stern()] and the `hc_stern_*` palette
#'   helpers, including pre-formatted color stops for `hc_colorAxis()`.
#' * **Saving** -- [stern_save()] wraps `ggplot2::ggsave()` with pixel
#'   dimensions, named size presets, automatic `showtext` DPI sync, and
#'   a sensible cream-background default.
#'
#' # Design principles
#'
#' Editorial first. The themes assume a research-brief / policy-report
#' context: cream page, white plot panel, soft tan gridlines, serif
#' headlines, sans-serif labels.
#'
#' Use-order matters. The categorical palette is in priority order:
#' position 1 is your default first category, position 3 (mustard) is
#' the canonical highlight color for focal annotations.
#'
#' Direction is semantic. The diverging scale ships with `reverse =`
#' so you can flip it when "up" means "bad" for a metric (e.g. crime,
#' eviction) without losing the convention that olive reads as positive.
#'
#' Labels stay legible. The `stern_text_on_*` helpers handle the
#' contrast flip for text overlaid on filled cells, so heatmaps and
#' tile labels don't disappear at the dark end of the scale.
#'
#' @keywords internal
"_PACKAGE"
