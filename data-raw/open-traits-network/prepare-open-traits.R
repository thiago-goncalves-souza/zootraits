# download data from
# https://github.com/open-traits-network/otn-taxon-trait-summary/blob/main/traits.csv.gz

otn_raw <- readr::read_csv("data-raw/open-traits-network/traits.csv")

# there are 23 datasets!
otn_raw |>
  dplyr::distinct(datasetId)



otn_raw2 <- otn_raw |>
  dplyr::select(datasetId,
                relationName,
                resolvedName,
                resolvedTraitName,
                scientificNameVerbatim,
                accessDate,
                providedTraitName, traitNameVerbatim) |>
  dplyr::sample_n(1000)


otn_raw |>
  dplyr::count(resolveKingdomName)



writexl::write_xlsx(otn_raw2, "otnraw_complete_sample1000.xlsx")



naniar::gg_miss_var(otn_raw2)
