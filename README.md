# stern

An editorial design system for civic-data visualization in R — ggplot2 themes, color scales, Shiny components, and a Highcharter theme, all in a coordinated vintage editorial palette.

## Installation

```r
# install.packages("remotes")
remotes::install_github("EmilyRStern/stern-theme")
```

To pin to a specific release:

```r
remotes::install_github("EmilyRStern/stern-theme@v0.1.0")
```

## What's in here

The package is split into modules so you only load what you need:

- **ggplot2 theme** — `theme_stern()`, `theme_stern_vertical()`, `theme_stern_map()`, the `scale_color_stern_*` / `scale_fill_stern_*` family, `stern_text_on_seq()` / `stern_text_on_div()`, and `stern_save()` for streamlined exports.
- **Shiny / bslib** (optional) — `stern_bs_theme()`, `stern_app_shell()`, `stern_stat_callout()`, `stern_value_box_palette()`. Requires `bslib`, `shiny`, `htmltools`.
- **Highcharter** (optional) — `hc_theme_stern()` plus the `hc_stern_*` palette helpers and color-stop helpers for `hc_colorAxis()`. Requires `highcharter`.

The core ggplot module only needs `ggplot2` and `scales`. The Shiny and Highcharter modules are listed as Suggests so you don't have to install everything just to use the static themes.

## Quick start — static ggplot

```r
library(ggplot2)
library(stern)

stern_setup_fonts()           # call once per session

ggplot(data, aes(x, y, color = group)) +
  geom_line() +
  scale_color_stern_cat() +
  labs(
    title    = "Headline",
    subtitle = "Supporting context",
    caption  = "Source: Agency, Year"
  ) +
  theme_stern()
```

## Quick start — Shiny

```r
library(shiny)
library(bslib)
library(stern)

ui <- stern_app_shell(
  title = "Dashboard",
  sidebar = sidebar(
    selectInput("var", "Variable", choices = c("A", "B", "C"))
  ),
  card(
    card_header("My chart"),
    card_body(plotOutput("plot"))
  )
)

server <- function(input, output) { ... }
shinyApp(ui, server)
```

## Quick start — Highcharter

```r
library(highcharter)
library(stern)

highchart() |>
  hc_chart(type = "column") |>
  hc_xAxis(categories = months) |>
  hc_add_series(name = "Series 1", data = values) |>
  hc_stern_cat() |>
  hc_add_theme(hc_theme_stern())
```

## Saving plots

`stern_save()` is a streamlined wrapper around `ggsave()`. Pixel dimensions, named size presets, automatic `showtext` DPI sync, and a sensible cream-background default:

```r
p <- ggplot(...) + theme_stern()

stern_save(p, "report.png")                       # 1600 x 1000 cream PNG
stern_save(p, "social.png",  size = "social")     # 1200 x 630 (Twitter card)
stern_save(p, "square.png",  size = "square")     # 1200 x 1200 (Instagram)
stern_save(p, "custom.png",  width = 900, height = 600)
stern_save(p, "vector.pdf")                       # PDF auto-detected
stern_save(p, "white.png",   bg = "white")        # override background
```

The format is inferred from the extension. The `showtext` DPI is matched to the export DPI under the hood, so your text doesn't come out tiny when saving at print resolution.

## Color system

Three scales, each with its own job:

- **Categorical** — `scale_color_stern_cat()` / `scale_fill_stern_cat()`. Six earthy hues in use order: olive, navy, mustard, rust, walnut, sage. Position 1 is your default first category. Position 3 (mustard) is also the canonical "highlight the focal point" color when used outside the categorical scale.
- **Sequential** — `scale_color_stern_seq()` / `scale_fill_stern_seq()`. Single-hue olive ramp, low to high. Discrete-binned variant: `scale_*_stern_seq_d()`. Use `reverse = TRUE` to flip direction.
- **Diverging** — `scale_color_stern_div()` / `scale_fill_stern_div()`. Olive to navy with a warm cream midpoint. Pass `midpoint =` to set where neutral falls in your data. Pass `reverse = TRUE` when "up" means "bad" for the metric (so navy reads as bad).

## Theme variants

- **`theme_stern()`** — default. Horizontal gridlines, white plot panel, cream page, bottom-centered legend.
- **`theme_stern_vertical()`** — vertical gridlines instead. Use for horizontal bar charts and dot plots.
- **`theme_stern_map()`** — no gridlines, no panel border, no axis ticks. Use for choropleths and spatial visualizations.

All three accept a `legend =` argument: `"bottom"` (default), `"top"`, `"right"`, `"left"`, `"none"`, or a numeric `c(x, y)` for an inset legend.

## Text-on-fill legibility

When labels sit on top of a sequential or diverging fill, dark text gets lost on the dark end of the scale. Two helpers handle the contrast flip automatically:

- **`stern_text_on_seq(values)`** — for sequential fills. Returns dark text for light cells, cream text for dark cells.
- **`stern_text_on_div(values, midpoint = 0)`** — for diverging fills. Returns cream text near both extremes, dark text near the neutral middle.

Pair either helper with `scale_color_identity()` so ggplot uses the colors directly:

```r
ggplot(data, aes(x, y, fill = score)) +
  geom_tile() +
  geom_text(aes(label = score, color = stern_text_on_seq(score)),
            family = "stern_sans") +
  scale_fill_stern_seq() +
  scale_color_identity()
```

## Token reference

All color tokens are exported and documented (`?stern_palette`, etc.):

```r
stern_palette       # named vector: olive, navy, mustard, rust, walnut, sage
stern_seq           # 5 colors: sequential olive ramp
stern_div           # 7 colors: diverging olive to navy
stern_bg_primary    # "#FBF8F1" — page background
stern_bg_secondary  # "#F2EDDF" — panels
stern_text_primary  # "#2B2A1F"
stern_text_body     # "#4A4632"
stern_text_muted    # "#6E6A55"
stern_border        # "#C9C0A4"
```

## Running the smoke tests

The repo includes two scripts that exercise the package end-to-end. After installing and loading:

```r
library(stern)
source("test-stern-theme.R")    # renders 9 chart types in the plot pane
source("test-stern-shiny.R")    # launches a Shiny smoke-test app
```

Use the back/forward arrows in the RStudio plot pane to flip through the static charts.

## Fonts

This theme uses Google Fonts (auto-loaded on `stern_setup_fonts()` via `showtext`):

- **Source Serif 4** for headlines, subtitles, body, and legend text
- **Source Sans 3** for axis labels and structural UI

By default, `face = "bold"` renders at weight 600 (semibold) for an editorial half-bold feel. Override with `stern_setup_fonts(bold_weight = 700)` for full bold or `bold_weight = 500` for medium.

## Dependencies

**Required:** `ggplot2`, `scales`.

**Suggested:** `showtext`, `sysfonts` (for Google Font support); `bslib`, `shiny`, `htmltools`, `DT` (for the Shiny module); `highcharter` (for interactive charts).

The Suggests packages are checked at function-call time — install only what you actually use.

## License

MIT © Emily Stern
