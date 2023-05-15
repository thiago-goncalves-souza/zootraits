#' download_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        class = "text-right",
        width = 12,
        downloadButton(ns("download_data"), "Download")
      )
    )
  )
}

#' download_table Server Functions
#'
#' @noRd
mod_download_table_server <- function(id, dataset){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    output$download_data <- downloadHandler(
      filename = function() {
        paste("Zootraits_review-", Sys.Date(), ".xlsx", sep = "")
      },
      content = function(file) {
        writexl::write_xlsx(dataset, file)
      }
    )


  })
}

## To be copied in the UI
# mod_download_table_ui("download_table_1")

## To be copied in the server
# mod_download_table_server("download_table_1")
