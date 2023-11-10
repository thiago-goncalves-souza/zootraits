## code to prepare `trait_dimension_colors` dataset goes here
devtools::load_all()

data_trait_dimension <- review_data |>
  dplyr::distinct(trait_dimension)

color <- viridis::viridis(nrow(data_trait_dimension))

trait_dimension_colors <- data_trait_dimension |>
  dplyr::mutate(color = color)

usethis::use_data(trait_dimension_colors, overwrite = TRUE)
