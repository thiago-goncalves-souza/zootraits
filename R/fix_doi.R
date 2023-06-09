fix_doi <- function(doi_url) {
  doi_url <- stringr::str_remove_all(doi_url, "^\\[")

  dplyr::case_when(
    doi_url == "-" ~ NA_character_,
    doi_url == "NA" ~ NA_character_,
    stringr::str_starts(doi_url, "doi: ") ~ paste0("https://doi.org/", stringr::str_remove(doi_url, "^doi: ")),
    stringr::str_starts(doi_url, "doi.org/") ~ paste0("https://", doi_url),
    stringr::str_starts(doi_url, "dx.doi.org/") ~ paste0("https://", doi_url),
    stringr::str_starts(doi_url, "hdl.handle.net/") ~ paste0("https://", doi_url),
    stringr::str_starts(doi_url, "zoolstud.sinica.edu.tw/") ~ paste0("https://", doi_url),
    !stringr::str_starts(doi_url, "https://doi.org/") ~ paste0("https://doi.org/", doi_url),
    TRUE ~ doi_url
  ) |>
    stringr::str_remove_all("\\.$") |>
    stringr::str_remove_all("\\]$") |>
    stringr::str_remove_all(" ")
}
