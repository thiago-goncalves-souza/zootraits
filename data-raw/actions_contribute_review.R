usethis::ui_info("Loading packages ----------------------------------------")

devtools::load_all()

usethis::ui_info("Authenticating on Google Sheets -------------------------------------")
auth_google_sheets()

usethis::ui_info("Importing data from Google Sheets ----------------------------------------")
url_sheet <- "https://docs.google.com/spreadsheets/d/1nStfAOwUvUuVC4Xo3ArI8i1Be9TxGNdmntfn87OGSy4/edit#gid=1464062411"

papers_raw <- googlesheets4::read_sheet(url_sheet, sheet = "papers")

contributors_raw <- googlesheets4::read_sheet(url_sheet, sheet = "contributors")


usethis::ui_info("Preparing data for papers ----------------------------------------")

review_data |>
  dplyr::glimpse()

contributed_papers <- papers_raw |>
  dplyr::filter(verified == TRUE) |>
  dplyr::transmute(
    code,
    year = paper_year,
    reference = paste0(paper_author, "; ", paper_year, "; ", paper_journal),
    doi = fix_doi(paper_doi),
    doi_html = create_doi_html(doi),
    taxonomic_unit,
    taxonomic_group,
    ecosystem,
    study_scale,
    where,
    trait_type,
    intraspecific_data,
    trait_details,
    trait_details_other,
    trait_dimension
  ) |>
  dplyr::mutate(
    trait_details_other = tidyr::replace_na(trait_details_other, ""),
    trait_details = paste0(trait_details, trait_details_other, collapse = "; "),
  ) |>
  dplyr::select(-trait_details_other) |>
  tidyr::separate_longer_delim(trait_dimension, "; ") |>
  dplyr::mutate(trait_type = dplyr::if_else(
    trait_type == "both" | trait_type == "both", "response and effect", trait_type
  )) |>
  dplyr::mutate(
    dplyr::across(
      .cols = c(
        "taxonomic_unit", "ecosystem",
        "study_scale", "trait_type", "intraspecific_data",
        "trait_details", "trait_dimension"
      ),
      .fns = stringr::str_to_lower
    ),
    trait_dimension = stringr::str_replace_all(trait_dimension, " ", "_")
  ) |>
  dplyr::mutate(
    year = as.numeric(year)
  )


usethis::ui_info("Preparing data of Contributors ----------------------------------------")


emails <- papers_raw |>
  dplyr::filter(verified == TRUE) |>
  dplyr::distinct(contributor_email) |>
  dplyr::pull(contributor_email)

contributors_list <- contributors_raw |>
  dplyr::filter(contributor_email %in% emails) |>
  dplyr::distinct(contributor_email, .keep_all = TRUE)

usethis::use_data(contributors_list, overwrite = TRUE)


usethis::ui_info("Join tables - Review and Contributed Papers ----------------------------------------")
complete_review_data <- review_data |>
  dplyr::mutate(code = as.character(code)) |>
  dplyr::bind_rows(contributed_papers)

usethis::ui_info("Upload data in the app ----------------------------------------")
usethis::use_data(complete_review_data, overwrite = TRUE)
