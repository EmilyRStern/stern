# stern

A design system for data visualization in R. The system was designed to be accessible to casual R users, allowing for easier collaboration and consistency on group projects.  

## Installation

To access the package input the following code in the R-Studio console window:

```r
# install.packages("remotes")
remotes::install_github("EmilyRStern/stern")
```

This will install the package. After installation, it can be called with `library(stern)`.

To demo the styling, run the following in your console: 

```r
# Static plots
stern::stern_test()

# Shiny app 
stern::stern_test_shiny()
```

Use the back/forward arrows in the RStudio plot pane to flip through the static charts. Shiny will open in its own window. 

## Quick start

Quick start sections are blocks to be pasted into an R script, to show how to apply the themes to your own outputs. 

### Quick start — ggplot

After installing the library, paste the below r code into a script file to create a static plot.

```r
## Loading block. Add in relevant R libraries and datasets at top of script. 
library(ggplot2)
library(stern)

stern_setup_fonts()           # Need to call once per session before using theme

## Example plot using stern theme where we call the categorical color scale with `scale_color_stern_cat()`, and apply the overall plot theme (fonts, backgrounds) with `theme_stern()`

p <- ggplot(data, aes(x, y, color = group)) +
  geom_line() +
  scale_color_stern_cat() +
  labs(
    title    = "Headline",
    subtitle = "Supporting context",
    caption  = "Source: Agency, Year"
  ) +
  theme_stern()
```

Below are starter blocks for shiny and highcharts. Used for interactive products like dashboards and html charts.

### Quick start — Shiny

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

### Quick start — Highcharter

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

`stern_save()` is a wrapper around `ggsave()`, with sizing conventions optimized to suit different deliverable types. In this example we create and save a chart called `p`

```r
p <- ggplot(...) + theme_stern()

## All saving options listed below. `stern_save` on it's own should suffice for most uses. 

stern_save(p, "report.png")                       # 1600 x 1000 cream PNG
#stern_save(p, "social.png",  size = "social")     # 1200 x 630 (Twitter card)
#stern_save(p, "square.png",  size = "square")     # 1200 x 1200 (Instagram)
#stern_save(p, "custom.png",  width = 900, height = 600) # customized shape
#stern_save(p, "vector.pdf")                       # PDF auto-detected
#stern_save(p, "white.png",   bg = "white")        # override background

```

## Fonts

This theme uses Google Fonts (auto-loaded on `stern_setup_fonts()` via `showtext`):

- **Source Serif 4** for headlines, subtitles, body, and legend text
- **Source Sans 3** for axis labels and structural UI

By default, `face = "bold"` renders at weight 600 (semibold). Override with `stern_setup_fonts(bold_weight = 700)` for full bold or `bold_weight = 500` for medium.

## Dependencies

**Required:** `ggplot2`, `scales`, `showtext`, `sysfonts` (for Google Font support); `bslib`, `shiny`, `htmltools`, `DT` (for the Shiny module); `highcharter` (for interactive charts).

## License

MIT © Emily Stern, 2026
