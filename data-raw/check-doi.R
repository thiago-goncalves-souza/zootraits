devtools::load_all()

doi_prepare_check <- review_data |>
  dplyr::distinct(code, doi) |>
  dplyr::mutate(need_fixing = dplyr::case_when(
    doi == "-" ~ TRUE,
    stringr::str_detect(doi, "\\[|\\]") ~ TRUE,
    doi == "NA" ~ TRUE,
    is.na(doi) ~ TRUE,
    TRUE ~ FALSE
  ),
  doi_url = dplyr::case_when(
    stringr::str_starts(doi, "http") ~ doi,
    TRUE ~ paste0("https://doi.org/", doi)
  ))

doi_prepare_check |>
  dplyr::filter(need_fixing == FALSE)


check_status <- function(url_check){
  url_check |>
    httr::GET() |>
    purrr::pluck("status_code")
}

possibly_check_status <- purrr::possibly(check_status, "ERROR")

status_doi <- doi_prepare_check |>
  dplyr::filter(need_fixing == FALSE) |>
  dplyr::mutate(status_code_doi = purrr::map_vec(doi_url, check_status))

# do it saving the results along
