# download data from
# https://github.com/open-traits-network/otn-taxon-trait-summary/blob/main/traits.csv.gz

otn_raw <- readr::read_csv("data-raw/open-traits-network/traits.csv")

# there are 23 datasets!
otn_raw |>
  dplyr::distinct(datasetId)




otn_selected <- otn_raw |>
  dplyr::select(
    -curator, -resolvedTaxonName, -resolvedTaxonId,
    -parentTaxonId, -counts, -bucketName, -bucketId, -comment,
    -resolvedCommonNames, -phylum, -taxonIdVerbatim
  )


otn_selected |>
  dplyr::distinct(scientificNameVerbatim)



naniar::gg_miss_var(otn_selected, show_pct = TRUE)

otn_selected |>
  dplyr::count(resolveKingdomName)


# Pensar melhor quais sao os dados para mostrar.
# A base original tem mais 3.4 milhões de linhas.
# Ficaria muito pesado para rodar no shiny!
# Se for isso mesmo, precisaremos de um backend de banco de dados.
