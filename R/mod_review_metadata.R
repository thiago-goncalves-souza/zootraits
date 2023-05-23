#' review_metadata UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_review_metadata_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::box(
      title = "Metadata",
      collapsible = FALSE,
      width = 12,
      reactable::reactableOutput(ns("table"))
    )
  )
}

#' review_metadata Server Functions
#'
#' @noRd
mod_review_metadata_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
   output$table <- reactable::renderReactable({
     metadata_raw |>
       reactable::reactable(pagination = FALSE,
         columns =
           list(
             name_var = reactable::colDef(name = "Variable", maxWidth = 200),
             class_var = reactable::colDef(name = "Class", maxWidth = 100),
             options_var = reactable::colDef(name = "Categories"),
             description = reactable::colDef(name = "Description", maxWidth = 400)
           )
       )
   })

  })
}

## To be copied in the UI
# mod_review_metadata_ui("review_metadata_1")

## To be copied in the server
# mod_review_metadata_server("review_metadata_1")
