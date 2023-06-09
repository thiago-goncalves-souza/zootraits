#' data_exploration UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_review_data_exploration_ui <- function(id) {
  ns <- NS(id)

  tagList(
    mod_review_filter_ui(ns("review_filter_1")),
    fluidRow(
      bs4Dash::box(
        title = "Higher taxonomic groups",
        collapsible = TRUE,
        width = 6,
        mod_download_table_ui(ns("download_table_2")),
        echarts4r::echarts4rOutput(ns("chart_taxonomic_groups")) |> waiting()
      ),
      bs4Dash::box(
        title = "Trait dimensions",
        collapsible = TRUE,
        width = 6,
        mod_download_table_ui(ns("download_table_3")),
        echarts4r::echarts4rOutput(ns("chart_trait_dimension")) |> waiting()
      )
    ),
    fluidRow(
      bs4Dash::box(
        title = "Map",
        collapsible = TRUE,
        width = 12,
        p("Not every paper is shown in the map.
          The studies are grouped by country."),
        br(),
        leaflet::leafletOutput(ns("map")) |> waiting()
      )
    ),
    fluidRow(
      bs4Dash::box(
        title = "General traits",
        collapsible = TRUE,
        width = 12,
        mod_download_table_ui(ns("download_table_4")),
        echarts4r::echarts4rOutput(ns("chart_traits")) |> waiting()
      )
    )
  )
}

#' data_exploration Server Functions
#'
#' @noRd
mod_review_data_exploration_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    review_dataset <- mod_review_filter_server("review_filter_1")


    output$chart_taxonomic_groups <- echarts4r::renderEcharts4r({
      data_for_chart <- review_dataset() |>
        prepare_data_for_bar_echart(x_var = "taxonomic_group")

      mod_download_table_server("download_table_2", data_for_chart,
        prefix = "data_for_taxonomic_group_chart"
      )

      data_for_chart |>
        bar_echart()
    })

    output$chart_trait_dimension <- echarts4r::renderEcharts4r({
      data_for_chart <- review_dataset() |>
        prepare_data_for_bar_echart(x_var = "trait_dimension")

      mod_download_table_server("download_table_3", data_for_chart,
        prefix = "data_for_trait_dimension_chart"
      )

      data_for_chart |>
        bar_echart()
    })


    output$chart_traits <- echarts4r::renderEcharts4r({
      data_tidy <- review_dataset() |>
        tidyr::separate_longer_delim(cols = "trait_details", delim = ";") |>
        dplyr::mutate(
          trait_details = stringr::str_to_lower(trait_details),
          trait_details = stringr::str_squish(trait_details)
        ) |>
        dplyr::left_join(trait_information,
          by = "trait_details",
          relationship = "many-to-many"
        ) |>
        dplyr::select(-trait_type.y) |>
        dplyr::rename(trait_type = trait_type.x)

      data_for_tree_map <- data_tidy |>
        prepare_data_for_treemap_echart(x_var = "general_trait")

      mod_download_table_server("download_table_4", data_for_tree_map,
        prefix = "data_for_general_trait_chart"
      )


      data_for_tree_map |>
        treemap_echart()
    })

    output$map <- leaflet::renderLeaflet({
      review_map_data |>
        dplyr::left_join(review_dataset(),
          by = "code",
          relationship =
            "many-to-many"
        ) |>
        dplyr::distinct(
          code, id, scale_color, where_fixed,
          CNTR_ID,
          reference, year, doi_html, geometry
        ) |>
        dplyr::mutate(popup_text = glue::glue("
                                              <b>{reference}</b><br>
                                              {doi_html}<br>")) |>
        tidyr::drop_na(reference) |>
        leaflet::leaflet() |>
        leaflet::setView(lng = 0, lat = 0, zoom = 2) |>
        leaflet::addProviderTiles(provider = leaflet::providers$OpenStreetMap) |>
        leaflet::addAwesomeMarkers(
          popup = ~popup_text,
          icon = leaflet::awesomeIcons(
            markerColor = ~scale_color,
            icon = "search",
            iconColor = "white",
            library = "ion"
          ),
          clusterOptions = leaflet::markerClusterOptions()
        )
    })


  })
}
