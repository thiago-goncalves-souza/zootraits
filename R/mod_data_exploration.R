#' data_exploration UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_data_exploration_ui <- function(id) {
  ns <- NS(id)

  tagList(
    fluidRow(
      bs4Dash::box(
        title = "Welcome to ZooTraits",
        collapsible = FALSE,
        width = 12,
        shiny::tags$p(
          htmltools::includeMarkdown(app_sys("app/www/md/ZooTraits.md"))
        )
      )
    ),
    fluidRow(
      bs4Dash::box(
        title = "Filter",
        collapsible = FALSE,
        width = 12,
        fluidRow(
          picker_input(
            inputId = ns("taxonomic_unit"),
            label =  "Taxonomic unit",
            choices = unique(review_data$taxunit),
            selected =  unique(review_data$taxunit)
          ),
          picker_input(
            inputId = ns("taxonomic_level"),
            label =  "Taxonomic level",
            choices = unique(review_data$taxon_span),
            selected =  unique(review_data$taxon_span)
          ),
          picker_input(
            inputId = ns("taxonomic_group"),
            label =  "Taxonomic group",
            choices = options_input(review_data$taxon),
            selected =  options_input(review_data$taxon)
          )
        ),
        fluidRow(
          picker_input(
            inputId = ns("ecosystem"),
            label =  "Ecosystem",
            choices = options_input(review_data$ecosystem),
            selected =  options_input(review_data$ecosystem)
          ),
          picker_input(
            inputId = ns("study_scale"),
            label =  "Study Scale",
            choices = options_input(review_data$study_scale),
            selected =  options_input(review_data$study_scale)
          ),
        ),
        fluidRow(
          picker_input(
            inputId = ns("trait_type"),
            label = "Trait type",
            choices = options_input(review_data$trait_type),
            selected = options_input(review_data$trait_type)
          ),
          picker_input(
            inputId = ns("trait_dimension"),
            label = "Trait dimension",
            choices = options_input(review_data$trait_dimension),
            selected = options_input(review_data$trait_dimension)
          ),
          picker_input(
            inputId = ns("intraspecific_data"),
            label = "Intraspecific data",
            choices = options_input(review_data$intraspecific_data),
            selected = options_input(review_data$intraspecific_data)
          )
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
mod_data_exploration_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    review_dataset <- reactive({
      req(input$taxonomic_level)
      req(input$taxonomic_group)
      req(input$taxonomic_unit)
      req(input$ecosystem)
      req(input$study_scale)
      req(input$trait_type)
      req(input$trait_dimension)

      review_data |>
        dplyr::filter(
          taxon_span %in% input$taxonomic_level,
          taxon %in% input$taxonomic_group,
          taxunit %in% input$taxonomic_unit
        ) |>
        dplyr::filter(
          ecosystem %in% prepare_input_to_filter(input$ecosystem),
          study_scale %in% prepare_input_to_filter(input$study_scale),
          trait_type %in% prepare_input_to_filter(input$trait_type),
          trait_dimension %in% prepare_input_to_filter(input$trait_dimension),
          intraspecific_data %in% prepare_input_to_filter(input$intraspecific_data)
        )
    })

    output$table <- reactable::renderReactable({
      review_dataset() |>
        dplyr::select(year, reference, doi_html, where) |>
        dplyr::mutate(details = '<center><i class="fa-solid fa-magnifying-glass-plus"></i></center>') |>
        dplyr::arrange(desc(year)) |>
        dplyr::distinct() |>
        reactable::reactable(
          sortable = TRUE,
          columns =
            list(
              year = reactable::colDef(name = "Year", maxWidth = 50),
              reference = reactable::colDef(name = "Reference", minWidth = 200),
              doi_html = reactable::colDef(name = "DOI", html = TRUE),
              where = reactable::colDef(name = "Where", html = TRUE),
              details = reactable::colDef(name = "See more", html = TRUE, maxWidth = 100)
            )
        )
    })
  })
}

## To be copied in the UI
# mod_data_exploration_ui("data_exploration_1")

## To be copied in the server
# mod_data_exploration_server("data_exploration_1")
