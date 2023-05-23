# Read raw data --------
review_data_raw <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_review_data_may23.xlsx") |> janitor::clean_names()

taxon_names <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_taxon_names_may23.xlsx") |> janitor::clean_names()

trait_information <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_trait_information_may23.xlsx") |> janitor::clean_names()

# Number of distinct papers reviewed!

review_data_raw |>
  dplyr::distinct(code, reference) |>
  nrow()

# Clean data ----
# We need to have the same number of lines for review_data_raw and
# review_data
review_data <- review_data_raw |>
  dplyr::select(-tidyselect::any_of(c("conclusion_ok", "conclusion_wrong"))) |>
  dplyr::mutate(doi_html = glue::glue("<a href=' https://doi.org/{doi}' target='_blank'>{doi}</a>")) |>
  tidyr::pivot_longer(
    cols = c("freshwater", "marine", "terrestrial"),
    names_to = "ecosystem", values_to = "ecosystem_value"
  ) |>
  dplyr::filter(ecosystem_value == 1) |>
  dplyr::select(-ecosystem_value) |>
  tidyr::pivot_longer(
    cols = c("local", "regional", "global"),
    names_to = "study_scale", values_to = "study_scale_value"
  ) |>
  dplyr::filter(study_scale_value == 1) |>
  dplyr::select(-study_scale_value) |>
  dplyr::mutate(
    study_scale = forcats::fct_relevel(study_scale, c("local", "regional", "global")),
    intraspecific_data = forcats::fct_relevel(intraspecific_data, c("yes", "no"))
  ) |>
  tidyr::pivot_longer(
    cols = c(
      "trophic",
      "life_history",
      "habitat",
      "defense",
      "metabolic",
      "other"
    ),
    names_to = "trait_dimension",
    values_to = "trait_dimension_value"
  ) |>
  dplyr::filter(trait_dimension_value == 1) |>
  dplyr::select(-trait_dimension_value) |>
  dplyr::left_join(taxon_names, by = "taxon") |>
  dplyr::rename(taxon_higher_level_1 = higher_taxon_lev1,
                taxon_higher_level_2 = higher_taxon_lev2) |>
  dplyr::relocate(taxon_higher_level_1, taxon_higher_level_2, .after = taxon)
# tidyr::separate_longer_delim(cols = "where", delim = ";") |>
# dplyr::mutate(where = stringr::str_squish(where))



# Use data --------
usethis::use_data(review_data, overwrite = TRUE)
usethis::use_data(taxon_names, overwrite = TRUE)
usethis::use_data(trait_information, overwrite = TRUE)
