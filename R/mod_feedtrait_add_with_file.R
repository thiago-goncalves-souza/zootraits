#' feedtrait_add_with_file UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_feedtrait_add_with_file_ui <- function(id) {
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
              shiny::downloadButton(
                outputId = ns("download_template_csv"),
                label = "Download",
                icon = icon("download")
              )
            )
          )
        ),
        bs4Dash::box(
          title = "Upload the file",
          collapsible = FALSE,
          width = 12,
          fluidRow(
            HTML("- Fill out the template. <br>
                 - Make sure to create one row for each paper. <br>
               - Use the section below in this page as a guide to know
               what are the options to use in each column. <br>
               - In case you need to
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
                multiple = FALSE,
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv"
                )
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
mod_feedtrait_add_with_file_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$download_template_csv <- shiny::downloadHandler(
      filename = "feedtraits_template.csv",
      content = function(file) {
        template <- tibble::tibble(
          paper_title = as.character(),
          paper_doi = as.character(),
          paper_url = as.character(),
          paper_author = as.character(),
          paper_journal = as.character(),
          paper_year = as.character(),
          study_scale = as.character(),
          ecosystem = as.character(),
          where = as.character(),
          taxonomic_unit = as.character(),
          taxonomic_group = as.character(),
          latitude = as.character(),
          longitude = as.character(),
          trait_type = as.character(),
          intraspecific_data = as.character(),
          trait_dimension = as.character(),
          trait_details = as.character(),
          trait_details_other = as.character(),
          contributor_name = as.character(),
          contributor_email = as.character(),
          contributor_affiliation = as.character(),
          contributor_orcid = as.character(),
        ) |>
          tibble::add_row()

        readr::write_csv(x = template, file = file)
      }
    )
  })
}

## To be copied in the UI
# mod_feedtrait_add_with_file_ui("feedtrait_add_with_file_1")

## To be copied in the server
# mod_feedtrait_add_with_file_server("feedtrait_add_with_file_1")
