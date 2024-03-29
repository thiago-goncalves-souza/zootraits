#' review_filter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_review_filter_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      bs4Dash::box(
        title = "Filter",
        collapsible = FALSE,
        width = 12,
        fluidRow(
          picker_input(
            inputId = ns("taxonomic_group"),
            label =  "Taxonomic group",
            choices = options_input(complete_review_data$taxonomic_group),
            selected =  NULL
          ),
          picker_input(
            inputId = ns("ecosystem"),
            label =  "Ecosystem",
            choices = options_input(complete_review_data$ecosystem),
            selected =  options_input(complete_review_data$ecosystem)
          ),
          picker_input(
            inputId = ns("study_scale"),
            label =  "Study Scale",
            choices = options_input(complete_review_data$study_scale),
            selected =  options_input(complete_review_data$study_scale)
          )
        ),
        fluidRow(
          picker_input(
            inputId = ns("trait_type"),
            label = "Trait type",
            choices = options_input(complete_review_data$trait_type),
            selected = options_input(complete_review_data$trait_type)
          ),
          picker_input(
            inputId = ns("trait_dimension"),
            label = "Trait dimension",
            choices = options_input(complete_review_data$trait_dimension),
            selected = options_input(complete_review_data$trait_dimension)
          ),
          picker_input(
            inputId = ns("intraspecific_data"),
            label = "Intraspecific data",
            choices = options_input(complete_review_data$intraspecific_data),
            selected = options_input(complete_review_data$intraspecific_data)
          )
        ),
        fluidRow(
          shiny::actionButton(inputId = ns("search"), label = "Search")
        )
      )
    )
  )
}

#' review_filter Server Functions
#'
#' @noRd
mod_review_filter_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    review_dataset <- reactive({
      input$search
      isolate({
        req(input$ecosystem)
        req(input$study_scale)
        req(input$trait_type)
        req(input$trait_dimension)


        taxonomic_group_filtrar <-
          prepare_input_to_filter_taxonomic_group(
            input_filtro = input$taxonomic_group,
            col_name = "taxonomic_group",
            dataset = complete_review_data
          )


        complete_review_data |>
          dplyr::filter(
            taxonomic_group %in% taxonomic_group_filtrar
          ) |>
          dplyr::filter(
            ecosystem %in% prepare_input_to_filter(input$ecosystem),
            study_scale %in% prepare_input_to_filter(input$study_scale),
            trait_type %in% prepare_input_to_filter(input$trait_type),
            trait_dimension %in% prepare_input_to_filter(input$trait_dimension),
            intraspecific_data %in% prepare_input_to_filter(input$intraspecific_data)
          )
      })
    })
  })
}

## To be copied in the UI
# mod_review_filter_ui("review_filter_1")

## To be copied in the server
# mod_review_filter_server("review_filter_1")
