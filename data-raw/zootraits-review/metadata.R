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
    "code" ~ "Code attributed after downloading from Scopus or WOS",
    "reference" ~ "Author, year and journal",
    "year" ~ "Year of publication",
    "doi" ~ "Paper's DOI",
    # ----
    "taxunit" ~ "Taxonomic unit used",
    "taxon_span" ~ "More inclusive taxonomic unit used (genus, family, order...)",
    "taxon" ~ "More inclusive taxonomic group used (Arachnida, Araneae, Mammalia, etc...)",
    "taxonomic_group" ~ "Taxonomic group used",
    "where" ~ "In which country/ocean/continent the study was conducted",
    "ecosystem" ~ "In which ecosystem the study was conducted",
    "trait_type" ~ "Trait type use",
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
- <b>Undetermined morphological traits:</b> When authors used morphological traits without explicitly linking them to a specific trait dimension. <br>
- <b>Undetermined trait:</b>	other traits that do not fit the previous dimensions or the authors didn't name the trait",
    "trait_details" ~ "Detailed trait name given by the original author",
    .default = ""
  ))


usethis::use_data(metadata_raw, overwrite = TRUE)
