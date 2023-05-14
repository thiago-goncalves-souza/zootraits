test_missing <- function(dataset, col){

  missing <-  dataset |>
    dplyr::filter(.data[[col]] == "NA" | is.na(.data[[col]])) |>
    dplyr::select(code, reference, doi, .data[[col]])

  if(nrow(missing) > 0){
    print(htmltools::h2(paste0("Missing information: `", col, "`")))
    print(knitr::kable(missing))
  htmltools::br()
  }

}

# test_missing_wider_binary <- function(dataset, cols){
# browser()
#   missing <-  dataset |>
#     dplyr::mutate(sum_vars = sum(dplyr::select(tidyselect::any_of(cols)))) |>
#     dplyr::filter(sum_vars == "NA" | is.na(sum_vars)) |>
#     dplyr::select(code, reference, doi, .data[[cols]])
#
#   if(nrow(missing) > 0){
#     print(htmltools::h2(paste0("Missing information: `", cols, "`")))
#     print(knitr::kable(missing))
#     htmltools::br()
#   }
#
# }
