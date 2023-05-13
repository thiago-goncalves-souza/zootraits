#' data_exploration UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_data_exploration_ui <- function(id){
  ns <- NS(id)

  tagList(
    fluidRow(

      bs4Dash::box(
        title = "Filter",
        collapsible = FALSE,
        width = 12,
        column(
          width = 4,
          fluidRow(
          shinyWidgets::pickerInput(
            inputId = ns("taxonomic_level"),
            label =  "Taxonomic level",
            choices = unique(review_data$taxon_span),
            selected =  unique(review_data$taxon_span),
            options = list(
              `actions-box` = TRUE),
            multiple = TRUE
          )),
          fluidRow(
          shinyWidgets::pickerInput(
            inputId = ns("taxonomic_group"),
            label =  "Taxonomic group",
            choices = sort(unique(review_data$taxon)),
            selected =  unique(review_data$taxon),
            options = list(
              `actions-box` = TRUE),
            multiple = TRUE
          )
         ),

         # fluidRow(
         #   shinyWidgets::pickerInput(
         #     inputId = ns("ecosystem"),
         #     label =  "Ecosystem",
         #     choices = c("Freshwater", "Marine", "Terrestrial"),
         #     selected =  c("Freshwater", "Marine", "Terrestrial"),
         #     options = list(
         #       `actions-box` = TRUE),
         #     multiple = TRUE
         #   )
         # ),
        )
      ),
      bs4Dash::box(
        title = "Dataset",
        collapsible = TRUE,
        width = 12,
        reactable::reactableOutput(ns("table"))
      ),
    )

  )
}

#' data_exploration Server Functions
#'
#' @noRd
mod_data_exploration_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    review_dataset <- reactive({
      req(input$taxonomic_level)
      req(input$taxonomic_group)
      # req(input$ecosystem)


     #  browser()

      # filter_ecosystem_freshwater <- dplyr::if_else("Freshwater" %in% input$ecosystem, 1, 0)

      review_data |>
      dplyr::filter(taxon_span %in% input$taxonomic_level,
                    taxon %in% input$taxonomic_group)

    })

    output$table <- reactable::renderReactable({
      review_dataset() |>
        reactable::reactable()
    })


  })
}

## To be copied in the UI
# mod_data_exploration_ui("data_exploration_1")

## To be copied in the server
# mod_data_exploration_server("data_exploration_1")
