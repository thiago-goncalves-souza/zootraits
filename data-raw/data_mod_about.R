
# AUTHORS ----------
authors_raw <- readr::read_csv("data-raw/authors-raw.csv")

institutions_raw <- readr::read_csv2("data-raw/institutions-raw.csv") |>
  dplyr::mutate(institutions_id = as.character(institutions_id))

authors_list <- authors_raw |>
  tidyr::separate_longer_delim(institutions_id, delim = ";") |>
  dplyr::left_join(institutions_raw)

usethis::use_data(authors_list, overwrite = TRUE)


# INSTITUTIONS ------
institutions <- readr::read_csv2("data-raw/institutions-raw.csv")

usethis::use_data(institutions, overwrite = TRUE)
