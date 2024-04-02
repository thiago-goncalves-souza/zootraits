devtools::load_all()

gt_filter_cols <- prepared_gt_otn |>
  dplyr::bind_rows(prepared_gt_animal_traits) |>
  dplyr::distinct(dataset, phylum,
                  class,
                  order) |>
  dplyr::arrange(phylum,
                 class,
                 order) |>
  dplyr::mutate(
    class = dplyr::na_if(class, "NA"),
    order = dplyr::na_if(order, "NA")
  )

usethis::use_data(gt_filter_cols, overwrite = TRUE)
