test_missing <- function(dataset, col){
  missing <-  dataset |>
    dplyr::filter({{col}} == "NA" | is.na({{col}})) |>
    dplyr::select(code, reference, doi, {{col}})

  if(nrow(missing) > 0){
    print(paste0("Missing information:", col))
    print(knitr::kable(missing))
  }


  testthat::expect_equal(nrow(missing), 0)


}
