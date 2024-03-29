picker_input <- function(..., multiple = TRUE, search = FALSE, width = 4) {
  column(
    width = width,
    shinyWidgets::pickerInput(
      options = list(
        `actions-box` = TRUE,
        `live-search` = search,
        `live-search-normalize` = TRUE
      ),
      multiple = multiple,
      ...
    )
  )
}


options_input <- function(col, option_none = FALSE, option_other = FALSE) {
  options_to_add <- col |>
    stringr::str_split(pattern = ";") |>
    unlist() |>
    stringr::str_trim() |>
    sort() |>
    as.character() |>
    stringr::str_to_title() |>
    stringr::str_replace_all("_", " ") |>
    unique()

  if (isTRUE(option_none)) {
    options_to_add <- c("None", options_to_add) |>
      unique()
  }

  if (isTRUE(option_other)) {
    options_to_add <- c(options_to_add, "Other") |>
      unique()
  }

  options_to_add
}

prepare_input_to_filter <- function(col) {
  col |> janitor::make_clean_names()
}


prepare_input_to_filter_taxonomic_group <- function(input_filtro, col_name, dataset) {

  if(length(input_filtro) == 0){

    input_filtro <- unique(dataset[[col_name]])
  }

  unique(input_filtro)
}

# utils to prepare table -------

prepare_wide_col <- function(col) {
  col |>
    unique() |>
    stringr::str_replace_all("_", " ") |>
    stringr::str_to_sentence() |>
    knitr::combine_words()
}


create_metadata_description <- function(var, label = "") {
  description <- metadata_raw |>
    dplyr::filter(name_var == var) |>
    dplyr::pull(description) |>
    purrr::pluck(1)

  shiny::HTML(
    glue::glue(
      "{label} <br> <small>{description}</small>"
    )
  )
}

discard_none <- function(input_var) {
  if (paste0(input_var, collapse = "; ") != "None") {
    input_var |>
      purrr::discard(~ .x == "None") |>
      paste0(collapse = "; ")
  } else {
    input_var
  }
}
