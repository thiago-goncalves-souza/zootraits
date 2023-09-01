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
mod_otn_explore_ui <- function(id) {
  ns <- NS(id)

  tagList(
    bs4Dash::box(
      title = "Filter",
      collapsible = FALSE,
      width = 12,
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
      ),
      fluidRow(
        shiny::actionButton(inputId = ns("search"), label = "Search")
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
    ),
    fluidRow(
      bs4Dash::box(
        title = "Dataset download",
        collapsible = TRUE,
        width = 12,
        mod_download_table_ui(ns("download_table_1")),
        br(),
        reactable::reactableOutput(ns("table")) |> waiting()
      )
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

    otn_filtered <- reactive({
      input$search
      isolate({
        req(input$phylum_name)
        req(input$family_name)
        filter_phylum <- input$phylum_name
        filter_family <- input$family_name

        otn_selected |>
          dplyr::filter(
            resolved_phylum_name %in% filter_phylum,
            resolved_family_name %in% filter_family
          ) |>
          dplyr::collect()
      })
    })

    mod_download_table_server("download_table_1", otn_filtered(), prefix = "Zootraits_OTN")

    output$table <- reactable::renderReactable({
      prepared_data <- otn_filtered() |>
        dplyr::arrange(
          resolved_phylum_name,
          resolved_family_name,
          resolved_genus_name,
          resolved_species_name,
          resolved_trait_name
        ) |>
        dplyr::distinct() |>
        dplyr::mutate(
          url_html = glue::glue("<a href='{resolved_external_url}' target='_blank'>{resolved_external_url}</a>"),
          resolved_species_name = tidyr::replace_na(resolved_species_name, ""),
          resolved_genus_name = paste0("<i>", resolved_genus_name, "</i>"),
          resolved_species_name = paste0("<i>", resolved_species_name, "</i>")
        ) |>
        dplyr::select(
          resolved_phylum_name,
          resolved_family_name,
          resolved_genus_name,
          resolved_species_name,
          resolved_trait_name,
          url_html
        )



      prepared_data |>
        reactable::reactable(
          sortable = TRUE,
          searchable = TRUE,
          columns =
            list(
              resolved_phylum_name = reactable::colDef(name = "Phylum"),
              resolved_family_name = reactable::colDef(name = "Family"),
              resolved_genus_name = reactable::colDef(name = "Genus", html = TRUE),
              resolved_species_name = reactable::colDef(name = "Species", html = TRUE),
              resolved_trait_name = reactable::colDef(name = "Trait"),
              url_html = reactable::colDef(name = "URL", html = TRUE)
            )
        )
    })
  })
}
