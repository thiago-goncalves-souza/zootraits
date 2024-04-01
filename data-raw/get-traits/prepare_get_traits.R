
gt_filter_cols <- prepared_gt_otn |>
  dplyr::bind_rows(prepared_gt_at) |>
  dplyr::distinct(dataset, phylum,
                  class,
                  order) |>
  dplyr::arrange(dataset, phylum,
                 class,
                 order)

usethis::use_data(gt_filter_cols, overwrite = TRUE)
