#' otn UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_otn_explore_ui <- function(id){
  ns <- NS(id)
  tagList(

  )
}

#' otn Server Functions
#'
#' @noRd
mod_otn_explore_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}
