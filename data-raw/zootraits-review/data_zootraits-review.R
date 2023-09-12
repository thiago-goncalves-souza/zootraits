devtools::load_all()
# Read raw data --------
review_data_raw <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_review_data_may23.xlsx") |>
  janitor::clean_names() |>
  dplyr::mutate(
    code = as.character(code)
  )

taxon_names <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_taxon_names_may23.xlsx") |>
  janitor::clean_names()

trait_information <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_trait_information_may23.xlsx") |>
  janitor::clean_names()


correct_DOI <- readxl::read_xlsx("data-raw/zootraits-review/doi_check-july23.xlsx") |>
  janitor::clean_names() |>
  dplyr::select(code, new_doi) |>
  dplyr::mutate(new_doi = dplyr::na_if(new_doi, "no doi")) |>
  dplyr::mutate(
    code = as.character(code)
  )

# Number of distinct papers reviewed!

review_data_raw |>
  dplyr::distinct(code, reference) |>
  nrow()

# Clean data ----
# We need to have the same number of lines for review_data_raw and
# review_data
review_data <- review_data_raw |>
  dplyr::select(-tidyselect::any_of(c("conclusion_ok", "conclusion_wrong"))) |>
  dplyr::rename("undetermined_morphological_traits" = "body_size_undetermined") |>
  dplyr::rename(taxonomic_unit = taxunit) |>
  dplyr::left_join(correct_DOI, by = dplyr::join_by(code)) |>
  dplyr::mutate(
    doi = dplyr::coalesce(new_doi, doi),
    doi = fix_doi(doi),
    doi_html = create_doi_html(doi)
  ) |>
  dplyr::select(-new_doi) |>
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
      "undetermined_morphological_traits",
      "other"
    ),
    names_to = "trait_dimension",
    values_to = "trait_dimension_value"
  ) |>
  dplyr::mutate(trait_dimension = dplyr::if_else(
    trait_dimension == "other", "undetermined_trait", trait_dimension
  )) |>
  dplyr::filter(trait_dimension_value == 1) |>
  dplyr::select(-trait_dimension_value) |>
  dplyr::left_join(taxon_names, by = "taxon") |>
  dplyr::rename("taxonomic_group" = higher_taxon_lev1) |>
  dplyr::relocate(taxonomic_group, .after = taxon) |>
  dplyr::relocate(ecosystem, study_scale, .before = where) |>
  dplyr::relocate(doi_html, .after = doi) |>
  dplyr::relocate(year, .after = code) |>
  dplyr::select(-tidyselect::any_of(c("higher_taxon_lev2", "taxon", "taxon_span"))) |>
  dplyr::mutate(trait_type = dplyr::if_else(
    trait_type == "both" |  trait_type == "both", "response and effect", trait_type
  ))

# Use data --------
usethis::use_data(review_data, overwrite = TRUE)
usethis::use_data(taxon_names, overwrite = TRUE)
usethis::use_data(trait_information, overwrite = TRUE)
