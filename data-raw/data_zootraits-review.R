# Read raw data --------
review_data_raw <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_review_data_may23.xlsx") |> janitor::clean_names()

taxon_names <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_taxon_names_may23.xlsx") |> janitor::clean_names()

trait_information <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_trait_information_may23.xlsx") |> janitor::clean_names()


# Clean data ----
review_data <- review_data_raw |>
  dplyr::mutate(doi_html = glue::glue("<a href=' https://doi.org/{doi}' target='_blank'>{doi}</a>"))


# Use data --------
usethis::use_data(review_data, overwrite = TRUE)
usethis::use_data(taxon_names, overwrite = TRUE)
usethis::use_data(trait_information, overwrite = TRUE)
