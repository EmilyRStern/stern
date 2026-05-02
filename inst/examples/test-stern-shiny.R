# ============================================================================
# test-stern-shiny.R
# ----------------------------------------------------------------------------
# A small Shiny app that exercises every component styled by the stern
# Shiny module.
#
# Tests:
#   - page_sidebar layout
#   - sidebar with form inputs (selectInput, sliderInput, dateRangeInput,
#     checkboxGroupInput, radioButtons)
#   - cards with headers, bodies, footers
#   - bslib::value_box() with the design system's left-border accent
#   - stern_stat_callout() -- the standalone version
#   - tabs (navset_tab)
#   - DT data tables
#   - highcharter charts (column, line, scatter)
#   - buttons (primary, secondary, action)
#
# Run with:
#   library(stern)
#   stern_test_shiny()
#
# Sample data is intentionally silly -- books, snacks, weather observations.
# ============================================================================

library(shiny)
library(bslib)
library(htmltools)
library(DT)
library(highcharter)
library(dplyr)
library(tibble)
library(stern)

# ---- Sample data ----------------------------------------------------------

# Tea consumption data (categorical line chart)
tea_data <- tibble(
  month = month.abb[1:8],
  earl_grey  = c(48, 52, 55, 50, 58, 62, 65, 68),
  chamomile  = c(72, 70, 65, 60, 55, 50, 48, 52),
  peppermint = c(35, 38, 42, 48, 55, 62, 68, 75),
  rooibos    = c(28, 30, 35, 40, 42, 45, 48, 50)
)

# Library checkout table (DT)
library_data <- tibble(
  Title       = c("The Goblin Emperor", "Piranesi", "All Systems Red",
                  "Annihilation", "Babel", "The Fifth Season",
                  "Gideon the Ninth", "A Memory Called Empire"),
  Genre       = c("Fantasy", "Fantasy", "Sci-fi", "Sci-fi",
                  "Fantasy", "Fantasy", "Sci-fi", "Sci-fi"),
  Checkouts   = c(248, 312, 156, 89, 421, 384, 267, 198),
  Avg_Rating  = c(4.3, 4.5, 4.1, 3.8, 4.6, 4.5, 4.2, 4.3),
  Last_Out    = c("2026-04-12", "2026-04-28", "2026-04-22", "2026-03-15",
                  "2026-04-30", "2026-04-25", "2026-04-19", "2026-04-21")
)

# Bakery scores (categorical bar chart)
bakery_scores <- tibble(
  bakery = c("Hearth", "Crumb", "Levain", "Stoneground", "Wildflour", "Toast"),
  score  = c(82, 68, 91, 76, 88, 71)
)

# ---- UI -------------------------------------------------------------------

ui <- stern_app_shell(
  title = "Stern theme -- component test",
  # fillable = FALSE so the main content uses normal block flow.
  # In fillable mode, htmlwidget heights inside nested cards/tabs collapse to 0.
  fillable = FALSE,
  sidebar = sidebar(
    title = "Filters",
    width = 280,

    selectInput(
      "tea_choice", "Tea variety",
      choices  = c("Earl Grey", "Chamomile", "Peppermint", "Rooibos"),
      selected = "Earl Grey"
    ),

    selectInput(
      "genre_filter", "Genre",
      choices  = c("All", "Fantasy", "Sci-fi"),
      selected = "All"
    ),

    sliderInput(
      "rating_min", "Minimum rating",
      min = 3.0, max = 5.0, value = 4.0, step = 0.1
    ),

    dateRangeInput(
      "date_range", "Checkout window",
      start = "2026-03-01", end = "2026-04-30"
    ),

    checkboxGroupInput(
      "formats", "Formats",
      choices  = c("Hardcover", "Paperback", "Audiobook", "E-book"),
      selected = c("Hardcover", "Paperback")
    ),

    radioButtons(
      "sort_by", "Sort by",
      choices  = c("Title", "Genre", "Checkouts"),
      selected = "Checkouts",
      inline   = FALSE
    ),

    hr(),

    actionButton("refresh", "Refresh data", class = "btn-primary"),
    br(), br(),
    actionButton("export", "Export", class = "btn-secondary")
  ),

  # Page header
  div(
    style = "margin-bottom: 8px;",
    h2("Library checkouts dashboard",
       style = "margin-bottom: 2px;"),
    p("Spring 2026 reporting period - Demo data for theme testing.",
      style = paste0("font-family: 'Source Serif 4', serif; ",
                     "color: ", stern_text_body, "; font-size: 0.92rem; ",
                     "margin-bottom: 16px;"))
  ),

  # Value boxes row (using stern_stat_callout for the design system look)
  layout_column_wrap(
    width = 1/4,
    gap = "12px",
    stern_stat_callout(
      label = "Total checkouts",
      value = "2,408",
      context = "Up from 2,141 in spring 2025",
      accent = "olive"
    ),
    stern_stat_callout(
      label = "Active patrons",
      value = "847",
      context = "76.7% returning members",
      accent = "navy"
    ),
    stern_stat_callout(
      label = "Avg rating",
      value = "4.3",
      context = "Across all genres",
      accent = "mustard"
    ),
    stern_stat_callout(
      label = "Overdue",
      value = "23",
      context = "Down from 41 last month",
      accent = "rust"
    )
  ),

  br(),

  # Tabs
  navset_tab(
    nav_panel(
      title = "Charts",
      icon  = NULL,

      br(),
      layout_column_wrap(
        width = 1/2,
        gap = "16px",

        # NOTE: We wrap each highchartOutput in a plain block-level <div>
        # rather than putting it directly inside card_body(). bslib's
        # card_body uses .html-fill-container (display:flex), and in the
        # RStudio Viewer pane the chart's parent reports offsetWidth: 0
        # at the moment Highcharts initializes -- so Highcharts gives up
        # and the card stays empty. A plain block div with explicit
        # width:100%; height:320px gives Highcharts a guaranteed canvas.
        card(
          full_screen = FALSE,
          card_header("Tea consumption by variety"),
          div(
            style = "display: block; width: 100%; height: 320px; padding: 12px 14px; box-sizing: border-box;",
            highchartOutput("tea_chart", width = "100%", height = "100%")
          ),
          card_footer("Source: The break room sign-in sheet.")
        ),

        card(
          full_screen = FALSE,
          card_header("Bakery freshness scores"),
          div(
            style = "display: block; width: 100%; height: 320px; padding: 12px 14px; box-sizing: border-box;",
            highchartOutput("bakery_chart", width = "100%", height = "100%")
          ),
          card_footer("Source: The cookie tasting club.")
        )
      ),

      br(),
      card(
        full_screen = FALSE,
        card_header("Monthly trend across all teas"),
        div(
          style = "display: block; width: 100%; height: 340px; padding: 12px 14px; box-sizing: border-box;",
          highchartOutput("trend_chart", width = "100%", height = "100%")
        ),
        card_footer("Source: The break room sign-in sheet.")
      )
    ),

    nav_panel(
      title = "Data",
      br(),
      card(
        full_screen = FALSE,
        card_header("Library checkout records"),
        card_body(
          fill = FALSE,
          min_height = "360px",
          DTOutput("library_table")
        )
      )
    ),

    nav_panel(
      title = "Notes",
      br(),
      card(
        card_body(
          h3("About this dashboard"),
          p(style = "font-family: 'Source Serif 4', serif; line-height: 1.65;",
            "This is a test of the Stern theme applied to a Shiny app. ",
            "Every component on this page is styled through ",
            tags$code("stern_bs_theme()"), " plus the layered CSS rules in ",
            tags$code("stern-shiny.R"), "."),
          p(style = "font-family: 'Source Serif 4', serif; line-height: 1.65;",
            "If anything looks off -- fonts not loading, colors not matching, ",
            "spacing weird -- note which component and we'll tune the rules. ",
            "Common issues to look for: rounded corners showing through, ",
            "white text on colored fills, borders missing or too heavy, ",
            "form inputs reverting to default Bootstrap styling."),
          h4("Component checklist"),
          tags$ul(
            style = "font-family: 'Source Serif 4', serif; line-height: 1.7;",
            tags$li("Sidebar -- secondary cream background, square corners"),
            tags$li("Form inputs -- uppercase labels, white input backgrounds, olive focus"),
            tags$li("Buttons -- primary olive, secondary outlined"),
            tags$li("Stat callouts -- cream with colored left borders"),
            tags$li("Tabs -- underline active state in olive, no pills"),
            tags$li("Cards -- square corners, secondary cream headers"),
            tags$li("DT table -- serif body, sans uppercase headers, olive pagination"),
            tags$li("Highcharter -- olive/navy/mustard series, cream background")
          )
        )
      )
    )
  )
)

# ---- Server ---------------------------------------------------------------

server <- function(input, output, session) {

  # Tea chart -- categorical line by tea variety
  output$tea_chart <- renderHighchart({
    req(input$tea_choice)
    selected_col <- switch(input$tea_choice,
                           "Earl Grey"  = "earl_grey",
                           "Chamomile"  = "chamomile",
                           "Peppermint" = "peppermint",
                           "Rooibos"    = "rooibos")
    req(selected_col)
    values <- tea_data[[selected_col]]

    highchart() |>
      hc_chart(type = "column") |>
      hc_xAxis(categories = tea_data$month, title = list(text = NULL)) |>
      hc_yAxis(title = list(text = "Cups served")) |>
      hc_add_series(
        name = input$tea_choice,
        data = values,
        color = stern_palette[["olive"]]
      ) |>
      hc_legend(enabled = FALSE) |>
      hc_tooltip(valueSuffix = " cups") |>
      hc_add_theme(hc_theme_stern())
  })

  # Bakery chart -- bar with mustard highlighting the best
  output$bakery_chart <- renderHighchart({
    sorted <- bakery_scores |> arrange(desc(score))
    best_idx <- which.max(sorted$score) - 1  # 0-indexed for Highcharts

    point_colors <- rep(stern_palette[["olive"]], nrow(sorted))
    point_colors[which.max(sorted$score)] <- stern_palette[["mustard"]]

    highchart() |>
      hc_chart(type = "bar") |>
      hc_xAxis(categories = sorted$bakery, title = list(text = NULL)) |>
      hc_yAxis(title = list(text = "Score"), min = 0, max = 100) |>
      hc_add_series(
        name = "Score",
        data = lapply(seq_along(sorted$score), function(i) {
          list(y = sorted$score[i], color = point_colors[i])
        })
      ) |>
      hc_legend(enabled = FALSE) |>
      hc_tooltip(pointFormat = "<b>{point.y}</b> out of 100") |>
      hc_add_theme(hc_theme_stern())
  })

  # Trend chart -- multi-series line
  output$trend_chart <- renderHighchart({
    highchart() |>
      hc_chart(type = "line") |>
      hc_xAxis(categories = tea_data$month, title = list(text = NULL)) |>
      hc_yAxis(title = list(text = "Cups served")) |>
      hc_add_series(name = "Earl Grey",  data = tea_data$earl_grey) |>
      hc_add_series(name = "Chamomile",  data = tea_data$chamomile) |>
      hc_add_series(name = "Peppermint", data = tea_data$peppermint) |>
      hc_add_series(name = "Rooibos",    data = tea_data$rooibos) |>
      hc_stern_cat() |>
      hc_tooltip(shared = TRUE, valueSuffix = " cups") |>
      hc_add_theme(hc_theme_stern())
  })

  # Library table
  # NOTE: server = FALSE bundles the rows into the page payload instead of
  # using DT's Ajax server-side mode. With serverSide=TRUE (the default),
  # the table can render as empty if the Ajax round trip is blocked or
  # the URL routing is off (e.g. RStudio Viewer pane, custom proxies).
  output$library_table <- renderDT({
    req(input$genre_filter, input$rating_min)
    df <- library_data
    if (input$genre_filter != "All") {
      df <- df |> filter(Genre == input$genre_filter)
    }
    df <- df |> filter(Avg_Rating >= input$rating_min)

    datatable(
      df,
      rownames = FALSE,
      options = list(
        pageLength = 5,
        lengthMenu = c(5, 10, 25),
        dom = "ftip",
        columnDefs = list(
          list(className = "dt-right", targets = c(2, 3))
        )
      ),
      colnames = c("Title", "Genre", "Checkouts", "Avg rating", "Last checked out")
    )
  }, server = FALSE)

  # Button effects (just message for now)
  observeEvent(input$refresh, {
    showNotification("Refreshing data... (test theme)",
                     type = "message", duration = 2)
  })

  observeEvent(input$export, {
    showNotification("Export triggered (test theme)",
                     type = "default", duration = 2)
  })
}

# ---- Run ------------------------------------------------------------------

shinyApp(ui, server)
