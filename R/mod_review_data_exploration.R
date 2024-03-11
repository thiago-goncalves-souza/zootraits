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
    fluidRow(
      bs4Dash::box(
        title = "ExploreTrait - Data exploration",
        collapsible = FALSE,
        width = 12,
        "In this page, you can explore distribution and abundance/coverage of
      trait data information from almost ~1,700 manuscripts to investigate trends
      and gaps in traits used on several animal taxonomic groups (reviewed in Gonçalves-Souza et al. 2023). "
      )
    ),
    mod_review_filter_ui(ns("review_filter_1")),
    fluidRow(
      bs4Dash::box(
        title = "Taxonomic groups",
        collapsible = TRUE,
        width = 6,
        echarts4r::echarts4rOutput(ns("chart_taxonomic_groups")) |> waiting(),
        mod_download_table_ui(ns("download_table_2"))
      ),
      bs4Dash::box(
        title = "Trait dimensions",
        collapsible = TRUE,
        width = 6,
        echarts4r::echarts4rOutput(ns("chart_trait_dimension")) |> waiting(),
        mod_download_table_ui(ns("download_table_3"))
      )
    ),
    fluidRow(
      bs4Dash::box(
        title = "Map",
        collapsible = TRUE,
        width = 12,
        p("Most of the studies are grouped by country."),
        leaflet::leafletOutput(ns("map")) |> waiting()
      )
    ),
    fluidRow(
      bs4Dash::box(
        title = "Traits",
        collapsible = TRUE,
        width = 12,
        echarts4r::echarts4rOutput(ns("chart_traits")) |> waiting(),
        mod_download_table_ui(ns("download_table_4"))
      )
    ),
    fluidRow(
      bs4Dash::box(
        title = "ExploreTrait - Dataset download",
        collapsible = TRUE,
        width = 12,
        mod_download_table_ui(ns("download_table_5")),
        reactable::reactableOutput(ns("table")) |> waiting()
      ),
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
        prepare_data_for_line_graph(color_var = "taxonomic_group")


      mod_download_table_server("download_table_2", data_for_chart,
        prefix = "data_for_taxonomic_group_chart"
      )

      category <- data_for_chart |>
        dplyr::group_by(line_var) |>
        dplyr::summarise(soma = sum(n)) |>
        dplyr::arrange(desc(soma)) |>
        dplyr::slice_max(order_by = soma, n = 10) |>
        dplyr::pull(line_var)

      data_for_series_plot <- data_for_chart |>
        dplyr::filter(line_var %in% category) |>
        dplyr::mutate(year_date = lubridate::as_date(paste0(year, "-01-01")))

      bar_linechart(
          data_for_series_plot = data_for_series_plot
        )
    })

    output$chart_trait_dimension <- echarts4r::renderEcharts4r({
      data_for_chart <- review_dataset() |>
        prepare_data_for_bar_echart(x_var = "trait_dimension")

      mod_download_table_server("download_table_3", data_for_chart,
        prefix = "data_for_trait_dimension_chart"
      )

      data_for_chart |>
        bar_echart(
          title_lab = "Most frequent trait dimensions found in the review",
          x_lab = "Number of papers",
          y_lab = "Trait dimension"
        ) |>
        echarts4r::e_add_nested("itemStyle", color)
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
        dplyr::select(-trait_dimension) |>
        dplyr::rename(
          trait_type = trait_type.x,
          trait_dimension = trait_type.y
        )

      data_for_tree_map <- data_tidy |>
        prepare_data_for_treemap_echart(x_var = "general_trait", color = "trait_dimension") |>
        dplyr::filter(name != "Other")

      mod_download_table_server("download_table_4", data_for_tree_map,
        prefix = "data_for_general_trait_chart"
      )


      data_for_tree_map |>
        treemap_echart(
          title_lab = "Number of papers where each trait appeared in the review"
        )
    })

    output$map <- leaflet::renderLeaflet({
      review_map_data |>
        dplyr::mutate(
          code = as.character(code)
        ) |>
        dplyr::left_join(review_dataset(),
          by = "code",
          relationship =
            "many-to-many"
        ) |>
        dplyr::distinct(
          code, id, scale_color, # where,
          CNTR_ID,
          reference, year, doi_html, geometry
        ) |>
        dplyr::mutate(popup_text = glue::glue("
                                              <b>{reference}</b><br>
                                              {doi_html}<br>")) |>
        tidyr::drop_na(reference) |>
        leaflet::leaflet() |>
        leaflet::setView(lng = 0, lat = 0, zoom = 2) |>
        leaflet::addProviderTiles(
          provider = leaflet::providers$Esri.WorldTopoMap,
          group = "ESRI World Topo Map"
        ) |>
        leaflet::addProviderTiles(
          "Esri.WorldImagery",
          group = "ESRI World Imagery"
        ) |>
        leaflet::addProviderTiles(
          leaflet::providers$OpenStreetMap,
          group = "Open Street Map"
        ) |>
        leaflet::addAwesomeMarkers(
          popup = ~popup_text,
          icon = leaflet::awesomeIcons(
            markerColor = ~scale_color,
            icon = "search",
            iconColor = "white",
            library = "ion"
          ),
          clusterOptions = leaflet::markerClusterOptions()
        ) |>
        leaflet::addLayersControl(
          baseGroups = c("ESRI World Topo Map", "ESRI World Imagery", "Open Street Map"),
          options = leaflet::layersControlOptions(collapsed = FALSE)
        )
    })

     mod_download_table_server("download_table_5", review_dataset())

    output$table <- reactable::renderReactable({
      prepared_data <- review_dataset() |>
        dplyr::mutate(details = '<center><i class="fa-solid fa-magnifying-glass-plus"></i></center>') |>
        dplyr::arrange(desc(year)) |>
        dplyr::group_by(code) |>
        dplyr::reframe(
          code = code,
          year = year,
          reference = reference,
          doi_html = doi_html,
          where = where,
          taxonomic_group = prepare_wide_col(taxonomic_group),
          study_scale = prepare_wide_col(study_scale),
          ecosystem = prepare_wide_col(ecosystem),
          trait_type = prepare_wide_col(trait_type),
          trait_dimension = prepare_wide_col(trait_dimension),
        ) |>
        dplyr::distinct() |>
        dplyr::ungroup()

      prepared_data |>
        dplyr::select(-code) |>
        reactable::reactable(
          sortable = TRUE,
          showSortable = TRUE,
          columns =
            list(
              year = reactable::colDef(name = "Year", maxWidth = 70),
              reference = reactable::colDef(name = "Reference", minWidth = 200),
              doi_html = reactable::colDef(name = "DOI", html = TRUE),
              where = reactable::colDef(name = "Where", html = TRUE),
              taxonomic_group = reactable::colDef(name = "Taxonomic group"),
              study_scale = reactable::colDef(name = "Study Scale"),
              ecosystem = reactable::colDef(name = "Ecosystem"),
              trait_dimension = reactable::colDef(name = "Trait Dimensions"),
              trait_type = reactable::colDef(name = "Trait type")
            )
        )
    })
  })
}
