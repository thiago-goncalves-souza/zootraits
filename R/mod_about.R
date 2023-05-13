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
        shiny::tags$p(
          "TO DO."
        )
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
        dplyr::mutate(desc2 = glue::glue("- {desc} <br>")) |>
        dplyr::group_by(name) |>
        dplyr::mutate(desc_group = paste0(desc2, collapse = "\n")
        ) |>
        dplyr::distinct(name, desc_group) |>
        reactable::reactable(pagination = FALSE,
                             columns = list(
                               name = reactable::colDef(name = "Author", maxWidth = 250),
                               desc_group= reactable::colDef(name = "Institutions", html = TRUE)
                             ))
    })


  })
}

## To be copied in the UI
# mod_about_ui("about_1")

## To be copied in the server
# mod_about_server("about_1")