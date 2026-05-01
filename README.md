# stern-theme

A ggplot2 theme + color scales for civic-data visualization, in a vintage editorial palette.

## What's in here

- **`stern-theme.R`** — the theme (`theme_stern()`, `theme_stern_vertical()`, `theme_stern_map()`) and color scale functions for categorical, sequential, and diverging data.
- **`test-stern-theme.R`** — a battery of test charts. Run it once to verify everything works on your machine and to see what each scale looks like.
- **`test-output/`** — populated when you run the test script. Holds the rendered PNGs.

## Quick start

```r
source("stern-theme.R")
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

## Color system

Three scales, each with its own job:

- **Categorical** — `scale_color_stern_cat()` / `scale_fill_stern_cat()`. Six earthy hues in use order: olive, navy, mustard, rust, walnut, sage. Position 1 is your default first category. Position 3 (mustard) is also the canonical "highlight the focal point" color when used outside the categorical scale.
- **Sequential** — `scale_color_stern_seq()` / `scale_fill_stern_seq()`. Single-hue olive ramp, low → high. Discrete-binned variant: `scale_*_stern_seq_d()`. Use `reverse = TRUE` to flip direction.
- **Diverging** — `scale_color_stern_div()` / `scale_fill_stern_div()`. Olive ↔ navy with a warm cream midpoint. Pass `midpoint =` to set where neutral falls in your data. Pass `reverse = TRUE` when "up" means "bad" for the metric (so navy reads as bad).

## Theme variants

- **`theme_stern()`** — default. Horizontal gridlines, white plot panel, cream page.
- **`theme_stern_vertical()`** — vertical gridlines instead. Use for horizontal bar charts and dot plots.
- **`theme_stern_map()`** — no gridlines, no panel border, no axis ticks. Use for choropleths and spatial visualizations.

## Token reference

You can also pull tokens directly when building custom annotations or callouts:

```r
stern_palette       # named vector: olive, navy, mustard, rust, walnut, sage
stern_seq           # 5 colors: sequential olive ramp
stern_div           # 7 colors: diverging olive ↔ navy
stern_bg_primary    # "#FBF8F1" — page background
stern_bg_secondary  # "#F2EDDF" — panels
stern_text_primary  # "#2B2A1F"
stern_text_body     # "#4A4632"
stern_text_muted    # "#6E6A55"
stern_border        # "#C9C0A4"
```

## Running the tests

```r
setwd("path/to/stern-theme")
source("test-stern-theme.R")
```

Output lands in `test-output/` as PNGs. The data is intentionally silly — snacks, tea, garden yields — so what you're evaluating is the theme itself, not the topic.

If anything looks off (font rendering wrong, colors not pulling through, spacing weird), it's almost always one of:

- Fonts didn't load — check that `showtext` and `sysfonts` are installed and that `stern_setup_fonts()` ran without error.
- DPI mismatch — the test script uses `dpi = 150`. If text looks too big or too small at that DPI, adjust in the call to `stern_setup_fonts()` or in your `ggsave()` call.
- Caching issues — restart R and try again. `showtext` can get sticky between sessions.

## Dependencies

- `ggplot2`
- `scales`
- `showtext` and `sysfonts` (for Google Font support)
- `dplyr`, `tidyr`, `tibble` (used in the test script for data shaping)
- `sf` (used in the test script for the choropleth example)

## Fonts

This theme uses Google Fonts:

- **Source Serif 4** for headlines, subtitles, and body
- **Source Sans 3** for axis labels, legends, captions, and UI

Both load automatically through `stern_setup_fonts()` via `showtext`. No local installation required.
