## code to prepare `trait_dimension_colors` dataset goes here
devtools::load_all()

data_trait_dimension <- review_data |>
  dplyr::distinct(trait_dimension) |>
  tibble::add_row(trait_dimension = "body_size")

color <- viridis::viridis(nrow(data_trait_dimension), begin = 0.1, end = 0.9)

trait_dimension_colors <- data_trait_dimension |>
  dplyr::mutate(color = color)

usethis::use_data(trait_dimension_colors, overwrite = TRUE)
