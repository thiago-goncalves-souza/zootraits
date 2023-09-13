devtools::load_all(".")

metadata_var <- function(var) {
  dataset <- complete_review_data |>
    dplyr::pull({{ var }})

  name_var <- var

  class_var <- class(dataset)

  options <- dataset |>
    unique() |>
    sort()


  if (length(options) < 10) {
    options_var <- options |>
      paste0(collapse = ", ")
  } else if (var == "reference") {
    options_var <- options[1:3] |>
      paste0(collapse = "; ") |>
      paste0(", ...")
  } else if (var == "doi") {
    options_var <- options[4] |>
      paste0(", ...")
  } else if (var == "trait_details") {
    options_var <- options[2] |>
      stringr::str_replace_all(";", ", ") |>
      paste0(", ...")
  } else {
    options_var <- options[1:10] |>
      paste0(collapse = ", ") |>
      paste0(", ...")
  }

  tibble::tibble(
    name_var, class_var, options_var
  )
}


variables <- complete_review_data |>
  names()

metadata_raw <- purrr::map(variables, metadata_var) |>
  purrr::list_rbind() |>
  dplyr::filter(name_var != "doi_html") |>
  dplyr::mutate(description = dplyr::case_match(
    name_var,
    "code" ~ "ID Code",
    "reference" ~ "Author, year and journal",
    "year" ~ "Year of publication",
    "doi" ~ "Paper's DOI",
    # ----
    "taxonomic_unit" ~ "Taxonomic unit of trait identification, i.e.,
    the trait information was attributed to species, genus or family level,
    or you set trait information using multiple levels).",
    "taxonomic_group" ~ "More inclusive taxonomic group used
    (Arachnida, Araneae, Mammalia, etc...), you can refer to <a href='https://doi.org/10.1371/journal.pone.0119248' target='_blank'>Ruggiero et al.
    (2015)</a>.",
    "where" ~ "In which country/ocean/continent the study was conducted",
    "ecosystem" ~ "What is the predominant ecosystem in which the study was conducted",
    "trait_type" ~ "Trait type used: <br>

- <b>Effect trait</b>: traits that cause variation in different aspects of
ecosystem functioning <br>

- <b>Response trait</b>: traits that respond to environmental changes <br>

- <b>Response and effect trait</b>: traits that respond to environmental
changes and also impact ecosystem funtioning <br>

- <b>Undefinied</b>: generic description of species traits with no assumption
that this is important in terms of response to or impacts on ecosystems <br>
",
    "intraspecific_data" ~ "Intrapecific variability was included?",
    "study_scale" ~ "Spatial scale of the study: <br>
 - <b>Local</b> - few meters to few kilometers (same site, e.g., city, national park, etc) <br>
 - <b>Regional</b> - several locations in one or multiples landscapes in the same region <br>
 - <b>Global</b> - at least three continents and two hemisphere",
    # ---
    "trait_dimension" ~ "Trait dimension classified in the review: <br>
- <b>Trophic:</b> Feeding guilds; Physiological; behavioral <br>
- <b>Life history:</b> 	Life history strategies  <br>
- <b>Habitat:</b>	Response to abiotic gradients; spatial, temporal or structural <br>
- <b>Defense:</b>	Avoidance/resistance strategies <br>
- <b>Metabolic:</b>	Metabolic rate strategies/Energy allocation  <br>
- <b>Undetermined morphological traits:</b> When authors used morphological traits without explicitly linking them to a specific trait dimension.",
    "trait_details" ~ "Detailed trait name given by the original author",
    .default = ""
  ))


usethis::use_data(metadata_raw, overwrite = TRUE)
