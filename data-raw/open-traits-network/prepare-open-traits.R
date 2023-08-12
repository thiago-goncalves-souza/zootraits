# download data from
# https://github.com/open-traits-network/otn-taxon-trait-summary/blob/main/traits.csv.gz

otn_raw <- readr::read_csv("data-raw/open-traits-network/traits.csv")

# there are 23 datasets!
otn_raw |>
  dplyr::distinct(datasetId)



naniar::gg_miss_var(otn_raw, show_pct = TRUE)


otn_selected <- otn_raw |>
  dplyr::select(
    -curator, -resolvedTaxonName, -resolvedTaxonId,
    -parentTaxonId, -counts, -bucketName, -bucketId, -comment,
    -resolvedCommonNames, -phylum, -taxonIdVerbatim, -traitIdVerbatim,
    -family, -resolvedExternalId, -relationName, -resolvedPath, -resolvedPathIds,
    -resolvedPathNames
  ) |>
  dplyr::distinct() |>
  janitor::clean_names()

nrow(otn_selected)
names(otn_selected)

con_db <- connect_db()


RSQLite::dbWriteTable(con_db, "otn_selected", otn_selected, overwrite = TRUE)

RSQLite::dbDisconnect(con_db)



# distinct filter columns

otn_filter_cols <- otn_selected |>
  dplyr::distinct(
    resolve_kingdom_name,
    resolved_phylum_name, resolved_family_name, resolved_name
  ) |>
  tidyr::separate(
    col = resolved_name,
    into = c("resolved_genus_name", "resolved_species_name"),
    sep = " ", extra = "merge", fill = "right",
    remove = FALSE
  )

usethis::use_data(otn_filter_cols, overwrite = TRUE)
