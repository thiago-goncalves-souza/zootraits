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
            HTML("- Fill out the template above. <br>
                 - Make sure to create one row for each paper or one row for each taxonomic group in case the same paper studied multiple taxonomic groups. <br>
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
                  ".xlsx"
                )
              )
            )
          )
        ),
        bs4Dash::box(
          title = "Review and submit",
          collapsible = FALSE,
          width = 12,
          fluidRow(
            reactable::reactableOutput(
              outputId = ns("uploaded_table"),
              width = "100%"
            )
          ),
          fluidRow(
            div(
              style = "display: flex; justify-content: center;",
              shiny::actionButton(
                inputId = ns("send_suggestion_csv"),
                label = "Submit your suggestion",
                icon = shiny::icon("plus")
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

    file_template <- tibble::tibble(
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

    output$download_template_csv <- shiny::downloadHandler(
      filename = "feedtraits_template.xlsx",
      content = function(file) {
        writexl::write_xlsx(x = file_template, path = file)
      }
    )


    uploaded_data <- reactive({
      req(input$upload_template)

      raw_uploaded_data <- readxl::read_xlsx(path = input$upload_template$datapath)

      raw_uploaded_data
    })

    #

    # Create an InputValidator object
    input_validator_csv <- shinyvalidate::InputValidator$new()
    input_validator_csv$add_rule("upload_template", shinyvalidate::sv_required())

    output$uploaded_table <- reactable::renderReactable({
      uploaded_data() |>
        reactable::reactable()
    })



    observeEvent(input$send_suggestion_csv, {
      # 4. Don't proceed if any input is invalid

      names_data_uploaded <- names(uploaded_data())
      names_file_template <- names(file_template)
      waldo_comp <- waldo::compare(names_data_uploaded, names_file_template, x_arg = "uploaded_file", y_arg = "template_file")
      waldo_comp

      if (length(waldo_comp) > 0) {
        showNotification(
          glue::glue("The data uploaded does not have the same columns as the template.

          Please use the template."),
          type = "error"
        )
      } else if (input_validator_csv$is_valid()) {
        # 5. If all inputs are valid, proceed

        # generating an id to be used in the code column
        sys_time <- Sys.time()
        date_time_text <- stringr::str_extract_all(sys_time, pattern = "(\\d)+") |>
          unlist() |>
          paste0(collapse = "")

        code <- paste0("c_", date_time_text, collapse = "")

        paper_to_add <- uploaded_data() |>
          dplyr::mutate(
            verified = FALSE,
            code = code,
            .before = tidyselect::everything()
          ) |>
          dplyr::select(
            -contributor_name, -contributor_orcid,
            -contributor_affiliation
          ) |>
          dplyr::mutate(
            date_time = sys_time, .before = contributor_email
          )

        contributor_to_add <- uploaded_data() |>
          dplyr::select(tidyselect::starts_with(
            "contributor_"
          )) |>
          dplyr::mutate(date_time = sys_time) |>
          dplyr::mutate(
            code = code,
            .before = tidyselect::everything()
          )

        googlesheets4::sheet_append(
          ss = "1nStfAOwUvUuVC4Xo3ArI8i1Be9TxGNdmntfn87OGSy4",
          data = paper_to_add,
          sheet = "papers"
        )

        googlesheets4::sheet_append(
          ss = "1nStfAOwUvUuVC4Xo3ArI8i1Be9TxGNdmntfn87OGSy4",
          data = contributor_to_add,
          sheet = "contributors"
        )

        shinyalert::shinyalert(
          title = "Suggestion sent!",
          text = "Thank you for your contribution. The Zootraits team will review your suggestion.",
          size = "s",
          closeOnEsc = TRUE,
          closeOnClickOutside = FALSE,
          html = TRUE,
          type = "success",
          showConfirmButton = TRUE,
          showCancelButton = FALSE,
          confirmButtonText = "OK",
          confirmButtonCol = "#AEDEF4",
          timer = 0,
          imageUrl = "",
          animation = TRUE
        )
      } else {
        showNotification(
          "Please upload the file before continuing",
          type = "warning"
        )
      }
    })
  })
}

## To be copied in the UI
# mod_feedtrait_add_with_file_ui("feedtrait_add_with_file_1")

## To be copied in the server
# mod_feedtrait_add_with_file_server("feedtrait_add_with_file_1")
