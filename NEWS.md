# stern (development version)

## stern 0.1.0

First release. Converts the loose `stern-theme.R` / `stern-shiny.R` /
`stern-highcharter.R` scripts into a proper installable R package.

### ggplot2 module

* `theme_stern()`, `theme_stern_vertical()`, `theme_stern_map()` — three
  theme variants for cartesian charts, horizontal bar charts, and maps.
* `scale_color_stern_cat()` / `scale_fill_stern_cat()` — categorical
  palette in use order (olive, navy, mustard, rust, walnut, sage).
* `scale_color_stern_seq()` / `scale_fill_stern_seq()` — single-hue olive
  sequential ramp, with discrete-binned variants `*_seq_d()`.
* `scale_color_stern_div()` / `scale_fill_stern_div()` — diverging
  olive ↔ navy ramp with cream midpoint.
* `stern_text_on_seq()` / `stern_text_on_div()` — automatic text-color
  contrast flip for labels overlaid on filled cells.
* `stern_setup_fonts()` — register Source Serif 4 and Source Sans 3
  via `showtext`.

### Shiny module (Suggests: bslib, htmltools, shiny)

* `stern_bs_theme()` — `bslib` theme matching the ggplot aesthetic.
* `stern_app_shell()` — sensible-default wrapper around `page_sidebar()`.
* `stern_stat_callout()` — bordered stat callout component.
* `stern_value_box_palette()` — accent-color helper for `value_box()`.

### Highcharter module (Suggests: highcharter)

* `hc_theme_stern()` — Highcharts theme matching the ggplot aesthetic.
* `hc_stern_cat()` / `hc_stern_seq()` / `hc_stern_div()` — palette
  application helpers.
* `hc_stern_seq_stops()` / `hc_stern_div_stops()` — pre-formatted color
  stops for `hc_colorAxis()`.

### Color tokens (exported)

* `stern_palette`, `stern_seq`, `stern_div`
* `stern_bg_primary`, `stern_bg_secondary`, `stern_bg_surface`
* `stern_text_primary`, `stern_text_body`, `stern_text_muted`
* `stern_border`, `stern_border_soft`
