#' otn_about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_otn_about_ui <- function(id){
  ns <- NS(id)
  tagList(

  )
}

#' otn_about Server Functions
#'
#' @noRd
mod_otn_about_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_otn_about_ui("otn_about_1")

## To be copied in the server
# mod_otn_about_server("otn_about_1")
