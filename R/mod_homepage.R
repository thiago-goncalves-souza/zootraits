#' homepage UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_homepage_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      bs4Dash::box(
        title = "About ZooTraits",
        collapsible = FALSE,
        width = 12,
        shiny::tags$p(
          htmltools::includeMarkdown(app_sys("app/www/md/ZooTraits.md"))
        )
      ),
      bs4Dash::box(
        title = "Supporting institutions",
        collapsible = FALSE,
        width = 12,
        shiny::htmlOutput(ns("logos_institutions"))
      )
    )
  )
}

#' homepage Server Functions
#'
#' @noRd
mod_homepage_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$logos_institutions <- shiny::renderUI({
      img_institutions <- institutions |>
        tidyr::drop_na(img) |>
        dplyr::mutate(img_html = glue::glue("<a href='{url}' target='_blank'><img src='www/logos/{img}' style='max-width: 50%;'></a>")) |>
        dplyr::pull(img_html) |>
        paste0(collapse = " <br> ")

      HTML(paste0("<center>", img_institutions, "</center>"))
    })
  })
}

## To be copied in the UI
# mod_homepage_ui("homepage_1")

## To be copied in the server
# mod_homepage_server("homepage_1")
