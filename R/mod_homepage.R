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
    tagList(
      bs4Dash::box(
        title = "ZooTraits",
        collapsible = FALSE,
        width = 12,
        "TODO"
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
  })
}

## To be copied in the UI
# mod_homepage_ui("homepage_1")

## To be copied in the server
# mod_homepage_server("homepage_1")
