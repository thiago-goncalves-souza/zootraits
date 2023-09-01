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


options_input <- function(col, option_none = FALSE) {
  options_to_add <- col |>
    unique() |>
    sort() |>
    as.character() |>
    stringr::str_to_title() |>
    stringr::str_replace_all("_", " ")

  if (isTRUE(option_none)) {
    options_to_add <- c("None", options_to_add)
  }

  options_to_add
}

prepare_input_to_filter <- function(col) {
  col |> janitor::make_clean_names()
}

# utils to prepare table -------

prepare_wide_col <- function(col) {
  col |>
    unique() |>
    stringr::str_replace_all("_", " ") |>
    stringr::str_to_sentence() |>
    knitr::combine_words()
}
