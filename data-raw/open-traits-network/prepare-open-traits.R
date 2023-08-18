# download data from
# https://github.com/open-traits-network/otn-taxon-trait-summary/blob/main/traits.csv.gz

otn_raw <- readr::read_csv("data-raw/open-traits-network/traits.csv")

# there are 23 datasets!
otn_raw |>
  dplyr::distinct(datasetId)

# explore how many observations we have per kingdom
otn_raw |>
  dplyr::count(resolveKingdomName)

# explore the missing values
naniar::gg_miss_var(otn_raw, show_pct = TRUE)

# export the missing values in Kingdom
otn_raw |>
dplyr::filter(is.na(resolveKingdomName)) |>
dplyr::count(resolvedPhylumName, resolvedTaxonName, resolvedFamilyName,resolvedName,sort = TRUE) |>
dplyr::slice_head(n = 1000) |>
writexl::write_xlsx("data-raw/open-traits-network/missing-kingdom.xlsx")



otn_selected <- otn_raw |>
# filter only the animal kingdom
dplyr::filter(resolveKingdomName == "Animalia") |>
# remove columns that are not needed
  dplyr::select(
    -curator, -resolvedTaxonName, -resolvedTaxonId,
    -parentTaxonId, -counts, -bucketName, -bucketId, -comment,
    -resolvedCommonNames, -phylum, -taxonIdVerbatim, -traitIdVerbatim,
    -family, -resolvedExternalId, -relationName, -resolvedPath, -resolvedPathIds,
    -resolvedPathNames, -numberOfRecords, -accessDate, - traitNameVerbatim,
    -resolveKingdomName, -providedTraitName, -datasetId, -scientificNameVerbatim
  ) |>
  dplyr::distinct() |>
  janitor::clean_names()

dplyr::glimpse(otn_selected)

nrow(otn_selected)
names(otn_selected)

usethis::use_data(otn_selected, overwrite = TRUE)


# con_db <- connect_db()

# RSQLite::dbListTables(con_db)

# # RSQLite::dbRemoveTable(con_db, "otn_selected")

# RSQLite::dbWriteTable(con_db, "otn_selected", otn_selected, overwrite = TRUE)

# RSQLite::dbDisconnect(con_db)

# distinct filter columns

otn_filter_cols <- otn_selected |>
  dplyr::distinct(
    resolved_phylum_name, resolved_family_name, resolved_name
  ) |>
  tidyr::separate(
    col = resolved_name,
    into = c("resolved_genus_name", "resolved_species_name"),
    sep = " ", extra = "merge", fill = "right",
    remove = FALSE
  ) |>
  dplyr::distinct()

usethis::use_data(otn_filter_cols, overwrite = TRUE)
