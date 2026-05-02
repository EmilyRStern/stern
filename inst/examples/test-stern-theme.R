# ============================================================================
# stern smoke test
# ----------------------------------------------------------------------------
# Renders a battery of test charts using the stern package. Each chart prints
# to the active graphics device (the RStudio plot pane). Use the back/forward
# arrows in the plot pane to flip through them.
#
# This script is invoked by stern::stern_test(). You can also source it
# directly: source(system.file("examples", "test-stern-theme.R", package = "stern"))
#
# Sample data is intentionally silly (snack consumption, tea preferences,
# library checkouts, etc.) so the theme is what gets evaluated, not the topic.
# ============================================================================

# ---- Setup ----------------------------------------------------------------

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(sf)
  library(scales)
})

stern::stern_setup_fonts(dpi = 96)

# Each call shows the plot in the active graphics device.
save_test <- function(plot, name, width = 8, height = 5) {
  message("  showing: ", name)
  print(plot)
}

message("Rendering Stern theme test charts...")

# ---- 1. Categorical bar - horizontal -------------------------------------

snack_data <- tibble::tibble(
  snack = c("Pretzels", "Trail mix", "Cheese cubes",
            "Olives", "Crackers"),
  count = c(48, 32, 24, 18, 9)
)

p1 <- ggplot(snack_data, aes(x = count, y = reorder(snack, count),
                              fill = snack)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = count), hjust = -0.4,
            family = "stern_sans", size = 3.2,
            color = stern::stern_text_body) +
  stern::scale_fill_stern_cat() +
  scale_x_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(
    title    = "Office snacks consumed this month",
    subtitle = "Tracked by the kitchen committee, not very scientifically",
    x        = "Servings",
    y        = NULL,
    caption  = "Source: A clipboard on the fridge."
  ) +
  stern::theme_stern_vertical() +
  theme(legend.position = "none")

save_test(p1, "01_categorical_horizontal_bars")

# ---- 2. Categorical line chart -------------------------------------------

tea_pref <- tibble::tibble(
  tea = rep(c("Earl Grey", "Chamomile", "Peppermint", "Rooibos"), each = 8),
  month = factor(rep(month.abb[1:8], times = 4), levels = month.abb),
  cups = c(
    48, 52, 55, 50, 58, 62, 65, 68,   # Earl Grey
    72, 70, 65, 60, 55, 50, 48, 52,   # Chamomile
    35, 38, 42, 48, 55, 62, 68, 75,   # Peppermint
    28, 30, 35, 40, 42, 45, 48, 50    # Rooibos
  )
)

p2 <- ggplot(tea_pref, aes(x = month, y = cups, color = tea, group = tea)) +
  geom_line(linewidth = 0.7) +
  geom_point(size = 1.6) +
  stern::scale_color_stern_cat() +
  labs(
    title    = "Tea consumption by variety",
    subtitle = "Cups served at the office, January through August",
    x        = NULL,
    y        = "Cups served",
    color    = "Tea",
    caption  = "Source: The break room sign-in sheet."
  ) +
  stern::theme_stern()

save_test(p2, "02_categorical_lines")

# ---- 3. Stacked bar (4 categories) ---------------------------------------

reading_data <- tidyr::expand_grid(
  shelf = c("Fiction", "Non-fiction", "Mystery", "Cookbooks"),
  format = factor(c("Hardcover", "Paperback", "Audiobook", "E-book"),
                  levels = c("Hardcover", "Paperback", "Audiobook", "E-book"))
) |>
  dplyr::mutate(
    checkouts = dplyr::case_when(
      shelf == "Fiction"     & format == "Hardcover" ~ 32,
      shelf == "Fiction"     & format == "Paperback" ~ 28,
      shelf == "Fiction"     & format == "Audiobook" ~ 22,
      shelf == "Fiction"     & format == "E-book"    ~ 18,
      shelf == "Non-fiction" & format == "Hardcover" ~ 38,
      shelf == "Non-fiction" & format == "Paperback" ~ 22,
      shelf == "Non-fiction" & format == "Audiobook" ~ 24,
      shelf == "Non-fiction" & format == "E-book"    ~ 16,
      shelf == "Mystery"     & format == "Hardcover" ~ 26,
      shelf == "Mystery"     & format == "Paperback" ~ 34,
      shelf == "Mystery"     & format == "Audiobook" ~ 28,
      shelf == "Mystery"     & format == "E-book"    ~ 12,
      shelf == "Cookbooks"   & format == "Hardcover" ~ 44,
      shelf == "Cookbooks"   & format == "Paperback" ~ 18,
      shelf == "Cookbooks"   & format == "Audiobook" ~ 4,
      shelf == "Cookbooks"   & format == "E-book"    ~ 14
    )
  )

p3 <- ggplot(reading_data, aes(x = shelf, y = checkouts, fill = format)) +
  geom_col(width = 0.65) +
  stern::scale_fill_stern_cat() +
  labs(
    title    = "Library checkouts by section and format",
    subtitle = "Spring quarter, neighborhood branch",
    x        = NULL,
    y        = "Checkouts",
    fill     = "Format",
    caption  = "Source: Imaginary library system."
  ) +
  stern::theme_stern()

save_test(p3, "03_stacked_bars")

# ---- 4. Sequential continuous heatmap ------------------------------------

heatmap_data <- expand.grid(
  day = factor(c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"),
               levels = c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")),
  bakery = c("Hearth", "Crumb", "Levain", "Stoneground", "Wildflour", "Toast"),
  stringsAsFactors = FALSE
)

set.seed(42)
heatmap_data$score <- round(runif(nrow(heatmap_data), 30, 95))

p4 <- ggplot(heatmap_data, aes(x = day, y = bakery, fill = score)) +
  geom_tile(color = stern::stern_bg_primary, linewidth = 0.5) +
  geom_text(aes(label = score, color = stern::stern_text_on_seq(score)),
            family = "stern_sans", size = 3) +
  stern::scale_fill_stern_seq(name = "Freshness") +
  scale_color_identity() +
  coord_equal() +
  labs(
    title    = "Cookie freshness scores by bakery and day",
    subtitle = "Higher is fresher. Rated by an enthusiastic but unqualified panel.",
    x        = NULL,
    y        = NULL,
    caption  = "Source: A very serious cookie tasting club."
  ) +
  stern::theme_stern() +
  theme(panel.grid = element_blank())

save_test(p4, "04_sequential_heatmap", width = 9, height = 5)

# ---- 5. Sequential discrete (binned quintiles) ---------------------------

set.seed(11)
quintile_data <- tibble::tibble(
  neighborhood = paste("Block", LETTERS[1:15]),
  bird_count = sample(20:200, 15, replace = TRUE)
) |>
  dplyr::mutate(
    quintile = factor(
      dplyr::ntile(bird_count, 5),
      levels = 1:5,
      labels = c("Lowest", "Low", "Mid", "High", "Highest")
    )
  )

p5 <- ggplot(quintile_data,
             aes(x = bird_count, y = reorder(neighborhood, bird_count),
                 fill = quintile)) +
  geom_col(width = 0.7) +
  stern::scale_fill_stern_seq_d(name = "Quintile") +
  labs(
    title    = "Backyard bird counts by neighborhood block",
    subtitle = "Citizen science data, May reporting period",
    x        = "Birds counted",
    y        = NULL,
    caption  = "Source: Volunteers with binoculars and patience."
  ) +
  stern::theme_stern_vertical()

save_test(p5, "05_sequential_discrete_quintiles", width = 8, height = 6)

# ---- 6. Diverging bars ---------------------------------------------------

diverge_data <- tibble::tibble(
  city = c("Pinehurst", "Marlowe", "Cedarville", "Brookline",
           "Ashford", "Westmont", "Oakford", "Riverside",
           "Fairview", "Stonebridge", "Millcreek", "Glenwood",
           "Lakeshore", "Hillcrest"),
  pct_change = c(20, 14, 9, 5, 3, 1, -2, -4, -6, -10, -14, -18, -22, -28)
) |>
  dplyr::arrange(pct_change) |>
  dplyr::mutate(city = factor(city, levels = city))

p6 <- ggplot(diverge_data, aes(x = pct_change, y = city, fill = pct_change)) +
  geom_col(width = 0.75) +
  geom_vline(xintercept = 0, color = stern::stern_border, linewidth = 0.4) +
  geom_text(aes(label = paste0(ifelse(pct_change > 0, "+", ""), pct_change, "%"),
                hjust = ifelse(pct_change > 0, -0.2, 1.2)),
            family = "stern_sans", size = 3,
            color = stern::stern_text_body) +
  stern::scale_fill_stern_div(midpoint = 0) +
  scale_x_continuous(labels = function(x) paste0(x, "%"),
                     expand = expansion(mult = c(0.15, 0.15))) +
  labs(
    title    = "Year-over-year change in farmers' market attendance",
    subtitle = "Spring 2026 vs. Spring 2025, by host town",
    x        = "Change",
    y        = NULL,
    caption  = "Source: Regional market collective."
  ) +
  stern::theme_stern() +
  theme(legend.position = "none",
        panel.grid.major.y = element_blank())

save_test(p6, "06_diverging_bars", width = 8, height = 6)

# ---- 7. Faceted small multiples ------------------------------------------

set.seed(7)
facet_data <- expand.grid(
  week = 1:12,
  garden = c("Tomatoes", "Peppers", "Squash", "Beans")
) |>
  dplyr::mutate(
    base = dplyr::case_when(
      garden == "Tomatoes" ~ 2,
      garden == "Peppers"  ~ 1.5,
      garden == "Squash"   ~ 3,
      garden == "Beans"    ~ 2
    ),
    yield = base * week + rnorm(48, 0, 4),
    yield = pmax(0, yield)
  )

p7 <- ggplot(facet_data, aes(x = week, y = yield, fill = garden)) +
  geom_col(width = 0.7) +
  stern::scale_fill_stern_cat() +
  facet_wrap(~ garden, ncol = 2) +
  labs(
    title    = "Weekly garden yield by crop",
    subtitle = "Pounds harvested, community garden plot",
    x        = "Week",
    y        = "Pounds",
    caption  = "Source: A spreadsheet kept by a very dedicated retiree."
  ) +
  stern::theme_stern() +
  theme(legend.position = "none")

save_test(p7, "07_facets", width = 9, height = 6)

# ---- 8. sf-based choropleth ----------------------------------------------

grid_sf <- sf::st_make_grid(
  sf::st_as_sfc(sf::st_bbox(c(xmin = 0, ymin = 0, xmax = 5, ymax = 5))),
  cellsize = 1
) |>
  sf::st_as_sf() |>
  dplyr::mutate(
    parcel = paste0("P", sprintf("%02d", dplyr::row_number())),
    bee_score = c(
      12, 18, 25, 30, 22,
      20, 35, 48, 52, 38,
      28, 50, 72, 68, 45,
      22, 42, 55, 60, 40,
      15, 28, 35, 32, 25
    )
  )

p8 <- ggplot(grid_sf) +
  geom_sf(aes(fill = bee_score), color = stern::stern_bg_primary, linewidth = 0.5) +
  stern::scale_fill_stern_seq(name = "Bee score") +
  labs(
    title    = "Pollinator activity by garden parcel",
    subtitle = "Bees observed per 10-minute survey window",
    caption  = "Source: A volunteer with a stopwatch and a notebook."
  ) +
  stern::theme_stern_map()

save_test(p8, "08_choropleth_sf", width = 7, height = 6)

# ---- 9. Mustard-highlight chart ------------------------------------------

highlight_data <- tibble::tibble(
  quarter = factor(
    c("Q1 24", "Q2 24", "Q3 24", "Q4 24", "Q1 25", "Q2 25",
      "Q3 25", "Q4 25", "Q1 26"),
    levels = c("Q1 24", "Q2 24", "Q3 24", "Q4 24", "Q1 25", "Q2 25",
               "Q3 25", "Q4 25", "Q1 26")
  ),
  value = c(58, 64, 52, 60, 67, 70, 75, 72, 95),
  highlight = c(rep("normal", 8), "focus")
)

p9 <- ggplot(highlight_data, aes(x = quarter, y = value, fill = highlight)) +
  geom_col(width = 0.7) +
  scale_fill_manual(
    values = c(normal = stern::stern_palette[["olive"]],
               focus  = stern::stern_palette[["mustard"]])
  ) +
  geom_text(data = subset(highlight_data, highlight == "focus"),
            aes(label = value), vjust = -0.6,
            family = "stern_sans", size = 3.4,
            color = stern::stern_text_primary) +
  labs(
    title    = "Pumpkin pie sales by quarter",
    subtitle = "Q1 26 highlighted because, well, look at it",
    x        = NULL,
    y        = "Pies sold",
    caption  = "Source: The bakery's POS system, which is extremely judgmental."
  ) +
  stern::theme_stern() +
  theme(legend.position = "none")

save_test(p9, "09_mustard_highlight")

# ---- Done ----------------------------------------------------------------

message("\nAll done. Use the back/forward arrows in the RStudio plot pane ",
        "to flip through all 9 charts.")
