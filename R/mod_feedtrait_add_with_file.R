#' feedtrait_add_with_file UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_feedtrait_add_with_file_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      bs4Dash::box(
        title = "Contribute by submitting a file",
        collapsible = TRUE,
        collapsed = FALSE,
        width = 12,
        status = "primary",
        solidHeader = TRUE,

        bs4Dash::box(
          title = "Download the file template",
          collapsible = FALSE,
          width = 12,
          fluidRow(
            div(
              style = "display: flex; justify-content: center;",
              downloadButton(outputId = ns("download_template"),
                             label = "Download",
                             icon = icon("download"),
                             width = "20%")
            )
          )
        ),
        bs4Dash::box(
          title = "Upload the file",
          collapsible = FALSE,
          width = 12,
          fluidRow(
            HTML("Fill out the template. Make sure to create one row for each
               paper. Use the section below in this page as a guide to know
               what are the
               options to use in each column. In case you need to
               add more than one category in a column, make sure to
               separate the content with a semicolon `; `.")
          ),
          br(), br(),
          fluidRow(
            div(
              style = "display: flex; justify-content: center;",
              fileInput(
                inputId = ns("upload_template"),
                label = "Upload the file",
                multiple = FALSE
              )
            )
          )
        )
      )
    )
  )
}

#' feedtrait_add_with_file Server Functions
#'
#' @noRd
mod_feedtrait_add_with_file_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_feedtrait_add_with_file_ui("feedtrait_add_with_file_1")

## To be copied in the server
# mod_feedtrait_add_with_file_server("feedtrait_add_with_file_1")
