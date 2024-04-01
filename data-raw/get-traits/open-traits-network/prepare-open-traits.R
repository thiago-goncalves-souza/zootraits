# download data from
# https://github.com/open-traits-network/otn-taxon-trait-summary/blob/main/traits.csv.gz
otn_raw <-
  readr::read_csv("data-raw/get-traits/open-traits-network/traits.csv")

# This file was created by Thiago:
ranked_taxon <-
  readxl::read_xlsx("data-raw/get-traits/open-traits-network/ranked_taxon.xlsx") |>
  janitor::clean_names() |>
  dplyr::select(phylum, class, order, family) |>
  dplyr::distinct()


otn_filtered <- otn_raw |>
  # filter only the animal kingdom
  dplyr::filter(resolveKingdomName == "Animalia") |>
  # remove columns that are not needed
  dplyr::select(
    -curator,
    -resolvedTaxonName,
    -resolvedTaxonId,-parentTaxonId,
    -counts,
    -bucketName,
    -bucketId,
    -comment,-resolvedCommonNames,
    -phylum,
    -taxonIdVerbatim,
    -traitIdVerbatim,-family,
    -resolvedExternalId,
    -relationName,
    -resolvedPath,
    -resolvedPathIds,-resolvedPathNames,
    -numberOfRecords,
    -accessDate,
    -traitNameVerbatim,-resolveKingdomName,
    -providedTraitName,
    -scientificNameVerbatim
  ) |>
  dplyr::distinct() |>
  janitor::clean_names() |>
  tidyr::separate(
    col = resolved_name,
    into = c("resolved_genus_name", "resolved_species_name"),
    sep = " ",
    extra = "merge",
    fill = "right",
    remove = FALSE
  )

prepared_gt_otn <- otn_filtered |>
  dplyr::left_join(
    ranked_taxon,
    by = c(
      "resolved_phylum_name" = "phylum",
      "resolved_family_name" = "family"
    )
  )

usethis::use_data(prepared_gt_otn, overwrite = TRUE)

otn_filter_cols <- prepared_gt_otn |>
  dplyr::distinct(resolved_phylum_name,
                  class,
                  order) |>
  dplyr::arrange(resolved_phylum_name,
                 class,
                 order)

usethis::use_data(otn_filter_cols, overwrite = TRUE)
