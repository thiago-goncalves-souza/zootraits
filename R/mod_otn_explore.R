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
    fluidRow(
      bs4Dash::box(
        title = "GetTrait",
        collapsible = FALSE,
        width = 12,
        shiny::tags$p(
          htmltools::includeMarkdown(app_sys("app/www/md/otn.md"))
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
            inputId = ns("phylum_name"),
            label = "Phylum",
            choices = unique(otn_filter_cols$resolved_phylum_name),
            selected = NULL,
            multiple = TRUE,
            search = TRUE,
            width = 12
          ),
        ),
        fluidRow(
          picker_input(
            inputId = ns("class_name"),
            label = "Class",
            choices = unique(otn_filter_cols$class),
            selected = NULL,
            multiple = TRUE,
            search = TRUE,
            width = 12
          ),
        ),
        fluidRow(
          picker_input(
            inputId = ns("order_name"),
            label = "Order",
            choices = unique(otn_filter_cols$order),
            selected = NULL,
            multiple = TRUE,
            search = TRUE,
            width = 12
          ),
        ),
        fluidRow(
          shiny::actionButton(inputId = ns("search"), label = "Search")
        )
      )
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

    observeEvent(input$phylum_name, ignoreInit = TRUE, {
      filter_options <- otn_filter_cols |>
        dplyr::filter(resolved_phylum_name %in% input$phylum_name) |>
        dplyr::distinct(class) |>
        dplyr::pull(class)

      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "class_name",
        choices = filter_options,
        selected = filter_options
      )
    })


    observeEvent(input$class_name, ignoreInit = TRUE, {
      filter_options <- otn_filter_cols |>
        dplyr::filter(class %in% input$class_name) |>
        dplyr::distinct(order) |>
        dplyr::pull(order)

      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "order_name",
        choices = filter_options,
        selected = filter_options
      )
    })


    otn_filtered <- reactive({
      input$search
      isolate({
        filter_phylum <-
          prepare_input_to_filter_null(
            input_filter = input$phylum_name,
            col_name = "resolved_phylum_name",
            dataset = otn_filter_cols
          )


        filter_class <-
          prepare_input_to_filter_null(input_filter = input$class,
                                       col_name = "class",
                                       dataset = otn_filter_cols)

        filter_order <-
          prepare_input_to_filter_null(input_filter = input$order,
                                       col_name = "order",
                                       dataset = otn_filter_cols)

        otn_selected |>
          dplyr::filter(
            resolved_phylum_name %in% filter_phylum,
            class %in% filter_class,
            order %in% filter_order
          )
      })
    })

    mod_download_table_server("download_table_1", otn_filtered(), prefix = "Zootraits_OTN")

    output$table <- reactable::renderReactable({
      prepared_data <- otn_filtered() |>
        dplyr::arrange(
          dataset_id,
          resolved_phylum_name,
          class,
          order,
          resolved_genus_name,
          resolved_species_name,
          resolved_trait_name
        ) |>
        dplyr::distinct() |>
        dplyr::mutate(
          dataset_id_short = stringr::str_remove(dataset_id, "https://opentraits.org/datasets/") |>
            stringr::str_to_upper(),
          dataset = glue::glue("<a href='{dataset_id}' target='_blank'>{dataset_id_short}</a>"),
          url_html = glue::glue("<a href='{resolved_external_url}' target='_blank'>{resolved_external_url}</a>"),
          resolved_species_name = tidyr::replace_na(resolved_species_name, ""),
          resolved_genus_name = paste0("<i>", resolved_genus_name, "</i>"),
          resolved_species_name = paste0("<i>", resolved_species_name, "</i>")
        ) |>
        dplyr::select(
          dataset,
          resolved_phylum_name,
          class,
          order,
          resolved_genus_name,
          resolved_species_name,
          resolved_trait_name,
          url_html
        )



      prepared_data |>
        reactable::reactable(
          sortable = TRUE,
          showSortable = TRUE,
          searchable = FALSE,
          columns =
            list(
              resolved_phylum_name = reactable::colDef(name = "Phylum"),
              class = reactable::colDef(name = "Class"),
              order = reactable::colDef(name = "Order"),
              resolved_genus_name = reactable::colDef(name = "Genus", html = TRUE),
              resolved_species_name = reactable::colDef(name = "Species", html = TRUE),
              resolved_trait_name = reactable::colDef(name = "Trait"),
              url_html = reactable::colDef(name = "URL", html = TRUE),
              dataset = reactable::colDef(name = "Dataset", html = TRUE)
            )
        )
    })
  })
}
