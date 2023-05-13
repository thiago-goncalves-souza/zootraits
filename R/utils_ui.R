picker_input <- function(...) {
  column(
    width = 4,
    shinyWidgets::pickerInput(
      options = list(`actions-box` = TRUE),
      multiple = TRUE,
      ...
    )
  )
}


options_input <- function(col) {
  col |>
    unique() |>
    sort() |>
    as.character() |>
    stringr::str_to_title() |>
    stringr::str_replace_all("_", " ")
}

prepare_input_to_filter <- function(col) {
  col |> janitor::make_clean_names()
}
