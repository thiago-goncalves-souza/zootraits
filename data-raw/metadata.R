devtools::load_all(".")

metadata_var <- function(var){

  dataset <- review_data |>
    dplyr::pull({{var}})

  name_var <- var

  class_var <- class(dataset)

    options <- dataset |>
      unique() |>
      sort()


  if(length(options) < 500){
    options_var <-  options |>
      paste0(collapse = ", ")
  } else {
    options_var <-  ""
  }

  tibble::tibble(
    name_var, class_var, options_var
  )
}


variables <- review_data |>
  names()

metadata_raw <- purrr::map(variables, metadata_var) |>
  purrr::list_rbind() |>
  dplyr::filter(name_var != "doi_html") |>
  dplyr::mutate(description = "")

metadata_raw |>
  writexl::write_xlsx("data-raw/metadata-raw.xlsx")

# variables

# type of variable

# categories: what are the options?

# description
