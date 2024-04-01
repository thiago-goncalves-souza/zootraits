# file sent by Thiago
# From: https://github.com/animaltraits/animaltraits.github.io/tree/main

# Original file: https://zenodo.org/record/6468938/files/observations.xlsx?download=1

raw_animal_traits <- readxl::read_excel("data-raw/get-traits/animal-traits/AnimalTraits.xlsx") |>
  janitor::clean_names() |>
  dplyr::rename(dataset_url = url)

# TO DO! Thiago.
prepared_gt_animal_traits <- raw_animal_traits |>
  dplyr::mutate(trait = "",
                external_url = "")

usethis::use_data(prepared_gt_animal_traits, overwrite = TRUE)



