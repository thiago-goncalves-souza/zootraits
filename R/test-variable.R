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


