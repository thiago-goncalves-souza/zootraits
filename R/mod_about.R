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
        title = "Authors of the Zootraits",
        collapsible = TRUE,
        width = 12,
        shiny::HTML("<b>Corresponding author</b>: <a href='mailto:tgoncalv@umich.edu'>Thiago Gonçalves-Souza</a>"),
        br(),
        br(),
        leaflet::leafletOutput(ns("authors_map")),
        br(),
        reactable::reactableOutput(ns("authors_table"))
      ),
      bs4Dash::box(
        title = "Contributors of FeedTrait",
        collapsible = TRUE,
        width = 12,
        reactable::reactableOutput(ns("contributors_table"))
      ),
      bs4Dash::box(
        title = "Authors of the Open Traits Network",
        collapsible = TRUE,
        width = 12,
        shiny::HTML("Please visit the <a href='https://opentraits.org/members' target='_blank'>Open Traits Network members pages</a> to see a list of the current members.")
      ),
      bs4Dash::box(
        title = "Citation",
        collapsible = FALSE,
        width = 12,
        shiny::tags$p(
          htmltools::includeMarkdown(app_sys("app/www/md/how-to-cite.md"))
        )
      ),
      bs4Dash::box(
        title = "License",
        collapsible = FALSE,
        width = 12,
        shiny::tags$p(
          htmltools::includeMarkdown(app_sys("app/www/md/license.md"))
        )
      ),
      bs4Dash::box(
        title = "App",
        collapsible = TRUE,
        width = 12,
        htmltools::includeMarkdown(app_sys("app/www/md/dev.md"))
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
            desc_group = reactable::colDef(name = "Affiliation", html = TRUE)
          )
        )
    })

    output$contributors_table <- reactable::renderReactable({
      contributors_list |>
        dplyr::transmute(
          name = contributor_name,
          affiliation = contributor_affiliation,
          contact = glue::glue(
            "<a href='mailto:{contributor_email}'>{fontawesome::fa('envelope')}</a>
            <a href='{contributor_orcid}' target='blank'>{fontawesome::fa('orcid')}</a>"
          )
        ) |>
        reactable::reactable(
          pagination = FALSE,
          columns = list(
            name = reactable::colDef(name = "Contributor name", maxWidth = 250),
            affiliation = reactable::colDef(name = "Affiliation", html = TRUE),
            contact = reactable::colDef(name = "Contact", html = TRUE)
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
