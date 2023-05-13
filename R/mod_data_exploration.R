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
      title = "Welcome to ZooTraits",
      collapsible = FALSE,
      width = 12,
      shiny::tags$p(
        htmltools::includeMarkdown(app_sys("app/www/md/ZooTraits.md")))
    )
  ),
    fluidRow(

      bs4Dash::box(
        title = "Filter",
        collapsible = FALSE,
        width = 12,
        fluidRow(
          column(
            width = 4,
            shinyWidgets::pickerInput(
              inputId = ns("taxonomic_unit"),
              label =  "Taxonomic unit",
              choices = unique(review_data$taxunit),
              selected =  unique(review_data$taxunit),
              options = list(
                `actions-box` = TRUE),
              multiple = TRUE
            )),
          column(
          width = 4,
          shinyWidgets::pickerInput(
            inputId = ns("taxonomic_level"),
            label =  "Taxonomic level",
            choices = unique(review_data$taxon_span),
            selected =  unique(review_data$taxon_span),
            options = list(
              `actions-box` = TRUE),
            multiple = TRUE
          )),
          column(
            width = 4,
          shinyWidgets::pickerInput(
            inputId = ns("taxonomic_group"),
            label =  "Taxonomic group",
            choices = sort(unique(review_data$taxon)),
            selected =  unique(review_data$taxon),
            options = list(
              `actions-box` = TRUE),
            multiple = TRUE
          )
         )
        ),
         fluidRow(
           column(width = 4,
           shinyWidgets::pickerInput(
             inputId = ns("ecosystem"),
             label =  "Ecosystem",
             choices = c("Freshwater", "Marine", "Terrestrial"),
             selected =  c("Freshwater", "Marine", "Terrestrial"),
             options = list(
               `actions-box` = TRUE),
             multiple = TRUE
           )
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
mod_data_exploration_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    review_dataset <- reactive({
      req(input$taxonomic_level)
      req(input$taxonomic_group)
      req(input$taxonomic_unit)
      req(input$ecosystem)

      review_data |>
      dplyr::filter(taxon_span %in% input$taxonomic_level,
                    taxon %in% input$taxonomic_group,
                    taxunit %in% input$taxonomic_unit) |>
        dplyr::filter(ecosystem %in% stringr::str_to_lower(input$ecosystem))


    })

    output$table <- reactable::renderReactable({
      review_dataset() |>
        dplyr::select(year, reference, doi_html, where) |>
        dplyr::mutate(details = '<center><i class="fa-solid fa-magnifying-glass-plus"></i></center>') |>
        dplyr::arrange(desc(year)) |>
        reactable::reactable(sortable = TRUE,
                             columns =
                               list(
                                 year = reactable::colDef(name = "Year", maxWidth = 50),
                                 reference =  reactable::colDef(name = "Reference", minWidth = 200),
                                 doi_html = reactable::colDef(name = "DOI", html = TRUE),
                                 where = reactable::colDef(name = "Where", html = TRUE),
                                 details = reactable::colDef(name = "See more", html = TRUE, maxWidth = 100)
                               ))
    })


  })
}

## To be copied in the UI
# mod_data_exploration_ui("data_exploration_1")

## To be copied in the server
# mod_data_exploration_server("data_exploration_1")
