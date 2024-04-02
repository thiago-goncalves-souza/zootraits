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
mod_get_trait_ui <- function(id) {
  ns <- NS(id)

  tagList(
    fluidRow(
      bs4Dash::box(
        title = "GetTrait",
        collapsible = FALSE,
        width = 12,
        shiny::tags$p(
          htmltools::includeMarkdown(app_sys("app/www/md/get-traits.md"))
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
            inputId = ns("dataset_name"),
            label = "Dataset",
            choices = list("AnimalTraits" =  "AnimalTraits",
                        "Open Traits Network (OTN)" = "otn"),
            selected = list("AnimalTraits" = "AnimalTraits"),
            multiple = FALSE,
            search = TRUE,
            width = 12
          ),
        ),
        fluidRow(
          picker_input(
            inputId = ns("phylum_name"),
            label = "Phylum",
            choices = NULL,
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
            choices = NULL,
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
            choices = NULL,
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
mod_get_trait_server <- function(id, prepared_gt_otn) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(input$dataset_name, ignoreInit = FALSE, {
      filter_options <- gt_filter_cols |>
        dplyr::filter(dataset == input$dataset_name) |>
        dplyr::distinct(phylum) |>
        dplyr::arrange(phylum) |>
        dplyr::pull(phylum)

      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "phylum_name",
        choices = filter_options,
        selected = NULL
      )
    })

    observeEvent(input$phylum_name, ignoreInit = TRUE, {
      filter_options <- gt_filter_cols |>
        dplyr::filter(dataset == input$dataset_name) |>
        dplyr::filter(phylum %in% input$phylum_name) |>
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
      filter_options <- gt_filter_cols |>
        dplyr::filter(dataset == input$dataset_name) |>
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


    dataset_filtered <- reactive({
      input$search
      isolate({
        filter_phylum <-
          prepare_input_to_filter_null(
            input_filter = input$phylum_name,
            col_name = "phylum",
            dataset = gt_filter_cols
          )


        filter_class <-
          prepare_input_to_filter_null(input_filter = input$class,
                                       col_name = "class",
                                       dataset = gt_filter_cols)

        filter_order <-
          prepare_input_to_filter_null(input_filter = input$order,
                                       col_name = "order",
                                       dataset = gt_filter_cols)

        if(input$dataset_name == "otn"){
          dados <- prepared_gt_otn
        } else if(input$dataset_name == "AnimalTraits"){
          dados <- prepared_gt_animal_traits
        }

        dados |>
          dplyr::filter(
            phylum %in% filter_phylum,
            class %in% filter_class,
            order %in% filter_order
          )
      })
    })

    mod_download_table_server("download_table_1", dataset_filtered(), prefix = "Zootraits_GetTrait_")

    output$table <- reactable::renderReactable({
      prepared_data <- dataset_filtered() |>
        dplyr::arrange(
          dataset_url,
          phylum,
          class,
          order,
          genus,
          species,
          trait
        ) |>
        dplyr::distinct() |>
        dplyr::mutate(
          dataset_url_short = dplyr::case_when(
            dataset == "AnimalTraits" ~ "Animal Traits",
            TRUE ~ stringr::str_remove(dataset_url, "https://opentraits.org/datasets/") |>
            stringr::str_to_upper()),
          dataset = glue::glue("<a href='{dataset_url}' target='_blank'>{dataset_url_short}</a>"),
          url_html = glue::glue("<a href='{external_url}' target='_blank'><button type='button' class='btn btn-link'>Click here</button></a>"),
          species = tidyr::replace_na(species, ""),
          genus = paste0("<i>", genus, "</i>"),
          species = paste0("<i>", species, "</i>")
        ) |>
        dplyr::select(
          dataset,
          phylum,
          class,
          order,
          genus,
          species,
          trait,
          url_html
        )



      prepared_data |>
        reactable::reactable(
          sortable = TRUE,
          showSortable = TRUE,
          searchable = FALSE,
          columns =
            list(
              phylum = reactable::colDef(name = "Phylum"),
              class = reactable::colDef(name = "Class"),
              order = reactable::colDef(name = "Order"),
              genus = reactable::colDef(name = "Genus", html = TRUE),
              species = reactable::colDef(name = "Species", html = TRUE),
              trait = reactable::colDef(name = "Trait"),
              url_html = reactable::colDef(name = "Read more", html = TRUE),
              dataset = reactable::colDef(name = "Dataset", html = TRUE)
            )
        )
    })
  })
}
