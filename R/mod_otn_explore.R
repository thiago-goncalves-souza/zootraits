#' otn UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#'
#  otn_filter_cols   |> dplyr::glimpse()
#  Rows: 323,201
# Columns: 4
# $ resolve_kingdom_name <chr> "Animalia", "Animalia", NA, NA, "Animalia", "Animalia", "Animalia", "Animalia", "Animalia", "Animalia", "Animalia", NA, "Ani…
# $ resolved_phylum_name <chr> "Echinodermata", "Mollusca", NA, NA, "Chordata", "Chordata", "Echinodermata", "Chordata", "Chordata", "Chordata", "Chordata"…
# $ resolved_family_name <chr> "Schizasteridae", "Semelidae", NA, NA, "Cyprinidae", "Centrarchidae", "Acanthasteridae", "Fringillidae", "Acanthisittidae", …
# $ resolved_name        <chr> "Abatus cordatus", "Abra segmentum", "Abralia trigonura", "Abraliopsis morisii", "Abramis brama", "Acantharchus pomotis", "A…

mod_otn_explore_ui <- function(id) {
  ns <- NS(id)

  tagList(
    bs4Dash::box(
      title = "Filter",
      collapsible = FALSE,
      width = 12,
      fluidRow(
        picker_input(
          inputId = ns("kingdom_name"),
          label = "Kingdom",
          choices = unique(otn_filter_cols$resolve_kingdom_name),
          selected = unique(otn_filter_cols$resolve_kingdom_name),
          multiple = TRUE, search = TRUE,
          width = 12
        )
      ),
      fluidRow(
        picker_input(
          inputId = ns("phylum_name"),
          label = "Phylum",
          choices = unique(otn_filter_cols$resolved_phylum_name),
          selected = unique(otn_filter_cols$resolved_phylum_name),
          multiple = TRUE, search = TRUE,
          width = 12
        ),
      ),
      fluidRow(
        picker_input(
          inputId = ns("family_name"),
          label = "Family",
          choices = unique(otn_filter_cols$resolved_family_name),
          selected = unique(otn_filter_cols$resolved_family_name),
          multiple = TRUE, search = TRUE,
          width = 12
        ),
      )
      # fluidRow(
      #   picker_input(
      #     inputId = ns("genus_name"),
      #     label = "Genus",
      #     choices = unique(otn_filter_cols$resolved_genus_name),
      #     selected = unique(otn_filter_cols$resolved_genus_name),
      #     multiple = TRUE, width = 12, search = TRUE
      #   )
      # ),

      # fluidRow(
      #   picker_input(
      #     inputId = ns("species_name"),
      #     label = "Species",
      #     choices = unique(otn_filter_cols$resolved_species_name),
      #     selected = unique(otn_filter_cols$resolved_species_name),
      #     multiple = TRUE, width = 12, search = TRUE
      #   )
      #   )
    )
  )
}

#' otn Server Functions
#'
#' @noRd
mod_otn_explore_server <- function(id, otn_selected) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(input$kingdom_name, ignoreInit = TRUE, {
      filter_options <- otn_filter_cols |>
        dplyr::filter(resolve_kingdom_name %in% input$kingdom_name) |>
        dplyr::distinct(resolved_phylum_name) |>
        dplyr::pull(resolved_phylum_name)

      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "phylum_name",
        choices = filter_options,
        selected = filter_options
      )
    })


    observeEvent(input$phylum_name, ignoreInit = TRUE, {
      filter_options <- otn_filter_cols |>
        dplyr::filter(resolved_phylum_name %in% input$phylum_name) |>
        dplyr::distinct(resolved_family_name) |>
        dplyr::pull(resolved_family_name)

      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "family_name",
        choices = filter_options,
        selected = filter_options
      )
    })


    # observeEvent(input$family_name, ignoreInit = TRUE, {

    #     filter_options <- otn_filter_cols |>
    #     dplyr::filter(resolved_family_name %in% input$family_name) |>
    #     dplyr::distinct(resolved_genus_name, resolved_species_name)

    #     shinyWidgets::updatePickerInput(
    #       session = session,
    #       inputId = "genus_name",
    #       choices = unique(filter_options$resolved_genus_name),
    #       selected = unique(filter_options$resolved_genus_name)
    #     )
    #     shinyWidgets::updatePickerInput(
    #       session = session,
    #       inputId = "species_name",
    #       choices = unique(filter_options$resolved_species_name),
    #       selected = unique(filter_options$resolved_species_name)
    #     )


    #   })
  })
}
