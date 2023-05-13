review_data <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_review_data_may23.xlsx") |> janitor::clean_names()

taxon_names <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_taxon_names_may23.xlsx") |> janitor::clean_names()

trait_information <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_trait_information_may23.xlsx") |> janitor::clean_names()



usethis::use_data(review_data, overwrite = TRUE)
usethis::use_data(taxon_names, overwrite = TRUE)
usethis::use_data(trait_information, overwrite = TRUE)
