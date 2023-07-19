#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_about_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      bs4Dash::box(
        title = "Authors",
        collapsible = TRUE,
        width = 12,
        leaflet::leafletOutput(ns("authors_map")),
        br(),
        reactable::reactableOutput(ns("authors_table"))
      )
    )
  )
}

#' about Server Functions
#'
#' @noRd
mod_about_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$authors_table <- reactable::renderReactable({
      authors_list |>
        dplyr::select(-institutions_id) |>
        dplyr::distinct(name, university, .keep_all = TRUE) |>
        dplyr::group_by(name) |>
        dplyr::mutate(desc_group = knitr::combine_words(university)) |>
        dplyr::distinct(name, desc_group) |>
        reactable::reactable(
          pagination = FALSE,
          columns = list(
            name = reactable::colDef(name = "Author", maxWidth = 250),
            desc_group = reactable::colDef(name = "Institutions", html = TRUE)
          )
        )
    })


    output$authors_map <- leaflet::renderLeaflet({
      authors_list |>
        tidyr::drop_na(lat, long) |>
        dplyr::distinct(name, lat, long) |>
        leaflet::leaflet() |>
        leaflet::setView(lng = -50, lat = 0, zoom = 2) |>
        leaflet::addProviderTiles(provider = leaflet::providers$OpenStreetMap) |>
        leaflet::addMarkers(
          lng = ~long, lat = ~lat, popup = ~name,
          clusterOptions = leaflet::markerClusterOptions()
        )
    })
  })
}

## To be copied in the UI
# mod_about_ui("about_1")

## To be copied in the server
# mod_about_server("about_1")
