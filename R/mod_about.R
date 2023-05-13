#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_about_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      bs4Dash::box(
        title = "About ZooTraits",
        collapsible = FALSE,
        width = 12,
        shiny::tags$p(
          "TO DO."
        )
      ),
      bs4Dash::box(
        title = "Authors",
        collapsible = TRUE,
        width = 12,
        reactable::reactableOutput(ns("authors_table"))
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

#' about Server Functions
#'
#' @noRd
mod_about_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$authors_table <- reactable::renderReactable({
      authors_list |>
        dplyr::select(-institutions_id) |>
        dplyr::distinct(name, university, .keep_all = TRUE) |>
        dplyr::group_by(name) |>
        dplyr::mutate(desc_group = knitr::combine_words(university)) |>
        dplyr::distinct(name, desc_group) |>
        reactable::reactable(pagination = FALSE,
                             columns = list(
                               name = reactable::colDef(name = "Author", maxWidth = 250),
                               desc_group= reactable::colDef(name = "Institutions", html = TRUE)
                             ))
    })

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
# mod_about_ui("about_1")

## To be copied in the server
# mod_about_server("about_1")
