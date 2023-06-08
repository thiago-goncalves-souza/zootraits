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
        title = "Filter",
        collapsible = FALSE,
        width = 12,
        fluidRow(
          picker_input(
            inputId = ns("taxon_higher_level_1"),
            label =  "Taxonomic group",
            choices = options_input(review_data$taxon_higher_level_1),
            selected =  options_input(review_data$taxon_higher_level_1)
          ),
          picker_input(
            inputId = ns("ecosystem"),
            label =  "Ecosystem",
            choices = options_input(review_data$ecosystem),
            selected =  options_input(review_data$ecosystem)
          ),
          picker_input(
            inputId = ns("study_scale"),
            label =  "Study Scale",
            choices = options_input(review_data$study_scale),
            selected =  options_input(review_data$study_scale)
          )
        ),
        fluidRow(
          picker_input(
            inputId = ns("trait_type"),
            label = "Trait type",
            choices = options_input(review_data$trait_type),
            selected = options_input(review_data$trait_type)
          ),
          picker_input(
            inputId = ns("trait_dimension"),
            label = "Trait dimension",
            choices = options_input(review_data$trait_dimension),
            selected = options_input(review_data$trait_dimension)
          ),
          picker_input(
            inputId = ns("intraspecific_data"),
            label = "Intraspecific data",
            choices = options_input(review_data$intraspecific_data),
            selected = options_input(review_data$intraspecific_data)
          )
        ),
        fluidRow(
          shiny::actionButton(inputId = ns("search"), label = "Search")
        )
      )),
    fluidRow(
      bs4Dash::box(
        title = "Higher taxonomic groups",
        collapsible = TRUE,
        width = 6,
        echarts4r::echarts4rOutput(ns("chart_taxonomic_groups")) |> waiting()
      ),
      bs4Dash::box(
        title = "Trait dimensions",
        collapsible = TRUE,
        width = 6,
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
        # wordcloud2::wordcloud2Output(ns("chart_general_trait")) |> waiting()
      )
    ),

    fluidRow(
      bs4Dash::box(
        title = "General traits",
        collapsible = TRUE,
        width = 12,
        echarts4r::echarts4rOutput(ns("chart_traits")) |> waiting()
        # wordcloud2::wordcloud2Output(ns("chart_general_trait")) |> waiting()
      )
    ),

    fluidRow(
      bs4Dash::box(
        title = "Dataset",
        collapsible = TRUE,
        width = 12,
        mod_download_table_ui(ns("download_table_1")),

        reactable::reactableOutput(ns("table") ) |> waiting()
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

      review_dataset <- reactive({

        input$search
        isolate({
          req(input$taxon_higher_level_1)
          req(input$ecosystem)
          req(input$study_scale)
          req(input$trait_type)
          req(input$trait_dimension)

          review_data |>
            dplyr::filter(
              taxon_higher_level_1 %in% input$taxon_higher_level_1
            ) |>
            dplyr::filter(
              ecosystem %in% prepare_input_to_filter(input$ecosystem),
              study_scale %in% prepare_input_to_filter(input$study_scale),
              trait_type %in% prepare_input_to_filter(input$trait_type),
              trait_dimension %in% prepare_input_to_filter(input$trait_dimension),
              intraspecific_data %in% prepare_input_to_filter(input$intraspecific_data)
            )
        })

    })


    output$chart_taxonomic_groups <- echarts4r::renderEcharts4r({
      review_dataset() |>
        bar_echart(x_var = "taxon_higher_level_1")
    })

    output$chart_trait_dimension <- echarts4r::renderEcharts4r({
      review_dataset() |>
        bar_echart(x_var = "trait_dimension")
    })


    output$chart_traits <- echarts4r::renderEcharts4r({
       data_tidy <- review_dataset() |>
          tidyr::separate_longer_delim(cols = "trait_details", delim = ";") |>
          dplyr::mutate(trait_details = stringr::str_to_lower(trait_details),
                        trait_details = stringr::str_squish(trait_details)) |>
          dplyr::left_join(trait_information,
                           by = "trait_details",
                           relationship = "many-to-many") |>
          dplyr::select(-trait_type.y) |>
          dplyr::rename(trait_type = trait_type.x)

       data_tidy |>
         treemap_echart(x_var = "general_trait")
    })

    output$map <- leaflet::renderLeaflet({
      # TO DO
      review_map_data |>
        dplyr::left_join(review_dataset(),
                          by = "code",
                          relationship =
                           "many-to-many") |>
        dplyr::distinct(code, id, scale_color, where_fixed,
                        CNTR_ID,
                        reference, year, doi_html, geometry) |>
        dplyr::mutate(popup_text = glue::glue("
                                              <b>{reference}</b><br>
                                              {doi_html}<br>")) |>
        tidyr::drop_na(reference) |>
        leaflet::leaflet()  |>
        leaflet::setView(lng = 0, lat = 0, zoom = 2) |>
        leaflet::addProviderTiles(provider = leaflet::providers$OpenStreetMap) |>
        leaflet::addAwesomeMarkers(popup = ~ popup_text,
                                   icon = leaflet::awesomeIcons(
                                     markerColor = ~scale_color,
                                     icon = 'search',
                                     iconColor = 'white',
                                     library = 'ion'
                                   ),
                                   clusterOptions = leaflet::markerClusterOptions()
        )
    })


    # output$chart_general_trait <- wordcloud2::renderWordcloud2({
    #   review_dataset() |>
    #     tidyr::separate_longer_delim(cols = "trait_details", delim = ";") |>
    #     dplyr::mutate(trait_details = stringr::str_to_lower(trait_details),
    #                   trait_details = stringr::str_squish(trait_details)) |>
    #     dplyr::left_join(trait_information,
    #                      by = "trait_details",
    #                      relationship = "many-to-many") |>
    #     dplyr::select(-trait_type.y) |>
    #     dplyr::rename(trait_type = trait_type.x) |>
    #     wordcloud_chart(var = "general_trait")
    # })

    mod_download_table_server("download_table_1", review_dataset())

    output$table <- reactable::renderReactable({
      prepared_data <- review_dataset() |>
        dplyr::mutate(details = '<center><i class="fa-solid fa-magnifying-glass-plus"></i></center>') |>
        dplyr::arrange(desc(year)) |>
        dplyr::group_by(code) |>
        dplyr::summarise(
          code = code,
          year = year,
          reference = reference,
          doi_html = doi_html,
          where = where,
          taxon = prepare_wide_col(taxon),
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
          columns =
            list(
              year = reactable::colDef(name = "Year", maxWidth = 50),
              reference = reactable::colDef(name = "Reference", minWidth = 200),
              doi_html = reactable::colDef(name = "DOI", html = TRUE),
              where = reactable::colDef(name = "Where", html = TRUE),
              taxon = reactable::colDef(name = "Taxon"),
              study_scale = reactable::colDef(name = "Study Scale"),
              ecosystem = reactable::colDef(name = "Ecosystem"),
              trait_dimension = reactable::colDef(name = "Trait Dimensions"),
              trait_type = reactable::colDef(name = "Trait type")
            )
        )
    })
  })
}
