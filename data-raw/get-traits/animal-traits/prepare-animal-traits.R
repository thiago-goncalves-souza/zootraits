options(scipen = 999)
# file by Animal Traits
# From: https://github.com/animaltraits/animaltraits.github.io/tree/main

# Original file: https://zenodo.org/record/6468938/files/observations.xlsx?download=1

raw_animal_traits <-
  readxl::read_excel(
    "data-raw/get-traits/animal-traits/observations-animal-traits-original-data_2024-04-02.xlsx"
  ) |>
  janitor::clean_names()



prepared_gt_animal_traits <- raw_animal_traits |>
  dplyr::select(
    -tidyselect::contains("_comment"),-tidyselect::contains("_method"),-tidyselect::contains("_units")
  ) |>
  dplyr::select(-c(sample_size_value, original_temperature)) |>
  dplyr::mutate(dplyr::across(.fns = as.character, .cols = tidyselect::everything())) |>
  tidyr::pivot_longer(
    cols = -c(
      phylum,
      class,
      order,
      family,
      genus,
      species,
      specific_epithet,
      sex,
      in_text_reference,
      publication_year,
      full_reference
    ),
    names_to = "trait",
    values_to = "trait_value"
  ) |>
  tidyr::drop_na(trait_value) |>
  dplyr::mutate(
    dataset = "AnimalTraits",
    dataset_url = "https://animaltraits.org/",
    .before = tidyselect::everything()
  ) |>
  dplyr::mutate(
    doi = dplyr::case_when(
      stringr::str_detect(full_reference, "doi:") ~ stringr::str_extract(full_reference, "doi:.*") |>
        stringr::str_remove_all("doi:")
    ),
    doi_complete = paste0("https://doi.org/", doi),
    external_url = dplyr::case_when(
      !is.na(doi) ~ doi_complete,
      TRUE ~ paste0("https://www.google.com/search?q=", full_reference) |>
        stringr::str_replace_all("&", "e")
    )
  ) |>
  dplyr::select(-doi, -doi_complete)

# Eventually would be good to check all these DOI and see if there is any info
# that we need to fix
# prepared_gt_animal_traits |>
#   dplyr::distinct(external_url) |>
#   dplyr::slice_sample(n = 1)

usethis::use_data(prepared_gt_animal_traits, overwrite = TRUE)

