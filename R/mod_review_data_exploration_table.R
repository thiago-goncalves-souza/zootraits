#' data_exploration UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_review_data_exploration_table_ui <- function(id) {
  ns <- NS(id)

  tagList(
    mod_review_filter_ui(ns("review_filter_1")),
    fluidRow(
      bs4Dash::box(
        title = "Dataset download",
        collapsible = TRUE,
        width = 12,
        mod_download_table_ui(ns("download_table_1")),
        reactable::reactableOutput(ns("table")) |> waiting()
      ),
    )
  )
}

#' data_exploration Server Functions
#'
#' @noRd
mod_review_data_exploration_table_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    review_dataset <- mod_review_filter_server("review_filter_1")

    mod_download_table_server("download_table_1", review_dataset())

    output$table <- reactable::renderReactable({
      prepared_data <- review_dataset() |>
        dplyr::mutate(details = '<center><i class="fa-solid fa-magnifying-glass-plus"></i></center>') |>
        dplyr::arrange(desc(year)) |>
        dplyr::group_by(code) |>
        dplyr::reframe(
          code = code,
          year = year,
          reference = reference,
          doi_html = doi_html,
          where = where,
          taxon = prepare_wide_col(taxon),
          study_scale = prepare_wide_col(study_scale),
          ecosystem = prepare_wide_col(ecosystem),
          trait_type = prepare_wide_col(trait_type),
          trait_dimension = prepare_wide_col(trait_dimension),
        ) |>
        dplyr::distinct() |>
        dplyr::ungroup()

      prepared_data |>
        dplyr::select(-code) |>
        reactable::reactable(
          sortable = TRUE,
          columns =
            list(
              year = reactable::colDef(name = "Year", maxWidth = 50),
              reference = reactable::colDef(name = "Reference", minWidth = 200),
              doi_html = reactable::colDef(name = "DOI", html = TRUE),
              where = reactable::colDef(name = "Where", html = TRUE),
              taxon = reactable::colDef(name = "Taxon"),
              study_scale = reactable::colDef(name = "Study Scale"),
              ecosystem = reactable::colDef(name = "Ecosystem"),
              trait_dimension = reactable::colDef(name = "Trait Dimensions"),
              trait_type = reactable::colDef(name = "Trait type")
            )
        )
    })
  })
}
